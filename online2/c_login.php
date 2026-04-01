<?
define("DEBUG",  "0");
//session_save_path('tmp/') ;
session_save_path('c:\temp') ;
session_start();
//echo session_save_path() ;
require_once('m_init.php');
require_once('m_profili.php');
require_once("m_user_tracking.php");
$db = new Db();
$profili = new Profili;
$u_track = new UserTracking();

$data = array();
unset($_SESSION['profili_id']);
if (isset($_GET['f']))
	$function = $_GET['f'];
else $function = 'login';
if ($function == 'forgot') 	ForgotPass();
if ($function == 'login') Login();


function ForgotPass(){
	global $db;
	global $profili;
	global $u_track;
	$data['eadr'] = '';
	if (isset($_GET['eadr'])){
		$data['eadr'] = $_GET['eadr'];
	}
	if (isset($_POST['post']) && $_POST['post'] == 1 ){
		if (isset($_POST['eadr'])) {
			if (DEBUG)var_dump($_POST);
			if (!filter_var($_POST['eadr'], FILTER_VALIDATE_EMAIL)) {
				$error['eadr'] = 'Ievadîtais e-pasts nav derîgs';
				$text = "<b>ATGÂDINÂT PAROLI: </b>".$error['eadr'];					
				$u_track->Save($text);
			}
			else{
				$result = $profili->GetEadr($_POST['eadr']);
					if (DEBUG) var_dump($result);
				if (empty($result)){
					$error['eadr'] = 'Lietotâjs ar ðâdu e-pasta adresi nav reìistrçts';
					$text = "<b>ATGÂDINÂT PAROLI: </b>".$error['eadr'];					
					$u_track->Save($text);
				}
				else{
					//sûtâm jaunu paroli
					include("l_email.php");
					$email = new Email();
					$user_name = $result['eadr'];
					$new_pw = mt_rand(100000,999999);
					$recipient = $result['eadr'];
					//saglabâ jauno paroli
					
					$values = array('pass' => md5($new_pw));
					$profili_id = $result['id'];
					$profili->Update($values,$profili_id);		
					$sent = $email->ForgotPasswordData($user_name,$new_pw,$recipient);
					
					$_SESSION['info']['msg'] = "Jûsu jaunâ parole ir nosûtîta uz e-pasta adresi <b>".$_POST['eadr']."</b><BR>Ja nesaòemat paroli 10 minûðu laikâ, sazinieties ar IMPRO biroju pa 
					tâlruni 67221312!";
					$_SESSION['info']['email'] =  $_POST['eadr'];
					$text = "<b>ATGÂDINÂT PAROLI: </b>".$_SESSION['info']['msg'];
					
					$u_track->Save($text);
					$_POST['post'] = 0;
					Login();
					
					exit();
				
					
				}
				
			}
			if (count($error)==0){
				
			}
			else{
				$data['values'] = $_POST;
				$data['errors'] = $error;
			}			
		}
	}
	
	include("v_forgot_password.php");
	
}
function Login(){

	//Login::
	global $db;
	global $profili;
	global $u_track;
	if (isset($_SESSION['gift_card']) && $_SESSION['gift_card']==1){
		$pirkt_dk = 1;
	}
	else{
		$pirkt_dk = 0;
	}
	if (isset($_POST['post']) && $_POST['post'] == 1 ){
		
		if (isset($_POST['eadr'])) {
			$id = $profili->Login($_POST['eadr'],$_POST['pass']);
			if ($id) {
			
				if ($pirkt_dk){
					$text = "<b>Ieiet sistçmâ - pirkt dâvanu karti</b>";
				}
				else{
					$text = "<b>Ieiet sistçmâ</b>";
				}
				
				//ja ieíeksçts 'Atcerçties mani no ðîs ierîces'
				if (isset($_POST['remember_me'])){
					$profili->SetCookie($_POST['eadr']);
					//die();
					$text .= "<br>Atcerçties mani no ðîs ierîces";
				}
					
				
				//no mâjaslapas pogas 'Pirkt':
				if (isset($_SESSION['pirkt']['grupas_id'])){
					$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_reservation.php?f=TravellerCount">';
					$text .= "<br>Pirkt ceïojumu ar ID#".$_SESSION['pirkt']['grupas_id'];
				}
				else{
					if ($pirkt_dk){
						//die('ielogojamies');
						$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_reservation.php?f=BuyGiftCard">';
					}
					else{
						if (isset($_SESSION['after_login_redirect_url'])){
							$url = $_SESSION['after_login_redirect_url'];
						}
						else{
							$url = 'c_home.php';
						}

						
						$data['header'] = '<meta http-equiv="refresh" content="1;URL='.$url.'">';
					}
					
				}
				$u_track->Save($text);
				if (isset($_SESSION['gift_card'])){
					unset($_SESSION['gift_card']);
				}
				
				//pârbauda, vai lietotâjs nav bloíçts. Ja ir pârvirza uz bloíçðanas lapu
				$profils = $profili->GetId($id);
				if ($profils['banned'] ){
				
					$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_banned_profile.php">';
					$text = "Lietotâjs ir bloíçts - pârvirza uz bloíçðanas paziòojuma lapu.";
					$u_track->Save($text);
					unset($_SESSION);//atiestata login datus
				}
			
			} else {
				
				$data['message'] = 'Neizdevâs pieslçgties. <BR>Pârbaudiet e-pastu vai paroli!';
				$text = $data['message'];					
				$u_track->Save($text);
			}
		}
	}
	else{
		//pârbauda, vai nav uzstâdîts cookie ar loginu
		//var_dump($_COOKIE);
		if(isset($_COOKIE["impro-online"])){
			$pieces = explode(",", $_COOKIE["impro-online"]);
			$eadr = $pieces[0];
			$cookies_token = $pieces[1];
			$result = $profili->LoginByCookie($eadr,$cookies_token);
			//var_dump($result);
			if ($result) {
				if ($pirkt_dk){
					$text = "<b>Ieiet sistçmâ - pirkt dâvanu karti (bez datu ievadîðanas - sistçma atceras lietotâju)</b>";
				}
				else{
					$text = "<b>Ieiet sistçmâ (bez datu ievadîðanas - sistçma atceras lietotâju)</b>";
				}
				
					
				
				//no mâjaslapas pogas 'Pirkt':
				if (isset($_SESSION['pirkt']['grupas_id'])){
					$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_reservation.php?f=TravellerCount">';
					$text .= "<br>Pirkt ceïojumu ar ID#".$_SESSION['pirkt']['grupas_id'];
				}
				else{
					if ($pirkt_dk){
						//die('ielogojamies');
						$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_reservation.php?f=BuyGiftCard">';
					}
					else{
						
						$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_home.php">';
					}
					
				}
				$u_track->Save($text);
				if (isset($_SESSION['gift_card'])){
					unset($_SESSION['gift_card']);
				}
				
				//pârbauda, vai lietotâjs nav bloíçts. Ja ir pârvirza uz bloíçðanas lapu
				$profils = $profili->GetId($id);
				if ($profils['banned']){
				
					$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_banned_profile.php">';
					$text = "Lietotâjs ir bloíçts - pârvirza uz bloíçðanas paziòojuma lapu.";
					$u_track->Save($text);
					unset($_SESSION);//atiestata login datus
				}
			}
		}
	}
	if (isset($_SESSION['info'])){
		$data['info']['email']= $_SESSION['info']['email'];
		$data['info']['msg']= $_SESSION['info']['msg'];
		unset($_SESSION['info']);
	}
	//nolasa, vai nav kâdi banku ierobeþojumi spçkâ
	require_once("m_settings.php");
	$settings = new Settings();
	$data['disabled_bankas'] = $settings->GetDisabledBankas();
	if ($pirkt_dk){
		include 'v_gift_card_authorize.php';
	}
	else{
		
		include 'v_login.php';
	}
	
}


?>
