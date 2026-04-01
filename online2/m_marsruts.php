<?
class Marsruts {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db();
	
	}
	
	function GetId($id){
		$query = "SELECT * FROM marsruts WHERE ID=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	//atgriež maršrutu pēc online rezervācijas id
	function GetOnlineRez($online_rez_id){
		$query = "SELECT m.* 
					FROM pieteikums p, grupa g, marsruts m
					WHERE p.online_rez = ?
					AND p.gid not in (".$this->db->invisibleGid.")
					AND p.gid=g.ID
					AND g.mID = m.ID";
		$params = array($online_rez_id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
					
	}
	
	//atgriež testa maršrutu id
	function getTestIds($where){
		$query = "SELECT ID FROM marsruts WHERE v LIKE ('".$where."%')";
		
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$id_array = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$id_array[] = $row['ID'];
			
		}	
		return $id_array;
	}
	
	//atgriež maršrutu pēc grupas ID
	function GetGid($gid){
		$query = "SELECT m.* FROM marsruts m, grupa g
					WHERE g.mID = m.ID AND g.ID=?";
		$params = array($gid);
		If(DEBUG){
		echo $query."<br>";
		var_dump($params);
		echo "<br><br>";
		}
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}

	function Insert($data){
		$qry = "SELECT * FROM marsruts WHERE v2 like ?";
		$params = array($marsr_arr['v2'] );
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		if (sqlsrv_has_rows($result)) {
			echo "eksistē grupa";
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$mID = $row['id'];
			}
		}
		else{
			"Jaliek jauns marsruts";
			$this->db->Insert('marsruts',$data);
			$qry = "SELECT MAX(id) as id FROM marsruts";
			$res = $this->db->Query($qry);
			while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				$mID = $row['id'];
				
			}
		}
		return $mID;
	}
	// function IsDouble($data)
	// {
	// 	$query = "select isnull(count(*),0) from marsruts where v2 = '$data["marsruts"]["v2"]' and id in (select mid from grupa where beigu_dat>='1/1/$data["beigu_dat"]' and beigu_dat<'1/1/$data["beigu_dat"]')";
	// 	$params = array($data[marsruts[v2]],$data["beigu_dat"],$data["beigu_dat"]);
	// 	$result = $this->db->Query($qry);
	// 	return $result;
	// }
	

}
?>