<?
header("Content-type: text/html; charset=utf-8"); 

//print_r($_POST);

//echo "<br> pamatojums -> ".$_POST['VK_MSG']." = ".utf8_decode($_POST['VK_MSG']);

//echo "<br> str_garums -> ".str_garums($_POST['VK_MSG'])." = ".str_garums(utf8_encode($_POST['VK_MSG']));

file_put_contents("log\post.txt",date("Y-m-d H:i:s")." POST DNB ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);
?>