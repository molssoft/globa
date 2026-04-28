<?
//session_save_path('tmp/') ;
session_save_path('c:\temp') ;
session_start();
//echo session_save_path() ;
//if (isset($_GET['a']) && (int)$_GET['a']==1){
//	$_SESSION['test'] = 1;
//}

if (isset($_SESSION['test'])){
	//unset($_SESSION['test']);
	define("DEBUG",  "1");
}
else{
	define("DEBUG",  "0");
}
require_once('m_init.php');
require_once('m_profili.php');
require_once('m_dalibn.php');
require_once("m_user_tracking.php");
$db = new Db;
$u_track = new UserTracking();
$profili = new Profili;
$data = array();
//unset($_SESSION['new_user']);
// tabs
$tabs = array();
$tabs[1] = array();
$tabs[1]['title'] = 'Persona';
$tabs[1]['enabled'] = 1;
$tabs[1]['link'] = 'c_register.php?f=name';
$tabs[2] = array();
if ($profili->RegCompleted()){
	$tabs[2]['title'] = 'E-pasts';
}
else{
	$tabs[2]['title'] = 'Pieeja';
}
$tabs[2]['enabled'] = 1;
$tabs[2]['link'] = 'c_register.php?f=email';

$tabs[3] = array();
$tabs[3]['title'] = 'Dokuments';
$tabs[3]['enabled'] = 1;
$tabs[3]['link'] = 'c_register.php?f=passport';
$tabs[4] = array();
$tabs[4]['title'] = 'Adrese';
$tabs[4]['enabled'] = 1;
$tabs[4]['link'] = 'c_register.php?f=address';

$tabs[5] = array();
$tabs[5]['title'] = 'Tâlrunis';
$tabs[5]['enabled'] = 1;
$tabs[5]['link'] = 'c_register.php?f=phone';
$tabs['wizzard'] = 1;
$_SESSION['tabs'] = $tabs;

