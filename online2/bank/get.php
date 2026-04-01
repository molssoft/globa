<?
//print_r($_POST);

session_save_path('../tmp/') ;
session_start();
$uniq_id = uniqid("Swedbank-pid#");
$f_name = "get.php";
date_default_timezone_set('Europe/Riga');
require_once('../m_init.php');
$db = new Db; 
require_once('i_bank_functions.php');	 
require_once("../m_user_tracking.php");
$u_track = new UserTracking();
//require_once('../inc/php_functions.php'); 
/*$_POST['VK_SERVICE'] = '1101';
$_POST['VK_VERSION'] = '008';
$_POST['VK_SND_ID'] = 'HP';
$_POST['VK_REC_ID'] = 'IMPRO';
$_POST['VK_STAMP'] = '232';
$_POST['VK_T_NO'] = '234';
$_POST['VK_AMOUNT'] = '0.35';
$_POST['VK_CURR'] = 'LVL';
$_POST['VK_REC_ACC'] = 'LV02HABA0001408051509';
$_POST['VK_REC_NAME'] = 'IMPRO CEÏOJUMI SIA';
$_POST['VK_SND_ACC'] = 'LV73HABA0551003199315';
$_POST['VK_SND_NAME'] = 'NILS AUSTRUMS';
$_POST['VK_REF'] = '53_59';
$_POST['VK_MSG'] = 'Impro online rezervâcija. TEST GRUPA 2 - ÈEH... (rez_id=59)';
$_POST['VK_T_DATE'] = '10.08.2009';
$_POST['VK_MAC'] = 'UAl4vMvFurKPUQElvzwHkuO+b2+Uj+rST/TSTPinjwi17CBqouB368dEkVbZKGFUcl4vRrBndrBP0TLZ2njoswiaKZQal27QePP3aONlYntdg5GwN12KMK8SdLPfbHO/8JOU4oSlNtC6LSeYGX36PWu7Jae5PMuXsaYGjUT4PoM=';
*/

$r_method = $_SERVER['REQUEST_METHOD'];

//$r_method = 'POST';
//echo "<br>method=".$r_method."<br>";
//print_r($_GET);

$bank_response_data = array();

if($r_method == 'GET'){
	// logs failâ
	$text = "GET SWED ".print_r($_GET,true);
	
	foreach ($_GET as $key => $value)
		$$key = $value;

   //header('Location:http://www.impro.lv/online/bank/get.asp'.$_SERVER[QUERY_STRING]);
   //die("get");

  $bank_response_data = $_GET;
  //lai paspçtu post pienâkt pirmais, nedaudz iemidzinam skriptu:
	sleep(60);
	
} elseif($r_method == 'POST') {
	
	$text = "POST SWED ".print_r($_POST,true);
	$q_str = '?';
	
	foreach ($_POST as $key => $value){

		$$key = $value;       
	  
	  //--- veido querystring
	  if($q_str!='?') 
		$q_str .= '&';

	  $q_str = $q_str.$key.'='.$value;

	  $bank_response_data = $_POST;

	}
	            
}
// logs failâ
Log2File($text,$f_name);




	//paraksta stringa seciiba vadoties peec bankas specifikaacijas

