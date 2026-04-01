<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_tiesibas.php");
require_once("online2/m_maksajumi.php");
require_once($_SESSION['path_to_files']."m_dalibn.php");
require_once($_SESSION['path_to_files']."m_valuta.php");
	$dalibn = new Dalibn;
$db = New db();

$tiesibas = new Tiesibas();
$maksajumi = new Maksajumi();
$valutas = new Valuta();
 if ($tiesibas->IsAccess(T_GRAMATVEDIS)){
	$function = $_GET['f'];
	if (!isset($_GET['f'])) $function = 'index';
	if ($function == 'index') Index();
	if ($function == 'delete') Delete();
	if ($function == 'GetPossiblePids') GetPossiblePids($_GET['id']);
	if ($function == 'CreateOrders') CreateOrders();
	if ($function == 'completed') Completed();
	if ($function == 'GetOrders') GetOrders($_GET['id']);

 }
 else{
	 exit("Jums nav pieejas tiesîbu ðai lapai");
 }
 
function Index(){
	global $dalibn;
	global $db;
	global $maksajumi;
	global $valutas;
	 require_once("online2/i_functions.php");
	 if (isset($_FILES['file']) && ($_FILES['file']['error'] == UPLOAD_ERR_OK)) {
		 $allowed =  array('xml','csv');
		$filename = $_FILES['file']['name'];
		$ext = pathinfo($filename, PATHINFO_EXTENSION);
		if(!in_array($ext,$allowed) ) {
			die ('Ðads faila veids nav atïauts');
		}
		$error = array();
		$inserted = 0;
		//fidavista formâtâ
		if ($ext == 'xml'){
			$xml = simplexml_load_file($_FILES['file']['tmp_name']); 
			$xml=simplexml_load_file($_FILES['file']['tmp_name']) or die("Error: Cannot create object");
			//print_r($xml);
			$values = array();
			$san_konts = (string)$xml->Statement->AccountSet->AccNo;
			//var_Dump($client);
		//	var_dump($xml->Statement->AccountSet->CcyStmt);echo "<br><br>";
		
			foreach($xml->Statement->AccountSet->CcyStmt as $ccy_stmt){
				//var_dump($ccy_stmt);
				//echo "<br><br>";
				$valuta = (string)$ccy_stmt->Ccy;
				foreach($ccy_stmt->TrxSet as $set){
					
					//kredîts:
					if ($set->CorD == 'C'){
						$values = array();
						//var_dump($set);
						//echo "<br><br>";
						$values['datums'] = date("Y-m-d H:i:s");
						$values['valuta_id'] = $valutas->GetVal($valuta);
						$values['valuta'] = 	$valuta;
						$values['detalas'] = (string)$set->PmtInfo;
						$values['maks_datums'] = (string)$set->BookDate;
						$values['bank_ref'] = (string)$set->BankRef;
						$values['summa'] = (string)$set->AccAmt;
						$values['detalas'] = (string)$set->PmtInfo;
						$values['maks_konts'] =(string) $set->CPartySet->AccNo;
						$values['maks_reg_nr'] = (string)$set->CPartySet->AccHolder->LegalId;
						$values['maks_nos'] = (string)$set->CPartySet->AccHolder->Name;
						$values['san_konts'] = $san_konts;
						//$values['maks_nos'] = iconv('utf-8', 'ISO-8859-13//IGNORE',$values['maks_nos']);
						foreach($values as $key=>$val){
							$values[$key] = iconv('utf-8', 'ISO-8859-13//IGNORE',$val);
							
						}
						if (PkValid($values['maks_reg_nr'])){
							//ja tas ir personas kods
							$pk_arr = explode("-",$values['maks_reg_nr']);
							$pk1 = $pk_arr[0];
							$pk2 = $pk_arr[1];
							$dalibnieks = $dalibn->GetPk($pk1,$pk2);
							//echo "<br>dalîbnieks;</br>";
							//var_dump($dalibnieks);
							//echo "<br><br>";
							if ($dalibnieks){
								$values['did'] = $dalibnieks['ID'];
							}
						}
						
							
						//var_dump(mb_detect_encoding($values['maks_nos']));
						//var_dump($values);
						
						//echo "<br><br>";
						//pârbauda, vai db ar ðâdu bank ref un san_kontu nav jau ieimportçts maksâjums
						if (!$maksajumi->exists($values['san_konts'],$values['bank_ref'])){
							//echo "neeksistç";
							$maksajumi->insert($values);
							$inserted++;
						}
						else {
						//	echo "eksistç";
							$error['file'] .= 'Ieraksts nav pievienots - ðâds ieraksts jau eksistç ('.$values['maks_nos'].', '.'bank_ref = '.$values['bank_ref'].')<br>';//.print_r($values,true)."<br>";
						}
					}
					
				}
				
			}
		
			//var_dump($xml->Header->From);
			//echo "<br>";
			/*$values['valuta'] = (string)$xml->Payment->Ccy[0];
			
			
			$values['summa'] = (string)$xml->Payment->BenSet->Amt;
			$values['san_konts'] = (string)$xml->Payment->BenSet->BenAccNo;
			*/
		
		//	
			//echo $xml->body;
			if ($inserted == 0){
					$error['file'] .= 'Kïûda: nav pievienots neviens ieraksts.';
				}
		}
		
		//csv no seb bankas
		if ($ext == 'csv'){
			if (($handle = fopen($_FILES['file']['tmp_name'], "r")) !== FALSE) {
				//$inserted = 0;
				$row = 0;
				while (($data = fgetcsv($handle, 1000, "\n")) !== FALSE) {
					
					$num = count($data);
					//echo "<p> $num fields in line $row: <br /></p>\n";
					
					if ($row==0){
						$konta_nr_arr = $data[0];
						$re = '/KONTA \((LV.+)\)/';
						

						preg_match($re, $konta_nr_arr, $matches);

						// Print the entire match result
						//echo "matches";
						//var_dump($matches);
						$san_konts = $matches[1];
						//echo "saòçmçja konts. $san_konts<br>";
					}
					$row++;
					for ($c=0; $c < $num; $c++) {
						$data[$c] = iconv('utf-8', 'ISO-8859-13//IGNORE',$data[$c]);
						$data[$c] = str_replace('"','',$data[$c]);
						//echo $data[$c] . "<br />\n";
						$line = $data[$c];
						$field_arr = explode(";",$line);
						//echo "field_arr:<br>";
						//var_dump($field_arr);
						//echo "<br><br>";
						$last_field_ind = count($field_arr) - 1;
						if (!empty($field_arr[$last_field_ind]) && $field_arr[$last_field_ind]!="SUMMA KONTA VALÛTÂ" && is_numeric($field_arr[0]) && $field_arr[14] == "C"){
							//echo "ðo rindiòu apstrâdâsim<br>";
							$values = array();
							$values['datums'] = date("Y-m-d H:i:s");
							$values['valuta'] = $field_arr[2];
							$values['valuta_id'] =  $valutas->GetVal($field_arr[2]);
							$values['summa'] = $field_arr[3];
							$values['summa'] = str_replace(',','.',$values['summa']);
							$values['maks_nos'] = $field_arr[4];
							$values['maks_reg_nr'] = $field_arr[5];
							$values['maks_konts'] = $field_arr[6];
							$values['detalas'] = $field_arr[9];
							$values['bank_ref'] = $field_arr[10];
							$values['maks_datums'] = date("Y-m-d",strtotime($field_arr[11]));
							$values['san_konts'] = $san_konts;
							if (PkValid($values['maks_reg_nr'])){
								//ja tas ir personas kods
								$pk_arr = explode("-",$values['maks_reg_nr']);
								$pk1 = $pk_arr[0];
								$pk2 = $pk_arr[1];
								$dalibnieks = $dalibn->GetPk($pk1,$pk2);
							//	echo "<br>dalîbnieks;</br>";
								//var_dump($dalibnieks);
							//	echo "<br><br>";
								if ($dalibnieks){
									$values['did'] = $dalibnieks['ID'];
								}
							}
							//var_dump($values);
							
							//echo "<br><br>";
							//pârbauda, vai db ar ðâdu bank ref un san_kontu nav jau ieimportçts maksâjums
							if (!$maksajumi->exists($values['san_konts'],$values['bank_ref'])){
								//echo "neeksistç";
								$maksajumi->insert($values);
								$inserted++;
							}
							else {
								//echo "eksistç";
								$error['file'] .= 'Ieraksts nav pievienots - ðâds ieraksts jau eksistç ('.$values['maks_nos'].', '.'bank_ref = '.$values['bank_ref'].')<br>';//.print_r($values,true)."<br>";
							}
					
						}
						/*if ($field_arr[0] == 'MU NR.'){
							echo "headeru rindinja!";
							$header_arr = $field_arr;
						}*/
						
					}
				}
				fclose($handle);
				if ($inserted == 0){
					$error['file'] .= 'Kïûda: nav pievienots neviens ieraksts.';
				}
			}
			
		}
		if (count($error) > 0) {
			// kïûda		
			// râdam vecâs vçrtîbas un kïûdas paziòojumu
			
			$data['errors'] = $error;
		}
	
	 
	}
	$data['maksajumi'] = $maksajumi->Get();
	//	 var_dump($data['maksajumi']);
	include_once("v_maksajumi.php") ;
}

