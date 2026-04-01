<?
//-------------------------------//
// 06.02.2020 RT
// c_grupa.php
//------------------------------//
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_tiesibas.php");



$db = New Db();


$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'edit';
if ($function == 'edit') Edit();
if ($function == 'parakstit') Parakstit();

function Edit(){
	global $db;
	$tiesibas = new Tiesibas();

	$gid = (int)$db->GetGet('gid');
	if ($gid>0){
		require_once("online2/m_pieteikums.php");
		require_once("online2/m_dalibn.php");
		require_once("online2/m_marsruts.php");
		require_once("online2/m_grupa.php");
		
		$piet = new Pieteikums();
		$dalibn = new Dalibn();
		$marsruts = new Marsruts();
		$gr = new Grupa();
		$data = array();
		$data = $gr->GetId($gid);
		$data["marsruts"] = $marsruts->GetGid($gid);
	
 		//Nosakam tiesibas labot
		$data['gr_lab1'] = ($tiesibas->IsAccess(T_GR_LAB1) ? true : false);
 		$data['gr_lab2'] = ($tiesibas->IsAccess(T_GR_LAB2) ? true : false);

		require_once("v_grupa_edit.php");
	}
	else{
		exit('Grupa nav atrasta');
	}


	 
	
}

	
?>