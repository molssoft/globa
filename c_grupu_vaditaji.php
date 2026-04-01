<?
//-------------------------------//
// 06.02.2020 RT
// c_grupa.php
//------------------------------//
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_grupu_vaditaji.php");
$db = New Db();


$function = $_GET['f'];

if (!isset($_GET['f'])) $function = 'index';
if ($function == 'add') Add($_GET['id'],$_GET['name'],$_GET['lastname'],$_GET['did']);
if ($function == 'edit') Edit($_GET['idnum']);
if ($function == 'delete') Delete($_GET['idnum']);
if ($function == 'index') Index();
if ($function == 'save') Update($_GET['idnum'],$_GET['id'],$_GET['name'],$_GET['lastname'],$_GET['did']);


function Index()
{
	$grupuVaditaji = new GrupuVaditaji();
	
	$data = $grupuVaditaji->GetAll();
	require_once("v_grupu_vaditaji.php");
}

function Add($id,$name,$lastname,$did)
{
	$grupuVaditaji = new GrupuVaditaji();
	$grupuVaditaji->Add($id,$name,$lastname,$did);
	index();
} 
function Edit($idnum)
{
	$grupuVaditaji = new GrupuVaditaji();	
	
	$user = $grupuVaditaji->GetById($idnum);
	require_once("v_grupu_vaditaji_edit.php");
}

function Delete($idnum)
{
	$grupuVaditaji = new GrupuVaditaji();
	
	if(isset($idnum) && !empty($idnum)) {
		$grupuVaditaji->Delete($idnum);	
	}
	Index();
}

function Update($idnum,$id,$name,$lastname,$did)
{
	$grupuVaditaji = new GrupuVaditaji();
	$grupuVaditaji->Update($idnum,$id,$name,$lastname,$did);
	Index();
}
?>