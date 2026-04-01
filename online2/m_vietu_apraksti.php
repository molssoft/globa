<?
class VietuApraksti {
	var $db;

	public function __construct() {
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';

		require_once($path.'m_init.php');
		$this->db = new Db;
	}

	function GetId($id){
		$query = "SELECT * FROM portal.dbo.vietu_apraksti WHERE id = ?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
	}

	function GetAll(){
		$query = "SELECT * FROM portal.dbo.vietu_apraksti";
		$params = array();
		return $this->db->query_array($query,$params);
	}

	function Insert($values){
		$table = "portal.dbo.vietu_apraksti";
		return $this->db->Insert($table,$values, array());
	}

	function Update($id, $values){
		$table = "portal.dbo.vietu_apraksti";
		$this->db->Update($table,$values,$id);
	}

	function Delete($id){
		$query = "DELETE FROM portal.dbo.vietu_apraksti WHERE id = ?";
		$params = array($id);
		return $this->db->Query($query,$params);
	}
	
	function DeleteMarsrutsLink($id) {
		$query = "DELETE FROM portal.dbo.Marsruti_vietu_apraksti WHERE id = ?";
		$params = array($id);
		return $this->db->Query($query,$params);		
	}
}
?>



