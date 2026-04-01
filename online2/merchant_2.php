<?php
$s_get = $_GET; 
//var_dump($s_get);
//echo "<br><br>";

session_save_path('tmp/') ;
session_start();
require_once("m_init.php");
$db = new Db;
require_once("bank/i_bank_functions.php");
require_once("bank/i_config.php");
require_once("m_user_tracking.php");
$u_track = new UserTracking();
$filename = "log\get".date("Y-m").".txt";

$rez_id = (int)$s_get["rez_id"];

if (($s_get["a"] == "start")) {
 
	?>


<? 
} elseif ($s_get["a"] == "finish" && $s_get["s"] == "k"){


	$ip = $_SERVER["REMOTE_HOST"];
	

	
	$query = "SELECT * FROM [merchant_session] WHERE [ip] = '".$ip."' AND [hash] = '".$s_get["hash"]."' AND [timestamp] >= DATEADD(minute,-50,GETDATE()) ";
	//echo $query."<br>";

	$res= $db->Query($query);
	//var_dump($res);
	//SET $result = $db.$Conn.Execute($query);
	
	//Response.Write(query)
	//Response.end
	$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC); 

	//echo "<br><br>";
	if ($result) {
		//echo "rersult";

				//die('a');
		$rez_id = $result["rez_id"];
		
		//----
		//dim $arr, $recipient;
		
		$recipient =  $result["trans_uid"];
		//var_dump($recipient);

		//echo "<br><br>";
		//$arr = explode("_",$recipient);
		//$recipient = $arr[0];
		//$trans_id = $arr[1];
		$trans_id = $result["trans_uid"];
		//----

		$str_ord_ids = CreateDbOrders($rez_id, "mk", $trans_id);
		//var_dump($str_ord_ids);
		//--- pirmajâ maks reizç apstiprina lîgumu ar maksâjumu (payment_accepted)
		//require_once("m_ligumi.php");
		//$ligumi = new Ligumi();
		//if (!$ligumi->IsAccepted($rez_id)) {
		//	$ligumi->Accept($rez_id);
		//}
					
		if ($str_ord_ids!="") { //--- ja orderi tika izveidoti
		
			$_SESSION["reg_err"] = "Apmaksa izpildîta veiksmîgi!";
			$_SESSION[$rez_id."_"."ligums_ok"] = $rez_id;
			
			$values = array('no_delete' => 1);
			$db->Update('online_rez',$values,$rez_id);
			//--- nosuta apstiprinajuma epastu
			//dabû maksâjuma kopsummmu
			$maksajuma_summa = GetSumma($rez_id,$trans_id);
			
			//Set result = res.get_reservations_details(rez_id,0, recipient) //$_SESSION["user_id")
			//email = result("eadr")
			
			//$query = "SELECT * FROM [profili] WHERE [id] = '".$recipient."'  ";
 
			//Set $result = $db.$Conn.execute($query);
			require_once("m_profili.php");
		
			$profili = new Profili();	
			$result = $profili->GetOnlineRez($rez_id);
			//reìistrçtam lietotâjam
			if (!empty($result)){
				//$query = "select p.* from online_rez o inner join profili p on p.id = o.profile_id where o.id = '".$rez_id."'";
				
				if ($result["eadr_new"] != "") {
					$eadr = $result["eadr_new"];
				} else {
					$eadr = $result["eadr"];
				}
			}
			//nereìistrçtam lietotâjam, pçrkot dk:
			else{
				require_once("m_pieteikums.php");
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
					$text = "<b>Maksâðana ar karti-kïûda</b>:<br>";
					$text .= "Nav atrasta e-adrese, uz ko izsûtît apstiprinâjumu";				
					$u_track->Save($text);
				}
			
			}
			$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=ok&f=SendSummary&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id."&summa=".$maksajuma_summa;
			$text = "<b>Maksâðana ar karti-e-pasta izsûtîðana</b>:<br>";
			$text .= "url : $url";				
			$u_track->Save($text);
			header("Location:  ".$url);
		
		} else {

			//redirektee atpakal uz rezervaciju
			$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
			$text = "<b>Maksâðana ar karti-orderi nav izveidoti</b>:<br>";
			$text .= "url : $url";				
			$u_track->Save($text);
			header("Location: ".$url);
			
			//header("Location: ".Application("site_base_url")."rezervacija_detalas.asp?rez_id=".$rez_id); //<----- edit production path
		}
		
	} else {
			file_put_contents($filename,date("Y-m-d H:i:s")." merchant_2.php (rez_id=".$rez_id.") => query ".$query." with ip=".$ip." and hash=".$s_get['hash']." returned 0 rows \r\n\r\n",FILE_APPEND);
		//rez_id = s_get("rez_id")
		//$_SESSION["reg_err") = "Apmaksa izpildîta neveiksmîgi!"
		
		//---log failed session attempt
		LogPost(array('error merchant log'=> "invalid session hash or timeout. [ip] = ".$ip.", [hash] = ".$s_get["hash"]));
		//$query= "insert into session_variables(session_id, [key],[value]) values(9999,'error merchant log', 'invalid session hash or timeout. [ip] = ".$ip.", [hash] = ".$s_get["hash"].", date = '+cast(getdate() as varchar))";
		//Set $result = $db.$Conn.execute($query);
		$result = $db->Query($query);
		//ðito jâatkomentç atpakaï:
		$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
		$_SESSION["reg_err"] = "Kïûda: merchant session error.";
		$text = "<b>Maksâðana ar karti-kïûda</b>:<br>";
		$text .= $_SESSION["reg_err"];	
		$text .= "url: $url";
		$u_track->Save($text);
		header("Location: ".$url);
		
		//header("Location: ".Application("site_base_url")."rezervacija.asp");	
			
	}
	
} elseif ($s_get["a"] == "finish" && $s_get["s"] == "o") {
	$rez_id = $s_get["rez_id"];
	$skaidrojums = "";
	if  (isset($s_get['code']) && !empty($s_get['code'])){
		$code = $s_get['code'];
		require_once("m_merchant_response_codes.php");
		$resp_codes = new MerchantResponseCodes;
		$skaidrojums = $resp_codes->GetByCode($code);
	}
	$_SESSION["reg_err"] = "Apmaksa izpildîta neveiksmîgi! ".$skaidrojums;
	$url = $_SESSION['application']["site_base_url"]."c_reservation.php?result=failed&f=PaymentResult&rez_id=".$rez_id;
	$text = "<b>Maksâðana ar karti-kïûda</b>:<br>";
	$text .= $_SESSION["reg_err"]."<br>";
	$text .= "url: $url";		
	$u_track->Save($text);
	header("Location: ".$url);
		
	//header("Location: ".Application("site_base_url")."rezervacija_detalas.asp?rez_id=".$rez_id);
}
?>