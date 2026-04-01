<?

// Restore user session when Luminor returns (cross-site POST does not send cookies).
// Requires trans_dnbnord.php_session_id column (NVARCHAR(255) NULL).
//AI
if (!empty($_POST['VK_STAMP'])) {
	require_once('../m_init.php');
	$db_early = new Db;
	$result = $db_early->Query('SELECT php_session_id FROM trans_dnbnord WHERE id = ?', [$_POST['VK_STAMP']]);
	if ($result) {
		$row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC);
		if ($row && !empty($row['php_session_id'])) {
			session_id($row['php_session_id']);
		}
	}
}
//AI

session_save_path('../tmp/');
session_start();
date_default_timezone_set('Europe/Riga');
require_once('../m_init.php');
require_once("../m_user_tracking.php");

$u_track = new UserTracking();

$db = new Db;
// logs failâ
	file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." POST DNB ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);
//exit();
    
//require_once('../inc/php_functions.php');
 require_once('i_bank_functions.php');

/*$_POST['VK_SERVICE'" = '1102';
$_POST['VK_VERSION'" = '008';
$_POST['VK_SND_ID'" = 'HP';
$_POST['VK_REC_ID'" = 'IMPRO';
$_POST['VK_STAMP'" = '232';
$_POST['VK_T_NO'" = '234';
$_POST['VK_AMOUNT'" = '0.35';
$_POST['VK_CURR'" = 'LVL';
$_POST['VK_REC_ACC'" = 'LV02HABA0001408051509';
$_POST['VK_REC_NAME'" = 'IMPRO CEÏOJUMI SIA';
$_POST['VK_SND_ACC'" = 'LV73HABA0551003199315';
$_POST['VK_SND_NAME'" = 'NILS AUSTRUMS';
$_POST['VK_REF'" = '53_59';
$_POST['VK_MSG'" = 'Impro online rezervâcija. TEST GRUPA 2 - ÈEH... (rez_id=59)';
$_POST['VK_T_DATE'" = '10.08.2009';
$_POST['VK_MAC'" = 'UAl4vMvFurKPUQElvzwHkuO+b2+Uj+rST/TSTPinjwi17CBqouB368dEkVbZKGFUcl4vRrBndrBP0TLZ2njoswiaKZQal27QePP3aONlYntdg5GwN12KMK8SdLPfbHO/8JOU4oSlNtC6LSeYGX36PWu7Jae5PMuXsaYGjUT4PoM=';
*/
//testam:
/*
$_POST = array
(
"testam" => 1,
    "VK_SERVICE" => "1102",
    "VK_VERSION" => "101",
    "VK_SND_ID" => "RIKOLV2X",
    "VK_REC_ID" => "10022",
    "VK_STAMP" => "718",
    "VK_T_NO" => "612045843",
    "VK_AMOUNT" => "0.01",
    "VK_CURR" => "EUR",
    "VK_REC_ACC" => "LV76RIKO0002010047384",
    "VK_REC_NAME" => "IMPRO CELOJUMI",
    "VK_REC_REG_ID" => "40003235627",
    "VK_REC_SWIFT" => "RIKOLV2X",
    "VK_SND_ACC" => "TEST",
    "VK_SND_NAME" => "TEST",
    "VK_REF" => "6385_E63CF104-9389-test",
    "VK_MSG" => "Impro online rezervacija. Test",
    "VK_T_DATE" => "14.09.2016",
    "VK_T_STATUS" => "2",
    "VK_MAC" => "IEzAELLnWhuocVEVBdlsBqovW6RD7BZLpe1aM9wc03yjIM11jzJ0NiK2dQWSNnOPbflQJbwPeWqcq1ng+TdkAe69Xl889ZAFgOpkvZt1PXLGjUNLDjbiQlCyDQCwTVlZoZcclVoGCbGnM8lwzfFkIyOo5EWMKloNUXgQpI5PTHE5xmMa+liKwhz+o1ZVqDpeWv6/Kd2TqYCX8e4QBWXzEbddkNDbcmBC9JZYc5R5CvBChd81ZruvVqxDNJ9JbYrszbPg6Dl8ODkMYga+0GqJb3a5KoxAd0kbXb1ZnjMe5wBwt7RkeXsi7nC0FcmYnZY2gqzeV+/A4QLxnlCyapCadA==",
    "VK_LANG" => "LAT",
    "VK_RETURN" => "https://www.impro.lv/online/bank/get_dnbnord.php"
);


$_POST = array
(
        'VK_SND_ACC' => 'LV85RIKO0001050477923','VK_T_NO' => '681250013','VK_T_DATE' => '15.06.2017','VK_SND_ID' => 'RIKOLV2X','VK_MSG' => 'Impro online rezervacija. Islandes lielais ... (rez_id_24421)','VK_VERSION' => '101','VK_STAMP' => '849','VK_REC_SWIFT' => 'RIKOLV2X','VK_T_STATUS' => '1','VK_REF' => '7398_906B37F0-7764-','VK_REC_ACC' => 'LV76RIKO0002010047384','VK_CURR' => 'EUR','VK_AMOUNT' => '500.00','VK_REC_REG_ID' => '40003235627','VK_SERVICE' => '1102','VK_MAC' => 'YzsDn2y6weVOngNXlNbYOMa5GigXjdTXnL78fQDxm6btW3kXP+7RLtG3titBEfXAX5D1A53mZEx8p39EOkYfGfQzibZzF/xgEMQd0J6NQ6NQjOxfHIFJytJAzCiHrNX5VS00bAbnc72ypB4GBKbhn8i/Z4eGZPRYhgGqyizSYOwlIj9SJkEFCU2n/p8XVYmuMFPjck43M3px1u126QC5fxj65V6yYtaipkEHu4tI810CmHGb4wGOZoJhsWNLtfBambS3M8sIQ5pdEnnqpFp/icVed1LOVx8wFvM7EvmTskDNRJraeq06nG0/0YK8Nx/vLEuMBQOsGgkZJwFUwE9fSQ==','VK_SND_NAME' => 'LIEPIÅ…Å  GUNTARS','VK_REC_NAME' => 'IMPRO CELOJUMI','VK_LANG' => 'LAT','VK_REC_ID' => '10022'
)
;*/
//connect_to_mssql();
LogPost($_POST);


