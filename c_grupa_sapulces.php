<?
//-------------------------------//
// Grupas ar nākotnes sapulces datumu un laiku
// c_grupa_sapulces.php
//------------------------------//
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init_utf.php");
require_once("online2/m_grupa_utf.php");
$db = new Db();

$function = isset($_GET['f']) ? $_GET['f'] : 'index';

if ($function == 'index') Index();

function Index()
{
	$grupa = new Grupa();
	$data = $grupa->GetFutureSapulces();
	$db = $grupa->db;
	require_once("v_grupa_sapulces.php");
}
?>
