<?
class Pieteikums {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init_utf.php');
	
		$this->db = new Db;

	}
	
	function PlaceInRoom($rez,$did,$viesn_id){
		
		$psid = $this->db->GetValue("
			select top 1 ps.id from piet_saite ps
				join pieteikums p on ps.pid = p.id
				where 
					p.online_rez = $rez
					and ps.did = $did
					and p.deleted = 0
					and ps.deleted = 0
				order by ps.id
			","id"
		);
		
		$pid = $this->db->GetValue("select pid from piet_saite where id = $psid","pid");
		$gid = $this->db->GetValue("select gid from pieteikums where id = $pid","gid");
		$vvid = $this->db->GetValue("select veids from viesnicas where id = $viesn_id","veids");
		$bazes_cena = $this->db->GetValue("select id from vietu_veidi where gid = $gid and tips = 'C' and max_vecums is null","id");
		$bazes_cena_berns = $this->db->GetValue("select isnull(max(id),0) as x from vietu_veidi where gid = $gid and tips = 'C' and max_vecums is not null","x");

		// kajīšu grupām nav bāzes cenas
		if (!$bazes_cena) {
			$bazes_cena = $this->db->GetValue("select id from vietu_veidi where gid = $gid and tips = 'X'","id");
			$bazes_cena_berns = $bazes_cena;
		}

		// dzēšam visas viesnicas piemaksas šajā pieteikumā
		$this->db->Query("update ps set deleted = 1 
			from piet_saite ps
			join vietu_veidi v on ps.vietas_veids = v.id
			where 
				pid = $pid 
				and (v.tips = 'VV'  or v.tips = 'V1')");
		
		// ieliekam viesnicaa
		$this->db->Query("update piet_saite set 
			vid = $viesn_id
			,vietas_veids = $bazes_cena
			where id = $psid
			",array());
		
			
		// viesnicai piesaistītā piemaksa
		$piemaksa_id = $this->db->GetValue("select isnull(vietu_veidi_id,0) as x from viesnicas_veidi where id = $vvid","x");
		$piemaksa_berns_id = $this->db->GetValue("select isnull(vietu_veidi_child_id,0) as x from viesnicas_veidi where id = $vvid","x");
		
		if ($piemaksa_id != 0 ) {
			$piet_saite = $this->GetSaiteId($psid);
			unset($piet_saite['id']);
			unset($piet_saite['vid']);
			$piet_saite['vietas_veids'] = $piemaksa_id;
			unset($piet_saite['vietas_cenaEUR']);
			unset($piet_saite['summaEUR']);
			$this->db->Insert("piet_saite",$piet_saite);
		}
	}
	
	function GetViesnicasPiemaksa($pid){
		return $this->db->GetValue("SELECT top 1 v.id
			FROM piet_saite ps
			join vietu_veidi v on ps.vietas_veids = v.id
			WHERE pid=$pid and v.tips = 'VV'","id");
	}
	
	function GetSaglabataBazesCena($pid){
		//echo $pid;
		return $this->db->GetValue("SELECT top 1 ps.summaEUR
			FROM piet_saite ps
			join vietu_veidi v on ps.vietas_veids = v.id
			WHERE pid=$pid and (v.tips = 'C' or v.tips = 'CH1')","summaEUR");
	}
	
	function GetId($id){
		$query = "SELECT * FROM pieteikums WHERE ID=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}		
	}
	
	function Update($data,$id){	
		//$old_piet = $this->GetId($id);
		$result = $this->db->Update('pieteikums',$data,$id);
		//$new_piet = $this->GetId($id);
		//$this->db->UpdateActionDetails($old_piet,$new_piet,"pieteikums",$id,"");
		return $result;	
	}
	
	function GetSaiteId($id){
		$query = "SELECT * FROM piet_saite WHERE id=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	//atgriež asociatīvo masīvu ar pieteikum saitēm, kur key=saites_id
	function GetSaitesAssoc($id){
		$query = "SELECT * FROM piet_saite WHERE pid=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		$data = array();	
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[$row['id']] = $row;			
		}
		return $data;
	}
	
	function Insert($data){
		require_once('m_profili.php');
		
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));	
		$formated_date = $date->format('Y-m-d H:i:s');
		if (!isset($data['datums']))
			$data['datums'] = $formated_date;
		if (!isset($data['vesture'])){
			$profili = new Profili();
			$profils = $profili->GetId();
			$epasts = $profils['eadr'];
			$data['vesture'] = $epasts.' (online) - Izveidoja. '.$formated_date." <br>";
		}	
		if (!isset($data['deleted']))
			$data['deleted'] = 0;
		if (!isset($data['agents']))
			$data['agents'] = 0;
		if (!isset($data['personas']))
			$data['personas'] = 1;
		if (!isset($data['atcelts']))
			$data['atcelts'] = 0;
		if (!isset($data['izveidoja']))
			$data['izveidoja'] = 'online';
		if (!isset($data['internets']))
			$data['internets'] = 1;
		if (!isset($data['step']))
			$data['step'] = 0;
		if (!isset($data['is_new']))
			$data['is_new'] = 1;
		
	
		$pieteikums_id = $this->db->Insert('pieteikums',$data,array('did' =>$data['did'],'internets'=>1));
		return $pieteikums_id;
	}
	
	function InsertSaite($data){
		//piet_saite : pid, did, vietsk = 1, deleted = 0, persona = 1
		if (!isset($data['vietsk']))
			$data['vietsk'] = 1;
		if (!isset($data['deleted']))
			$data['deleted'] = 0;
		if (!isset($data['persona']))
			$data['persona'] = 0;	
		if (!isset($data['papildv']))
			$data['papildv'] = 0;		
		
		//var_dump($data);
		//die();
		$result = $this->db->Query(" select gid from pieteikums where id = ".$data['pid']);
		$p = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		
		$result = $this->db->Query(" select gid from vietu_veidi where id = '".$data['vietas_veids']."' and gid = ".$p['gid']);
		//echo " select gid from vietu_veidi where id = '".$data['vietas_veids']."' and gid = ".$p['gid'];
		//die();
		if ($data['vietas_veids'] != '' && $data['vietas_veids'] != '0')
			if (!sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))
				die('Kluda veicot rezervaciju. Iespejams, ka vienlaikus atverti vairaki rezervacijas logi! ');
		
		
		$piet_saite_id = $this->db->Insert('piet_saite',$data,$data);
		
		return $piet_saite_id;
	}
	
	function Calculate1($pid) {
		$query = "EXEC pieteikums_calculate_jauns @pid = ?";
		$params = array($pid);

		$this->db->Query($query,$params);
	}
	function Calculate($pid) {
		$query = "EXEC pieteikums_calculate $pid";
		
		require_once("i_pieteikums_calculate.php");
		PieteikumsCalculate($pid);		
	}
	
	function UpdateSaite($data,$id){
		$pid = $data['pid'];
		$result = $this->db->Update('piet_saite',$data,$id);
		
		return $result;
	}
	
	function DeleteSaite($pid){

		//vēstures saglabāšanai
		$old_vals = $this->GetId($pid);
		$where = " pid=? AND (vid=0 OR vid IS NULL) AND (kid=0 OR kid IS NULL) AND deleted=0";
		$qry = "SELECT * FROM piet_saite WHERE $where";
		$params = array($pid);
		$result = $this->db->Query($qry,$params);
		$old_saites_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$id = $row['id'];
			$old_saites_arr[$id] = $row;
		}
		$qry = "UPDATE piet_saite SET deleted=1 WHERE $where";
		if (DEBUG) echo "$qry<br>";
		
		$this->db->Query($qry,$params);
		$qry = "UPDATE piet_saite SET vietas_veids=0 WHERE pid=? AND (isnull(vid,0)<>0 ) AND (isnull(kid,0)<>0) AND  isnull(vietas_veids,0) <>0";
		$params = array($pid);
		$this->db->Query($qry,$params);
		 

		if (!empty($old_saites_arr)){
			$history = "";
			$FieldsToSave = $this->db->GetPietSaiteEditFields();
		
			 foreach ($old_saites_arr as $old_saites_vals){
			
				 $history_arr = array();
				 Foreach ($FieldsToSave as $item){
					if (!empty($old_saites_vals[$item])) {
					 
						$history_arr[$item] = $this->db->GetFieldTitle($item,"piet_saite") . ": " .$this->db->GetValStr($item,$old_saites_vals[$item]);
					}
				 }
				 //ja ir lauki, ko saglabāt un tā nav tukšā piet_saite ar vietsk, ko izveido pēc pieteikuma izvedošanas
				 if (count($history_arr) and !(count($history_arr)==1 and key($history_arr) =='vietsk')){
					$history .= "** Dzēsts pakalpojums :: ".implode(", ",$history_arr)." => <br>";
					
				}
			}
			 if (!empty($history)){
					
				$new_vals = $this->GetId($pid);
				$this->db->UpdateActionDetails($old_vals,$new_vals,"pieteikums",$pid,$history);
			}
		}
	
	}
	
	//atgriež pieteiktos pakalpojumus par konkrēto pieteikumu VAI rezervaciju
	function GetPakalp($pid=FALSE,$online_rez=FALSE,$vietu_veidi_arr=FALSE){
	
		//echo "PID:".$pid;
		$qry = "SELECT * FROM piet_saite s";
		
		$params = array();
		$where = 0;
		if ($pid){
			$qry .= " WHERE pid = ? AND isnull(summaEUR,0)<>0 ";
			$params[] = $pid;
			$where = 1;
		}
		if ($online_rez){
			$qry .= ", pieteikums p WHERE s.pid=p.id AND p.online_rez = ? AND not p.gid in (".$this->db->invisibleGid.")";
			$params[] = $online_rez;
			$where = 1;
		}
		if ($where)
			$qry .= " AND s.deleted!=1";
		else 
			$qry .= " WHERE s.deleted!=1";
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
		}
		//$params = array($pid);
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}	
			//iet cauri visiem pieejamajiem pakalpjumiem
		$pieteiktie_pak = array();
		if(sqlsrv_has_rows($result) ) {
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$pieteiktie_pak[]= $row;
				
			}	
		}
		if ($vietu_veidi_arr){
			foreach ($vietu_veidi_arr as $vietu_veids){
				//inicializējam atgriežamo masīvu ar vietas veidu un skaitu
				$piet_pak_arr[$vietu_veids['id']] = 0;
				foreach ($pieteiktie_pak as $piet){
					if ($piet['vietas_veids'] == $vietu_veids['id']){
						$piet_pak_arr[$vietu_veids['id']]++;
					}
				}
			}
			return $piet_pak_arr;
		}
		else return $pieteiktie_pak;
		
	}
	
	//atgriež rezervēto viesnīcas numuriņu, ja tāds ir
	function GetViesnica($pid){
		$qry = "SELECT vid FROM piet_saite WHERE deleted!=1 
				AND vid IS NOT NULL AND vid>0";
		
		$qry .= " AND pid = ?";
		$params = array($pid);
		
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}	
						
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['vid'];
		}
		
	}
	
	//atgriež pieteikuma ID pēc rezervācijas un dalībnieka ID
	function GetOnlineRezDid($online_rez,$did){
		$qry = "SELECT * FROM pieteikums WHERE online_rez = ? AND did= ? AND not gid in (".$this->db->invisibleGid.")";
		$params = array($online_rez,$did);
		if (DEBUG){
		//echo $qry."<br>";
		//var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//var_dump($row);
			return $row['id'];			
		}	
	}
	
	//atgriež dalībieku ID pēc viesnīcas ID
	function GetDidVid($vid,$did=0){
		$qry = "SELECT * FROM piet_saite WHERE vid= ? AND deleted!=1 AND did!=?";
		$params = array($vid,$did);
		if (DEBUG){
			//echo $qry."<br>";
			//var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		$dalibnieku_id = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//var_dump($row);
			//return $row['did'];	
			$dalibnieku_id[] = $row['did'];
		}
		return $dalibnieku_id;		
	}
	
	//atgriež iemaksas par konkrēto ceļojumu
	function GetIemaksatsOnlineRez($online_rez, $did=FALSE){
		
		$qry = "SELECT iemaksasEUR-izmaksasEUR as iemaksats 
				FROM pieteikums WHERE online_rez=?
				";
		if ($did)
			$qry .= " AND did=?";
		$params = array($online_rez,$did);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
			echo "<br><br>";
		}
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['iemaksats'];			
		}	
	}
	
	//--atgriež kopējo pakalpojumu summu--//
	function GetSumma($online_rez,$did=FALSE){
		$qry = "SELECT SUM(s.summaEUR) as summa
				FROM piet_saite s, pieteikums p, online_rez r
				WHERE s.pid=p.id
				AND p.online_rez=r.id
				AND r.id=?
				AND s.deleted!=1";
		if ($did)
			$qry .= " AND p.did=?";
		$params = array($online_rez,$did);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['summa'];
		}		
	}
	
	//--------------------atgriež visus pieteikumus pēc online rez ID------//
	function GetPietOnlineRez($online_rez){
		
		$qry = "SELECT p.* 
				FROM pieteikums p, online_rez r
				WHERE p.online_rez=r.id
				AND r.id=?
				AND p.deleted!=1
				AND p.gid not in (".$this->db->invisibleGid.")";
	
		$params = array($online_rez);
		if (DEBUG){
			echo "$qry<br>";
			var_dump($params);
			echo "<br><br>";
		}
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$pieteikumi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$pieteikumi[] = $row;
		}
		return $pieteikumi;		
	}
	
	//atgriež dalībnieku pēc pieteikuma ID
	function GetDalibnPid($pid){
		//echo "pid";
		$qry = "SELECT d.*  
				FROM dalibn d, pieteikums p
				WHERE p.id=? 
				AND p.did=d.ID";
		//echo "$qry<br>";
		$params = array($pid);
		//var_dump($params);
	//	echo "<br><br>";
		$result = $this->db->Query($qry,$params);
			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			//echo "<br><br>";
			return $row;
		}
		$qry = "SELECT d.*  
				FROM dalibn d,piet_saite ps
				WHERE ps.pid=? 
				AND ps.did=d.ID ";
		//echo "$qry<br>";
		$params = array($pid);
		//var_dump($params);
	//	echo "<br><br>";
		$result = $this->db->Query($qry,$params);
			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			//echo "<br><br>";
			return $row;
		}
	
	}
	
	//atgrieži papildvietu cenu pēc pieteikuma ID
	function GetPapildvSummaPid($pid){
		$qry = "select isnull(sum(summaEUR),0) x from piet_saite inner join 
						vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id
						where pid = ? and tips = 'P' and piet_saite.deleted = 0";
		//echo "$qry<br>";
		$params = array($pid);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
	}
	
	//atgriež kajītes pēc rezervācijas id
	function GetKajitesOnlineRez($online_rez){
		$qry = "select kvietas_veids,nosaukums from piet_saite 
		inner join kajite on kajite.id = piet_saite.kid
		inner join kajites_veidi on kajite.veids = kajites_veidi.id
		where 
		kvietas_veids <> 0
		and piet_saite.deleted = 0 
		and pid in 
		(select id from pieteikums where online_rez = ? AND not gid in (".$this->db->invisibleGid."))";
		$params = array($online_rez);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$kajites = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kajites[] = $row;
		}
		return $kajites;		
	}
	
	//atgriež minimālo maksājuma summu pēc pieteikuma 
	function GetMaksMinSumma($m){
		$iemaksats = $m['iemaksasEUR'] - $m['izmaksasEUR'];		
		//dabū termiņu aktuālo
		require_once('m_grupa.php');
		$gr = new Grupa();
		$termini = $gr->getPaymentDeadlinesId($m['gid']);
		//echo "Termiņi<br>";
		//var_dump($termini);
		//echo "<br><br>";
		$sodiena = new DateTime();
		//var_dump($sodiena);
		//var_dump($sodiena<$termini['term1_dat']);
		//ja pirmais termiņš vēl nav nokavēts:
		$atlaide = $m['atlaidesEUR'];		
		$piemaksa = $m['sadardzinEUR'];	
		$cena = $m['summaEUR'] - $atlaide + $piemaksa;
		if (DEBUG){
			echo "<br>šodiena:";	
			var_dump($sodiena);
			echo "<br><br>";
			echo "<br>termiņi:";
			var_dump($termini);
			echo "<br><br>";
		}			
		if ($sodiena<$termini['term1_dat']){
			$min_summa = 0.00;
			//$min_summa = $termini['term1_summa'] - $iemaksats;
		}
		//ja otrais termiņš vēl nav nokavēts
		elseif ($sodiena>=$termini['term1_dat'] && $sodiena<$termini['term2_dat']){
			if ($cena > ($termini['term2_summa'])){				
				$min_summa = $termini['term1_summa'] - $iemaksats;
			}
			else{
				$min_summa = $cena - $iemaksats;
			}
		}
		elseif($sodiena>=$termini['term2_dat'] && $sodiena<$termini['term3_dat']){
			if ($cena > ($termini['term2_summa'] + $termini['term1_summa'])){				
				$min_summa = ($termini['term2_summa'] + $termini['term1_summa'])  - $iemaksats;
			}
			else{
				$min_summa = $cena - $iemaksats;
			}
		}
		else{
			//pēdējā termiņa summa
					
			//$cena = $m['summaEUR'] - $atlaide + $piemaksa;		
			
			
			
			$min_summa = $cena - $iemaksats;
		}
		if (DEBUG){
				echo "CENA: $cena<br>";
				echo "IEMAKSATS: $iemaksats <br>";
		}
		return $min_summa;
		
		
	}
	
	//Dalībnieka izņemšana no viesnīcas numura
	function DeleteVidDid($vid,$did,$online_rez_id){
		$pid = $this->GetOnlineRezDid($online_rez_id,$did);
		//vēstures saglabāšanai
		$old_vals = $this->GetId($pid);
		$old_saites_arr = $this->GetSaitesAssoc($pid);
		$this->db->UpdateWhere('piet_saite',array('vid'=>0),array('vid' => $vid, 'did'=>$did));
		
		$new_vals = $this->GetId($pid);
		$new_saites_arr = $this->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);		
	}
	
	//--- updeito pieteikuma lauku papildvieta
	function UpdatePietPapildv($pid) {
		
		$query = "SELECT * FROM piet_saite WHERE deleted=0 AND pid=? AND papildv=1";
		$params = array($pid);
		$result = $this->db->Query($query,$params);
		
		if (sqlsrv_has_rows($result)) {
			$values = array('papildvietas' => 1);
		
			//$q1 = "UPDATE [".Application("db_tb_pieteikums")."] SET papildvietas=1 WHERE id = ".$pid." AND deleted=0";			
		} else {
			$values = array('papildvietas' => 0);
		}
		$where_arr = array('id' => $pid,
							'deleted' =>0);
		$this->db->UpdateWhere('pieteikums',$values,$where_arr);
	}
	
	//Pārbauda, vai dalībniekam jau nav pietiekums šajā grupā
	//ATgriež 1, ja ir , 0 - ja nav
	function ExistsPieteikumsDidGid($pk1,$pk2,$gid,$rez_id = 0){
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetPk($pk1,$pk2);
		$did = $dalibnieks['ID'];
		$query = "SELECT p.* FROM pieteikums p 
				INNER JOIN piet_saite ps on ps.pid = p.id 
				WHERE ps.did =  ? 
				AND gid = ? 
				AND p.deleted = 0 
				AND ps.deleted = 0
				AND p.atcelts = 0 
				AND isnull(p.online_rez,1)<>?		
				order by p.id";
		$params = array($did,$gid,$rez_id);
	
		$result = $this->db->Query($query,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}	
		if(sqlsrv_has_rows($result) ) {	
			return 1;
		}
		else {
			return 0;
		}	
	}
	
	//atgriež dalībniekam maksājamo un iemaksāto summu par ceļojumu
	function GetMaksatPid($pid){
		$m = $this->GetId($pid);
		
		$gid = $m['gid'];
		require_once("m_grupa.php");
		$gr = new Grupa();
		$grupa = $gr->GetId($gid);
		$valuta = $grupa['valuta'];
		$atlaide = $m['atlaides'.$valuta];
		$piemaksa = $m['sadardzin'.$valuta];
		
		$cena = $m['summa'.$valuta];
//		- $atlaide + $piemaksa;
		$iemaksats = $m['iemaksas'.$valuta];
		 
		$izmaksats = $m['izmaksas'.$valuta];
		$jamaksa = $cena + $piemaksa - $atlaide - $iemaksats + $izmaksats;
		$iemaksas = array ('atlaide' => $m['atlaides'.$valuta],
							'piemaksa' => $m['sadardzin'.$valuta],
							'cena' => $cena,
							'iemaksats' =>  $iemaksats,
							'izmaksats' => $izmaksats,
							'jamaksa' => $jamaksa
							);
							
		return $iemaksas;
	}
	
	//atgriež  lietotājam visu maksājamo un iemaksāto summu par ceļojumu
	function GetMaksatOnlineRez($online_rez){
		$pieteikumi = $this->GetPietOnlineRez($online_rez);
		$atlaide_kopa = 0;
		$piemaksa_kopa = 0;
		$iemaksats_kopa = 0;
		$cena_kopa = 0;
		$jamaksa_kopa = 0;
		foreach ($pieteikumi as $piet){
			$m = $this->GetId($piet['id']);
			if (DEBUG){
				//echo "Pieteikums:<br>";
				//var_dump($m);
				//echo "<br><br>";
			}
			if ($m['summaLVL']!=0){
				
				$atlaide = $m['atlaidesLVL'];
				$atlaide_kopa +=$atlaide;
				$piemaksa = $m['sadardzinLVL'];
				$piemaksa_kopa += $piemaksa;
				$cena = $m['summaLVL'] - $atlaide + $piemaksa;
				$cena_kopa += $cena;
				$iemaksats = $m['iemaksasLVL'] - $m['izmaksasLVL'];
			
			}
			elseif ($m['summaUSD']!=0){ 
			$atlaide = $m['atlaidesEUR'];
			$atlaide_kopa +=$atlaide;
			$piemaksa = $m['sadardzinEUR'];
			$piemaksa_kopa += $piemaksa;
			$cena = $m['summaEUR'] - $atlaide + $piemaksa;
			$cena_kopa += $cena;
			$iemaksats = $m['iemaksasEUR'] - $m['izmaksasEUR'];
			}
			else{
				$atlaide = $m['atlaidesEUR'];
				$atlaide_kopa +=$atlaide;
				$piemaksa = $m['sadardzinEUR'];
				$piemaksa_kopa += $piemaksa;
				$cena = $m['summaEUR'] - $atlaide + $piemaksa;
				$cena_kopa += $cena;
				$iemaksats = $m['iemaksasEUR'] - $m['izmaksasEUR'];
			}
			$iemaksats_kopa += $iemaksats;
			$jamaksa = $cena - $iemaksats;
			$jamaksa_kopa += $jamaksa;
			
		}
		$iemaksas = array ('atlaide' => $atlaide_kopa,
								'piemaksa' => $piemaksa_kopa,
								'cena' => $cena_kopa,
								'iemaksats' =>  $iemaksats_kopa,
								'jamaksa' => $jamaksa_kopa
								);
		return $iemaksas;
	}
	
	//atgriež  lietotājam maksājamo un iemaksāto summu par dāvanu karti
	function GetMaksatId($id){
		
		$atlaide_kopa = 0;
		$piemaksa_kopa = 0;
		$iemaksats_kopa = 0;
		$cena_kopa = 0;
		$jamaksa_kopa = 0;
		//foreach ($pieteikumi as $piet){
			$m = $this->GetId($id);
			$atlaide = $m['atlaidesEUR'];
			$atlaide_kopa +=$atlaide;
			$piemaksa = $m['sadardzinEUR'];
			$piemaksa_kopa += $piemaksa;
			$cena = $m['summaEUR'] - $atlaide + $piemaksa;
			$cena_kopa += $cena;
			$iemaksats = $m['iemaksasEUR'] - $m['izmaksasEUR'];
			$iemaksats_kopa += $iemaksats;
			$jamaksa = $cena - $iemaksats;
			$jamaksa_kopa += $jamaksa;
			
		//}
		$iemaksas = array ('atlaide' => $atlaide_kopa,
								'piemaksa' => $piemaksa_kopa,
								'cena' => $cena_kopa,
								'iemaksats' =>  $iemaksats_kopa,
								'jamaksa' => $jamaksa_kopa
								);
		return $iemaksas;
	}
	
	//atgriež lietotāja iegādātās dāvanu kartes
	function getUserGiftCards(){
		require_once("m_grupa.php");
		$gr = new Grupa;
		$gid_array = $gr->getAllGiftCardGid();
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetId();
		$did = $dalibnieks['ID'];
		$query = "SELECT p.id as pid, p.*,g.mID FROM pieteikums p, grupa g 
					WHERE p.did=?
					AND p.gid IN (".implode(",",$gid_array).")
					AND p.deleted=0
					AND p.gid=g.ID
					AND p.online_rez IN (
						SELECT id FROM online_rez 
						WHERE no_delete=1
					)
					AND p.bilanceEUR>0
					ORDER BY p.datums ASC";
		$params = array($did);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
			echo "<br><br>";
		}
		
		$result = $this->db->Query($query,$params);	
		$gift_cards = array();
		require_once("m_grupa.php");
		require_once("m_marsruts.php");
		
		$marsruts = new Marsruts();
		$gr = new Grupa();
		
		require_once("i_functions.php");
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$mid = $row['mID'];			
			$celojums = $marsruts->GetId($mid);
			$celojuma_nos = $celojums['v'];
			$pid = $row['id'];
			$iemaksas = $this->GetMaksatId($pid);
			//pārbauda, vai līgums ir izveidots un akceptēts
			$pabeigta = ($iemaksas['iemaksats'] >0 ? 1 : 0);
			if ($pabeigta){
				$gift_card = array (
										'pid' => $row['pid'],
										'celojuma_nos' => $celojuma_nos,
										'cena' => CurrPrint($row['dk_summa']),
										'jamaksa' => CurrPrint($iemaksas['jamaksa']),
										'iemaksats' => CurrPrint($iemaksas['iemaksats']),
										'pabeigta'=>$pabeigta,
										'dk_serija' => $row['dk_serija'],
										'dk_numurs' => $row['dk_numurs'],
										'dk_kods' => $row['dk_kods'],
										'dk_kam' => $row['dk_kam'],
										'sakuma_datums' => $this->db->Date2Str($row['sakuma_datums'])
										);
				$gift_cards[] = $gift_card;
			}
			
		}
	
		return $gift_cards;
		
		
	}
	
	//saglabā pieteikuma saitē ceļojuma cenu - ja ir izvēlēta viesnīca, tad kopā ar viesnīcu
	function SaveCelojumaCena($pid,$data){
		$qry = "SELECT id FROM piet_saite WHERE pid=? AND deleted=0";
		$params = array($pid);
		//echo $qry."<br>";
		//var_dump($params);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		if(sqlsrv_has_rows($result) ) {
			
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$piet_saite_id = $row['id'];
			}
			$this->UpdateSaite($data, $piet_saite_id);
			
		}
		else{
			$piet_saite_id = $this->InsertSaite($data);
		}
		return $piet_saite_id;
		
	}

	//ATgriež nākamo insertējamo dāvanu kartes numuru (dk_numurs)
	function GetDkNum(){
		$qry = "SELECT MAX(dk_numurs) as num  FROM pieteikums";
		$result = $this->db->Query($qry);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		if(sqlsrv_has_rows($result) ) {
			
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				if ($row['num'] === NULL)
					return 1;
				else
					return $row['num']+1;
			}
		}
	}
	
	//atgriež papildvietu skaitu pēc pieteikums ID
	function GetPapildvId($id){
		$qry = "select sum(vietsk) as papildvietas
				from piet_saite 
				where (NOT DELETED = 1) and (papildv = 1) 
				and pid = ?";
		$params = array($pid);
		$res = $this->db->Query($qry,$params);
		if(sqlsrv_has_rows($res) ) {
			while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				return $row['papildvietas'];
			}
		}
		else return 0;
	}
	
	//atgriež dāvanu kartes pieteikumu pēc kartes nr. un koda
	function GetDk($dk_numurs,$dk_kods){
		$qry = "SELECT *
				FROM pieteikums 
				WHERE dk_numurs=?
				AND dk_kods=?
				AND deleted!=1";
		//echo "$qry<br>";
		$params = array($dk_numurs,$dk_kods);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		//$pieteikumi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
		//return $pieteikumi;		
	}
	
	//atgriež apmaksātās dāvanu kartes pēc meklēšanas parametriem
	function GetDkWhere($where_arr){
		$where = "";
		$where_str_arr = array();
		$params = array();
		if (isset($where_arr['datums_no'])){
			$where_str_arr[] = "(pieteikums.datums >= ?)";
			$params[] = $where_arr['datums_no'];
		}
		if (isset($where_arr['datums_lidz'])){
			$where_str_arr[] = "(pieteikums.datums <= ?)";
			$params[] = $where_arr['datums_lidz'];
		}
		if (isset($where_arr['dk_numurs'])){
			$where_str_arr[] = "(dk_numurs = ?)";
			$params[] =$where_arr['dk_numurs'];
		}
		if (isset($where_arr['dk_kods'])){
			$where_str_arr[] = "(dk_kods = ?)";
			$params[] = $where_arr['dk_kods'];
		}
		if (isset($where_arr['requested_only']) && (int)$where_arr['requested_only'] === 1){
			$where_str_arr[] = "(ISNULL(orez.invoice_status, '') = 'requested')";
		}
		$where = implode(" AND ", $where_str_arr);
		$qry = "SELECT pieteikums.*,orez.no_delete,orez.dk_attelota,orez.invoice_status
				FROM pieteikums 
				LEFT JOIN online_rez orez on pieteikums.online_rez=orez.id
				WHERE $where
				AND pieteikums.deleted!=1
				AND dk_numurs IS NOT NULL
				AND dk_kods IS NOT NULL
				AND online_rez IN (
					SELECT id FROM online_rez
					WHERE no_delete=1
				)
				ORDER BY pieteikums.datums DESC";
		//echo "$qry<br>";
		
		//var_dump($params);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$pieteikumi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$pieteikumi[] =  $row;
		}
		return $pieteikumi;
		
	}
	
	
	//priekš kajīšu ceļojumiem
	function AddPakalpojumsId($id,$values){
		//atrod piet_saiti, kam vēl nav saglabāts pakalpojums, bet ir tikai kajīte/viesnica
		$qry = "SELECT * FROM piet_saite WHERE deleted=0 AND isnull(vietas_veids,0)=0 AND pid=?";
		$params = array($id);
		$result = $this->db->Query($qry,$params);
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$piet_saite_id =  $row['id'];
			$this->UpdateSaite($values,$piet_saite_id);
		}
		else{
			$this->InsertSaite($values);
		}
	}
	
	function NullesPakalpId($pid,$vv){
		/*$old_vals = $this->GetId($pid);
		$old_saites_arr = $this->GetSaitesAssoc($pid);*/
		
		$qry = "UPDATE piet_saite SET vietas_veids=? 
				WHERE isnull(vietas_veids,0)=0 
				AND deleted=0 AND pid=?";		
		$params = array($vv,$pid);
		$res = $this->db->Query($qry,$params);
	
	}
	
	//atgriež rezervēto kajīti, ja ir
	function GetKajiteId($id){
		$qry = "SELECT kid, kvietas_veids,kvietas_cenaEUR,kv.nosaukums
				FROM piet_saite ps 
				LEFT JOIN kajite k ON k.id=ps.kid 
				LEFT JOIN kajites_veidi kv ON k.veids=kv.id
				WHERE ps.deleted!=1 
				AND kid IS NOT NULL AND kid>0 AND kvietas_veids<>0
				
				";
		
		$qry .= " AND pid = ? ORDER BY kvietas_cenaEUR DESC";
		
		$params = array($id);
		
		/*echo $qry."<br>";
		var_dump($params);
		echo "<br><br>";*/
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}	
		$kajite = array();				
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//echo "Kajīte<br>";
			//print_r($row);
			//echo "<br><br>";
			$kajite[] = $row;
		}
		return $kajite;
		
	}
	
	//atgriež visus pieteikumus ar konrkēto vietu veidu
	function GetByVietasVeids($vietas_veids,$kartot_pec){
		$qry = "SELECT p.*,d.*,p.datums as piet_datums,p.id as pid ";
		
		if (is_array($vietas_veids)) {
			foreach ($vietas_veids as $vv) {
				$qry .=  ",(select sum(vietsk) from piet_saite where vietas_veids = $vv and did = d.ID and deleted = 0) as vv" . $vv;
			}
		} else {
			$qry .=  ",(select sum(vietsk) from piet_saite where vietas_veids = $vietas_veids and did = d.ID and deleted = 0) as vv" . $vietas_veids;
		}
		
		$qry .= " FROM pieteikums p
				LEFT JOIN dalibn d on p.did=d.id
				where p.deleted=0 ";
			$qry .= " and p.id in (select pid from piet_saite where vietas_veids IN (".implode(",",$vietas_veids).") and deleted = 0 )";
			
		if ($kartot_pec == "datums"){
			$order_by = " ORDER BY datums ASC";
		}
		else if($kartot_pec == "vards"){
			$order_by = " ORDER BY dbo.fn_str_to_num(uzvards) ASC, dbo.fn_str_to_num(vards) ASC";
		}
		$qry .= $order_by;
		
		if (!is_array($vietas_veids)) $params = array($vietas_veids);
		
		$ret = $this->db->QueryArray($qry,$params);		
		
		return $ret;
	}
	
	//---------------------------------------
	// 19.12.2019 RT
	// pārbauda, vai dotajam pieteikums eksistē kāds orderis (vai ir iemaksas)
	//------------------------------------------
	function HasPayment($id){

		$qry = "SELECT SUM(summa) as summa 
				from orderis where deleted=0 
				and pid=?";
		$params = array($id);
		
		$result = $this->db->Query($qry,$params);
		if ( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {	
			if ($row['summa'] > 0) {
				return true;
			}
		}
		return false;
	}
	
	//---------------------------------------
	// 19.12.2019 RT
	// atgriež online_rez pēc pieteikuma ID
	//------------------------------------------
	function OnlineRez($id){
		require_once("m_online_rez_utf.php");
		$online_rez = new OnlineRez();
		$qry = "SELECT online_rez
				from pieteikums where id=?";
		$params = array($id);
		$data = array();
		$result = $this->db->Query($qry,$params);
		if ( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {			
			$data = $online_rez->getId($row['online_rez']);
		}
		return $data;
	}
}
?>