if($VK_SERVICE=="1101"){

	$data = $data.str_garums($VK_SERVICE).$VK_SERVICE;
	$data = $data.str_garums($VK_VERSION).$VK_VERSION;	
	$data = $data.str_garums($VK_SND_ID).$VK_SND_ID;
	$data = $data.str_garums($VK_REC_ID).$VK_REC_ID;
	$data = $data.str_garums($VK_STAMP).$VK_STAMP;	
	$data = $data.str_garums($VK_T_NO).$VK_T_NO;	
	$data = $data.str_garums($VK_AMOUNT).$VK_AMOUNT;	
	$data = $data.str_garums($VK_CURR).$VK_CURR;	
	$data = $data.str_garums($VK_REC_ACC).$VK_REC_ACC;	
	$data = $data.str_garums(utf8_decode($VK_REC_NAME)).$VK_REC_NAME;	
	$data = $data.str_garums($VK_SND_ACC).$VK_SND_ACC;	
	$data = $data.str_garums(utf8_decode($VK_SND_NAME)).$VK_SND_NAME;	
	$data = $data.str_garums($VK_REF).$VK_REF;
	$data = $data.str_garums(utf8_decode($VK_MSG)).$VK_MSG;
	$data = $data.str_garums($VK_T_DATE).$VK_T_DATE;
	//$data = $data.str_garums($VK_LANG).$VK_LANG;
	//$data = $data.str_garums($VK_AUTO).$VK_AUTO;

}else if($VK_SERVICE=="1901"){

	$data = $data.str_garums($VK_SERVICE).$VK_SERVICE;
	$data = $data.str_garums($VK_VERSION).$VK_VERSION;	
	$data = $data.str_garums($VK_SND_ID).$VK_SND_ID;
	$data = $data.str_garums($VK_REC_ID).$VK_REC_ID;
	$data = $data.str_garums($VK_STAMP).$VK_STAMP;	
	$data = $data.str_garums($VK_REF).$VK_REF;
	$data = $data.str_garums(utf8_decode($VK_MSG)).$VK_MSG;
	//$data = $data.str_garums($VK_LANG).$VK_LANG;
	//$data = $data.str_garums($VK_AUTO).$VK_AUTO;

}

	
	//-------------------------

	//echo "<br><br>DATA = ".$data."<br><br>**************************************************";
	//echo "sourcecrypt = ".$sourcecrypt."<br>" ;
	//echo "public key = ".$res."<br>";
	//echo "<br>public key string = ".$pub_key."<br>";


$sourcecrypt = base64_decode($VK_MAC);

if(!$sourcecrypt) {
	$error = "base64_decode false";
	$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
	$text .= $error;	
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
	$u_track->Save($text);
	die("base64_decode false");
}


//echo "Paraksts : ".$sourcecrypt."<BR>";

$fp=fopen('e:\\globa\\wwwroot\\online2\\bank\\swedbank\\bank-cert.pem', "r"); 
$pub_key=fread ($fp,8192);
fclose($fp);
$res=openssl_get_publickey($pub_key);

if(!$res){
	$error = "publickey error";
	$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
	$text .= $error;		
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');		
	$u_track->Save($text);
	die("publickey error");
}


//openssl_public_decrypt ($sourcecrypt,$newsource,$res);
//echo "Source decrypt : $newsource<BR><BR>------------------------------------------";

//----------------------

	$result = openssl_verify($data,$sourcecrypt,$res);
    openssl_free_key($res);  
	
	//echo "Rezultâts:" . $result;

	//....
	if ($result ) {
    	//connect_to_mssql();
		require_once("../m_merchant_session.php");
		$merchant_session = new MerchantSession();			
		$arr = $merchant_session->CreatePhpSession(0,0,'swedbank',$bank_response_data);

		//var_dump($bank_response_data);
		$hash = $arr['hash'];
    	//$hash = create_asp_session(0,0,'swedbank',$bank_response_data);
	    if ($hash) {
			$l_url = "get_2.php?hash=$hash";
			//$text = "<b>Maksāšana caur Swedbank-iekïaujam get_2.php</b>:$l_url<br>";	
			
			//$u_track->Save($text);
			$sget['hash'] = $hash;
			include_once("get_2.php");
    		//header('Location: '.$l_url);
			
			//$text = "<b>Redirects nenostrâdâja</b>:$l_url<br>";						
			//$u_track->Save($text);
			exit();
		} else {
			$error = "CreatePhpSession hash error";
			$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
			$text .= $error;
			$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');				
			$u_track->Save($text);
			die('CreatePhpSession hash error');
		}
	} else {
		$error = "Veryfication error<br>";
		$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
		$text .= $error;	
		$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');			
		$u_track->Save($text);
		die("Veryfication error<br>");
	}


//}else{
//	die("Decryption error<br>");
//}


$error = "Nenokļūstam uz get_2.php";
$text = "<b>Maksāšana caur Swedbank-kļūda</b>:<br>";
$text .= $error;
$text = mb_convert_encoding($text, 'ISO-8859-13','UTF-8');					
$u_track->Save($text);
die();
  //--- redirekts uz asp
  


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



?>