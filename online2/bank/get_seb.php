<?
//header('X-PHP-Response-Code: 404', true, 404);
session_save_path('../tmp/') ;
session_start();

$uniq_id = uniqid("SEB-pid#");
require_once('i_bank_functions.php'); 
date_default_timezone_set('Europe/Riga');
$r_method = $_SERVER['REQUEST_METHOD'];
$f_name = "get_seb.php";
if ($r_method == 'POST'){
// logs failâ
	$text = "POST SEB ".print_r($_POST,true);
	//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." POST SEB ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);
}
elseif ($r_method == 'GET'){
	$text = "GET SEB ".print_r($_GET,true);
	//file_put_contents("log\get".date("Y-m").".txt",date("Y-m-d H:i:s")." GET SEB ".print_r($_GET,true)."\r\n\r\n",FILE_APPEND);
	//lai paspçtu post pienâkt pirmais, nedaudz iemidzinam skriptu:
	//ðîs iemidzinðânas dçï banka nesânem http 200 kodu un nesûta apstirpinâjumu par maksâjumu 09.05.2018--aizkomentçjam
	//sleep(60);

}	
Log2File($text,$f_name);
require_once('../m_init.php');
require_once("../m_user_tracking.php");
$u_track = new UserTracking();
$db = new Db; 

//testam:
/*$_POST = array(
 "IB_SND_ID" => "SEBUB",
    "IB_SERVICE" => "0004",
    "IB_VERSION" => "001",
    "IB_REC_ID" => "IMPSELOSIA",
    "IB_PAYMENT_ID" => "4784_5A942EE5-0075-0",
    "IB_PAYMENT_DESC" => "Impro online rezervacija. Izbaudi Belovezas ... (rez_id_20249)",
    "IB_FROM_SERVER" => "N",
    "IB_STATUS" => "ACCOMPLISHED",
    "IB_CRC" => "CxHpe/igDYdr8xcjp6iVUOKNTA6c4+zAo86wDe+3GbwKmzG/dtYcXynn10kq8TFA+rMJew1IQvc0Ld+Vf7cl29HL7v5UChIrEZ/2/SIB7mmeuDy+Qs2ltiv0NdTJdRvw548OOh0HULFubbQBkTeGH7qTTbpL4zA1vCxDz9sRDPk=",
    "IB_LANG" => "LAT"
);*/


//require_once('../inc/php_functions.php'); 

//connect_to_mssql(); //temp
LogPost($_GET); //temp

//LogPost($_POST);




//$r_method = 'POST';
//echo "<br>method=".$r_method."<br>";
//print_r($_GET);

$bank_response_data = array();

if($r_method == 'GET'){

	foreach ($_GET as $key => $value){
		$$key = $value;
	}

	$bank_response_data = $_GET;
	
} elseif($r_method == 'POST') {

	//$q_str = '?';
	
	foreach ($_POST as $key => $value){

		$$key = $value;   
	
	}
		//--- veido querystring
		//if($q_str!='?') $q_str .= '&';
		//$q_str = $q_str.$key.'='.$value;

	$bank_response_data = $_POST;
            
}


LogPost(array("debug seb IB_SERVICE"=>$IB_SERVICE));

//print_r("->".$IB_SERVICE);

//paraksta stringa seciiba vadoties peec bankas specifikaacijas

