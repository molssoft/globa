<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_grupa.php");
require_once("online2/m_vietu_veidi.php");
require_once("online2/m_viesnicas.php");
require_once("online2/m_grupu_vaditaji.php");
$db = New Db();
$grupa = New Grupa();
$vietu_veidi = New VietuVeidi();
$viesnicas = New Viesnicas();
$grupu_vaditaji = New GrupuVaditaji();

$gid = $_POST['grupa_id'];

$old = $grupa->getID($gid);

$updates = array();

///////////////////
// kods
///////////////////
$kods = $_POST['kods'];
if ($kods != ''){
	if ($grupa->is_unique($gid,$kods)){
		$updates['kods'] = $kods;
	} else {
		$message = 'Grupas kods jau eksistç!';
	}
}

///////////////////
// valuta
///////////////////
$updates['valuta'] = 'EUR';

///////////////////
// blocked
///////////////////
if ($_POST['blocked'])
	$blocked = 1;
else
	$blocked = 0;
$updates['blocked'] = $blocked;

///////////////////
// online
///////////////////
if ($_POST['online'])
	$online = 1;
else
	$online = 0;
$updates['internets'] = $online;

///////////////////
// garantets
///////////////////
if ($_POST['garantets'])
	$garantets = 1;
else
	$garantets = 0;
$updates['garantets'] = $garantets;

///////////////////
// nevajag_pases
///////////////////
if ($_POST['nevajag_pases'])
	$nevajag_pases = 1;
else
	$nevajag_pases = 0;
$updates['nevajag_pases'] = $nevajag_pases;

///////////////////
// pardot_agentiem_no
///////////////////
$pardot_agentiem_no = $db->sql_date($_POST['pardot_agentiem_no']);
$updates['pardot_agentiem_no'] = $pardot_agentiem_no;

///////////////////
// konts
///////////////////
$updates['konts'] = $_POST['konts'];

///////////////////
// konts_ava
///////////////////
$updates['konts_ava'] = $_POST['konts_ava'];


///////////////////
// marsruts
///////////////////
if ($_POST['v']){
	$marsruts = $db->getID('marsruts',$old['mID']);
	
	$mupdates = array();
	$mupdates['old'] = $_POST['old'];
	if (!$mupdates['old']) $mupdates['old'] = 0;
	$mupdates['v'] = $_POST['v'];
	
	$db->Update('marsruts',$mupdates,$old['mID']);
	$db->Query("update marsruts set v2 = dbo.fn_encode(v) where id = ".$old['mID']);
}

///////////////////
// slug
///////////////////
if ($_POST['slug']) {
	$updates['slug'] = generateSlug($_POST['slug']);
} else {
	if ($_POST['v']) {
		$updates['slug'] = generateSlug($_POST['v']);
	}
}

///////////////////
// meta_desc
///////////////////
if ($_POST['meta_desc']) {
	$db->Query("update grupa set meta_desc = N'" . $_POST['meta_desc'] . "' where [mid] = ".$old['mID']);

}


///////////////////
// carter
///////////////////
if ($_POST['carter'])
	$carter = 1;
else
	$carter = 0;
$updates['carter'] = $carter;

///////////////////
// Èartera viesnica
///////////////////
$updates['carter_viesn_id'] = $_POST['carter_viesn_id'];
if ($carter == 1 && $_POST['carter_viesn_id']==0)
{
	$message = 'Jâizvçlas èartera viesnica!';
}

///////////////////
// lidojuma vietas
// vienâ lidojumâ var bût cilvçki no vairâkâm grupâm, tapçc svarîgi kontrolçt vietu skaitu lidojumâ
///////////////////
$lidojums = $db->sql_date($_POST['lidojums']);
$lidojums_vietas = $_POST['lidojums_vietas'];

$updates['lidojums'] = $lidojums;
$updates['lidojums_vietas'] = $lidojums_vietas;

