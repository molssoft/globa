<?
session_save_path('../tmp/') ;
session_start();
date_default_timezone_set('Europe/Riga');
require_once('../m_init.php');
require_once("i_bank_functions.php");
require_once("i_config.php");
require_once("../m_user_tracking.php");
$u_track = new UserTracking();

$db = new Db;

//--- sanjem atbildi no bankas un paarbauda parakstu. talak ieraksta datus db, uzgeneree hash un padod to get_citadele_2.php ---///
//-------------------------------------------------------------------------------------------------------------///

// logs failâ
$filename = "log\get".date("Y-m").".txt";
file_put_contents($filename,date("Y-m-d H:i:s")." POST CITADELE ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);
//require_once '../xmlseclibs.php';
require_once('i_bank_functions.php');
//require_once 'XML/Serializer.php';
//require_once 'XML/Unserializer.php';
require_once '../third_party/xmlseclibs.php';
require_once '../third_party/XML/Serializer.php';
require_once '../third_party/XML/Unserializer.php';

//connect_to_mssql(); 

//testam
$_POST = array(

    "idd_hf_0" => "",
    "xmldata" => '<?xml version="1.0" encoding="UTF-8"?>
<FIDAVISTA xmlns="http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1 http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1/fidavista.xsd"><Header><Timestamp>20160912115929000</Timestamp><From>10000</From><Extension><Amai xmlns="http://digi.parex.lv/XMLSchemas/amai/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://digi.parex.lv/XMLSchemas/amai/ http://digi.parex.lv/XMLSchemas/amai/amai.xsd"><Request>PMTRESP</Request><RequestUID>57d66f13da</RequestUID><Version>1.0</Version><Code>100</Code><SignatureData><Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><Reference URI=""><Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>NMyi2CiqwENCPE0AlscQqa9bgzw=</DigestValue></Reference></SignedInfo><SignatureValue>MWQguA/HdbyC/+jeyILKMmUhbgtriDrZ6LUwSYVnteVuWZ0MYi1tSingKYv4Mq2Hc3YeNjbH6ZPq
ezvmzgam23tOGBS8tFHb40RTfWGB5VJy3lvLNSCFRJjaG6oNfQnUqZs9OC59xAl2MXeM/3TUq/oS
Wk5kp9KQbh8eTWV2Sj5WPNHYOz4b02GkTn18Npj3B6XUyNW9IgpOea9zGhPEtG+A57bmIeUI9zKd
nVIiTsMmo6aSsqwyEQ/oKDd1LB8S7Xvnb9V9NZhw/ZNiNruN/hnEgKtjYg8n2PU+wJa+G1L/YayL
ixAWpycOGgiH2EX7jau3LfU5i16pTozn0qJIHRm1zAqNMTtd6C3AASqnezoLKzar8C+NeWbQyPjN
dEIZO+i7wl9aNqkwXTG94xz/Ha2k0Bpw+X4o85ndcS2OcTZyV4yh3qExpTfIJx85a/OL2jhMUSXJ
6Kkt/7yESGnExHj5eHJw0Q5JWGEm/HSxAKq/5LQKJWnloe9PlWlYDZCvemRB+fBCYZz2W1g3uhHx
vw67AtiK+SxRRtf4guATGAaq40/i83Rbw3w5Le40MGUJOnH5gyBoE00lFJNS8753tTWoyZKkzXO4
mZufNCjNflLGwZggKi1dV5zOQzKrM0Uqv3QtT58V8CqEl1+iSxTmEcWoNzhfOzSX7ho+ID1i7XQ=</SignatureValue><KeyInfo><X509Data><X509SubjectName>CN=AMAI,OU=IT,O=Citadele Banka AS,L=Riga,ST=Unknown,C=LV</X509SubjectName><X509Certificate>MIIFazCCA1OgAwIBAgIENlLsbjANBgkqhkiG9w0BAQsFADBmMQswCQYDVQQGEwJMVjEQMA4GA1UE
CBMHVW5rbm93bjENMAsGA1UEBxMEUmlnYTEaMBgGA1UEChMRQ2l0YWRlbGUgQmFua2EgQVMxCzAJ
BgNVBAsTAklUMQ0wCwYDVQQDEwRBTUFJMB4XDTE0MDExNzE0NTg0NloXDTE5MDExNjE0NTg0Nlow
ZjELMAkGA1UEBhMCTFYxEDAOBgNVBAgTB1Vua25vd24xDTALBgNVBAcTBFJpZ2ExGjAYBgNVBAoT
EUNpdGFkZWxlIEJhbmthIEFTMQswCQYDVQQLEwJJVDENMAsGA1UEAxMEQU1BSTCCAiIwDQYJKoZI
hvcNAQEBBQADggIPADCCAgoCggIBAMkERaCZKMHu3hMUHbJmXYZnuKIIk9GhNzW4mkSmqcHaD845
wEFCXgN/PEV+4W/8XkHRd6jDeiEhDzIPts9kUsrWZGJ7yFw5vF/WGKlM6IYHF6immkCs3EibDvAu
rLwCpNhQcAXsf06visVFj3Sz4cbinqQfkZhPvYcaDR3KBwxBASFC+4xOJFkXDq2B2etZ6fkvmVGT
v5ONZ1Hli8EurU6gAaHD1uT4LCsKzyjyQCmzUfhjSz/qrt0Lqup445T3Jwp6Nswo2qKCf2McH7o5
Y58ZhyKBbpat4kmLDClFF8+DZOPN/YFLfRxXvy3gdYVZrWJ18kLTgPdynroCXrFRCYhRxNV8M13I
v9C6lFEAnTxqOvJG2SZHcmHI3sUIneqDqTBGNJhy0sxBmIZE9sxyd0q+YaJO1wZspc/8BBxuQg5X
5iXLt8mE21xczr3XtbWmj9wbWaLGZGRuR9mUWlszlGJm/ejaPN+ocTOo6D1kVUKoxHYy/J2uwC6P
MUgEW4tEZAEcJ6CZrm2FfqAiDWuk8/EHSpAX3rfTVJ27zF4Ztm0x/LbDMD0HvBklgQ+4fv+pDvzz
DGxdYDZAzEHuxoMKvQhzsO/ArrCN6HgU5+BYN/CHL3PMQ8+SAL9swOrv8rM6u7KGNIX8JAdaxTUa
MBxeDMnYnt/mXwCeXhVlcKkwFhD5AgMBAAGjITAfMB0GA1UdDgQWBBSDV1HGPdL5jDVKo84lY0Ai
v5MIXDANBgkqhkiG9w0BAQsFAAOCAgEABAD9oFeOC5zBGMVeSNNdLON0PPEAjVGs8dN5LHkYTPwL
/nNpcS89f58pHhbvuxoAZ1V8oPi60nTiun7xyeQPX6xUHFbBBvU9XEEMpdb5/ftiUia/g7kO/Xbz
H32QPYzIg+A2XE6Zt2EKi0S+TLotrV0Dw9cp5kEBzraZLUPuY1nbdcS1BgO80TeVoxzK5qnXTknD
KyW6E/kPcC9BJScZ/+JsMRF9a8moLQRgWVM3ZzVQxNEhCUfPma7csuSU2xqHkqWAcuZlaPTk12hh
BKcTj3TO/M+U5hvC87OHU9FmHkc58gfbCuXbsaqTv0egZDtdiSB+AxP5bAcZsSLLPkD1hlffbYMJ
01xa+k8dSWb/GVqJMHIrn7j7UnxsiYXBuEsl8ZOR/tZshgmf9TJVIQ5iswiHPmBB9rvcqFWE5OVg
EVBhvJjQBoxXdFWM9ZREdb6R91WX4eXl5ZjPxF8VfvF5jEQFtGLRsQNZx6XiSZKVhrrwEEHlVMbu
FwdLQghXKCNTXlmXjKAU2DK5ft2PcB5lHOWvEF3xQrINnghhCl9m7pz59pc8N1xDO2rtO1sb8j2J
weTfiQqwlKSf7HvEcd9SeJyCwu7BVHUUKabfUzDGxCSHImUgh1Ek3tG+lC/6HKlXaLflBkxu6J6E
2mDZKJl/gML22KQ59FtuhIOCJTs9OlU=</X509Certificate></X509Data></KeyInfo></Signature></SignatureData></Amai></Extension></Header></FIDAVISTA>
'
);

$url_php = "get_citadele_2.php";

//header("content-type: text/xml");
//print_r($_POST["xmldata"]);

LogPost($_POST);
//LogPost($fix);
//LogPost("check x");

$xml = $_POST["xmldata"];
//$xml = $fix;
//LogPost("check x 1");

if($xml==""){
	LogPost("citadele xml data error");
	die("data error");
}

//LogPost("check 0");

if(!verify($xml)){

	LogPost("citadele xml signature error");
	die("xml signature error");
}

//LogPost("check 1");

//print_r("xml izskatas ok<br>");
//print_r(xmlToArray($xml));
//die();

//check request timestamp
//....

$post_array	= xmlToArray($xml);
require_once("../m_merchant_session.php");
$merchant_session = new MerchantSession();			
$hash = $merchant_session->CreatePhpSession(0,0,'citadele', $post_array);

if ($hash) {
				
	LogPost(array("debug citadele hash id"=>$hash['id']));

	$query = "SELECT [key], CAST([value] as text) as v FROM [globa].[dbo].[session_variables] WHERE session_id = '".(int)$hash['id']."'";


	$res = $db->Query($query);

	$arr2 = array();
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		$arr2[$row['key']] = $row['v'];


	}	


	$ip=$_SERVER['REMOTE_ADDR'];

	//parbauda pieprasijuma veidu....
	if ($arr2["Request"]=="PMTRESP" || $arr2["Request"]=="PMTSTATRESP"){
		if ($arr2["Request"]=="PMTRESP") { //post redirect atgriezhoties no bankas
			
			LogPost("PMTRESP redirekts uz php_2 1");
			
			//--- redirekts uz asp
			//http tika nomainîts uz https 18.jul 2012
			//header('Location: '.$url_php.'?hash='.$hash['hash']."&ip=$ip");

			
		
		}else if ($arr2["Request"]=="PMTSTATRESP"){ //silent post. banka vienmeer suuta statusa atbildi.

			LogPost("PMTSTATRESP redirekts uz php_2 2");

			//$curl = $url_php."?hash=".$hash['hash']."&ip=$ip";
			//$output = connectPage($curl, "get");
			//exit();

		}
		$sget = array('hash' => $hash['hash'],'ip'=> $ip); 	
		//--------------------------
		// get_citadele_2.php
		//--------------------------
		
		//session_save_path('../tmp/') ;
		//session_start();
		//require_once('../m_init.php');
		require_once('../m_profili.php');
		require_once("../m_ligumi.php");
		//$db = new Db;
		$ligumi = new Ligumi();
		$profili = new Profili();
		

		//'lija krûkliòa
		 
		DebugLog("citadele php_2", "start ");
		 
		//secured.print_session
		//Response.Write("test asp "+Request.QueryString)
		//response.end
		 
		 
		//Set $db = $new $cls_db;
		//$sget = $_GET; 
		 
		DebugLog( "citadele php_2", "cls_db ");
		 
		//ip = Request.Servervariables("REMOTE_HOST")
		//ip = "192.168.1.132" //--- impro webservera ser-ww2 adrese
		//--- citadele sûta pieprasîjumu uz http. Tad serveris pârdirektç uz https un pieprasîjumam nomainâs ip uz servera ip.
		//--- ip saòem caur get
		$ip = $sget["ip"];
		 
		$query = "SELECT * FROM [merchant_session] WHERE [ip] = ? AND [hash] = ? AND [timestamp] >= DATEADD(minute,-50,GETDATE()) ";
		$params = array($ip,$sget['hash']);
		$res = $db->Query($query, $params);

		 //die($sget['hash']);
		 
		DebugLog( "hash", $sget["hash"]);
		DebugLog( "ip", $ip);
		 
		 
		//Response.Write(query)
		//Response.end
		if (!sqlsrv_has_rows($res)){

			//response.write query
			//response.end
			
			//Response.Write("url = "+Application("site_base_url"))
			//Response.end
			
			DebugLog( "reg_err", "Kïûda: merchant session error.");
			
			$_SESSION["reg_err"] = "Kïûda: merchant session error.";
			
			$text = "<b>Maksâðana caur Citadele-kïûda</b>:<br>";
			$text .= $_SESSION["reg_err"];	
			$u_track->Save($text);
			//header("Location: ../c_reservation.php?f=SavedReservations"); //<----- edit production path
			header("Location: ../c_home.php");
			exit();
			
		}


		$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);

		$query = "SELECT * FROM [session_variables] WHERE session_id = ?";

		$params = array($result["id"]);

		$vars_result = $db->Query($query,$params);

		//$query = "SELECT * FROM [session_variables] WHERE session_id = ".$result["id"];
		//SET $vars_result = $db.$Conn.Execute($query);
		//SET $s_get = CreateObject("Scripting.Dictionary");
		//response.write query&"<br>"
		while($res = sqlsrv_fetch_array( $vars_result, SQLSRV_FETCH_ASSOC)){


			$var_key = $res["key"];
			$var_value = ''.$res["value"];
			$s_get[$var_key] = $var_value;
			
			

		}
		 
		 
		/*Set $bank = $new $cls_bank;
		Set $res = $new $cls_rezervacijas;
		Set $email = $new $cls_email;
		 */
				
		//--- iegust rez_id no datubazes 
		if (($s_get["Request"] == "PMTRESP")) {
			$trans_id = $s_get["RequestUID"];

		} else { //--- PMTSTATRESP
			$trans_id = $s_get["ExtId"];  

		}

			
		$ssql = "SELECT * FROM trans_citadele WHERE RequestUID = ?";
		$params = array($trans_id);
		$res = $db->Query($ssql,$params);
		//set $rez = $db.$conn.execute($ssql);
		if (sqlsrv_has_rows($res)){
			while($rez = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			//var_dump($rez);
			//die();
				$rez_id = $rez["rez_id"];
				$s_get["rez_id"] = $rez_id;
				$trans_uid = $rez["trans_uid"]; 	
			} 
		}else {
			$_SESSION["reg_err"] = "Kïûda: transakcijas numurs nav atrasts. ".$ssql;
			$text = "<b>Maksâðana caur Citadele-kïûda </b>:<br>";
			$text .= $_SESSION["reg_err"];	
			$u_track->Save($text);
		}

		//----

		//---- iegust dalita maksajuma trans_uid


		//$arr = explode("_",$trans_uid);
		//$trans_uid = $arr[1];
		//----

		 
		DebugLog( "rez_id", ''.$rez_id);
		DebugLog( "reg_err", ''.$_SESSION["reg_err"]);
		DebugLog( "request", ''.$s_get["Request"]);

		if (($s_get["Request"] == "PMTRESP")) {
		 
			//todo check Timestamp	20120613130809000 

				Switch (floor($s_get["Code"])){
			
					Case 300: //Sistçmas kïûda
						
						$_SESSION["reg_err"] = "Neveiksmîga maksâjuma izpilde! Sistçmas kïûda.";
						BankReplyLogCitadele($s_get);
						$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
						$text .= $_SESSION["reg_err"];	
						$u_track->Save($text);
						break;			
						
					Case 200: //Lietotâjs atcçlis operâciju
						
						$_SESSION["reg_err"] = "Neveiksmîga maksâjuma izpilde! Lietotâjs atcçlis operâciju.";
						BankReplyLogCitadele($s_get); 
						$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
						$text .= $_SESSION["reg_err"];	
						$u_track->Save($text);
						break;	
						
					Case 100: //Pieprasîjums veiksmîgi apstrâdâts
					
						if (BankReplyLogCitadele($s_get)) { 

							$values = array('no_delete' => 1);
							$db->Update('online_rez',$values,$rez_id);
							//$db.$conn.execute("update online_rez set no_delete = 1 where id = " + CStr($rez_id));

							$_SESSION["reg_success"] = "Pieprasîjums veiksmîgi apstrâdâts"; 
							$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
							$text .= $_SESSION["reg_success"].'. Rezervâcija vairs nedzçsîsies';	
							$u_track->Save($text);
							
							$_SESSION[$rez_id."_ligums_ok"] = $rez_id;
							$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
							$text .= 'Veidojam orderus';	
							$u_track->Save($text);
							$str_ord_ids = CreateDbOrders($rez_id, "citadele", $trans_uid); //izveidojam orderus
			
							//--- pirmajâ maks reizç apstiprina lîgumu 
							if (!$ligumi->IsAccepted($rez_id)) {
									//ieliek atziimi, ka ligumam piekritis + ieraksta liguma id rezervacijas tabulâ.
									$ligumi->Accept($rez_id);
							}
							
							if ($str_ord_ids!="") { //--- ja orderi tika izveidoti
								$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
								$text .= 'Orderi tika izveidoti';	
								$u_track->Save($text);
								//--- nosuta apstiprinajuma epastu
								require_once("../m_profili.php");
								$profili = new Profili();	
								$result = $profili->GetOnlineRez($rez_id);
								//$query = "select p.* from online_rez o inner join profili p on p.id = o.profile_id where o.id = '".$rez_id."'";
								//reìistrçtam lietotâjam
								if (!empty($result)){
									//Set $result = $db.$Conn.execute($query);		
									if (!empty($result["eadr_new"] )) {
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
										$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
										$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
										$u_track->Save($text);
									}
								
								}
								if (empty($eadr)){
									$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
										$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
										$u_track->Save($text);
								}
								
									
								$text = "<b>Maksâðana caur Citadele - e-pasta izsûtîðana (rezervâcija $rez_id)</b>:<br>";
								if ($r_method == "POST"){
									$no_redirect = null;
								}
								else $no_redirect = 1;
								$text .= "SendSummary($rez_id,$eadr,$no_redirect)";				
								$u_track->Save($text);
								/*require_once("../c_reservation.php");
								if (isset($no_redirect)){
									SendSummary($rez_id, $eadr, $no_redirect);
								}
								else
									SendSummary($rez_id, $eadr);*/
							
								//header("Location: ".Application("site_base_url")."send_email.asp?type=confirm&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
								header("Location:  ".$_SESSION['application']["site_base_url"]."c_reservation.php?f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
									exit();
							}
							else{
								$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
								$text .= 'Orderi izveidoti jau iepriekð';	
								$u_track->Save($text);
							}
						}
						break;	
						
		 
					Default: //kïûda - neviens no zinâmiem kodiem
					
						$_SESSION["reg_err"] = "Neveiksmîga maksâjuma izpilde!";
						$text = "<b>Maksâðana caur Citadele-kïûda  - rezervâcija $rez_id</b>:<br>";
						$text .= $_SESSION["reg_err"];	
						$u_track->Save($text);
						break;
						
				}
			
			
				//Response.Write($_SESSION["reg_err"))
				//Response.end
			
				//redirektee atpakal uz rezervaciju
				$url = $_SESSION['application']["site_base_url"]."c_reservation.php?f=PaymentResult&rez_id=".$rez_id;			
			
				header("Location: ".$url);
				
			//	header("Location: ".$_SESSION['application']["site_base_url"]."c_reservation.php?f=Summary&rez_id=".$rez_id);
				exit();
				//header("Location: ".Application("site_base_url")."rezervacija_detalas.asp?rez_id=".$rez_id); 
		 
		} elseif ($s_get["Request"] = "PMTSTATRESP"){
			//--- bankas maksajuma statuss (silent post)
			DebugLog( "PMTSTATRESP", "begin");
			
			//--- parbauda vai nav jau atnakusi pozitiva atbilde
			//maksajums_result = bank.get_pieprasijumi(rez_id)
			
			//DebugLog( "PMTSTATRESP", "0"
			//DebugLog( "maksajums_result 0", maksajums_result
			
			//--- ieraksta jauno atbildi
			if (BankReplyLogCitadele($s_get)) { 
					
					
					DebugLog( "maksajums_result ", $maksajums_result);
					DebugLog( "StatCode", $s_get["StatCode"]);
					
					//--- tad, ja nav pozitivas atbildes
					//If maksajums_result <> 1 and s_get("StatCode") = "E" Then
					
					//	bank.get_pieprasijumi(rez_id) //izveido orderi un ligumu un aizsuta apstipr. epastu
						
					//	DebugLog( "PMTSTATRESP", "ok"
									
					//end if
					
				if ($s_get["StatCode"] == "E") {
					$values = array('no_delete' => 1);
					$db->Update('online_rez',$values,$rez_id);
									
					$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
					$text .= 'Rezervâcija vairs nedzçsîsies';	
					$u_track->Save($text);
					
					
					DebugLog( "PMTSTATRESP", "ok");
					$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
					$text .= 'Veidojam orderus';	
					$u_track->Save($text);
							
					$str_ord_ids = CreateDbOrders($rez_id, "citadele", $trans_uid); //izveidojam orderus
			
					//--- pirmajâ maks reizç apstiprina lîgumu 
					if (!$ligumi->IsAcceptedWithPayment($rez_id)) {
						$ligumi->AcceptWithPayment($rez_id);
					}
							
					if ($str_ord_ids!="") { //--- ja orderi tika izveidoti, nosuuta apst. epastu
						$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
						$text .= 'Orderi tika izveidoti';	
						$u_track->Save($text);	
						//--- nosuta apstiprinajuma epastu
						//$result = $ligumi->GetOnlineRez($rez_id);
						require_once("../m_profili.php");
						$profili = new Profili();	
						$result = $profili->GetOnlineRez($rez_id);
						//$query = "select p.* from online_rez o inner join profili p on p.id = o.profile_id where o.id = '".$rez_id."'";
						//reìistrçtam lietotâjam
						if (!empty($result)){
							//Set $result = $db.$Conn.execute($query);		
							if (!empty($result["eadr_new"] )) {
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
								$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
								$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
								$u_track->Save($text);
							}
						
						}
						if (empty($eadr)){
							$text = "<b>Maksâðana caur Citadele-kïûda (rezervâcija $rez_id)</b>:<br>";
								$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
								$u_track->Save($text);
						}
						//require_once("../l_email.php");
						//$email = new Email();
						//$result1 = $email->ReservationConfirmation($rez_id,0,$eadr,$trans_uid);	
						//header("Location:  ../c_reservation.php?f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
						$text = "<b>Maksâðana caur Citadele - e-pasta izsûtîðana (rezervâcija $rez_id)</b>:<br>";
						if ($r_method == "POST"){
							$no_redirect = null;
						}
						else $no_redirect = 1;
						$text .= "SendSummary($rez_id,$eadr,$no_redirect)";				
						$u_track->Save($text);
						require_once("../c_reservation.php");
						if (isset($no_redirect)){
							SendSummary($rez_id, $eadr, $no_redirect);
						}
						else
							SendSummary($rez_id, $eadr);
						exit();
					}
					else{
						$text = "<b>Maksâðana caur Citadele (rezervâcija $rez_id)</b>:<br>";
						$text .= 'Orderi nav izveidoti';	
						$u_track->Save($text);	
					}
				
				}	
			}
			
			DebugLog( "PMTSTATRESP", "end");
			
		} else {
			$text = "<b>Maksâðana caur Citadele-kïûda</b>:<br>";
			$text .= "Pieprasîjuma kïûda";
			$u_track->Save($text);
			echo "Pieprasîjuma kïûda";
		}
		 
		 
		 

		//----------------------------------------------------------------------------------------
		 
		
		//------------------------------------------------------------------------------




	}

	exit();

} else {
	LogPost("CreatePhpSession hash error");
	die('CreatePhpSession hash error');
}



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   /**
    * Verify xml request
    *
    * @param xml $xml
    * @return bool
    */
   function verify($xml){

      $doc = new DOMDocument();
      $doc->loadXML($xml);
      $objXMLSecDSig = new XMLSecurityDSig();

      if(!$objDSig = $objXMLSecDSig->locateSignature($doc)){
         throw new Exception("Cannot locate Signature Node");
      }
      $objXMLSecDSig->canonicalizeSignedInfo();
      $objXMLSecDSig->idKeys = array('wsu:Id');
      $objXMLSecDSig->idNS   = array('wsu'=>'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');

      if(!$retVal = $objXMLSecDSig->validateReference()){
         throw new Exception("Reference Validation Failed");
      }

      if(!$objKey = $objXMLSecDSig->locateKey()){
         throw new Exception("We have no idea about the key");
      }
      $key = NULL;

	  //print_r($objKey);

      $objKeyInfo = XMLSecEnc::staticLocateKeyInfo($objKey, $objDSig);

	  //echo "<br>so far.. <br>";

      // ja nav norâdîta atslçga, tad norâda to. ðajâ gadîjumâ nav vajadzîgs, jo tiek norâdîta xml`â
      //if(!$objKeyInfo->key && empty($key)){
      //  $objKey->loadKey($this->public_cert, TRUE);
      //}
      return $objXMLSecDSig->verify($objKey);
   }

      /**
    * Translates xml response into mixed array
    *
    * @param xml string $response
    * @return array
    */
   function xmlToArray($response){

      $unserializer = new XML_Unserializer();
      $status = $unserializer->unserialize($response);
	  //30.10.18 izmainīju izsaukšanu, lai nemet kļūdu PHP Strict Standards:  Non-static method PEAR::isError() should not be called statically in E:\globa\wwwroot\online2\bank\get_citadele_test.php on line 646
	   if ((new PEAR)->isError($status)){
		    //$status->getMessage(); //error message
         return false;
	   }
	   
     /* if(PEAR::isError($status)){
		    
         //$status->getMessage(); //error message
         return false;
      }*/
      return $unserializer->getUnserializedData();
   }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugLog($p_key, $p_val) {
			global $db;
			//dim $query, $db;
			//Set $db = $new $cls_db;
			$values = array('session_id' => '777',
							'[key]' => $p_key,
							'value' => $p_val
							);
			$db->Insert('session_variables',$values);
			//$query = "INSERT INTO [globa].[dbo].[session_variables] ([session_id], [key], [value]) VALUES ('777', '".$p_key."', '".$p_val."')";
			//Response.Write query&"<br>"
			//$db.$Conn.Execute($query);
		 
		}
		 
		 
		function BankReplyLogCitadele($pGet) {
			global $db;
			//--- ieraksta citadele bankas atbildi zurnaalaa 
			
			//dim $xml_body, Request, $RequestUID, $Code, $rez_id;
			//dim $b_time_stamp, $b_from, $b_extid, $b_doc_no, $b_statcode, $b_bookdate;
			//dim $ssql;
		 
			//xml_body = pGet("")
			$request = $pGet["Request"];
			$rez_id = $pGet["rez_id"];	
			
			if (($request == "PMTRESP")) {
				
				$Code = $pGet["Code"];	
				$Message = $pGet["Message"];
				$RequestUID = $pGet["RequestUID"];
			
				$values = array('Request' => $request,
								'RequestUID' => $RequestUID,
								'Code' => $Code,
								'Message' => $Message,
								'rez_id' => $rez_id
								);
				//$db->Insert
				$ssql = "INSERT INTO trans_in_citadele(Request,RequestUID,Code,Message,rez_id) " + _;
					   "VALUES ('".$request."','".$RequestUID."','".$Code."','".$Message."','".$rez_id."') ";
			
			} elseif ($request = "PMTSTATRESP") {
			
				$b_time_stamp = $pGet["Timestamp"];
				$b_from = $pGet["From"];
				$b_extid = $pGet["ExtId"];
				$b_doc_no = $pGet["DocNo"];
				$b_statcode = $pGet["StatCode"];
				$b_bookdate = $pGet["BookDate"];
				//--- pievienoti lauki AccNo un Name saskaòâ ar DigiLink versiju 2.4, 21.08.2012
				$b_accno = $pGet["AccNo"];
				$b_name = $pGet["Name"];
				
				//if b_statcode="E" then
				//	Code = "100"
				//else
				//	Code = "200"
				//end if
				
				$values = array('Request' => $request,
								'RequestUID' => $b_extid,
								'rez_id' => $rez_id,
								'b_from' => $b_from,
								'b_extid' => $b_extid,
								'b_doc_no' => $b_doc_no,
								'b_statcode' => $b_statcode,
								'b_bookdate' => $b_bookdate,
								'b_accno' => $b_accno,
								'b_name' => $b_name
								);
				/*$ssql = "INSERT INTO trans_in_citadele(Request,RequestUID,rez_id,b_from,b_extid,
				b_doc_no,b_statcode,b_bookdate,b_accno,b_name) " + _;
					   "VALUES ('".$request."','".$b_extid."','".$rez_id."',".$b_from.",'".$b_extid."',
					   '".$b_doc_no."','".$b_statcode."','".$b_bookdate."','".$b_accno."','".$b_name."')";
				*/
			}
			
			//query = "INSERT INTO [globa].[dbo].[session_variables] ([session_id], [key], [value]) VALUES ('777', 'debug query', '"&SQLText(ssql)&"')"
			//Response.Write query&"<br>"
			//db.Conn.Execute(query)
			
			//Response.Write(ssql)
			//Response.end
			
			if (isset($values)) {
				$result = $db->Insert('trans_in_citadele',$values);
				//Set $result = $db.$Conn.Execute($ssql);
				return  True;
			} else {
				return  False;
			}
		}
 

?>