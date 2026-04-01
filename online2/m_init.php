<?
if (!isset($dont_init_header))
	header('Content-Type: text/html; charset=Windows-1257');


if (!function_exists('_win')) {
    function _win($input)
    {
        if (!is_string($input)) {
            return $input;
        }

        return iconv('UTF-8', 'Windows-1257//IGNORE', $input);
    }
}


if (!function_exists('_utf')) {
    function _utf($input)
    {
		if (!is_string($input)) {
			return $input;
		}

		return iconv('Windows-1257', 'UTF-8//IGNORE', $input);
	}
}

if (!class_exists('Db')) {
class Db {
	
	var $conn;
	var $invisibleGid = '458'; // klientam nav jāredz šīs grupas (!Atteikušies)
	var $cancelledGid = 6066;
	var $empty_date;
	var $tester_profiles = array(5116,5585,95,7996,87,84);//R�ta, M�ris, Arta, Liene, Madara, J�nis Bite
	//var $log_filename =  "db_queries\\db_".date("Y-m").".txt";
	
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
		if (isset($_SESSION['test']))define('DEBUG',"1");
		$this->empty_date = new DateTime('1900-01-01');
		
	}
	
	public function validate_time($time, $format = 'H:i'){
		$d = DateTime::createFromFormat($format, $time);
		return $d && $d->format($format) === $time;
	}
	
	public function validate_date($date, $format = 'd.m.Y'){
		$d = DateTime::createFromFormat($format, $date);
		return $d && $d->format($format) === $date;
	}
	
	public function sql_num($num){
		if (is_numeric($num)){
			return $num;
		} else {
			return 0;
		}
	}

	
	public function sql_date($date, $format = 'd.m.Y'){
		$parts = explode('.',$date);
		// nez kapēc nestrādā datumi ar vienu ciparu dienā un mēnesī
		if (count($parts)==3){
			
			if (strlen($parts[0])==1)
				$result = '0'.$parts[0];
			else
				$result = $parts[0];
			$result = $result . '.';
			
			if (strlen($parts[1])==1)
				$result = $result.'0'.$parts[1];
			else
				$result = $result.$parts[1];
			$result = $result . '.' . $parts[2];
			$date = $result;
		}
		
		
		if ($this->validate_date($date, $format))
		{
			$d = DateTime::createFromFormat($format, $date);
			return $d->format('Y-m-d');
		}
		else
			return null;
	}
	
	function get_by_id($table,$id){
		return $this->GetId($table,$id);
	}
	
	function GetId($table,$id){
		$qry = "SELECT * FROM $table WHERE id=?";
		$params = array($id);
		$result = $this->Query($qry,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		return $row;
	}
	
	function GetValue($sql,$field){
		$result = $this->Query($sql,array());
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		return $row[$field];
	}

	function get_by_field($table,$field,$value){
		$qry = "SELECT * FROM $table WHERE $field=?";
		$params = array($value);
		$result = $this->Query($qry,$params);
		
		return $row;
	}


	function query_array($query, $params = null, $log  = FALSE) {
		$arr = array();
		$res = sqlsrv_query($this->conn, $query, $params);
		
		while ($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$arr[] = $row;
		}
		
		return $arr;
	}

	function query_array2($query, $params = null, $log  = FALSE) {
		$arr = array();
		
		
		$res = sqlsrv_query($this->conn, $query, $params);
		
		echo $query;
		
		while ($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$arr[] = $row;
		}

		return $arr;
	}

	function Query($query, $params = null, $log  = FALSE) {
	
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
			echo "<br><br>";
		}
		$res = sqlsrv_query($this->conn, $query, $params);
	
		if( !(strpos($query, 'exec ') !== false) && $res === false ) {

			 die( print_r( sqlsrv_errors(), true));
		}		
		return $res;	
	}
	
	function QueryArray($query, $params = null) {
		$res = $this->Query($query, $params);
		$result = array();
		while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
			 $result[] = $row;
		}
		return $result;
	}
	
	function MsEscapeString($data) {
        //if ( !isset($data) or empty($data) ) return '';
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

	function Insert($table,$values,$max_id_param = FALSE,$log = false) {
		
	   $count = 0;
	   $fields = '';
	   $vals = '';

	   foreach($values as $col => $val) {
		 if ($count != 0) $fields .= ', ';
		 if ($count != 0) $vals .= ', ';
		 $fields .= " $col ";
		 $count++;
		 if ($table == 'autobusi'){
			 echo "vol:$col val:$val<br>";
		 }
		 $values_array[]= $val;

	   }

	  for ($i=0;$i<count($values);$i++){
		   $param_array[]="?";
	  }
	  $par = implode(", ",$param_array);
	  $sql = "INSERT INTO $table ($fields) VALUES ($par)";

	  $params = $values_array;
	  
	  if ($log){			
			$this->LogQuery('Insert',$sql,$params);
	  }
	  
	  $result = $this->Query($sql,$params);
	  if ($log){
		  $this->LogQuery('Insert',"successful",$params);
	  }
	  
		if( $result === false ) {
			echo $qry;
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
			
			$result = $this->Query($qry);
			if ($log){			
				$this->LogQuery('Insert->get max ID ',"successful");
			}
			
			if ($result === false) {
				die( print_r( sqlsrv_errors(), true) );
			}
			
			if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
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
	
	function Update($table, $values, $id, $log = false) {
	
		$query = "UPDATE $table SET ";
		$sep = '';
		$fields = '';
		foreach($values as $key=>$value) {
			//$query .= $sep.$key." = '".$value."'";
			$query .= $sep.$key." = ?";
			$sep = ',';
			if ($value instanceof DateTime){
				$values_array[] = $value;
			}
			else if (is_null($value)){
				$values_array[] = $value;
			}else 
				$values_array[]= "$value";
			
		}
		$query .= " WHERE id = ?";
		
		array_push($values_array,$id);
		$params = $values_array;
		if (DEBUG){
			echo $query;
			var_dump($params);
		}
		if ($log){			
			$this->LogQuery('Update',$query,$params);
		}
		
		if ($table=='marsruts' && false){
			echo $query . '<BR>';
			var_dump($params);
			die();
		}
		
		$result = $this->Query($query,$params);
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}
		//return $result;
		//mssql_query($query);
	}
	function UpdateGrupuVaditaji($table, $values, $id, $log = false) {
	
		$query = "UPDATE $table SET ";
		$sep = '';
		$fields = '';
		foreach($values as $key=>$value) {
			//$query .= $sep.$key." = '".$value."'";
			$query .= $sep.$key." = ?";
			$sep = ',';
			if ($value instanceof DateTime){
				$values_array[] = $value;
			}
			else
				$values_array[]= "$value";
			
		}
		$query .= " WHERE idnum = ?";
		var_dump($query);
		
		array_push($values_array,$id);
		$params = $values_array;
		if (DEBUG){
			echo $query;
			var_dump($params);
		}
		if ($log){			
			$this->LogQuery('Update',$query,$params);
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
		//echo "update where<br>";
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
		
		//ja apdeito pieteikumu, vai piet saiti, saglab� v�stur�
		/*var_dump($table);
		if ($table == 'piet_saite'){
			echo 'ir piet saites';
			require_once("m_pieteikums_new.php");
			$piet = new Pieteikums_new();
			$old_vals = $piet->GetId($where_arr['pid']);
			$old_saites_arr  = $piet->GetSaitesAssoc($where_arr['pid']);
			
		}
		else echo 'nav';*/
		$result = $this->Query($query,$params);
		if( $result === false ) {
			 die( print_r( sqlsrv_errors(), true));
		}
		/*if ($table == 'piet_saite'){
			echo 'ir piet saites';
			$new_vals = $piet->GetId($where_arr['pid']);
			$new_saites_arr  = $piet->GetSaitesAssoc($where_arr['pid']);
			echo "Saglab�jam v�sturi";
			
			$this->SavePietHistory($old_saites_arr,$new_saites_arr,$where_arr['pid'],$old_vals,$new_vals);
			
		}*/
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
			if (strlen($arr[0])==2 && strlen($arr[1])==2 && strlen($arr[2])==4 && checkdate($arr[1], $arr[0], $arr[2])) {
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
	
	//v�stures saglab��ana no Globas
	


	
//atgrie� detaliz�tu v�sturi

	function GetUpdateActionDetails($old_vals, $new_vals, $table_p, $id_l) {
	  //sal�dzina, kuri lauki ir main�ju�ies
	  $history="";
	  //lauki, kuru izmai�as nepiefiks�
		//novadu ne�em (novada id, jo ir lauks novads_nos dalibniekam).
		$dont_log_fields = array('vesture','vards2','adrese2','pilseta2','uzvards2','nosaukums2','novads',"info","kvietas_cena","kvietas_cenaEUR","vietas_cenaEUR","summa","cena","persona","papildv","bilanceEUR","bilance","deleted");
		/*if ( $id==145411 && false){
			var_dump($old_vals);
			var_dump($new_vals);
			die();
		}*/
	   foreach ($old_vals as $field_name=>$old_val){
			if (!in_array($field_name,$dont_log_fields)) {
			
			$new_val = $new_vals[$field_name];
		  if ((!(($old_val == "" && $new_val == "0") || ($old_val == "" && $new_val == "") || ($old_val == "0" && $new_val == "")) && !($field_name == "viesnicas_veids" && ($old_val == "" || $new_val == "")))) {
		   

					
			if ($old_val != $new_val){
				//echo "nesakr�t!!";
			  //rw "nesakr�t"   
			  $old_val=$this->GetValStr($field_name, $old_val);
			  $new_val=$this->GetValStr($field_name, $new_val); 
			 $history .= "** " .$this->GetFieldTitle($field_name,$table_p). " :: ".$this->Any2Str($old_val)." => ".$this->Any2Str($new_val)."<br>";
			  //rw history
			  //rw field_value
			}
		  }
		}
		//rw "<br>"
	  }
	  //echo $history."<br>";
	  //rw history
	  //LogUpdateActionNew table_p,id_l,history
	  //response.end
	  return $history;
	}

	//latvisko boolean tipa v�t�bas
	function BoolLV($val) {
		if ($val) {return  "ir";} else { return "nav";}
	}
	
	//atgrie� laukam nosaukumu las�m� form�
	function GetValStr($field_name,$val){
		$GetValStr  = $val;
		if ($field_name=="rajons" or $field_name=="novads"){
			$GetValStr  = $this->GetNosaukumsID($field_name,$val);		
		}
		if (($field_name=="agents")) {
			$GetValStr  = $this->GetAgentsID($val);		
		}
		if ($field_name == "gid" || $field_name=="old_gid") {
			if (($val != "")) {
				require_once("m_grupa.php");
				$gr = new Grupa();
				$GetValStr = $gr->GetFullNosaukums($val);			
			}
		}
		if (($field_name=="vietas_veids")) {
			$GetValStr = $this->GetNosaukumsID("vietu_veidi",$val);
			
		}
		if (($field_name=="kid")) {
			/*echo "kid:";
			var_dump($val);
			echo "<br><br>";*/
			if (!empty($val)){
				require_once("m_kajite.php");
				$kaj = new Kajite();
				$kajite = $kaj->GetId($val);				
				$GetValStr = $this->GetNosaukumsID("kajites_veidi",$kajite['veids']);
			}
		}
		if (($field_name=="kvietas_veids")) {
			require_once("m_kajite.php");
			$kaj = new Kajite();
			$GetValStr = $kaj->GetCenasNos($val);
		}
		if (($field_name=="vid")) {
			
			if (!empty($val)){
				require_once("m_viesnicas.php");
				$viesn = new Viesnicas();
				$viesnicas_veids = $viesn->GetId($val);
					
				$GetValStr = $viesnicas_veids['nosaukums'];//." istaba Nr.". $val;
			}
		}
		
		if (is_bool($val)) {
			$GetValStr = $this->BoolLV($val);		
		}
		
		return $GetValStr;

	}

	function UpdateActionDetails($old_dict, $new_dict, $table_p, $id_l, $history="") {
		$history .= $this->GetUpdateActionDetails($old_dict, $new_dict, $table_p, $id_l);
		
		if ($history!=""){
			$this->LogAction($table_p,$id_l,'laboja',$history);
		}

	}
 

	//atgrie� piet_saites laukus, kuru izmainas ir j�glab� v�stur�
	function GetPietSaiteEditFields() {
		 $FieldsToSave = array("vietsk","vietas_veids","vid","kid","kvietas_veids","summaEUR","summa");
		 return  $FieldsToSave;
	}

	//sal�dzina piet_saites pieteikumam
	function SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals) {
		$history = "";
		//dim $saites_id;
		ForEach ($old_saites_arr as $saites_id=>$saite){
			/*echo "$saite <br>";
			var_dump($saite);
			echo "<br><br>";*/
			//rw "<br>key:"
			//rw saites_id
			//rw "<br>"
			 $old_piet_vals = $old_saites_arr[$saites_id];
			 $new_piet_vals = $new_saites_arr[$saites_id];
			// echo "Sal�dzin�m";
			$history .= $this->GetUpdateActionDetails($old_piet_vals,$new_piet_vals,"piet_saite",$pid);
			//UpdateActionDetails old_piet_vals,new_piet_vals,"pieteikums",pid,""
			unset($new_saites_arr[$saites_id]);
			
		}
		
	 
		 $FieldsToSave = $this->GetPietSaiteEditFields();
		 //paskat�s, vai jaunaj� piet. sai�u mas�v� nav k�das saites, kas nav vecaj�
		 ForEach ($new_saites_arr as $saites_id=>$saite){
		 
			//rw "<br>jaun� pieteikuma id:"
			$history .= "** Pievienots jauns pakalpojums :: =>";
			//p�rkop�� v�srt�bas, kuras j�glab�
			//set old_piet_vals = old_saites_arr(saites_id)
			$new_piet_vals = $new_saites_arr[$saites_id];
			//rw "items"
			$history_details_arr = array();
			 Foreach ($FieldsToSave as $item){
				 //echo "$item:<br>";
				//rw item
				//rw ">>"
				//rw nullprint(new_piet_vals(item))
				//rw "<<<br>"
				
				if (!empty($new_piet_vals[$item]) && !($item=="kvietas_veids" && $new_piet_vals[$item]=="0")) {
						$history_details_arr[] = $this->GetFieldTitle($item,"piet_saite") . ": ". $this->GetValStr($item,$new_piet_vals[$item]);
				
					//new_saites_vals0.add item,new_piet_vals(item)
					//old_saites_vals0.add item,""
				}
			 }
			
			$history_details = implode(", ",$history_details_arr);
			 
			$history .= $history_details. " <br>";
			//rw history		
			//rw saites_id
			//rw "<br>"
		 }
		$this->UpdateActionDetails($old_vals,$new_vals,"pieteikums",$pid,$history);
		 //LogUpdateActionNew "pieteikums",pid,history
		 
	}

	function Any2Str($val){
		if ($val instanceof DateTime) {
		  // true
		  $str = $this->Date2Str($val);
		}
		else $str = $val;
		return $str;
	}
	function GetNosaukumsID($table,$id){
		if ($id==0) {
			$nosaukums = "";
		}
		else{
			$nosaukums = $id;
			
			$qry = "SELECT nosaukums FROM $table WHERE id=?";
			$params = array($id);
			$result = $this->Query($qry,$params);
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$nosaukums = $row['nosaukums'];
			}
			
		}
		return $nosaukums;
	}
	
	function GetFieldTitle($field,$table=""){

		  //vards,uzvards,pk1,pk2,paseS,paseNR,paseIZD,paseIZDdat,paseDERdat,nosaukums,reg,nmkods,vaditajs,kontaktieris,adrese,pilseta,indekss,
		  //talrunisMvalsts,talrunisM,fax,talrunisDValsts,talrunisD,talrunisMobValsts,talrunisMob,eadr,eadr_paz,piezimes,fizjur,deleted,rajons,
		  //novads,dzimta,aizsutits,jaunumi,aid,idS,idNR,idDerDat,internets,dzimsanas_datums
		$title=$field;
		if (($field == "vards")) {
			$title="v�rds";
		}
		if (($field == "uzvards")) {
			$title = "uzv�rds";		
		}
		if (($field == "pk1" || $field == "pk2" )) {
			$title = "personas kods";		
		}
		if (($field == "paseS")) {
			$title = "pases s�rija";		
		}
		if (($field == "paseNR")) {
			$title = "pases numurs";		
		}
		if (($field == "paseIZD")) {
			$title = "pases izdev�js";		
		}
		if (($field == "paseDERdat")) {
			$title = "pases der�guma termi��";		
		}
		if (($field == "reg")) {
			$title = "re�. nr.";		
		}
		if (($field == "nmkods")) {
			$title = "nod. maks. kods";		
		}
		if (($field == "vaditajs")) {
			$title = "vad�t�js";		
		}
		if (($field == "kontaktieris")) {
			$title = "kontaktp.";		
		}
		if (($field == "pilseta")) {
			$title = "pils�ta/pagasts";		
		}
		if (($field == "talrunisMvalsts")) {
			$title = "m�jas t�lr. valsts kods";		
		}
		if (($field == "talrunisDvalsts")) {
			$title = "darba t�lr. valsts kods";		
		}
		if (($field == "talrunisMobvalsts")) {
			$title = "mob. t�lr. valsts kods";		
		}
		if (($field == "talrunisM")) {
			$title = "m�jas t�lr.";		
		}
		if (($field == "talrunisD")) {
			$title = "darba t�lr.";		
		}
		if (($field == "talrunisMob")) {
			$title = "mob. t�lr.";		
		}
		if (($field == "fax")) {
			$title = "fakss";		
		}
		if (($field == "eadr")) {
			$title = "e-adrese";		
		}
		if (($field == "piezimes")) {
			$title = "piez�mes";		
		}
		if (($field == "fizjur")) {
			$title = "juridiska persona";		
		}
		if (($field == "dzimta")) {
			$title = "dzimums";		
		}
		if (($field == "idS")) {
			$title = "ID kartes s�rija";		
		}
		if (($field == "idNR")) {
			$title = "ID kartes numurs";		
		}
		if (($field == "idDerDat")) {
			$title = "ID kartes der�guma termi��";		
		}
		if (($field == "dzimsanas_datums")) {
			$title = "dzim�anas datums";		
		}
		if (($field == "agents")) {
			$title = "a�ents";		
		}
		if (($field == "gid")) {
			$title = "grupa";		
		}
		if (($field == "old_gid")) {
			$title = "iepriek��j� grupa";		
		}
		if (($field == "dat_atcelts")) {
			$title = "atteikuma datums";		
		}
		if (($field == "vieta_rezerveta_lidz")) {
			$title = "vieta rezerv�ta l�dz";		
		}
		if (($field == "vietas_veids")) {
			$title = "vietas veids";		
		}
		if (($field == "kid")) {
			$title = "kaj�te";		
		}
		if (($field == "kvietas_veids")) {
			$title = "kaj�tes veids";		
		}
		if (($field == "summaEUR")) {
		
			$title = "summa EUR";	
			if (($table=="piet_saite")) {
				$title = "pakalpojuma ".$title; 
			} else { 
				if ($table=="pieteikums") {$title= "pieteikuma ".$title; }
			}
		}
		if (($field == "summa")) {
			$title = "summa val�t�";
			if (($table=="piet_saite")) {
				$title = "pakalpojuma ".$title; 
			} else { 
				if ($table=="pieteikums") {$title= "pieteikuma ".$title ;}
			}		
		}
		if (($field == "vietsk")) {
			$title = "vietu skaits";		
		}
		if (($field == "vid")) {
			$title = "viesn�cas numurs";		
		}
		if (($field == "viesnicas_veids")) {
			$title = "viesn�cas numura veids";		
		}
		if (($field == "bilanceEUR")) {
			$title = "bilance EUR";		
		}
		if (($field == "tmp")) {
			$title = "apstiprin�ta rezerv�cija";		
		}
		if (($field == "ligums_id")) {
			$title = "L�guma ID#";		
		}
		if (($field == "carter_voucer")) {
			$title = "Vau�eris izdruk�ts";		
		}

		return $title;


	}
	
	
	//v�stures saglab��ana
	function LogAction($table_p,$id_l,$action_p,$history=""){
		
		$qry = "SELECT vesture FROM $table_p WHERE id = ?";
			$params = array($id_l);
		if (DEBUG){
			echo "$qry <br>";
			var_dump($params);
			echo "<br><br>";
			//exit();
		}
	
		$result = $this->Query($qry,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		$ves = $row["vesture"];
		if (DEBUG){
			var_dump($row);
			echo "<br><br>";
		}
		if (empty($ves)) {
			$ves = '';
		}
			
		$qry = "UPDATE $table_p  SET [vesture] = '".$ves.$this->GetUser()." - ".$action_p." || ".date("d.m.Y H:i:s")."<br>".$history."' WHERE id = ?";
			
		
		if (DEBUG){
			echo "$qry<br>";
			var_dump($params);
			echo "<br><br>";
		}
		$this->Query($qry,$params);
	}
 
 
	function GetWindowsUser() {
		if (isset($_SESSION["user_name"]))
			return $_SESSION["user_name"];
		$user = $_SERVER["LOGON_USER"];
		if (strlen($_SERVER["LOGON_USER"])==0){
			$user = "unknown";
			
		}else{
			for ($i=0; $i<strlen($user); $i++) {
				if (substr($user,$i,1) == "\\" ) {
					$user =  substr($user,$i+1);
					break;
				}
			}
		}
		return $user;
	}
	
	function GetUser(){
		require_once("m_profili.php");
		$profili = new Profili();
		if (isset($_SESSION['profili_id'])){
			$profils = $profili->GetId();
			if ($profils['eadr'] != NULL)
					$user = $profils['eadr'];
			else
				$user = $profils['vards'].' '.$profils['uzvards'];
			$user .=' (online)';
		}
		else $user = $this->GetWindowsUser();
		return $user;
		
	}
	 
	//------------------------------
	//GetCurUserId - atgrie� tejko�� j�zera Id
	//-----------------------------
	function GetCurUserID() {
		//'If Get_User() = Session("CurUser") and not isnull(Session("CurUserID")) then
		//'	GetCurUserID = Session("CurUserID")
		//'else
			$_SESSION["CurUser"]   =  $this->GetWindowsUser();
		//var_dump($this->GetWindowsUser());
			$_SESSION["CurUserID"] =  $this->GetUserID($this->GetWindowsUser());
			//var_dump($_SESSION);
			return  $_SESSION["CurUserID"];
		//'end if
	}
	//------------------------------
	//GetUserId - atgrie� j�zera Id p�c v�rda (str*20)
	//-----------------------------
	function GetUserID($vards) {
		if ($vards=="") {
			return 0;
		}
		$qry = "SELECT lietotaji.id from Lietotaji where UPPER(Lietotajs)=?";
		//echo $qry;
	
		$params = array(strtoupper($vards));
			//var_dump($params);
		$rUname = $this->Query($qry,$params);
		if (!sqlsrv_has_rows($rUname)) {	
		
			//dim $ID;
			$ID = $this->AddUser($vards,"unknown");
			return $ID;
		} else {
			//rUname.movefirst
			$row = sqlsrv_fetch_array( $rUname, SQLSRV_FETCH_ASSOC);
			return $row["id"];
		}
	}
	function AddUser($vards, $info) {
		$username=trim($vards);
		if (strlen($info)==0) {$info=" ";}
		if (strlen($username)>20) {$username=substr($username,0,20);}
		if (strlen($username)==0) {return;}
		
		$values = array('lietotajs'=>$username, 'info' => $info);
		$id = $this->Insert('Lietotaji',$values,$values);
		return $id;
	}


	
	//atgrie� true ja tuk�s datums; false pret�j� gad
	function IsEmptyDate($date){
		if (empty($date) || $date == $this->empty_date){
			return true;
		}
		else return false;

	}
	/**
	 * Constructs a offsetted query.
	 *
	 * Because of the major differences between MySQL (LIMIT) and 
	 * SQL Server's cursor approach to offsetting queries, this method
	 * allows an abstraction of this process at application level.
	 *
	 * @param int    $offset the offset point of the query
	 * @param int    $limit  the limit of the query
	 * @param string $select the fields we're selecting
	 * @param string $tables the tables we're selecting from
	 * @param string $order  the order by clause of the query
	 * @param string $where  the conditions of the query
	 *
	 * @return string
	 */
	function offset($offset, $limit, $select, $tables, $order, $where='')
	{
		$ret .= 'SELECT [outer].* FROM (
				SELECT ROW_NUMBER() OVER(ORDER BY ' . $order .') as ROW_NUMBER,
				' . $select . '
				FROM ' . $tables . ($where ? ' WHERE ' . $where : '')
			.') AS [outer]
				WHERE [outer].[ROW_NUMBER] BETWEEN '
			. (intval($offset)+1).' AND '.intval($offset+$limit)
			. ' ORDER BY [outer].[ROW_NUMBER]';

		return $ret;
	}
	
	//atgrie� rindi�u skaitu vaic�jumam
	function GetQryCount($qry){
		$qry = "SELECT COUNT(*) as skaits FROM ($qry) as t ";	
		$result = $this->Query($qry);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['skaits'];
		}
	}
	
	function GetWhere($table,$data,$where_cond=null){
		$query = "SELECT * FROM $table ";
		$params = array();
		$where_arr = array();
		foreach ($data as $field=>$val){
			$where_arr[] = " $field=? ";
			$params[] = $val;
			
		}
		$where = implode(" AND ",$where_arr);
		$query.= "WHERE $where";
		if (isset($where_cond)){
			$query .= " AND $where_cond";
		}
		//echo $query;
		$result = $this->Query($query,$params);
		return $result;
		
	}
	
	function LogQuery($function,$qry,$params = false){
		if ($_SESSION['profile_id'] == 5116){
			//die( "LOG!!!");
		}
		$content = date("Y-m-d H:i:s")."; function: ".$function."; query: ".$qry;
		if ($params){
			$content .= "; param.: ".print_r($params,true);
			
		}
		$content .= "\r\n\r\n";
		file_put_contents("db_queries\\db_".date("Y-m").".txt",$content,FILE_APPEND);
	}
	
	//checkbox vērtibu pārvēr integer vērt�b�
	function Check2Int($val){
		
		$ret_val = ($val == 'on' ? 1 : 0);
		return $ret_val;
	}
	
	function getBrowser() {
	  $u_agent = $_SERVER['HTTP_USER_AGENT'];
	  $bname = 'Unknown';
	  $platform = 'Unknown';
	  $version= "";

	  // First get the platform?
	  if (preg_match('/linux/i', $u_agent)) {
		$platform = 'linux';
	  } elseif (preg_match('/macintosh|mac os x/i', $u_agent)) {
		$platform = 'mac';
	  } elseif (preg_match('/windows|win32/i', $u_agent)) {
		$platform = 'windows';
	  }

	  // Next get the name of the useragent yes seperately and for good reason
	  if(preg_match('/MSIE/i',$u_agent) && !preg_match('/Opera/i',$u_agent)) {
		$bname = 'Internet Explorer';
		$ub = "MSIE";
	  } elseif(preg_match('/Firefox/i',$u_agent)) {
		$bname = 'Mozilla Firefox';
		$ub = "Firefox";
	  } elseif(preg_match('/Chrome/i',$u_agent)) {
		$bname = 'Google Chrome';
		$ub = "Chrome";
	  } elseif(preg_match('/Safari/i',$u_agent)) {
		$bname = 'Apple Safari';
		$ub = "Safari";
	  } elseif(preg_match('/Opera/i',$u_agent)) {
		$bname = 'Opera';
		$ub = "Opera";
	  } elseif(preg_match('/Netscape/i',$u_agent)) {
		$bname = 'Netscape';
		$ub = "Netscape";
	  }

	  // finally get the correct version number
	  $known = array('Version', $ub, 'other');
	  $pattern = '#(?<browser>' . join('|', $known) . ')[/ ]+(?<version>[0-9.|a-zA-Z.]*)#';
	  if (!preg_match_all($pattern, $u_agent, $matches)) {
		// we have no matching number just continue
	  }

	  // see how many we have
	  $i = count($matches['browser']);
	  if ($i != 1) {
		//we will have two since we are not using 'other' argument yet
		//see if version is before or after the name
		if (strripos($u_agent,"Version") < strripos($u_agent,$ub)){
		  $version= $matches['version'][0];
		} else {
		  $version= $matches['version'][1];
		}
	  } else {
		$version= $matches['version'][0];
	  }

	  // check if we have a number
	  if ($version==null || $version=="") {$version="?";}

	return array(
	  'userAgent' => $u_agent,
	  'name'      => $bname,
	  'version'   => $version,
	  'platform'  => $platform,
	  'pattern'    => $pattern
	  );
	}
	
	function GetPost($field){
		$value = (isset($_POST[$field]) ? $_POST[$field] : false);
		return $value;
	}
	
	function GetGet($field){
		$value = (isset($_GET[$field]) ? $_GET[$field] : false);
		return $value;
	}


function menesis($men)
{
 			   if ($men==1)
				return 'janv�ris';
 			   if ($men==2)
				return 'febru�ris';
 			   if ($men==3)
				return 'marts';
 			   if ($men==4)
				return 'apr�lis';
 			   if ($men==5)
				return 'maijs';
 			   if ($men==6)
				return 'j�nijs';
 			   if ($men==7)
				return 'j�lijs';
 			   if ($men==8)
				return 'augusts';
 			   if ($men==9)
				return 'septembris';
 			   if ($men==10)
				return 'oktobris';
 			   if ($men==11)
				return 'novembris';
 			   if ($men==12)
				return 'decembris';
}

	

}	// class Db
} // class exists
?>