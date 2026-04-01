<?

require_once($path.'../m_init.php');
$db = new Db;	

$guid = $_GET['id'];
$shortGuid = str_replace('-', '', $guid);

$rbank_id = $db->QueryArray("select bank_id from swedbank_trans where guid = ? and bank_id is not null",[$guid]);
$bank_id = $rbank_id[0]['bank_id'];


$url = 'https://pi.swedbank.com/public/api/v2/transactions/'.$bank_id.'/status';

$kid = 'LV:IMPRO'; // <-- Replace with your real merchant ID
$privateKeyPath = 'e:\\globa\\wwwroot\\online2\\bank\\swedbank\\swpriv.pem';

// LOAD PRIVATE KEY
$privateKeyContent = file_get_contents($privateKeyPath);
$privateKey = openssl_pkey_get_private($privateKeyContent);
if (!$privateKey) {
	die("Failed to load private key.");
}

// PREPARE JWS HEADER
$header = [
	"alg" => "RS512",
	"b64" => false,
	"crit" => ["b64"],
	"iat" => time(),
	"url" => $url,
	"kid" => $kid
];
// ENCODE HEADER
$headerJson = json_encode($header, JSON_UNESCAPED_SLASHES); // Required: no escaped slashes
$headerEncoded = rtrim(strtr(base64_encode($headerJson), '+/', '-_'), '=');

// Set actual payload
$payloadArray = [];

// Encode payload as JSON (without escaped slashes)
$payload = json_encode($payloadArray, JSON_UNESCAPED_SLASHES);
$postData = $payload; // This will be sent as POST body

// Data to sign (b64 is false, so use raw payload)
$dataToSign = $headerEncoded . '.' . $payload;

// SIGN
if (!openssl_sign($dataToSign, $signature, $privateKey, "sha512")) {
	die("Signing failed.");
}
$signatureEncoded = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');

// DETACHED JWS: header..signature (note the double dots)
$jwsDetached = $headerEncoded . '..' . $signatureEncoded;

// SEND REQUEST
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET'); // Use GET instead of POST
curl_setopt($ch, CURLOPT_POSTFIELDS, $postData); // Set POST data
curl_setopt($ch, CURLOPT_HTTPHEADER, [
	'Content-Type: application/json',
	'X-JWS-SIGNATURE: ' . $jwsDetached,
	'Content-Length: ' . strlen($postData)
]);
curl_setopt($ch, CURLOPT_CAINFO, "e:\\globa\\wwwroot\\online2\\bank\\swedbank\\cacert.pem");

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ($response === false) {
	$error = curl_error($ch);
	curl_close($ch);
	die("cURL error: $error");
}

curl_close($ch);
openssl_free_key($privateKey);



$db->Insert("swedbank_trans",['guid'=>$guid,'status'=>$httpCode,'description'=>"$response",'bank_id'=>$bank_id]);		
$data = json_decode($response, true);



require_once("../m_user_tracking.php");
$u_track = new UserTracking();

require_once("../m_merchant_session.php");
$merchant_session = new MerchantSession();			
$arr = $merchant_session->CreatePhpSession(0,0,'swedbank',$data);



//var_dump($bank_response_data);
$hash = $arr['hash'];
//$hash = create_asp_session(0,0,'swedbank',$bank_response_data);
if ($hash) {
	$sget['hash'] = $hash;
	$bank_response_data = $data;
	include_once("get_swed2.php");

	exit();
} else {
	$error = "CreatePhpSession hash error";
	$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
	$text .= $error;
	$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
	$u_track->Save($text);
	die('CreatePhpSession hash error');
}
/*
?>
<html> 
<head>
    <meta charset="UTF-8">
    <title>Your Page Title</title>
</head>
<body>
<?
echo "HTTP Status: $httpCode\n";
echo "Response:\n$response\n";


echo '<pre>' . print_r($_POST, true) . '</pre>';
*/



?>