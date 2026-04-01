<?
//require_once('inc/php_functions.php');

//šim failam jābut utf8 kodējumā!!!
//pēc datu posta no asp faila latviešu garumzīmes pazūd, tāpēc postējot simboli tiek aizvietoti ar #simbols

header("Content-type: text/html; charset=utf-8"); 

//print_r($_POST);
//echo "<br> pamatojums -> ".$_POST['VK_MSG']." = ".utf8_decode($_POST['VK_MSG']);
//echo "<br> str_garums -> ".str_garums($_POST['VK_MSG'])." = ".str_garums(utf8_encode($_POST['VK_MSG']));


foreach ($_POST as $key => $value){
		
		$$key = uncode_lv_special_chars_utf8($value);       

}
file_put_contents("log\post.txt",date("Y-m-d H:i:s")." POST SEB ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);

//$VK_MSG = "Rezervācija"; 
//$VK_MSG = utf8_encode($VK_MSG);

//echo "<br> pamatojums -> ".$VK_MSG." = ".utf8_decode($VK_MSG);
//echo "<br> str_garums -> ".str_pad(strlen($VK_MSG), 3, "0", STR_PAD_LEFT)." = ".str_pad(strlen(utf8_decode($VK_MSG)), 3, "0", STR_PAD_LEFT);


$paraksts = $paraksts . str_pad(strlen($IB_SND_ID), 3, "0", STR_PAD_LEFT) . $IB_SND_ID;
$paraksts = $paraksts . str_pad(strlen($IB_SERVICE), 3, "0", STR_PAD_LEFT) . $IB_SERVICE;
$paraksts = $paraksts . str_pad(strlen($IB_VERSION), 3, "0", STR_PAD_LEFT) . $IB_VERSION;
$paraksts = $paraksts . str_pad(strlen($IB_AMOUNT), 3, "0", STR_PAD_LEFT) . $IB_AMOUNT;
$paraksts = $paraksts . str_pad(strlen($IB_CURR), 3, "0", STR_PAD_LEFT) . $IB_CURR;
$paraksts = $paraksts . str_pad(strlen(utf8_decode($IB_NAME)), 3, "0", STR_PAD_LEFT) . $IB_NAME;
$paraksts = $paraksts . str_pad(strlen($IB_PAYMENT_ID), 3, "0", STR_PAD_LEFT) . $IB_PAYMENT_ID;
$paraksts = $paraksts . str_pad(strlen(utf8_decode($IB_PAYMENT_DESC)), 3, "0", STR_PAD_LEFT) . $IB_PAYMENT_DESC;


//echo "<br>Paraksts: ".$paraksts;
//echo "<br>VK_MSG: ".str_pad(strlen(utf8_decode($VK_MSG)), 3, "0", STR_PAD_LEFT) . $VK_MSG;
//die();


echo "<br>Lūdzu uzgaidiet...<br>";

//Generate PDF
//require_once('inc/php_functions.php');
//connect_to_mssql();

$rez_id = $_POST['rez_id'];
//$ligums = get_ligums($rez_id);
//--- izmaiņas 19.dec 2012. katru reizi ģenerēt līgumu nevajag. tikai pirmo reizi.
/*if(is_array($ligums)){
	require_once('inc/generate_ligums.php');
	$avanss = $ligums['avanss'];
	$pdf_content = generate_ligums($rez_id, 'official',$avanss);
	$data = unpack("H*hex", $pdf_content);
	mssql_query("UPDATE [ligumi] SET bpdf = 0x{$data['hex']} WHERE [rez_id] = $rez_id AND deleted = 0");
}*/
//echo "<br>";

//$data = $_POST['IB_CRC'];
$data = $paraksts;

//echo "VK_MAC: ".$data;

$fp = fopen("e:\\globa\\wwwroot\\online2\\bank\\seb\\private_key.pem", "r");
$priv_key = fread($fp, 8192);
fclose($fp);

$pkeyid = openssl_get_privatekey($priv_key, "ms410a"); //otrs parametrs - passphrase privatas atslegas failam

if(!$pkeyid){die("private key error");}

//echo "<br>key --->".$priv_key;
//echo "<br>keyId --->".$pkeyid;

$signature = "";

// compute signature
if(!openssl_sign($data, $signature, $pkeyid)){
	die("signature calculation error");
};


//test verify
/*$fp = fopen("e:\\globa\\wwwroot\\online2\\bank\\seb\\public_key.pem", "r");
$pub_key = fread($fp, 8192);
fclose($fp);
$pkeyid = openssl_get_publickey($pub_key);

///die("verify = ".openssl_verify($data, $signature,$pkeyid));

if(openssl_verify($data, $signature,$pkeyid)){
	die("signature ok");
};

die("stop!");

*/

// free the key from memory
openssl_free_key($pkeyid);

$signature = base64_encode($signature); 

//die("<br>SIGNATURE: <br>".$signature);

//$bank_url = "http://www.impro.lv/online/tset/bank/get_seb.php"; 

$bank_url = "https://ibanka.seb.lv/ipc/epakindex.jsp";

?>
<html>
<head>
  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
</head>
<body>
	<form name="hbpost" action="<?php echo $bank_url;?>" method="post">

	<input type="hidden" name="IB_SND_ID"		maxlength="10"	value="<?php  echo $IB_SND_ID;?>"	>
	<input type="hidden" name="IB_SERVICE"		maxlength="4"	value="<?php  echo $IB_SERVICE;?>"	>
	<input type="hidden" name="IB_VERSION"		maxlength="3"	value="<?php  echo $IB_VERSION;?>"		>
	<input type="hidden" name="IB_AMOUNT"		maxlength="17"	value="<?php  echo $IB_AMOUNT;?>"		>
	<input type="hidden" name="IB_CURR"			maxlength="3"	value="<?php  echo $IB_CURR;?>"		>
	<input type="hidden" name="IB_NAME"			maxlength="30"	value="<?php echo $IB_NAME;?>"		>
	<input type="hidden" name="IB_PAYMENT_ID"	maxlength="20" value="<?php  echo $IB_PAYMENT_ID;?>"	>
	<input type="hidden" name="IB_PAYMENT_DESC"	maxlength="100" value="<?php  echo $IB_PAYMENT_DESC;?>"	>
	<input type="hidden" name="IB_CRC"			maxlength="300"	value="<?php  echo $signature;?>"		>
	<input type="hidden" name="IB_FEEDBACK"		maxlength="150"	value="<?php  echo $IB_FEEDBACK;?>"		>
	<input type="hidden" name="IB_LANG"			maxlength="3"	value="<?php  echo $IB_LANG;?>"		>

	</form>
	<script>
		document.hbpost.submit();
	</script>
</body>
</html>

<?php

//--- funkcijas -------------------------------------------------------
                      
Function str_garums($garums){
	
	$len = strlen($garums);

	switch (strlen($len)) {
		case 0:
			return "000";
			break;
		case 1:
			return "00".$len;
			break;
		case 2:
			return "0".$len;
			break;		
		case 3:
			return $len;
			break;
	}

}
function uncode_lv_special_chars_utf8($string) {
	$search = array();
	$replace = array();
	$search[] = '#a';
	$replace[]  = 'a';
	$search[] = '#c';
	$replace[]  = 'c';
	$search[] = '#e';
	$replace[]  = 'e';
	$search[] = '#g';
	$replace[]  = 'g';
	$search[] = '#i';
	$replace[]  = 'i';
	$search[] = '#k';
	$replace[]  = 'k';
	$search[] = '#l';
	$replace[]  = 'l';
	$search[] = '#n';
	$replace[]  = 'n';
	$search[] = '#s';
	$replace[]  = 's';
	$search[] = '#u';
	$replace[]  = 'u';
	$search[] = '#z';
	$replace[]  = 'z';
	$search[] = '#A';
	$replace[]  = 'A';
	$search[] = '#C';
	$replace[]  = 'C';
	$search[] = '#E';
	$replace[]  = 'E';
	$search[] = '#G';
	$replace[]  = 'G';
	$search[] = '#I';
	$replace[]  = 'I';
	$search[] = '#K';
	$replace[]  = 'K';
	$search[] = '#L';
	$replace[]  = 'L';
	$search[] = '#N';
	$replace[]  = 'N';
	$search[] = '#S';
	$replace[]  = 'S';
	$search[] = '#U';
	$replace[]  = 'U';
	$search[] = '#Z';
	$replace[]  = 'Z';
	$search[] = '#O';
	$replace[]  = 'O';
	$search[] = '#o';
	$replace[]  = 'o';

	return str_replace($search, $replace, $string);
}
/*
function uncode_latvian_special_chars_utf8($string) {
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
	$replace[]  = 'Ž';

	return str_replace($search, $replace, $string);
}
*/
?>
