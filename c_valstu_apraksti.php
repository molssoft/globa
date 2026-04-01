<?
/*==================================================*/
// c_valstu_apraksti.php	
/*==================================================*/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_valstu_apraksti.php");

$db = New Db();
$valstuApr = new ValstuApraksti();

if(isset($_GET["f"])){
	$f = $_GET["f"];
}
else $f = "";

switch($f){
	case "edit":
		$data = $valstuApr->GetId($_GET["id"]);
		include("views/v_valstu_apraksti_edit.php");
		break;
	case "add":
		$data = array();
		include("views/v_valstu_apraksti_edit.php");
		break;
	case "insert":
		$valstuApr->Insert($_POST);
		header("Location: c_valstu_apraksti.php");
		break;
	case "update":
		$values = $_POST;
		$id = $values["id"];
		unset($values["id"]);
		$valstuApr->Update($id, $values);
		header("Location: c_valstu_apraksti.php");
		break;
	case "delete":
		$valstuApr->Delete($_GET["id"]);
		header("Location: c_valstu_apraksti.php");
		break;
	default:
		$data = $valstuApr->GetAll();
		include("views/v_valstu_apraksti.php");
		break;
}



