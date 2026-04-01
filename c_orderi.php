<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_orderis.php");
require_once("online2/m_tiesibas.php");
$db = New db();
$ord = new Orderis();
$tiesibas = new Tiesibas();
$function = $_GET['f'];
//if (!isset($_GET['f'])) $function = 'meklet';
if ($function == 'apstiprinat') Apstiprinat();

function Apstiprinat(){
	global $ord;
	if (isset($_GET['oid'])){
		$error = array();
		//var_dump($_POST);
		$oid = (int)$_GET['oid'];
		$ord->Confirm($oid);
		header("Location: ".$_SERVER["HTTP_REFERER"]);
		die();
	}
	else die('Nav norâdîts ordera numurs');
}
?>