$function = $_GET['f'];
if ($function == 'name') 		Name();
if ($function == 'email') 		Email();
if ($function == 'email_new') 		Email_new();
if ($function == 'passport') 	Passport();
if ($function == 'address') 	Address();
if ($function == 'phone') 		Phone();
if ($function == 'NameTest') 		NameTest();
//$action = $_GET['act'];
//if (isset($_GET['a']) && (int)$_GET['a']==1){
//	$_SESSION['test'] = 1;
//	define("DEBUG",1);
//}
function Name() {
	
	global $db;
	global $u_track;
	global $tabs;
	
	//var_dump($db);
	//var_dump($_SESSION);
	$profili = new Profili;
	require_once("m_dalibn.php");
	$dalibn = new Dalibn();

	$_SESSION['tabs']['current'] = 1;
	$script = "<script>
					$(document).ready(function() {
						$('#myModal').modal();
					});
				</script>";
	//dzimðanas diena
	if (isset($_POST['subm']) && $_POST['subm'] == 2){
		//var_dump($_POST);
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}		
		$u_track->Save($text);
		//Validation
		//$error = array();
		$error = $dalibn->ValidateBirthday($_POST['dzimsanas_datums']);
		if (count($error) == 0) {
			if (isset($_SESSION['profili_id']) ) {
				$db1 = $db->EscapeValues($_POST,'dzimsanas_datums');
			//	var_dump($db1);
			$db1['dzimsanas_datums']  = str_replace('.', '-', $db1['dzimsanas_datums'] );
				$db1['dzimsanas_datums'] = date("Y-m-d",strtotime($db1['dzimsanas_datums']));
				//var_dump($db1);
				// updeits
				$profili->Update($db1,$_SESSION['profili_id']);
				//echo "updated";
				$dalibnieks = $dalibn->GetId();
				$dalibn_id = $dalibnieks['ID'];
				//echo "DALÎBIEKA ID: $dalibn_id<br>";
				if ($dalibnieks){
					$dalibn->Update($db1,$dalibn_id);
					
					if ($profili->CheckLogin() && $profili->RegCompleted()){
						
					//header("Location: c_home.php");
						$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
					}
					else{
						Email();
						exit();
					}
				
				}
				else{
					die('Nav atrasts dalîbnieks');
				}
			}
			else{
				die('Nav atrasts profils');
			}
			
		}
		else{
			// kïûda
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			// râdam vecâs vçrtîbas un kïûdas paziòojumu
			//$data['values'] = $_POST;
			$data['dzimsanas_datums'] = $_POST['dzimsanas_datums'];
			$data['errors'] = $error;
			$data['script'] = $script;
			//echo "DALÎBNIEKA ID: $dalibn_id<br>";
			//$birthday = $dalibn->Birthday($dalibn_id);
		//	include 'v_register_name_new.php';
			//exit();
		}
		
		
		//exit();
	}
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}		
		$u_track->Save($text);
		//Validation
		$error = array();
		$values['vards'] = $_POST['vards'];
		$values['uzvards'] = $_POST['uzvards'];
		$values['pk1'] = $_POST['pk1'];
		$values['pk2'] = $_POST['pk2'];
		$values['dzimta'] = $_POST['dzimta'];
		$values['user_piezimes'] = $_POST['user_piezimes'];
		// validate
		
		$error = $dalibn->Validate($values);
		
		// db pârbaudes
		if (count($error) == 0) {
				
			if (isset($_SESSION['profili_id'])) {
				// eksistçjoðs profils
				// var mainît tikai dzimumu un piezîmes
				$db1 = $db->EscapeValues($_POST,'dzimta,user_piezimes');
				// updeits
				$profili->Update($db1,$_SESSION['profili_id']);
					
				$dalibnieks = $dalibn->GetId();
				$dalibn_id = $dalibnieks['ID'];
				if (!$dalibnieks){
					$dalibn->Insert($db1);
				}
				else{
					$dalibn->Update($db1,$dalibn_id);
				}
			
				
			} else {
				$db1 = $db->EscapeValues($_POST,'vards,uzvards,pk1,pk2,dzimta,user_piezimes');
				// pârbaudam vai var izveidot profilu
				$err = $profili->CanInsert($db1);
				if ($err==''){
					//pârbaudâm, vai ðâds dalîbnieks jau nav reìistrçts
					require_once('m_dalibn.php');
					
					$result = $dalibn->Exists($db1);
					if (strlen($result)==0){
						//veidosim jaunu dalibnieku
						$dalibn_id=0;
					}
					elseif((int)$result>0){
						$dalibn_id = (int)$result;
						//echo "Dalibn id: $dalibn_id<br>";						
					}
					else{
						$err = $result;
					}
					if ($err==''){
						// izveidojam jaunu ierakstu
						$tmp = $profili->Insert($db1);
						//var_dump($tmp);
						$_SESSION['profili_id'] = $tmp;
						
						if ($dalibn_id>0) $dalibn->Update($db1,$dalibn_id);
						else $dalibn->Insert($db1);
						
											
					} else {
						$error['vards'] = $err;
					}
				} else {
					$error['vards'] = $err;
				}
			}
		}

		//var_dump($_POST);
		
		if (count($error) > 0) {
			// kïûda
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			// râdam vecâs vçrtîbas un kïûdas paziòojumu
			$data['values'] = $_POST;
			$data['errors'] = $error;
			include 'v_register_name_new.php';
			exit();
		}else{
			// viss pareizi
			// ejam uz nâkamo soli
			$_POST['post'] = 0;
			
			$dalibnieks = $dalibn->GetId();
			$dalibn_id = $dalibnieks['ID'];
			
			//jâapstiprina vai jâievada dzimðanas datums
			if (!empty($dalibnieks['dzimsanas_datums']) && $db->empty_date != $dalibnieks['dzimsanas_datums']){
				if ($profili->CheckLogin() && $profili->RegCompleted()){
				//header("Location: c_home.php");
					$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				}
				else{
					Email();
					exit();
				}
			}
			else{
				$data['script'] = $script;
				//echo "DALÎBNIEKA ID: $dalibn_id<br>";
				$birthday = $dalibn->Birthday($dalibn_id);
				$data['dzimsanas_datums'] = $db->Date2Str($birthday);
			}
		}	
	} 
	//else {
		
		if (isset($_SESSION['profili_id'])) {
			
			$profili = new Profili;
		
			//$row = $profili->GetId($_SESSION['profili_id']);
			$row = $dalibn->GetId();
			if (empty($row)){
				$profils = $profili->GetId();
				die("Nav atrasts dalîbnieks ar ðâdu personas kodu: <b>".$profils['pk1'].'-'.$profils['pk2']."</b>. Lûdzu, sazinieties ar IMPRO.");
			}
			$values = array();				
			$values['vards'] = $row['vards'];
			$values['uzvards'] = $row['uzvards'];
			$values['pk1'] = $row['pk1'];
			$values['pk2'] = $row['pk2'];
			$values['dzimta'] = $row['dzimta'];
			$values['user_piezimes'] = $row['user_piezimes'];
			if (!empty($row['dzimsanas_datums']) && $db->empty_date != $row['dzimsanas_datums']){
				$values['dzimsanas_datums'] = $db->Date2Str($row['dzimsanas_datums']);
			}
			
			$data['values'] = $values;
		}
	//}
	
	include 'v_register_name_new.php';
}

