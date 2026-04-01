<?
class MerchantLog {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;	
	}
	
	function GetTransId($trans_id){
		$query = "SELECT * FROM merchant_log WHERE trans_id=?";
		$params = array($trans_id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	function Update($values,$trans_id){
		$where_arr = array('trans_id' => $trans_id);
		$result = $this->db->UpdateWhere('merchant_log',$values,$where_arr);
		return true;
	}
	
	

	
	

	

}
?>