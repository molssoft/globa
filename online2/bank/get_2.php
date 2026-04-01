<?
session_save_path('../tmp/') ;
session_start();
require_once('../m_init.php');
require_once('../m_profili.php');
require_once('../m_ligumi.php');
require_once("i_config.php");
require_once("i_bank_functions.php");
require_once("../m_user_tracking.php");
$u_track = new UserTracking();
$ligumi = new Ligumi();
$db = new Db;
$f_name = "get_2.php";

//$text = "<b>get_2.php sākums</b><br>";						
//$u_track->Save($text);
			
$filename = "log\get".date("Y-m").".txt";
$rez_id = 0;
$msg = $s_get["VK_MSG"];
$re ="/rez_id[=|_]+([0-9]+)/"; 
preg_match($re, $msg, $matches);
$rez_id = $matches[1];
 
 
 
 
//$db = $new $cls_db;
//$sget = $_GET;  
//08.08.2019 RT: nelasam bankas atbildi no db, bet ņemam pa tiešo no get_sen.php $bank_response_data
$s_get = $bank_response_data;


$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";

$text .= "bank response data: ".print_r($bank_response_data,true);
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');	
if ($r_method == "POST"){
	$u_track->Save($text,$rez_id);
}
else{
	Log2File($text,$f_name);
	//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." ".$text." \r\n\r\n",FILE_APPEND);
}
/*$text .= "qry: $query<br>";	
$text .= "ip:".$ip."<br>";	
$text .= "hash:".$sget['hash']."<br>";	
Log2File($text,$f_name);

$res = $db->Query($query, $params);*/


 if (empty($s_get)){
//if (!sqlsrv_has_rows($res)){

	$url = $_SESSION['application']["site_base_url"]."c_home.php";
			
	$_SESSION["reg_err"] = "Kļūda: merchant session error.";
	$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
	$text .= $_SESSION["reg_err"];
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
	$u_track->Save($text,$rez_id);
	Log2File($text,$f_name);
	//file_put_contents($filename,date("Y-m-d H:i:s")." get_2.php (rez_id=".$rez_id.") => query ".$query." with ip=".$ip." and hash=".$sget['hash']." returned 0 rows - SESIJA NAV ATRASTA, beidzam apstrādi \r\n\r\n",FILE_APPEND);
	
	header("Location: ".$url);

	//header("Location: ".$_SESSION['application']["site_base_url"]."c_reservation.php?f=SavedReservations");
}
else{
	$text = "merchant_session atrasta, turpinām";
	Log2File($text,$f_name);
	//file_put_contents($filename,date("Y-m-d H:i:s")." get_2.php (rez_id=".$rez_id.") => query ".$query." with ip=".$ip." and hash=".$sget['hash']." returned rows - SESIJA ATRASTA, turpinām \r\n\r\n",FILE_APPEND);
	
}


 
//---pievienots 31/01/2013: parbaude vai viena pozitiva atbilde jau ir sanjemta. 
//---lai talak nenotiktu otreizeja apstrade.
$process = false;
$msg = $s_get["VK_MSG"];
$exmsg = explode("/",$msg);
$ref = $exmsg[2];
if ($s_get["VK_SERVICE"] == "1101") {

	//'db.Conn.BeginTrans  //*** Transaction Start ***' 
	
	$query = "select * from bankas_pieprasijumi where vk_service like '1101' and vk_ref like ?";
	$params = array($ref);
	$text = "Meklē, vai jau nav saņemta pozitīva atbilde:".$query." => ".print_r($params,true);
	Log2File($text,$f_name);

	$result = $db->Query($query,$params);
	//SET $result = $db.$Conn.Execute($query);
	if (!sqlsrv_has_rows($result)){//---atbildes vel nav

		//if ($result.$eof) { //---atbildes vel nav
		$process=true;
		$text = "Pozitīvas atbildes vēl nav (bankas_pieprasijumi), varēsim veidot orderus";
		Log2File($text,$f_name);
		
		
	}
	else{
	
		$text = "Pozitīva atbilde jau ir reģistrēta (bankas_pieprasijumi), nevarēsim veidot orderus";
		Log2File($text,$f_name);
	}
	//file_put_contents($filename,date("Y-m-d H:i:s")." get_2.php (rez_id=".$rez_id.") => query ".$query." with vk_ref=".$s_get["VK_REF"]." returned ".(int)$process." - (0- VEIDOSIM orderus, 1- NEVEIDOSIM orderus) \r\n\r\n",FILE_APPEND);


}
//---