function Email_24042018(){
	if (isset($_GET['act']) && $_GET['act'] == 'change_passw'){
		$_SESSION['act'] = 'change_passw';
	}
	$_SESSION['tabs']['current'] = 2;

	// Iegûstam lietotâja DB datus
	global $db;
	global $u_track;
	global $tabs;
	$profili = new Profili;
	$profils = $profili->GetId($_SESSION['profili_id']);
	$dalibn = new Dalibn;
	$dalibnieks = $dalibn->GetId();

			
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);
		$error = array();
		if (filter_var($_POST['epasts'], FILTER_VALIDATE_EMAIL) == false) {	$error['epasts'] = 'E-pasts ievadîts nekorekti'; }
	
		if ($_POST['pass1'] != $_POST['pass2']) {							$error['pass'] = 'Paroles nesakrît'; }
		//if(empty($profils['pass'])){
			if (strlen($_POST['pass1']) < 5 || strlen($_POST['pass2']) < 5) {	$error['pass'] = 'Parolei jâbût vismaz 5 simbolus garai'; }
		//}
		
		
		
		if (count($error) == 0) {			
			if ($_SESSION['profili_id']){				
				if(empty($profils['pass'])){
					$registered_user = false;
					// Ja parole DB nav ievadîta, tad ievieto POST value uzreiz
					$_POST['eadr'] = $_POST['epasts'] ;
					$_POST['pass'] = md5($_POST['pass1']);
					$db1 = $db->EscapeValues($_POST,'eadr,pass');
					$profili->Update($db1,$_SESSION['profili_id']);	
					
					
					$dalibn->Update($db1,$dalibnieks['ID']);
				}else{
					// Ja parole DB atrodas, ir ievadita POST, bet nesakrît, update
					
					//if(md5($_POST['pass1']) != $profils['pass'] || $_POST['eadr'] != $profils['eadr']){
						$_POST['eadr'] = $_POST['epasts'] ;
						$_POST['pass'] = md5($_POST['pass1']) ;
						$db1 = $db->EscapeValues($_POST,'eadr,pass');
						$profili->Update($db1,$_SESSION['profili_id']);				
						$dalibn->Update($db1,$dalibnieks['ID']);
						$profili->Login($_POST['eadr'],$_POST['pass']);
						//var_dump($db1);
						//$_SESSSION['username'] = $db1['eadr'];
					//$_SESSSION['password'] = $db1['pass'];
						//var_dump($_SESSION);
						//}
						$registered_user = true;
				}
				
			}else{
				die("FATAL ERROR:404");
			}
		}
		
		if (count($error) > 0) {
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			$data['values']['epasts'] = $_POST['epasts'];
			$data['errors'] = $error;
			
			include 'v_register_email.php';
			exit();
		}else{
			$_POST['post'] = 0;
			//var_dump($_SESSION);
			if ($registered_user){
			//if ($profili->CheckLogin()){
				if (isset($_SESSION['act']) && $_SESSION['act'] == 'change_passw'){
					unset($_SESSION['act']);
					//$data['header'] = '<meta http-equiv="refresh" content="1;URL=c_home.php">';
					echo "<script>
							alert('Parole veiksmîgi nomainîta!');
							window.location = 'c_home.php';
						</script>'";
				}
				elseif ($profili->RegCompleted()){
					$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				}
				else{
					Passport();
					exit();	
				}
				//header("Location: c_home.php");
				
			}
			else{
				
				//if (if(empty($profils['pass'])
				//$_SESSION['tmp_username'] = $db1['eadr'];
				//$_SESSION['tmp_password'] = $db1['pass'];
				Passport();
				exit();				
			}
			
		
		}
	}
