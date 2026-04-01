<?
class Novads {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;
	
	}
	function get() {		
		
		$query = "SELECT * FROM Novads ORDER BY nosaukums ASC";
		//$params = array($_SESSION['profili_id']);
		//var_dump($params);
		
		$result = $this->db->Query($query);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$novadi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$novadi[] = $row;
			
		}
		return $novadi;

	}
	
	public function GetId($id){
		
		
		$query = "SELECT * FROM Novads WHERE id=?";
		$params = array($id);
		
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}

		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			  return $row;
		}
		
	}

}
?>