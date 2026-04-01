<?
//session_save_path('c:\temp') ;
session_save_path('c:\temp') ;
session_start();

//echo session_save_path() ;
//define("DEBUG",  "1");
if (isset($_SESSION['test'])){
	//unset($_SESSION['test']);
	define("DEBUG",  "1");
}
else{
	define("DEBUG",  "0");
}

if (isset($_GET['test_gr']) && $_GET['test_gr']==1){
	$_SESSION['test_gr'] = 1;
}

	require_once('m_init.php');


require_once('m_profili.php');
require_once("m_user_tracking.php");

$db = new Db;
$profili = new Profili;


	
$u_track = new UserTracking();
$tabs = array();
$tabs[0] = array();
$tabs[0]['title'] = 'Ceïotâju skaits';
$tabs[0]['enabled'] = 1;
$tabs[0]['link'] = 'c_reservation.php?f=TravellerCount';
$tabs[1] = array();
$tabs[1]['title'] = 'Ceïojums';
$tabs[1]['enabled'] = 1;
$tabs[1]['link'] = 'c_reservation.php?f=Travel';
$tabs[2] = array();
$tabs[2]['title'] = 'Personas';
$tabs[2]['enabled'] = 1;
$tabs[2]['link'] = 'c_reservation.php?f=Travellers';



if (isset($_SESSION['reservation']['grupas_id'])){

	//pârbauda, vai ceïojumam ir pieejama viesnîca
	require_once("m_viesnicas.php");
	$viesnicas = new Viesnicas();
	$viesnicu_veidi = $viesnicas->GetVeidsGid($_SESSION['reservation']['grupas_id']);
	//var_dump($viesnicu_veidi);	
	//ja ceïojumam ir pieejama viesnîca
	if (count($viesnicu_veidi)>0){
		$tabs[4] = array();
		$tabs[4]['title'] = 'Viesnîca';
		$tabs[4]['enabled'] = 1;
		$tabs[4]['link'] = 'c_reservation.php?f=Hotels';
	}
	
	require_once("m_grupa.php");
	
	$gr = new Grupa();

	$grupa = $gr->GetId($_SESSION['reservation']['grupas_id']);
	
	if(DEBUG){
		//echo "<br><b>GRUPA</b><br>";
		//var_dump($grupa);
		//echo "<br><br>";
	}
	if (!$grupa['nevajag_pases']){
		$tabs[8] = array();
		$tabs[8]['title'] = 'Dokumenti';
		$tabs[8]['enabled'] = 1;
		$tabs[8]['link'] = 'c_reservation.php?f=Documents';
	}
	//vai ceïojumam ir pieejamas kajîtes
	require_once("m_kajite.php");
	$kajites = new Kajite();
	$kajisu_veidi = $kajites->GetVeidiGid($_SESSION['reservation']['grupas_id']);
	
	//ja ceïojumam ir pieejamas kajîtes
	if (count($kajisu_veidi)>0){
		$tabs[3] = array();
		$tabs[3]['title'] = 'Kajîtes';
		$tabs[3]['enabled'] = 1;
		$tabs[3]['link'] = 'c_reservation.php?f=Cabins';
		
		//pârbauda, vai prâmja ceïojumam ir pieejami papildus pakalpojumi:
		require_once('m_vietu_veidi.php');
		$vietu_veidi = new VietuVeidi();
		$data['vietu_veidi'] = $vietu_veidi->GetAvailable($_SESSION['reservation']['grupas_id']);
		if (DEBUG){
			var_dump($data['vietu_veidi']);
			echo "<--vietu veidi <br><br>";
		}
		$data['pakalpojums'] = array();
		if (!empty($vietu_veidi)){
			foreach ($data['vietu_veidi'] as $veids){
				if (DEBUG)
				{
					echo "<br>Veids:<br>";
					var_dump($veids);
					echo "<br><br>";
				}
				if ($veids['tips'] == 'C'){
					$data['pakalpojums']['cena'][] = $veids;
				}
				if ($veids['tips'] == 'P'){
					$data['pakalpojums']['papildvieta'][] = $veids;
				}
				if ($veids['tips'] == 'EX'){
					$data['pakalpojums']['ekskursija'][] = $veids;
				}
				if ($veids['tips'] == 'ED'){
					$data['pakalpojums']['edinasana'][] = $veids;
				}
				//piemaksa par vienvietîgu numuru
				if ($veids['tips'] == 'V1'){
					$data['pakalpojums']['v1'][] = $veids;
				}
				//Cits
				if ($veids['tips'] == 'X'){
					$data['pakalpojums']['cits'][] = $veids;
				}
				//Pçdçjâs dienas cena
				if ($veids['tips'] == 'Z1'){
					$data['pakalpojums']['pd_cena'][] = $veids;
					if (isset($_SESSION['test'])) {var_dump($veids);
						echo "<br><br>";
					}
					
				}
			
			}
		}
		if (count($data['pakalpojums']) > 0 ){
			$tabs[5] = array();
			$tabs[5]['title'] = 'Pakalpojumi';
			$tabs[5]['enabled'] = 1;
			$tabs[5]['link'] = 'c_reservation.php?f=Services';
		}
	}
	else{
		$tabs[5] = array();
		$tabs[5]['title'] = 'Pakalpojumi';
		$tabs[5]['enabled'] = 1;
		$tabs[5]['link'] = 'c_reservation.php?f=Services';
	}
	
}
else{
	$tabs[4] = array();
	$tabs[4]['title'] = 'Viesnîca';
	$tabs[4]['enabled'] = 1;
	$tabs[4]['link'] = 'c_reservation.php?f=Hotels';
	$tabs[8] = array();
	$tabs[8]['title'] = 'Dokumenti';
	$tabs[8]['enabled'] = 1;
	$tabs[8]['link'] = 'c_reservation.php?f=Documents';
}

