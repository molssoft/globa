<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_agenti.php");
require_once("online2/m_lietotaji.php");

$db = New Db();

$function = $_GET["f"];

if(!isset($_GET["f"])) $function = "index";
if($function == "index") Index();
if($function == "neaktivie") Neaktivie();
if($function == "lietotajiView") LietotajiView($_GET["id"]);
if($function == "addAgentsView") AddAgentsView();
if($function == "editLietotajsView") EditLietotajsView($_GET["id"]);
if($function == "editAgentsView") EditAgentsView($_GET["id"]);
if($function == "addNewLietotajsView") AddNewLietotajsView($_GET["aid"]);
if($function == "editLigumsView") EditLigumsView($_GET["id"]);
if($function == "addAgents") AddAgents($_POST["aktivs"],$_POST["pilseta"],$_POST["vards"],$_POST["dkonts"],$_POST["ckonts"]);
if($function == "updateAgents") UpdateAgents($_GET["id"],$_POST["aktivs"],$_POST["pilseta"],$_POST["vards"],$_POST["dkonts"],
	$_POST["ckonts"],$_POST["liguma_vieta"],$_POST["liguma_datums"],$_POST["liguma_nr"],$_POST["uznemums"],$_POST["regnr"],
	$_POST["adrese"],$_POST["tur_regnr"],$_POST["liguma_pamats"],$_POST["parstavis"]);
if($function == "deleteAgents") DeleteAgents($_GET["id"]);
if($function == "addLietotajs") AddLietotajs($_GET["aid"],$_POST["lietotajs"],$_POST["vards"],$_POST["uzvards"],$_POST["epasts"],$_POST["parole"],$_POST["aktivs"]);
if($function == "deleteLietotajs") DeleteLietotajs($_GET["id"]);
if($function == "updateLietotajs") UpdateLietotajs($_GET["id"],$_POST["lietotajs"],$_POST["vards"],$_POST["uzvards"],$_POST["epasts"],$_POST["parole"],$_POST["aktivs"]);

function Index() {
	$agenti = new Agenti();	
	$data = $agenti->GetActive();
	require_once("views/agenti/v_agenti.php");
}

function Neaktivie() {
	$agenti = new Agenti();
	
	
	$data["neaktivi"] = $agenti->GetNonActive();
	require_once("views/agenti/v_agenti_neaktivie.php");
}

function LietotajiView($id){
	$lietotaji = new Lietotaji();
	
	$data = $lietotaji->GetLietotajiById($id);
	$aid = $id;

	require_once("views/agenti/v_agenta_lietotaji.php");
}

function AddAgentsView(){
	require_once("views/agenti/v_add_agents.php");
}

function EditLigumsView($id){
	$agenti = new Agenti();

	$data = $agenti->GetById($id);
	require_once("views/agenti/v_agenta_liguma_info.php");
	
}

function AddAgents($aktivs,$pilseta,$vards,$dkonts,$ckonts){
	$agenti = new Agenti();
	
	$active = 0;
	if($aktivs == "on"){
		$active = 1;
	}

	
	$data = array(
	"aktivs" => $active,
	"pilseta" => $pilseta,
	"vards" => $vards,
	"dkonts" => $dkonts,
	"ckonts" => $ckonts);
	
	$agenti->Add($data);
	Index();
}

function UpdateAgents($id,$aktivs,$pilseta,$vards,$dkonts,$ckonts,$liguma_vieta,$liguma_datums,$liguma_nr,$uznemums,$reg_nr,$adrese,$tur_regnr,$liguma_pamats,$parstavis){
	$agenti = new Agenti();

	$data = array(
	"id" => $id,
	"aktivs" => $aktivs,
	"pilseta" => $pilseta,
	"vards" => $vards,
	"dkonts" => $dkonts,
	"ckonts" => $ckonts,
	"liguma_vieta" => $liguma_vieta,
	"liguma_datums" => $liguma_datums,
	"liguma_nr" => $liguma_nr,
	"uznemums" => $uznemums,
	"regnr" => $reg_nr,
	"adrese" => $adrese,
	"tur_regnr" => $tur_regnr,
	"liguma_pamats" => $liguma_pamats,
	"parstavis" => $parstavis
	);
var_dump($data);
	$agenti->Update($data);
	Index();
}

function DeleteAgents($id){
	$agenti = new Agenti();
	
	$agenti->Delete($id);
	Index();
}

function AddLietotajs($aid,$lietotajs,$vards,$uzvards,$epasts,$parole,$aktivs){
	var_dump($_POST);
	var_dump($aktivs);
	$lietotaji = new Lietotaji();
	$active = 0;
	if($aktivs == "on"){
		$active = 1;
	}

	$data = array(
	"aid" => $aid,
	"active" => $active,
	"Lietotajs" => $lietotajs,
	"vards" => $vards,
	"uzvards" => $uzvards,
	"epasts" => $epasts,
	"parole" => $parole,
	);
	$lietotaji->Add($data);
	Index();
}

function DeleteLietotajs($id){
	$lietotaji = new Lietotaji();
	$lietotaji->Delete($id);
	Index();
}

function EditAgentsView($id) {
	$agenti = new Agenti();

	$data = $agenti->GetById($id);
	require_once("views/agenti/v_agenti_edit.php");
}

function AddNewLietotajsView($aid2){
	$aid = $aid2;
	$data['title'] = "Pievienot lietotâju";
	$data['aid'] = $aid;
	$data['form_action'] = "c_agenti.php?f=addLietotajs&aid=".$aid;
	require_once("views/agenti/v_lietotajs_edit.php");
}

function EditLietotajsView($id){
	$lietotaji = new Lietotaji();
	$data['title'] = "Lietotâjs";
	$data["lietotajs"] = $lietotaji->GetId($id);
	$data['aid'] = $data['lietotajs']['aid'];
	$data['form_action'] = "c_agenti.php?f=updateLietotajs&id=".$data["lietotajs"]["id"];

	require_once("views/agenti/v_lietotajs_edit.php");
}

function UpdateLietotajs($id,$lietotajs,$vards,$uzvards,$epasts,$parole,$aktivs){
	var_dump($_POST);
	var_dump($aktivs);
	$lietotaji = new Lietotaji();
	$active = 0;
	if($aktivs == "on"){
		$active = 1;
	}
	$data = array(
	"id" => $id, 
	"lietotajs" => $lietotajs, 
	"vards" => $vards,
	"uzvards" => $uzvards,
	"epasts" => $epasts,
	"parole" => $parole,
	"active" => $active);
var_dump($data);
	$lietotaji->Update($data);
	Index();
}

?>