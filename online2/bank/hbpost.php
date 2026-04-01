<?php
//
//if ($_SERVER['REMOTE_ADDR'] == '80.233.209.62')

// jaunā versija
if (1==1)
{
	$_POST['VK_MSG'] = uncode_lv_special_chars_utf8($_POST['VK_MSG']);  
	$_POST['VK_MSG'] = str_replace('rezervacija','rezervācija',$_POST['VK_MSG']);  
	
	/*
	?>
	<pre>
	<?php print_r($_POST); ?>
	</pre>
	<?
	*/

		
	// CONFIGURATION
	//$url = 'https://pi.swedbank.com/public/api/v2/agreement/providers';
	if ($_POST['DESTINATION']=='swedbank')
		$url = 'https://pi.swedbank.com/public/api/v2/transactions/providers/HABALV22';

	if ($_POST['DESTINATION']=='revolut')
		$url = 'https://pi.swedbank.com/public/api/v2/transactions/providers/RETBLT21';
	
	if ($_POST['DESTINATION']=='seb')
		$url = 'https://pi.swedbank.com/public/api/v2/transactions/providers/UNLALV2X';

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

	require_once($path.'../m_init.php');
	$db = new Db;	
	/*
	$trans = $db->QueryArray("INSERT INTO swedbank_trans (rez_id,amount,currency,description,trans_uid) OUTPUT INSERTED.guid VALUES (?,?,?,?,?) ",
		[
			$_POST['rez_id']
			,$_POST['VK_AMOUNT']
			,$_POST['VK_CURR']
			,$_POST['VK_MSG']
			,$_POST['VK_REF']
		]
	);*/
	
	$trans = $db->QueryArray("INSERT INTO swedbank_trans (rez_id,amount,currency,description,trans_uid,destination) OUTPUT INSERTED.guid VALUES (?,?,?,?,?,?) ",
		[
			$_POST['rez_id']
			,$_POST['VK_AMOUNT']
			,$_POST['VK_CURR']
			,$_POST['VK_MSG']
			,$_POST['VK_REF']
			,$_POST['DESTINATION']
		]
	);
	
	$guid = $trans[0]['guid'];
	$shortGuid = str_replace('-', '', $trans[0]['guid']);

	// Set actual payload
	$payloadArray = [
		"amount" => $_POST['VK_AMOUNT'],
		"currency" => $_POST['VK_CURR'],
		"description" => $_POST['VK_MSG'],
		"redirectUrl" => "https://impro.lv/online/bank/get_swed.php?id=$guid",
		"notificationUrl" =>"https://impro.lv/online/bank/get_swed.php?id=$guid",
		"endToEndIdentification" => $shortGuid,
		"locale" => "lv"
	];
	
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
	curl_setopt($ch, CURLOPT_POST, true); // Switch to POST
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

	$data = json_decode($response, true);
	$db->Insert("swedbank_trans",['guid'=>$guid,'status'=>$httpCode,'description'=>"$response",'bank_id'=>$data['id']]);		
	echo "HTTP Status: $httpCode\n";
	echo "Response:\n$response\n";
	
	
	if ($httpCode==201) {
		$redirectUrl = $data['urls']['redirect'];
		header("Location: $redirectUrl");
		exit;
	}
	else {
		?>
		Maksājums neizdevās!
		<?
		exit;
	}
	
	die();
}

//die();
//print_r($_POST);
//session_start();
echo "Lūdzu uzgaidiet...";

//--- Generate PDF
//--- izmaiņas 19.dec 2012. katru reizi ģenerēt līgumu nevajag. tikai pirmo reizi.
//require_once('inc/php_functions.php');
//connect_to_mssql();

//šim failam jābut utf8 kodējumā!!!

//pēc datu posta no asp faila latviešu garumzīmes pazūd, tāpēc postējot simboli tiek aizvietoti ar #simbols


$rez_id = $_POST['rez_id'];
require_once("../m_ligumi.php");
$ligumi = new Ligumi();
$ligums = $ligumi->GetRezId($rez_id);

//---------------------		
foreach ($_POST as $key => $value){
	$$key = uncode_lv_special_chars_utf8($value);  
}
$data = $VK_MAC;//$_POST['VK_MAC'];


