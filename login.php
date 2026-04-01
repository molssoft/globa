<?php

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

$db = New Db();
$res = $db->QueryArray("select * from lietotaji 
	where 
		lietotajs = '".$_POST['username']."' 
		and parole = '".$_POST['password']."'");

if (count($res)==1)
{
	$_SESSION['user_name']=$res[0]['Lietotajs'];
	echo $_SESSION['user_name'];
}

header("location:default.asp");
?>