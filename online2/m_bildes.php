<?
class Bildes{
	
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db();
	}
	
	function GetGrupa($kods){
		$query = "select mb.id as mbid,* from portal.dbo.Grupas g
			join portal.dbo.marsruti_bildes mb on g.marsruts = mb.[mid]
			where g.gr_kods = '$kods'";
		$result = $this->db->QueryArray($query);
		
		return $result;
	}
}
?>