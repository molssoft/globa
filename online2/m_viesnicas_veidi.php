<?
class ViesnicasVeidi {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db;
	}
	
	public function Ensure($gid,$veids,$pilns_nosaukums,$vietas){
		$id = $this->get_by_nosaukums($gid,$veids);
		if ($id==0) {
			$data = array();
			$data['gid'] = $gid;
			$data['nosaukums'] = $veids;
			$data['pilns_nosaukums'] = $pilns_nosaukums;
			$data['vietas'] = $vietas;
			$data['pieejams_online'] = 1;
			
			$this->db->insert('viesnicas_veidi',$data);
			$id = $this->get_by_nosaukums($gid,$veids);
		}
		return $id;
	}
	
	public function GetByNosaukums($gid,$veids){
		$query = "select * from viesnicas_veidi where gid = $gid and nosaukums = '$veids'";
		$params = array();
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		

		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		
		if (count($row)==0)
			return 0;
		else	
			return($row['id']);
		
	}
	
	function GetById($id){
		$query = "SELECT * FROM viesnicas_veidi WHERE id=?";
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