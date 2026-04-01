<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
$db = New Db();
require_once("online2/m_tiesibas.php");
$tiesibas = new Tiesibas();

if (!$tiesibas->IsAccess(T_ANKETAS)){
	header("Location: default.asp");
	exit();
}


require_once("online2/m_anketas.php");
$anketas = new Anketas();
require_once("online2/m_grupa.php");
$gr = new Grupa();

if (isset($_POST['meklet'])){
	//var_dump($_POST);
	$data = array();
	$data['ar_anketam'] = true;
	$data['kods'] = $db->GetPost('kods');
	$data['kurators'] = $db->GetPost('kurators');
	$data['datums_no'] = $db->GetPost('datums_no');
	$data['datums_lidz'] = $db->GetPost('datums_lidz');
	$data['valsts'] = $db->GetPost('valsts');
	$data['grupas'] = $gr->GetWhere($data);
	require_once("v_anketas_grupas.php");
}
else{
	if (!empty($_GET['gid'])){
		$gid = (int)$_GET['gid'];

		$data['anketas'] = $anketas->GetByGid($gid);
		//print_r($data['anketas'] );
		$data['grupa'] = $gr->GetId($gid);
		require_once("v_anketas.php");
	}
	else exit("Nav norâdîts grupas ID#");
}
?>


