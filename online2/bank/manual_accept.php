<?php
 session_start();
require_once('m_init.php');
require_once('m_profili.php');
require_once("m_ligumi.php");
$db = new Db;
$ligumi = new Ligumi();
$profili = new Profili();
require_once("i_bank_functions.php");
 
echo "first set parameters"; //<--- uncomment
exit(); //<--- uncomment to execute
 
//dim $res, $rez_id, $x, $trans_id, $bank_name;
//Set $res = $new $cls_rezervacijas;
 
$rez_id = 5396;						//<<<<----- $EDIT; 
$trans_id = "6CAD9803-43B0-4";		//<<<<----- $EDIT: $trans_uid ($bez $profile_id $sakuma);
 
//mk = maksajumu karte; 
//ib = swedbank internetbanka ; 
//dnbnord = dnbnord internetbanka ; 
//seb, citadele
 
$bank_name = "mk";					//<<<<----- $EDIT; 
 
 
$x = CreateDbOrders($rez_id, $bank_name, $trans_id); 
//res.accept_ligums(rez_id)
if ($x=="") {	
	echo "Rezervacijas ".$rez_id." orderi NAV izveidoti.";
} else {
	echo "Rezervacijas ".$rez_id." orderi ir izveidoti: ".$x;
}
 
//---!!!!!!! epasts netiek nosutits
 
//---!!!!!!! ja nepieciesams, pec tam manuali jaizmaina orderu izveidosanas datums
 
?>

