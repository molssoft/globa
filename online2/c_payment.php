<?php

require_once("bank/i_config.php");
require_once("bank/i_bank_functions.php");
require_once("i_functions.php");

require_once("m_merchant_session.php");
$merchant_session = new MerchantSession();

	
//Response.Write("->create")	
$hash = $merchant_session->CreatePhpSession_0(-1, $_GET['a'], $_GET['d'], 3);
//unset($_SESSION['reservation_bank']);
//$steps.$clean_steps $rez_id;

header("Location: merchant.php?a=start&k=".$hash);

?>