$tabs[6] = array();
$tabs[6]['title'] = 'Kontaktdati';
$tabs[6]['enabled'] = 1;
$tabs[6]['link'] = 'c_reservation.php?f=ContactData';
/*$tabs[7] = array();
$tabs[7]['title'] = 'Adreses';
$tabs[7]['enabled'] = 1;
$tabs[7]['link'] = 'c_reservation.php?f=Addresses';*/

$tabs[9] = array();
$tabs[9]['title'] = 'Kopsavilkums';
$tabs[9]['enabled'] = 1;
$tabs[9]['link'] = 'c_reservation.php?f=Summary';

$tabs['wizzard'] = 1;
ksort($tabs);
$_SESSION['tabs'] = $tabs;

$function = $_GET['f'];

if ($function == 'Testam') Testam();
if ($function == 'Testam1') Testam1();
if ($function == 'TravellerCount') {$new=0; if (isset($_GET['par'])) $new = $_GET['par']; TravellerCount();}
if ($function == 'Travel') 	Travel();
if ($function == 'Travellers') 	Travellers();
if ($function == 'Services') 	Services();
if ($function == 'Hotels') 	Hotels();

if ($function == 'Addresses') Addresses();
if ($function == 'ContactData') ContactData();
if ($function == 'Documents') Documents();
if ($function == 'Summary') Summary();
if ($function == 'MakePayment') MakePayment();
if ($function == 'Contract') 	Contract();
if ($function == 'GenerateContract') GenerateContract();
if ($function == 'GenerateContract_new') GenerateContract_new1();
if ($function == 'AcceptContract') 	AcceptContract();
if ($function == 'AcceptReservation') 	AcceptReservation();
if ($function == 'GetDalibnForRoom') 	GetDalibnForRoom();
if ($function == 'CancelRoom') 	CancelRoom();
if ($function == 'BookRoom') 	BookRoom();
if ($function == 'CancelReservation') {$par = 0; if (isset($_GET['par'])) $time_exceeded = $_GET['par'];	CancelReservation($par);}
if ($function == 'CancelReservationAjax') 	CancelReservationAjax();
if ($function == 'SavedReservations') 	SavedReservations();
if ($function == 'TimeExceeded') 	TimeExceeded();
if ($function == 'BuyGiftCard') BuyGiftCard();
if ($function == 'SendSummary') SendSummary();
if ($function == 'CancelBuyGiftCard') CancelBuyGiftCard();
if ($function == 'PrintDk') PrintDk();
if ($function == 'BuyGiftCardNoUser') BuyGiftCardNoUser();
if ($function == 'PaymentResult') PaymentResult();
if ($function == 'HotelsTest') HotelsTest();
if ($function == 'PrintDk_test') PrintDk_test();
if ($function == 'TravellersTest') TravellersTest();

if ($function == 'GiftCardPayment') GiftCardPayment();
if ($function == 'SelectCabin') SelectCabin();
if ($function == 'Cabins') Cabins();

if ($function == 'ViewDk') ViewDk();
if ($function == 'GiftCardAuthorize') GiftCardAuthorize();
if ($function == 'GiftCardAuthorizeNew') GiftCardAuthorizeNew();
//no mâjaslapas pogas 'Pirkt':
if (isset($_GET['gid']) && (int)$_GET['gid']>0){
	$_SESSION['pirkt']['grupas_id'] = (int)$_GET['gid'];
}
//var_dump($_SESSION);

if (isset($_GET['a']) && (int)$_GET['a']==1){
	$_SESSION['test'] = 1;
}

