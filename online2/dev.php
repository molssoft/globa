<?php

// CONFIGURATION
$url = 'https://pi.swedbank.com/public/api/v2/agreement/providers';
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
    "iat" => time()-120,
    "url" => $url,
    "kid" => $kid
];

// ENCODE HEADER
$headerJson = json_encode($header, JSON_UNESCAPED_SLASHES); // Required: no escaped slashes
$headerEncoded = rtrim(strtr(base64_encode($headerJson), '+/', '-_'), '=');

// EMPTY PAYLOAD (GET request)
$payload = '';  // No body in GET request

// DATA TO SIGN
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
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'X-JWS-SIGNATURE: ' . $jwsDetached
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

// PRINT RESPONSE
echo "HTTP Status: $httpCode\n";
echo "Response:\n$response\n";
