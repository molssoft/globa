<?
//require_once('inc/php_functions.php');

//šim failam jābut utf8 kodējumā!!!

//pēc datu posta no asp faila latviešu garumzīmes pazūd, tāpēc postējot simboli tiek aizvietoti ar #simbols

header("Content-type: text/html; charset=utf-8"); 
date_default_timezone_set('Europe/Riga');
//print_r($_POST);

//echo "<br> pamatojums -> ".$_POST['VK_MSG']." = ".utf8_decode($_POST['VK_MSG']);

//echo "<br> str_garums -> ".str_garums($_POST['VK_MSG'])." = ".str_garums(utf8_encode($_POST['VK_MSG']));




foreach ($_POST as $key => $value){

		$$key = uncode_lv_special_chars_utf8($value);  
		//$$key = $value;

}
file_put_contents("log\post.txt",date("Y-m-d H:i:s")." POST DNB ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);

//$VK_MSG = "Rezervācija"; 
//$VK_MSG = utf8_encode($VK_MSG);

//echo "<br> pamatojums -> ".$VK_MSG." = ".utf8_decode($VK_MSG);
//echo "<br> str_garums -> ".str_pad(strlen($VK_MSG), 3, "0", STR_PAD_LEFT)." = ".str_pad(strlen(utf8_decode($VK_MSG)), 3, "0", STR_PAD_LEFT);


$paraksts = $paraksts . str_pad(strlen($VK_SERVICE), 3, "0", STR_PAD_LEFT) . $VK_SERVICE;
$paraksts = $paraksts . str_pad(strlen($VK_VERSION), 3, "0", STR_PAD_LEFT) . $VK_VERSION;
$paraksts = $paraksts . str_pad(strlen($VK_SND_ID), 3, "0", STR_PAD_LEFT) . $VK_SND_ID;
$paraksts = $paraksts . str_pad(strlen($VK_STAMP), 3, "0", STR_PAD_LEFT) . $VK_STAMP;
$paraksts = $paraksts . str_pad(strlen($VK_AMOUNT), 3, "0", STR_PAD_LEFT) . $VK_AMOUNT;
$paraksts = $paraksts . str_pad(strlen($VK_CURR), 3, "0", STR_PAD_LEFT) . $VK_CURR;
$paraksts = $paraksts . str_pad(strlen($VK_ACC), 3, "0", STR_PAD_LEFT) . $VK_ACC;
$paraksts = $paraksts . str_pad(strlen(utf8_decode($VK_NAME)), 3, "0", STR_PAD_LEFT) . $VK_NAME;
$paraksts = $paraksts . str_pad(strlen($VK_REG_ID), 3, "0", STR_PAD_LEFT) . $VK_REG_ID;
$paraksts = $paraksts . str_pad(strlen($VK_SWIFT), 3, "0", STR_PAD_LEFT) . $VK_SWIFT;
$paraksts = $paraksts . str_pad(strlen($VK_REF), 3, "0", STR_PAD_LEFT) . $VK_REF;
$paraksts = $paraksts . str_pad(strlen(utf8_decode($VK_MSG)), 3, "0", STR_PAD_LEFT) . $VK_MSG;
$paraksts = $paraksts . str_pad(strlen($VK_RETURN), 3, "0", STR_PAD_LEFT) . $VK_RETURN;
$paraksts = $paraksts . str_pad(strlen($VK_RETURN2), 3, "0", STR_PAD_LEFT) . $VK_RETURN2;

//echo "<br>Paraksts: ".$paraksts;
//echo "<br>VK_MSG: ".str_pad(strlen(utf8_decode($VK_MSG)), 3, "0", STR_PAD_LEFT) . $VK_MSG;
//die();


echo "<br>Lūdzu uzgaidiet...<br>";

//Generate PDF
//require_once('inc/php_functions.php');
//connect_to_mssql();
$rez_id = $_POST['rez_id'];
/*$ligums = get_ligums($rez_id);
//--- izmaiņas 19.dec 2012. katru reizi ģenerēt līgumu nevajag. tikai pirmo reizi.
if(is_array($ligums)){
	require_once('inc/generate_ligums.php');
	$avanss = $ligums['avanss'];
	$pdf_content = generate_ligums($rez_id, 'official', $avanss);
	$data = unpack("H*hex", $pdf_content);
	mssql_query("UPDATE [ligumi] SET bpdf = 0x{$data['hex']} WHERE [rez_id] = $rez_id AND deleted = 0");
}*/
//echo "<br>";

//$data = $_POST['VK_MAC'];
$data = $paraksts;

//echo "VK_MAC: ".$data;

$fp = fopen("dnbnord/private_key.pem", "r");
$priv_key = fread($fp, 8192);
fclose($fp);

$pkeyid = openssl_get_privatekey($priv_key, "ms410a"); //otrs parametrs - passphrase privatas atslegas failam

if(!$pkeyid){die("Kļūda izpildot pieprasījumu 1002");}

//echo "<br>key --->".$priv_key;
//echo "<br>keyId --->".$pkeyid;

$signature = "";

// compute signature
if(!openssl_sign($data, $signature, $pkeyid)){
	die("signature calculation error");
};

/*
//test verify
$fp = fopen("e:\\bank\\dnbnord\\pub_key.pem", "r");
$pub_key = fread($fp, 8192);
fclose($fp);
$pkeyid = openssl_get_publickey($pub_key);

///die("verify = ".openssl_verify($data, $signature,$pkeyid));

if(openssl_verify($data, $signature,$pkeyid)){
	die("signature ok");
};

//die("stop!");
*/

// free the key from memory
openssl_free_key($pkeyid);

$signature = base64_encode($signature); 

//die("<br>SIGNATURE: <br>".$signature);

//echo "Sheit ir gatava forma, kas jaaposto uz DnB NORD ";

//$bank_url = "http://www.impro.lv/online/tset/bank/get_dnbnord.php"; 
//$bank_test_url = "http://inord-t.dnbnord.lv/iNORDLink/index.php";
//$bank_url = "https://www.inord.lv/inordlink/index.php";

//Iepriekšējā adrese bija: https://www.inord.lv/inordlink/index.php
//Jaunā adrese ir: https://ib.dnb.lv/login/index.php
$bank_url = "https://ib.luminor.lv/login/index.php";

?>
<html>
<head>
  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
</head>
<body>
	<form name="hbpost" action="<?php echo $bank_url;?>" method="post">

	<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?php  echo $_POST['VK_SERVICE'];?>"	>
	<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?php  echo $_POST['VK_VERSION'];?>"	>
	<input type="hidden" name="VK_SND_ID"	maxlength="20"	value="<?php  echo $_POST['VK_SND_ID'];?>"	>
	<input type="hidden" name="VK_STAMP"	maxlength="32"	value="<?php  echo $_POST['VK_STAMP'];?>"	>
	<input type="hidden" name="VK_AMOUNT"	maxlength="13"	value="<?php  echo $_POST['VK_AMOUNT'];?>"	>
	<input type="hidden" name="VK_CURR"		maxlength="3"	value="<?php  echo $_POST['VK_CURR'];?>"	>
	<input type="hidden" name="VK_ACC"		maxlength="21"	value="<?php  echo $_POST['VK_ACC'];?>">
	<input type="hidden" name="VK_NAME"		maxlength="105" value="<?php  echo $VK_NAME; ?>">
	<input type="hidden" name="VK_REG_ID"	maxlength="20"	value="<?php  echo $_POST['VK_REG_ID'];?>">
	<input type="hidden" name="VK_SWIFT"	maxlength="20"	value="<?php  echo $_POST['VK_SWIFT'];?>">
	<input type="hidden" name="VK_REF"		maxlength="20"	value="<?php  echo $_POST['VK_REF'];?>"	>
	<input type="hidden" name="VK_MSG"		maxlength="140"	value="<?php  echo $VK_MSG; ?>"	>
	<input type="hidden" name="VK_RETURN"	maxlength="400"	value="<?php  echo $_POST['VK_RETURN'];?>"	>
	<input type="hidden" name="VK_RETURN2"	maxlength="400"	value="<?php  echo $_POST['VK_RETURN2'];?>"	>
	<input type="hidden" name="VK_MAC"		maxlength="300"	value="<?php  echo $signature;?>"	>
	<input type="hidden" name="VK_TIME_LIMIT" maxlength="19" value="<?php echo $_POST['VK_TIME_LIMIT'];?>"	>
	<input type="hidden" name="VK_LANG"		maxlength="3"	value="<?php  echo $_POST['VK_LANG'];?>"	>
	</form>
	
	<!--<form name="test_post" action="post_dnb_test.php" method="post">
	<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?php  echo $_POST['VK_SERVICE'];?>"	>
	<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?php  echo $_POST['VK_VERSION'];?>"	>
	<input type="hidden" name="VK_SND_ID"	maxlength="20"	value="<?php  echo $_POST['VK_SND_ID'];?>"	>
	<input type="hidden" name="VK_STAMP"	maxlength="32"	value="<?php  echo $_POST['VK_STAMP'];?>"	>
	<input type="hidden" name="VK_AMOUNT"	maxlength="13"	value="<?php  echo $_POST['VK_AMOUNT'];?>"	>
	<input type="hidden" name="VK_CURR"		maxlength="3"	value="<?php  echo $_POST['VK_CURR'];?>"	>
	<input type="hidden" name="VK_ACC"		maxlength="21"	value="<?php  echo $_POST['VK_ACC'];?>">
	<input type="hidden" name="VK_NAME"		maxlength="105" value="<?php  echo $VK_NAME; ?>">
	<input type="hidden" name="VK_REG_ID"	maxlength="20"	value="<?php  echo $_POST['VK_REG_ID'];?>">
	<input type="hidden" name="VK_SWIFT"	maxlength="20"	value="<?php  echo $_POST['VK_SWIFT'];?>">
	<input type="hidden" name="VK_REF"		maxlength="20"	value="<?php  echo $_POST['VK_REF'];?>"	>
	<input type="hidden" name="VK_MSG"		maxlength="140"	value="<?php  echo $VK_MSG; ?>"	>
	<input type="hidden" name="VK_RETURN"	maxlength="400"	value="<?php  echo $_POST['VK_RETURN'];?>"	>
	<input type="hidden" name="VK_RETURN2"	maxlength="400"	value="<?php  echo $_POST['VK_RETURN2'];?>"	>
	<input type="hidden" name="VK_MAC"		maxlength="300"	value="<?php  echo $signature;?>"	>
	<input type="hidden" name="VK_TIME_LIMIT" maxlength="19" value="<?php echo $_POST['VK_TIME_LIMIT'];?>"	>
	<input type="hidden" name="VK_LANG"		maxlength="3"	value="<?php  echo $_POST['VK_LANG'];?>"	>
	</form>-->
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
