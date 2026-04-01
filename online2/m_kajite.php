<?
class Kajite {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db();
	}
	
	function GetId($id){
		$query = "SELECT *
					FROM kajite					
					WHERE id = ? ";
		//echo $query."<br>";
		//echo "$id<br>";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}
	
	
	function GetVeidsId($kveids_id){
		$query = "SELECT * FROM kajites_veidi WHERE id=?";
		
		$params = array($kveids_id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}
	
	function GetVeidiGid($gid){
		//echo "GID:$gid<br>";
		$qry = "SELECT k.veids,kv.nosaukums,kv.id,k.vietas
				FROM kajite k,kajites_veidi kv
				WHERE k.gid=?
				AND k.veids = kv.id
				group by k.veids,kv.nosaukums,kv.id,k.vietas";
		//echo $qry."<br>";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$veidi[] = $row;
			
		}
		return $veidi;
	}
	function GetAvailableVeidiGid($gid,$dalibn_arr=null){
		$veidi = $this->GetVeidiGid($gid);
		//var_dump($veidi);
		$kajites_veidi = array();
		if (!empty($veidi)){
			foreach($veidi as $row){
				if (DEBUG){
					echo "Kaj veidi:<br>";
					print_r($row);
					echo "<br><br>";
				}
				
				$veids = $row['id'];
				$qry = "SELECT SUM(vietas) as skaits FROM kajite WHERE veids = ?";
				$params = array($veids);
				$res = $this->db->Query($qry,$params);			
				$rowVietas= sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
				$vietas_kopa = $rowVietas['skaits'];
				
				$qry = "SELECT count(*) as skaits FROm piet_saite 
						where deleted=0 and kid!=0 
						AND kvietas_veids NOT in (3,6,7) 
						AND kid IN (SELECT id FROM kajite WHERE veids=?)";
			
				$params = array($veids);
				if (isset($dalibn_arr)){
					foreach($dalibn_arr as $did){
						$qry .= " AND did !=?";
						$params[] = $did;
					}
				}
				if (DEBUG){
					echo "GetAvailableVeidiGid <br>";
					echo $qry."<br>";
					var_dump($params);
					
				}
				$res = $this->db->Query($qry,$params);			
				$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
				//print_r($rowAiznemts);
				//echo "M<br>";
				$aiznemts = $rowAiznemts['skaits'];
				if (DEBUG){
					echo "aizòemts: $aiznemts<br>";
				}
				if ($aiznemts>0){
					//atrod 'aizòemtâs' vietas, par kurâm piemaksâts, lai nepieliktu kâdu citu kajîtç 
					$qry = "SELECT count(*) as skaits FROm piet_saite 
								where deleted=0 and kid!=0 
								AND kvietas_veids=3 AND kid IN (SELECT id FROM kajite WHERE veids=?)";
					
					$params = array($veids);
					if (DEBUG){
						echo "GetAvailableVeidiGid kvietas_veids 3<br>";
						echo $qry."<br>";
						var_dump($params);
						
					}
					$res = $this->db->Query($qry,$params);			
					$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
					$aiznemts_papildus_1 = $rowAiznemts['skaits'] / $aiznemts;
					if (DEBUG){
						echo "aiznemts_papildus_1: $aiznemts_papildus_1<br>";
					}
					
					$qry = "SELECT count(*) as skaits FROm piet_saite 
								where deleted=0 and kid!=0 
								AND kvietas_veids=6  
								AND kid IN (SELECT id FROM kajite WHERE veids=?)";
					
					$params = array($veids);
					if (DEBUG){
						echo "GetAvailableVeidiGid kvietas_veids 6<br>";
						echo $qry."<br>";
						var_dump($params);
						
						
					}
					$res = $this->db->Query($qry,$params);			
					$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
					$aiznemts_papildus_2 = $rowAiznemts['skaits'];
					if (DEBUG){
						echo "aiznemts_papildus_2: $aiznemts_papildus_2<br>";
					}
					
					//
					$qry = "SELECT count(*) as skaits FROm piet_saite 
								where deleted=0 and kid!=0 
								AND kvietas_veids=7 AND kid IN (SELECT id FROM kajite WHERE veids=?)";
					
					$params = array($veids);
					if (DEBUG){
						echo "GetAvailableVeidiGid kvietas_veids 7<br>";
						echo $qry."<br>";
						var_dump($params);
						
					}
					$res = $this->db->Query($qry,$params);			
					$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
					if ($rowAiznemts['skaits']){
						$aiznemts_papildus_3 = 3;
					}
					else{
						$aiznemts_papildus_3 = 0;
					}
					
					$aiznemts += $aiznemts_papildus_1 + $aiznemts_papildus_2 + $aiznemts_papildus_3;
					
				}
				$brivas_vietas = $vietas_kopa - $aiznemts;
				//echo "Brîvas vietas: ".$brivas_vietas."<br>";
				if ($brivas_vietas >= 1){
					$kveids = $this->GetVeidsId($row['id']);
					$kajite = array('nosaukums' => $row['nosaukums'],
									'brivas_vietas' => $brivas_vietas ,
									'kveids_id' => $row['id'],
									'kveids'  => $kveids
									);
					$kajites_veidi[] = $kajite;
				}
					
			}
		}
		return $kajites_veidi;
	}

	function GetAvailableGid($gid,$kveids=null,$only_one=null,$did=null,$piemaksa=null){
		
		//echo "GetAvailableGid<br>";
		//echo "did:<br>";
		//var_dump($did);
		//echo "<br><br>";
		$qry = "SELECT kv.nosaukums,k.vietas, k.id as kid,k.veids
				from kajite k 
				left join kajites_veidi kv on k.veids=kv.id 
				where k.gid=?"; 
		
		$params = array($gid);
		if (isset($kveids)){
			$qry .= " AND kv.id=?";
			$params[] = $kveids;
		}
		if (DEBUG){
			echo "GET AVAILABLE GID KAJITE:<br>";
			echo $qry."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
		
		//$veidi = array();
		$kajites = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		//	echo "atrod aizòemtâs vietas<br>";
			//atrod aizòemtâs vietas 
			$qry = "SELECT count(*) as skaits FROM piet_saite 
						where deleted=0 and kid!=0 
						AND kvietas_veids NOT in (3,6,7) and kid=?";
				$params = array($row['kid']);
			if (isset($did) && !empty($did)){
				$qry.= " AND did!=?";
				$params[] = $did;
			}
		
			if (DEBUG){
				echo "atrod aizòemtâs vietas kajîtçs:<br>";
				echo $qry."<br>";
				var_dump($params);
			}
			$res = $this->db->Query($qry,$params);			
			$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
			$aiznemts = $rowAiznemts['skaits'];
			if ($aiznemts>0){
				
				//atrod 'aizòemtâs' vietas, par kurâm piemaksâts, lai nepieliktu kâdu citu kajîtç 
				$qry = "SELECT count(*) as skaits FROm piet_saite 
							where deleted=0 and kid!=0 
							AND kvietas_veids=3  and kid=?";				
				$params = array($row['kid']);
				$res = $this->db->Query($qry,$params);			
				$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
				$aiznemts_papildus_1 = $rowAiznemts['skaits'] / $aiznemts;
				
				$qry = "SELECT count(*) as skaits FROm piet_saite 
							where deleted=0 and kid!=0 
							AND kvietas_veids=6  and kid=?";				
				$params = array($row['kid']);
				$res = $this->db->Query($qry,$params);			
				$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
				$aiznemts_papildus_2 = $rowAiznemts['skaits'];
				
				$qry = "SELECT count(*) as skaits FROm piet_saite 
							where deleted=0 and kid!=0 
							AND kvietas_veids=7  and kid=?";				
				$params = array($row['kid']);
				$res = $this->db->Query($qry,$params);			
				$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
				$aiznemts_papildus_3 = ($rowAiznemts['skaits'] ? 3 : 0);
				
				
				$aiznemts += $aiznemts_papildus_1 + $aiznemts_papildus_2 + $aiznemts_papildus_3;
			}
			$brivas_vietas = $row['vietas'] - $aiznemts;
			if (DEBUG){
				var_dump($row['vietas']);
				echo "Brîvas vietas kajîtç ".$row['kid'].": $brivas_vietas <br>";
			}
			
			if ($brivas_vietas >= 1){
				$ok = 1;
				//ja ir izvçlçta kajîte vienam cilvçkam ar piemaksu, tad atgrieþ tikai pilnîbâ tukðu kajîti	
				if (isset($piemaksa) and $piemaksa and $row['vietas'] != $brivas_vietas){
					$ok = 0;
						
				}
				if ($ok){
					$kajite = array('nosaukums' => $row['nosaukums'],
									'brivas_vietas' => $brivas_vietas,
									'kid' => $row['kid'],
									'veids' => $row['veids']
									);
					//if (isset($only_one))
						//return $kajite;
					$kajites[] = $kajite;
				}
			}
					
			
			
		}
		//echo "nesakârtotas kajîtes:<br>";
			//var_dump($kajites);
			//echo "<br><br>";
		if (isset($only_one)){
			//atgrieþ visvairâk aizòemto
			usort($kajites, function($a, $b) {
						return strcmp($a["brivas_vietas"], $b["brivas_vietas"]);
						});
			//echo "sakârtotas kajîtes:<br>";
			//var_dump($kajites);
			//echo "<br><br>";
			return($kajites[0]);
		}
		return $kajites;
		
	}

	//atgrieþ pilnîbâ brîvâs kajîtes grupai
	function GetEmptyGid($gid,$kveids=null,$dalibnieki=null){
		
		$qry = "SELECT kv.nosaukums,k.vietas, k.id as kid,k.veids,k.vietas
				from kajite k 
				left join kajites_veidi kv on k.veids=kv.id 
				where k.gid=?"; 
		
		$params = array($gid);
		if (isset($kveids)){
			$qry .= " AND kv.id=?";
			$params[] = $kveids;
		}
		
		$result = $this->db->Query($qry,$params);
		
		//$veidi = array();
		$kajites = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//atrod aizòemtâs vietas 
			$qry = "SELECT count(*) as skaits FROM piet_saite 
						where deleted=0 and kid!=0 
						and kid=?";
			$params = array($row['kid']);
			if (isset($dalibnieki) && is_array($dalibnieki)){
				foreach($dalibnieki as $did){
					$qry .= " AND did<>?";
					$params[] = $did;
				}
			}
			
			$res = $this->db->Query($qry,$params);			
			$rowAiznemts = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
			$aiznemts = $rowAiznemts['skaits'];
			//var_dump($rowAiznemts);
		//echo "<---ainemts<br>";
			if ($aiznemts==0){

				$kajite = $row;
				$kajites[] = $kajite;
			}			
		}
		
		return $kajites;
		
	}
	//kvietas veids var bût tikai 3 vai 6
	/*function ReserveFullCabin($online_rez_id,$did,$kaj_id,$kvietas_veids){
			
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");
		require_once("m_online_rez.php");
		require_once("m_grupa.php");
		$gr = new Grupa();
		$online_rez = new OnlineRez();
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();
		
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);

		

		$vv = 0;	
		$values = array('kid'=>$kid,'kvietas_veids' => $kvietas_veids,'persona'=> 1,'vietas_veids'=> $vv);
		$where_arr = array('pid' => $pid							
							);
		//var_dump($where_arr);
		
		$where_cond = "(deleted=0 AND ((summaEUR IS NULL AND kvietas_veids =0) OR (kid IS NOT NULL AND kid>0)))";
		//saglabâ jauno kajîti
		$this->db->UpdateWhere('piet_saite',$values,$where_arr,$where_cond);
	}
	*/
	
	function ChangeCabin($online_rez_id,$did,$kid,$papildus_vieta = null){
			
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");
		require_once("m_online_rez.php");
		require_once("m_grupa.php");
		$gr = new Grupa();
		$online_rez = new OnlineRez();
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();
		
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		
		
		//vçstures saglabâðanai:
		$old_vals = $pieteikums->GetId($pid);
		$old_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		
		//nodzçð pieteikumus ar papildvietâm kajîtç, ja tâdi ir
		$qry = "UPDATE piet_saite set deleted=1 WHERE deleted=0 AND pid=? AND kid IS NOT NULL AND kvietas_veids IN (3,6,7)";
		$params = array($pid);
		$this->db->Query($qry,$params);
		//dabû dalîbnieka vecumu uz ceïojuma beigu dienu		
		$gid = $online_rez->GetGidId($online_rez_id);
	
		$grupa = $gr->GetId($gid);
		$beigu_dat = $grupa['beigu_dat'];
		
		$age = $dalibn->GetAgeId($did,$beigu_dat);
		$kvietas_veids = $this->GetKajitesGrupaAge($age,$gid);
		
		
		/*$qry = "SELECT id FROM vietu_veidi WHERE gid=? AND nosaukums like '%nav%' AND tips='X'";
		$params = array($gid);
		$res = $this->db->Query($qry,$params);			
		if($row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$vv = $row['id'];
		}
		else $vv = 0;*/
		$vv = 0;	
		$values = array('kid'=>$kid,
					'kvietas_veids' => $kvietas_veids,
					'persona'=> 1,
					'vietas_veids'=> $vv);
		$where_arr = array('pid' => $pid							
							);
		//var_dump($where_arr);
		
		$where_cond = "(deleted=0 AND ((summaEUR IS NULL AND kvietas_veids =0) OR (kid IS NOT NULL AND kid>0)))";
		//saglabâ jauno kajîti
		
		//vispirms pârbauda, vai tieðâm apdeita nosacîjums izpildîsies:
		$qry = "SELECT * FROM piet_saite WHERE pid=? AND $where_cond";
		
		$piet_saite = $this->db->Query($qry,array($pid));
		if(!sqlsrv_fetch_array( $piet_saite, SQLSRV_FETCH_ASSOC) ){
			die("Kïûda. Neizdevâs ievietot ceïotâju #$did kajîtç #$kid! Lûdzu, sazinieties ar IMPRO!");
		} 
		$this->db->UpdateWhere('piet_saite',$values,$where_arr,$where_cond);
		
		
		if (isset($papildus_vieta) && !empty($papildus_vieta)){
			if (DEBUG){
				echo "pievienojam papildus vietu:<br>";
			}
			$nulles_vv_id = $gr->GetNullesPakalpId($gid);
			$values = array('kid'=>$kid,
					'kvietas_veids' => $papildus_vieta,
					'persona'=> 1,
					'vietas_veids'=> $nulles_vv_id,
					'pid' => $pid,
					'did' => $did);
			//var_dump($values);
			
			$pieteikums->InsertSaite($values);
		}
		$pieteikums->Calculate($pid);
		
		//vçstures saglabâðanai:
		$new_vals = $pieteikums->GetId($pid);
		$new_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);	
	}
	
	//atgrieþ vecumam atbilstoðo kajîtes veidu:
	 function GetKajitesGrupaAge($d_age,$gid){

		$kajites_grupa = 1;
		$kveidi = $this->GetPricesGid($gid);
		//dabû vecuma intervâlus no db
		$qry = "SELECT * FROM kajites_vecums";
		$result = $this->db->Query($qry);	
		
		while( $kajites_vecums = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($kajites_vecums);
			//echo "<br><br>";
			//bçrns
			if (($d_age <= $kajites_vecums["bernu_lidz"]) && array_key_exists(2,$kveidi)) {
				$kajites_grupa = 2;
			}
			//pusaudzis
			if (($d_age >=$kajites_vecums["pusaudzu_no"] && $d_age<=$kajites_vecums["pusaudzu_lidz"]) && array_key_exists(5,$kveidi)) {
				$kajites_grupa = 5;
			}
			//standarta
			if (($d_age>$kajites_vecums["pusaudzu_lidz"]) && array_key_exists(1,$kveidi)) { 
				$kajites_grupa = 1;
			}
		}
		return $kajites_grupa;
	 }
	 
	 //atgrieþ pieejamos kajîðu veidus pçc cenâm:
	 function GetPricesGid($gid,$kveids_id=null){
		// echo "GetPricesGid<br>";
		 $qry = "select sum(standart_cena) as standart, sum(bernu_cena) as bernu,sum(pusaudzu_cena) as pusaudzu,sum(senioru_cena) as senioru,  sum(papild_cena) as papild, sum(papild2_cena) as papild2,
				sum(papild3_cena) as papild3 from kajites_veidi where gid = ?";
		 $params = array($gid);
		if (isset($kveids_id)){
			$qry .= " AND id=?";
			$params[] = $kveids_id;
		}
		
		// echo $qry;
		// var_dump($gid);
		// echo "<br><br>";
		 $result = $this->db->Query($qry,$params);
		/*
			1 - standarta
			2 - bçrnu
			3 - papildus 1 brîva vietas
			4 - senioru
			5 - pusaudþu,
			6 - papildus 2 brîvas vietas
			7 - papildus 3 brîvas vietas (vienam ceïotâjam visu kajîti)
		*/
		$kveidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			//echo "<br>";
			if ($row['standart'] > 0 )
				$kveidi[1] = $row['standart'];	
			if ($row['bernu'] > 0 )
				$kveidi[2] = $row['bernu'];	
			if ($row['senioru'] > 0 )
				$kveidi[4] = $row['senioru'];	
			if ($row['pusaudzu'] > 0 )
				$kveidi[5] = $row['pusaudzu'];
			
			if ($row['papild'] > 0 )
				$kveidi[3] = $row['papild'];	
			if ($row['papild2'] > 0 )
				$kveidi[6] = $row['papild2'];	
			if ($row['papild3'] > 0 )
				$kveidi[7] = $row['papild3'];	
					
		}
		return $kveidi;
	 }
	 
	 //atgrieþ kajîtes veidu pçc online rezervâcijas
	 function GetKajitesVeidsOnlineRez($online_rez_id){
		 $qry = "SELECT DISTINCT k.veids as kveids_id,kv.nosaukums
				FROM piet_saite ps, kajite k,kajites_veidi kv
				WHERE ps.deleted!=1 
				AND ps.kid=k.id
				AND k.veids=kv.id
				AND ps.pid IN (SELECT id FROM pieteikums WHERE online_rez=?)";
		$params = array($online_rez_id);
		$result = $this->db->Query($qry,$params);
		
		
		$kajites_veids = array();				
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kajites_veids = $row;
		}
		return $kajites_veids;
		
	}
	
	//pçc kajîtes veida nr. atgrieþ tâs cenas nosaukumu vârdiski (bçrnu pusaudþu, standarta utt.)
	function GetCenasNos($kvv_p) {
		
		$cena = (empty($kvv_p) ? "" : $kvv_p);
		if ($kvv_p == 1) {$cena =  "standarta";}
		if ($kvv_p == 2) {$cena =  "bçrnu";}
		if ($kvv_p == 3) {$cena =  "piemaksa par vienu brîvo vietu";}
		if ($kvv_p == 6) {$cena =  "piemaksa par divâm brîvajâm vietâm";}
		if ($kvv_p == 7) {$cena =  "piemaksa par trim brîvajâm vietâm";}
		if ($kvv_p == 4) {$cena =  "senioru";}
		if ($kvv_p == 5) {$cena =  "pusaudþu";}		
		
		return $cena;
	}
	
	//atrod, vai par rezervâciju ir piemaksas par kajîtçm
	 function IsKajPiemaksaOnlineRezId($online_rez_id){
		 $qry = "SELECT ps.kvietas_veids
				FROM piet_saite ps, kajite k
				WHERE ps.deleted!=1 
				AND ps.kid=k.id
				AND ps.pid IN (SELECT id FROM pieteikums WHERE online_rez=?)";
		$params = array($online_rez_id);
		
	//	echo $qry."<br>";
	//	var_dump($params);
	//	echo "<br><br>";
		$result = $this->db->Query($qry,$params);
		
		
		//$kajites_veids = array();
		$ir_piemaksa = 0;		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			if ($row['kvietas_veids'] == 3 || $row['kvietas_veids']==6 || $row['kvietas_veids']==7){
				$ir_piemaksa = 1;
				break;
			}
		}	
		return $ir_piemaksa;
	 }
	 
	 //atgrieþ dalîbnieka rezervçto kajîti
	 function GetDid($did,$online_rez_id){
	
		$qry = "SELECT kid FROM piet_saite WHERE deleted=0 AND pid IN (SELECT id FROM pieteikums WHERE online_rez=?) AND kid IS NOT NULL AND kid<>3 AND kid<>6 AND kid<>7";
		$params = array($online_rez_id);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
			echo "<br><br>";
		}

		$result = $this->db->Query($qry,$params);
		//$kajite = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kajite = $row['kid'];
		}
		return $kajite;
		
	 }
	 
	 //atgrieþ, ar ko kopâ dalîbnieks ir ielikts istabiòâ
	function GetKaimini($kid,$did,$online_rez){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$qry = "SELECT ps.*,p.online_rez FROM piet_saite ps,pieteikums p 
				WHERE p.id=ps.pid 
				AND isnull(ps.kid,0)<>0 and ps.kvietas_veids<>6 and ps.kvietas_veids<>3 
				AND kid= ? AND ps.deleted!=1 AND p.deleted=0 AND ps.did!=?";
		$params = array($kid,$did);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
				
		$dalibnieku_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kaimins = $dalibn->GetId($row['did']);
			if (DEBUG){
				echo "Kaimiòð ".$row['did'].":<br>";
				print_r($kaimins);
				echo "<br>__________________________<br>";
			}
			//pârbauda, vai dalîbnieks ir no ðîs paðas rezervâcijas
			if ($online_rez == $row['online_rez']){
				//var attçlot dalîbnieka vârdu				
				$dalibnieku_arr[] = $kaimins['vards'].' '.$kaimins['uzvards'];
			}
			else{
				if (DEBUG){
					echo "kaiminja dzimte:<br>";
					var_dump($kaimins['dzimta']);
					echo "<br>";
				}
				/*if ($kaimins['dzimta'] == 's') $img = '<i>Sieviete</i>';
				elseif ($kaimins['dzimta'] == 'v') $img= '<i>Vîrietis</i>';
				else $img = '<i>Cits</i>';*/
				$img = "<i>Cits ceïotâjs</i>";
				$dalibnieku_arr[] = $img;
				
				//$this->GetDzimtaImg($kaimins['dzimta']);
			}			
		}
		if (DEBUG){
			echo "kaimiòu arr:<br>";
			print_r($dalibnieku_arr);
			echo "<br>________________________<br>";
		}
		return $dalibnieku_arr;		
	
	}
	
	//atgrieþ visas rezervâcijâ rezervçtâs kajîtes
	function GetKidOnlineRez($online_rez){
		$qry = "SELECT DISTINCT ps.kid FROM piet_saite ps,pieteikums p 
				WHERE p.id=ps.pid 
				AND isnull(ps.kid,0)<>0 and ps.kvietas_veids<>6 and ps.kvietas_veids<>3 
				AND ps.deleted!=1 AND p.deleted=0 AND p.online_rez=?";
		$params = array($online_rez);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
				
		$kid_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kid_arr[] = $row['kid'];
		}
		return $kid_arr;
	}	

		//ATGRIEÞ VIENÂ LÎGUMÂ ESOÐÂS KAJÎTES
	function GetKidLigumsId($ligums_id){
		$qry = "SELECT DISTINCT ps.kid FROM piet_saite ps,pieteikums p 
				WHERE p.id=ps.pid 
				AND isnull(ps.kid,0)<>0 and ps.kvietas_veids<>6 and ps.kvietas_veids<>3 
				AND ps.deleted!=1 AND p.deleted=0 AND p.ligums_id=?";
		$params = array($ligums_id);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
				
		$kid_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kid_arr[] = $row['kid'];
		}
		return $kid_arr;
	}

}
?>