// reìistrçjam konkrçtâ datuma lidojuma vietas lai arî citas grupas zinâtu
if ($carter !=0 && $lidojums_vietas!='' && $lidojums){
	$lv = $db->get_by_field('lidojums_vietas','lidojums',$lidojums);
	if ($lv===NULL){
		$db->insert('lidojums_vietas',array('lidojums'=>$lidojums));
	}
	$db->Query("update lidojums_vietas set vietas = $lidojums_vietas where lidojums = '$lidojums'",array());
}

///////////////////
// standarta viesnicas
///////////////////
if ($_POST['standarta_viesnicas']){
	$proc_twin = 65;
	$proc_double = 50;
	$proc_single = 5;
	
	$vietsk_nakts = $_POST['vietsk_nakts'];
	if (!$vietsk_nakts)
		$vietsk_nakts = 40;
	
	if ($vietsk_nakts == 0)
		$vietsk_nakts = 40;
	

	$twin_id = $vietu_veidi->ensure($gid,'TWIN','Divvietîgs atseviğía gulta',2);
	$count = round($vietsk_nakts * $proc_twin / 100 / 2);
	$viesnicas->ensure($gid,2,$twin_id,$count);
	
	$double_id = $vietu_veidi->ensure($gid,'DOUBLE','Divvietîgs kopîga gulta',2);
	$count = round($vietsk_nakts*$proc_double/100/2);
	$viesnicas->ensure($gid,2,$double_id,$count);
	
	$double_id = $vietu_veidi->ensure($gid,'DOUBLE','Divvietîgs kopîga gulta',2);
	$count = round($vietsk_nakts*$proc_double/100/2);
	$viesnicas->ensure($gid,2,$double_id,$count);
	
	$single_id = $vietu_veidi->ensure($gid,'SINGLE','Vienvietîgs',1);
	if ($grupa->has_single($gid) || $carter){
		$count = round($vietsk_nakts*$proc_single/100);
		$viesnicas->ensure($gid,1,$single_id,$count);
	}
	$vietu_veidi->ensure($gid,'TRIPLE','Trîsvietîgs',3);
	$vietu_veidi->ensure($gid,'DOUBLE+1','Divvietîgs kopîga gulta+1',3);
	$vietu_veidi->ensure($gid,'TWIN+1','Divvietîgs atseviğía gulta+1',3);
	$vietu_veidi->ensure($gid,'QUADRA','Èetrvietîgs',4);
}

///////////////////
// veids
///////////////////
$updates['veids'] = $_POST['veids'];

///////////////////
// klients	TODO: trûkst pârbaudes vai klientam ir visi rekvizîti
///////////////////
if ($_POST['klients']=='2')
	$updates['pasutitajs'] = $_POST['klients'];
else
	$updates['pasutitajs'] = 0;

///////////////////
// valsts
///////////////////
$valsts = $_POST['valsts'];
if ($valsts!="X"){
	$db->Query("UPDATE marsruts SET valsts = '$valsts' where id = (select mid from grupa where id = $gid)");
} 

///////////////////
// valsts dala
///////////////////
$valsts_dala = $_POST['valsts_dala'];
if ($valsts_dala!="X"){
	$db->Query("UPDATE marsruts SET valsts_dala = '$valsts_dala' where id = (select mid from grupa where id = $gid)");
} else {
	$db->Query("UPDATE marsruts SET valsts_dala = NULL where id = (select mid from grupa where id = $gid)");
}

///////////////////
// atcelta
///////////////////
if ($_POST['atcelta'])
	$atcelta = 1;
else
	$atcelta = 0;
$updates['atcelta'] = $atcelta;

///////////////////
// sakuma_dat
///////////////////
$sakuma_dat = $db->sql_date($_POST['sakuma_dat']);
$updates['sakuma_dat'] = $sakuma_dat;

///////////////////
// beigu_dat	TODO: pârbaude vai nav mazâks par sâkuma datumu
///////////////////
$beigu_dat = $db->sql_date($_POST['beigu_dat']);
$updates['beigu_dat'] = $beigu_dat;

