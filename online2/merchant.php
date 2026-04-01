<?php
/*==============================*/
/* Merchant name: impro.lv      */
/* Merchant ID: 1186626         */
/*==============================*/
// Restore user session when gateway returns (cross-site POST does not send cookies).
// Requires merchant_log.php_session_id column (NVARCHAR(255) NULL).
if (isset($_GET['a']) && $_GET['a'] === 'finish' && !empty($_POST['trans_id'])) {
	require_once('m_init.php');
	$db_early = new Db;
	$result = $db_early->Query('SELECT php_session_id FROM merchant_log WHERE trans_id = ?', [$_POST['trans_id']]);
	if ($result) {
		$row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC);
		if ($row && !empty($row['php_session_id'])) {
			session_id($row['php_session_id']);
		}
	}
}
session_save_path('tmp/') ;
session_start();
require_once('m_init.php');
require_once('m_profili.php');
require_once("m_user_tracking.php");
$u_track = new UserTracking();
$db = new Db;
$profili = new Profili;

require_once("i_functions.php");

   
//------------------------
$filename = "bank\log\get".date("Y-m").".txt";
// logs failā
file_put_contents($filename,date("Y-m-d H:i:s")." GET MERCHANT ".print_r($_GET,true)."\r\n\r\n",FILE_APPEND);	

require_once("m_merchant_session.php");
$merchant_session = new MerchantSession();


