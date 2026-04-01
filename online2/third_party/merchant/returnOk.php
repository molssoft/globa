<?PHP
require('includes/config.php');
require('includes/connect.php');
require('includes/Merchant.php');
$ecomm_url = $domain.':8443/ecomm/MerchantHandler';
$trans_id = urlencode($_POST['trans_id']);
$ip = urlencode($_SERVER['REMOTE_ADDR']);



$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

$resp = $merchant -> getTransResult($trans_id, $ip);

echo $resp;

if($resp == 'RESULT: DECLINED'){
  $result_code = 'DECLINED';
}else{
  $result_code = explode(':', $resp);
  $result_code = substr($result_code[2], 1, 3);
}

if(substr($resp,8,6) == 'FAILED'){
$result_code = 'FAILED: '.$result_code;
}

$ok = substr($resp,8,2);
$trans_id = ($_POST['trans_id']);

      $result = mssql_query("UPDATE $db_table SET `result` = '$result_code' WHERE `trans_id` = '$trans_id'");
      if (!$result) {
          die('*** Invalid query');
      }
?>
