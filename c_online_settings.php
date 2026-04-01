<?
//-------------------------
// c_online_settings.php
//-------------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once($_SESSION['path_to_files']."m_init.php");
require_once($_SESSION['path_to_files']."m_settings.php");
$db = New Db();
$settings = new Settings();


require_once($_SESSION['path_to_files']."i_functions.php");


$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'index';
if ($function == 'index') Index();
if ($function == 'Vesture') {
	Vesture();
}
function Index(){
	global $db;
	global $settings;
	if (isset($_POST['submit'])){
		//var_dump($_POST);
		$values = $db->EscapeValues($_POST,'variable');
		//echo "values:<br>";
		//var_dump($values['variable']);
		$settings->UpdateBankas($values['variable']);
		
	}
	$data = $settings->GetBankas();
	//var_dump($data);
	require_once("v_online_settings.php");
}

function Vesture(){
	global $settings;
	$data = $settings->GetBankas();
	//var_dump($data);
	require_once("v_online_settings_vesture.php");
}

?>