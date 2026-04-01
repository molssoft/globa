<?
//************************************//
// bloket_online_profilu.php 		
// Lietotâja online profila bloíçðana 
// RT 21.02.2019
//************************************//
session_start();
$_SESSION['path_to_files'] = 'online2/';

require_once("online2/m_profili.php");

$profili = new Profili();

if (isset($_GET['id'])){
	$id = (int)$_GET['id'];
	$profili->BanProfile($id);
	$profils = $profili->GetId($id);
	$pk1 = $profils['pk1'];
	$pk2 = $profils['pk2'];
	header("Location: profils.asp?pk1=$pk1&pk2=$pk2");
	exit();
}
?>