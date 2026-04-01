<?

//var_dump(http_response_code());
session_save_path('../tmp/') ;
session_start();

require_once('../m_init.php');
require_once('../m_profili.php');
require_once("../m_ligumi.php");
require_once("../m_user_tracking.php");
require_once('../m_online_rez.php');
$online_rez = new OnlineRez();
$u_track = new UserTracking();
$db = new Db;
$ligumi = new Ligumi();
$profili = new Profili();
require_once("i_bank_functions.php");
require_once("i_config.php");
$f_name = "get_seb_2.php";

//$sget = $_GET;  
/*$text = "<b>Maksâðana caur SEB</b>:<br>";
	$text .= "ip: romeote <br>";				
	$u_track->Save($text);*/
$ip = $_SERVER["REMOTE_HOST"];
/*$text = "<b>Maksâðana caur SEB</b>:<br>";
	$text .= "ip: $ip <br>";				
	$u_track->Save($text);*/
	
//08.08.2019 RT: nelasam bankas atbildi no db, bet òemam pa tieðo no get_seb.php $bank_response_data
$s_get = $bank_response_data;
//$query = "SELECT * FROM [merchant_session] WHERE [ip] = ? AND [hash] = ? AND [timestamp] >= DATEADD(minute,-50,GETDATE()) ";

$text = "<b>Maksâðana caur SEB</b>:<br>";
$text .= "bank response data: ".print_r($bank_response_data,true);
/*$text .= "qry: $query<br>";	
$text .= "ip:".$ip."<br>";	
$text .= "hash:".$hash['hash']."<br>";	*/
if ($r_method == "POST"){
	$u_track->Save($text);
}
else{
	Log2File($text,$f_name);
	//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." ".$text." \r\n\r\n",FILE_APPEND);
}

/*$params = array($ip,$hash['hash']);
$res = $db->Query($query, $params);*/
 
 if (empty($s_get)){
//if (!sqlsrv_has_rows($res)){
	//response.write query
	//response.end
	
	//Response.Write("url = "+Application("site_base_url"))
	//Response.end
	$values = array('teksts' => 'get_seb: merchant session error');
	$db->Insert('debug_log',$values);
	//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: merchant session error')");
 
	$_SESSION["reg_err"] = "Kïûda: merchant session error.";
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=c_home.php";	
	$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
	$text .= $_SESSION["reg_err"];
	if ($r_method == 'POST'){	
		$text .= "<br>url: $url";
	}
	else{
		Log2File($text,$f_name);
		//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." ".$text." \r\n\r\n",FILE_APPEND);
	}
	$u_track->Save($text);
	if ($r_method == 'POST'){
		//header("Location: ".$url);
		redirect($url);
	}		//<----- edit production path
	exit();
}
/*$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
$query = "SELECT * FROM [session_variables] WHERE session_id = ?";
$params = array($result["id"]);
$vars_result = $db->Query($query,$params);

$s_get = array();
while($vars = sqlsrv_fetch_array( $vars_result, SQLSRV_FETCH_ASSOC)){
	$var_key = $vars["key"];
	$var_value = $vars["value"];
	$s_get[$var_key] = $var_value;
}
 */
 


//--- ieraksta bankas atbildi zhurnaala tabulaa
 $values = array('teksts' => 'get_seb: before reply log');
$db->Insert('debug_log',$values);
//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: before reply log')");
 //var_dump($s_get);
 //echo "<br><br>";
 //die();
// var_dump(($s_get["IB_SERVICE"] == "0003" || $s_get["IB_SERVICE"] == "0004") );
 //die();
