<?
class GrupaIzbrVieta {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;
	
	}
	
	function GetId($id){
		$query = "SELECT * FROM grupa_izbr_vieta WHERE ID=?";
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