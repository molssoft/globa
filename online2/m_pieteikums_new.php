<?
class Pieteikums {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
	
		$this->db = new Db;
	
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
	//atgrieþ asociatîvo masîvu ar pieteikum saitçm, kur key=saites_id
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
		//$old_vals = $this->GetId($data['pid']);
		//$old_saites_arr = $this->GetSaitesAssoc($data['pid']);
		
		//echo "ins";
		//piet_saite : pid, did, vietsk = 1, deleted = 0, persona = 1
		if (!isset($data['vietsk']))
			$data['vietsk'] = 1;
		if (!isset($data['deleted']))
			$data['deleted'] = 0;
		if (!isset($data['persona']))
			$data['persona'] = 0;	
		if (!isset($data['papildv']))
			$data['papildv'] = 0;		
		
		$piet_saite_id = $this->db->Insert('piet_saite',$data,$data);
		
		//atjauno pieteikuma summu
		//$pid = $data['pid'];
		//$this->Calculate($pid);
		//$query = "EXEC pieteikums_calculate_jauns @pid = ?";
		//$params = array($pid);
		//$this->db->Query($query,$params);
		
		/*$new_vals = $this->GetId($data['pid']);
		$new_saites_arr = $this->GetSaitesAssoc($data['pid']);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$data['pid'],$old_vals,$new_vals);*/
		return $piet_saite_id;
	
	}
	
	function Calculate1($pid) {
		$query = "EXEC pieteikums_calculate_jauns @pid = ?";
		$params = array($pid);
		//echo $query."<br>";
		//var_dump($params);
		//echo "<br><br>";
		$this->db->Query($query,$params);
	}
	function Calculate($pid) {
		$query = "EXEC pieteikums_calculate $pid";
		//$params = array($pid);
		//echo $query."<br>";
		//var_dump($params);
		//	echo "<br><br>";
		//echo $query;
		
		//$res = $this->db->Query($query);
		
		require_once("i_pieteikums_calculate.php");
		PieteikumsCalculate($pid);
		
		
	}
	
	function UpdateSaite($data,$id){
		$pid = $data['pid'];
		
		/*$old_vals = $this->GetId($pid);
		$old_saites_arr = $this->GetSaitesAssoc($pid);*/
		//echo "upd";	
		$result = $this->db->Update('piet_saite',$data,$id);
		//atjauno pieteikuma summu
		//
		//$pid = $data['pid'];
		//$this->Calculate($pid);
		//$query = "EXEC pieteikums_calculate @pid = ?";
		//$params = array($pid);
		//$this->db->Query($query,$params);
		
		/*$new_vals = $this->GetId($pid);
		$new_saites_arr = $this->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);*/
		
		return $result;
	}
	
	function DeleteSaite($pid){
		
	/*	$old_vals = $this->GetId($pid);
		$old_saites_arr = $this->GetSaitesAssoc($pid);*/
		//echo "DEl";
		//vçstures saglabâðanai
		$old_vals = $this->GetId($pid);
		$where = " pid=? AND (vid=0 OR vid IS NULL) AND (kid=0 OR kid IS NULL) AND deleted=0";
		$qry = "SELECT * FROM piet_saite WHERE $where";
		$params = array($pid);
		$result = $this->db->Query($qry,$params);
		$old_saites_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			//echo "<br><br>";
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
					 
						$history_arr[] = $this->db->GetFieldTitle($item,"piet_saite") . ": " .$this->db->GetValStr($item,$old_saites_vals[$item]);
						//old_saites_vals0.add item,old_vals(item)
						//new_saites_vals0.add item,""
					}
				 }
				 if (count($history_arr)){
					
					$history .= "** Dzçsts pakalpojums :: ".implode(", ",$history_arr)." => <br>";
					
				}
			}
			 if (!empty($history)){
					
				$new_vals = $this->GetId($pid);
				$this->db->UpdateActionDetails($old_vals,$new_vals,"pieteikums",$pid,$history);
			}
		}
		
	
		/*$new_vals = $this->GetId($pid);
		$new_saites_arr = $this->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);*/
		//$query = "EXEC pieteikums_calculate @pid = ?";
		//$params = array($pid);
		//$this->db->Query($query,$params);
		//atjauno pieteikuma summu
		//$this->Calculate($pid);
	
	}
	
	//atgrieþ pieteiktos pakalpojumus par konkrçto pieteikumu VAI rezervaciju
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
				//print_r($row);
				//echo "<--<br>";
				$pieteiktie_pak[]= $row;
				
			}	
		}
		if ($vietu_veidi_arr){
			foreach ($vietu_veidi_arr as $vietu_veids){
				//inicializçjam atgrieþamo masîvu ar vietas veidu un skaitu
				$piet_pak_arr[$vietu_veids['id']] = 0;
			//	echo "<br>PAKALPOJUMU VEIDI:<br>";
				//var_dump($vietu_veids);
				//echo "<br><br>";
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
	
	//atgrieþ rezervçto viesnîcas numuriòu, ja tâds ir
	function GetViesnica($pid){
		$qry = "SELECT vid FROM piet_saite WHERE deleted!=1 
				AND vid IS NOT NULL AND vid>0";
		
		$qry .= " AND pid = ?";
		$params = array($pid);
		
		/*echo $qry."<br>";
		var_dump($params);
		echo "<br><br>";*/
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}	
						
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['vid'];
		}
		
	}
	
	//atgrieþ pieteikuma ID pçc rezervâcijas un dalîbnieka ID
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
	
	//atgrieþ dalîbieku ID pçc viesnîcas ID
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
	
	//atgrieþ iemaksas par konkrçto ceïojumu
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
	
	//--atgrieþ kopçjo pakalpojumu summu--//
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
	
	//--------------------atgrieþ visus pieteikumus pçc online rez ID------//
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
	
	//atgrieþ dalîbnieku pçc pieteikuma ID
	function GetDalibnPid($pid){
		$qry = "SELECT d.*  
				FROM dalibn d, pieteikums p
				WHERE p.id=?
				AND p.did=d.ID";
		//echo "$qry<br>";
		$params = array($pid);
		//var_dump($params);
	//	echo "<br><br>";
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			//echo "<br><br>";
			return $row;
		}
	
	}
	
	//atgrieþi papildvietu cenu pçc pieteikuma ID
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
	
	//atgrieþ kajîtes pçc rezervâcijas id
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
	
	//atgrieþ minimâlo maksâjuma summu pçc pieteikuma 
	function GetMaksMinSumma($m){
		$iemaksats = $m['iemaksasEUR'] - $m['izmaksasEUR'];		
		//dabû termiòu aktuâlo
		require_once('m_grupa.php');
		$gr = new Grupa();
		$termini = $gr->getPaymentDeadlinesId($m['gid']);
		//echo "Termiòi<br>";
		//var_dump($termini);
		//echo "<br><br>";
		$sodiena = new DateTime();
		//var_dump($sodiena);
		//var_dump($sodiena<$termini['term1_dat']);
		//ja pirmais termiòð vçl nav nokavçts:
		$atlaide = $m['atlaidesEUR'];		
		$piemaksa = $m['sadardzinEUR'];	
		$cena = $m['summaEUR'] - $atlaide + $piemaksa;
		if (DEBUG){
			echo "<br>ðodiena:";	
			var_dump($sodiena);
			echo "<br><br>";
			echo "<br>termiòi:";
			var_dump($termini);
			echo "<br><br>";
		}			
		if ($sodiena<$termini['term1_dat']){
			$min_summa = 0.01;
			//$min_summa = $termini['term1_summa'] - $iemaksats;
		}
		//ja otrais termiòð vçl nav nokavçts
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
			//pçdçjâ termiòa summa
					
			//$cena = $m['summaEUR'] - $atlaide + $piemaksa;		
			
			
			
			$min_summa = $cena - $iemaksats;
		}
		if (DEBUG){
				echo "CENA: $cena<br>";
				echo "IEMAKSATS: $iemaksats <br>";
		}
		return $min_summa;
		
		
	}
	
	//Dalîbnieka izòemðana no viesnîcas numura
	function DeleteVidDid($vid,$did,$online_rez_id){
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		//vçstures saglabâðanai
		$old_vals = $pieteikums->GetId($pid);
		$old_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		$this->db->UpdateWhere('piet_saite',array('vid'=>0),array('vid' => $vid, 'did'=>$did));
		
		$new_vals = $pieteikums->GetId($pid);
		$new_saites_arr = $pieteikums->GetSaitesAssoc($pid);
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
	
	//Pârbauda, vai dalîbniekam jau nav pietiekums ðajâ grupâ
	//ATgrieþ 1, ja ir , 0 - ja nav
	function ExistsPieteikumsDidGid($pk1,$pk2,$gid,$rez_id = 0){
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetPk($pk1,$pk2);
		$did = $dalibnieks['ID'];
		$query = "SELECT p.* FROM pieteikums p 
				inner join piet_saite ps on ps.pid = p.id 
				WHERE ps.did =  ? AND gid = ? 
				and p.deleted = 0 
				/*and p.tmp = 0 */
				/*and (p.step = '4' or p.step='a')*/
				and p.atcelts = 0 
				AND isnull(p.online_rez,1)<>?		
				order by p.id";
		$params = array($did,$gid,$rez_id);
		if (DEBUG){
			echo "$query<br>";
			var_dump($params);
			echo "<br><br>";
		}
	
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
	
	//atgrieþ dalîbniekam maksâjamo un iemaksâto summu par ceïojumu
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
	
	//atgrieþ  lietotâjam visu maksâjamo un iemaksâto summu par ceïojumu
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
	
	//atgrieþ  lietotâjam maksâjamo un iemaksâto summu pardâvanu karti
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
	
	//atgrieþ lietotâja iegâdâtâs dâvanu kartes
	function getUserGiftCards(){
		require_once("m_grupa.php");
		$gr = new Grupa;
		$gid_array = $gr->getAllGiftCardGid();
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$dalibnieks = $dalibn->GetId();
		$did = $dalibnieks['ID'];
		$query = "SELECT p.*,g.mID FROM pieteikums p, grupa g 
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
		//require_once("m_pieteikums.php");
		//$pieteikums = new Pieteikums();
		$marsruts = new Marsruts();
		$gr = new Grupa();
		
		require_once("i_functions.php");
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$mid = $row['mID'];			
			$celojums = $marsruts->GetId($mid);
			//echo "<br><br>";
			//var_dump($celojums);			
			$celojuma_nos = $celojums['v'];
			$pid = $row['id'];
			$iemaksas = $this->GetMaksatId($pid);
			//pârbauda, vai lîgums ir izveidots un akceptçts
			//require_once('m_ligumi.php');
			//$ligumi  = new Ligumi();
			//$apstiprinats = (int)$ligumi->GetAcceptedOnlineRez($online_rez_id);
			//$var_labot = ($apstiprinats ? 0 : 1);
			$pabeigta = ($iemaksas['iemaksats'] >0 ? 1 : 0);
			if ($pabeigta){
				$gift_card = array (
										'celojuma_nos' => $celojuma_nos,
										/*'cena' => CurrPrint($iemaksas['cena'] - $iemaksas['atlaide'] + $iemaksas['piemaksa']),*/
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
	
	//saglabâ pieteikuma saitç ceïojuma cenu - ja ir izvçlçta viesnîca, tad kopâ ar viesnîcu
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

	//ATgrieþ nâkamop insertçjamo dâvanu kartes numuru (dk_numurs)
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
	
	//atgrieþ papildvietu skaitu pçc pieteikums ID
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
	
	//atgrieþ dâvanu kartes pieteikumu pçc kartes nr. un koda
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
	
	//atgrieþ apmaksâtâs dâvanu kartes pçc meklçðanas parametriem
	function GetDkWhere($where_arr){
		$where = "";
		$where_str_arr = array();
		if (isset($where_arr['datums_no'])){
			$where_str_arr[] = "(datums >= ?)";
			$params[] = $where_arr['datums_no'];
		}
		if (isset($where_arr['datums_lidz'])){
			$where_str_arr[] = "(datums <= ?)";
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
		$where = implode(" AND ", $where_str_arr);
		$qry = "SELECT *
				FROM pieteikums 
				WHERE $where
				AND deleted!=1
				AND dk_numurs IS NOT NULL
				AND dk_kods IS NOT NULL
				AND online_rez IN (
					SELECT id FROM online_rez
					WHERE no_delete=1
				)
				ORDER BY datums ASC";
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
	
	
	//priekð kajîðu ceïojumiem
	function AddPakalpojumsId($id,$values){
		//atrod piet_saiti, kam vçl nav saglabâts pakalpojums, bet ir tikai kajîte/viesnica
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
		
		/*$new_vals = $this->GetId($pid);
		$new_saites_arr = $this->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);		*/
		
	}
	
	//atgrieþ rezervçto kajîti, ja ir
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
			//echo "Kajîte<br>";
			//print_r($row);
			//echo "<br><br>";
			$kajite[] = $row;
		}
		return $kajite;
		
	}

}
?>