#!/usr/bin/php -q
<?PHP
require("/var/www/html/php_atis/includes/config.php");
require('/var/www/html/php_atis/includes/Merchant.php');
$ecomm_url = $domain.':8443/ecomm/MerchantHandler';

$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

        $resp = $merchant -> closeDay();
        //echo $resp;

?>
