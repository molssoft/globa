<?
session_save_path('c:\temp') ;
session_start();

//echo session_save_path() ;
require_once('m_init.php');
require_once('m_profili.php');
require_once("m_online_rez.php");



$profili = new Profili;
$online_rez = new OnlineRez();
$_SESSION['already_registered_check'] = 0;
$data = array();

if ($profili->CheckLogin()){
	if (isset($_SESSION['reservation']['from_email'])){
		header("Location:c_reservation.php?f=Hotels&rez_id=".(int)$_SESSION['reservation']['from_email']);
		unset($_SESSION['reservation']['from_email']);
		exit();
	}
	if (isset($_SESSION['reservation'])){
		unset($_SESSION['reservation']);
	}
	if (isset($_GET['test'])){
		
		$test = 1;
	}
	else $test=0;
	
	//pârbauda, vai ir pabeigts profils:
	unset($_SESSION['uncompleted_profile_message']);
	
	$data['uncompleted_res'] = $online_rez->GetUserReservations(true);
	include 'v_home.php';


}
else{

	header("Location: c_login.php");
}

?>
