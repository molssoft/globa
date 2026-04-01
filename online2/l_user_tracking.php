<?
Class UserTracking{
	var $db;
	
	public function __construct() { 
		//session_start();
		require_once('m_init.php');
		$this->db = new Db;	
		
	}
	function Save($text){
		$data = array('session' => session_id(),
						'text'=> $text,
						);
		if (isset($_SESSION['profili_id']))
			$data['profili_id'] = $_SESSION['profili_id'];
		if (isset($_SESSION['reservation']['online_rez_id']))
			$data['rez_id'] = $_SESSION['reservation']['online_rez_id'];
		if (isset($_SESSION['reservation']['grupas_id']))
			$data['gid'] = $_SESSION['reservation']['grupas_id'];
		require_once("m_user_tracking.php");
		$user_tracking = new UserTracking();
		$user_tracking->Save($data);
	}
}

?>