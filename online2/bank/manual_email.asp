<?
//------- nosuuta online rezervacijas apstiprinajuma epastu
//-------
//------- https://www.impro.lv/online/bank/manual_email.asp
//-------
//-------

session_start();
require_once('m_init.php');
require_once('m_profili.php');
require_once("m_ligumi.php");
$db = new Db;
$ligumi = new Ligumi();
$profili = new Profili();
require_once("i_bank_functions.php");
 
echo "first set parameters";	
exit();							//<--- $comment to execute;
 
//dim $rez_id, $trans_id;
//dim $recipient_id, $eadr, $result;
 
//Set $db = $new $cls_db;
 
$rez_id = 9018;						//<<<<----- $EDIT; 
$trans_id = "6E333DCC-EAD8-4";		//<<<<----- $EDIT:	$trans_uid ($bez $profile_id $sakuma);
 
$recipient_id = 1478;					//<<<<----- $EDIT:	$dalibnieka $online $profila $id;
 
 
//--- nosuta apstiprinajuma epastu	
 
			//$query = "SELECT * FROM [profili] WHERE [id] = '".$recipient_id."'  ";
 
			//Set $result = $db.$Conn.execute($query);
			$result = $profili->GetId($recipient_id);
			if ($result["eadr_new"] != "") {
				$eadr = $result["eadr_new"];
			} else {
				$eadr = $result["eadr"];
			}
			
			//eadr = "nils@molssoft.lv" //<<<<-------DEBUG email
 	
			header("Location: ".Application("site_base_url")."send_email.asp?type=confirm&rez_id=".$rez_id."&recipient=".$eadr."&trans_id=".$trans_id);
 
 
//----------------------------------
?>

