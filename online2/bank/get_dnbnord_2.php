<?php
session_save_path('../tmp/') ;
session_start();
require_once('../m_init.php');
require_once('../m_profili.php');
require_once("../m_ligumi.php");
require_once("../m_user_tracking.php");
$u_track = new UserTracking();
$db = new Db;
$ligumi = new Ligumi();
$profili = new Profili();
require_once("i_bank_functions.php");
require_once("i_config.php");
 
 

//08.08.2019 RT: nelasam bankas atbildi no db, bet òemam pa tieðo no get_seb.php $bank_response_data
$s_get = $bank_response_data; 

/*
$ip = $_SERVER["REMOTE_HOST"];

$query = "SELECT * FROM [merchant_session] WHERE [ip] = ? AND [hash] = ? AND [timestamp] >= DATEADD(minute,-50,GETDATE()) ";
*/
$text = "<b>Maksâðana caur DNB</b>:<br>";
$text .= "bank response data: ".print_r($bank_response_data,true);
/*$text .= "qry: $query<br>";	
$text .= "hash:".$hash['hash']."<br>";	*/
$u_track->Save($text);

/*$params = array($ip,$hash['hash']);
$res = $db->Query($query, $params);
*/

 
  if (empty($s_get)){
//if (!sqlsrv_has_rows($res)){
	
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=SavedReservations";
	$_SESSION["reg_err"] = "Kïûda: merchant session error.";
	$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
	$text .= $_SESSION["reg_err"];
	$text .= "<br>url: $url";
	$u_track->Save($text);
	
	header("Location: ".$url);
	exit();
	//header("Location: ".Application("site_base_url")."rezervacija.asp"); //<----- edit production path
}
/*$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
$query = "SELECT * FROM [session_variables] WHERE session_id = ?";

$text = "<b>Maksâðana caur DNB</b>:<br>";
$text .= "qry: $query<br>";	
$text .= "session_id:".$result["id"]."<br>";

$params = array($result["id"]);
$vars_result = $db->Query($query,$params);


while($vars = sqlsrv_fetch_array( $vars_result, SQLSRV_FETCH_ASSOC)){
	$var_key = $vars["key"];
	$var_value = $vars["value"];
	$s_get[$var_key] = $var_value;
}
*/
 
 

