<?
class Lietotaji {
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
	

	function GetId($id){
		$query = "SELECT * FROM lietotaji WHERE id=?";
		$params = array($id);
		
		$result = $this->db->Query($query,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
	}
	
	
	function GetField($field,$id){
		$query = "SELECT [$field] as field FROM lietotaji WHERE id=?";
		$params = array($id);
		
		$result = $this->db->Query($query,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['field'];
		}
	}
	
	function Update($data){
		$active;
		
	
		$table = "lietotaji";
		$values = array(
		"lietotajs" => $data["lietotajs"],
		"vards" => $data["vards"],
		"uzvards" => $data["uzvards"],
		"epasts" => $data["epasts"],
		"parole" => $data["parole"],
		"active" => $data['active'],
		);
		$this->db->Update($table,$values,$data["id"]);
	}
	
	function GetLietotajiById($id){
		$query = "Select * from lietotaji where aid = ? ORDER BY id";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data;
	}
	
	function Delete($id){
		$query = "Delete from lietotaji where id = ?";
		$params = array($id);
		$this->db->Query($query, $params);
	}
	
	function Add($data){
		$table = "lietotaji";
		$this->db->Insert($table,$data);
	}
}
?>