//	else {
		
		if ($_SESSION['profili_id']) {			
			$values = array();
			$values['epasts'] = $profils['eadr'];
			$data['values'] = $values;
		}
	//}
	if (isset($_GET['test'])){
		include 'v_register_email_new.php';
	}
	else{
		include 'v_register_email.php';
	}
	//include 'v_register_email.php';
}

function Email(){
	
	$_SESSION['tabs']['current'] = 2;

	// Iegûstam lietotâja DB datus
	global $db;
	global $u_track;
	global $tabs;
	$profili = new Profili;
	$profils = $profili->GetId($_SESSION['profili_id']);
	$dalibn = new Dalibn;
	$dalibnieks = $dalibn->GetId();
	
	if ($profili->RegCompleted()){
		$prasit_paroli = true;
	}
	else{
		$prasit_paroli = false;
	}
			
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);
		$error = array();
		if (filter_var($_POST['epasts'], FILTER_VALIDATE_EMAIL) == false) {	$error['epasts'] = 'E-pasts ievadîts nekorekti'; }
		elseif ($profili->EadrExists($_POST['epasts'])){ $error['epasts'] = 'Ðâda e-pasta adrese sistçmâ jau ir reìistrçta';}
		if ($prasit_paroli){
			$parole_pareiza = $profili->CheckPassword($_POST['old_pass']);		
			if (!$parole_pareiza){ $error['old_pass'] = 'Esoðâ parole nav ievadîta pareizi'; }
		}
		else{
			if ($_POST['pass1'] != $_POST['pass2']) { $error['pass'] = 'Paroles nesakrît'; }
		//if(empty($profils['pass']) or (strlen($_POST['pass1'])>0 or strlen($_POST['pass2'])>0)){
			if (strlen($_POST['pass1']) < 5 || strlen($_POST['pass2']) < 5) {	$error['pass'] = 'Parolei jâbût vismaz 5 simbolus garai'; }
		//}
		}
		
		
		
		
		if (count($error) == 0) {			
			if ($_SESSION['profili_id']){				
				if(empty($profils['pass'])){
					$registered_user = false;
					// Ja parole DB nav ievadîta, tad ievieto POST value uzreiz
					$_POST['eadr'] = $_POST['epasts'] ;
					$_POST['pass'] = md5($_POST['pass1']);
					$db1 = $db->EscapeValues($_POST,'eadr,pass');
					$profili->Update($db1,$_SESSION['profili_id']);	
					
					
					$dalibn->Update($db1,$dalibnieks['ID']);
				}else{
					// Ja parole DB atrodas, ir ievadita POST, bet nesakrît, update
					
					//if(md5($_POST['pass1']) != $profils['pass'] || $_POST['eadr'] != $profils['eadr']){
						$_POST['eadr'] = $_POST['epasts'] ;
						//$_POST['pass'] = md5($_POST['pass1']) ;
						$db1 = $db->EscapeValues($_POST,'eadr');
						$profili->Update($db1,$_SESSION['profili_id']);				
						$dalibn->Update($db1,$dalibnieks['ID']);
						$profili->Login($_POST['eadr'],$_POST['pass']);
						//var_dump($db1);
						//$_SESSSION['username'] = $db1['eadr'];
					//$_SESSSION['password'] = $db1['pass'];
						//var_dump($_SESSION);
						//}
						$registered_user = true;
				}
				
			}else{
				die("FATAL ERROR:404");
			}
		}
		
		if (count($error) > 0) {
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			$data['values']['epasts'] = $_POST['epasts'];
			$data['errors'] = $error;
			$data['prasit_paroli'] = $prasit_paroli;
			include 'v_register_email.php';
			exit();
		}else{
			$_POST['post'] = 0;
			//var_dump($_SESSION);
			if ($registered_user){
				//change login data
				//var_dump($_POST);
				$profili->Login($_POST['eadr'],md5($_POST['old_pass']));
				//var_dump($_SESSION);
				//die();
				
			//if ($profili->CheckLogin()){
				
				if ($profili->RegCompleted()){
					$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				}
				else{
					Passport();
					exit();	
				}
				//header("Location: c_home.php");
				
			}
			else{
				
				//if (if(empty($profils['pass'])
				//$_SESSION['tmp_username'] = $db1['eadr'];
				//$_SESSION['tmp_password'] = $db1['pass'];
				Passport();
				exit();				
			}
			
		
		}
	}