//log ierakstīt
// logs failā
file_put_contents("log\post.txt",date("Y-m-d H:i:s")." POST SWEDBANK ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);


$fp = fopen("e:\\globa\\wwwroot\\online2\\bank\\swedbank\\key.pem", "r");
$priv_key = fread($fp, 8192);
fclose($fp);

//echo "test ZXC<br>";
//echo $php_errormsg;
$pkeyid = openssl_get_privatekey($priv_key);

$signature = "";

// compute signature
if(!openssl_sign($data, $signature, $pkeyid)){
	die("signature calculation error");
};


// free the key from memory
openssl_free_key($pkeyid);

$signature = base64_encode($signature);

//echo "Sheit ir gatava forma, kas jaaposto uz Hansabanku<br>Digitaalais paraksts ir shaads: ";
?>
<html>
<head>
  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
  <meta charset="UTF-8">
</head>


<form name="hbpost" action="https://www.swedbank.lv/banklink/" method="post">
<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?php  echo $_POST['VK_SERVICE'];?>"	>
<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?php  echo $_POST['VK_VERSION'];?>"	>
<input type="hidden" name="VK_SND_ID"	maxlength="10"	value="<?php  echo $_POST['VK_SND_ID'];?>"	>
<input type="hidden" name="VK_STAMP"	maxlength="20"	value="<?php  echo $_POST['VK_STAMP'];?>"	>
<input type="hidden" name="VK_AMOUNT"	maxlength="17"	value="<?php  echo $_POST['VK_AMOUNT'];?>"	>
<input type="hidden" name="VK_CURR"	maxlength="3"	value="<?php  echo $_POST['VK_CURR'];?>"	>
<input type="hidden" name="VK_REF"	maxlength="20"	value="<?php  echo $_POST['VK_REF'];?>"	>
<input type="hidden" name="VK_MSG"	maxlength="70"	value="<?php  echo $VK_MSG;?>"	>
<input type="hidden" name="VK_MAC"	 maxlength="300"	value="<?php  echo $signature;?>"	>
<input type="hidden" name="VK_RETURN"	maxlength="65"	value="<?php  echo $_POST['VK_RETURN'];?>"	>
<input type="hidden" name="VK_LANG"	maxlength="3"	value="<?php  echo $_POST['VK_LANG'];?>"	>
<input type="hidden" name="VK_ENCODING"	value="<?php  echo $_POST['VK_ENCODING'];?>"	>

</form>

<script>
	document.hbpost.submit();
</script>


<?php

function uncode_lv_special_chars_utf8($string) {
	$search = array();
	$replace = array();
	$search[] = '#a';
	$replace[]  = 'ā';
	$search[] = '#c';
	$replace[]  = 'č';
	$search[] = '#e';
	$replace[]  = 'ē';
	$search[] = '#g';
	$replace[]  = 'ģ';
	$search[] = '#i';
	$replace[]  = 'ī';
	$search[] = '#k';
	$replace[]  = 'ķ';
	$search[] = '#l';
	$replace[]  = 'ļ';
	$search[] = '#n';
	$replace[]  = 'ņ';
	$search[] = '#s';
	$replace[]  = 'š';
	$search[] = '#u';
	$replace[]  = 'ū';
	$search[] = '#z';
	$replace[]  = 'ž';
	$search[] = '#A';
	$replace[]  = 'Ā';
	$search[] = '#C';
	$replace[]  = 'Č';
	$search[] = '#E';
	$replace[]  = 'Ē';
	$search[] = '#G';
	$replace[]  = 'Ģ';
	$search[] = '#I';
	$replace[]  = 'Ī';
	$search[] = '#K';
	$replace[]  = 'Ķ';
	$search[] = '#L';
	$replace[]  = 'Ļ';
	$search[] = '#N';
	$replace[]  = 'Ņ';
	$search[] = '#S';
	$replace[]  = 'Š';
	$search[] = '#U';
	$replace[]  = 'Ū';
	$search[] = '#Z';
	$replace[]  = 'ž';
	$search[] = '#O';
	$replace[]  = 'Ō';
	$search[] = '#o';
	$replace[]  = 'ō';

	return str_replace($search, $replace, $string);
}
// sheit testeejam, vai patieshaam abas atsleegas darbojas
/*
echo "---CRYPT---<BR>";
$source="Mans slepenais teksts";
echo "Message : $source<BR>";
$fp=fopen("./bank/key.pem","r");
$priv_key=fread ($fp,8192);
fclose($fp);
//echo $pub_key;
openssl_get_privatekey($priv_key);
openssl_private_encrypt ($source,$sourcecrypt,$priv_key);
echo "Crypted message : ".$sourcecrypt."<BR><BR>";
$source="";

echo "---DECRYPT---<BR>";
echo "Crypted message : ".$sourcecrypt."<BR>";
$fp=fopen("./bank/cert.pem","r");
$pub_key=fread ($fp,8192);
fclose($fp);
$res=openssl_get_publickey($pub_key);
openssl_public_decrypt ($sourcecrypt,$newsource,$res);
echo "Source decryptÄ†Ā©e : $newsource<BR><BR>";
*/
?>