<?
class UserTracking {
	var $db;
	
	public function __construct() { 
		require_once('m_init_utf.php');
		$this->db = new Db;	
	}
	
	function Save($text,$rez_id=null){
		
		$data = array('session' => session_id(),
						'text'=> $text,
						'version' => 2
						);
		if (isset($_SESSION['profili_id']))
			$data['profili_id'] = $_SESSION['profili_id'];
		if (isset($rez_id)){
			$data['rez_id'] = $rez_id;
		}elseif (isset($_SESSION['reservation']['online_rez_id']))
			$data['rez_id'] = $_SESSION['reservation']['online_rez_id'];
		if (isset($_SESSION['reservation']['grupas_id']))
			$data['gid'] = $_SESSION['reservation']['grupas_id'];
		require_once("m_dalibn_utf.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetId();
		$data['did'] = $dalibnieks['ID'];
	
		$this->db->Insert('user_tracking',$data);
		
	}
	function GetId($id){
	}
	
	
		
	
	
}
?>