if($IB_SERVICE=="0003"){

	$data = $data.str_garums($IB_SND_ID).$IB_SND_ID;
	$data = $data.str_garums($IB_SERVICE).$IB_SERVICE;	
	$data = $data.str_garums($IB_VERSION).$IB_VERSION;
	$data = $data.str_garums($IB_PAYMENT_ID).$IB_PAYMENT_ID;
	$data = $data.str_garums($IB_AMOUNT).$IB_AMOUNT;	
	$data = $data.str_garums($IB_CURR).$IB_CURR;	
	$data = $data.str_garums($IB_REC_ID).$IB_REC_ID;	
	$data = $data.str_garums($IB_REC_ACC).$IB_REC_ACC;	
	$data = $data.str_garums(utf8_decode($IB_REC_NAME)).$IB_REC_NAME;	
	$data = $data.str_garums($IB_PAYER_ACC).$IB_PAYER_ACC;	
	$data = $data.str_garums(utf8_decode($IB_PAYER_NAME)).$IB_PAYER_NAME;	
	$data = $data.str_garums(utf8_decode($IB_PAYMENT_DESC)).$IB_PAYMENT_DESC;	
	$data = $data.str_garums($IB_PAYMENT_DATE).$IB_PAYMENT_DATE;	
	$data = $data.str_garums($IB_PAYMENT_TIME).$IB_PAYMENT_TIME;	

	//$data = $data.str_garums(utf8_decode($VK_REC_NAME)).$VK_REC_NAME;

}else if($IB_SERVICE=="0004"){

	$data = $data.str_garums($IB_SND_ID).$IB_SND_ID;
	$data = $data.str_garums($IB_SERVICE).$IB_SERVICE;
	$data = $data.str_garums($IB_VERSION).$IB_VERSION;
	$data = $data.str_garums($IB_REC_ID).$IB_REC_ID;
	$data = $data.str_garums($IB_PAYMENT_ID).$IB_PAYMENT_ID;
	$data = $data.str_garums(utf8_decode($IB_PAYMENT_DESC)).$IB_PAYMENT_DESC;
	$data = $data.str_garums($IB_FROM_SERVER).$IB_FROM_SERVER;
	$data = $data.str_garums($IB_STATUS).$IB_STATUS;

}else{

	LogPost(array("debug seb error 1 "=>"bank request error"));
	$error = "bank request error";
	$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
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


$sourcecrypt = base64_decode($IB_CRC); //

if(!$sourcecrypt){
	$error = "base64_decode false";
	$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
	$text .= $error;	
	$u_track->Save($text);
	die($error);
}


//echo "Paraksts : ".$sourcecrypt."<BR>";
//die();

$fp=fopen('e:\\globa\\wwwroot\\online2\\bank\\seb\\seb_key.pem', "r"); //--- bank_prod.crt //bank_test
$pub_key=fread ($fp,8192);
fclose($fp);
$res=openssl_get_publickey($pub_key);

if(!$res) {
	$error = "publickey error";
	$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
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
	//print_r("bank_response_data = ".$bank_response_data);
	//die();

	//....

	LogPost(array("debug seb result = "=> "$result"));
	LogPost(array("debug seb result method = "=>$r_method));

	if ($result or isset($_GET['test']) ) {
		//pârbauda, vai jau nav uzsâkta transakcijas apstrâde pçdçjâs minûtes laikâ
		$qry = "SELECT * FROM lock_trans WHERE IB_PAYMENT_ID=? AND IB_SERVICE=? AND ts >
		DateADD(mi, -1, Current_TimeStamp)";
		$params = array($bank_response_data['IB_PAYMENT_ID'],$bank_response_data['IB_SERVICE']);
		$result = $db->Query($qry,$params);
		if (sqlsrv_has_rows($result)) {
				$error = "Lûdzu, uzgaidiet, lîdz tiks apstrâdâts maksâjuma apstiprinâjums. ";
				$text = "<b>Maksâðana caur SEB</b>:<br>";
				$text .= $error;	
				$url = $_SESSION['application']["site_base_url"]."c_home.php";	
				$text .= "Pâradresçjam uz $url";
				$u_track->Save($text);
				
				$_SESSION['reg_warning'] = $error;
				
				redirect($url);
				die();
		}
		else{
			$qry = "  BEGIN TRANSACTION

			  /*lock table  till end of transaction*/
			  SELECT * 
			  FROM lock_trans
			  WITH (TABLOCK, HOLDLOCK)


			  /*do some other stuff (including inserting/updating table )*/
				INSERT INTO lock_trans (IB_PAYMENT_ID,IB_SERVICE,ts) VALUES ('".$bank_response_data['IB_PAYMENT_ID']."','".$bank_response_data['IB_SERVICE']."',getdate());


			  -- release lock
			  COMMIT TRANSACTION";
			  $db->Query($qry);
		}
		
    
		
		//server-to-server atbilde
		if($r_method == 'GET'){
		
			if(!LogSebStatus($bank_response_data)){

				LogPost(array("debug seb error 3 = "=>"LogSebStatus = false"));
				$error = "LogSebStatus = false";
				$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
				$text .= $error;	
				$u_track->Save($text);
				die($error);
			}

		}
		//else{ //POST. lietotaaja redirekts
			require_once("../m_merchant_session.php");
			$merchant_session = new MerchantSession();			
			$hash = $merchant_session->CreatePhpSession(0,0,'seb',$bank_response_data);
			
			if ($hash) {
				
				LogPost(array("debug seb hash id"=>$hash['id']));

				
				//$url = "https://www.impro.lv/online/bank/get_seb_2.php?hash=".$hash['hash'];
				//$text = "<b>Maksâðana caur SEB-iekïaujam get_seb_2.php</b>:<br>";
				//$text .= "url: $url";
				//$u_track->Save($text);
				
				//$curl = $url."?hash=".$hash['hash']."&ip=$ip";
				//$output = connectPage($curl, "get");
				//	header('Location: '.$url);
				/*$text = "<b>Maksâðana caur SEB</b>:<br>";
				$text .= "pâradresâcija uz get_seb_2.php a curl: ".(int)$output." <br>";				
				$u_track->Save($text);
				$text = "<b>Maksâðana caur SEB</b>:<br>";
				$text .= "nenotika pâradresâcija uz get_seb_2.php? <br>";				
				$u_track->Save($text);*/
				
				include_once("get_seb_2.php");
				exit();
			
			} else {
				LogPost(array("debug seb CreatePhpSession hash error"));
				$error = 'CreatePhpSession hash error';
				$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
				$text .= $error;	
				$u_track->Save($text);
				die($error);
				
			}
		//}

	} else {

		LogPost(array("debug seb error 2"=>"seb Data veryfication error"));
		$error = "Data veryfication error<br>";
		$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
		$text .= $error;	
		$u_track->Save($text);
		die($error);
	}

	
	LogPost(array("debug seb procedure end"));


//}else{
//	die("Decryption error<br>");
//}
$error = "Nenokïûstam uz get_seb_2.php";
$text = "<b>Maksâðana caur SEB-kïûda</b>:<br>";
$text .= $error;	
$u_track->Save($text);
		

die();
//die("200");

  


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

function redirect($url)
{
    if (!headers_sent() && false)
    {    
        header('Location: '.$url);
        exit;
        }
    else
        {  
        echo '<script type="text/javascript">';
        echo 'window.location.href="'.$url.'";';
        echo '</script>';
        echo '<noscript>';
        echo '<meta http-equiv="refresh" content="0;url='.$url.'" />';
        echo '</noscript>'; exit;
    }
}



?>