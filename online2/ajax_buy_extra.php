<?
// file: ajax_buy_extra.php
// executes functionality to buy extra services 

session_save_path('c:\temp') ;
session_start();

require_once('m_init.php');
require_once('m_vietu_veidi.php');

$rid = $_SESSION['reservation']['online_rez_id'];
$product_id = $_POST['product_id'];  
list($did, $vietas_veids) = explode('-', $product_id, 2);

$vv = new VietuVeidi();
$vv->create($rid,$did,$vietas_veids);
?>