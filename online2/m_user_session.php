<?
class UserSession {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;	
	}
	
	function Save($profili_id,$session_id=null){
		
		//var_dump($_SESSION);
		if(!isset($session_id))
			$session_id = session_id();
			
		$data = array('session_id' => $session_id,
						'profili_id'=> $profili_id,
						'last_activity_time' => date("Y-m-d H:i:s")
						);
		//pârbauda, vai ðim lietotâjam jau eksistç ieraksts:				
		$user_session = $this->GetProfiliId($profili_id);
		if (!empty($user_session)){
			//updeits
			$id = $user_session['id'];
			$this->db->Update('user_session',$data,$id);			
		}
		else{
			//inserts
			$data['date'] = date("Y-m-d H:i:s");
			$this->db->Insert('user_session',$data);
		}
	}
	
	function SaveBeforePayment($profili_id,$session_id=null){
		
		//var_dump($_SESSION);
		if(!isset($session_id))
			$session_id = session_id();
		//pârbauda, vai pçdçjâs aktivitâtes laiks nav lielâks	
		$data = array('session_id' => $session_id,
						'profili_id'=> $profili_id,
						'before_payment_time' => date("Y-m-d H:i:s")
						);
		//pârbauda, vai ðim lietotâjam jau eksistç ieraksts:				
		$user_session = $this->GetProfiliId($profili_id);
		if (!empty($user_session)){
			//updeits
			if (DEBUG){
				var_dump($user_session);
				var_dump($data);
				
			}
			/*if ($user_session['last_activity_time'] > $data['before_payment_time']){
				$data['last_activity_time'] = date("Y-m-d H:i:s",strtotime("-1 second",strtotime($data['before_payment_time'])));
			}*/
			$id = $user_session['id'];
			/*if (DEBUG){
				echo "<br><br>";
				var_dump($user_session);
				var_dump($data);
				//exit();
				
			}*/
			$this->db->Update('user_session',$data,$id);	
			//if (DEBUG) exit();
		}
		else{
			//inserts
			$data['date'] = date("Y-m-d H:i:s");
			$data['last_activity_time'] = date("Y-m-d H:i:s");
			$this->db->Insert('user_session',$data);
		}
	}
	
	
	function GetProfiliId($profili_id=null){
		if (!isset($profili_id))
			$profili_id = $_SESSION['profili_id'];
		$query = "SELECT * FROM user_session where profili_id=?";
		$params = array($profili_id);
		$result = $this->db->Query($query,$params);
		$user_sess = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$user_sess =  $row;			
		}
		return $user_sess;	
	}	
}

if(isset($_GET['method']) && isset($_GET['param'])){
	session_save_path('tmp/');
	session_start();
   $user_sess = new UserSession();
   if (isset($_GET['session_id'])){
	   $user_sess->$_GET['method']($_GET['param'],$_GET['session_id']);
   }
   else 
	$user_sess->$_GET['method']($_GET['param']);
}		
?>