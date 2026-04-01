<?
class Grupa {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else if (defined("PATH_TO_FILES")){
			$path =PATH_TO_FILES;
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;	
	}
	
	/**
	 * Groups with future sapulces_dat and set sapulces_laiks_no (for listing).
	 * Excludes cancelled. Ordered by sapulces date/time.
	 */
	public function GetFutureSapulces() {
		$select = "SELECT g.*, m.v";
		$from   = " FROM grupa g LEFT JOIN marsruts m ON g.mID = m.ID ";
		$where  = " WHERE g.atcelta = 0 "
				. " AND g.sapulces_dat > GETDATE() "
				. " AND g.sapulces_laiks_no IS NOT NULL ";
		$order  = " ORDER BY g.sapulces_dat ASC, g.sapulces_laiks_no ASC ";
		$qry    = $select . $from . $where . $order;

		$result = $this->db->Query($qry);
		$data   = array();
		while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
			$row['sapulces_dat_str']     = $this->db->Date2Str($row['sapulces_dat']);
			$row['sapulces_laiks_no_str'] = $this->db->Time2Str($row['sapulces_laiks_no']);
			$data[] = $row;
		}
		return $data;
	}	
	
	// pārbauda vai nepārklājas sapulces laiki
	function ValidateSapulcesLaiks($no,$lidz,$gid){
		$qry = "SELECT * FROM grupa WHERE 
			(
				(sapulces_laiks_no <= ? and sapulces_laiks_lidz >= ?)
				OR
				(sapulces_laiks_no <= ? and sapulces_laiks_lidz >= ?)
				OR
				(sapulces_laiks_no >= ? and sapulces_laiks_lidz <= ?)
			) AND id <> ? and atcelta = 0
			";
		
		$qry = "SELECT * FROM grupa WHERE 
			(
				(sapulces_laiks_no <= '$no' and sapulces_laiks_lidz >= '$no')
				OR
				(sapulces_laiks_no <= '$lidz' and sapulces_laiks_lidz >= '$lidz')
				OR
				(sapulces_laiks_no >= '$no' and sapulces_laiks_lidz <= '$lidz')
			) AND id <> '$gid' and atcelta = 0
			";
		$params = array($no,$no,$lidz,$lidz,$no,$lidz,$gid);
		$result = $this->db->Query($qry,$params);
		
		if (sqlsrv_has_rows($result)) {
			$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
			return $row['kods'];
		}
		return '';
	}
	
	function Insert($data){
		$qry = "SELECT * FROM grupa WHERE kods = ?";
		$params = array($data['kods'] );
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		if (sqlsrv_has_rows($result)) {
			echo "eksistē grupa";
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$id = $row['ID'];
			}
		}
		else{
			$this->db->Insert('grupa',$data);
			$qry = "SELECT MAX(id) as id FROM grupa";
			$res = $this->db->Query($qry);
			while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				$id = $row['id'];
			}
		}
		return $id;
	}
	
	//atgrie� �artera grupu id mas�vu, kur�m nedr�kst pie�aut pusaiz�emtus divviet�gos numuri�us
	function get_carter_full_rooms(){
		$query = "SELECT * FROM grupa WHERE kods IN ('17.V.2.4.1.B.9','17.V.2.4.1.B.C','17.V.2.4.1.B.B','17.V.2.4.1.B.A','17.V.2.4.1.B.8','17.V.2.4.1.B.E','17.V.2.4.1.B.D','17.V.2.4.1.B.7','17.V.2.4.1.B.5','17.V.2.4.1.B.2','17.V.2.4.1.B.3','17.V.2.4.1.B.4')";
		$result = $this->db->Query($query);
		$grupas = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$grupas[] =  $row['ID'];			
		}
		return $grupas;
		
	}
	
	function has_single($id){
		$query = "SELECT * FROM vietu_veidi WHERE gid = ? AND tips='V1'";
		$result = $this->db->Query($query,array($id));
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return true;			
		}
		return false;
	}
	
	function is_unique($id,$kods){
		$query = "SELECT * FROM grupa g WHERE id <> ? AND kods = ? ";
		$result = $this->db->Query($query,array($id,$kods));
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return false;			
		}
		return true;
	}

	
	function GetId($id){
		$query = "SELECT g.*,m.v FROM grupa g, marsruts m WHERE g.id = ? AND g.mID=m.id";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}
	
	function GetValsts($id){
		$query = "SELECT m.valsts FROM grupa g, marsruts m WHERE g.id = ? AND g.mID=m.id";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			return '';
		}		
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['valsts'];			
		}
	}
	
	//atgriež grupas kodu, datumu un nosaukumu
	function GetFullNosaukums($id){
		$grupa = $this->GetId($id);
		if ($grupa){
			$nosaukums = $grupa['kods'].' '.$this->db->Date2Str($grupa['sakuma_dat']).' '.$grupa['v'];
			return $nosaukums;
		}
	
	}
	
	function AvailableList($count, $id = FALSE){
		//lai rādītu arī testa grupas:
		require_once("m_marsruts.php");
		$marsruts =  new Marsruts();
		$test_mid_array = $marsruts->getTestIds('TEST GRUPA:');
		
		if (DEBUG){
			echo "testa grupas:<br>";
			var_dump($test_mid_array);
			echo "<br><br>";
		}
		if (isset($_SESSION['profili_id']) && (in_array($_SESSION['profili_id'],$this->db->tester_profiles)) 
			||isset($_SESSION['test_gr'])){
				//var_dump($this->db->tester_profiles);
		
			//$test_mid_array[] = 21287;
			if (count($test_mid_array)>0){
				$where_mid = "g.mID in (".implode(',',$test_mid_array).") and (g.sakuma_dat>getdate() 
				 AND g.atcelta = 0
				AND	g.veids = 1 )";
			}
			else $where_mid = "1=0";
			$test_where = "1=0";
			if(DEBUG){
				$test_where = "g.id=21657";//"g.id = 21059";
			}
			$query = "SELECT g.ID,g.mID,g.sakuma_dat ,v.vietas,g.kods,v.vietas,v.viesn_online_pieaug,v.viesn_online_bernu
				FROM grupa g, vietas v,marsruts m
				WHERE ((g.sakuma_dat>getdate() 
				AND g.internets = 1 AND g.atcelta = 0
				AND ISNULL(g.pdf,'') <> '') OR ($where_mid) OR ($test_where) )
					AND v.vietas >= $count
				AND v.gid=g.ID
				AND g.mID = m.ID
				";
				
				if(isset($_SESSION['test_gr'])){
					$query .= "AND g.sakuma_dat>getdate() ";
				}
			
		}
		else{
			if (count($test_mid_array)>0){
				$where_mid = "g.mID NOT in (".implode(',',$test_mid_array).")";
			}
			else $where_mid = "1=1";
			$query = "SELECT g.ID,g.mID,g.sakuma_dat ,v.vietas
					FROM grupa g
					JOIN vietas v ON g.ID = v.gid
					WHERE g.sakuma_dat>getdate() 
					AND g.internets = 1 AND g.atcelta = 0
					AND ISNULL(g.pdf,'') <> ''
					AND v.vietas >= $count
					AND ($where_mid) OR g.id = 25906";
					
					//echo $query;
					//die();
		}
		
		
		if ($id){
			$query .= " AND g.ID=?";
			$params = array($id);
		}
		else{
			$query .= " AND v.vietas>=?
					";
			$params = array($count);
		}
		
					//echo $query;
					//die();		
		
		$query .= " ORDER BY g.sakuma_dat ASC";
		if (DEBUG){
			echo $query."<br>";
		}
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$grupas = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//r�d�m tikai t�s grupas, kur�m ir pieejams pdf fails
			//if ($this->ExistsPdfId($row['ID']) || DEBUG || (isset($_SESSION['profili_id']) && (in_array($_SESSION['profili_id'],$this->db->tester_profiles)) )){

				$grupas[] = $row;
			//}
			
		}
		return $grupas;
		
	}
	
	function AvailableId($id){
		$query = "SELECT g.ID,g.mID,g.sakuma_dat ,v.vietas
					FROM grupa g, vietas v
					WHERE g.sakuma_dat>getdate() 
					AND g.internets = 1 AND g.atcelta = 0
					AND ISNULL(g.pdf,'') <> ''
					AND v.gid=g.ID
					AND g.ID = ?
					ORDER BY g.sakuma_dat ASC";
	
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['vietas'];
			
		}		
	}
	
	//atgriež maksājumu termiņus un summas
	function getPaymentDeadlinesId($id){
		$query = "SELECT term1_dat, term1_summa,term2_dat, term2_summa,term3_dat,valuta
					FROM grupa WHERE id=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}		
	}
	
	//atgriež šī gada online Dāvanu karšu grupas ID
	function getGiftCardGid(){
		$this_year  = date("Y");
		$query = "SELECT g.* FROM marsruts m,grupa g
					WHERE m.v like ('!D_vanu kartes - online%$this_year%')
					AND g.mID = m.ID";
		//echo $query."<br>";
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['ID'];
			
		}		
		
	}
	
	//atgriež visus iespējamos dāvanu karšu grupu ID
	function getAllGiftCardGid(){
		$query = "SELECT g.* FROM marsruts m,grupa g
					WHERE m.v like ('!D_vanu kartes%')
					AND g.mID = m.ID";
		//echo $query."<br>";
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$gid_array  = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$gid_array[] = $row['ID'];
			
		}
		return $gid_array;
	}
	
	function GetCelojumaNosId($id){
		$grupa = $this->GetId($id);
		//var_dump($grupa);
		$data = array();
		$data['sakuma_dat'] =  $this->db->Date2Str($grupa['sakuma_dat']);
		$data['beigu_dat'] =  $this->db->Date2Str($grupa['beigu_dat']);
		if ($data['sakuma_dat'] == $data['beigu_dat']){
			$datums = $data['sakuma_dat'];
		}
		else{
			if (date("Y",strtotime($data['sakuma_dat'])) == date("Y",strtotime($data['beigu_dat'])))
				$data['sakuma_dat'] = date("d.m.",strtotime($data['sakuma_dat']));
			$datums = $data['sakuma_dat']." - ".$data['beigu_dat'];
		}
		$mid = $grupa['mID'];
		
		require_once("m_marsruts.php");
		$marsruts = new Marsruts();
		$celojums = $marsruts->GetId($mid);
		
		$data['celojuma_nos'] = $celojums['v'];
		$celojuma_nos = $celojums['v']." (".$datums.")";
		//return $data;
		return $celojuma_nos;
	}
	//atgriež visus online dāvanu karšu grupu ID
	function getAllOnlineGiftCardGid(){
		$query = "SELECT g.* FROM marsruts m,grupa g
					WHERE m.v like ('!D_vanu kartes - online%')
					AND g.mID = m.ID
					AND g.veids=10
					";
		//echo $query."<br>";
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$gid_array  = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$gid_array[] = $row['ID'];
			
		}
		return $gid_array;
	}
	//atriež TRUE, ja grupa ir dāvanu karte, FALSE - ja nav
	function IsDkOnlineRez($online_rez){
		require_once("m_online_rez.php");
		$rez = new OnlineRez();
		//dab� grupas id no rezervb�cijas
		$gid = $rez->GetGidId($online_rez);
		$online_gift_card_gid_arr = $this->getAllOnlineGiftCardGid();
		if (in_array($gid,$online_gift_card_gid_arr))
			return true;
		else return false;
		
	}
	
	//p�rbauda, vai grupai ir detalizēts apraksts (pdf fails). ATgriež true, ja ir, false-ja nav
	function ExistsPdfId($id){
		/*$query = "SELECT g.pdf FROM grupa gg
				INNER JOIN portal.dbo.grupas g ON g.gr_kods = gg.kods
				INNER JOIN portal.dbo.marsruti m ON m.id = g.marsruts 
				where (isnull(g.pdf,'')<>'' OR isnull(m.pdf,'')<>'')
				And gg.id=?";*/
		$query =  "SELECT gg.pdf FROM grupa gg
				INNER JOIN portal.dbo.grupas pg ON pg.gr_kods = gg.kods
				INNER JOIN portal.dbo.marsruti m ON m.id = pg.marsruts 
				where (isnull(gg.pdf,'')<>'' OR isnull(m.pdf,'')<>'')
				And gg.id=?";
		//echo $query."<br>";
		$params = array($id);
		//var_dump($params);
		$result = $this->db->Query($query,$params);
		
		if (sqlsrv_has_rows($result)) {
			return true;
		}
		else return false;
		
	}
	
	
	//pievieno grupai pdf aprakstu
	function LinkPdf($id,$pdf){
		 
		 $this->db->Update('grupa',array('pdf'=> $pdf),$id);
		 //saglab�jam pie grupas vēstures, ka pievienots apraksts
		 $this->db->LogAction('grupa',$id,'pievienots ce�ojuma apraksts');
		 //izsūtam e-pastu par pdf apraksta pievieno�anu		
		 require_once("l_email.php");
		 $email = new Email();
		 $gr = $this->GetId($id);
		 $email->SendGroupPdfChanges($gr);
	
		 
	}
	//noņem grupai pdf aprakstu
	function UnlinkPdf($id){
		 
		 $this->db->Update('grupa',array('pdf'=> NULL),$id);
		 //saglab�jam pie grupas v�stures, ka no�emts apraksts
		 $this->db->LogAction('grupa',$id,'no�emts ce�ojuma apraksts');
		  //izs�t�m e-pastu par pdf apraksta no�em�anu	
		 require_once("l_email.php");
		 $email = new Email();
		 $gr = $this->GetId($id);
		 $email->SendGroupPdfChanges($gr,0);
	}
	
	function GetNullesPakalpId($gid){
		$qry = "SELECT id FROM vietu_veidi WHERE gid=? AND nosaukums like '%nav%' AND tips='X'";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$vv = $row['id'];
		}
		else $vv = 0;
		return $vv;
	}
	
	
	//atgrie� grupas kuratoru, kontrolieru e-pastus, kuriem s�t�t sist�mas zi�ojumus par grupas k��d�m (nepareizi pakalpojumi u.c.)
	function GetResponsibleEmails($gid){
		$email_arr = array('impro@impro.lv','madara@impro.lv');

		$qry = "SELECT kurators, kontrolieris FROM grupa WHERE id=?";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);
		$lid_arr = array();
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			if (!empty($row['kontrolieris'])) $lid_arr[] = $row['kontrolieris'];
			if (!empty($row['kurators'])) $lid_arr[] = $row['kurators'];
			if (!empty($lid_arr)){
				
				require_once("m_lietotaji.php");
				$lietotaji = new Lietotaji();
				foreach ($lid_arr as $lid){
					$epasts = $lietotaji->GetField('epasts',$lid);
					if (!empty($epasts) && !in_array($epasts,$email_arr)){
						$email_arr[] = $epasts;
					}
					
				}
			}
			
		}
		return $email_arr;
		
	}
	function SendEmail2Resp($gid,$msg){
		$grupa = $this->GetId($gid);
		if (!$grupa['TESTAM']){
			//atrod atbild�go grupas lietot�ju e-pastus
			$email_arr = $this->GetResponsibleEmails($gid);
		}
		else{
			$email_arr = array('r.treikalisha@gmail.com');
		}
		//var_dump($email_arr);
		require_once("l_email.php");
		$email = new Email();
		$subj = 'K��da online rezerv�cij�';
		//$recipient = 'r.treikalisha@gmail.com; ruupasts@inbox.lv';
		$recipient = implode(';',$email_arr);	
		$email->SendMail($msg, $subj, $recipient,true,'SendEmail2Resp');
	}
	
	//atgrie� grupas vad�t�ju
	function GetVaditajs($gid){
		$qry = "SELECT v.* FROM grupu_vaditaji v, grupa g WHERE v.idnum=g.vaditajs and g.id=?";
		
		$params = array($gid);
		$res = $this->db->Query($qry,$params);			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			return $row;
		}
		return false;
	}
	
	//atgrie� grupas dal�bnieku sarakstu
	function GetDalibnList($gid){
		$qry = "SELECT DISTINCT dalibn.ID AS did, dalibn.vards, dalibn.nosaukums, dalibn.uzvards,pieteikums.datums,pieteikums.id as pid,dalibn.eadr
		FROM dalibn INNER JOIN (Pieteikums INNER JOIN piet_saite ON Pieteikums.id = piet_saite.pid left join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id) ON dalibn.ID = piet_saite.did WHERE isnull(vietu_veidi.tips,'') <> 'G' and pieteikums.gid = ? AND (isnull(piet_saite.kvietas_veids,0) <> 3 OR (isnull(piet_saite.kvietas_veids,0) = 3 AND piet_saite.papildv=1)) AND piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) ORDER BY uzvards,vards ASC;";
		//pieteikums.datums, pieteikums.id , piet_saite.persona desc;
		//echo $qry;
		$params = array($gid);
		$res = $this->db->Query($qry,$params);
		$data = array();		
		while($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			//print_r($row);
			$data[] = $row;
		}
		return $data;
		

	}
	
	//p�rbauda, vai grupa ir �arteris
	function IsCarter($gid){
		$grupa = $this->GetId($gid);
		if ($grupa['carter'] == 1) return true;
		else return false;
	}
	
	//p�rbauda, vai izv�l�to ce�ojumu dr�kst pied�v�t
	function ValidateSelectedGid($gid,$traveller_count){
		$error = "";
		
		//ne�aujam �emt pr�mju ce�ojumu rezrev�cij�m ar vair�k nek� 4 dal�bniekiem
		if ($traveller_count > 4){
			require_once("m_kajite.php");
			$kajites = new Kajite();
			
			$kajisu_veidi = $kajites->GetVeidiGid($gid);
			if (count($kajisu_veidi)>0){
				$error = "Ce�ojumu ar pr�mi iesp�jams rezerv�t ne vair�k k� 4 dal�bniekiem. Veiciet vair�kas rezerv�cijas vai sazinieties ar IMPRO!";
			}
		}
		return $error;
		
	}
	
	function GetVietas($gid){
		$qry = "select dbo.fn_brivas_vietas(?) as x";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);
		
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			return $row['x'];
		}
		
		return 0;
	}
	
	
	//atgrie� brivo vietu skaitu autobus� 
	function GetVietasAutobuss($gid,$online_rez_id){
		$qry = "SELECT vietas FROM vietas WHERE gid=?";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);
			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$brivas_vietas = $row['vietas'];
		}
		
		$grupa = $this->GetId($gid);
		//--- personu skaits kas brauc
		$qry = "SELECT isnull(sum(isnull(personas,0)),0) as personas FROM pieteikums where gid = ? and deleted = 0";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);
			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$personas = $row['personas'];
		}
		
		//-- aizemto papildvietu skaits autobusa
		$qry = "SELECT isnull(sum(vietsk),0) as papildvietas FROM piet_saite WHERE 
				pid in 
					(select id from pieteikums where gid = ? and deleted = 0
					and (pieteikums.tmp=0 or agents_izv = 1)) 
				and deleted <> 1
				and papildv = 1
				and pid not in (select id from pieteikums where online_rez=? and deleted=0)";
		$params = array($gid,$online_rez_id);
		$res = $this->db->Query($qry,$params);
			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$papildvietas = $row['papildvietas'];
		}
		/*$qry = "select sum(CAST(persona AS INT)) + sum(CAST(papildv AS INT)) as aiznemts
				from piet_saite 
				where pid in (select id from pieteikums where  gid=? and deleted=0 )
				and deleted=0";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);*/
			

		$vietas = $grupa['vietsk'] - $personas - $papildvietas;
		return $vietas;
		
	}
	
	function GetWhere($data){

		$where = " WHERE g.atcelta=0 AND g.TESTAM=0 ";
	
		if (!empty($data['kods'])){
			$where .= " AND g.kods like '".$data['kods']."'";
		}
		if (!empty($data['kurators'])){
			$where .= " AND g.kurators = '".$data['kurators']."'";
		}
		if (!empty($data['valsts'])){
			$where .= " AND m.valsts = '".$data['valsts']."'";
		}
		if (!empty($data['datums_no'])){
			$where .= " AND g.sakuma_dat >= '".date("Y-m-d",strtotime($data['datums_no']))."'";
		} 
		if (!empty($data['datums_lidz'])){
			$where .= " AND g.sakuma_dat < '".date("Y-m-d",strtotime($data['datums_lidz']))."'";
		} 
		if (!empty($data['ar_anketam'])){
			$where .= " AND g.id IN (select gid from anketas) AND m.v  not like '!%'";
		}

		$select = "SELECT g.*,m.v";
		$from =   " FROM grupa g /*left join lietotaji li on g.kurators=li.id left join lietotaji li2 on g.kontrolieris=li2.id */ left join marsruts m  on g.[mID]=m.ID ";
	
		$order_by = " ORDER BY g.sakuma_dat ASC,m.v ASC";
		$qry = $select.$from.$where.$order_by;
		//echo $qry;
		$result = $this->db->query($qry);
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//$row['datums_txt'] =  $this->GetDateTxt($row['No'],$row['Lidz']);
			$data[] = $row;
		}		
		return $data;
	
	}
	function GetDepartureLocation($locationId)
	{
		$query = "select * from grupa_izbr_vieta where id = ?";
		$params = array($locationId);
		$res = $db->Query($query,$params);

		return $locationRow["nosaukums"];
	}

	function IsInGroup($did,$gid)
	{
		$query = "select id from pieteikums where did = $did and gid = $gid and deleted = 0 ";
		$res = $this->db->query($query);
		if (sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)) 
			return true;
		else
			return false;
	}
	

	function GetBlockType($b_type) {
	  $bt="nav";
	  switch ((int)$b_type) {

	    case 1:
	      $bt="sl�gta";
	      break;

	    case 2:
	      $bt="atv�rta";
	      break;
	  }
	  return $bt;
	}
	//--------------------------------------

	function ComboBlockType($b_type) {
	  $shtml="<SELECT name=blocked>";
	  $shtml+="<OPTION value=0";
	  if (empty($b_type)) {
	    $shtml+=" selected "; 
	  }
	  $shtml+=">nav</OPTION>";
	  $shtml+="<OPTION value=1";
	  if ($b_type == 1) {
	    $shtml+=" selected "; 
	  }
	  $shtml+=">sl�gta</OPTION>";
	 
	  $shtml+="</SELECT>";
	  return $shtml;
	}
	//--------------------------------------

	
}
?>