if (($_GET['a'] == 'start') && $_GET['k']) {
	require_once('third_party/merchant/includes/config.php');
	$ecomm_url = $domain.':8443/ecomm/MerchantHandler';
	//connect_to_mssql();
	
	$session = CheckSession($_GET['k'], 20); //--- otrais parametrs time to live. default =1. 
												//--- 16.07.2013 izmaits ttl = 2, jo paradijusies atskiriba starp laikiem create_php_session (cls_celojumi.asp) un check_asp_session (php_functions.php). ka rezultataa sesijas ierakstu neatrod. izpildaas Error 2.

	if ($session) {
		$session_id = $db->MsEscapeString($session['id']);
		$trans_uid = $db->MsEscapeString($session['trans_uid']); //--- globas dalita maksajuma trans id (tabula trans_uid)

		$rez_id = $db->MsEscapeString($session['rez_id']);
		require_once("m_ligumi.php");
		$ligumi = new Ligumi();
		$ligums = $ligumi->GetRezId($rez_id);

		if(is_array($ligums)){ //--- izmainas 19.dec 2012. katru reizi generet ligumu nevajag. tikai pirmo reizi.
			$avanss = $ligums['avanss'];
		}
	
		require_once('third_party/merchant/includes/Merchant.php');
	
        
		$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);
		$description = iconv('Windows-1257', 'UTF-8', $session['description']);
		
		$ip = GetRealIpAddr();
		$summa = (int)($session['summa']*100);

		//die("$summa, $currency, $ip, $description, $language");
		//27500, 428, 95.68.105.190, Impro online rezervcija. Adventes laiks Bav... (rez_id=1184), lv

		$resp = $merchant -> startSMSTrans($summa, $currency, $ip, $description, $language);
		//var_dump($resp);

		
		if (substr($resp,0,14) == "TRANSACTION_ID") {
			$trans_id=urlencode(substr($resp,16,28));
			$url = $domain."/ecomm/ClientHandler?trans_id=$trans_id";

			$trans_id=substr($resp,16,28);
			$values = array('trans_id' => $trans_id,
							'amount' => $summa,
							'currency' => $currency,
							'client_ip_addr' => $ip,
							'description' => $description,
							'language' => $language,
							'result' => '???',
							'rez_id' => $rez_id,
							'trans_uid' => $trans_uid,
							'php_session_id' => session_id()
							);
			$result = $db->Insert('merchant_log',$values);
			if ($result) {
				$text = "<b>Maksāšana ar karti-pāradresējam uz maksāšanas lapu firstdata</b>:<br>";
				$text .= "url: ".$url;	
				$u_track->Save($text);
				header("Location: $url");
			} else {
				$error = 'Error 0 <a href="c_reservation.php?f=Summary">Atgriezties</a>';
				$text = "<b>Maksasana ar karti-kluda</b>:<br>";
				$text .= $error;	
				$u_track->Save($text);
				$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
				header("Location: $url");
			}

		} else {
			$error = 'Error 1 <a href="c_reservation.php?f=Summary">Atgriezties</a>';
			$text = "<b>Maksasana ar karti-kluda</b>:<br>";
			$text .= $error;	
			$u_track->Save($text);
			$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
			header("Location: $url");
		}
	} else {
		$error = 'Error 2 <a href="c_reservation.php?f=Summary">Atgriezties</a>';
		$text = "<b>Maksāšana ar karti-kļūda</b>:<br>";
		$text .= $error;	
		$u_track->Save($text);
		$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
		header("Location: $url");
	}
}else if (($_GET['a'] == 'finish') && isset($_GET['k']) && $_POST['trans_id']){
	require_once('third_party/merchant/includes/config.php');
	require_once('third_party/merchant/includes/connect.php');
	require_once('third_party/merchant/includes/Merchant.php');
	$ecomm_url = $domain.':8443/ecomm/MerchantHandler';

	$trans_id = urlencode($_POST['trans_id']);

	$ip = urlencode(GetRealIpAddr());

	$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

	$resp = $merchant -> getTransResult($trans_id, $ip);

	if($resp == 'RESULT: DECLINED'){
		$result_code = 'DECLINED';
	}else{
		$result_code = explode(':', $resp);
		$result_code = substr($result_code[2], 1, 3);
	}

	if(substr($resp,8,6) == 'FAILED'){
		$result_code = 'FAILED: '.$result_code;
	}

	$ok = substr($resp,8,2);
	$trans_id = $db->MsEscapeString($_POST['trans_id']);
	require_once("m_merchant_log.php");
	$merchant_log = new MerchantLog();
	$trans_result = $merchant_log->GetTransId($trans_id);
	$values = array('result' => $result_code,
					'response' => $resp);	
					
	$result = $merchant_log->Update($values,$trans_id);
	
	$rez_id = $trans_result['rez_id'];
	$trans_uid = $trans_result['trans_uid'];
	
	$hash = sha1('ms410a'.date('Y.m.d H:i:s').$ip.rand());
	$values = array('hash' => $hash,
					'ip' => $ip,
					'summa' => 0,
					'description' => '',
					'timestamp' => date("Y-m-d H:i:s"),
					'rez_id' => $rez_id,
					'trans_uid' => $trans_uid);
	$hash_result = $merchant_session->Insert($values);
	
	if ($result && $result_code == '000') {
		$url = "https://www.impro.lv/online/merchant_2.php?hash=".$hash."&a=finish&s=k";
		$text = "<b>Maks??ana ar karti-p?radres?jam</b>:<br>";
				$text .= $url;	
				$u_track->Save($text);
		header("Location: $url");
	} else {
		$url = "https://www.impro.lv/online/merchant_2.php?a=finish&rez_id=$rez_id&s=o&code=$result_code";
		$text = "<b>Maks??ana ar karti-p?radres?jam</b>:<br>";
				$text .= $url;	
				$u_track->Save($text);
		header("Location: $url");
		
	}
}else if (($_GET['a'] == 'finish') && isset($_GET['o'])){
	$error = 'Error 3 <a href="c_reservation.php?f=Summary">Turpin?t</a>';
	$text = "<b>Maks??ana ar karti-k??da</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
	header("Location: $url");
}else{
	$error = 'Error 4 <a href="c_reservation.php?f=Summary">Turpin?t</a>';
	$text = "<b>Maks??ana ar karti-k??da</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
	header("Location: $url");
}


//--------------------------------------------------------------------------------------------------------------------------------//
// Funkcijas																													  //
//--------------------------------------------------------------------------------------------------------------------------------//

function CheckSession($hash, $ttl = 1) {
	global $db;
	$hash = $db->MsEscapeString($hash);	
	$ttl = $db->MsEscapeString($ttl);
	$ip = GetRealIpAddr();
	$until = date("Y.m.d H:i:s",mktime(date('H'),date('i')-$ttl,date('s'),date('m'),date('d'),date('Y')));
	$sql = "SELECT * FROM [merchant_session] WHERE [ip] = ? AND [hash] = ? AND [timestamp] >= ?";
	$params = array($ip,$hash,$until);
	$result = $db->Query($sql,$params);
	$session = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
	return $session;
}




?>