//no e-pasta pogas par ceïojuma/dk kopsavilkumu
if (isset($_GET['f'])){
	if($_GET['f'] == 'SavedReservations'){
		$_SESSION['after_login_redirect_url'] = 'c_reservation.php?f=SavedReservations';
	}
}

function ResStatus($readonly=false){
	//echo "resstatus";
	$online_rez_id = 0;
	if (isset($_GET['rez_id'])){
		$online_rez_id = $_GET['rez_id'];
		$_SESSION['reservation']['online_rez_id'] = $online_rez_id;
	}elseif (isset($_SESSION['reservation']['online_rez_id'])){
		$online_rez_id = $_SESSION['reservation']['online_rez_id'];
	}

	require_once("m_online_rez.php");
	$online_rez = new OnlineRez();
	
	//ja vien tâ nav atgrieðanâs pçc maksâjuma
	if (!$readonly){
		//pârbauda, vai rezervâcija pieder profila îpaðniekam	
		if ($online_rez_id != 0 && !$online_rez->IsOwner($online_rez_id)){
			SaveUserTracking('<font color="red">Mçìinâjums skatîties sveðu rezervâciju #'.$online_rez_id.'!!!!</font>');
			$online_rez_id = 0;
		}
	}

	if ($online_rez_id){
		
		//uzstâda grupas id, ceïotâju skaitu, i travel, traveller_count dalibn_id_array
		
		if (!isset($_SESSION['reservation']['grupas_id'])){
			//echo "not set";
			$_SESSION['reservation']['grupas_id'] = $online_rez->GetGidId($online_rez_id);
		}
		else{
			if (DEBUG) var_dump($_SESSION['reservation']['grupas_id']);
		}
		
		if (!isset($_SESSION['reservation']['traveller_count']))
			$_SESSION['reservation']['traveller_count'] = $online_rez->GetTravellerCount($online_rez_id);
		
		if (!isset($_SESSION['reservation']['dalibn_id_arr']))
			$_SESSION['reservation']['dalibn_id_arr'] = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		if (!isset($_SESSION['reservation']['i_travel'])){
			require_once("m_dalibn.php");
			$dalibn = new Dalibn();
			$es = $dalibn->GetId();
			$mans_did = $es['ID'];
			if (in_array($mans_did,$_SESSION['reservation']['dalibn_id_arr']))
				$_SESSION['reservation']['i_travel'] = 1;
			else
				$_SESSION['reservation']['i_travel'] = 0;
		}
		
		//echo "rez";
		$rez = $online_rez->GetId($online_rez_id);
		/*echo "rezrevâvija<br>";
		var_dump($rez);
		echo "<br><br>";*/
		if (!empty($rez)){
			//var_dump($rez);
			$rez_apstiprinata = (int)$rez['apstiprinata'];
		}
		else{
			return('Rezervâcija ar ID# <b>'.$online_rez_id.'</b> nav atrasta.<br><a href="c_home.php">Atgriezties</a>');		
		}
	}
	else
		$rez_apstiprinata = 0;
	
	$rez_statuss = array('var_labot' => TRUE,
						'ir_iemaksas' => FALSE,
							'online_rez' => $online_rez_id,
							'rez_apstiprinata' => $rez_apstiprinata,
							'no_delete' => (int)$rez['no_delete']);
	//var_dump($rez_statuss);					
	//$var_labot[$online_rez] = 1;
	if ($online_rez_id){
		//pârbauda, vai lîgums ir izveidots un akceptçts
		//echo "ieklausim ligumu:";
		require_once('m_ligumi.php');
		//echo "ieklavam";
		$ligumi  = new Ligumi();
		/*echo "Rezervâcijas statuss> Lîgums apstiprinâts:<br>";
		var_dump($ligumi->GetAcceptedOnlineRez($online_rez_id));
			echo "<<<<<br><br>";
		echo $ligumi->GetAcceptedOnlineRez($online_rez_id);
		echo "<<<<<br><br>";*/
		if ($ligumi->GetAcceptedOnlineRez($online_rez_id)){
			
			$rez_statuss['var_labot'] = FALSE;
		}
		require_once("m_pieteikums.php");
		$pieteikums = new Pieteikums();
		$iemaksas = $pieteikums->GetMaksatOnlineRez($online_rez_id);
		if (DEBUG){
			echo "Iemaksas<br>";
			var_dump($iemaksas);
			echo "<br><br>";
		}
		
		$rez_statuss['ir_iemaksas'] = ($iemaksas['iemaksats'] > 0 ? TRUE : FALSE);
		if ($rez_statuss['ir_iemaksas']) $rez_statuss['var_labot'] = false;
			
	}
	//testam
	//$rez_statuss['var_labot'] = FALSE;
	//
	return $rez_statuss;
}
?>