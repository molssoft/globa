<?
class OnlineRez {
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
	
/**
 * Returns items for conversion/purchase DataLayer (GA4/Meta).
 * One item per unique trip: item_id, item_name, price (unit), quantity (number of participants).
 * JS expects: item_id, item_name, price (number), quantity (number).
 *
 * @param int $online_rez_id
 * @return array Array of items: [ ['item_id' => ..., 'item_name' => ..., 'price' => float, 'quantity' => int], ... ]
 */
	function GetPurchaseItemsForDatalayer($online_rez_id) {
		$qry = "SELECT g.id AS item_id, m.v AS item_name,
				SUM(p.iemaksasEUR) AS total_eur,
				COUNT(*) AS qty
			FROM pieteikums p
			JOIN grupa g ON p.gid = g.id
			JOIN marsruts m ON m.id = g.[mid]
			WHERE p.online_rez = ? AND p.deleted = 0
			GROUP BY g.id, m.v";
		$params = array($online_rez_id);
		$result = $this->db->Query($qry, $params);
		if ($result === false) {
			return array();
		}
		$items = array();
		while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
			$total = isset($row['total_eur']) ? (float) $row['total_eur'] : 0;
			$qty = isset($row['qty']) ? (int) $row['qty'] : 0;
			$unitPrice = $qty > 0 ? $total / $qty : 0;
			$items[] = array(
				'item_id'   => (string) $row['item_id'],
				'item_name' => (string) _utf($row['item_name']),
				'price'     => round($unitPrice, 2),
				'quantity'  => $qty
			);
		}
		return $items;
	}	
	
	function GetId($id){
		$query = "SELECT * FROM online_rez WHERE ID=? AND deleted=0";
		//echo $query;
		$params = array($id);
		//echo"$id";
		
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die(print_r( sqlsrv_errors(), true));
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}		
	}
	
	function Insert($profile_id,$deriga_min = 30){
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));
		$formated_date = $date->format('Y-m-d H:i:s');
		//if (isset($_SESSION['test']) ){
			$deriga_lidz = $date->add(new DateInterval('PT' . $deriga_min. 'M'));
			$deriga_lidz = $deriga_lidz->format('Y-m-d H:i:s');
			//echo "DErīga līdz: $deriga_lidz <br>";
			$values = array('profile_id'=> $profile_id,
						'datums' => $formated_date,
						'deleted' => 0,
						'closed' => 0,
						'deriga_lidz' => $deriga_lidz
						);
				$online_rez_id = $this->db->Insert('online_rez',$values,array('profile_id'=>$profile_id));
				return $online_rez_id;
		//}

	}
	
	function Delete($id){
		$qry = "SELECT * FROM online_rez WHERE id=? AND no_delete=0";
		$params = array($id);
		$res = $this->db->Query($qry,$params);
		if (sqlsrv_has_rows($res)) {
			//jāizsūta e-pasts par neapmaksātu reervāciju, ja tika līdz bankai
			$row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
			if (DEBUG){
				//var_dump($row);
				//die();
			}
			if ($row['tika_lidz_bankai']==1){
				$epasts_dzesta_neapmaksata = 1;
			}
			else{
				$epasts_dzesta_neapmaksata = 0;
			}
			$qry = "UPDATE online_rez SET deleted=1,epasts_dzesta_neapmaksata=$epasts_dzesta_neapmaksata WHERE id=? AND no_delete=0";
		//	echo "$qry <br>";
			
			$this->db->Query($qry,$params);
			
			$qry = "UPDATE pieteikums SET deleted=1 WHERE online_rez=?";
			$this->db->Query($qry,$params);
			
			$qry = "UPDATE piet_saite SET deleted=1 WHERE pid IN (SELECT ID FROM pieteikums WHERE online_rez=?)";
			$this->db->Query($qry,$params);	
		}		
	}
	

	function GetDalibnList($online_rez_id,$profile_id=null,$full = false,$test = false){
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		$qry = "SELECT did 
				FROM pieteikums
				WHERE online_rez=?
				AND gid <> '".$this->db->invisibleGid."' AND did<>0";
		$params = array($online_rez_id);
		if (isset($profile_id)){
			$qry .= "AND profile_id=? ";
			$params[]=$profile_id;			
		}
		$qry .= "ORDER BY did ASC";
		if ($test){
			echo $qry."<br>";
			var_dump($params);
		}
		
		$result = $this->db->Query($qry,$params);
			
		$dalibnieki = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			if ($full){
				$dalibnieki[] = $dalibn->GetId($row['did']);
			}
			else{
				$dalibnieki[] = $row['did'];
			}
		}
		return $dalibnieki;
	}
	
	
	//atgriež grupas ir pēc online rez id
	function GetGidId($id){
		$qry = "SELECT gid FROM pieteikums WHERE online_rez = ?
				AND gid not in (".$this->db->invisibleGid.")
				GROUP BY gid";
		$params = array($id);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['gid'];
		}
				
	}
	
	//atgriež grupas ir pēc online rez id
	function GetCountry($id){
		$qry = "select top 1 valsts from marsruts m
			join grupa g on m.id = g.[mid]
			join pieteikums p on p.gid = g.id
			where p.online_rez = $id
			";
			
		$params = array($id);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['valsts'];
		}
				
	}

	//atgriež iepriekšējās grupas ir pēc online rez id (atceltām grupām)
	function GetOldGidId($id){
		$qry = "SELECT old_gid FROM pieteikums WHERE online_rez = ?
				AND gid not in (".$this->db->invisibleGid.")
				GROUP BY old_gid";
		$params = array($id);
		if (DEBUG){
			//echo $qry."<br>";
			//var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['old_gid'];
		}
				
	}
	
	//apstiprina online rezervāciju
	function Accept($id){
		$this->db->Update("online_rez",array('apstiprinata' => 1),$id);
	}
	
	//pievieno komentāru
	function UpdateComment($id, $comment){
		$this->db->Update("online_rez",array('komentars' => $comment),$id);
	}

	//atjaunina rēķina statusu (invoice_status laukā)
	function UpdateInvoiceStatus($id, $status){
		$this->db->Update("online_rez", array('invoice_status' => $status), $id);
	}
	
	//atgriež bērna id, ja rezervācijā ir arī bērns
	function WithChildren($id){
		$dalibn_id_arr = $this->GetDalibnList($id,$_SESSION['profili_id']);
		$children = array();
		require_once("m_dalibn.php");
		require_once("m_grupa.php");
		$dalibn = new Dalibn();
		$gr = new Grupa();
		$gid = $this->GetGidId($id);
		$grupa = $gr->GetId($gid);
			
		//dabū brauciena beigu datumu (vecuma rēķināšanai)
		$beigu_dat = $grupa['beigu_dat'];
		foreach($dalibn_id_arr as $did){
			
			$birthday = $dalibn->Birthday($did);
			if ($birthday){
				$diff = $beigu_dat->diff($birthday);
				$age = $diff->format('%y');
				if (DEBUG) echo "<br>vecums: $age<br>";
				if ($age<=16) $children[] = $did;
			}
		}
		return $children;
	}
	
	
	 

	function GetCurrent($rez_id, $tmp,$profile_id){
 
		$whereC = "pp.profile_id=p.profile_id 
				and pp.deleted=0 
				and pp.tmp = 0 
				and pp.gid = p.gid 
				and pp.online_rez = p.online_rez 
				and pp.atcelts = 0";
		//--- 10.06.2013 pievienots where nosacijums //and p.gid<>458', kas izsledz pieteikumus, kuri ir atteiksusies
		$query="select distinct m.v as celojums,p.datums as reg_datums,p.gid,g.sakuma_dat as datums,g.beigu_dat as beigu_datums, g.izbr_laiks, iv.nosaukums as izbr_vieta, term1_dat, term2_dat, term3_dat, term1_summa, term2_summa, 
				(select count(pp.id) from pieteikums pp where ".$whereC.") as personas,
				(select sum(pp.summaLVL) from pieteikums pp where ".$whereC.") as summa,
				(select sum(pp.iemaksasLVL) from pieteikums pp where ".$whereC.") as iemaksas,
				(select sum(pp.izmaksasLVL) from pieteikums pp where ".$whereC.") as izmaksas, 
				(select sum(pp.summaEUR) from pieteikums pp where ".$whereC.") as summaEUR,
				(select sum(pp.iemaksasEUR) from pieteikums pp where ".$whereC.") as iemaksasEUR,
				(select sum(pp.izmaksasEUR) from pieteikums pp where ".$whereC.") as izmaksasEUR, 
				p.profile_id, o.parbaude 
				from marsruts m 
				inner join grupa g 
					on m.id=g.mid 
				inner join pieteikums p 
					on g.id=p.gid 
				left outer join [orderis] o 
					on o.pid = p.id and o.deleted = 0 
				left join grupa_izbr_vieta iv 
					on iv.id = g.izbr_vieta 
				where p.online_rez=? 
				and p.deleted=0 
				and p.tmp = ? 
				and p.atcelts = 0 
				and p.profile_id=?
				and p.gid<>458;"; 
		$params = array($rez_id,$tmp,$profile_id);
		$result = $this->db->Query($query,$params);
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}	
	}
	
	 


	function GetDetails($rez_id, $tmp, $profile_id) {
		
        $ssql = "select ps.vid as v_id,
				ps.kid as k_id 
				from [pieteikums] p 
				inner join [profili] pp 
					on pp.id = p.profile_id 
				inner join [piet_saite] ps 
					on ps.pid=p.id 
				left join viesnicas v 
					on v.id = ps.vid 
				left join viesnicas_veidi vsv 
					on vsv.id = v.veids 
				where p.online_rez=? 
				and ps.deleted=0 
				and p.profile_id = ?
				and p.deleted=0 
				and p.tmp = 0
				and p.atcelts = 0 
				and ((ps.vid is not null) or (ps.kid is not null) ) ";
		$params = array($rez_id,$profile_id);
		$res = $this->db->Query($ssql,$params);	
		
		if (sqlsrv_has_rows($res)) {
			$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
			if ($result["k_id"]>0) {
				$param = "ps.kid";
				$viesn = "kajites_veidi";
				$kaj = "kajite";
			} else {
				$param = "ps.vid";
				$viesn = "viesnicas_veidi";
				$kaj = "viesnicas";
			}
		
			//--- 7.06.2013 izmainits lauks p.did uz ps.did
			//--- gadijumaa ja dalibnieks ir dzeests un izveidots cits pieteikumaa did lauks 
			//--- online rezervacijai neupdeitojas un dalibnieku vairs nevar atrast
			
			
			$query="select vv.max_vecums, p.zid, p.id as p_id,p.gid, ps.did as d_id, pp.id as profile_id, pp.eadr, p.iemaksas,pp.vards,pp.uzvards,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,vv.cenaLVL, vv.cenaEUR, ps.id as ps_id,ps.vid as v_id,ps.kid as k_id, vsv.nosaukums as viesnica, vsv.vietas as vietas, 
					isnull((select sum(atlaideLVL) from piet_atlaides where pid = p.id ),0) as atlaide, 
					isnull((select sum(atlaideEUR) from piet_atlaides where pid = p.id ),0) as atlaideEUR, 
					isnull((select sum(summaLVL) from orderis where deleted = 0 and pid = p.id ),0) as iemaksas_sum, 
					isnull((select sum(summaEUR) from orderis where deleted = 0 and pid = p.id ),0) as iemaksas_sumEUR, 
					isnull((select sum(summaEUR) from orderis where deleted = 0 and nopid = p.id ),0) as izmaksas_sumEUR 
					from pieteikums p 
					inner join profili pp 
						on pp.id = p.profile_id 
					inner join piet_saite ps 
						on ps.pid=p.id 
					inner join vietu_veidi vv 
						on vv.id=ps.vietas_veids 
					left join ".$kaj." v 
						on v.id = ".$param." 
					left join ".$viesn." vsv 
						on vsv.id = v.veids 
					where p.online_rez=? 
					and ps.deleted=0 
					and p.deleted=0 
					and p.tmp = ? 
					and p.atcelts = 0 
					order by p_id;";
			$params = array($rez_id,$tmp);
			
			$res = $this->db->Query($query,$params);	
			
			return $res;
		}
		 else {
			//---ja nav naktsmitnes, tad atgriezh parejo rezervacijas informaciju. 09/08/2010 Nils
			$query="select vv.max_vecums, p.zid, p.id as p_id,p.gid, ps.did as d_id, pp.id as profile_id, pp.eadr, p.iemaksas,pp.vards,pp.uzvards,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,vv.cenaLVL, vv.cenaEUR, ps.id as ps_id,ps.vid as v_id,ps.kid as k_id, '' as viesnica, 
					 isnull((select sum(atlaideLVL) from piet_atlaides where pid = p.id ),0) as atlaide, 
					 isnull((select sum(atlaideEUR) from piet_atlaides where pid = p.id ),0) as atlaideEUR, 
					 isnull((select sum(summaLVL) from orderis where deleted = 0 and pid = p.id ),0) as iemaksas_sum, 
					 isnull((select sum(summaEUR) from orderis where deleted = 0 and pid = p.id ),0) as iemaksas_sumEUR, 
					 isnull((select sum(summaEUR) from orderis where deleted = 0 and nopid = p.id ),0) as izmaksas_sumEUR 
					 from pieteikums p 
					inner join profili pp 
						on pp.id = p.profile_id 
					inner join piet_saite ps 
						on ps.pid=p.id 
					inner join vietu_veidi vv 
						on vv.id=ps.vietas_veids 
					where p.online_rez=?
					and ps.deleted=0 
					and p.deleted=0 
					and p.tmp = ?
					and p.atcelts = 0 
					order by p_id;";
			$params = array($rez_id,$tmp);
			
			$res = $this->db->Query($query,$params);	
			
			return $res;
		}
	}
	//atgriež lietotāja nepabeigtās rezervācijas
	function GetUserUncompletedRes(){
		
	}
	//atgriež lietotāja rezervācijas 
	function GetUserReservations($only_uncompleted=false){
		require_once("m_grupa.php");
		$gr = new Grupa();
		$gift_card_gid_arr = $gr->getAllGiftCardGid();
		$gift_card_gid = implode(",",$gift_card_gid_arr);
		$query = "SELECT DISTINCT rez.*, g.sakuma_dat as sdat
					FROM online_rez rez 
					LEFT JOIN pieteikums p 
						ON p.online_rez = rez.id
					LEFT JOIN grupa g 
						ON g.id = p.gid
					WHERE rez.profile_id=? 
					AND rez.deleted=0
					AND p.deleted=0
					AND not p.gid in (".$this->db->invisibleGid.")
					AND NOT p.gid IN (".$gift_card_gid.")
					/*AND g.sakuma_dat>getutcdate()*/";
		
		$query .= " ORDER BY rez.datums DESC";
		//echo $query;
		//die();
		
		//echo $_SESSION['profili_id'];
		//die();
		
		$params = array($_SESSION['profili_id']);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
			
		$result = $this->db->Query($query,$params);	
		$reservations = array();
		require_once("m_grupa.php");
		require_once("m_marsruts.php");
		require_once("m_pieteikums.php");
		require_once("m_kajite.php");
		$pieteikums = new Pieteikums();
		$marsruts = new Marsruts();
		$gr = new Grupa();
		$kaj = new Kajite();
		
		require_once("i_functions.php");
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			$online_rez_id = $row['id'];
			$iemaksas = $pieteikums->GetMaksatOnlineRez($online_rez_id);
			if (DEBUG){
				echo "iemaksas:<br>";
				var_dump($iemaksas);
				echo "<br><br>";
			}
			$pabeigta = ($iemaksas['iemaksats'] >0 ? 1 : 0);
			
			$radit = true;
			
		
			//dabū ceļojuma datumu un nosaukumu
			$gid = $this->GetGidId($online_rez_id);
			//ja šis ir atcelts ceļojums)
			if ($gid == $this->db->cancelledGid){
				$atcelta_grupa = 1;				
			}
			else $atcelta_grupa = 0;
			
			if ($only_uncompleted && ($pabeigta || $atcelta_grupa)){
				$radit = false;
			}
			

			
			if ($radit){
				if($atcelta_grupa){
					if (DEBUG){
						echo "<br>old gid:<br>";
						var_dump($this->GetOldGidId($online_rez_id));
						echo "<br><br>";
					}
					$gid = $this->GetOldGidId($online_rez_id);
					//atrod iemaksas un izmaksas no orderiem, jo pieteikuma bilance šajā gad.ir 0 un summa arī
					require_once("m_orderis.php");
					$orderis = new Orderis();
					$maksajumi = $orderis->GetSummasOnlineRez($online_rez_id);
					if (DEBUG){
						echo "<br>ORDERI:<br>";
						var_dump($maksajumi);
						echo "<br><br>";
					}
				}
				
				$grupa = $gr->GetId($gid);
				//var_dump($grupa);
				$sakuma_dat =  $this->db->Date2Str($grupa['sakuma_dat']);
				$beigu_dat =  $this->db->Date2Str($grupa['beigu_dat']);
				
				if ($sakuma_dat == $beigu_dat){
					$beigu_dat = ''; 
					//echo "sakrīt <br>";
					
				}
				else{
					if (date("Y",strtotime($sakuma_dat)) == date("Y",strtotime($beigu_dat)))
						$sakuma_dat = date("d.m.Y",strtotime($sakuma_dat));
				}
				if (DEBUG){
					echo "Sākuma datums:<br>";
					var_dump($sakuma_dat);
					echo "<br><br>";
					echo "Beigu datums:<br>";
					var_dump($beigu_dat);
					echo "<br><br>";
				}
				$mid = $grupa['mID'];			
				$celojums = $marsruts->GetId($mid);
				//echo "<br><br>";
				//var_dump($celojums);			
				$celojuma_nos = $celojums['v'];
				
				//pārbauda, vai līgums ir izveidots un akceptēts
				require_once('m_ligumi.php');
				$ligumi  = new Ligumi();
				$apstiprinats = (int)$ligumi->GetAcceptedOnlineRez($online_rez_id);
				
				$var_labot = ($apstiprinats || $iemaksas['iemaksats'] > 0 ? 0 : 1);
				
				
				$kajisu_veidi = $kaj->GetVeidiGid($gid);
				$ir_kajites = (count($kajisu_veidi)>0 ? true : false);
				$rezervacija = array ('rez_id'=> $online_rez_id,
										'sakuma_dat' => $sakuma_dat,
										'beigu_dat' => $beigu_dat,
										'celojuma_nos' => $celojuma_nos,
										'cena' => CurrPrint($iemaksas['cena']),
										'jamaksa' => CurrPrint($iemaksas['jamaksa']),
										'iemaksats' => CurrPrint($iemaksas['iemaksats']),
										'var_labot' => $var_labot,
										'pabeigta' => $pabeigta,
										'gid' => $gid,
										'atcelta_grupa' => $atcelta_grupa,
										'ir_kajites'=> $ir_kajites);
				if (isset($maksajumi)){
					$rezervacija['orderi'] = $maksajumi;
				}
				$reservations[] = $rezervacija;
			}
			
		}
	
		return $reservations;
		
	}
	
	//atgriež ceļotāju skaitu
	function GetTravellerCount($online_rez){
		$query = "SELECT count(DISTINCT did) as skaits
					FROM pieteikums 
					WHERE online_rez=?
					AND did IS NOT NULL
					AND did!=0
					AND deleted=0
					AND not gid in (".$this->db->invisibleGid.")";
		$params = array ($online_rez);
		$result = $this->db->Query($query,$params);
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['skaits'];
		}	
	}


	
	//pārbauda, vai apmaksu veicis reģistrēts vai nereģistrēts lietotājs
	function IsProfileId($id){
	
		$rez =  $this->GetId($id);
		
		if ($rez['profile_id']){
			return true;
		}
		else return false;
	}
	
	//pagarina rezervācijas veikšanas laiku:
	function ExtendTime($id,$minutes=40){
		$deriga_lidz = date("Y-m-d H:i:s",strtotime("+$minutes minutes"));
		$data = array('deriga_lidz'=>$deriga_lidz);
		$this->db->Update('online_rez',$data,$id);
		
	}
	
	
	//atgriež online rezervācijas, kurām ir uzstādīts no_delete, bet nav izveidojušies orderi (SEB kļūdainās, kam nepienāk 0004 statuss)
	function GetNeapmaksatas(){
		$query = "SELECT o.*,p.vards,p.uzvards FROM online_rez o LEFT JOIN profili p ON p.id=o.profile_id 
		where no_delete =1 AND o.deleted=0 AND o.id iN(SELECT online_rez FROM pieteikums WHERE  deleted=0 AND id NOT IN (SELECT pid FROm orderis where deleted=0) ) ORDER by o.datums DESC";
		$query = "select isnull(orez.tika_lidz_bankai,0) as tika_lidz_bankai,
				orez.deleted,sakuma_dat,orez.id, max(p.datums) as datums, g.kods, m.v, pr.vards,
				 pr.uzvards, count(p.personas) as dalibnieki,   
				sum(p.summaLVL) as summaLVL, sum(p.summaUSD) as summaUSD, sum(p.summaEUR) as summaEUR,   
				sum(p.bilanceLVL) as bilanceLVL,sum(p.bilanceUSD) as bilanceUSD,sum(p.bilanceEUR) as bilanceEUR,   
				orez.ligums_id, p.atlaidesLVL 
				from online_rez orez   
				inner join pieteikums p on p.online_rez = orez.id   
				inner join profili pr on pr.id = orez.profile_id   
				inner join grupa g on g.id = p.gid  
				inner join marsruts m on m.id = g.mid  
				where ((orez.deleted = 0 and p.deleted = 0 and p.tmp = 0 and (p.step = '4' or orez.no_delete=1)) or (orez.deleted=1 and isnull(orez.tika_lidz_bankai,0)=1)) and p.internets = 1  
				AND orez.id iN(SELECT online_rez FROM pieteikums WHERE  deleted=0 AND id NOT IN (SELECT pid FROm orderis where deleted=0) )
				group by orez.tika_lidz_bankai, orez.deleted,sakuma_dat, orez.id, g.kods, m.v, orez.ligums_id, pr.vards, pr.uzvards, p.atlaidesLVL  
				order by p.datums DESC";
		$result = $this->db->Query($query);
		$reservations = array();
		require_once("m_grupa.php");
		$gr = new Grupa();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$reservation = $row;
			$gid =$this->GetGidId($row['id']);
			$grupa = $gr->GetId($gid);
			$c_nos = $gr->GetCelojumaNosId($gid);
			$reservation['grupa'] = $grupa;
			$reservation['grupa']['c_nos'] = $c_nos;
			$reservations[] = $reservation;
		}	
		return $reservations;
	}
	
	//-------------------------
	//07.09.2019 RT
	// pārbauda, vai rezervācija pieder profila īpašnieka
	//-------------------------
	function IsOwner($id){
		
		$profili_id = (isset($_SESSION['profili_id']) ? $_SESSION['profili_id'] : 0);
		$res = $this->GetId($id);
		if (!empty($res) && $res['profile_id'] == $profili_id)
			return true;
		else return false;
	}
	
	//---------------------------------------
	// 18.12.2019 RT
	// checks if reservation has payments
	//------------------------------------------
	function HasPayment($id){
		require_once("m_pieteikums.php");
		$pieteikums = new Pieteikums();
		$qry = "SELECT SUM(summa) as summa 
				from orderis where deleted=0 
				and pid in (select id from pieteikums where deleted=0 and online_rez=?)";
		$params = array($id);
		
		$result = $this->db->Query($qry,$params);
		if ( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {			
			if ($row['summa'] > 0) {
				return true;
			}
		}
		return false;
		/*$iemaksas = $pieteikums->GetMaksatOnlineRez($id);
		if (DEBUG){
			echo "Iemaksas<br>";
			var_dump($iemaksas);
			echo "<br><br>";
		}		
		return ($iemaksas['iemaksats'] > 0 ? TRUE : FALSE);*/
		
	}
	
	//-------------------------------------------------------------------------------------//
	// 26.12.2019 RT
	// atgriež ceļotāju skaitu rezervācijā - vai nu no sesijas, vai pēc pieteikumu skaita
	//-------------------------------------------------------------------------------------//
	function TravellerCount($id){	
		
		if ($_SESSION['reservation']['traveller_count']){
			$traveller_count = $_SESSION['reservation']['traveller_count'];
		}
		else{		
			$qry = "SELECT count(id) as skaits from pieteikums 
						where deleted=0 
						AND online_rez = ?
						AND gid not in (".$this->db->invisibleGid.")";
			$params = array($id);
			
			$result = $this->db->Query($qry,$params);
			if ($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				
				$traveller_count = $row['skaits'];
			}		
		}
		return $traveller_count;		
	}
	
	//--------------------------------------------------------------//
	// 27.12.2019. RT
	// Pārbauda, vai profila īpašnieks ietilpst dotajā rezervācijā
	// atgriež true/false
	//--------------------------------------------------------------//
	function ITravel($id){
		if ($this->CanEdit($id)){
			//skatās, vai ir sesijā uzstādīts
			if (isset($_SESSION['reservation']['i_travel']) && (int)$_SESSION['reservation']['i_travel']>0){
				if ( $_SESSION['reservation']['i_travel']) return true;
				else return false;
			}
		}
				
		require_once('m_dalibn.php');		
		$dalibn = new Dalibn();
		$es = $dalibn->GetId();
		$qry = "SELECT * FROM pieteikums
					where deleted=0 
					AND online_rez = ?
					AND gid not in (".$this->db->invisibleGid.")
					AND did = ?";
		$params = array($id,$es['ID']);
		$result = $this->db->Query($qry,$params);
		
		if (sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return true;
		}
		else{
			return false;
		}
				
			
					
	}
	
	//------------------------------------//
	// 27.12.2019 RT
	// Pārbauda,vai rezervāciju var labot
	// atgriež true/false
	//-----------------------------------//
	function CanEdit($id){
		//pārbauda, vai līgums ir izveidots un akceptēts		
		require_once('m_ligumi.php');		
		$ligumi  = new Ligumi();		
		if ($ligumi->GetAcceptedOnlineRez($id)){			
		  return FALSE;
		}
		//---------------//
		//pārbauda, vai ir iemaksas
		if ($this->HasPayment($id)){
			return false;
		}
		//--------//

		return true;
	}
	
	//--------------------------------//
	// 23.12.2019 RT
	// Izveido jaunu online_rez
	//-------------------------------//
	function CreateNew($dalibn_id_arr,$dk=false){
		global $profili;
		global $db;
		//dzēšam veco, ja ir
		
		if(isset($_SESSION['reservation']['online_rez_id'])){		
			$this->Delete($_SESSION['reservation']['online_rez_id']);		
		}
		
		//izveidojam jaunu rezervāciju	
		if ($dk){
			//dāvanu kartes rezervācija
			$deriga_min = 1440;
			if ($profili->CheckLogin()) $profile_id = $_SESSION['profili_id'];
			else $profile_id = 0;
		}
		else{
			//ceļojuma rezervācija
			$deriga_min = 30;		
			$profile_id = $_SESSION['profili_id'];
		}
		
		
		require_once("m_grupa.php");
		$gr = new Grupa();
		
		$brivas_vietas = $gr->GetVietas($_SESSION['reservation']['grupas_id']);
		if ($brivas_vietas < count($dalibn_id_arr) and !$dk) {
			die('Grupā vairs nav brīvu vietu!');
		}
		
		$online_rez_id = $this->Insert($profile_id,$deriga_min);
		//ja izveidojās veiksmīgi		
		if ($online_rez_id){	
			require_once('m_pieteikums.php');
			$pieteikums = new Pieteikums();
			
			// pārbaude vai jau nav reģistrējušies šim ceļojumam
			if (!$dk) {
				foreach ($dalibn_id_arr as $did){	
					if ($gr->IsInGroup($did,$_SESSION['reservation']['grupas_id']))
						return -1;
				}
			}
			
			//izveidojam pietiekumus katram dalībniekam un katram pieteikumam piet_saite
			foreach ($dalibn_id_arr as $did){	
				if ($dk){
					$gr = new Grupa();
					$gid = $gr->getGiftCardGid();
					if (empty($gid)){
						//$error['summa'] = 'Kļūda - nav atrasts dāvanu kartes grupas ID#. Lūdzu, sazinieties ar IMPRO.';
						return false;
					}
					
					$db1 = $db->EscapeValues($_POST,'kam');
					$dk_numurs = $pieteikums->GetDkNum();
					$values = array('gid' => $gid,	
									'profile_id' => $profile_id,	
									'did' => $did,			
									'online_rez' => $online_rez_id,
									'dk_serija' => 'On',
									'dk_numurs' => $dk_numurs,
									'dk_kods' => GenDkKods(),
									'dk_kam' => $db1['kam'],
									'dk_summa' => $_POST['summa'],
									'sakuma_datums' => date("Y-m-d"),
									'beigu_datums' => date("Y-m-d",strtotime("+1 Year -1 Day")),
									'summaEUR' => $_POST['summa'],
									'piezimes'	=>  'Davanu karte nr. On-'.$dk_numurs
							);	
				}
				else{
					$values = array('gid' => $_SESSION['reservation']['grupas_id'],
									'did' => $did,
									'profile_id' => $_SESSION['profili_id'],
									'online_rez' => $online_rez_id);
					
				}			
				if (DEBUG)	var_dump($values);
				$pieteikums_id = $pieteikums->Insert($values);
				
				$values = array('pid' => $pieteikums_id,
								'did' => $did);							
				$piet_saites_id = $pieteikums->InsertSaite($values);	
			}
			if ($dk){
				$pieteikums->Calculate($pieteikums_id );
			}
			$_SESSION['reservation']['online_rez_id'] = $online_rez_id;
			return $online_rez_id;
		}
		else {
			return false;
		}	
		
		
	}
	
	
	//----------------------------------------------------//
	// 27.12.2019 RT
	// Pārbauda, vai rezervācijai ir pievienoti dalībnieki
	//----------------------------------------------------//
	//---------------------------------------//
	function HasDalibn($id){
		$traveller_count = $this->TravellerCount($id);
		
		$dalibn_piet_count = count($this->GetDalibnList($id));
		if ($traveller_count == $dalibn_piet_count) return true;
		else return false;
	}
	
	//-----------------------------------------------//
	// 10.01.2020 RT
	// Pārbauda, vai visiem rezrevācijas dalībniekiem
	//	ir norādzītas dzimšanas dienas
	// atgriež true/false
	//-----------------------------------------------//
	function AllDalibnHaveBirthData($id){
		$dalibn_arr = $this->GetDalibnList($id,null,true);
		foreach($dalibn_arr as $dalibn){
			if(empty($dalibn['dzimsanas_datums'])){
				return false;
			}
		}
		return true;
	}
		
	
	
}
?>