//--- ieraksta bankas atbildi zhurnaala tabulaa
if ($s_get["VK_SERVICE"] == "1102" && BankReplyLogDnbnord($s_get)) {
 
	//iegust no pamatojuma - rezervacijas id
	$msg = $s_get["VK_MSG"];
	$recipient = $s_get["VK_REF"];
		
	//dim $arr;
	$arr = explode("_",$recipient);
	$recipient = $arr[0];
	$trans_id = $arr[1];
 
 
	/*Set regexp = $New RegExp;
	regexp.$IgnoreCase = True;
	regexp.$Global = True;*/
	
 
	/*$regexp_string = "rez_id_+([0-9]+)";
	regexp.$Pattern = $regexp_string;
	Set $regexp_result = regexp.Execute($msg);*/
	$re = "/rez_id[=|_]+([0-9]+)/";  
	//$re = "/rez_id=+([0-9]+)/";  
	preg_match($re, $msg, $matches);
	if (count($matches)==2){
		$rez_id = $matches[1];
	}
	else{
		$error = "Kïûda: Nav rezervâcijas numura. Sazinieties ar Impro.";
		echo $error;
		$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
		$text .= $error;	
		$u_track->Save($text);
		exit();
	}
		
		
	//Response.Write("regexp_result="+)
	/*if ($regexp_result.$Count > 0) {
		$rez_id = CInt($regexp_result[0].$SubMatches[0]);
	} else {
		//$_SESSION["reg_err") = "Kïûda: Nav rezervâcijas numura. Sazinieties ar Impro."
		//response.redirect(Application("site_base_url")&"rezervacija.asp") //<----- edit production path
		echo "Kïûda: Nav rezervâcijas numura. Sazinieties ar Impro.";
		Response.end;
	}*/
 
	//apmaksa veiksmiga
	if ($s_get["VK_T_STATUS"]=="2" || $s_get["VK_T_STATUS"]=="1") { //status 2=izpildts, 1=pienemts apstradei
		
		$values = array('no_delete' => 1);
		$db->Update('online_rez',$values,$rez_id);
		//$db.$conn.execute("update online_rez set no_delete = 1 where id = " + CStr($rez_id));
 
 
		if ($s_get["VK_T_STATUS"]=="2") { 
			$_SESSION["reg_err"] = "Maksâjums veiksmîgi izpildîts!";
		} else {
			$_SESSION["reg_err"] = "Maksâjums pieòemts izpildei! 30 minûðu laikâ Jûs uz savu e-pasta adresi saòemsiet iegâdâto dâvanu karti.";
		}
		
		$_SESSION[$rez_id."_ligums_ok"] = $rez_id;
		
		//response.redirect(Application("site_base_url")&"celojums_ligums.asp")
 
		//dim $test,$str_ord_ids,$eadr;
		//test =res.save_ligums(user_id,g_id,$_SESSION["ImproLigums")) 
		if ($s_get["VK_T_STATUS"]=="2"){
			$str_ord_ids = CreateDbOrders($rez_id, "dnbnord", $trans_id); //izveidojam orderus
			
			//--- pirmajâ maks reizç apstiprina lîgumu 
			if (!$ligumi->IsAcceptedWithPayment($rez_id)) {
				$ligumi->AcceptWithPayment($rez_id);
			}
				
			if ($str_ord_ids!="") { //--- ja orderi tika izveidoti
			
				//--- nosuta apstiprinajuma epastu
				//dabû maksâjuma kopsummmu
				$maksajuma_summa = GetSumma($rez_id,$trans_id);
				require_once("../m_profili.php");
				$profili = new Profili();	
				$result = $profili->GetOnlineRez($rez_id);
				//$query = "SELECT * FROM [profili] WHERE [id] = '".$recipient."'  ";
				if (!empty($result)){
					//Set $result = $db.$Conn.execute($query);		
					if ($result["eadr_new"] != "") {
						$eadr = $result["eadr_new"];
					} else {
						$eadr = $result["eadr"];
					}
				}
				//nereìistrçtam lietotâjam, pçrkot dk:
				else{
					require_once("../m_pieteikums.php");
					$piet = new Pieteikums();
					$where_arr = array('online_rez'=>$rez_id);
					$dk_arr = $piet->GetPietOnlineRez($rez_id);
					
					//echo "dk_arr:<br>";
					//var_dump($dk_arr);
					//echo "<br><br>";
					if (!empty($dk_arr)){
						$dk = $dk_arr[0];
						$dalibnieks = $piet->GetDalibnPid($dk['id']);
						$eadr = $dalibnieks['eadr'];
					}
					else{
						$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
						$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
						$u_track->Save($text);
					}
				
				}
				$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id;
				
				$text = "<b>Maksâðana caur DNB-e-pasta izsûtîðana</b>:<br>";
				
				$no_redirect = null;
				$text .= "SendSummary($rez_id,$eadr,$no_redirect)";				
				$u_track->Save($text);
				require_once("../c_reservation.php");
				//if (isset($no_redirect)){
					SendSummary($rez_id, $eadr, $no_redirect,$maksajuma_summa);
				//}
				//else
				//	SendSummary($rez_id, $eadr);
				//header("Location:  ".$url);
				exit();		
				
			
		
				//header("Location: ".Application("site_base_url")."send_email.asp?type=confirm&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
			}
		}
		//maksâjums pieòemts izpildei
		else{
			
			$text = "<b>Maksâðana caur DNB</b>:<br>";
			$text .= $_SESSION["reg_err"] ;				
			$u_track->Save($text);
		}
	
	} else { //apmaksa neveiksmiga
	
		//dim $err_msg;
		
		Switch ($s_get["VK_T_STATUS"]){
			Case "3";
				$err_msg = "Maksâjums atcelts!";
				break;
			default:
				$err_msg = "Neveiksmîga maksâjuma izpilde. Sazinieties ar Impro.";
				break;
		}
 
 
		$_SESSION["reg_err"] = $err_msg;
		$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
		$text .= $_SESSION["reg_err"] ;				
		$u_track->Save($text);
 
	}
	
 
	//redirektee atpakal uz rezervaciju
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
 	$text = "<b>Maksâðana caur DNB-orderi nav izveidoti</b>:<br>";
	$text .= "url: $url";
	$u_track->Save($text);
	header("Location: ".$url);
	exit();
	//header("Location: ".$_SESSION['application']["site_base_url"]."c_reservation.php?f=Summary&rez_id=".$rez_id); //<----- edit production path
 
} else {
 
	//redirektee atpakal uz lietotaaja profilu
	$_SESSION["reg_err"] = "Kïûda: atbilde no bankas nav saòemta.";
	$url = $_SESSION['application']["site_base_url"]."c_home.php";
	$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
	$text .= $_SESSION["reg_err"] ;
	$text .= "<br>url: $url";				
	$u_track->Save($text);
	header("Location: ".$url); //<----- edit production path
	exit();
 
}

 