///////////////////
// grupas vadîtâji
///////////////////
$vaditajs = $db->sql_num($_POST['vaditajs']);
$vaditajs2 = $db->sql_num($_POST['vaditajs2']);
$updates['vaditajs'] = $vaditajs;
$updates['vaditajs2'] = $vaditajs2;

///////////////////
// izbraukğanas laiks un iebraukğanas laiks un vadîtâja pieejamîba
///////////////////

if ($db->validate_time($_POST['izbr_laiks'])){
	$izbr = $sakuma_dat . ' ' . $_POST['izbr_laiks'];
	$updates['izbr_laiks'] = $izbr;
}
else {
	$updates['izbr_laiks'] = NULL;
}
	
if ($db->validate_time($_POST['iebr_laiks'])){
	$iebr = $beigu_dat . ' ' . $_POST['iebr_laiks'];
	$updates['iebr_laiks'] = $iebr;
}
else {
	$updates['iebr_laiks'] = NULL;
}

if ($db->validate_time($_POST['ielid_laiks_uz'])){
	$ielid_laiks_uz = $sakuma_dat . ' ' . $_POST['ielid_laiks_uz'];
	$updates['ielid_laiks_uz'] = $ielid_laiks_uz;
} else {
	$updates['ielid_laiks_uz'] = NULL;
}



if ($vaditajs) {
	if ($db->validate_time($_POST['izbr_laiks'])
		&& $db->validate_time($_POST['iebr_laiks'])){
			$izbr = $sakuma_dat . ' ' . $_POST['izbr_laiks'];
			$iebr = $beigu_dat . ' ' . $_POST['iebr_laiks'];
			if (!$grupu_vaditaji->IsFree($vaditajs,$gid,$izbr,$iebr)) {
				$message = 'Pirmais grupas vadîtâjs ir aizòemts!';
			}
		}
}

if ($vaditajs2) {
	if ($db->validate_time($_POST['izbr_laiks'])
		&& $db->validate_time($_POST['iebr_laiks'])){
			$izbr = $sakuma_dat . ' ' . $_POST['izbr_laiks'];
			$iebr = $beigu_dat . ' ' . $_POST['iebr_laiks'];
			if (!$grupu_vaditaji->IsFree($vaditajs2,$gid,$izbr,$iebr)) {
				$message = 'Otrais grupas vadîtâjs ir aizòemts!';
			}
		}
}


///////////////////
// izbraukğanas vieta
///////////////////
$updates['izbr_vieta'] = $_POST['izbr_vieta'];


///////////////////
// Vauèeris
///////////////////
if ($_POST['drukat_vauceri'])
	$drukat_vauceri = 1;
else
	$drukat_vauceri = 0;
$updates['drukat_vauceri'] = $drukat_vauceri;

///////////////////
// iebraukğanas vieta
///////////////////
$updates['iebr_vieta'] = $_POST['iebr_vieta'];

///////////////////
// sapulces_dat		TODO: pârbaude vai nav lielâks par sâkuma datumu
///////////////////
$sapulces_dat = $db->sql_date($_POST['sapulces_dat']);
$updates['sapulces_dat'] = $sapulces_dat;


///////////////////
// sapulces_laiks
///////////////////
$sapulce_ok = true;
// pârbauda laika formât sâkuma datumam
// un pieskaita datumam laiku
if ($_POST['sapulces_laiks_no'] == $_POST['sapulces_laiks_lidz'] && $_POST['sapulces_laiks_no'] = '00:00'){
	$_POST['sapulces_laiks_no'] = '';
	$_POST['sapulces_laiks_lidz'] = '';
}
if ($db->validate_time($_POST['sapulces_laiks_no']))
{
	$updates['sapulces_laiks_no'] = $_POST['sapulces_laiks_no'];
	if ($updates['sapulces_dat']) {
		$updates['sapulces_laiks_no'] = $updates['sapulces_dat'] . ' ' . $updates['sapulces_laiks_no'];
	}
} else {
	$sapulce_ok = false;
}
// pârbauda laika formât beigu datumam
// un pieskaita datumam laiku
if ($db->validate_time($_POST['sapulces_laiks_lidz'])){
	$updates['sapulces_laiks_lidz'] = $_POST['sapulces_laiks_lidz'];
	if ($updates['sapulces_dat']) {
		$updates['sapulces_laiks_lidz'] = $updates['sapulces_dat'] . ' ' . $updates['sapulces_laiks_lidz'];
	}
} else {
	$sapulce_ok = false;
}

