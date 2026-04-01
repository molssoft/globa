<?
//==========================================================
//== SWEDBANK ===
//==========================================================


function SendOrderSwedbank($pay_data, $p_pamatojums, $p_ord_ids, $rez_id,$destination) {
	require_once("bank/i_bank_functions.php");

	global $db;
	//$id = $pay_pid; 
	$summa = $pay_data;
	//$p_pamatojums = encodeLV($p_pamatojums);
	
	//--- izveido tukshu log ierakstu un saglabaa id
	$date = new DateTime();
	$date->setTimezone(new DateTimeZone('Europe/Riga'));	
	$formated_date = $date->format('Y-m-d H:i:s');
	$values = array('p_datums' => $formated_date,
	                'VK_SERVICE' => '');
	
	//exit('...');
	$log_res_id = $db->Insert('bankas_pieprasijumi',$values,array('p_datums' => $formated_date),true);
	//exit('...');
	
	if (empty($log_res_id)) die("Kļūda. Nav izdevies pieslēgties bankai. Lūdzu, mēģiniet vēlreiz.");
	//$ssql = "Set Nocount on; INSERT INTO bankas_pieprasijumi(VK_SERVICE) VALUES(''); Select @@IDENTITY as id";
	//SET $log_res = $db.$Conn.Execute($ssql);
	
	$VK_SERVICE=	"1002"	;		//$Pieprasijuma $tips, $kuru $tirgotajs $suuta $bankai;
	$VK_VERSION = "008";//$algoritma $tips;
	$VK_SND_ID="IMPRO";	//$Tirgotaaja $identifikators. $sho $veertiibu $janomaina,$kad $taa $buus $zinaama;
	$VK_STAMP = $log_res_id; //log faila id, kaa reference
	$VK_AMOUNT = $summa; //	"0.01"; //		//sii ir maksaajuma summa. Testa versijaa veertiiba ir 1 santiims. Peec tam nomainit uz - summa
	$VK_CURR= "EUR"; //"LVL"																				'valuuta
	$VK_REF = $p_ord_ids; //globas orderu id numuri																	'Maksaajuma uzdevuma references numurs - db jaabuut kolonnai, kas raada, kura peec kaartas ir konkreetaa atbilde no bankas
	$VK_MSG = $p_pamatojums; //"Maksajums par IMPRO celojumu: "&summa&" "&VK_CURR	'maksaajuma uzdevuma detaljas
	$VK_MAC= ""	;	//'$shis $mainiigais $buus $digitaalais $paraksts;
	$VK_RETURN =	$_SESSION['application']["hansabankReturnGET"];  //'."?id=".$p_ord_ids														'$uz $sho $linku $banka $suutiis $atbildi;
	$VK_LANG= "LAT"	;//$valoda;
	$VK_ENCODING = "UTF-8";
	
	//response.write VK_REF
	//response.end
	
	//--- Formee VK_MAC parakstu ----------------------------------------

	$vk_mac_stringlen = strlen($VK_SERVICE);
	if($vk_mac_stringlen == 4 ){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SERVICE;
	} else { 
		echo "VK_SERVICE error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_VERSION);
	if($vk_mac_stringlen == 3){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_VERSION;
	} else { 
		echo "VK_VERSION error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_SND_ID);
	if($vk_mac_stringlen <=10 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SND_ID;
	} else { 
		echo "VK_SND_ID error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_STAMP);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_STAMP;
	} else { 
		echo "VK_STAMP error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_AMOUNT);
	if($vk_mac_stringlen <=17 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_AMOUNT;
	} else { 
		echo "VK_AMOUNT error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_CURR);
	if($vk_mac_stringlen == 3){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_CURR;
	} else { 
		echo "VK_CURR error. Contact administrator!";
		exit();
	}
 
 	$vk_mac_stringlen = strlen($VK_REF);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_REF;
	} else { 
		echo "VK_REF error. Contact administrator!";
		//echo VK_REF;
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_MSG);
	if($vk_mac_stringlen <=70 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_MSG;
	} else { 
		echo "VK_MSG error. Contact administrator!";
		exit();
	}
 
	
 
	//------------------------------------------------------------------------------
 
 
	//--- log bankas pieprasijumu 1002
	$values = array('VK_SERVICE' => $VK_SERVICE,
					'VK_VERSION' => $VK_VERSION,
					'VK_SND_ID' => $VK_SND_ID,
					'VK_STAMP' => $VK_STAMP,
					'VK_AMOUNT' => $VK_AMOUNT,
					'VK_CURR' => $VK_CURR,
					'VK_REF' => $VK_REF,
					'VK_MSG' => $VK_MSG,
					'VK_MAC' => $VK_MAC,
					'VK_RETURN' => $VK_RETURN,
					'VK_LANG' => $VK_LANG,
					);
	
	
	if ($test){
		//var_dump($values);
		
	}
	$log_res = $db->Update("bankas_pieprasijumi",$values,$log_res_id,true);

	//------------------------------------------------------------------------------
	//sheit postojam datus uz php failu, kas shifree datus ar sha-1 algoritmu, izveido digitaalo parakstu un aizsuuta datus uz Hansabanku
 ?>
	<form name="hbpost" action="bank/hbpost.php" method="post" accept-charset="utf-8">
		<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?=$VK_SERVICE?>"	>
		<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?=$VK_VERSION?>"	>
		<input type="hidden" name="VK_SND_ID"	maxlength="10"	value="<?=$VK_SND_ID?>"		>
		<input type="hidden" name="VK_STAMP"	maxlength="20"	value="<?=$VK_STAMP?>"		>
		<input type="hidden" name="VK_AMOUNT"	maxlength="17"	value="<?=$VK_AMOUNT?>"		>
		<input type="hidden" name="VK_CURR"	maxlength="3"	value="<?=$VK_CURR?>"		>
		<input type="hidden" name="VK_REF"	maxlength="20"	value="<?=$VK_REF?>"		>
		<input type="hidden" name="VK_MSG"	maxlength="70"	value="<?=EncodeLV($VK_MSG)?>"		>
		<input type="hidden" name="VK_MAC"	 maxlength="300"	value="<?=EncodeLV($VK_MAC)?>"		>
		<input type="hidden" name="VK_RETURN"	maxlength="65"	value="<?=$VK_RETURN?>"		>
		<input type="hidden" name="VK_LANG"	maxlength="3"	value="<?=$VK_LANG?>"		>
		<input type="hidden" name="VK_ENCODING"	value="<?=$VK_ENCODING?>">
		<input type="hidden" name="DESTINATION"	value="<?=$destination?>">
		
		<input type="hidden" name="rez_id"	value="<?=$rez_id?>"		>
	</form>
	<?
	//die();

	?>
	<script>
		document.hbpost.submit();
	</script>
	<?
 
	//------------------------------------------------------------------------------
 
 
 
} 
//------------------------------------------------------------------------------
