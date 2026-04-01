<?php
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_vietu_apraksti.php");

$va = new VietuApraksti();
$va->DeleteMarsrutsLink($_GET['id']);
header("location:grupa_edit2.asp?gid=".$_GET['gid']);