function Delete(){
	//var_dump($_POST);
	//die();
	global $db;
	global $maksajumi;
	if (isset($_POST['delete_id'])){
		$maksajumi->Delete((int)$_POST['delete_id']);
		
		$data['script'] = "<script>alert('Maksâjums ir izdzçsts!');</script>";
		
	}
	$data['maksajumi'] = $maksajumi->Get();
	//	 var_dump($data['maksajumi']);
		include_once("v_maksajumi.php") ;
}

function Completed(){
	global $db;
	global $maksajumi;

		//var_dump($_POST);
	
	if (isset($_POST['update_id'])){
			//var_dump($_POST);
		$pabeigts = (int)$_POST['pabeigts'];
		//var_dump($_POST);
		$maksajumi->Update(array('pabeigts' => $pabeigts), (int)$_POST['update_id']);
		//$data['script'] = "<script>alert('Maksâjums ir izdzçsts!');</script>";
		
	}
	$data['maksajumi'] = $maksajumi->Get();
	//	 var_dump($data['maksajumi']);
	include_once("v_maksajumi.php") ;
}

function GetPossiblePids($id){
	global $db;
	global $maksajumi;
	
	//atrod ðim cilvçkam 
	//
	
	
	//atrod visas grupas, kuram dalibniekam ir neapmaksâts pieteikums
	
	$pid_arr = $maksajumi->GetNeapmaksatiPid($id);
	//var_dump($pid_arr);
	$data['pid_arr'][$id] = $pid_arr;
	$data['maksajumi'] = $maksajumi->Get();
	//	 var_dump($data['maksajumi']);
		include_once("v_maksajumi.php") ;
	
}

