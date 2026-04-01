<?
class MerchantResponseCodes {
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
	
	function GetByCode($code){
		//extract only numbers from response code
		$code = preg_replace("/[^0-9]/","",$code);
		$query = "SELECT dbo.fn_decode_vb(skaidrojums) as skaidrojums FROM merchant_response_codes WHERE kods=?";
		$params = array($code);
		
		//echo $query;
		$result = $this->db->Query($query,$params);
			
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['skaidrojums'];
				
		}
		
	}
	

	
	
	
	
	
	
	
	
}
?>