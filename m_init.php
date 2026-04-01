<?

class Db {
	
	var $conn;
	var $invisibleGid = '458'; // klientam nav jārdz šīs grupas (!Atteikušies)
	var $tester_profiles = array(5116,5585,95,7996,87);//Rūta, Māris, Arta, Liene, Madara
	
	
	public function __construct() {    
		//session_start();
		$_SESSION['init'] = 1;
		$serverName = "SER-DB3\mssql2008"; //serverName\instanceName
		//$connectionInfo = array( "Database"=>"globa", "UID"=>"www", "PWD"=>"www");
		$connectionInfo = array(
			"Database" => "globa",  // Database name
			"Uid" => "www",            // Database username
			"PWD" => "www",             // Database password
			"TrustServerCertificate" => "true"
		);		
		$this->conn =  sqlsrv_connect( $serverName, $connectionInfo);
		
		date_default_timezone_set('Europe/Riga');
		if (!defined('DEBUG'))define('DEBUG',"0");
	}
	
	
	
	
	function Query($query, $params = null, $log  = FALSE) {
	
		if (DEBUG){
			//echo $query."<br>";
			//var_dump($params);
			//echo "<br><br>";
		}
		$res = sqlsrv_query($this->conn, $query, $params);
	
		if( !(strpos($query, 'exec ') !== false) && $res === false ) {

			 die( print_r( sqlsrv_errors(), true));
		}		
		if ($log) {
			/*$query_type = array("insert","delete","update","replace");
			foreach ( $query_type as $word )
			{
				if ( preg_match("/^\\s*$word /i",$query) )
				{
					
					
				}
			}*/
		}
		if (DEBUG){
			//echo "query res<br>";
			//var_dump($res);
			//echo "<br><br>";
		}
		return $res;	
	}
	
	function MsEscapeString($data) {
        if ( !isset($data) or empty($data) ) return '';
        if ( is_numeric($data) ) return $data;

        $non_displayables = array(
            '/%0[0-8bcef]/',            // url encoded 00-08, 11, 12, 14, 15
            '/%1[0-9a-f]/',             // url encoded 16-31
            '/[\x00-\x08]/',            // 00-08
            '/\x0b/',                   // 11
            '/\x0c/',                   // 12
            '/[\x0e-\x1f]/'             // 14-31
        );
        foreach ( $non_displayables as $regex )
            $data = preg_replace( $regex, '', $data );
        $data = str_replace("'", "''", $data );
        return $data;
    }

	function EscapeValues($post,$values){
		$d = array();
		if (DEBUG) var_dump($values);
		$v = explode(',',$values);
		foreach($v as $vv) {
			$d[$vv] = $this->MsEscapeString($post[$vv]);
		}
		
		return $d;
	}

	function Insert($table,$values,$max_id_param = FALSE) {
		
	   $count = 0;
	   $fields = '';
	   $vals = '';

	   foreach($values as $col => $val) {
		  if ($count != 0) $fields .= ', ';
		  if ($count != 0) $vals .= ', ';
		 $fields .= " $col ";
		 //$vals .= " '$val' ";
		 // $vals .= " '$val' ";
		 $count++;
		 IF (DEBUG){
			 echo "Value:<br>";
			 var_dump($val);
			 echo "<br><br>";
		 }
		 $values_array[]= $val;

	   }

	  // $query = "INSERT INTO $table ($fields) values ($vals);";
	  // mssql_query($query);
	  for ($i=0;$i<count($values);$i++){
		   $param_array[]="?";
		   
	  }
	  $par = implode(", ",$param_array);
	  $sql = "INSERT INTO $table ($fields) VALUES ($par)";
	//  $sql .= ";/* SELECT SCOPE_IDENTITY() AS IDENTITY_COLUMN_NAME*/"; 
	  if (DEBUG) {
		  echo $sql;
			var_dump($values);
			echo "values arry:<br>";
			var_dump($values_array);
			echo "<br><br>";
	  }
	  
	  $params = $values_array;
		//var_dump($params);
	  $result = $this->Query($sql,$params);

	 
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}

		if ($max_id_param){
			$qry = "SELECT MAX(ID) AS ID FROM $table";
			$arr = array();
			$params = array();
			
			foreach ($max_id_param as $key=>$val){
				$arr[] = "$key = ?";
				$params[] = $val;
			}
			//$where = implode(" AND ",$arr);
			//$qry .= " WHERE $where";
			if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
			}
				$result = $this->Query($qry,$params);
	
