<?
class VietuVeidi {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db;
	
	}
	
	public function create($rez,$did,$vietas_veids){
		require_once("m_online_rez.php");
		require_once("m_grupa.php");
		require_once("m_pieteikums.php");
				
		if ($rez != $_SESSION['reservation']['online_rez_id'])
			die();
		
		$o = new OnlineRez();
		$gid = $o->GetGidId($rez);

		$p = new Pieteikums();
		$pid = $p->GetOnlineRezDid($rez,$did);
		
		$p->InsertSaite(["pid"=>$pid,"did"=>$did,"vietas_veids"=>$vietas_veids]);
		$p->Calculate($pid);
	}
	
	// dabon personai pieejamos pakalpojumus
	// ņemot vērā personas vecumu, izvēlēto viesnicu un pakalpojumu limitus
	public function get_avaialable_online($rez,$did,$age){
		
		require_once("m_online_rez.php");
		require_once("m_grupa.php");
		require_once("m_dalibn.php");
		$online_rez = new OnlineRez();
		$grupa = new Grupa();
		$dalibn = new Dalibn();
		
		$pers_count = $online_rez->GetTravellerCount($rez);

		// atrodam viesnicai piesaisīto cenu
		// jā tā nav 0 tad tā ir vienīgā ceļojuma cena ko piedāvājam
		$sql = "select 
			isnull(vietu_veidi_id,0) as viesnicas_cena
			,vv.nosaukums as vtips
			,p.gid as gid
		from online_rez rez
		join pieteikums p on p.online_rez = rez.id
		join piet_saite ps on p.id = ps.pid
		join grupa g on g.id = p.gid
		join dalibn d on ps.did = d.id
		left join viesnicas v on ps.vid = v.id
		left join viesnicas_veidi vv on v.veids = vv.id
		where 
			rez.id = $rez
			and ps.deleted = 0
			and ps.did = $did";
			
		$result = $this->db->Query($sql,array());
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		$viesnicas_cena = $row['viesnicas_cena'];
		$vtips = $row['vtips'];
		$gid = $row['gid'];
		
		// atlasam pilnu sarakstu ar pakalpojumiem
		$sql = "select vietu_veidi.*, isnull(vv.id,0) as vvid
			from vietu_veidi 
			left join viesnicas_veidi vv on vv.vietu_veidi_id = vietu_veidi.id
			where 
				vietu_veidi.gid = $gid
				and no_online = 0
				and isnull(max_vecums,120)>=$age
				and isnull(min_vecums,0)<=$age
				and 
				(
					tips in ('V1','EX','ED','P','Z1','CH1','VV','C')
					-- kajīšu cena 
					OR (tips = 'X' and cenaEUR>0)
				)
			";
		
		if (!$dalibn->IsClient($did))
			$sql .= " and isnull(klienta_cena,0) = 0 ";
		
		$result = $this->db->Query($sql,array());
		
		
		$pakalpojumi = array();
		while( $veids = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			// vai pakalpojums ir ieejams (pārbauda limitu)
			$pieejams = true;
			if (!empty($veids['limits'])){
				$aiznemts = $this->GetAiznemtsId($veids['id'],$online_rez_id);
				if ($veids['limits'] <= $aiznemts)
					$pieejams = false;
			} else {
				$aiznemts = 0;
			}
			
			// vienai personai nepiedāvā visas istabas pakalpojumus
			if ($pers_count==1 && $vtips != 'SINGLE')
				if ($veids['visa_istaba'])
					$pieejams = false;
			
			// pierakstam brīdinājumu par atlikušajām vietām
			if (!empty($veids['limits'])){
				$brivas_v = $veids['limits'] - $aiznemts;
				if ($brivas_v == 1)
					$veids['nosaukums'] .= '<font color="red"> (pieejama 1 vieta!)</font>';
				else
					$veids['nosaukums'] .= '<font color="red"> (pieejamas '.$brivas_v.' vietas!)</font>';
			}			
			
			//ja grupā vairs nav brīvu vietu autobusā, nepiedāvā papildvietas
			if ($veids['papildv'] ){
				$brivas_v_autobusa = $grupa->GetVietasAutobuss($gid,$rez);
				
				if ($brivas_v_autobusa <=0 ){
					$pieejams = false;
				}
				elseif ($brivas_v_autobusa < $pers_count){
					//pieliek brīdinājumu, ka visiem var nepietikt
					if ($brivas_v_autobusa == 1)
						$veids['nosaukums'] .= '<font color="red"> (pieejama 1 vieta!)</font>';										
					else
						$veids['nosaukums'] .= '<font color="red"> (pieejamas '.$brivas_v_autobusa .' vietas!)</font>';
				}
			}
			
			if ($pieejams){
				$veids['aiznemts'] = $aiznemts;
				// sadalam pakalpojumus dažādos masīvos pēc tipa
				if ($veids['tips'] == 'C' || $veids['tips'] == 'CH1'){
					$pakalpojumi['cena'][] = $veids;
				}
				if ($veids['tips'] == 'P'){
					$pakalpojumi['papildvieta'][] = $veids;
				}
				if ($veids['tips'] == 'EX'){
					$pakalpojumi['ekskursija'][] = $veids;
				}
				if ($veids['tips'] == 'ED'){
					$pakalpojumi['edinasana'][] = $veids;
				}
				//piemaksa par vienvietīgu numuru
				if ($veids['tips'] == 'V1'){
					$pakalpojumi['v1'][] = $veids;
				}
				//Cits
				if ($veids['tips'] == 'X' && $veids['cenaEUR'] > 0){ //lai nerādītu kajisu papildus paklpojumu 'nav'
					$pakalpojumi['cits'][] = $veids;
				}
				//Pēdējās dienas cena
				if ($veids['tips'] == 'Z1'){
					$pakalpojumi['pd_cena'][] = $veids;
				}
			}
		}
		
		//Sakārtojam pakalpojumu alfabētiski			
		foreach ($pakalpojumi as $key=>$pakalp){
			usort($pakalpojumi[$key], function($a, $b) {
				return strcmp($a["nosaukums"], $b["nosaukums"]);
			});
		}
		return $pakalpojumi;
	}
	
	// pakalpojumi kuri pieejami pēc rezervācijas pabeigšanas
	// var piepirkt klāt
	// tikai konkrēti tipi un izņemti tie kuri jau ir nopirkti
	public function get_avaialable_buy($rez,$did,$age){
		
		// pārbaudam vai grupa nav bloķēta
		// un vai tā pārdodas online
		
		require_once("m_online_rez.php");
		require_once("m_grupa.php");
		$online_rez = new OnlineRez();
		$gid = $online_rez->GetGidId($rez);
		$grupa = new Grupa();
		$g = $grupa->GetId($gid);
		
		if ($g['blocked']==1)
			return Array();
		
		if ($g['internets']!=1)
			return Array();
		
		$today = date('Y-m-d');

		
		if ($g['sakuma_dat']->date >= $today)
			return Array();
		
		$buy = $this->get_avaialable_online($rez,$did,$age);
		
		// grupas kuras vajag
		$keysToKeep = ['ekskursija', 'edinasana'];

		// atstājam tikai grupas kuras mums vajag
		$result = array_intersect_key($buy, array_flip($keysToKeep));
		
		// saliekam visus pakalpojumus vienā sarakstā
		$group1 = isset($result['ekskursija']) ? $result['ekskursija'] : [];
		$group2 = isset($result['edinasana']) ? $result['edinasana'] : [];
		
		$onelist = array_merge($group1, $group2);

		// pārbaudam vai pakalpojums jau nav nopirkts
		$notexists = array();
		foreach ($onelist as $item) {
			$query = "select * from piet_saite where deleted = 0 and did = $did and vietas_veids = ".$item['id'];
			$params = array();
			$result = $this->db->QueryArray($query,$params);
			
			if (count($result) == 0)
				$notexists[] = $item;
		}

		return $notexists;
	}
		

	
	public function ensure($gid,$veids,$pilns_nosaukums,$vietas){
		
		$id = $this->get_by_nosaukums($gid,$veids);
		if ($id==0) {
			$data = array();
			$data['gid'] = $gid;
			$data['nosaukums'] = $veids;
			$data['pilns_nosaukums'] = $pilns_nosaukums;
			$data['vietas'] = $vietas;
			$data['pieejams_online'] = 1;
			
			$this->db->insert('viesnicas_veidi',$data);
			$id = $this->get_by_nosaukums($gid,$veids);
		}
		return $id;
	}
	
	public function get_by_nosaukums($gid,$veids){
		$query = "select * from viesnicas_veidi where gid = $gid and nosaukums = '$veids'";
		$params = array();
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		

		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		
		if ($row)
		{
			if (count($row)==0)
				return 0;
			else	
				return($row['id']);
		}
		else 
			return 0;
		
	}
	
	function GetAvailableOld($gid, $did = NULL){
		/*
		C - ceļojuma cena
		P - checkbox
		Ex - ekskursija (checkbox)
		x - cits
		ed - ēdināšana (checkbox)
		%_NA - nerādīt
		G - nerāda online sistēmā
		V1 - piemaksa par vienvietīgu numuru, rāda tikai tad ja izvēlēta vienvietīga viesnica
		*/
		$show_tips = array('C'=>'select','P'=>'checkbox','Ex'=>'checkbox','ed'=>'checkbox','VV'=>'checkbox');
		$show_tips_list = implode(",", $show_tips);
		$qry = "SELECT * FROM vietu_veidi WHERE gid=? /*AND tips IN (?)*/";

		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$vietu_veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$vietu_veidi[] = $row;
		}	
		return $vietu_veidi;
	}
	
	function GetId($id){
		$query = "SELECT * FROM vietu_veidi WHERE id=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}		
	}
	
	function GetAvailable($gid,$online_rez_id=0){
		/*
		C - ceļojuma cena
		P - checkbox
		Ex - ekskursija (checkbox)
		x - cits
		ed - ēdināšana (checkbox)
		%_NA - nerādīt
		G - nerāda online sistēmā
		V1 - piemaksa par vienvietīgu numuru, rāda tikai tad ja izvēlēta vienvietīga viesnica
		*/
		$show_tips = array('C'=>'select','P'=>'checkbox','Ex'=>'checkbox','ed'=>'checkbox');
		$show_tips_list = implode(",", $show_tips);
		$qry = "SELECT *,isnull(limits,'') as lim FROM vietu_veidi WHERE no_online = 0 and gid=? /*AND tips IN (?)*/";

		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		$vietu_veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {

			//ja vietu veidam ir uzlikts limits, pārbauda, vai tas nav sasniegts jau
			$pieejams = true;
			if (!empty($row['lim'])){
				$aiznemts = $this->GetAiznemtsId($row['id'],$online_rez_id);
				if ($row['lim'] <= $aiznemts)
					$pieejams = false;
			}
			
			if ($pieejams){
				$vv = $row;
				if (isset($aiznemts)){
					$vv['aiznemts'] = $aiznemts;
				}
				$vietu_veidi[] = $vv;
			}
			
		}	
		return $vietu_veidi;
	}

	//atgriež aizņemto vietu skaitu pēc vietas veida
	function GetAiznemtsId($id,$online_rez_id=0){
		if (!empty($online_rez_id)){
			$qry = "select count(id) as skaits from piet_saite where deleted = 0  and pid in (select id from pieteikums where deleted = 0 and id = piet_saite.pid) and vietas_veids=? AND pid NOT IN (SELECT id FROM pieteikums where deleted=0 AND online_rez=?)";
			$params = array($id,$online_rez_id);
		}
		else{
			$qry = "select count(id) as skaits from piet_saite where deleted = 0  and pid in (select id from pieteikums where deleted = 0 and id = piet_saite.pid) and vietas_veids=?";
			$params = array($id);
		}
		
		
		$res = $this->db->Query($qry,$params);
		if( $rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
			$aiznemts = $rowAiznemts['skaits'];
			
		}
		else $aiznemts = 0;
		return $aiznemts;
	}
}
?>