//	else {
		
		if ($_SESSION['profili_id']) {			
			$values = array();
			$profils = $profili->GetId();
			$values['epasts'] = $profils['eadr'];
			$data['values'] = $values;
		}
	//}
		
		$data['prasit_paroli'] = $prasit_paroli;
		
		include 'v_register_email.php';
	
	//include 'v_register_email.php';
}

function Passport(){
	$_SESSION['tabs']['current'] = 3;
	
	// Iegûstam lietotâja DB datus
	$profili = new Profili;
	global $db;
	global $u_track;
	global $tabs;

	$row = $profili->GetId($_SESSION['profili_id']);
	$dalibn = new Dalibn;
	$dalibnieks = $dalibn->GetId();	
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);
		//Validation
		$error = array();
		$documents = array( 'paseNR' => $_POST['paseNR'],
										'idNR' => $_POST['idNR'],
										'paseDERdat' => $_POST['paseDERdat'],
										'idDerDat' => $_POST['idDerDat']
										);
		$errors = $dalibn->ValidateDocuments($documents);
		//var_dump($errors);
		if (!empty($errors['abi'])){
			foreach ($errors['abi'] as $key=>$value){
			
				$error[$key] = $value;
				
			}
		}
		else{
			if (!empty($errors['pase'])){
				foreach ($errors['pase'] as $key=>$value){
				
					$error[$key] = $value;
					
				}
			}
			if (!empty($errors['id_karte'])){
				foreach ($errors['id_karte'] as $key=>$value){
					
					$error[$key] = $value;
					
				}
			}
		}
		//var_dump($error);
		if (count($error) == 0) {			
			if ($_SESSION['profili_id']){
				$documents = array( 'paseNR' => $_POST['paseNR'],
								'idNR' => $_POST['idNR'],
								'paseDERdat' => $_POST['paseDERdat'],
								'idDerDat' => $_POST['idDerDat']
								);
				if (isset($_SESSION['test']) && $_SESSION['test']==1){
					//var_dump($documents);
					//exit();
				}
				$dalibn->UpdateDocuments($documents,$dalibnieks['ID'],1);
				
				
			}else{
				die("FATAL ERROR:404");
			}
		}
		$data['values'] = $_POST;
		if (count($error) > 0) {
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
					
			$data['errors'] = $error;
			include 'v_register_passport.php';
			exit();
		}else{
			$_POST['post'] = 0;
			if ($profili->CheckLogin() && $profili->RegCompleted()){
				//header("Location: c_home.php");
				$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				include 'v_register_passport.php';
				
			}
			else{
				Address();
				
			}
			exit();
		}
	}
//	else {
		if ($_SESSION['profili_id']) {
			//print_r($row);
			$values = array();
		//	$values['paseS'] =  $row['paseS'];
			$values['paseNR'] = $dalibnieks['paseS'].$dalibnieks['paseNR'];
			//var_dump($dalibnieks['paseDERdat']);
			
			$empty_date = new DateTime('1900-01-01');
			if (!empty($dalibnieks['paseDERdat']) && $dalibnieks['paseDERdat'] != $empty_date) {$values['paseDERdat'] = $db->Date2Str($dalibnieks['paseDERdat']);}
			
			//$values['idS']= $row['idS'];
			$values['idNR'] = $dalibnieks['idS'].$dalibnieks['idNR'];
			
			if (!empty($dalibnieks['idDerDat']) && $dalibnieks['idDerDat'] != $empty_date ){$values['idDerDat'] = $db->Date2Str($dalibnieks['idDerDat']);}
			
			
			$data['values'] = $values;
		
		}
	//}
	include 'v_register_passport.php';
}

