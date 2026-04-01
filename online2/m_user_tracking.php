<?
class UserTracking {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
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
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetId();
		$data['did'] = $dalibnieks['ID'];
		//require_once("m_user_tracking.php");
		//$user_tracking = new UserTracking();
		//if (!isset($data['version']))
			//$data['version'] = 2;
	
		$this->db->Insert('user_tracking',$data);
		
	}
	function GetId($id){
		/*$query = "SELECT viesnicas.id as vid,vv.*
					FROM viesnicas 
					LEFT JOIN viesnicas_veidi vv
						ON viesnicas.veids = vv.id 
					WHERE viesnicas.id = ? ";
		//echo $query."<br>";
		//echo "$id<br>";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}*/
	}
	
	
		
	
	
}
?>