<?
/*==================================================*/
// 19.08.2019 RT 
// c_vietu_veidi.php	
/*==================================================*/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_pieteikums.php");
require_once("online2/m_dalibn.php");
require_once("online2/m_vietu_veidi.php");
require_once("online2/m_grupa.php");

$db = New Db();
$piet = new Pieteikums();
$dalibn = new Dalibn();
$cvv = new VietuVeidi();
$gr = new Grupa();

//saraksta izdrukāšana grupai ar pasūtītajiem pakalpojumiem ar iespēju sakārtot pēc datuma/alfabēta
$vietas_veids = (int)$_GET['vv'];
$vietu_veidi = $_GET['vairaki_vv'];
$gid = (int)$_GET['gid'];
if (isset($_GET['kartot_pec'])){
	$data['kartot_pec'] = $_GET['kartot_pec'];
	$vietas_veids = $_SESSION['vietas_veids'];
	$vietu_veidi = $_SESSION['vietu_veidi'];
	$gid = $_SESSION['gid'];
}
else{
	$data['kartot_pec'] = "datums";
}

	
if ($gid>0 && ($vietas_veids>0 || count($vietu_veidi)>0)){
	//saglabā sesijā priekš kārtošanas
	$_SESSION['vietas_veids'] = $vietas_veids;
	$_SESSION['vietu_veidi'] = $vietu_veidi;
	$_SESSION['gid'] = $gid;
	
	if ($vietas_veids)
		$vietu_veidi = [$vietas_veids];
	
	foreach($vietu_veidi as $vv){
		$data['vv_arr'][] = $cvv->GetId($vv);
	}
	
	if (count($vietu_veidi)>0){
		$data['pieteikumi'] = $piet->GetByVietasVeids($vietu_veidi,$data['kartot_pec']);
	}
	$data['grupas_nos'] = $gr->GetFullNosaukums($gid);
	require_once("v_vietu_veidi_sar.php");

}
else{
	
	die("Nav norādīts grupas Nr. un vietas veids");
}


	 
?>