// pârbauda vai sapulces nepârklâjas
if ($sapulce_ok) {
	$sapulce_dubult_kods = $grupa->ValidateSapulcesLaiks($updates['sapulces_laiks_no'],$updates['sapulces_laiks_lidz'],$gid);
	if ($sapulce_dubult_kods!=''){
		$sapulce_ok = false;
		$message = 'Sapulces datums pârklâjas ar citu grupu ('.$sapulce_dubult_kods.')';
	}
}
if (!$sapulce_ok){
	$updates['sapulces_laiks_no'] = null;
	$updates['sapulces_laiks_lidz'] = null;
}



///////////////////
// termiòi
///////////////////
$term1_dat = $db->sql_date($_POST['term1_dat']);
$updates['term1_dat'] = $term1_dat;
$updates['term1_summa'] = $db->sql_num($_POST['term1_summa']);
$updates['term1_zaud_summa'] = $db->sql_num($_POST['term1_zaud_summa']);
$term2_dat = $db->sql_date($_POST['term2_dat']);
$updates['term2_dat'] = $term2_dat;
$updates['term2_summa'] = $db->sql_num($_POST['term2_summa']);
$updates['term2_zaud_summa'] = $db->sql_num($_POST['term2_zaud_summa']);
$term3_dat = $db->sql_date($_POST['term3_dat']);
$updates['term3_dat'] = $term3_dat;

///////////////////
// cena
///////////////////
$updates['i_cena_eur'] = $db->sql_num($_POST['i_cena_eur']);


///////////////////
// pçdçjâs dienas cena
///////////////////
$updates['pm_cena'] = $db->sql_num($_POST['pm_cena']);
if ($updates['pm_cena']==0) 
	$updates['pm_cena'] = NULL;
$updates['ped_vietas_dzimums'] = $_POST['ped_vietas_dzimums'];

///////////////////
// vietas
///////////////////
$updates['vietsk'] = $db->sql_num($_POST['vietsk']);
$updates['vietsk_nakts'] = $db->sql_num($_POST['vietsk_nakts']);
$updates['avio_vietas'] = $db->sql_num($_POST['avio_vietas']);

