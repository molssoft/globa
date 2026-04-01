<?php 
error_reporting('E_ALL');
ini_set('display_errors', 'on');

if (isset($_GET['info'])) { phpinfo(); exit(); }

if (!function_exists('curl_init')) { exit('cURL not available!'); }

$s = isset($_GET['s']) ? $_GET['s'] : 'http';
$v = isset($_GET['v']) ? $_GET['v'] : 'yes';

$data = 'E';
$ch = curl_init();
curl_setopt($ch, CURLOPT_CAINFO, getcwd() . '\cacert.pem');
//curl_setopt($ch, CURLOPT_SSL_CIPHER_LIST, 'AES256-SHA:ALL:!RC4:!3DES:!aNULL:!ADH:!DH:!EDH:!KRB5:!IDEA:!EXP:!LOW:!eNULL:+HIGH');
curl_setopt($ch, CURLOPT_SSLVERSION, 6);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_VERBOSE, true);

if ($v == 'no') {
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
}

if ($s == 'https') {
  curl_setopt($ch, CURLOPT_URL, 'https://example.com/'); 
} else if ($s == 'howsmyssl') {
  curl_setopt($ch, CURLOPT_URL, 'https://www.howsmyssl.com/a/check');
  header('Content-Type: application/json');
} else {
  curl_setopt($ch, CURLOPT_URL, 'http://example.com/');
}

$data = curl_exec($ch);
echo $data;

if ($e = curl_error($ch)) {
	var_dump($e);
	echo 'cURL info: ' . "\n";
    print_r(curl_version());
}

curl_close($ch);