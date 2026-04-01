<?
//----------------------
// c_dalibn.php
// 22.03.2018
//----------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once($_SESSION['path_to_files']."m_init.php");
require_once($_SESSION['path_to_files']."m_dalibn.php");
$db = New Db();
$dalibn  = new Dalibn();

require_once($_SESSION['path_to_files']."i_functions.php");

/*$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'index';
if ($function == 'index') Index();
if ($function == 'edit') {
	Edit();
}*/
//var_dump($_POST);
if (isset($_POST['search_ID'])){
	$search_id=$_POST['search_ID'];
	$id = (int)$search_id;
	$dalibnieks = $dalibn->GetId($id);
	//var_dump($dalibnieks);
	
	if ($dalibnieks){
		//var_dump($search_id);
		//var_dump($id);
		if ($search_id!==$id){
			$search_id=$id;
		}
		header("Location: dalibn.asp?search_id=".$search_id."&i=".$id);
	}
	else{
		
	
		header("Location: dalibn.asp?error=not_found&search_id=".$search_id);
	}
	
	
}
if (isset($_POST['search_rez'])){
	$search_rez=$_POST['search_rez'];
	$rez_id = (int)$search_rez;
	$dalibnieki = array();
	if ($rez_id){
		$dalibnieki = $dalibn->GetByRez($rez_id);
	}
	//var_dump($dalibnieks);
	
	//var_Dump(count($dalibnieki));
	//die();
	if (count($dalibnieki) > 0){
		if ($search_rez!==$rez_id){
			$search_rez=$rez_id;
		}
		//var_dump($dalibnieki);
		//die();
		
		//ja atrod vienu dalībnieku
		if (count($dalibnieki) == 1){
			//var_dump($search_id);
			header("Location: dalibn.asp?search_rez=".$search_rez."&i=".$dalibnieki[0]['ID']);
		}
		else{
			//dalibn lapā jāapstrādā, lai 
			header("Location: dalibn.asp?mekl_rez_id=".$search_rez);
		}
		
	}
	else{
		header("Location: dalibn.asp?error_rez=not_found&search_rez=".$search_rez);
		//header("Location: dalibn.asp?error=not_found&search_id=".$search_id);
	}
	
	
}

?>