///////////////////
// grupas nauda un vaditaja pieteikums
///////////////////
if ($veids = "1" || $veids = "2" || $veids = "3" ) {
	if ($vaditajs)
	{
		$vad = $grupu_vaditaji->get_by_idnum($vaditajs);
		$did = $grupu_vaditaji->ensure_dalibn_link($vad['idnum']);		
	} else {
		$did = 0;
	}
	
	if ($vaditajs2)
	{
		$vad2 = $grupu_vaditaji->get_by_idnum($vaditajs2);
		$did2 = $grupu_vaditaji->ensure_dalibn_link($vad2['idnum']);		
	} else {
		$did2 = 0;
	}
	
	if ($did!=0 || $did2!=0) {
		// veidojam grupas naudas pakalpojumu TODO: pârnest uz modeli
		$gv_vv = $db->query_array("select * from vietu_veidi where gid = '$gid' and tips = 'G'");
		if (count($gv_vv)==0){
			$gv_ins = $db->query_array("SET NOCOUNT ON; insert into vietu_veidi(gid,nosaukums,cena,persona,papildv,virsnieks,limenis,vesture,
						cenaLVL,cenaUSD,cenaEUR,limita_grupa,tips) values('$gid','Grupas nauda',0,0,0,0,1,
						'Auto - izveidots. '+cast(getdate() as varchar),0,0,0,'','G'); SELECT @@IDENTITY AS ID");
			$gv_vv = $db->query_array("select * from vietu_veidi where gid = '$gid' and tips = 'G'");
			$vv_id = $gv_vv[0]["id"];
		}
		else {
			$vv_id = $gv_vv[0]["id"];
		}
	}
	
	if ($did != 0)
	{

		// veido grupas vadîtâja pieteikumu: TODO: pârnest uz modeli
		$rp = $db->query_array("SELECT id,did FROM pieteikums WHERE deleted = 0 AND gid =$gid AND did = $did AND grupas_vad = 1");
		if (count($rp)==0) {
			$db->query_array("insert into pieteikums (gid,did,datums,deleted,piezimes,grupas_vad,personas) values ($gid,$did,getdate(),0,'GRUPAS VADÎTÂJS',1,0)");
			$rp = $db->query_array("select max(id) as max_id from pieteikums where gid = $gid");
			$pid = $rp[0]['max_id'];
		} else {
			$pid = $rp[0]['id'];
		}
		
		$rps = $db->query_array("SELECT * FROM piet_saite WHERE pid = $pid and deleted = 0");
		if (count($rps)==0) {
			$db->Query("insert into piet_saite (pid,did,cena,vietsk,summa,deleted,papildv,persona,vietas_veids) values ($pid,$did,0,0,0,0,0,0,$vv_id)");
		}
	} 

	if ($did2 != 0)
	{
		// veido grupas vadîtâja pieteikumu: TODO: pârnest uz modeli
		$rp = $db->query_array("SELECT id,did FROM pieteikums WHERE deleted = 0 AND gid =$gid AND did = $did2 AND grupas_vad = 1");
		if (count($rp)==0) {
			$db->query_array("insert into pieteikums (gid,did,datums,deleted,piezimes,grupas_vad,personas) values ($gid,$did2,getdate(),0,'GRUPAS VADÎTÂJS',1,0)");
			$rp = $db->query_array("select max(id) as max_id from pieteikums where gid = $gid");
			$pid = $rp[0]['max_id'];
		} else {
			$pid = $rp[0]['id'];
		}
		
		$rps = $db->query_array("SELECT * FROM piet_saite WHERE pid = $pid and deleted = 0");
		if (count($rps)==0) {
			$db->Query("insert into piet_saite (pid,did,cena,vietsk,summa,deleted,papildv,persona,vietas_veids) values ($pid,$did2,0,0,0,0,0,0,$vv_id)");
		}
	} 
	

	// izdzeğam visus citus vaditaju pieteikumus
	$db->Query("update pieteikums set deleted = 1 where gid = $gid and deleted = 0 and grupas_vad = 1 and isnull(iemaksasEUR,0) = 0 and did <> $did and did <> $did2");


}
///////////////////
// dzest vaditaja pieteikumu, ja vaditajs vairs nav piesaistits
///////////////////
//$db->Query(" update pieteikums set deleted = 1 where gid = $gid and deleted = 0 and grupas_vad = 1 and did <> $vaditajs and did <> $vaditajs2 and isnull(iemaksasEUR,0) = 0 and isnull(izmaksasEUR,0) = 0");
$db->Query(" update piet_saite set deleted = 1 where deleted = 0 and pid in (select id from pieteikums where deleted = 1 and gid = $gid)");