function Address(){
	global $db;
	global $u_track;
	global $tabs;
	$_SESSION['tabs']['current'] = 4;
	
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);
		$error = array();
		$address = array ('adrese' => $_POST['adrese'],
										'pilseta' => $_POST['pilseta'],
										'novads' => $_POST['novads'],
										'indekss' => $_POST['indekss']
										);
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$error = $dalibn->ValidateAddress($address);
		/*
		
		if (empty($_POST['address'])) { 	$error['address'] = 'Adrese nav ievadîta'; }
		if (empty($_POST['city'])) { 		$error['city'] = 'Pilsçta nav ievadîta'; }
		if (empty($_POST['district'])) { 	$error['district'] = 'Novads nav izvçlçts'; }
		if (empty($_POST['post_index'])) { 	$error['post_index'] = 'Pasta indekss nav norâdîts'; }
		*/
		
		if (count($error) == 0) {			
			if ($_SESSION['profili_id']){				
				/*$_POST['adrese'] = $_POST['address'];
				$_POST['pilseta'] = $_POST['city'];
				$_POST['novads'] = $_POST['district'];
				$_POST['indekss'] = $_POST['post_index'];*/
				
				$db1 = $db->EscapeValues($_POST,'adrese,pilseta,novads,indekss');
				$profili = new Profili;
				//var_dump($db1);
				//exit();
				$profili->Update($db1,$_SESSION['profili_id']);
				$dalibn = new Dalibn;
				$dalibnieks = $dalibn->GetId();
				$dalibn->Update($db1,$dalibnieks['ID']);
			}else{
				die("FATAL ERROR:404");
			}
		}
		$data['values'] = $_POST;
		if (count($error) > 0) {
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			$data['errors'] = $error;
			//include 'v_register_address.php';
			//exit();
			
		}else{
			$_POST['post'] = 0;
			if ($profili->CheckLogin() && $profili->RegCompleted()){
				//header("Location: c_home.php");
				$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				
			}
			else{
				Phone();
				exit();
			}
			
		}
	} 
	//else {
		if ($_SESSION['profili_id']) {
			$profili = new Profili;
			$row = $profili->GetId($_SESSION['profili_id']);
		//	print_r($row);
			/*$values = array();				
			$values['address'] = $row['adrese'];
			$values['city'] = $row['pilseta'];
			$values['district'] = $row['novads'];
			$values['post_index'] = $row['indekss'];*/
			if (!isset($data['values'])){
				$data['values'] = array('adrese' => str_replace('"','\"',$row['adrese']),
									'pilseta' =>  $row['pilseta'],
									'novads' => $row['novads'],
									'indekss' => $row['indekss']);
			}
			//var_dump($data['values']);
		}
	//}
	include_once("m_Novads.php");
	$novads = new Novads();
	$data['novadi'] = $novads->get();
	//var_dump($data['novadi']);
	include 'v_register_address.php';
}

