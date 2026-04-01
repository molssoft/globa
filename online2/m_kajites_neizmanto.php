<?
class Viesnicas {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;	
	}
	
	function GetId($id){
		$query = "SELECT viesnicas.id as vid,vv.*
					FROM viesnicas 
					LEFT JOIN viesnicas_veidi vv
						ON viesnicas.veids = vv.id 
					WHERE viesnicas.id = ? ";
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
	
	/*function AvailableList($count){
		$query = "SELECT g.ID,g.mID,g.sakuma_dat ,v.vietas
					FROM grupa g, vietas v
					WHERE g.sakuma_dat>getdate() 
					AND g.internets = 1 AND g.atcelta = 0
					AND	g.veids = 1 
					AND v.gid=g.ID
					AND v.vietas>=?
					ORDER BY g.sakuma_dat ASC";
		$params = array($count);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$grupas = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$grupas[] = $row;
			
		}
		return $grupas;
		
	}
	
	function AvailableId($id){
		$query = "SELECT g.ID,g.mID,g.sakuma_dat ,v.vietas
					FROM grupa g, vietas v
					WHERE g.sakuma_dat>getdate() 
					AND g.internets = 1 AND g.atcelta = 0
					AND	g.veids = 1 
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
	*/
	function GetVeidsGid($gid){
		//echo "GID:$gid<br>";
		$qry = "SELECT v.veids,vv.pilns_nosaukums,vv.nosaukums
				FROM viesnicas v,viesnicas_veidi vv
				WHERE v.gid=?
				AND v.veids = vv.id
				group by v.veids,vv.pilns_nosaukums,vv.nosaukums";
		//echo $qry."<br>";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$veidi[] = $row['nosaukums'];
			
		}
		return $veidi;
	}
	
	function GetAvailableGid($gid,$pid=0,$id=FALSE){
		//$gid=20850;
		$params = array();
		$params[] = $gid;
		if ($id){
			$where_id = 'v.id = ?';
			$params[] = $id;
		}
		else{
			$where_id = "1=1";
			
		}
		$qry = "SELECT v.veids,v.id,vv.vietas,vv.pilns_nosaukums,vv.nosaukums
				FROM viesnicas v,viesnicas_veidi vv
				WHERE v.gid=?
				AND $where_id
				AND v.veids = vv.id
				";
		//echo $qry;
		//print_r($params);
		//echo "<br><br>";
		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		unset($istabinas);
		$istabinas = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$vietas_id = $row['id'];
			$kopa_vietas= $row['vietas'];
			$qry = "SELECT COUNT(ID) as aiznemtas FROM piet_saite WHERE vid=? AND deleted!=1 AND pid!=?";
			
			$par = array($vietas_id,$pid);
			$res = $this->db->Query($qry,$par);
			if( $res === false) {
				
				die( print_r( sqlsrv_errors(), true) );
			}
			while( $row_skaits = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				//echo "<br>skaits";
				//print_r($row_skaits);
				$aiznemtas_vietas = $row_skaits['aiznemtas'];
				//echo "<br><br>";
			}
			//atgriež tikai tad, ja ir brīvas vietas numuriņā vai norādīts istabiņas ID
			if ($kopa_vietas > $aiznemtas_vietas || $id){
				$istabinas[$vietas_id]['vietas_kopa'] = $kopa_vietas;
				$istabinas[$vietas_id]['vietas_aiznemtas'] = $aiznemtas_vietas;
				$istabinas[$vietas_id]['veids'] = $row['nosaukums'];
				$istabinas[$vietas_id]['nosaukums'] = $row['pilns_nosaukums'];
				
			
				//pārbauda, vai ir norādīta papildus bērnu vieta
				//$re = "/[+][ ]{0,1}([S]+)/"; 
				$bernu_vietas = $this->GetBernuVietas($vietas_id);
				/*$re = "/\\+[ ]{0,1}([\\d]*)/"; 
				//$str = "nnvieta +1 vieta  f "; 
				//echo "<br>NOsakumums".$row['nosaukums']."<br<br>";
				preg_match($re,  $row['nosaukums'], $matches);
				//var_dump($matches);
				if (count($matches)>0){
					$bernu_vietas = ((int)$matches[1] >0 ? $matches[1] : 1);
				}
				else $bernu_vietas = 0;*/
				$istabinas[$vietas_id]['vietas_bernu'] = $bernu_vietas;
				//var_dump($matches);
				//echo "<br>ISTABIŅA:<br>";
				//var_dump($istabinas[$vietas_id]);
				//echo "<br><br>";
			}
		}
		return $istabinas;
	}
	
	//atgriež istabiņas brīvo vietu skaitu
	function GetOccupiedCountId($vid){

		$qry = "SELECT COUNT(ID) as aiznemtas FROM piet_saite WHERE vid=? AND deleted!=1";
			
			$par = array($vid);
			$res = $this->db->Query($qry,$par);
			if( $res === false) {
				
				die( print_r( sqlsrv_errors(), true) );
			}
			while( $row_skaits = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				//echo "<br>skaits";
				//print_r($row_skaits);
				$aiznemtas_vietas = $row_skaits['aiznemtas'];
				//echo "<br><br>";
			}
			return $aiznemtas_vietas;
	}
	
	
	
	//atgriež pieejamās istabiņas	
	function GetAvailable($online_rez_id){
		//----------viesn--------------------------------------------------//			
		/*
					select * from viesnicas_veidi where gid = 20378
		select * from viesnicas where gid= 20378
		select * from piet_saite where pid = 460048
		m_viesnicas

		-- viesnicu nevar piedāvāt
		-- ja nav brīvas tādas istabas
		-- ja rezervācijā ir viens cilvēks, tad nepiedāvā nekādas istabas kur ir vairāk par 2 cilvēki (3-uz augšu)
		-- vienam cilvēkam nepiedāva DOUBLE
		-- jebkuram cilvēkam var piedāvāt TWIN istabu ar tā paša dzimuma cilvēku
			-- jāizdrukā visi pusaizņemtie TWIN ar to pašu dzimumu
		-- ja ir 3 vai 4 vietas tad tādus numurus tikai ja rezervācija ir tikpat vai vairāk cilvēku
		-- ja viens cilvēks tad nepiedāvā pilnu TWIN ja ir pieejams tā paša dzimuma pustwins
		-- šķiet būs jāanalizē nosaukums
			-- ja nosakumā ir + zīme, tad aiz tās seko bērnu skaits (bērnu vietu)
			-- bērns vai iet pieaugušā vietā
			-- pieaugušais nevar iet bērna vietā
			
		-- TWIN var būt dažādu dzimumu cilvēki no vienas rezervācijas

		-- beigās validācija kad pēdējais cilvēks izvēlas viesnicu, tad visiem numuriem ar 3 vai vairāk vietām jābūt pilnīgi aizņemtiem

		--ja ir pusaizņemts numuriņš un rezervācijā palicis tikai 1 dalibnieks nelielikts, tad nerada tadu pasu tuksu numurinju
		*/
		require_once("m_online_rez.php");
		require_once("m_viesnicas.php");
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");
		require_once("m_viesnicas.php");
		require_once("m_grupa.php");
		$viesnicas = new Viesnicas();
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();
		$viesnicas = new Viesnicas();
		$online_rez = new OnlineRez();
		$gr = new Grupa();
		//dabū visu dalībnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		$_SESSION['reservation']['dalibn_id_arr'] = $dalibn_id_arr;
		/*echo "<br>dalībnieki:</br>";
		var_dump($dalibn_id_arr);
		echo "<br><br>";
		*/
		$istabinu_veidi = $viesnicas->GetVeidsGid($_SESSION['reservation']['grupas_id']);
		
		//atgriež 2 dimensiju asociatīvo masīvu ar katras istabiņas nosaukumu, kopējo/aizņemto/bērnu vietu skaitu
		$istabinas = $viesnicas->GetAvailableGid($_SESSION['reservation']['grupas_id']);
		/*echo "<br>ATGRIEZTĀS ISTABAS:<br>";
		var_dump($istabinas);
		echo "<br><br>";
		*/
		/*if (isset($mana_istaba)){
			$istabinas[] = $mana_istaba;
		}*/
		$radamas_istabas = array();
		//exit();
		//$mana_istaba = $viesnicas->GetAvailableGid($_SESSION['reservation']['grupas_id'],0,$data['istaba']);
		
		//dabū brauciena beigu datumu (vecuma rēķināšanai)							
	
		$grupa = $gr->GetId($_SESSION['reservation']['grupas_id']);
		$beigu_dat = $grupa['beigu_dat'];		
		
		
		//--------------------------ja rezervācijā ir 1 cilvēks-----------------//
		//no katra veida vajag vienu numuriņu. 
		if ($_SESSION['reservation']['traveller_count'] == 1){
			unset($pilns_twins);
			foreach($istabinas as $istabinas_id=>$istabina){
				
				//echo $istabina['vietas_kopa'];
				//echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				//--- nepiedāvā nekādas istabas kur ir vairāk par 2 cilvēki (3-uz augšu)--//
				if ($istabina['vietas_kopa']<=2){
					//echo "<=divvietiga<br>";
					// vienam cilvēkam nepiedāva DOUBLE
					if ($istabina['veids']!='DOUBLE'){
						//echo "nav double<br>";
						//jebkuram cilvēkam var piedāvāt TWIN istabu ar tā paša dzimuma cilvēku
						if ($istabina['veids'] == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas)){
							
							//ja ir pieejams pustwins
							if ($istabina['vietas_aiznemtas'] == 1){
								//echo "<br>viena vieta brīva<br><br>";
								//atrod, kas ir aizņēmis istabiņu
								foreach ($dalibn_id_arr as $active_did){
									$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									if (DEBUG){
										echo "kaimiņa did:<br>";
										var_dump($did_kaimina);
										echo "<br><br>";
									}
									if (!empty($did_kaimina)){
										$kaimins = $dalibn->GetId($did_kaimina[0]);
										/*echo "<br>Kaimiņš:<br>";
										var_dump($kaimins);
										echo "<br><br>";
										echo "<br>ES:<br>";*/
									
										$celotajs = $dalibn->GetId($active_did);
										//var_dump($celotajs);
										//echo "<br><br>";
										//ja sakrīt dzimumi, tad šo istabiņu var piedāvāt
										if ($kaimins['dzimta'] == $celotajs['dzimta']){											
											if ($kaimins['dzimta'] == 's')
												$kopa_ar = 'Sieviete';
											elseif ($kaimins['dzimta'] == 'v')
												$kopa_ar = 'Vīrietis';
											$ist = array('kopa_ar' => array(array('kopa_ar_dzimums' => $kaimins['dzimta'],
														'kopa_ar_nosaukums' => $kopa_ar,
														'kopa_ar_savejo' => 0,
														'kopa_ar_did' => $did_kaimina[0],
														'kopa_ar_berns' => 0)),
													'vietas_id' => $istabinas_id
													);
											
											$radamas_istabas['TWIN'][] = $ist;
											//echo "<br><br>pustvins ar ID <b>$istabinas_id</b><br><br>";
											//break;
										}
									}
								}
							}
							//visa istabiņa ir tukša
							elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
								//echo "2 vietas brīvas<br>";
								//atcerās šo istabiņu gadījumam, ja nebūs pieejams pustwins ar to pašu dzimumu
								$ist = array('kopa_ar' => array(),
												'vietas_id' => $istabinas_id
												);
								$pilns_twins = $ist;
							}
						
						}
						//SINGLE numuriņiem visticamāk
						elseif( !array_key_exists($istabina['veids'],$radamas_istabas)){
							$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
							$radamas_istabas[$istabina['veids']][] = $ist;
						}
					}
				}
				//-------------//
			}
			
			//ja ir pieejams twins
			//ja viens cilvēks tad nepiedāvā pilnu TWIN ja ir pieejams tā paša dzimuma pustwins
			if (in_array('TWIN',$istabinu_veidi)){
				//echo "ir pieejams TWINS<br>";
				//ja NAV pustvins atrasts, piedāvā pilno twinu
				if (!isset($radamas_istabas['TWIN']) && isset($pilns_twins)){
					if (DEBUG) echo "pilns twins";
					$radamas_istabas['TWIN'][] = $pilns_twins;
				}
			}
		}
		//---------END 1 ceļot.---------------------------------------------------------//
		
		
		//-----------------------------ja ir 2  ceļotāji--------------------------//
		if ($_SESSION['reservation']['traveller_count'] == 2){
			unset($pilns_twins);
			foreach($istabinas as $istabinas_id=>$istabina){
				
				//echo $istabina['vietas_kopa'];
				//echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				//----nepiedāvā nekādas istabas kur ir vairāk par 2 cilvēki (3-uz augšu)---//
				if ($istabina['vietas_kopa']<=2){
					//ja twins
					//jebkuram cilvēkam var piedāvāt TWIN istabu ar tā paša dzimuma cilvēku
					if ($istabina['veids'] == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas)){
							//ja pustukšs TWINS
							if ($istabina['vietas_aiznemtas'] == 1){
								//echo "<br>viena vieta brīva<br><br>";
								//pārbauda, kas ir aizņēmis istabiņu -
								foreach ($dalibn_id_arr as $active_did){
									/*echo "<br> Rādāmās istabas<br>";
									var_dump($radamas_istabas);
									echo "<br><br>";
									echo "<br>Istabinja<br>";
									var_dump($istabina);
									echo "<br><br>";
									*/
								//	if (!in_array($istabina,$radamas_istabas)){
									$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									/*echo "<br>Kaimiņš<br>";
									var_dump($did_kaimina);
									echo "<br><br>";*/
									//ja nav rezervējis šis pats cilvēks
									if (!empty($did_kaimina)){
										//ja arī otrs cilvēks ir no šīs pašas rezervācijas, tad var piedāvāt šo istabiņu
										if (in_array($did_kaimina[0],$dalibn_id_arr)){
										
										//ja rezervējis ir pats dalībnieks
										//if ($active_did!=$did_kaimina[0]){
											if (!array_key_exists('TWIN|ar_savejo',$radamas_istabas)){
												$kaimins = $dalibn->GetId($did_kaimina[0]);
												$birthday = $dalibn->Birthday($did_kaimina[0]);
												$diff = $beigu_dat->diff($birthday);
												$age = $diff->format('%y');
												if ($age<18) $berns = 1; else $berns=0;
												$ist = array('kopa_ar' => array(
														array('kopa_ar_dzimums' => $kaimins['dzimta'],
																'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
																'kopa_ar_savejo' => 1,
																'kopa_ar_did' => $did_kaimina[0],
																'kopa_ar_berns' => $berns,
																)),
													'vietas_id' => $istabinas_id
													);
													
												$radamas_istabas['TWIN|ar_savejo'][] = $ist;
										
										//}
										/*else{
											$radamas_istabas['TWIN']['kopa_ar'] = '';
											$radamas_istabas['TWIN']['vietas_id'] = $istabinas_id;
										}*/
												if (DEBUG) echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar savējo<br><br>";
												break;
											}
										}
										//ja no citas rezervācijas, pārbauda, vai sakrīt dzimums
										else{
											$kaimins = $dalibn->GetId($did_kaimina[0]);
											/*echo "<br>Kaimiņš:<br>";
											var_dump($kaimins);
											echo "<br><br>";
											echo "<br>ES:<br>";*/
											$celotajs = $dalibn->GetId($active_did);
											//var_dump($celotajs);
											//echo "<br><br>";
											//ja sakrīt dzimums, var piedāvāt šo numuriņu
											if ($kaimins['dzimta'] == $celotajs['dzimta']){
												if ($kaimins['dzimta'] == 's')
													$kopa_ar = 'Sieviete';
												elseif ($kaimins['dzimta'] == 'v')
													$kopa_ar = 'Vīrietis';
												if (!array_key_exists('TWIN|ar_'.$kaimins['dzimta'],$radamas_istabas)){
												$ist = array('kopa_ar' => array(
																	array('kopa_ar_dzimums' => $kaimins['dzimta'],
																		'kopa_ar_nosaukums' => $kopa_ar,
																		'kopa_ar_savejo' => 0,
																		'kopa_ar_did' => $did_kaimina[0],
																		'kopa_ar_berns' => 0)
																		),
													'vietas_id' => $istabinas_id
													);
												$radamas_istabas['TWIN|ar_'.$kaimins['dzimta']][] = $ist;
												if (DEBUG) echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar svešo<br><br>";
																							
												break;
												}
												//$ir_pustwins = TRUE;
											}
										}
									}
									//ja rezervējis šis pats cilvēks
									else{
									}
									
									//}else break;
								}
								
							}
							//visa istabiņa ir tukša
							elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
							//	echo "2 vietas brīvas<br>";
								$ist = array('kopa_ar' => array(),
											'vietas_id' => $istabinas_id
											);
								$radamas_istabas['TWIN_full'][] = $ist;
								
								$pilns_twins = $istabinas_id;
							}
							//ja vietas aizņēmis pats dalībnieks un vēl kāds no šīs rezervācijas
							/*elseif($istabina['vietas_aiznemtas'] == 2){
								echo "<br> 2 Aizņemtas vietas<br><br>";
								$did_kaiminu= $pieteikums->GetDidVid($istabinas_id);
								$parejie_dalibnieki = $_SESSION['reservation']['dalibn_id_arr'];
								$radit = FALSE;
								if (in_array($active_did,$did_kaiminu)){
									foreach ( $_SESSION['reservation']['dalibn_id_arr'] as $did){
										if ($did!= $active_did){
											if (in_array($did,$did_kaiminu)){
												$did_kaimina = $did;
												$radit = TRUE;
												break;
											}
										}
									}
								}
								if ($radit){
									$kaimins = $dalibn->GetId($did_kaimina);
									$radamas_istabas['TWIN|ar']['kopa_ar']='(kopā ar '.$kaimins['vards'].' '.$kaimins['uzvards'].')';
									$radamas_istabas['TWIN|ar']['vietas_id'] = $istabinas_id;
								}
							}*/
					}
					//ja no šī veida vēl nav atlasīts piedāvājamais numurins							
					elseif( !array_key_exists($istabina['veids'],$radamas_istabas)){
						//Ja istabiņa ir ar kopīgu gultu un kāds jau ir aizņēmis 1 vietu
						if ($istabina['veids'] == 'DOUBLE' && $istabina['vietas_aiznemtas'] == 1){
							foreach ($dalibn_id_arr as $active_did){
								$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
								//ja nav rezervējis šis pats cilvēks
								if (!empty($did_kaimina)){
									//ja arī otrs cilvēks ir no šīs pašas rezervācijas, tad šo numuriņu var piedāvāt
									if (in_array($did_kaimina[0],$dalibn_id_arr)){
										
										//ja rezervējis ir pats dalībnieks
										//if ($active_did!=$did_kaimina[0]){
											$kaimins = $dalibn->GetId($did_kaimina[0]);
											$birthday = $dalibn->Birthday($did_kaimina[0]);
											$diff = $beigu_dat->diff($birthday);
											$age = $diff->format('%y');
											if ($age<18) $berns = 1; else $berns=0;
											$ist = array('kopa_ar' => array(
																	array('kopa_ar_dzimums' => $kaimins['dzimta'],
																		'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
																		'kopa_ar_savejo' => 1,
																		'kopa_ar_did' => $did_kaimina[0],
																		'kopa_ar_berns' => $berns)
																		),
													'vietas_id' => $istabinas_id
													);
											$radamas_istabas['DOUBLE|ar'][] = $ist;
											break;
										//}
										/*else{
											$radamas_istabas['DOUBLE']['kopa_ar']='';
											$radamas_istabas['DOUBLE']['vietas_id'] = $istabinas_id;
									
										}*/
										
										//echo "<br><br>DOUBLE ar ID <b>$istabinas_id</b> ar savējo<br><br>";
									}
								}
							}
						}
						//SINGLE numuriņie visticamāk
						else{
							$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
							$radamas_istabas[$istabina['veids']][] = $ist;
						
						}
					}
					
				
					//ja ņem double, jāpārbauda, vai abi paņēma doubli
				}
				//--------------------------//
			}
		}
		//------END 2 ceļot.------------------------------------------------//
		
		
		
		//---------------ja ir 3 un vairāk ceļotāji----------------------------//
		if ($_SESSION['reservation']['traveller_count'] >=3 ){
			foreach($istabinas as $istabinas_id=>$istabina){
				/*echo "<br>IST:<br>";
				var_dump($istabina);
				echo "<br><br>";*/
				//echo $istabina['vietas_kopa'];
				//echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				//Ja istabiņa ir divvietīga ar atsevišķām gulrām
				if ($istabina['veids'] == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas)){
					//ja pustukšs TWINS
					if ($istabina['vietas_aiznemtas'] == 1){
						//echo "<br>viena vieta brīva<br><br>";
						//pārbauda, kas ir aizņēmis istabiņu 
						foreach ($dalibn_id_arr as $active_did){
							$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
							/*echo "KAIMIŅA DID:";
							var_dump($did_kaimina);
							echo "<br><br>";
							echo "<br> Šajā rezervācijā jau ir:";
							var_dump($_SESSION['reservation']['dalibn_id_arr']);
							echo "<br><br>";*/
							//ja atrasts kaimiņš
							if (!empty($did_kaimina)){
								//ja arī otrs cilvēks ir no šīs pašas rezervācijas, tad šo numuriņu var piedāvāt								
								if (in_array($did_kaimina[0],$_SESSION['reservation']['dalibn_id_arr'])){
									//echo "No šīs pašas rezervācijas<br>";
									
 									//ja rezervējis ir pats dalībnieks
									//if ($active_did!=$did_kaimina[0]){
										//echo "<br>Neskarīt ar kaimiņa<br>";
										$kaimins = $dalibn->GetId($did_kaimina[0]);
										$birthday = $dalibn->Birthday($did_kaimina);
										$diff = $beigu_dat->diff($birthday);
										$age = $diff->format('%y');
										$berns = ($age < 18 ? 1 : 0);
										$ist = array('kopa_ar'=> array(
															array('kopa_ar_dzimums' => $kaimins['dzimta'],
															'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
															'kopa_ar_savejo' => 1,
															'kopa_ar_did' => $did_kaimina[0],
															'kopa_ar_berns' => $berns
															)),
													'vietas_id' => $istabinas_id
													);
										$radamas_istabas['TWIN|ar_savejo'][] = $ist;
										break;
									//}
									/*else{
										echo "Sakrīt ar kaimiņa<br>";
										$ist = array('kopa_ar' => '',
													'vietas_id' => $istabinas_id
													);
										$radamas_istabas['TWIN'][] = $ist;
										
									}*/
									
									//echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar savējo<br><br>";
								}
								//ja nav, pārbauda, pārbauda, vai sakrīt dzimums
								else{
									
									$kaimins = $dalibn->GetId($did_kaimina[0]);
									/*echo "<br>Kaimiņš:<br>";
									var_dump($kaimins);
									echo "<br><br>";
									echo "<br>ES:<br>";*/
									$celotajs = $dalibn->GetId($active_did);
									//var_dump($celotajs);
									//echo "<br><br>";
									//ja sakrīt dzimums ar kaimiņu, šo numuriņu var piedāvāt
									if ($kaimins['dzimta'] == $celotajs['dzimta']){
										if ($kaimins['dzimta'] == 's')
											$kopa_ar = 'Sieviete';
										elseif ($kaimins['dzimta'] == 'v')
											$kopa_ar = 'Vīrietis';
										if (!array_key_exists('TWIN|ar_'.$kaimins['dzimta'],$radamas_istabas))	{
											$ist = array('kopa_ar' => array(array(
																	'kopa_ar_dzimums' => $kaimins['dzimta'],
																	'kopa_ar_nosaukums' => $kopa_ar,
																	'kopa_ar_savejo' => 0,
																	'kopa_ar_did' => $did_kaimina[0],
																	'kopa_ar_berns' => 0)),
													'vietas_id' => $istabinas_id
													);
											$radamas_istabas['TWIN|ar_'.$kaimins['dzimta']][] = $ist;	
											break;										
										}
										//echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar svešo<br><br>";
										//$ir_pustwins = TRUE;
									}
								}
							}
						}						
					}
					//visa TWIN istabiņa ir tukša
					elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
						//echo "2 vietas brīvas<br>";
						$ist = array('kopa_ar' => array(),
									'vietas_id' => $istabinas_id
									);
						$radamas_istabas['TWIN_full'][] = $ist;
					
						$pilns_twins = $istabinas_id;
					}					
				}
				//visas pārējās istabiņas izņemto TWIN
				elseif( !array_key_exists($istabina['veids'],$radamas_istabas)){
					if ($istabina['veids'] == 'DOUBLE'){
						if ($istabina['vietas_aiznemtas'] == 1){
							foreach ($dalibn_id_arr as $active_did){
								$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
								if (!empty($did_kaimina)){	
									//ja arī otrs cilvēks ir no šīs pašas rezervācijas, tad šo numuriņu var piedāvāt
									if (in_array($did_kaimina[0],$_SESSION['reservation']['dalibn_id_arr'])){
										
										//ja rezervējis ir pats dalībnieks
										//if ($active_did!=$did_kaimina[0]){
											$kaimins = $dalibn->GetId($did_kaimina[0]);
											$birthday = $dalibn->Birthday($did_kaimina[0]);
											$diff = $beigu_dat->diff($birthday);
											$age = $diff->format('%y');
											$berns = ($age < 18 ? 1 : 0);
											$ist = array('kopa_ar' => array(array(
																'kopa_ar_dzimums' => $kaimins['dzimta'],
																'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
																'kopa_ar_savejo' => 1,
																'kopa_ar_did' => $did_kaimina[0],
																'kopa_ar_berns' => $berns
																)),
														'vietas_id' => $istabinas_id
													);
											$radamas_istabas['DOUBLE|ar'][] = $ist;
											break;
											
										//}
										/*else{
											$radamas_istabas['DOUBLE']['kopa_ar']='';
											$radamas_istabas['DOUBLE']['vietas_id'] = $istabinas_id;
									
										}*/
										
										//echo "<br><br>DOUBLE ar ID <b>$istabinas_id</b> ar savējo<br><br>";
									}
								}
							}
						}
						else{
							$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
							$radamas_istabas[$istabina['veids']][] = $ist;
						}
					}
				
					// ja 3-.. vietīgā istabā ir palikušas brīvas vietas, pārbauda, vai tās visas nav bērnu
					if ($istabina['vietas_kopa'] >=3){
						$brivas_vietas = $istabina['vietas_kopa'] - $istabina['vietas_aiznemtas'];
						if (DEBUG)	echo "<br>Brīvās vietas: $brivas_vietas <br>";
						//ja ir palikušas tikai bērnu vietas
						
						if ($brivas_vietas == $istabina['vietas_bernu']){
							if (DEBUG) echo "palikušas tikai bērnu vietas";
							//pārbauda, vai rezervācijā ir bērni
							$children = $online_rez->WithChildren($online_rez_id);
							
							
							//ja rezervācija ir bērns(i)
							if (count($children)>0){
								//$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
								$kopa_ar_arr = array();
								//foreach ($dalibn_id_arr as $active_did){
								$did_kaiminu = $pieteikums->GetDidVid($istabinas_id);
									
								foreach ($did_kaiminu as $did_kaimina){
																	
									//vai arī otrs cilvēks ir no šīs pašas rezervācijas
									if (in_array($did_kaimina,$_SESSION['reservation']['dalibn_id_arr'])){
									
										//if ($active_did!=$did_kaimina){
											$kaimins = $dalibn->GetId($did_kaimina);
										
											$birthday = $dalibn->Birthday($did_kaimina);
											$diff = $beigu_dat->diff($birthday);
											$age = $diff->format('%y');
											$berns = ($age < 18 ? 1 : 0);
											$kopa_ar_arr[] =  array('kopa_ar_dzimums' => $kaimins['dzimta'],
													'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
													'kopa_ar_savejo' => 1,
													'kopa_ar_did' => $did_kaimina,
													'kopa_ar_berns' => $berns
													);													
										
									}
								}
								$ist = array('kopa_ar' => $kopa_ar_arr,
												'vietas_id' => $istabinas_id
												);
								$radamas_istabas[$istabina['veids'].'|ar'][] = $ist;
					
							}
						}
						//ir brīvas arī pieaugušo vietas - var likt neatkarīgi no vecuma šajā istabiņā
						else{
							//ja visas vietas vēl brīvas
							if ($brivas_vietas == $istabina['vietas_kopa']){
								if (DEBUG) echo "visas vietas vēl brīvas";
								$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
								$radamas_istabas[$istabina['veids']][] = $ist;
							}
							//ja ir jau kaimiņi
							else{
								if (DEBUG){
									echo "ir kaiminji";
									echo "<br> dalibn_id arr<br>";
									var_dump(	$dalibn_id_arr);
									echo "<br><br>";
								}									
								$kopa_ar_arr = array();
								//foreach ($dalibn_id_arr as $active_did){	
									$did_kaiminu = $pieteikums->GetDidVid($istabinas_id);
									if (DEBUG){
										echo "did kaiminu<br>";
										var_dump($did_kaiminu);
										echo "<br><br>";
									}
									foreach ($did_kaiminu as $did_kaimina){
										if (DEBUG) echo "<br>did kaimina: $did_kaimina <br>"; 	
								
										//vai arī otrs cilvēks ir no šīs pašas rezervācijas
										if (in_array($did_kaimina,$dalibn_id_arr)){
										
											//if ($active_did!=$did_kaimina){
												$kaimins = $dalibn->GetId($did_kaimina);
												if (DEBUG){
													var_dump($kaimins);
													echo"<br><---kaimins<br>";
												}
												$birthday = $dalibn->Birthday($did_kaimina);
												$diff = $beigu_dat->diff($birthday);
												$age = $diff->format('%y');
												$berns = ($age < 18 ? 1 : 0);
												$kopa_ar_arr[]= array('kopa_ar_dzimums' => $kaimins['dzimta'],
																		'kopa_ar_nosaukums' => $kaimins['vards'].' '.$kaimins['uzvards'],
																		'kopa_ar_savejo' => 1,
																		'kopa_ar_did' => $did_kaimina,
																		'kopa_ar_berns' => $berns);
												/*echo "KAIMIŅŠ";
												var_dump($kaimins);
												echo "<br><br>";*/
												
											//}
											//paša dalībnieka rezervētais numuriņš
											/*else{
												$ist = array('kopa_ar' => '',
													'vietas_id' => $istabinas_id
													);
												$radamas_istabas[$istabina['veids']][] = $ist;
											}*/
										}
									}
									
									//break;
									
								//}
								$ist = array(//'kopa_ar' => '(kopā ar '.implode(', ',$kopa_ar_arr).')',
													'kopa_ar' => $kopa_ar_arr,
													'vietas_id' => $istabinas_id
													);
								if (DEBUG){
									echo "<br>istaba:<br>";
									var_dump($ist);
									echo "<br><br>";
								}
								$radamas_istabas[$istabina['veids'].'|ar'][] = $ist;
						
							
							}	
						}
					}
					//SINGLE numuriņi
					elseif ($istabina['vietas_kopa']==1){
						$ist = array('kopa_ar' => array(),
									'vietas_id' => $istabinas_id
									);
						$radamas_istabas[$istabina['veids']][] = $ist;
					}
					
				}
			}
		}
	
		//---------END 3 un vairāk ceļot.-----------------------------------//
		
		if (DEBUG){
			echo "<br>Rādāmās istabas:<br>";
			var_dump($radamas_istabas);	
			echo "<br><br>";
		}
		
		$data['viesnicas']= array();
		//vai vispār ir istabas, ko piedāvāt
		$radamo_ist_id = array();
		if (count($radamas_istabas)>0){
				
		
			//ja rezervācijā ir divi dalībnieki un 1 jau ir paņēmis doubli
			//pārbauda, vai tas ir otrais dalībnieks, lai neierobežotu pirmajam izvēles iespējas && $active_did != $dalibnieki[0] 
			/*$limit_to_double = FALSE;
			if ($_SESSION['reservation']['traveller_count'] == 2 && array_key_exists('DOUBLE|ar',$radamas_istabas)){
				$istabas  =  $viesnicas->GetViesnicaAll($online_rez_id);
				//echo "Rezervēts:<br>";
				//var_dump($istabas);
				$skaits = count(array_filter($istabas));
				//Ja ir izvēlējies tikai viens no dalībniekiem				
				if ($skaits == 1) {	
					$limit_to_double = true;
				}
			}
			if ($limit_to_double){			
					$vieta = array ('vietas_id' =>$radamas_istabas['DOUBLE|ar'][0]['vietas_id'],
									'nosaukums' => $istabinas[$radamas_istabas['DOUBLE|ar'][0]['vietas_id']]['nosaukums'],
									'veids' => $istabinas[$radamas_istabas['DOUBLE|ar'][0]['vietas_id']]['veids'],
									'bernu_vietas' => $istabinas[$radamas_istabas['DOUBLE|ar'][0]['vietas_id']]['vietas_bernu'],
									'kopa_ar' => $radamas_istabas['DOUBLE|ar'][0]['kopa_ar'],
										
									'vietas_kopa' =>$istabinas[$radamas_istabas['DOUBLE|ar'][0]['vietas_id']]['vietas_kopa']);
					$data['viesnicas'][] = $vieta;
					$radamo_ist_id[] = $vieta['vietas_id'];	
							
				
			}
			else{*/
			if (DEBUG){
				echo "istabinas:<br>";
				var_dump($istabinas);
				echo "<br><br>";
			}
				foreach ($radamas_istabas as $istabas){
					if (DEBUG){
						echo "istabas:<br>";
						var_dump($istabas);
						echo "<br><br>";
					}
					$kopa_ar_arr = array();
				
					foreach ($istabas as $istaba){
						//echo "<br>KEY: $key <br><br>";
						//$nosauk = '';
						//if (strpos($key, 'TWIN|') !== false) {
							//$nosauk = substr($key, strpos($key, "|") + 1); 
							
						//}
						/*echo "ISTABA:";
						var_dump($istaba);
						echo "<br><br>";*/
						$radamo_ist_id[] = $istaba['vietas_id'];
						$vieta = array ('vietas_id' =>$istaba['vietas_id'],
									//'nosaukums' => $istabinas[$istaba['vietas_id']]['nosaukums'].' '.$istaba['kopa_ar'],
									'nosaukums' => $istabinas[$istaba['vietas_id']]['nosaukums'],
									'veids' => $istabinas[$istaba['vietas_id']]['veids'],
									'bernu_vietas' => $istabinas[$istaba['vietas_id']]['vietas_bernu'],
									'kopa_ar' => $istaba['kopa_ar'],
									'vietas_kopa' =>$istabinas[$istaba['vietas_id']]['vietas_kopa']
									//'kopa_ar_dzimums' => $istaba['kopa_ar_dzimums'],
									//'kopa_ar_savejo' => $istaba['kopa_ar_savejo']
									);
						$data['viesnicas'][] = $vieta;		
							//$kopa_ar_arr  =
						/*$data['viesnicas'][$istaba['vietas_id']]['vietas_id'] = $istaba['vietas_id'];
						$data['viesnicas'][$istaba['vietas_id']]['nosaukums'] = $istabinas[$value]['nosaukums'].' '.$nosauk;
						$data['viesnicas'][$istaba['vietas_id']]['vietas_kopa'] = $istabinas[$value]['vietas_kopa'];*/
					}	
					
					
				//}
				
				
			}
			
			if (DEBUG){
				echo "<br>Rādāmās istabas sakārtoti:<br>";
				var_dump($data['viesnicas']);		
				echo "<br><br>";
			}
		}
		else{					
			//$error['viesnica'] = "Atvainojiet, šim ceļojumam pašreiz nav iespējams norezervēt viesnīcas tiešsaitē, lūdzu, sazinieties ar IMPRO.";
			//$data['errors'] = $error;
		}
		//return $data['viesnicas'];
		/*echo "viesnicas<br>";
		var_dump($data['viesnicas']);
		echo "<br><br>";
		*/
		//Atrod jau norezervētās istabas
		$istabas  =  $viesnicas->GetViesnicaAll($online_rez_id);
		$rezerveto_vietu_skaits = count(array_filter($istabas));
		$celotaju_skaits = $_SESSION['reservation']['traveller_count'];
		
		if (DEBUG){
			echo "<b>Rezervētās Viesnīcas</b><br>";
			var_dump($istabas);
			echo "<br><br>";
		
			echo "<br>radamo istabu id arr<br>";
			var_dump($radamo_ist_id);
			echo "<br><br>";
		}
		
		//Ieliek rādāmo istabu masīvā, ja vēl nav
		$data['istabas'] = array();
		foreach ($istabas as $key=>$vid){
				if (!empty($vid)){
					//atrod aizņemto un brīvo vietu skaitu istabinjā
					$aiznemtas_vietas = $this->GetOccupiedCountId($vid);
					if (DEBUG) echo "Aizņemtās vietas: $aiznemtas_vietas <br>";
					$viesnica = $this->GetId($vid);
					if (DEBUG){
						echo "Viesnica:";
						var_dump($viesnica);
						echo "<br><br>";
					}
					$vietas_kopa = $viesnica['vietas'];
					$brivas_vietas = $vietas_kopa - $aiznemtas_vietas;
					if ($celotaju_skaits - $rezerveto_vietu_skaits <= $brivas_vietas){
						//skatās, vai ir masīvā pilnīgi tukšs šī paša tipa numuriņš
						//ja ir , tad to izņem
					//	echo "IR";
						foreach ($data['viesnicas'] as $key=>$viesn){
							if ($viesn['veids'] == $viesnica['nosaukums'] && count($viesn['kopa_ar'])==0){
								//echo "jāizņem";
								unset($data['viesnicas'][$key]);
							}
						}
					}
					if (!in_array($vid, $radamo_ist_id)){
						$did = $key;
						
						$kaiminu_did_arr = $pieteikums->GetDidVid($vid);
						/*echo "Kaimiņi:";
						var_dump($kaiminu_did_arr);
						echo "<br><br>";
						*/
						$kopa_ar_arr = array();
						foreach($kaiminu_did_arr as $did){
							$kaimins = $dalibn->GetId($did);
							$birthday = $dalibn->Birthday($did);
							$diff = $beigu_dat->diff($birthday);
							$age = $diff->format('%y');
							//echo "Kaimiņa vecums: $age <br>";
							
							if (in_array($did,$dalibn_id_arr)){
								$savejais = 1;
								$nosaukums = $kaimins['vards'].' '.$kaimins['uzvards'];
							}
							else {
								$savejais = 0;
								if ($kaimins['dzimta'] == 's')
									$nosaukums = 'Sieviete';
								elseif ($kaimins['dzimta'] == 'v')
									$nosaukums = 'Vīrietis';
								 
							}
							
							if ($age<18) $berns = 1; else $berns=0;
							$kopa_ar_arr[]= array('kopa_ar_dzimums' => $kaimins['dzimta'],
													'kopa_ar_nosaukums' => $nosaukums,
													'kopa_ar_savejo' => $savejais,
													'kopa_ar_did' => $did,
													'kopa_ar_berns' => $berns);
								
						}
						$bernu_vietas = $this->GetBernuVietas($vid);
						//tātad visas vietas aizņemtas šajā istabiņā
						$vieta = array ('vietas_id' =>$vid,
											'nosaukums' => $viesnica['pilns_nosaukums'],
											'kopa_ar' => $kopa_ar_arr,
											'bernu_vietas' => $bernu_vietas,
											'veids' => $viesnica['nosaukums'],
											'vietas_kopa' =>$viesnica['vietas']
											);
									
							$data['istabas'][]= $vieta;	
							$radamo_ist_id[] = $vid;							
								
						/*$vieta = array ('vietas_id' =>$istaba['vietas_id'],
									//'nosaukums' => $istabinas[$istaba['vietas_id']]['nosaukums'].' '.$istaba['kopa_ar'],
									'nosaukums' => $istabinas[$istaba['vietas_id']]['nosaukums'],
									'veids' => $istabinas[$istaba['vietas_id']]['veids'],
									'bernu_vietas' => $istabinas[$istaba['vietas_id']]['vietas_bernu'],
									'kopa_ar' => $istaba['kopa_ar'],
									'vietas_kopa' =>$istabinas[$istaba['vietas_id']]['vietas_kopa']
									//'kopa_ar_dzimums' => $istaba['kopa_ar_dzimums'],
									//'kopa_ar_savejo' => $istaba['kopa_ar_savejo']
									);
							*/	
					}
				}
			/*echo "<b>$key<br></b>";
			var_dump($vid);
			echo "<br><br>";
			*/
		}
		//saliek atrastās viesniicas citaa masiivaa
		if (isset($data['viesnicas'])){
			
			$viesnicas = array();
			foreach ($data['viesnicas'] as $viesnica){
				$data['istabas'][] = $viesnica;
				//$data['istabas'][0][]= $this->GetId($viesnica['vietas_id']);
			}
			//$data['istabas'] = array_map("unserialize", array_unique(array_map("serialize", $data['istabas'])));
			//$data['istabas'] = array_unique($data['istabas']);
		}
		//Ja ir divi dalibnieki un viens ir izvelejies double, bet otrs neko, otram piedava tikai doubli
		//$limit_to_double = false;
		$data_ist_tmp = array();
		if ($_SESSION['reservation']['traveller_count'] == 2){
		//	$skaits = count(array_filter($istabas));
			//Ja ir izvēlējies tikai viens no dalībniekiem				
			if ($rezerveto_vietu_skaits == 1) {	
				foreach ($data['istabas'] as $istaba){
					if ($istaba['veids'] == 'DOUBLE' && count($istaba['kopa_ar']) == 1){
						//echo "<b>DOUBLE</b><br>";
						//$limit_to_double = true;
						$data_ist_tmp[] = $istaba;
					
					}
				}
			}
		}

		if (count($data_ist_tmp)==1){
			$data['istabas'] = $data_ist_tmp;
		}
		/*$istabas  =  $viesnicas->GetViesnicaAll($online_rez_id);
		//echo "Rezervēts:<br>";
		//var_dump($istabas);
		$skaits = count(array_filter($istabas));
		//Ja ir izvēlējies tikai viens no dalībniekiem				
		if ($skaits == 1) {	
			$limit_to_double = true;
		}
		*/
		//sakārtojam pēc vietu skaita
	
				/*uasort($data['istabas'], function ($i, $j) {					
					$a = $i['vietas_kopa'];
					$b = $j['vietas_kopa'];
					if ($a == $b){
						
							return 0;
					}					
					elseif ($a > $b) return 1;
					else return -1;
				});*/
				
		//sakārtojam pēc vietu skaita UN pēc numuriņu veida
		if (count($data['istabas'])>0){
			foreach($data['istabas'] as $k=>$v) {
				$sort['vietas_kopa'][$k] = $v['vietas_kopa'];
				$sort['veids'][$k] = $v['veids'];
			}
			#
			array_multisort($sort['vietas_kopa'], SORT_ASC, $sort['veids'], SORT_ASC,$data['istabas']);
		}		
		return $data['istabas'];
		
	}
	//atgriež rezervācijas dalībnieku rezervētās istabiņas
	function GetViesnicaAll($online_rez_id){
		require_once("m_online_rez.php");		
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");		
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();	
		$online_rez = new OnlineRez();
		//dabū visu dalībnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		if (DEBUG){
			echo "<br>MODELdalībnieki:</br>";
			var_dump($dalibn_id_arr);
			echo "<br><br>";
		}
		
		$viesnicas = array();
		foreach ($dalibn_id_arr as $did){
			
			$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
			$viesnicas[$did] = $this->GetViesnica($pid);
		}
		if (DEBUG) var_dump($viesnicas);
		return $viesnicas;
		
	}
	
	//atgriež rezervēto viesnīcas numuriņu, ja tāds ir
	function GetViesnica($pid){
		$qry = "SELECT vid FROM piet_saite WHERE deleted!=1 
				AND vid IS NOT NULL AND vid>0";
		//testam
		/*$qry = "SELECT vid FROM piet_saite WHERE vid IS NOT NULL AND vid>0";
		*/
		$qry .= " AND pid = ?";
		$params = array($pid);
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
			//if (!empty($row['vid'])){
				//$viesnica = $this->GetId($row['vid']);
				//return $viesnica;
			//}
			return $row['vid'];
		}
		
	}
	
	//atgriež bērnu un pieaugušu vietu skaitu istabiņā
	function GetBernuVietas($id){
		$row = $this->GetId($id);
		
		$re = "/\\+[ ]{0,1}([\\d]*)/"; 
		//$str = "nnvieta +1 vieta  f "; 
		//echo "<br>NOsakumums".$row['nosaukums']."<br<br>";
		preg_match($re,  $row['nosaukums'], $matches);
		//var_dump($matches);
		if (count($matches)>0){
			$bernu_vietas = ((int)$matches[1] >0 ? $matches[1] : 1);
		}
		else $bernu_vietas = 0;
		
		return $bernu_vietas;
	}
	//ieliek rezervācijas dalībnieku izstabiņā, ja ir esošie - tos izņem
	function BookRoomForDid($online_rez_id, $vid,$did,$aiznemis_did){
		if ($aiznemis_did){
			$values = array('vid'=>0);
			$where_arr = array('vid' => $vid,
								'did' => $aiznemis_did
								);
			
			$this->db->UpdateWhere('piet_saite',$values,$where_arr);	
		}		
		require_once("m_pieteikums.php");
		$pieteikums = new Pieteikums();
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		//saglabā jauno istabiņu
		$where_arr = array('pid' => $pid							
							);
		$where_cond = "(deleted=0 AND ((summaEUR IS NULL AND vietas_veids IS NULL) OR (vid IS NOT NULL AND vid>0)))";
		
		$this->db->UpdateWhere('piet_saite',array('vid'=>$vid),$where_arr,$where_cond);
		
	}
	
	function RezervetasViesnicas($online_rez_id,$radamo_ist_id = array()){
		$istabas = $this->GetViesnicaAll($online_rez_id);
		if (DEBUG){
			echo "<b>Rezervētās Viesnīcas</b><br>";
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
		
		//dabū visu dalībnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		
		$data['istabas'] = array();
		foreach ($istabas as $key=>$vid){
				if (!empty($vid)){
					if (!in_array($vid, $radamo_ist_id)){
						$did = $key;
						$viesnica = $this->GetId($vid);
						/*echo "Viesnica:";
						var_dump($viesnica);
						echo "<br><br>";
						*/
						$kaiminu_did_arr = $pieteikums->GetDidVid($vid);
						if (DEBUG){
							echo "Kaimiņi:";
							var_dump($kaiminu_did_arr);
							echo "<br><br>";
						}
						
						$kopa_ar_arr = array();
						foreach($kaiminu_did_arr as $did){
							$kaimins = $dalibn->GetId($did);
							$birthday = $dalibn->Birthday($did);
							$diff = $beigu_dat->diff($birthday);
							$age = $diff->format('%y');
							//echo "Kaimiņa vecums: $age <br>";
							
							if (in_array($did,$dalibn_id_arr)){
								$savejais = 1;
								$nosaukums = $kaimins['vards'].' '.$kaimins['uzvards'];
							}
							else {
								$savejais = 0;
								if ($kaimins['dzimta'] == 's')
									$nosaukums = 'Sieviete';
								elseif ($kaimins['dzimta'] == 'v')
									$nosaukums = 'Vīrietis';
								 
							}
							
							if ($age<18) $berns = 1; else $berns=0;
							$kopa_ar_arr[]= array('kopa_ar_dzimums' => $kaimins['dzimta'],
													'kopa_ar_nosaukums' => $nosaukums,
													'kopa_ar_savejo' => $savejais,
													'kopa_ar_did' => $did,
													'kopa_ar_berns' => $berns);
								
						}
						$bernu_vietas = $this->GetBernuVietas($vid);
						//tātad visas vietas aizņemtas šajā istabiņā
						$vieta = array ('vietas_id' =>$vid,
											'nosaukums' => $viesnica['pilns_nosaukums'],
											'kopa_ar' => $kopa_ar_arr,
											'bernu_vietas' => $bernu_vietas,
											'veids' => $viesnica['nosaukums'],
											'vietas_kopa' =>$viesnica['vietas']
											);
									
							$data['istabas'][]= $vieta;	
							$radamo_ist_id[] = $vid;							
								
						
					}
				}
			/*echo "<b>$key<br></b>";
			var_dump($vid);
			echo "<br><br>";
			*/
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
	
	//atgriež 1 vai 0, vai dalībnieks ir rezervējis Vienvietīgu numuriņu
	function IsInSingle($pid){
		$vid= $this->GetViesnica($pid);
		$viesn = $this->GetId($vid);
		if (DEBUG){
			echo "viesnica v1:<br>";
			var_dump($viesn);
			echo "<br><br>";
		}
		if ($viesn['vietas'] == 1){
			return 1;
		}
		else return 0;
	}
}
?>