<?

//==============================//
// Paroles maiòa 				//
//c_change_password.php 	    //
//==============================//
session_save_path('c:\temp') ;
session_start();
require_once('m_init.php');
require_once('m_profili.php');
require_once('m_dalibn.php');
require_once("m_user_tracking.php");
$db = new Db;
$u_track = new UserTracking();
	
	
$profili = new Profili;
if ($profili->CheckLogin()){
	$profils = $profili->GetId($_SESSION['profili_id']);
	$dalibn = new Dalibn;
	$dalibnieks = $dalibn->GetId();
	if (isset($_POST['post']) && $_POST['post'] == 1){
		/*$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);*/
		$error = array();
		//if (filter_var($_POST['epasts'], FILTER_VALIDATE_EMAIL) == false) {	$error['epasts'] = 'E-pasts ievadîts nekorekti'; }
		//elseif ($profili->EadrExists($_POST['epasts'])){ $error['epasts'] = 'Ðâda e-pasta adrese sistçmâ jau ir reìistrçta';}
		
		$parole_pareiza = $profili->CheckPassword($_POST['old_pass']);		
		if (!$parole_pareiza){ $error['old_pass'] = 'Esoðâ parole nav ievadîta pareizi'; }
		
		if ($_POST['pass1'] != $_POST['pass2']) { 
			$error['pass'] = 'Paroles nesakrît'; 
		}
		
		if (strlen($_POST['pass1']) < 5 || strlen($_POST['pass2']) < 5) {	
			$error['pass'] = 'Parolei jâbût vismaz 5 simbolus garai'; 
		}
		//}
		
		
		if (count($error) == 0) {			
					
				
			// Ja parole DB atrodas, ir ievadita POST, bet nesakrît, update
			
			//if(md5($_POST['pass1']) != $profils['pass'] || $_POST['eadr'] != $profils['eadr']){
				//$_POST['eadr'] = $_POST['epasts'] ;
				$plain_pass = $_POST['pass1'];
				$_POST['pass'] = md5($_POST['pass1']) ;
				$db1 = $db->EscapeValues($_POST,'pass');
				$profili->Update($db1,$_SESSION['profili_id']);				
				//$dalibn->Update($db1,$dalibnieks['ID']);
				//$profili->Login($_POST['eadr'],$_POST['pass']);
				//var_dump($db1);
				//$_SESSSION['username'] = $db1['eadr'];
			//$_SESSSION['password'] = $db1['pass'];
				//var_dump($_SESSION);
				//}
				
				
				
			
		}
		
		if (count($error) > 0) {
			/*$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);*/
		//	$data['values']['epasts'] = $_POST['epasts'];
			$data['errors'] = $error;
			
			//include 'v_register_email_new.php';
			//exit();
		}else{
			$_POST['post'] = 0;
			//var_dump($_SESSION);
			
				//change login data
				//var_dump($_POST);
				if ($_SESSION['profili_id'] == 5116){
					/*define("DEBUG",1);
					$profils = $profili->GetId();
					$epasts = $profils['eadr'];
					var_dump($profili->Login($epasts,$plain_pass));
					exit();*/
				}
				$profils = $profili->GetId();
				$epasts = $profils['eadr'];
				$profili->Login($epasts,$plain_pass);
				
				
			//if ($profili->CheckLogin()){
				
					
			//$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_home.php">';
			echo "<script>
					alert('Parole veiksmîgi nomainîta!');
					window.location = 'c_home.php';
						</script>'";
						
		}
	}
	/*if ($_SESSION['profili_id']) {			
		$values = array();
		$profils = $profili->GetId();
		$values['epasts'] = $profils['eadr'];
		$data['values'] = $values;
	}*/
	//}



	include 'v_change_password.php';
}
else{
	header("Location: c_login.php");
}

?>