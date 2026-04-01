<?
/*==================================================*/
// c_valstis.php	
/*==================================================*/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_valstis.php");

$db = New Db();
$valstis = new Valstis();

if(isset($_GET["f"])){
    $f = $_GET["f"];
}
else $f = "";

switch($f){
    case "edit":
        $data = $valstis->GetId($_GET["id"]);
        include("views/v_valstis_edit.php");
        break;
    case "update":
        $valstis->Update($_POST);
        header("Location: c_valstis.php");
        break;
    default:
        $data = $valstis->GetAll();
        include("views/v_valstis.php");
        break;
}

