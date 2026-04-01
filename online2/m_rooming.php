<?
class Rooming {
	var $db;
	var $der = array();
	var $der_veidu_skaits = array();
	var $dalibn_arr = array();
											
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;	
		
	}
	//atgrieþ informâciju par brîvajiem viesnîcu numuriòiem
	function GetAvailable($online_rez_id,$gid,$res_dalibn_arr){
		$this->dalibn_arr = $this->GetDalibnData($online_rez_id);
		/*echo "dalibn_arr<br>";
		print_r($this->dalibn_arr);
		echo "<br><br>";*/
		//ja kâds jau ir ievietots:
		if (!$this->NoneAccomodated($this->dalibn_arr)){
			/*echo "ATgrieþ sesijâ saglabâto viesnîcu masîvu:<br>";
			print_r($_SESSION['reservation']['viesnicas']);
			echo "<br>========================<br>";
			return $_SESSION['reservation']['viesnicas'];*/
		}
		
		
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		require_once('m_viesnicas.php');
		$viesn = new Viesnicas();
		
		$params = array();
		$params[] = $gid;
		
		$qry = "SELECT v.veids,v.id,vv.vietas,vv.pilns_nosaukums,vv.nosaukums,vv.pieejams_online,vv.pieaug_vietas,vv.bernu_vietas
				FROM viesnicas v,viesnicas_veidi vv
				WHERE v.gid=?			
				AND v.veids = vv.id
				AND vv.pieejams_online = 1
				";		
		//echo $qry;
		//var_dump($params);
		$result = $this->db->Query($qry,$params);		
		
		
		$vietu_veidi = array();
		$veidu_skaits = array();
		
		$dalibn_skaits = count($this->dalibn_arr);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			/*echo "istabiòa:<br>";
			print_r($row);
			echo "<br><br>";*/
			$vietas_id = $row['id'];
			$kopa_vietas= $row['vietas'];
			$qry = "SELECT COUNT(ID) as aiznemtas FROM piet_saite WHERE vid=? AND deleted!=1";
			
			$par = array($vietas_id);
			$res = $this->db->Query($qry,$par);
			
			if( $row_skaits = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				/*echo "<br>skaits";
				print_r($row_skaits);
				echo "<br><br>";*/
				$aiznemtas_vietas = $row_skaits['aiznemtas'];
				
			}		
			
			$pieejams = false;
			//twinus var pusaizòemtus, pârçjos - pilnîgi brîvus
			$key = strtoupper($row['nosaukums']);
			//echo "key:".$key."<br>";
			//echo "aiznemts:".$aiznemtas_vietas."<br>";
			$veids = $row['nosaukums'];
			$kopa_ar = array();
			$ievietoti = array();
			$der = 0;
			if ($aiznemtas_vietas==0) {
				
				$pieejams = true;
				
			}
			else{
				//pârbauda, vai aizòemtâs vietas nepieder kâdam no tâs paðas rezervâcijas
				/*$qry = "SELECT did from piet_saite where vid=? AND deleted!=1 AND did in (".implode(",",$res_dalibn_arr).")";
				echo $qry;
				$par = array($vietas_id);
				print_r($par);
				$res = $this->db->Query($qry,$par);
				
				echo "row count: $row_count <br>";
				if (sqlsrv_has_rows($res)){
					echo 'ir';
					$pieejams = true;
					$key .= "|".$vietas_id;
					$der = 1;
					
					while($row_k = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ){
						$kaimins = $dalibn->GetId($row_k['did']);
						$kopa_ar[] = array('kopa_ar_dzimums' => $kaimins['dzimta'],
														'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
														'kopa_ar_savejo' => 1,
														'kopa_ar_did' => $row_k['did'],
														'kopa_ar_berns' => 0);
					}
					
				}
				else{*/
					if ($key=='TWIN' && $aiznemtas_vietas == 1){
						
						$kaimins = $this->GetKaimins($vietas_id);
						/*echo "kaimiòð:<br>";
						var_dump($kaimins);
						echo "<br><br>";*/
						$did = $kaimins['ID'];
						$dzimta = $kaimins['dzimta'];
						if (!empty($dzimta)){

							$kopa_ar[] = $this->GetKopaAr($did,0);
							$ievietoti[] =  $did;
							/*echo "kopâ arrr:<br>";
							var_dump($kopa_ar);
							echo "<br><br>";*/
							$key = "TWIN|".$dzimta;
							$veids = "TWIN|".$dzimta;
							$pieejams = true;	
							
						}
					}
				//}			
			}
			//saskaita cik no ðî veida jau ir => nepiedâvâ no viena veida vairâk nekâ ir dalîbnieku
			if (!isset($veidu_skaits[$key])){
				$veidu_skaits[$key] = 0;
				$this->der_veidu_skaits[$key] = 0;
			}
			else{
				
			}
			/*echo "Veidu skaits:<br>"; 
			var_dump($veidu_skaits);
			echo "<br><br>";
			echo "dalibn skaits: $dalibn_skaits <br>";
			echo "ir pieejams: $pieejams <br>";*/
			
			if ($pieejams && $veidu_skaits[$key] <= $dalibn_skaits){	
				//echo "Liekam iekðâ<br>";			
				
				$veidu_skaits[$key]++;
				
				if (strpos($veids, 'DOUBLE') === 0){
					$vietas_s = 1;
					$vietas_v = 1;
				}
				else {
					$vietas_v = null;
					$vietas_s = null;
				}
				/*if (array_key_exists($key,$vietu_veidi)){
					$skaits = $vietu_veidi[$key]['skaits'] + 1;
				}
				else $skaits = 1;*/
				//TODO - ielasâm visas istabas, arî vienâda veida, vienîgais smazinâm skait ar viena veida istabâm, lai tas nepârsniedz dalîbnieku skaitu
			
				$vietu_veidi[$vietas_id]['vietas_kopa'] = $kopa_vietas;
				$vietu_veidi[$vietas_id]['vietas_aiznemtas'] = $aiznemtas_vietas;
				$vietu_veidi[$vietas_id]['veids'] = $veids;
				$vietu_veidi[$vietas_id]['nosaukums'] = $row['pilns_nosaukums'];									
				$vietu_veidi[$vietas_id]['vietas_bernu'] = $row['bernu_vietas'];//$viesn->GetBernuVietas($vietas_id);
				$vietu_veidi[$vietas_id]['vietas_pieaug'] = $row['pieaug_vietas'];				
				//$vietu_veidi[$vietas_id]['skaits'] = $skaits;
				//$vietu_veidi[$vietas_id][] = array('vietas_id'=>$vietas_id,'kopa_ar'=>$kopa_ar);
				$vietu_veidi[$vietas_id]['vietas_id'] = $vietas_id;
				$vietu_veidi[$vietas_id]['kopa_ar'] = $kopa_ar;	
				$vietu_veidi[$vietas_id]['der'] = 0;
				//$vietu_veidi[$vietas_id]['tips'] = $key;
				$vietu_veidi[$vietas_id]['ievietoti'] = $ievietoti;
				$vietu_veidi[$vietas_id]['vietas_s'] = $vietas_s;
				$vietu_veidi[$vietas_id]['vietas_v'] = $vietas_v; 
				
			}	
			
		}
		/*echo "<br><b>GET DALIBN DATA: vietu_veidi</b>:<br>";
		print_r($vietu_veidi);
		echo "<br>============<br>";*/
		//îpaðaie gadîjumi:
		//ja viens cilvçks, tad nepiedâvâ pilnu TWIN, ja ir pieejams tâ paða dzimuma pustwins
		//Ja ir divi dalibnieki un viens ir izvelejies double, bet otrs neko, otram piedava tikai doubli
		//Ja ir pusaizòemts numuriòð un rezervâcijâ palicis tikai 1 dalîbnieks nelielikts, tad nerâda tâdu paðu tukðu numuriòu.
		
		//=====================//////////////
		
		
		//pârbauda, kuras istabinjas varçs aizpildît un atmet liekâs:
		$this->FillRoom($vietu_veidi,$this->dalibn_arr);
		$vietu_veidi = $this->der;
		/*echo "<br><b>vietu_veidi beigâs</b>:<br>";
		print_r($vietu_veidi);
		echo "<br>============<br>";*/
		$_SESSION['reservation']['viesnicas'] = $vietu_veidi;
		return $vietu_veidi;
	}
	
	function GetKopaAr($did,$savejais){
		/*echo "did:<br>";
		var_dump($did);*/
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$d = $dalibn->GetId($did);
		/*echo "Iemîtnieks:<br>";
		var_dump($d);
		echo "<br><br>";*/
		$dzimta = $d['dzimta'];
		$berns = $dalibn->IsChild($did);
		if ($savejais){
			$kopa_ar_savejo = 1;
			$kopa_ar_nos = $d['vards'].' '.$d['uzvards'];
		}
		else{
			$kopa_ar_savejo = 0;
			if ($dzimta == 's')
				$kopa_ar_nos = 'Sieviete';
			elseif ($dzimta == 'v')
				$kopa_ar_nos = 'Vîrietis';
		}
		$kopa_ar = array('kopa_ar_dzimums' => $dzimta,
						'kopa_ar_nosaukums' => $kopa_ar_nos,
						'kopa_ar_savejo' => $kopa_ar_savejo,
						'kopa_ar_did' => $did,
						'kopa_ar_berns' => $berns);
		return $kopa_ar;
	}
	//atgrieþ rezervâcijas dalîbnieku dzimumu, vecumu priekð ievietoðanas viesnîcâ
	function GetDalibnData($online_rez_id){
		require_once("m_grupa.php");		
		$gr = new Grupa();
		require_once('m_online_rez.php');
		$online_rez = new OnlineRez();
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		
		//dabû ceïojuma beigu datumu vecumu rçíinâðanai
		$gid = $online_rez->GetGidId($online_rez_id);
		$grupa = $gr->GetId($gid);
		$beigu_dat = $grupa['beigu_dat'];
		//var_dump($beigu_dat);
		
		$dalibnieki = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id'],1);
		//var_dump($dalibnieki);
		//dabû pârçjo ceïotâju datus priekð 
		$data = array();
		foreach($dalibnieki as $row){
			//print_r($row);
			$did = $row['ID'];
			$age = $dalibn->GetAge($did,$beigu_dat);
			//var_dump($did);
			//$data['dalibnieki'][] = $dalibn->GetId($did);
			$dalibnieks = array('id' => $did,
						'vards' => $row['vards'].' '.$row['uzvards'],
						'dzimums' => $row['dzimta'],
						'vecums' => $age,
						'ievietots' => 0,
						);
			$data[] = $dalibnieks;
		
		}
		//sakârto pçc vecuma dilstoðâ secîbâ:
		$this->SortByAge($data);
		return $data;
	}
	function searchArray($array, $key, $value)
	{
		$results = array();

		if (is_array($array)) {
			if (isset($array[$key]) && $array[$key] == $value) {
				$results[] = $array;
			}

			foreach ($array as $subarray) {
				$results = array_merge($results, $this->searchArray($subarray, $key, $value));
			}
		}

		return $results;
	}

	function SortByAge(&$people){
		$sortArray = array(); 

		foreach($people as $person){ 
			foreach($person as $key=>$value){ 
				if(!isset($sortArray[$key])){ 
					$sortArray[$key] = array(); 
				} 
				$sortArray[$key][] = $value; 
			} 
		}

		$orderby = "vecums"; //change this to whatever key you want from the array 

		array_multisort($sortArray[$orderby],SORT_DESC,$people); 

	}
	/*
	global der[1..vn] – globâls viesnîcu masîvs, atzîmçsim viesnicas kuras jârâda sarakstâ
v[1..vn] – lokâls viesnîcu masîvs
p[1..pn] – lokâls personu masîvs
*/
	//Aizpildît istabu
	function FillRoom($v,$p,$vstart = 0){
		//$vietu_veidi = array();
		/*echo "FIllroom<br>";
		print_r($v);
		echo "<br>";*/
		$vKeys = array_keys($v);

		for($vx=$vstart;$vx<count($v);$vx++){
			$room = $v[$vKeys[$vx]];
		/*	echo 'tekoðâ istaba:<br>';
			print_r($room);
			echo "<br><br>";*/
			//istaba tukða
			if ($room['vietas_aiznemtas'] < $room['vietas_kopa']){
				//$v2 = array();
				//$p2 = array();
				/*echo "p pirms accomodate person:<br>";
				print_r($p);
				echo "<br><br>";*/
				$result = $this->AccomodatePerson($v,$v2,$p,$p2,$vx);
				if ($result == 1){
					if ($this->EveryoneAccomodated($p2)){
						/*echo "v2 pirms rooming correct:<br>";
						print_r($v2);
						*/
						echo "==================GOOD=================";
						if ($this->RoomingCorrect($v2,$error)){							
							$this->MarkValidRooms($v2); // mainam globâlo rezultâtu masîvu
						}
						else echo 'rooming incorrect<br>';
					}
					else{
						//echo "<b>Rekursîvais izsaukums</b><br>";
						for ($vy = 0;$vy<count($v);$vy++){
							$room_y = $v2[$vKeys[$vy]];		
							if ($room_y['vietas_aiznemtas'] < $room_y['vietas_kopa']){
								echo "<b>Ieiet FillRoom</b><br>";
								$this->FillRoom($v2,$p2,$vy);// rekursîvais izsaukums
								echo "<b>Iziet FillRoom</b><br>";
							}
						}
					}
				}			
			}
			//else echo "vietas aiznemtas, apstradajam nakamo<br>";
		}
		
		//return $vietu_veidi_new;
	}
	
	//Ievietot cilvçkus
	function AccomodatePerson($v,&$v2,$p,&$p2,$vx){	
		
		echo "<br><b>AccomodatePerson:".$vx."</b><br>";
		require_once('m_dalibn.php');
		$dalibnieki = new Dalibn();
		$vKeys = array_keys($v);		
	
		//funkcija nokopç v => v2 un p=>p2 un veic izmaiòas tikai v2 un p2 masîvos. 
		$v2 = $v;
		$p2 = $p;		
		
		$room = $v[$vKeys[$vx]];
		/*echo '<br>room iekð accomodate person:<br>';
		print_r($room);
		echo "<br><br>";*/
		
		$accomodate = false;
		$vietas_aiznemtas = $room['vietas_aiznemtas'];
		/*
			mçìina ievietot cilvçkus numuriòâ vx
		sâk ievietot pieauguðos, ja pieauguðo ievietot vairs nevar, mçìina ievietot bçrnus ja tâdi ir
		*/	
		//foreach($p2 as $key=>$dalibn){
		for($px=0;$px<count($p2);$px++){
			$accomodate = $this->PlacePerson($v,$v2,$p,$p2,$vx,$px);
			/*			
			PlacePerson($v,&$v2,$p,&$p2,$vx,$px)
			
				PlaceTwinS
				PlaceTwinV
				PlaceDouble
				PlaceGeneral
			*/
		}
		
		if ($room['veids'] == 'TWIN'){
			/*echo "TWINAM PÂRBAUDE, vai visas vietas aizòemtas<br>";
			echo $room['vietas_aiznemtas'];
			echo "<br><br>";*/
			//var bût aizòemta viena vai abas vietas twinam, lai uzskatîtu par derîgu
			if ($room['vietas_aiznemtas'] == 1 or $room['vietas_aiznemtas'] == 2){
				//echo 'pievienot var ðo twinu<br>';
				$accomodate = true;
			}
		}
		else if ($room['vietas_aiznemtas'] == $room['vietas_kopa']){
			$accomodate = true;
		}
			

		/*echo "p2 iekð accomodatePerson:<br>";
		print_r($p2);
		echo "<br><br>";*/
		
		
		$this->DebugPrintRoom($v2,$p2);
			
		if ($accomodate){
			
			foreach ($v2 as $key=>$room2){
				if ($room2['vietas_id'] == $room['vietas_id']){
					$v2[$key]['vietas_aiznemtas'] = $room['vietas_aiznemtas']; 
				}
			}
			
			/*echo "v2 pçc accomodate person:<br>";
			print_r($v2);
			echo "<br><br>";*/
			$v2[$vKeys[$vx]]['der'] = 1;
			return 1;
		}
		else{
			$v2[$vKeys[$vx]]['der'] = 0;
			return false;
		}
		/*
		masîvâ p2 atzîmç ievietotos cilvçkus
		masîvâ v2 atzîmç izmaiòas par aizpildîto numuriòu
		ja viesnica aizpildîta korekti atgrieþ 1, ja ne 0
		*/
	
	}
	
	//Ievietot cilvçku
	function PlacePerson($v,&$v2,$p,&$p2,$vx,$px){
		$vKeys = array_keys($v);
		$dalibn = $p2[$px];
		$room = $v2[$vKeys[$vx]];
		
		echo '<b>dalîbnieks, kuru mçìina ievietot:</b><br>';
		var_dump($dalibn);
		echo "<br><br>";
		
		$ievietot = false;
		//ja dalîbnieks vçl nav ievietots kâdâ istabiòâ jau iepriekð
		if (empty($dalibn['ievietots'])){			
			//echo 'dalibnieks vel nav ievietots<br>';			
			//kamçr istabiòâ ir vieta
			if ($vietas_aiznemtas < $room['vietas_kopa']){
				$did = $dalibn['id'];
				
				//pusaizòemts twins - salîdzina dzimumus
				if (strpos($room['veids'], 'TWIN|') === 0) {
					$tmp_arr = explode("|",$room['veids']);	
					$kaimins_dzimums = $tmp_arr['1'];					
					if ($kaimins_dzimums == "s"){
						$ievietot = $this->PlaceTwinS($dalibn);
					}
					else if ($kaimins_dzimums == "v"){
						$ievietot = $this->PlaceTwinV($dalibn);
					}
				}
				elseif (strpos($room['veids'], 'DOUBLE') === 0){	
					$ievietot  = $this->PlaceDouble($dalibn,$room);
					
				}
				else{
					$ievietot = $this->PlaceGeneral($dalibn,$room);
				}				
				
				if ($ievietot){
					switch($ievietot){
						//ielikta sieviete
						case "s":
							$v2[$vKeys[$vx]]['vietas_s'] = 0;
							$v2[$vKeys[$vx]]['vietas_pieaug']--;
							break;
						//ielikts vîrietis
						case "v":
							$v2[$vKeys[$vx]]['vietas_v'] = 0;
							$v2[$vKeys[$vx]]['vietas_pieaug']--;
							break;
						//ielikts pieauguðais
						case "p":					
							$v2[$vKeys[$vx]]['vietas_pieaug']--;
							break;
						//ielikts bçrns
						case "b":
							$v2[$vKeys[$vx]]['vietas_bernu']--;
							break;
					}
					//echo "IEVIETOJAM DALÎBNIEKU!<br>";
					$p2[$px]['ievietots'] = $room['vietas_id'];
					//var_dump($p2[$key]['ievietots']);
					//echo "<br>++++++++++++++<br><br>";
					//array_push($v2[$vKeys[$vx]]['kopa_ar'],$this->GetKopaAr($did,1));
					array_push($v2[$vKeys[$vx]]['ievietoti'],$did);
					$v2[$vKeys[$vx]]['vietas_aiznemtas']++;
				}				
			}
			else{
				
			}
		}
		else{
			//echo 'dalîbnieks jau ir ievietots, nemçìina viòu ðeit ievietot<br>';
			//if ($dalibn['ievietots'] == $room['vietas_id']) return true; 
		}
		
		return $ievietot;
	}
	
	function PlaceTwinS($dalibn){
		require_once('m_dalibn.php');
		$dalibnieki = new Dalibn();
									
		//jasakrît dzimumam un jâbût vecâkam par 14 gadiem
		if ($dalibn['dzimums'] == "s" && !$dalibnieki->IsChild($dalibn['id'],14)){
			$did = $dalibn['id'];
			//var ievietot								
			//echo "var ievietot TWINÂ<br>";
			//echo "IEVIETOJAM DALÎBNIEKU!<br>";
			//$accomodate = true;
			
			
			return "p";								
		}
		else return false;
	}
	
	function PlaceTwinV($dalibn){
		require_once('m_dalibn.php');
		$dalibnieki = new Dalibn();
									
		//jasakrît dzimumam un jâbût vecâkam par 14 gadiem
		if ($dalibn['dzimums'] == "v" && !$dalibnieki->IsChild($dalibn['id'],14)){
			//var ievietot								
			//echo "var ievietot TWINÂ<br>";
			//echo "IEVIETOJAM DALÎBNIEKU!<br>";
			//$accomodate = true;
			
			return "p";									
		}
		else return false;
	}
	
	function PlaceDouble($dalibn,$room){
		require_once('m_dalibn.php');
		$dalibnieki = new Dalibn();
		$accomodate = "";
		//pieauguðais							
		if (!$dalibnieki->IsChild($dalibn['id'],18)){
			//pârbauda, vai ir vçl pieauguðo vietas
			//echo "pieauguðo vietu_skaits:".$room['vietas_pieaug']."<br>";
			if ($room['vietas_pieaug'] > 0){
				//echo 'vçl ir palikuðas pieauguðo vietas - var likt<br>			
				//pârbauda pieauguðâ dalîbnieka dzimumu
				if ($dalibn['dzimums'] == 's'){										
					/*echo "sieviete!<br>";
					print_r($room);
					echo "<br>";*/
					if ($room['vietas_s'] == 1){
						$accomodate = "s";
						//$ievietot = true;	
						//$room['vietas_s'] = 0;
						//$room['vietas_pieaug']--;
					}
				}
				else if ($dalibn['dzimums'] == 'v'){					
					if ($room['vietas_v'] == 1){
						$accomodate = "v";
						//$ievietot = true;	
						//$room['vietas_v'] = 0;
						//$room['vietas_pieaug']--;												
					}
				}
				
				
			}			
		}
		//bçrns lîdz 16 gadiem
		elseif ($dalibnieki->IsChild($dalibn['id'],16)){
			if ($room['vietas_bernu'] > 0){	
				$accomodate = "b";			
				//$ievietot = true;									
				//$room['vietas_bernu']--;
			}									
		}
		return $accomodate;
							
	}
	
	function PlaceGeneral($dalibn,$room){
		require_once('m_dalibn.php');
		$dalibnieki = new Dalibn();
		$ievietot = false;
		//pieauguðais							
		if (!$dalibnieki->IsChild($dalibn['id'],18)){
			//pârbauda, vai ir vçl pieauguðo vietas
			//echo "pieauguðo vietu_skaits:".$room['vietas_pieaug']."<br>";
			if ($room['vietas_pieaug'] > 0){
				//echo 'vçl ir palikuðas pieauguðo vietas - var likt<br>';		
				$ievietot = "p";	
				//$room['vietas_pieaug']--;
				
			}			
		}
		//bçrns lîdz 16 gadiem
		elseif ($dalibnieki->IsChild($dalibn['id'],16)){
			if ($room['vietas_bernu'] > 0){									
				$ievietot = "b";									
				//$room['vietas_bernu']--;
			}
			else{
				//ja nav double, var likt bçrnu pieauguðâ vietâ
				if ($room['vietas_pieaug']>0){
					$ievietot = "p";									
					//$room['vietas_pieaug']--;
					
				}
			}								
		}
		//16-18 gadi - var likt tikai pieauguðo vietâs, bet ne DOUBLE!
		else{
			//ja nav double, var likt bçrnu pieauguðâ vietâ
			if ($room['vietas_pieaug']>0){
				$ievietot = "p";									
				//$room['vietas_pieaug']--;									
			}								
		}	
		return $ievietot;
	}
	//pârbauda, vai vçl neviens nav ievietots
	function NoneAccomodated(){
		$online_rez_id = $_SESSION['reservation']['online_rez_id'];
		require_once('m_online_rez.php');
		$online_rez = new OnlineRez();
		$dalibnieki = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id'],0,1);
		foreach($dalibnieki as $did){
			if($this->DalibnHasRoom($online_rez_id,$did)){				
				return false;
			}			
		}		
		return true;
	}
	
	//visi jau ir ievietoti
	function EveryoneAccomodated($p2){
		/*echo "<b>EveryoneAccomodated?</b><br>";
		echo "dalibnieki:<br>";
		print_r($p2);
		echo "<br><br>";*/
		
		foreach($p2 as $dalibn){
			if(empty($dalibn['ievietots'])) {
				//echo 'NO<br>';
					return false;
			}			
		}
		
		//echo "YUP<br>";
		return true;
	}
	
	//saòem datus no loadrooming ja ir ja savietoti. Fillroom ietvaros saòem masîvu vienkârði
	function RoomingCorrect($v2,&$error){
		//echo "Rooming correct<br>";
		$error = array();
		
		//visiem numuriem jâbût pilnîgi aizòemtiem (vai tukðiem) !izòemot TWIN	
		foreach($v2 as $room){
			/*echo "pârbaudâmâ istaba:<br>";
			print_r($room);
			echo "<br>";*/
			if ($room['vietas_aiznemtas'] != 0){
				
				if (!(strpos($room['veids'], 'TWIN') === 0)) {
					if ($room['vietas_aiznemtas'] != $room['vietas_kopa']){
						$error['nepilns'] = 'Kïûda: Numuriòð nav aizpildîts pilnîbâ.';
						echo "Nav aizòemtas visas vietas!! <br>";
						return false;
					}					
				}
				
				//DOUBLE pârbaudes
				if (strpos($room['veids'], 'DOUBLE') === 0){
					
					$result = $this->ValidateDouble($room,$error);
					if (!$result){
						echo "KÏÛDA DOUBLE AIZPILDÎJUMÂ<br>";
						return false;	
						
					} 			
				}
				
				//TWIN pârbaudes
				if (strpos($room['veids'], 'TWIN') === 0) {
					//echo "validçjam twinu<br>";
					$result = $this->ValidateTwin($room,$error);
					
					if (!$result){echo "Kïûda ar twinu!";return false;}
					
				}
				//else echo "ðis nav twins!";				
			}			
		}
		return true;
	}
	
	
	function ValidateDouble($room,&$error){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$ir_s = false;
		$ir_v = false;
		foreach($room['ievietoti'] as $did){
			//vai nav no citas rezrevâcijas
			if (!$this->DalibnIsInRes($did)){
				$error['dazadi_dzimumi_double'] = 'Kïûda: divvietîgâ numuriòâ ar kopîgu gultu ir dalîbnieki no daþâdâm rezervâcijâm. Lûdzu, sazinieties ar IMPRO.';
				echo "dalîbnieks doublâ no citas rezervâcijas!<br>";
				return false;
			} 
			
			//vai ir pilngadîgs
			if ($dalibn->IsChild($did,18)){
				// ja tas ir bçrns lîdz 16 gadiem, tad var likt, ja ir bçrnu vietas
				if ($dalibn->IsChild($did,16)){
					echo "lîdz 16 gadiem<br>";
					print_r($room);
					echo "<br>";
					//pârbauda, vai numuriòam ir brîva bçrna vieta
					if ($room['vietas_bernu'] > 0){
						$room['vietas_bernu']--;
					}
					else{
						$error['nepilngadigs_double'] = 'Kïûda: divvietîgâ numuriòâ ar kopîgu gultu ir dalîbnieks, kas nav pilngadîgs. Lûdzu, sazinieties ar IMPRO.';
						echo "dalîbnieks doublâ nav pilngadîgs";
						return false;
					}
				}
				else{
					$error['nepilngadigs_double'] = 'Kïûda: divvietîgâ numuriòâ ar kopîgu gultu ir dalîbnieks, kas nav pilngadîgs. Lûdzu, sazinieties ar IMPRO.';
					echo "dalîbnieks doublâ nav pilngadîgs";
					return false;
				}
			}
			$d = $dalibn->GetId($did);
			echo "dalîbnisss<br>";
			print_r($d);
			echo "<br>";
			if ($d['dzimta'] == 's') $ir_s = true;
			if ($d['dzimta'] == 'v') $ir_v = true;
		}
		//vai ir pretçji dzimumi 
		if (!($ir_s && $ir_v)){
			$error['dazadi_dzimumi'] = 'Kïûda: divvietîgâ numuriòâ ir dalîbnieki no daþâdâm rezervâcijâm ar atðíirîgiem dzimumiem. Lûdzu, sazinieties ar IMPRO.';
			echo "DOUBLE ievietotie dalîbnieki nav ar daþâdiem dzimumiem";
			return false;
		}	
		return true;
	}
	
	function ValidateTwin($room,&$error){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		echo "Validate twin<br>";
		if (count($room['ievietoti']) == 2){
			echo "ievieti 2<br>";
			//pârbauda, vai nav kâds no citas rezervâcijas
			$dazadas_res = false;
			$ir_s = false;
			$ir_v = false;
			foreach ($room['ievietoti'] as $did){
				if (!$this->DalibnIsInRes($did)){
					$dazadas_res = true;;
				} 
				$d = $dalibn->GetId($did);
				
				if ($d['dzimta'] == 's') $ir_s = true;
				if ($d['dzimta'] == 'v') $ir_v = true;
			}
			
			//ja ir no daþâdâm rezrevâcijâm - jâsakrît dzimumiem
			if ($dazadas_res){
				if ($ir_s && $ir_v){
					$error['dazadi_dzimumi'] = 'Kïûda: divvietîgâ numuriòâ ir dalîbnieki no daþâdâm rezervâcijâm ar atðíirîgiem dzimumiem. Lûdzu, sazinieties ar IMPRO.';
					echo "TWIN daþâdu dzimumu cilvçki no daþâdâm rezervâcijâm";
					return false;
				}				
			}
		}
		return true;
	}
	
	function DalibnIsInRes($did){
		require_once('m_online_rez.php');
		$online_rez = new OnlineRez();

		$dalibnieki = $online_rez->GetDalibnList($_SESSION['reservation']['online_rez_id'],$_SESSION['profili_id'],0,1);
		/*echo "DALIBN IS IN RES: dalibnieki:<br>";
		print_r($dalibnieki);
		echo "<br><br>";
		echo "Dalîbnikes:<br>";
		var_dump($did);
		echo "<br><br>";*/
		if (in_array($did,$dalibnieki)) return true;
		else return false;
		
	}
	
	
	function MarkValidRooms($v2){
		echo 'mark valid rooms:<br>';
		print_r($v2);
		echo "<br>______________<br>";
		
		//ciik lîdz ðim ir jau pievienoti numuriòi no katra vietu veida
		$vietu_veidi_prev = array();
		foreach($this->der_veidu_skaits as $key=>$skaits){
			$vietu_veidi_prev[$key] = $skaits;
		}
		
		
		//cik plânots pievienot ðajâ ciklâ no katra vietu veida
		$veidu_skaits = array();
		foreach($v2 as $key=>$room){
			if ($room['der']){
				if (!isset($veidu_skaits[$room['veids']])){
					$veidu_skaits[$room['veids']] = 1;
				}
				else{
					$veidu_skaits[$room['veids']]++;
				}			
			}
			else{
				$veidu_skaits[$room['veids']] = 0;
			}
		}
		/*echo "viedu skaits:<br>";
		print_r($veidu_skaits);
		echo "<br><br>";*/
		
		//saglabâ maksimâlo skaitu, ko drîkst pievienot no viena veida
		foreach($v2 as $key=>$room){
			if ($room['der']){
				
				if ($this->der_veidu_skaits[$room['veids']] < $veidu_skaits[$room['veids']]){
					//echo "ir mazâks<br>";
					$this->der_veidu_skaits[$room['veids']] = $veidu_skaits[$room['veids']];
				}
			}
		}
	/*	echo "der veidu skaits:<br>";
		print_r($this->der_veidu_skaits);
		echo "<br><br>";*/
		
		//pievieno numuriòus der masîvam
		$veidu_skaits = array();
		foreach($v2 as $key=>$room){
			if ($room['der'] && !array_key_exists($key,$this->der)){
				if (!isset($veidu_skaits[$room['veids']])){
					$veidu_skaits[$room['veids']] = $vietu_veidi_prev[$room['veids']] + 1;
				}
				else{
					$veidu_skaits[$room['veids']]++;
				}
				//ja ðajâ ciklâ pievienoto viena veida numuriòu skaits nepârsniedz maksimâlo viena veida numuriòu skaitu:
				if ($veidu_skaits[$room['veids']] <= $this->der_veidu_skaits[$room['veids']] ){
					$this->der[$key] = $room;
					
				}
				
			}
				
			// number of rooms
			//foreach	
			//	if ($key==$key2)
		}
		
	/*	echo 'der pçc izmaiòâm:<br>';
		print_r($this->der);
		echo "<br><br>";
		*/
		
	}
	/*



global der[1..vn] – globâls viesnîcu masîvs, atzîmçsim viesnicas kuras jârâda sarakstâ un maksimâlo viesnicas numuriòu skaitu
v[1..vn] – lokâls viesnîcu masîvs
p[1..pn] – lokâls personu masîvs

funkcija aizpildît_istabu(v,p,vstart)
	for vx=vstart to vn
		if istaba tukða
			result = ievietot_cilvçkus(v,&v2,p,&p2,vx)
			if result = 1
				if visi_cilveki_ievietoti(p2)
					if istabu_stâvoklis_ok(v2)
						atzimet_der(v2)	 // mainam globâlo rezultâtu masîvu
					end if
				else
					aizpildît_istabu(v2,p2,vx) // rekursîvais izsaukums
				end if
			end if
		end if	
	end for
end funkcija

funkcija ievietot_cilvçku(v,&v2,p,&p2,vx)
	funkcija nokopç v => v2 un p=>p2 un veic izmaiòas tikai v2 un p2 masîvos. 
	mçìina ievietot cilvçkus numuriòâ vx
	sâk ievietot pieauguðos, ja pieauguðo ievietot vairs nevar, mçìina ievietot bçrnus ja tâdi ir
	masîvâ p2 atzîmç ievietotos cilvçkus
	masîvâ v2 atzîmç izmaiòas par aizpildîto numuriòu
	ja viesnica aizpildîta korekti atgrieþ 1, ja ne 0

funkcija visi_cilvçki_ievietoti(p)
	atgrieþ 1 ja masîvâ visi cilvçki atzîmçti kâ ievietoti

funkcija istabu_stâvoklis_ok(v)
	pârbauda vai paðreizçjais istabu aizpildîjums ir pareizs. 
	viens tvins var bût bûs tukðs (vai ne?)
	pârçjâs istabas ir vai nu tukðas vai pilnîbâ aizpildîtas

funkcija atzîmçt_der(v)
	uzstâda pazîmi (uzstâda maksimâlo skaitu) globâlajâ istabu masîvâ der[] ka viòas var râdît klientam 
	iziet cauri visam masîvam v un tâs istabas kuras ir aizpildîtas v uzstâda kâ derîgas masîvâ
	
der[]

*/

	//pârbauda, vai dalîbneiks ir jau ievietots istabiòâ
	function DalibnHasRoom($online_rez_id,$did){
		require_once('m_pieteikums.php');
		$pieteikums = new Pieteikums;
		require_once("m_viesnicas.php");
		$viesn = new Viesnicas();
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		return $viesn->GetViesnica($pid);
		
	}
	function GetKaimins($vid){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$qry = "SELECT did from piet_saite WHERE deleted=0 AND vid=?";
		$params = array($vid);
		$result = $this->db->Query($qry,$params);
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$did = $row['did'];
			$kaimins = $dalibn->GetId($did);			
			return $kaimins;
		}		
	}
	
	//atgrieþ pretçju dzimumu pieauguðos no dalîbnieku masîva
	function GetAdultPair($p2){
		require_once('m_dalibn.php');
		$d = new Dalibn();
		//echo "getadultpair()<br>";
		$pair = array();
		$ir_s = 0;
		$ir_v = 0;
		foreach($p2 as $dalibn){
			if (empty($dalibn['ievietots'])){
				echo "nav ievietots<br>";
				if (!$d->IsChild($dalibn['id'])){
					echo "ir pilngadîgs<br>";
					if ($dalibn['dzimums']=='s'){
						$pair['s'] = $dalibn['id'];
						$ir_s = 1;
					}
					else if ($dalibn['dzimums']=='v'){
						$pair['v'] = $dalibn['id'];
						$ir_v = 1;
					}
				}
				//else echo "nepilngadîgs!<br>";
			}
			//else echo "ir jau ievietots<br>";
		}
	//	echo "atgrieþam adult pair rezultâtu:<br>";
		if ($ir_s && $ir_v){
			return $pair;
		}
		else return false;
		
		
	}
	
	
	function RemoveDidFromRoom($vid,$did,$online_rez_id){
	//	echo "remove did from room<br>";
		require_once('m_pieteikums.php');
		$pieteikums = new Pieteikums();			
		$pieteikums->DeleteVidDid($vid,$did,$online_rez_id);
		//sesijas datos veic izmaiòu - kopa_ar masîvu jâpamaina

		$room = $_SESSION['reservation']['viesnicas'][$vid];
		foreach($room['kopa_ar'] as $key=>$row){
			/*echo "drukâjam kopâ ar!<br>";
			print_r($row);
			echo "<br>";*/
			if ($row['kopa_ar_did'] == $did){
				//pârbaudît ðo!
				unset($_SESSION['reservation']['viesnicas'][$vid]['kopa_ar'][$key]);
			}
		}
	}
	
	//ieliek rezervâcijas dalîbnieku izstabiòâ, ja ir esoðie - tos izòem
	function BookRoomForDid($online_rez_id, $vid,$did,$aiznemis_did){
		require_once("m_pieteikums.php");
		require_once("m_kajite.php");
		require_once("m_online_rez.php");
		$kajites = new Kajite();
		$pieteikums = new Pieteikums();
		$online_rez = new OnlineRez();	
		
		//izòem iepriekðçjo iemîtnieku, ja tâds ir
		if ($aiznemis_did){		
			$this->RemoveDidFromRoom($vid,$aiznemis_did,$online_rez_id);
		}		

		//===================================//
		//saglabâ jauno istabiòu
		//===================================//
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		//vçstures saglabâðanai
		$old_vals = $pieteikums->GetId($pid);
		$old_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		$where_arr = array('pid' => $pid							
							);
							
		//vai ceïojumam ir pieejamas kajîtes		
		$gid = $online_rez->GetGidId($online_rez_id);
		$kajisu_veidi = $kajites->GetVeidiGid($gid);
		
		//ja ceïojumam ir pieejamas kajîtes
		if (count($kajisu_veidi)>0){
		
			$where_cond = "(deleted=0 AND ((kid IS NOT NULL AND kvietas_veids <>0 AND kvietas_veids<>3 AND kvietas_veids<>6 AND kvietas_veids<>7)))";
		}
		else
			$where_cond = "(deleted=0 AND ((summaEUR IS NULL AND vietas_veids IS NULL) OR (vid IS NOT NULL AND vid>0)))";
		if (DEBUG ){
			//echo "where cond: $where_cond <br>";
			//print_r($where_arr);
		}
		//pârbauda, vai dalîbniekam iepriekð jau nav bijusi cita istabiòa
		$old_vid = $this->DalibnHasRoom($online_rez_id,$did);
		/*echo "vecâ istabiòa:<br>";
		var_dump($old_vid);
		echo "<br>";*/
		if (!empty($old_vid)){
			$this->RemoveDidFromRoom($old_vid,$did,$online_rez_id);
		}
		$this->db->UpdateWhere('piet_saite',array('vid'=>$vid),$where_arr,$where_cond);
		//TODO: sesijas datos saglabât izmaiòu - kopa_ar masîvu jâpamaina
		$kopa_ar = $this->GetKopaAr($did,1);
		 $_SESSION['reservation']['viesnicas'][$vid]['kopa_ar'][] = $kopa_ar;
		
		//saglabâ pieteikuma izmaiòu vçsturi:
		$new_vals = $pieteikums->GetId($pid);
		$new_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);		

	}
	
	function LoadRooming($online_rez_id){//m_viesnicas fialâ attçlota kâ rezrevçtâs viesnicass
		require_once("m_viesnicas.php");
		$viesn = new Viesnicas();
		$radamo_ist_id = array();
		$istabas = $viesn->GetViesnicaAll($online_rez_id);
		if (DEBUG){
			echo "<b>Rezervçtâs Viesnîcas</b><br>";
			var_dump($istabas);
			echo "<br><br>";
		}
		
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");
		require_once("m_grupa.php");
		require_once("m_online_rez.php");
		
		$gr = new Grupa();
		$online_rez = new OnlineRez();
		$pieteikums = new Pieteikums();
		$dalibn = new Dalibn();
		
		$gid = $online_rez->GetGidId($online_rez_id);
		$grupa = $gr->GetId($gid);
		$beigu_dat = $grupa['beigu_dat'];	
		
		//dabû visu dalîbnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		
		$data['istabas'] = array();
		
		foreach ($istabas as $key=>$vid){
				if (!empty($vid)){
					if (!in_array($vid, $radamo_ist_id)){
						$did = $key;
						$viesnica = $viesn->GetId($vid);
						/*echo "Viesnica:";
						var_dump($viesnica);
						echo "<br><br>";
						*/
						$kaiminu_did_arr = $pieteikums->GetDidVid($vid);
						if (DEBUG){
							echo "Kaimiòi:";
							var_dump($kaiminu_did_arr);
							echo "<br><br>";
						}
						
						$kopa_ar_arr = array();
						foreach($kaiminu_did_arr as $did){
							
							
							if (in_array($did,$dalibn_id_arr)){
								$savejais = 1;
								
							}
							else {
								$savejais = 0;
								
								 
							}
							
							
							$kopa_ar_arr[]= $this->GetKopaAr($did,$savejais);
								
						}
						$bernu_vietas = $viesn->GetBernuVietas($vid);
						//tâtad visas vietas aizòemtas ðajâ istabiòâ
						$vieta = array ('vietas_id' =>$vid,
											'nosaukums' => $viesnica['pilns_nosaukums'],
											'kopa_ar' => $kopa_ar_arr,
											'vietas_bernu' => $bernu_vietas,
											'veids' => $viesnica['nosaukums'],
											'vietas_kopa' =>$viesnica['vietas'],
											'vietas_aiznemtas' => count($kaiminu_did_arr),
											'ievietoti' => $kaiminu_did_arr,
											);
									
							$data['istabas'][$vid]= $vieta;	
							$radamo_ist_id[] = $vid;							
								
						
					}
				}
			
		}
		uasort($data['istabas'], function ($i, $j) {					
					$a = $i['vietas_kopa'];
					$b = $j['vietas_kopa'];
					if ($a == $b) return 0;
					elseif ($a > $b) return 1;
					else return -1;
				});
		return $data['istabas'];
	}
	
	function DebugPrintRoom($v,$p){
		echo "<br>-----------------------------------------------------------------------------------------------------------</br>";
		echo "<b>Rooming:</b>";
		echo "<br>-----------------------------------------------------------------------------------------------------------</br>";
		foreach($v as $viesn){
			echo "<b>".$viesn['veids']."</b>:";
			//print_r($viesn);
			//echo "<br>";
			$ievietotie = array();
			foreach($viesn['ievietoti'] as $did){
				$dalibnieks = $this->searchArray($p,'id',$did);
				
				$dalibnieks = $dalibnieks[0];
				
				if (!empty($dalibnieks)){
					//$dalibnieks = $dalibn->GetId($did);
					$ievietotie[]= $dalibnieks['vards'].' '.$dalibnieks['uzvards'].'('.$dalibnieks['dzimums'].$dalibnieks['vecums'].')';
				}
			}
			echo implode(", ",$ievietotie);
			echo "<br>";
		}
		echo "=============================================================</br>";
		
	}
}
	?>