function Phone(){
	$_SESSION['tabs']['current'] = 5;
	$profili = new Profili;
	global $u_track;
	global $tabs;
	
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}
		$u_track->Save($text);
		$error = array();
		// validation
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$home_number_country = trim($_POST['home_number_country']);
		$home_number = trim($_POST['home_number']);
		$work_number_country = trim($_POST['work_number_country']);
		$work_number = trim($_POST['work_number']);
		$mobile_number_country = trim($_POST['mobile_number_country']);
		$mobile_number = trim($_POST['mobile_number']);
		$country_codes = array('home_number_country' => $home_number_country,
								'work_number_country' => $work_number_country,
								'mobile_number_country' => $mobile_number_country);
		$phones = array('home_number' => $home_number,
						'work_number' => $work_number,
						'mobile_number' => $mobile_number);
		$error = $dalibn->ValidatePhones($phones,$country_codes);
		//var_dump($error);
		/*if (empty($_POST['home_number']) &&
			empty($_POST['work_number']) &&
			empty($_POST['mobile_number'])) { 	$error['home_number'] = 'Ievadiet vismaz 1 saziòas tâlruni'; }
		*/
		if (count($error) == 0) {			
			if ($_SESSION['profili_id']){	
				$escape_string = "";
				//if(!empty($_POST['home_number'])){
					$_POST['talrunisM'] = $_POST['home_number'];
					$escape_string .= "talrunisM,";
				//}
				//if(!empty($_POST['work_number'])){
					$_POST['talrunisD'] = $_POST['work_number'];
					$escape_string .= "talrunisD,";
				//}
				//if(!empty($_POST['mobile_number'])){
					$_POST['talrunisMob'] = $_POST['mobile_number'];
					$escape_string .= "talrunisMob,";
				//}
					$_POST['talrunisMvalsts'] = $_POST['home_number_country'];
					$escape_string .= "talrunisMvalsts,";
				//}
				//if(!empty($_POST['work_number'])){
					$_POST['talrunisDvalsts'] = $_POST['work_number_country'];
					$escape_string .= "talrunisDvalsts,";
				//}
				//if(!empty($_POST['mobile_number'])){
					$_POST['talrunisMobvalsts'] = $_POST['mobile_number_country'];
					$escape_string .= "talrunisMobvalsts,";
				//}
				$escape_string = rtrim($escape_string, ',');
				global $db;
				$db1 = $db->EscapeValues($_POST,$escape_string);
				
				$profili->Update($db1,$_SESSION['profili_id']);
				//$dalibn = new Dalibn;
				$dalibnieks = $dalibn->GetId();
				$dalibn->Update($db1,$dalibnieks['ID']);
			}else{
				die("FATAL ERROR:404");
			}
		}
		
		if (count($error) > 0) {
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			$data['values'] = $_POST;
			$data['errors'] = $error;
			include 'v_register_phone.php';
			exit();
		}else{
			$_POST['post'] = 0;
			if (!$profili->CheckLogin() || !$profili->RegCompleted()){
				$profils = $profili->GetId();
				$_SESSION['new_user'] = 1;
				$_SESSION['username'] = $profils['eadr'];
				$_SESSION['password'] = $profils['pass'];
				header("Location: c_home.php");
				exit();
			}
			else{
				
				$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
				
			}
			
		}
	}
//	else {
		if ($_SESSION['profili_id']) {
			$profili = new Profili;
			$row = $profili->GetId($_SESSION['profili_id']);
			
			$values = array();				
			$values['home_number'] = $row['talrunisM'];
			$values['work_number'] = $row['talrunisD'];
			$values['mobile_number'] = $row['talrunisMob'];
			$values['home_number_country'] = (empty($row['talrunisMvalsts']) ? '371' : $row['talrunisMvalsts']) ;
			$values['work_number_country'] = (empty($row['talrunisDvalsts']) ? '371' : $row['talrunisDvalsts']);
			$values['mobile_number_country'] = (empty($row['talrunisMobvalsts']) ? '371' : $row['talrunisMobvalsts']);
			$data['values'] = $values;
		}
	//}
	include 'v_register_phone.php';
}

