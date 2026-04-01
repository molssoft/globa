<?
//------------------------------------------
// 21.01.2020 RT
// c_maks_termini.php
// Maksâjuma termiòi konkrçtam pieteikumam
//-----------------------------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once($_SESSION['path_to_files']."m_grupa.php");
require_once($_SESSION['path_to_files']."m_pieteikums.php");
require_once($_SESSION['path_to_files']."i_functions.php");
$db = New Db();
$piet = new Pieteikums();
$gr = new Grupa();
if (isset($_GET['pid'])){
	$pid = $_GET['pid'];
	$pieteikums = $piet->GetId($pid);
	$data['grupa'] = $gr->GetId($pieteikums['gid']);

	$min_summa = $piet->GetMaksMinSumma($pieteikums);
	//$iemaksas = $piet->GetMaksatPid($pid);
	
	if ($min_summa <0){
		$min_summa = 0;
	}

	$data['min_summa'] = CurrPrint($min_summa);
	$termini = $gr->GetPaymentDeadlinesId($pieteikums['gid']);
			
	$data['termini'] = array();
	if ($termini['term1_dat'] && $termini['term1_summa']){
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term1_dat']),
										'summa' => number_format(round($termini['term1_summa'],2),2,'.',' ')
										);
		
	}
	if ($termini['term2_dat'] && $termini['term2_summa']){
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term2_dat']),
										'summa' => number_format(round(($termini['term2_summa'] ),2),2,'.',' ')
										);
		
	}
	if ($termini['term3_dat']){
		$maksat = $piet->GetMaksatId($pid);
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term3_dat']),
									'summa' => CurrPrint($maksat['cena'])
										);
		
	}
			
	require_once("v_maks_termini.php");

}
else{
	exit('Nav norâdîts pieteikuma ID#');
}
?>