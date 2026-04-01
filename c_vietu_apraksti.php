<?
/*==================================================*/
// c_vietu_apraksti.php	
/*==================================================*/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_vietu_apraksti.php");

$db = New Db();
$vietuApr = new VietuApraksti();

if(isset($_GET["f"])){
	$f = $_GET["f"];
}
else $f = "";

switch($f){
	case "edit":
		$data = $vietuApr->GetId($_GET["id"]);
		include("views/v_vietu_apraksti_edit.php");
		break;
	case "add":
		$data = array();
		include("views/v_vietu_apraksti_edit.php");
		break;
	case "insert":
		$values = $_POST;
		if (isset($values["id"])) unset($values["id"]);
		if (isset($values["ID"])) unset($values["ID"]);
		$vietuApr->Insert($values);
		header("Location: c_vietu_apraksti.php");
		break;
	case "update":
		$values = $_POST;
		$id = $values["id"];
		unset($values["id"]);
		$vietuApr->Update($id, $values);
		header("Location: c_vietu_apraksti.php");
		break;
	case "delete":
		$vietuApr->Delete($_GET["id"]);
		header("Location: c_vietu_apraksti.php");
		break;
	default:
		$data = $vietuApr->GetAll();
		include("views/v_vietu_apraksti.php");
		break;
}