			if( $result === false) {
				
				die( print_r( sqlsrv_errors(), true) );
			}
			else {
				//echo "OK";
			}

		
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				//print_r($row);
				return $row['ID'];
				
			}
			return false;
		}
		else{			
			//return $this->LastInsertId($result); 
			return $result;
		}
	}


	function LastInsertId($queryID) {

		sqlsrv_next_result($queryID);
		if(!sqlsrv_fetch($queryID)){
			die( print_r( sqlsrv_errors(), true));
		}
			if (sqlsrv_get_field($queryID, 0)==false){
				die( print_r( sqlsrv_errors(), true));
			}
			
        return sqlsrv_get_field($queryID, 0);

    } 
	
	function Update($table, $values, $id) {
	
		$query = "UPDATE $table SET ";
		$sep = '';
		$fields = '';
		foreach($values as $key=>$value) {
			//$query .= $sep.$key." = '".$value."'";
			$query .= $sep.$key." = ?";
			$sep = ',';
			$values_array[]= "$value";
			
		}
		$query .= " WHERE id = ?";
		
		
		array_push($values_array,$id);
		$params = $values_array;
		if (DEBUG){
			echo "UPDATE!!!!<br>";
			echo $query;
			var_dump($params);
			echo "LOG";
			var_dump($log);
		}
	
		
		$result = $this->Query($query,$params);
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}
		//return $result;
		//mssql_query($query);
	}
	
	//update WHERE 2
	function UpdateWhere2($table, $values, $where_arr) {
		$query = "UPDATE $table SET ";
		$sep = '';
		$fields = '';
		$params = array();
		foreach($values as $key=>$value) {
			//$query .= $sep.$key." = '".$value."'";
			$query .= $sep.$key." = ?";
			$sep = ',';
			$params[]= "$value";
		}
		$arr = array();
		foreach ($where_arr as $where){
		
			$arr[] = $where['field']." ".$where['op']." ?";
			$params[] = $where['val'];
		}
		$where_cond = implode(" AND ",$arr);
				
		$query .= " WHERE $where_cond";
		
		
		//array_push($values_array,$id);
		//$params = $values_array;
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$result = $this->Query($query,$params);
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}
		return $query;
		//return $result;
		//mssql_query($query);
	}
	function UpdateWhere($table, $values, $where_arr,$where_cond=NULL) {
	
		$query = "UPDATE $table SET ";
		$sep = '';
		$fields = '';
		$params = array();
		foreach($values as $key=>$value) {
			//$query .= $sep.$key." = '".$value."'";
			$query .= $sep.$key." = ?";
			$sep = ',';
			$params[]= "$value";
			
		}
		
		$arr = array();
		
		
		foreach ($where_arr as $key=>$val){
			$arr[] = "$key = ?";
			$params[] = $val;
		}
		$where = implode(" AND ",$arr);
		$query .= " WHERE $where";
		
		if (!empty($where_cond)){
			$query .= " AND $where_cond";
		}
		//array_push($values_array,$id);
		//$params = $values_array;
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$result = $this->Query($query,$params);
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}
		//return $result;
		//mssql_query($query);
	}
	
	
	function Date2Str($date,$separator = '.'){
		$empty_date = new DateTime('1900-01-01');
		if (!empty($date) && $date != $empty_date){
			
			$formated_date = $date->format("d".$separator."m".$separator."Y");
			return $formated_date;
		}
		return "&nbsp;";
	}
	
	function Time2Str($date){
		if (!empty($date)){
			$formated_date = $date->format("H:i:s");
			return $formated_date;
		}
		return $date;
	}
	
	function CheckDateFormat($date) {
		
		$arr  = explode('.', $date);
		//var_dump($arr);
		if (count($arr) == 3) {
			if (checkdate($arr[1], $arr[0], $arr[2]) && strlen($arr[0])==2 && strlen($arr[1])==2 && strlen($arr[2])==4) {
				// valid date ...
				return true;
			} else {
				// problem with dates ...
				return false;
			}
		} else {
			// problem with input ...
			return false;
		}
		
	} 
	
	function Str2SqlDate($string){
		//var_dump($string);
		//$formated_date = date("Y-m-d 00:00:00",strtotime($string));
		$date = new DateTime($string);
		$formated_date = $date->format('Y-m-d 00:00:00');
		return $formated_date;
	}
	

	
	

}
?>