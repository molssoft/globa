<?
class Maksajumi {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;	
	}
	
	function Get(){
		$query = "SELECT * FROM maksajumi WHERE deleted=0";
		//echo $query;
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$maksajumi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$row['orderi'] = $this->GetOrders($row['id']);
			$row['atlikums'] = $this->GetAtlikusiSumma($row['id']);
			$row['online'] = $this->IsOnline($row['id']);
			$maksajumi[] = $row;	
			
		}
		return $maksajumi;
	}
	
	//pârbauda vai maksâjums jau nav reìistrçts
	function Exists($san_konts,$bank_ref){
		$query = "SELECT * FROM maksajumi WHERE san_konts=? AND bank_ref=? AND deleted=0 ORDER BY maks_datums DESC,maks_nos ASC " ;
		$params = array($san_konts,$bank_ref);
		//var_dump($params);
		//var_dump($query);
		$result = $this->db->Query($query,$params);
		//echo "qq<br>";
		if(sqlsrv_has_rows($result) ) {
			return true;
		}
		else return false;
		
	}
	
	//atrod pçc dalîbnieka id nepamaksâtus pieteikumus
	function GetNeapmaksatiPid($id){
		require_once("m_grupa.php");
		$gr = new Grupa();
		$query = "SELECT p.id,p.gid,p.bilanceEUR,p.ligums_id FROM piet_saite ps, pieteikums p WHERE (ps.did=(SELECT did from maksajumi where id=?)  OR p.did=(SELECT did from maksajumi where id=?) ) AND p.deleted=0 AND ps.deleted=0 AND ps.pid=p.id /*AND p.bilanceEUR<0 */ GROUP BY p.id,p.gid,p.bilanceEUR,p.ligums_id ORDER BY p.id";
		$params = array($id,$id);
		//echo $query;
		//var_dump($params);
		$result = $this->db->Query($query,$params);
		$pid_arr = array();
			$grupu_arr = array();
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$pid_arr[$row['gid']][] = array('pid'=>$row['id'],
										
										'bilance'=>$row['bilanceEUR']);
			if (!in_array($row['gid'],$grupu_arr)){
				$grupu_arr[] = $gr->GetId($row['gid']);
			}
			$lid = $row['ligums_id'];
			//echo 'Lîgums id:<br>';
			//var_dump($lid);
			//atrod pçc lîguma pârçjos pieteikumus
			if (!empty($lid)){
				$query = "SELECT * from pieteikums WHERE ligums_id = ? AND deleted=0 AND id<>? AND bilanceEUR<0";
				$params = array($lid,$row['id']);
				//echo $query;
				//var_dump($params);
				$res_citi = $this->db->Query($query,$params);
				while( $row_citi = sqlsrv_fetch_array( $res_citi, SQLSRV_FETCH_ASSOC) ) {
					
					$pid_arr[$row['gid']][] = array('pid'=>$row_citi['id'],
										'bilance'=>$row_citi['bilanceEUR']);
				
				}
			}
		}
		$result = array('grupas'=>$grupu_arr,
						'pieteikumi' => $pid_arr);
		return $result;
	}
	
	function GetId($id){
		$query = "SELECT * FROm maksajumi WHERE id=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}
	
	function Delete($id){
		$query = "UPDATE maksajumi SET deleted=1 WHERE id=?";
		//$query = "DELETE FROM maksajumi WHERE id=?";
		$params = array($id);
		$this->db->Query($query,$params);
	}
	
	function Update($data,$id){
		$this->db->Update('maksajumi',$data,$id);
	}
	
	function Insert($data){
		$maksajumi_id = $this->db->Insert('maksajumi',$data,$data);
		return $maksajumi_id;
	}
	
	//atgrieþ orderus, kas izveidoti no konkrçtâ maksâjuma
	function GetOrders($id){
		$query = "SELECT  o.*,v.val FROM orderis o, valuta v WHERE o.valuta=v.id AND maksajumi_id=? AND deleted=0 ORDER BY num ASC";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		$orders = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$orders[] = $row;			
		}
		return $orders;
	}
	
	function GetOrderuSum($id){
		$query = "SELECT SUM(summaval) as summa FROM orderis WHERE deleted=0 AND maksajumi_id=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['summa'];			
		}
		return 0;
	}
	
	function GetAtlikusiSumma($id){
		$orderu_summa = $this->GetOrderuSum($id);
		$maksajums = $this->GetId($id);
		$atlikums = $maksajums['summa'] - $orderu_summa;
		return $atlikums;
	}
	//pârbaud, vai tas ir onlinâ caur mâjaslapu eikts maksâjums (pçc detaïâm)
	function IsOnline($id){
		//echo "IsOnline<br>";
		$re = '/^Impro online rezerv(â|a)cija\..+\.\.\. \(rez_id(=|_)\d{5,}\)$/';
		$maks = $this->GetId($id);
		$detalas = $maks['detalas'];
		//var_dump(preg_match($re,$detalas));
		preg_match($re,$detalas,$matches);
		//var_dump($matches);
		//echo "<br>";
		if (preg_match($re,$detalas)) return 1;
		else return 0;
	}
	
	
	
	
	
	
	
}
?>