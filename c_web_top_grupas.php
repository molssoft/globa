<?
//----------------------
// c_web_top_grupas.php
// 22.05.2019 RT
//----------------------
session_start();
define("PATH_TO_FILES",'online2/');
require_once(PATH_TO_FILES."m_init.php");
require_once(PATH_TO_FILES."m_skatijumi.php");

$db = New Db();
$skatijumi = new Skatijumi();


require_once($_SESSION['path_to_files']."i_functions.php");

$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'index';
if ($function == 'index') Index();


function Index(){
	global $db;
	global $skatijumi;
	$datums_no = date("d.m.Y",strtotime("-7 days"));
	$datums_lidz = date("d.m.Y",strtotime("-1 day"));
	
	if (isset($_POST['subm'])){
		//svar_dump($_POST);
		$datums_no = $_POST['datums_no'];
		$datums_lidz = $_POST['datums_lidz'];
		
		
	}
	else{
		
	}
	$data['skatijumi'] = $skatijumi->GetTOPGroups($datums_no,$datums_lidz);
	//var_dump($data);

	require_once("v_web_top_grupas.php");
}


?>