//izveido orderus izvçlçtajiem pid
function CreateOrders(){
	global $maksajumi;
	global $db;
	global $dalibn;
	
	require_once("online2/m_grupa.php");
	$gr = new Grupa();
	if (isset($_POST['post']) && $_POST['post'] == 1){
		require_once($_SESSION['path_to_files']."bank/i_bank_functions.php");
		//var_dump($_POST);
		$inserted_order_arr = array();
		$maks_id = (int)$_POST['maks_id'];
		$gid = (int)$_POST['gid'];
		
		$grupa = $gr->getId($gid);
		$maksajums = $maksajumi->GetId($maks_id);
		if (isset($_POST['summa_pid'])){
			$debeta_konti = array('UNLA' => '2.6.2.6.1',
						'HABA' => '2.6.2.4.5');
						/*
	Tâtad debeta konti

Swedbanka - 2.6.2.4.5

SEB banka - 2.6.2.6.1

Citadele - 2.6.2.1.2

Dnb banka - 2.6.2.2.1

Nordea - 2.6.2.3.1

Maksâjumi ar karti - 2.6.2.5.1
*/
			foreach($_POST['summa_pid'] as $pid=>$summa){
				if ($summa>0 || true){
					//atrodam atbisltoðo m
					$values = array();
					$values['pid'] = $pid;
					$values['nopid'] = 0;
					//var_dump(getOrdNum());
					$values['num'] = getOrdNum();
					$values['summa'] = $summa;
					$str_pamatojums = $grupa["kods"]." ";
					if (!empty($grupa['sakuma_dat'])) 
						$str_pamatojums .= $grupa['sakuma_dat']->format("d.m.Y")." ";
					$str_pamatojums .=$grupa["v"].". Dalîbnieks: ";
					//no pieteikuma id jâdabû dalîbnieks
					$did = $dalibn->GetIdPidSaite($pid);
					if (!empty($did)){
						$dalibnieks = $dalibn->GetId($did);
						$str_pamatojums .= $dalibnieks['vards']." ".$dalibnieks['uzvards'];
					}
					$values['pamatojums'] = $str_pamatojums;
					//.$result["dal_vards"]." ".$result["dal_uzv"];
					$values['maksajumi_id'] = $maks_id;
					$values['kas'] = $maksajums['maks_nos'];
					$values['summa'.$maksajums['valuta']] = $summa;
					$values['nosumma'.$maksajums['valuta']] = $summa;
					$values['valuta'] = $maksajums['valuta_id'];
					$values['datums'] = $maksajums['maks_datums'];
					//--- kredits
					//--- ja celjojuma beigu datums ir veelaaks par tekosho meenesi, njem avansa kontu
					$now =  new DateTime("now");
					$now->modify('last day of this month');
					if ($grupa['beigu_dat']>$now) {
					   $values['kredits'] = $grupa["konts_ava"]; //njem avansa kontu
					} else {
					   $values['kredits'] = $grupa["konts"]; //njem ienjemumu kontu
					}
					
					
					$values['vesture'] = $db->GetUser()." - Izveidoja. ".date("d.m.Y H:i:s")."<br>";
					//$values['kredits'] = $debeta_konti[$maksajums['maks_konts'];
					$debets = '';
					$re = '/LV\d{2}([a-z]{4})/i';
					preg_match($re, $maksajums['maks_konts'], $matches);
					if (isset($matches[1])){						
						$debets = $debeta_konti[$matches[1]];
					}
					$values['debets'] = $debets;
					//grupas kods
					$values['resurss'] = $grupa['kods'];
					$values['maks_veids'] = 'banka';
					//$values['pamatojums'] = $maksajums['detalas'];
					$values['dalib'] = $maksajums['did'];
					$values['pielikums'] = "Rezervacija: ".$values['pid'];
					$values['summaval'] = $values['summa'];
					$values['deleted'] = 0;
					$values['kas2'] = EncodeOldCharset($values['kas']);
					$values['pamatojums2'] = EncodeOldCharset($values['pamatojums']);
					$values['pielikums2'] = EncodeOldCharset($values['pielikums']);
					//online maksjaûmus nevajag pârbaudît, uzreiz apstiprinâm
					if ($maksajumi->IsOnline($maks_id)){
						$values['parbaude'] = 0;
					}
					else				
						$values['parbaude'] = 1;
					//	echo "VALUES<br>";
					//var_dump($values);
					//echo "<br><br>";
					/*$values = array(#'pid' => $o_pid,
							#'nopid' => 0,
						#	'num' => $o_num,
							#'datums' => $formated_date,
							#'kas' => $o_kas,
							#'dalib' => $o_dalibn,
							#'pamatojums' => $o_pamatojums,
							#'pielikums' => $o_pielikums,
							#'summaval' => $o_summaval,
							#'valuta' => $o_valuta_id,
							#'summa' => $o_summa,
							#'kredits' => $o_kredits,
							#'debets' => $o_debets,
							#'deleted' => 0,
							#'vesture' => $o_vesture,
							'nosummaLVL' => $o_nosummaLVL,
							'summaLVL' => $o_summaLVL,
							#'kas2' => $o_kas2,
							#'pamatojums2' => $o_pamatojums2,
							#'pielikums2' => $o_pielikums2,
							#'parbaude' => $o_parbaude,
							#'resurss' => $o_resurss,#
							#'maks_veids' =>$o_maks_veids 
							);*/
							$ord_id = $db->Insert('orderis',$values,$values);
							$order=array('num'=>$values['num'],
							'id'=>$ord_id);
							
							//CalculateSum($o_pid);
							//$ord_id=111;
					$inserted_order_arr[] = $order;
				
				}
			}
		}
		
		$message = "Izveidoti <b>".count($inserted_order_arr).'</b> orderi';
		if (!empty($inserted_order_arr)){
			$message .=":<br>";
			foreach($inserted_order_arr as $order){
				$message .= "<a href='ordedit.asp?oid=".$order['id']."' target='_blank'>Orderis ID#".$order['num']."</a><br>";
			}
			
		}
			$_SESSION['message'] = $message;
			//GetPossiblePids($maks_id);
	/*	$values = $db->EscapeValues($_POST,'partneris,nosaukums,nr,soferis,mobilais,vietas,krasa');
		//var_dump($values);
		$values['nosaukums'] = Encode($values['nosaukums']);
		$values['soferis'] = Encode($values['soferis']);
		//var_dump($values);
		//exit();
		if ($id){			
			$autobusi->Update($values,$id);
			
		
		}
		else{
			$id = $autobusi->Insert($values);
		}
		$_SESSION['message'] = '<font color=black size="4">Izmaiòas saglabâtas.</font><br>';*/
		//pârbauda, vaiu visa maksâjuma summa jau ir apstrâdâta
		
		$atlikusi_summa = $maksajumi->GetAtlikusiSumma($maks_id);
		/*echo "<br>atlikusî summa:<br>";
		var_dump($atlikusi_summa);
		echo "<br><br>";
*/
		if (round($atlikusi_summa,2)<=0){
			$maksajumi->Update(array('pabeigts' => 1), $maks_id);
		}
		
			
	}
	
	header("Location: c_maksajumi.php");
	
	
}
 
?>



