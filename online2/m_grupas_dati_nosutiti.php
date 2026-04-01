<?
class GrupasDatiNosutiti {
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
	
	function GetGid($gid){
		$query = "SELECT * FROM grupas_dati_nosutiti
					WHERE gid=? ORDER BY pievienoja_datums DESC";
		//echo $query;
		$params = array($gid);
		$result = $this->db->Query($query,$params);
		
			
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;			
		}
		return $data;
	}
	
	function GetPid($pid){
		$query = "SELECT * FROM grupas_dati_nosutiti
					WHERE pid=? ORDER BY pievienoja_datums DESC";
		//echo $query;
		$params = array($pid);
		$result = $this->db->Query($query,$params);
		
			
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;			
		}
		return $data;
	}
	
	function GetId($id){
	$query = "SELECT * FROM grupas_dati_nosutiti
					WHERE id=? ORDER BY pievienots_datums DESC";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}
	
	function Delete($id){
		$query = "UPDATE grupas_dati_nosutiti SET deleted=1 WHERE id=?";
		$params = array($id);
		$this->db->Query($query,$params);
	}
	
	function Update($data,$id){
		$this->db->Update('grupas_dati_nosutiti',$data,$id);
	}
	
	function Insert($data){
		$grupas_dati_nosutiti_id = $this->db->Insert('grupas_dati_nosutiti',$data,$data);
		return $grupas_dati_nosutiti_id;
	}
	
	
	
	
	
	
	
	
	
	
}
?>