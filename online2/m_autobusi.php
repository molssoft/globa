<?
class Autobusi {
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
		$query = "SELECT a.*,p.Nosaukums as pnos FROM autobusi a 
					LEFT JOIN partneri_auto p ON p.id=a.partneris
					WHERE a.deleted=0 ORDER BY pnos ASC, a.nosaukums ASC,nr ASC";
		//echo $query;
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$autobusi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$autobusi[] = $row;			
		}
		return $autobusi;
	}
	
	function GetId($id){
		$query = "SELECT a.*,p.Nosaukums as pnos FROM autobusi a 
					LEFT JOIN partneri_auto p ON p.id=a.partneris
					WHERE a.id = ?";
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
		$query = "UPDATE autobusi SET deleted=1 WHERE id=?";
		$params = array($id);
		$this->db->Query($query,$params);
	}
	
	function Update($data,$id){
		$this->db->Update('autobusi',$data,$id);
	}
	
	function Insert($data){
		$autobusi_id = $this->db->Insert('autobusi',$data,$data);
		return $autobusi_id;
	}
	
	function GetPartneriAuto(){
		$query = "SELECT * FROM partneri_auto
					WHERE Nosaukums IS NOT NULL
					ORDER BY Nosaukums ASC";
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$partneri = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$partneri[] = $row;			
		}
		return $partneri;
	}
	
	//saglabā siati ar bildi
	function AddBilde($data){
		$image_id = $this->db->Insert('autobusi_bildes',$data,$data);
		return $image_id;
	}
	
	function UpdateBilde($data,$id){
		$this->db->Update('autobusi_bildes',$data,$id);
	}
	
	function DeleteBilde($id){
		$qry = "DELETE FROM autobusi_bildes WHERE id=?";
		$params = array($id);
		$this->db->Query($qry,$params);
		
	}
	//atgriež visas autobusa bildes
	function GetBildes($id){
		$qry = "SELECT * FROM autobusi_bildes WHERE autobusi_id=?
				ORDER BY galvena DESC";
		$params = array($id);
		$result = $this->db->Query($qry,$params);
		$bildes = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$bildes[] = $row;			
		}
		return $bildes;
		
	}
	
	
	//atgriež galveno autobusa bildi
	function GetGalvenaBilde($id){
		$qry = "SELECT * FROM autobusi_bildes WHERE autobusi_id=? AND galvena=1";
		$params = array($id);
		$result = $this->db->Query($qry,$params);
		$bildes = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$bildes = $row;			
		}
		return $bildes;
	}
	
	//atgriež mājaslapā rādāmos autobusus:
	function GetWeb(){
		$query = "SELECT a.*,p.Nosaukums as pnos,b.bilde FROM autobusi a 
					LEFT JOIN partneri_auto p ON p.id=a.partneris
					LEFT JOIN autobusi_bildes b ON a.id=b.autobusi_id AND b.galvena=1
					WHERE a.deleted=0 AND radit_web=1 
					ORDER BY pnos ASC, a.nosaukums ASC,nr ASC";
		//echo $query;
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$autobusi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$autobusi[] = $row;			
		}
		return $autobusi;
	}
	
	
	
	
	
	
	
	
}
?>