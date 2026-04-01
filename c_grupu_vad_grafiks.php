<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
$db = New Db();
require_once("online2/m_grupu_vaditaji.php");
$grupu_vad = new GrupuVaditaji();

$datums = $db->GetGet('datums');
print_r($datums);
if ($datums){	
	$tmp = explode("_",$datums);	
	$y = $tmp[0];
	$m = $tmp[1];
}
if (empty($y)){
	$y = date("Y");
}
if (empty($m)){
	$m = date("n");
}

$data = array();
$data['datums'] = $y."_".$m;
$data['menesis'] = array();
$data['menesis'][1] = 'Janvâris';
$data['menesis'][2] = 'Februâris';
$data['menesis'][3] = 'Marts';
$data['menesis'][4] = 'Aprîlis';
$data['menesis'][5] = 'Maijs';
$data['menesis'][6] = 'Jûnijs';
$data['menesis'][7] = 'Jûlijs';
$data['menesis'][8] = 'Augusts';
$data['menesis'][9] = 'Septembris';
$data['menesis'][10] = 'Oktobris';
$data['menesis'][11] = 'Novembris';
$data['menesis'][12] = 'Decembris';
$days_in_month = date('t',strtotime($y."-".$m."-"."01"));
$data['days_in_month'] = $days_in_month;

$data['grafiks'] = $grupu_vad->GrafiksMenesim($y,$m);
//var_dump($data);

require_once("v_grupu_vad_grafiks.php");

?>


