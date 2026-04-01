<?php
$kid = 'LV:IMPRO'; // <-- Your real merchant ID
$privateKeyPath = 'e:\\globa\\wwwroot\\online2\\bank\\swedbank\\swpriv.pem';
$url = 'https://pi.swedbank.com/public/api/v2/agreement/providers'; // <-- NEW endpoint for providers

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
	"iat" => time() ,
	"url" => $url,
	"kid" => $kid
];

// ENCODE HEADER
$headerJson = json_encode($header, JSON_UNESCAPED_SLASHES);
$headerEncoded = rtrim(strtr(base64_encode($headerJson), '+/', '-_'), '=');

// Set empty payload for GET
$payload = '';
$dataToSign = $headerEncoded . '.' . $payload;

// SIGN
if (!openssl_sign($dataToSign, $signature, $privateKey, "sha512")) {
	die("Signing failed.");
}
$signatureEncoded = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');

// DETACHED JWS format: header..signature
$jwsDetached = $headerEncoded . '..' . $signatureEncoded;

// SEND GET REQUEST
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPGET, true); // <-- Use GET instead of POST
curl_setopt($ch, CURLOPT_HTTPHEADER, [
	'Accept: application/json',
	'X-JWS-SIGNATURE: ' . $jwsDetached
]);
curl_setopt($ch, CURLOPT_CAINFO, "e:\\globa\\wwwroot\\online2\\bank\\swedbank\\cacert.pem");

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

// DEBUG
echo "HTTP Status: $httpCode\n";
echo "Response:\n$response";