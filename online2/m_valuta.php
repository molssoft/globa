<?
class Valuta {
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
	
	//atgrieþ valûtas id pçc val lauka vçrtîbas
	function GetVal($val){
		$query = "SELECT * FROM valuta WHERE val=?";
		$params = array($val);
		//echo $query;
	//	var_dump($params);
		//die();
		$result = $this->db->Query($query,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['ID'];
		}
	}
}
?>