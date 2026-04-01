<?
//----------------------
// c_web_meklesana_log.php
//----------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once($_SESSION['path_to_files']."m_web_meklesana_log.php");
$db = New Db();
$log = new WebMeklesanaLog();


require_once($_SESSION['path_to_files']."i_functions.php");

$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'index';
if ($function == 'index') Index();
if ($function == 'edit') {
	Edit();
}
if ($function == 'TOPValstis') {
	TOPValstis();
}
if ($function == 'TOPKeywords') {
	TOPKeywords();
}
if ($function == 'TOPRegioni') {
	TOPRegioni();
}

function Index(){
	global $db;
	global $log;
	$datums_no = false;
	$datums_lidz = false;
	
	if (isset($_POST['subm'])){
		//svar_dump($_POST);
		$datums_no = $_POST['datums_no'];
		$datums_lidz = $_POST['datums_lidz'];
		
		$count = false;
	}
	else{
		$count = 200;
	}
	$data['log'] = $log->Get($count,$datums_no,$datums_lidz);
	//secho count($data['log']);
	//var_dump($data['autobusi']);
	require_once("v_web_meklesana_log.php");
}

//Biežāk meklētās valstis
function TOPValstis(){
	global $db;
	global $log;
	$datums_no = date("d.m.Y",strtotime("-7 days"));
	$datums_lidz = date("d.m.Y",strtotime("-1 day"));
	
	if (isset($_POST['subm'])){
		//svar_dump($_POST);
		$datums_no = $_POST['datums_no'];
		$datums_lidz = $_POST['datums_lidz'];	
	}
	
	$data['log'] = $log->GetTOPValstis($datums_no,$datums_lidz);
	require_once("v_web_meklesana_valstis.php");
}

//Biežāk meklētie atslēgas vārdi
function TOPKeywords(){
	global $db;
	global $log;
	$datums_no = date("d.m.Y",strtotime("-7 days"));
	$datums_lidz = date("d.m.Y",strtotime("-1 day"));
	
	if (isset($_POST['subm'])){
		//svar_dump($_POST);
		$datums_no = $_POST['datums_no'];
		$datums_lidz = $_POST['datums_lidz'];	
	}
	
	$data['log'] = $log->GetTOPKeywords($datums_no,$datums_lidz);
	require_once("v_web_meklesana_keywords.php");
}

//Biežāk meklētie atslēgas vārdi
function TOPRegioni(){
	global $db;
	global $log;
	$datums_no = date("d.m.Y",strtotime("-7 days"));
	$datums_lidz = date("d.m.Y",strtotime("-1 day"));
	
	if (isset($_POST['subm'])){
		//svar_dump($_POST);
		$datums_no = $_POST['datums_no'];
		$datums_lidz = $_POST['datums_lidz'];	
	}
	
	$data['log'] = $log->GetTOPRegioni($datums_no,$datums_lidz);
	require_once("v_web_meklesana_regioni.php");
}


?>