//--- ieraksta bankas atbildi zhurnaala tabulaa
if (BankReplyLog($s_get)) {
 
	//'If s_get("VK_SERVICE") = "1101" Then db.Conn.CommitTrans //*** Commit Transaction ***'
	
	//iegust no pamatojuma - rezervacijas id
	$msg = $s_get["VK_MSG"];
	$trans_id = $ref;		//--- $izmaiņ$as!!! $trans_id;

	$re ="/rez-id-([0-9]+)/"; 
	preg_match($re, $msg, $matches);
	$rez_id = $matches[1];
 
	//apmaksa veiksmiga
	if ($s_get["VK_SERVICE"] == "1101") {
		
		//apmaksa saņemta, atzīmējam lai rezervāciju neizdzēš, pat ja vēlāk orderi neizveidojas
		$values = array('no_delete' => 1,'deleted'=>0);
		//$db->Update('online_rez',$values,$rez_id);
		$db->Query("update online_rez set no_delete = 1 where id = " . $rez_id);

		//$db.$Conn.execute("update online_rez set no_delete = 1 where id = " + CStr($rez_id));
 
		$_SESSION["reg_err"] = "Apmaksa izpildīta veiksmīgi!";
		$_SESSION[$rez_id."_ligums_ok"] = $rez_id;
		$text = "<b>Maksāšana caur Swedbank #$rez_id;</b>:<br>";
		$text .= "apmaksa saņemta, atzīmējam, lai rezervāciju neizdzēš, pat ja vēlāk orderi neizveidojas";	
		$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
		$u_track->Save($text,$rez_id);
			Log2File($text,$f_name);
		//dim $str_ord_ids, $eadr;
		
		$process = true;
		$str_ord_ids = "";
		if ($process==true) {

			$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
			$text .= "mēģinām veidot orderus";	
			$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text,$rez_id);
			Log2File($text,$f_name);


			
			$str_ord_ids = CreateDbOrders($rez_id, "ib", $ref); //izveidojam orderus
			//die($str_ord_ids);
		}
		else{
			$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
			$text .= "orderus neveido";	
			$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text,$rez_id);
			Log2File($text,$f_name);
		}

		//--- pirmajā maks reizē apstiprina līgumu 
		// -- tagad līgumam jau jābūt apstiprinātam pirms maksāšanas
		//if (!$ligumi->IsAcceptedWithPayment($rez_id)) {
		
			//ieliek atziimi, ka ligumam piekritis + ieraksta liguma id rezervacijas tabulā.
			//$ligumi->AcceptWithPayment($rez_id);
		
		//}
		
		if ($str_ord_ids!="") { //--- ja orderi tika izveidoti
			$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
			$text .= "orderi tika izveidoti";	
			$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text,$rez_id);
				Log2File($text,$f_name);
			//--- nosuta apstiprinajuma epastu
			//dabū maksājuma kopsummmu
			$maksajuma_summa = GetSumma($rez_id,$ref);
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
			//nereģistrētam lietotājam, pērkot dk:
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
					$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
					$text .= "Nav atrasta e-adrese, uz ko izsūtīt apstiprinājumu";		
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');						
					$u_track->Save($text,$rez_id);
				}
			
			}
			
			$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id;
			
			$text = "<b>Maksāšana caur Swedbank-e-pasta izsūtīšana</b>:<br>";					
			$text .= "SendSummary($rez_id,$eadr)";	
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text,$rez_id);
			require_once("../c_reservation.php");
			//if (isset($no_redirect)){
				SendSummary($rez_id, $eadr, $no_redirect,$maksajuma_summa);
			//}
			//else
				//SendSummary($rez_id, $eadr);
			

			
			//$text .= "url : $url";				
			//$u_track->Save($text);
			//header("Location:  ".$url);
			die();
		
		}
		$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
		$text = "<b>Maksāšana caur Swedbank #$rez_id - orderi nav izveidoti</b>:<br>";
		$text .= "url : $url";
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');			
		$u_track->Save($text,$rez_id);
	//apmaksa neveiksmiga
	} elseif ($s_get["VK_SERVICE"] == "1901"){
 
		$_SESSION["reg_err"] = "Neveiksmīga maksājuma uzdevuma izpilde!";
		$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
		$text .= $_SESSION["reg_err"];	
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');			
		$u_track->Save($text,$rez_id);
	}
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
 	/*$text = "<b>Maksāšana caur Swedbank-orderi nav izveidoti</b>:<br>";
	$text .= "url : $url";				
	$u_track->Save($text);*/
	if ($r_method == "POST"){
		$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
			$text .=  "Nesūtām swedbankai 200ok atbildi,POST pieprasījums";
		//redirektee atpakal uz rezervaciju
		header("Location: ".$url);
	}
	else{
		$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
		$text .=  "sūtām swedbankai 200ok atbildi";
		Log2File($text,$f_name);
		//header("HTTP/1.1 200 OK");
		http_response_code(200);
	}
 
} else {
 
	//'db.Conn.CommitTrans //*** Commit Transaction ***'
	
	//redirektee atpakal uz lietotaaja profilu
	$_SESSION["reg_err"] = "Kļūda: atbilde no bankas nav saņemta.";
	$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
	$text .= $_SESSION["reg_err"];		
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
	$u_track->Save($text);
	
	header("Location: ".$_SESSION['application']["site_base_url"]."c_home.php");
 
}

 
function BankReplyLog($pGet) { //swedbank
	$f_name = "BankReplyLog (get_2.php)";
	global $db;
	//dim $s_get, $ssql;
	//dim $VK_SERVICE,$VK_VERSION,$VK_SND_ID,$VK_REC_ID,$VK_STAMP,$VK_T_NO,$VK_AMOUNT,$VK_CURR,$VK_REC_ACC,$VK_REC_NAME,$VK_SND_ACC,$VK_SND_NAME,$VK_REF,$VK_MSG,$VK_T_DATE,$VK_MAC,$VK_LANG,$VK_AUTO;
 
	$s_get=$pGet;
 
	$VK_SERVICE = $s_get["VK_SERVICE"];
	$VK_VERSION = $s_get["VK_VERSION"];
	$VK_SND_ID = $s_get["VK_SND_ID"];
	$VK_REC_ID = $s_get["VK_REC_ID"];
	$VK_STAMP = $s_get["VK_STAMP"];
	$VK_T_NO = $s_get["VK_T_NO"];
	$VK_AMOUNT = $s_get["VK_AMOUNT"];
	$VK_CURR = $s_get["VK_CURR"];
	$VK_REC_ACC = $s_get["VK_REC_ACC"];
	$VK_REC_NAME = $s_get["VK_REC_NAME"];
	$VK_SND_ACC = $s_get["VK_SND_ACC"];
	$VK_SND_NAME = $s_get["VK_SND_NAME"];
	$VK_REF = $s_get["VK_REF"];
	$VK_MSG = $s_get["VK_MSG"];
	$VK_T_DATE = $s_get["VK_T_DATE"];
	$VK_MAC = $s_get["VK_MAC"];
	$VK_LANG = $s_get["VK_LANG"];
	$VK_AUTO = $s_get["VK_AUTO"];
 
	//--- log bankas atbildi 1101 vai 1901
	if ($VK_SERVICE == "1101") {
 
		$ssql = "INSERT INTO bankas_pieprasijumi (VK_SERVICE,VK_VERSION,VK_SND_ID,VK_REC_ID,VK_STAMP,VK_T_NO,VK_AMOUNT,VK_CURR,VK_REC_ACC,VK_REC_NAME,VK_SND_ACC,VK_SND_NAME,VK_REF,VK_MSG,VK_T_DATE,VK_MAC,VK_LANG,VK_AUTO) VALUES ('".$VK_SERVICE."','".$VK_VERSION."','".$VK_SND_ID."','".$VK_REC_ID."','".$VK_STAMP."','".$VK_T_NO."','".$VK_AMOUNT."','".$VK_CURR."','".$VK_REC_ACC."','".$VK_REC_NAME."','".$VK_SND_ACC."','".$VK_SND_NAME."','".$VK_REF."','".$VK_MSG."','".$VK_T_DATE."','".$VK_MAC."','".$VK_LANG."','".$VK_AUTO."') ";
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
						'VK_SND_ACC' => $VK_SND_ACC,
						'VK_SND_NAME' => $VK_SND_NAME,
						'VK_REF' => $VK_REF,
						'VK_MSG' => $VK_MSG,
						'VK_T_DATE' => $VK_T_DATE,
						'VK_MAC' => $VK_MAC,
						'VK_LANG' => $VK_LANG,
						'VK_AUTO' => $VK_AUTO
						);
	} elseif($VK_SERVICE = "1901"){
		
		//$ssql = "INSERT INTO bankas_pieprasijumi (VK_SERVICE,VK_VERSION,VK_SND_ID,VK_REC_ID,VK_STAMP,VK_REF,VK_MSG,VK_MAC,VK_LANG,VK_AUTO) VALUES('".$VK_SERVICE."','".$VK_VERSION."','".$VK_SND_ID."','".$VK_REC_ID."','".$VK_STAMP."','".$VK_REF."','".$VK_MSG."','".$VK_MAC."','".$VK_LANG."','".$VK_AUTO."')";
		$values = array('VK_SERVICE' => $VK_SERVICE,
						'VK_VERSION' => $VK_VERSION,
						'VK_SND_ID' => $VK_SND_ID,
						'VK_REC_ID' => $VK_REC_ID,
						'VK_STAMP' => $VK_STAMP,
						'VK_REF' => $VK_REF,
						'VK_MSG' => $VK_MSG,
						'VK_MAC' => $VK_MAC,
						'VK_LANG' => $VK_LANG,
						'VK_AUTO' => $VK_AUTO
						);
	} else {
		$text = "Nav atbildes no bankas";
			Log2File($text,$f_name);
		//echo "Nav atbildes";
	}
 
	if (isset($values)) {
	//'response.write ssql
		$text = "Insert into bankas_pieprasijumi VALUES ".print_r($values,true);
		Log2File($text,$f_name);
		$result = $db->Insert('bankas_pieprasijumi',$values);
		//Set $result = $db.$Conn.Execute($ssql);
		return  True;
	} else {
		$text = "neveic insertu bankas_pieprasijumi";
		Log2File($text,$f_name);
		return  False;
	}
	
 
}




 







?>
