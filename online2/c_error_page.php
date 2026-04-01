<?
session_save_path('c:\temp') ;
session_start();
require_once('m_init.php');
$db = new Db();

require_once("v_error_page.php");
?>