if (($s_get["IB_SERVICE"] == "0003" || $s_get["IB_SERVICE"] == "0004") && BankReplyLogSeb($s_get)) {
	
  $values = array('teksts' => 'get_seb: after reply log');
	$db->Insert('debug_log',$values);
	//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: after reply log')");
 
	//iegust no pamatojuma - rezervacijas id
	$msg = $s_get["IB_PAYMENT_DESC"];
	//echo $msg."<br>";
	$recipient = $s_get["IB_PAYMENT_ID"];
		
	//dim $arr;
	$arr = explode("_", $recipient);
	$recipient = $arr[0];
	$trans_id = $arr[1]; //--- maks. trans_id
	//echo "Trans_id $trans_id<br>";
	
	/*$regexp_string = "rez_id_+([0-9]+)";
	regexp.$Pattern = $regexp_string;
	Set $regexp_result = regexp.Execute($msg);*/
	//Response.Write("regexp_result="+)
	$re = "/rez_id[=|_]+([0-9]+)/";  
	preg_match($re, $msg, $matches);
	if (count($matches)==2){
		$rez_id = $matches[1];
	
		//ielogo atrasto rez_id	
		$text = "<b>Maksâðana caur SEB</b>:<br>";
		$text .= "apmaksâjamâ rezervâcija: $rez_id";		
		Log2File($text,$f_name);		
		$u_track->Save($text);
		//----------------------//	
		
	} else {
		//$_SESSION["reg_err") = "Kïûda: Nav rezervâcijas numura. Sazinieties ar Impro."
		//response.redirect(Application("site_base_url")&"rezervacija.asp") //<----- edit production path
		$error = "Kïûda: Nav rezervâcijas numura. Sazinieties ar Impro.";
		//echo $error;
		$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
		$text .= $error;	
		$u_track->Save($text);
		$values = array('teksts' => 'get_seb: nav numura');
		$db->Insert('debug_log',$values);
		exit();
		//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: nav numura')");

	}
 
 
	if ($s_get["IB_SERVICE"]=="0004" && $s_get["IB_STATUS"]=="CANCELLED") {
 
		//apmaksa neveiksmiga
 
		$_SESSION["reg_err"] = "Neveiksmîga maksâjuma izpilde!";
		$values = array('teksts' => 'get_seb: neveiksmiga maksajuma izpilde');
		$db->Insert('debug_log',$values);
		$text = "<b>Maksâðana caur SEB-maksâjums ir atcelts</b><br>";
					
		$u_track->Save($text,$rez_id);
		unset($_SESSION["reg_success"]);
		//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: neveiksmiga maksajuma izpilda')");
		
	} else {
	
		if ($s_get["IB_SERVICE"]=="0003") { //pienemts apstradei
 
			$_SESSION["reg_err"] = "Maksâjums pieòemts izpildei!";
			$values = array('teksts' => 'get_seb: maksajums pienemts izpildei');
			$db->Insert('debug_log',$values);
			//saglabâjam, ka rezervâciju pagaidâm nedrîkst dzçst!!!
			$values = array('no_delete' => 1);
			$db->Update('online_rez',$values,$rez_id);
			
			
			//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: maksajums pienemts izpildei')");
			$text = "<b>Maksâðana caur SEB</b>:<br>";
			$text .= $_SESSION["reg_err"]. " Rezervâcija #$rez_id";				
			$u_track->Save($text,$rez_id);
			unset($_SESSION["reg_success"]);
		} elseif($s_get["IB_SERVICE"]=="0004" && $s_get["IB_STATUS"]=="ACCOMPLISHED"){
	
			$_SESSION["reg_success"] = "Maksâjums veiksmîgi izpildîts!";
			$values = array('teksts' => 'get_seb: maksajums izpildits');
			$db->Insert('debug_log',$values);
			$text = "<b>Maksâðana caur SEB</b>:<br>";
			$text .= $_SESSION["reg_success"]. " Rezervâcija #$rez_id";				
			$u_track->Save($text,$rez_id);
			//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: maksajums izpildits')");
 
		}
		
		if (isset($_SESSION["reg_success"])) {
			$values = array('teksts' => 'get_seb: no errors');
			$db->Insert('debug_log',$values);
			//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: no errors')");
			$values = array('no_delete' => 1);
			$db->Update('online_rez',$values,$rez_id);
			//$db.$conn.execute("update online_rez set no_delete = 1 where id = " + CStr($rez_id));
 
			$_SESSION[$rez_id."_ligums_ok"] = $rez_id;
		
			//response.redirect(Application("site_base_url")&"celojums_ligums.asp")
 
			//dim $test,$str_ord_ids,$eadr;
			//test =res.save_ligums(user_id,g_id,$_SESSION["ImproLigums")) 
				//if ($rez_id==32681){
					$str_ord_ids = CreateDbOrders_new($rez_id, "seb", $trans_id); //izveidojam orderus
				/*}
				else $str_ord_ids = CreateDbOrders($rez_id, "seb", $trans_id); //izveidojam orderus*/
			//exit();
				
			//--- pirmajâ maks reizç apstiprina lîgumu 
			if (!$ligumi->IsAcceptedWithPayment($rez_id)) {
				$ligumi->AcceptWithPayment($rez_id);
			}
			
			if ($str_ord_ids!="" ) { //--- ja orderi tika izveidoti
			
				//--- nosuta apstiprinajuma epastu
				//dabû maksâjuma kopsummmu
				$summa = GetSumma($rez_id,$trans_id);
				
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
						$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
						$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
						$u_track->Save($text,$rez_id);
					}
				
				}
				$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id;
				
				$text = "<b>Maksâðana caur SEB-e-pasta izsûtîðana</b>:<br>";
				if ($r_method == "POST"){
					$no_redirect = null;
				}
				else $no_redirect = 1;
				$text .= "SendSummary($rez_id,$eadr,$no_redirect,$summa)";				
				$u_track->Save($text,$rez_id);
				require_once("../c_reservation.php");
				//if (isset($no_redirect)){
					SendSummary($rez_id, $eadr, $no_redirect,$summa);
				//}
				//else
					//SendSummary($rez_id, $eadr);
				//header("Location:  ".$url);
				exit();		
				//header("Location: ".Application("site_base_url")."send_email.asp?type=confirm&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
			}
		} else {
			$_SESSION["reg_err"] = "Neveiksmîga maksâjuma izpilde! Sazinieties ar Impro.";
			$values = array('teksts' => 'get_seb: neveiksme');
			$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
			$text .= $_SESSION["reg_err"] ;				
			//$u_track->Save($text);
			$db->Insert('debug_log',$values);
			//$db.$conn.execute("insert into debug_log (teksts) values ('get_seb: neveiksme')");
		}
	 
	}
	
 
	//redirektee atpakal uz rezervaciju
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
 	$text = "<b>Maksâðana caur SEB-orderi nav izveidoti</b>:<br>";
	if ($r_method == 'POST'){
		$text .= "url: $url";		
	}
	if ($r_method == "POST"){
		$u_track->Save($text,$rez_id);
	}
	else{
		Log2File($text,$f_name);
		//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." ".$text." \r\n\r\n",FILE_APPEND);
	}
	if ($r_method == 'POST'){
		//header("Location: ".$url);
		redirect($url);
	}
	else{
		header("HTTP/1.1 200 OK");
	}
	exit();
	//header("Location: ".Application("site_base_url")."rezervacija_detalas.asp?rez_id=".$rez_id); //<----- edit production path
 
} else {
 
	//redirektee atpakal uz lietotaaja profilu
	$_SESSION["reg_err"] = "Kïûda: atbilde no bankas nav saòemta.";
	$url = $_SESSION['application']["site_base_url"]."c_home.php";
	$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
	$text .= $_SESSION["reg_err"];				
	$u_track->Save($text);
	if ($r_method == 'POST'){
		redirect($url);
		//header("Location: ".$url); //<----- edit production path
	}
	exit();
 
}
 

?>