function BankReplyLogDnbnord($pGet) {
	global $db;
	$s_get=$pGet;
 
	$VK_SERVICE = $s_get["VK_SERVICE"];
	$VK_VERSION = $s_get["VK_VERSION"];
	$VK_SND_ID = $s_get["VK_SND_ID"];
	$VK_REC_ID = $s_get["VK_REC_ID"];	//$x;
	$VK_STAMP = $s_get["VK_STAMP"];
	$VK_T_NO = $s_get["VK_T_NO"];		//$x;
	$VK_AMOUNT = $s_get["VK_AMOUNT"];
	$VK_CURR = $s_get["VK_CURR"];
	$VK_REC_ACC = $s_get["VK_REC_ACC"]; //x
	$VK_REC_NAME = $s_get["VK_REC_NAME"]; //x
	$VK_REC_REG_ID = $s_get["VK_REC_REG_ID"]; //x
	$VK_REC_SWIFT = $s_get["VK_REC_SWIFT"]; //x
	$VK_SND_ACC = $s_get["VK_SND_ACC"]; //x
	$VK_SND_NAME = $s_get["VK_SND_NAME"]; //x
	$VK_REF = $s_get["VK_REF"]; 
	$VK_MSG = $s_get["VK_MSG"];
	$VK_T_DATE = $s_get["VK_T_DATE"];	//$x;
	$VK_T_STATUS = $s_get["VK_T_STATUS"]; //x
	$VK_MAC = $s_get["VK_MAC"];
	$VK_LANG = $s_get["VK_LANG"];
 
	//--- log bankas atbildi 
	if ($VK_SERVICE == "1102") {
		$values = array('VK_SERVICE' => $VK_SERVICE,
						'VK_VERSION' => $VK_VERSION,
						'VK_SND_ID' => $VK_SND_ID,
						'VK_REC_ID' => $VK_REC_ID,
						'VK_STAMP' => $VK_STAMP,
						'VK_T_NO' => $VK_T_NO,
						'VK_AMOUNT' => $VK_AMOUNT,
						'VK_CURR' => $VK_CURR,
						'VK_REC_ACC' => $VK_REC_ACC,
						'VK_REC_NAME' => $VK_REC_NAME,
						'VK_REC_REG_ID' => $VK_REC_REG_ID,
						'VK_REC_SWIFT' => $VK_REC_SWIFT,
						'VK_SND_ACC' => $VK_SND_ACC,
						'VK_SND_NAME' => $VK_SND_NAME,
						'VK_REF' => $VK_REF,
						'VK_MSG' => $VK_MSG,
						'VK_T_DATE' => $VK_T_DATE,
						'VK_T_STATUS' => $VK_T_STATUS,
						'VK_MAC' => $VK_MAC,
						'VK_LANG' => $VK_LANG
						
						);
		/*$ssql = "INSERT INTO trans_in_dnbnord(VK_SERVICE,
		VK_VERSION,VK_SND_ID,VK_REC_ID
		,VK_STAMP,VK_T_NO,VK_AMOUNT
		,VK_CURR,VK_REC_ACC,VK_REC_NAME
		,VK_REC_REG_ID,VK_REC_SWIFT
		,VK_SND_ACC,VK_SND_NAME,VK_REF,VK_MSG,
		VK_T_DATE,VK_T_STATUS,
		VK_MAC,VK_LANG) VALUES ('".$VK_SERVICE."','".$VK_VERSION."','".$VK_SND_ID."','".$VK_REC_ID."','".$VK_STAMP."','".$VK_T_NO."','".$VK_AMOUNT."','".$VK_CURR."','".$VK_REC_ACC."','".$VK_REC_NAME."','".$VK_REC_REG_ID."','".$VK_REC_SWIFT."','".$VK_SND_ACC."','".$VK_SND_NAME."','".$VK_REF."','".$VK_MSG."','".$VK_T_DATE."','".$VK_T_STATUS."','".$VK_MAC."','".$VK_LANG."') ";
		*/
	} else {
		echo "Nav atbildes";
	}
 
	if (isset($values)) {
		$result = $db->Insert('trans_in_dnbnord',$values);
		return  True;
	} else {
		return  False;
	}
	
}
//------------------------------------------------------------------------------

 
?>