///////////////////
// vietu aprakstu piesaiste majas lapas marsrutam
///////////////////
if ($_POST['vietu_apraksts'])
{
	$rm = $db->query_array("select top 1 m.ID from portal.dbo.marsruti m 
		JOIN portal.dbo.grupas g on m.ID = g.marsruts
		WHERE g.gr_kods = '$kods'
	");
	
	if (count($rm)>0)
	{

		$mid  = (int)$rm[0]['ID'];
		$vaid = (int)$_POST['vietu_apraksts'];

		// Check if record already exists
		$check = $db->query_array("
			SELECT 1 
			FROM portal.dbo.Marsruti_vietu_apraksti
			WHERE mid = $mid
			  AND vaid = $vaid
		");

		// If no record found, insert
		if (count($check) === 0) {
			$db->query_array("
				INSERT INTO portal.dbo.Marsruti_vietu_apraksti ([mid],[vaid])
				VALUES ($mid, $vaid)
			");
		}
	}

}


///////////////////
// kurators
///////////////////
$updates['kurators'] = $db->sql_num($_POST['kurators']);

///////////////////
// kontrolieris (kavçtâju meklçtâjs)
///////////////////
$updates['kontrolieris'] = $db->sql_num($_POST['kontrolieris']);

///////////////////
// autobuss
///////////////////
$updates['autobuss_id'] = $db->sql_num($_POST['autobuss_id']);
$updates['autobuss'] = $_POST['autobuss'];

///////////////////
// Íçde
///////////////////
$updates['kede'] = $_POST['kede'];

///////////////////
// dokumenti un piezîmes
///////////////////
$updates['dokumenti'] = $_POST['dokumenti'];
$updates['piezimes'] = $_POST['piezimes'];

///////////////////
// grâmatvedîbas TODO jâpieliek tiesîbas
///////////////////
$updates['vad_id'] = $_POST['vad_id'];
$updates['ln'] = $_POST['ln'];
$updates['piezimes2'] = $_POST['piezimes2'];
$updates['pazimes'] = $_POST['pazimes'];

///////////////////
// grâmatvedîbas  sihrnonizâcijas karodziòğ
///////////////////
if ($beigu_dat != '' && $kods != '') {
	$db->Query("update grupa set need_check = 1 where id = $gid");
}

// big update 
if (count($updates)>0){
	
	$db->Update('grupa',$updates,$gid);
}

///////////////////
// atjaunojam informâciju par brîvajâm vietâm TODO pârnest uz modeli
///////////////////
$db->Query("delete from vietas where gid = $gid");
$db->Query("insert into vietas (gid,vietas,viesn_online_pieaug,viesn_online_bernu) values ($gid,isnull(dbo.fn_brivas_vietas($gid),0),dbo.fn_get_brivas_pieaug_vietas($gid),dbo.fn_get_brivas_bernu_vietas($gid))");

// TODO pasûtîjuma un skolçnu grupas cenu maiòu jâpieliek


function generateSlug($text) {
    // Latvian character replacements
    $replacements = [
        'â' => 'a', 'è' => 'c', 'ç' => 'e', 'ì' => 'g', 'î' => 'i', 'í' => 'k', 'ï' => 'l', 'ò' => 'n', 'ğ' => 's', 'û' => 'u', 'ş' => 'z',
        'Â' => 'A', 'È' => 'C', 'Ç' => 'E', 'Ì' => 'G', 'Î' => 'I', 'Í' => 'K', 'Ï' => 'L', 'Ò' => 'N', 'Ğ' => 'S', 'Û' => 'U', 'Ş' => 'Z', '/' => ''
    ];

    // Replace Latvian characters
    $text = strtr($text, $replacements);

    // Convert to lowercase
    $text = strtolower($text);

    // convert existing dashes to spaces
	$text = str_replace('-', ' ', $text);

    // Replace non-alphanumeric characters with spaces
    $text = preg_replace('/[^a-z0-9\s]/', '', $text);

    // Replace spaces with dashes
    $text = preg_replace('/\s+/', '-', $text);

    // Remove multiple dashes
    $text = preg_replace('/-+/', '-', $text);

    // Trim dashes from the beginning and end
    $text = trim($text, '-');

    return $text;
}

header('Location: grupa_edit2.asp?gid='.$gid.'&message='.urlencode ($message));
?>