function Name_old(){
	
	global $db;
	global $u_track;
	global $tabs;
	
	//var_dump($db);
	//var_dump($_SESSION);
	$profili = new Profili;
	$dalibn = new Dalibn;
	$_SESSION['tabs']['current'] = 1;
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
		foreach ($_POST as $key=> $val){					
			$text .= $key."=".$val."<br>";
			
		}		
		$u_track->Save($text);
		//Validation
		$error = array();
		$values['vards'] = $_POST['vards'];
		$values['uzvards'] = $_POST['uzvards'];
		$values['pk1'] = $_POST['pk1'];
		$values['pk2'] = $_POST['pk2'];
		$values['dzimta'] = $_POST['dzimta'];
		// validate
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$error = $dalibn->Validate($values);
		/*if (strlen($_POST['vards'])>30) { 		$error['vards'] = 'Vârds ir par garu.'; }
		if (strlen($_POST['vards'])<2) { 		$error['vards'] = 'Vârds ir par îsu.'; }
		if (strlen($_POST['uzvards'])>30) { 	$error['uzvards'] = 'Uzvârds ir par garu.'; }
		if (strlen($_POST['uzvards'])<2) { 		$error['uzvards'] = 'Uzvârds ir par îsu.'; }
		if (strlen($_POST['pk1']) != 6 
		 || strlen($_POST['pk2']) != 5) { 		$error['pk1'] = 'Personas kods ievadîts nepareizi'; }
		if (!is_numeric($_POST['pk1']) 
		  ||!is_numeric($_POST['pk2'])) { 		$error['pk1'] = 'Personas kods drîkst saturçt tikai ciparus'; }
		if (empty($_POST['dzimta'])) { 		$error['dzimta'] = 'Dzimums nav noradîts'; }
		*/
		$birth_array = $_POST['birthdayPicker_birth'];
		if (empty($birth_array)){
			$birth_array = $_POST['hidden_b'];
		}
		include_once("i_functions.php");
		$error_birth = ValidateBirthday($birth_array);
		if (count($error_birth)>0){
			$error['birth_date'] = implode("<br>",$error_birth);
		}
		// db pârbaudes
		if (count($error) == 0) {
				
			if (isset($_SESSION['profili_id'])) {
				// eksistçjoðs profils
				// var mainît tikai dzimumu
				$db1 = $db->EscapeValues($_POST,'dzimta');
				// updeits
				$profili->Update($db1,$_SESSION['profili_id']);
					
				$dalibnieks = $dalibn->GetId();
				if ($dalibnieks){
					$dalibn->Insert($db1);
				}
				else{
					$dalibn->Update($db1,$dalibnieks['ID']);
				}
			
				
			} else {
				$db1 = $db->EscapeValues($_POST,'vards,uzvards,pk1,pk2,dzimta,birthdayPicker_birthDay');
				//var_dump($_POST);
				//echo "<br><br>";

				$db1['dzimsanas_datums'] = $db1['birthdayPicker_birthDay'];
				unset($db1['birthdayPicker_birthDay']);
				//var_dump($db1);
				// pârbaudam vai var izveidot profilu
				$err = $profili->CanInsert($db1);
				if ($err==''){
					//pârbaudâm, vai ðâds dalîbnieks jau nav reìistrçts
					require_once('m_dalibn.php');
					
					$result = $dalibn->Exists($db1);
					if (strlen($result)==0){
						//veidosim jaunu dalibnieku
						$dalibn_id=0;
					}
					elseif((int)$result>0){
						$dalibn_id = (int)$result;
						//echo "Dalibn id: $dalibn_id<br>";						
					}
					else{
						$err = $result;
					}
					if ($err==''){
						// izveidojam jaunu ierakstu
						$tmp = $profili->Insert($db1);
						//var_dump($tmp);
						$_SESSION['profili_id'] = $tmp;
						
						if ($dalibn_id>0) $dalibn->Update($db1,$dalibn_id);
						else $dalibn->Insert($db1);
						
											
					} else {
						$error['vards'] = $err;
					}
				} else {
					$error['vards'] = $err;
				}
			}
		}

		//var_dump($_POST);
		
		if (count($error) > 0) {
			// kïûda
			$text = "<b>REÌISTRÂCIJA: ".$tabs[$_SESSION['tabs']['current']]['title']."-kïûda</b>:<br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			// râdam vecâs vçrtîbas un kïûdas paziòojumu
			$data['values'] = $_POST;
			$data['errors'] = $error;
			include 'v_register_name_test.php';
			exit();
		}else{
			// viss pareizi
			// ejam uz nâkamo soli
			$_POST['post'] = 0;
			if ($profili->CheckLogin()){
				//header("Location: c_home.php");
					$data['success'] = "Izmaiòas veiksmîgi saglabâtas!";
			}
			else{
				Email();
				exit();
			}
			
			
		}	
	} 
	//else {
		
		if (isset($_SESSION['profili_id'])) {
			
			$profili = new Profili;
			
			//$row = $profili->GetId($_SESSION['profili_id']);
			$row = $dalibn->GetId();
			$values = array();				
			$values['vards'] = $row['vards'];
			$values['uzvards'] = $row['uzvards'];
			$values['pk1'] = $row['pk1'];
			$values['pk2'] = $row['pk2'];
			$values['dzimta'] = $row['dzimta'];
			if (!empty($row['dzimsanas_datums'])){
				$birth_array['day'] = $row['dzimsanas_datums']->format("j");
				$birth_array['month'] = $row['dzimsanas_datums']->format("n");
				$birth_array['year'] = $row['dzimsanas_datums']->format("Y");
			}
		//	echo $dalibn->GetAge($values['ID']);
			$data['values'] = $values;
			
		}
	//}
	
	include 'v_register_name_test.php';
}


?>