//$r_method = $_SERVER['REQUEST_METHOD'];

//$r_method = 'POST';
//echo "<br>method=".$r_method."<br>";
//print_r($_GET);

$bank_response_data = array();


	
	foreach ($_POST as $key => $value){

		$$key = $value;       
	  
	}

	$bank_response_data = $_POST;
	            

//$VK_SND_NAME = "rezervÃ¢cija";
//echo "VK_SND_NAME = ".$VK_SND_NAME;
//echo "<br>VK_SND_NAME = ".utf8_decode($VK_SND_NAME)." = ".$VK_SND_NAME;
//echo "<br>".str_garums(utf8_decode($VK_SND_NAME))." = ".str_garums($VK_SND_NAME);
//die("stop"); 


//paraksta stringa seciiba vadoties peec bankas specifikaacijas

if($VK_SERVICE=="1102"){

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
	$data = $data.str_garums($VK_REC_REG_ID).$VK_REC_REG_ID;
	$data = $data.str_garums($VK_REC_SWIFT).$VK_REC_SWIFT;
	$data = $data.str_garums($VK_SND_ACC).$VK_SND_ACC;	
	$data = $data.str_garums(utf8_decode($VK_SND_NAME)).$VK_SND_NAME;	
	$data = $data.str_garums($VK_REF).$VK_REF;
	$data = $data.str_garums(utf8_decode($VK_MSG)).$VK_MSG;
	$data = $data.str_garums($VK_T_DATE).$VK_T_DATE;
	$data = $data.str_garums($VK_T_STATUS).$VK_T_STATUS;

	//$data = $data.str_garums($VK_LANG).$VK_LANG;


}else{
	$error = "bank request error";
	$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	die($error);

}

	
	//-------------------------

	//echo "<br><br>DATA = ".$data."<br><br>**************************************************";
	//echo "sourcecrypt = ".$sourcecrypt."<br>" ;
	//echo "public key = ".$res."<br>";
	//echo "<br>public key string = ".$pub_key."<br>";
	//echo "<br>VK_MAC = ".$VK_MAC;


$sourcecrypt = base64_decode($VK_MAC); //

if(!$sourcecrypt) {
	$error = "base64_decode false";
	$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	die($error);
}


//echo "Paraksts : ".$sourcecrypt."<BR>";
//die();

$fp=fopen('e:\\globa\\wwwroot\\online2\\bank\\dnbnord\\bank_prod.crt', "r"); //--- bank_prod.crt //bank_test
$pub_key=fread ($fp,8192);
fclose($fp);
$res=openssl_get_publickey($pub_key);

if(!$res) {
	$error = "publickey error";
	$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	die($error);
	
}


//openssl_public_decrypt ($sourcecrypt,$newsource,$res);
//echo "Source decrypt : $newsource<BR><BR>------------------------------------------";

//----------------------

	$result = openssl_verify($data,$sourcecrypt,$res);
    openssl_free_key($res);  
	
	//echo "<br>Rezultâts:" . $result ."<br>";
	//die();

	//....
	//testam
	var_dump($_POST);
	if (isset($_POST['testam'])){$result= true;}
	if ($result ) {

    	//connect_to_mssql();
		require_once("../m_merchant_session.php");
		$merchant_session = new MerchantSession();			
		$hash = $merchant_session->CreatePhpSession(0,0,'dnbnord',$bank_response_data);
    //	$hash = create_asp_session(0,0,'dnbnord',$bank_response_data);
	    if ($hash) {
  		 
			$text = "<b>Maksâðana caur DNB- iekïaujam uz get_dnbnord_2.php</b>:<br>";

			
			$u_track->Save($text);
			require_once("get_dnbnord_2.php");
			
			$u_track->Save($text);
    		//header('Location: get_dnbnord_2.php?hash='.$hash['hash']);
			//exit();
			
		} else {
			$error = 'CreatePhpSession hash error';
			$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
			$text .= $error;	
			$u_track->Save($text);
			die($error);
		}
	} else {
		$error = "Data veryfication error<br>";
		$text = "<b>Maksâðana caur DNB-kïûda</b>:<br>";
		$text .= $error;	
		$u_track->Save($text);
		die($error);
	}

//}else{
//	die("Decryption error<br>");
//}



die();

  


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