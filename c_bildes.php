<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_bildes.php");
require_once("online2/m_grupa.php");


$function = $_GET["f"];

if(!isset($_GET["f"])) $function = "index";
if($function == "index") Index();
if($function == "save") Save();

function Index() {
	$grupa = new Grupa();	
	$gid = $_GET["gid"];
	
	$gr = $grupa->GetId($gid);
	$bildes = new Bildes();	
	$data = $bildes->GetGrupa($gr['kods']);
	require_once("views/v_bildes.php");
}

function Save() {
	foreach ($_POST['alt_texts'] as $key => $value) {
		$db = New Db();
		$db->Query("update portal.dbo.marsruti_bildes set atsl_vardi = N'$value' where id = ?",[$key]);
    }
	Index();
}
?>
