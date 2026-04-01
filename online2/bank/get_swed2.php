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
			
$filename = "log\get".date("Y-m").".txt";
$rez_id = 0;


 
$re ="/rez-id-[=|_]+([0-9]+)/"; 
preg_match('/rez-id-(\d+)/', $bank_response_data['description'], $matches);
$rez_id = $matches[1];

$ruid = $db->QueryArray("select trans_uid from swedbank_trans where guid = ? and trans_uid is not null",[$guid]);
$trans_uid = $ruid[0]['trans_uid'];


$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";

$text .= "bank response data: ".print_r($bank_response_data,true);
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');	
if ($r_method == "POST"){
	$u_track->Save($text,$rez_id);
}
else{
	Log2File($text,$f_name);
}

$s_get = $bank_response_data;



//


//pārbaude vai jau nav izpildīts
$rEx = $db->QueryArray("SELECT * from swedbank_trans where guid =  ? and trans_uid = ? and status =  'EXECUTED'",[$guid,$trans_uid]);
if (count($rEx) > 0) {
	$db->Query("insert into swedbank_trans (guid,trans_uid,status) values (?,?,?)",[$guid,$trans_uid,'DUPLICATE']);
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
	header("Location: ".$url);
	exit();
}


// saglabājams statusu
$db->Query("insert into swedbank_trans (guid,trans_uid,status) values (?,?,?)",[$guid,$trans_uid,$bank_response_data["status"]]);

//--- ieraksta bankas atbildi zhurnaala tabulaa
if (BankReplyLog($s_get)) {
 
	//apmaksa veiksmiga
	if ($bank_response_data["status"] == "EXECUTED") {
		
		//apmaksa saņemta, atzīmējam lai rezervāciju neizdzēš, pat ja vēlāk orderi neizveidojas
		$values = array('no_delete' => 1,'deleted'=>0);
		$db->Query("update online_rez set no_delete = 1 where id = " . $rez_id);

		$_SESSION["reg_err"] = "Apmaksa izpildīta veiksmīgi!";
		$_SESSION[$rez_id."_ligums_ok"] = $rez_id;
		$text = "<b>Maksāšana caur Swedbank #$rez_id;</b>:<br>";
		$text .= "apmaksa saņemta, atzīmējam, lai rezervāciju neizdzēš, pat ja vēlāk orderi neizveidojas";	
		$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
		$u_track->Save($text,$rez_id);
			Log2File($text,$f_name);
		
		$process = true;
		$str_ord_ids = "";
		$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
		$text .= "mēģinām veidot orderus";	
		$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
		$u_track->Save($text,$rez_id);
		Log2File($text,$f_name);


		$str_ord_ids = CreateDbOrders($rez_id, "ib", $trans_uid); //izveidojam orderus

		if ($str_ord_ids!="") { //--- ja orderi tika izveidoti
			$text = "<b>Maksāšana caur Swedbank #$rez_id</b>:<br>";
			$text .= "orderi tika izveidoti";	
			$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text,$rez_id);
				Log2File($text,$f_name);
			//--- nosuta apstiprinajuma epastu
			//dabū maksājuma kopsummmu
			//$maksajuma_summa = GetSumma($rez_id,$ref);
			$maksajuma_summa = $bank_response_data['amount'];
			require_once("../m_profili.php");
			$profili = new Profili();	
			$result = $profili->GetOnlineRez($rez_id);
			
			if (!empty($result)){
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

				SendSummary($rez_id, $eadr, $no_redirect,$maksajuma_summa);

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

		http_response_code(200);
	}
 
} else {

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
