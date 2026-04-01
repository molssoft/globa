<?php


//dâvanu kartes pirkðana nereìistrçtam lietotâjam
function BuyGiftCardNoUser(){
	
	global $db;
	global $u_track;
	require("m_online_rez.php");
	$online_rez = new OnlineRez();
	if (isset($_POST['post']) && $_POST['post'] == 1 ){
		
		$_POST['vards'] = strtoupper($_POST['vards']);
		$_POST['uzvards'] = strtoupper($_POST['uzvards']);
		
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		require("m_pieteikums.php");
		$piet = new Pieteikums();
		if (DEBUG) var_dump($_POST);
		$text = "<b>Pirkt dâvanu karti bez reìistrâcijas</b>:<br>";
		SaveUserTracking($text,$_POST);
		
		//Validation
		$error = array();
		$values['vards'] = $_POST['vards'];
		$values['uzvards'] = $_POST['uzvards'];
					
		// validate
		$error = $dalibn->Validate($values);
		
		$home_number = $_POST['home_numberr'];
		$work_number = $_POST['work_numberr'];
		$mobile_number = $_POST['mobile_numberr'];
		$phones = array('home_number' => $home_number,
						'work_number' => $work_number,
						'mobile_number' => $mobile_number);
		$errors = $dalibn->ValidatePhones($phones);
		if (DEBUG){
			var_dump($errors);
		}
		if (count($errors)>0){
			foreach ($errors as $key=>$value){
				$error[$key] = $value;
			}
		}	
							
		//E-adreðu validâcija
		if (strlen($_POST['eadr'])>0){
			if (!filter_var($_POST['eadr'], FILTER_VALIDATE_EMAIL)) {
				$error['eadr'] = 'Ievadîtais e-pasts nav derîgs';
			}
		}
		else{
			$error['eadr'] = 'Nav norâdîts e-pasts';
		}
		//var_dump($error);
		//summas un saòçmçja validâcija
		$errors = ValidateDk($_POST);
	
		if (!empty($_POST['issue_company_invoice']) && (string)$_POST['issue_company_invoice'] === '1') {
			$cn = isset($_POST['company_name']) ? trim($_POST['company_name']) : '';
			if ($cn === '') {
				$errors['company_name'] = 'Norâdiet uzòçmuma nosaukumu';
			} elseif (strlen($cn) > 255) {
				$errors['company_name'] = 'Uzòçmuma nosaukums ir par garu';
			}
			if (!isset($_POST['company_reg']) || trim((string)$_POST['company_reg']) === '') {
				$errors['company_reg'] = 'Norâdiet reìistrâcijas numuru';
			}
			if (!isset($_POST['company_address']) || trim((string)$_POST['company_address']) === '') {
				$errors['company_address'] = 'Norâdiet juridisko adresi';
			}
		}	
	
		if (count($errors)>0){		
			foreach ($errors as $key=>$value){				
				$error[$key] = $value;
			}
		}
	
		if (count($error)==0){
			
			//---------------------------------------------
			// izveido jaunu dalîbnieku
			//---------------------------------------------
			require_once("m_dalibn.php");
			$dalibn = new Dalibn();
			$_POST['talrunisM'] = $_POST['home_numberr'];							
			$_POST['talrunisD'] = $_POST['work_numberr'];	
			$_POST['talrunisMob'] = $_POST['mobile_numberr'];
			$values = $db->EscapeValues($_POST,'vards,uzvards,talrunisM,talrunisD,talrunisMob,eadr');
			$did = $dalibn->SaveDkBuyer($values);
			//---------------------------------------------

			$profili_id = null;
			if (!empty($_POST['issue_company_invoice']) && (string)$_POST['issue_company_invoice'] === '1') {
				require_once('m_profili.php');
				$_POST['company_email'] = $_POST['eadr'];
				$profiliAnon = new Profili();
				$anonRow = $db->EscapeValues($_POST,
					'company_email,company_name,company_reg,company_vat,company_address,company_bank_name,company_bank_account');
				$profili_id = $profiliAnon->InsertAnon($anonRow);
			}
			
			//izveidojam jaunu rezervâciju
			$dalibn_id_arr = array($did);
			$online_rez_id = $online_rez->CreateNew($dalibn_id_arr,'dk');	
			if (!$online_rez_id){		
				$text = "<b>"."Pirkt dâvanu karti bez reìistrâcijas-kïûda</b>:<br>";
				$text .= 'Kïûda, saglabâjot rezervâciju. Lûdzu, mçìiniet vçlreiz';
				$u_track->Save($text);
				// râdam vecâs vçrtîbas un kïûdas paziòojumu
				$data['values'] = $_POST;
				$data['message'] = 'Kïûda, saglabâjot rezervâciju. Lûdzu, mçìiniet vçlreiz';	
			}
			else{
				// update profili_id
				if (!empty($profili_id) && !empty($online_rez_id)) {
					$db->Update('online_rez', array('profile_id' => (int)$profili_id), (int)$online_rez_id);
					$db->Query(
						'UPDATE online_rez SET invoice_status = ?, profile_id = ? WHERE id = ? AND deleted = 0',
						array('requested', (int)$profili_id, (int)$online_rez_id)
					);
				}					
				//ejam uz apmaksu
				$pieteikums =  $piet->GetPietOnlineRez($online_rez_id);
				$pieteikums_id = $pieteikums[0]['id'];
				$ievaditas_summas[$pieteikums_id] = $_POST['summa'];
				require_once("m_trans_uid.php");
				$trans = new TransUid();
				if ($profili_id)
					$trans_id = $trans->Save($online_rez_id,$profili_id,$ievaditas_summas);
				else
					$trans_id = $trans->Save($online_rez_id,$_SESSION['profili_id'],$ievaditas_summas);
				
				$_SESSION['reservation_bank'][$online_rez_id."_"."bank_str_ord_ids"] = $trans_id;
				$_SESSION['reservation_bank'][$online_rez_id."_".'bank_summa'] = $_POST['summa'];
				//ceïojuma nosaukums
				require_once('m_marsruts.php');
				$marsruts = new Marsruts();
				$celojums = $marsruts->GetOnlineRez($online_rez_id);
				$c_nos = (strlen($celojums['v']) > 17)
					? substr($celojums['v'], 0, 17) . "..."
					: $celojums['v'];						
				
				$_SESSION['reservation_bank'][$online_rez_id."_".'bank_str_pamatojums'] = "Impro rezervâcija. ".$c_nos." (rez_id=".$online_rez_id.")";
		
				$_SESSION['reservation']['summa'] = $_POST['summa'];
				$_POST['post'] = 0;	
				$_SESSION['reservation']['online_rez_id'] = $online_rez_id;
				$_SESSION['reservation']['dk'] = true;
				MakePayment('gift_card',0);
				exit();
			}
		}
		else{		
			$text = "<b>Pirkt dâvanu karti bez reìistrâcijas-kïûda:</b><br>";
			$text .= implode("<br>",$error);
			$u_track->Save($text);
			if (DEBUG) var_dump($error);
			$data['values'] = $_POST;
			$data['errors'] = $error;
		}
		//var_dump($error);	
	}
	$data['values'] = $_POST;
	$dk_lim = GetDkMinMaksSum();
	$data['min_summa'] = $dk_lim['min_summa'];
	$data['max_summa'] = $dk_lim['max_summa'];	
	require_once("v_gift_card_buy_no_user.php");
	
}