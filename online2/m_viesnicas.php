<?
class Viesnicas {
	var $db;
	var $bed_images = array ('child_M' => 'img/boy.svg',
							'child_F' => 'img/girl.svg',
							'adult_M' => 'img/male.svg',
							'adult_F' => 'img/female.svg',
							'double_right_side' => 'img/DOUBLE_R.svg',
							'double_left_side' => 'img/DOUBLE_L.svg',
							'free' => 'img/brivs.png',
							'single' => 'img/SINGLE.svg',
							'single4child' => 'img/CHILD.svg');
											
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db;
	}
	
	/*
		Nodzçð informâciju par viesnicâm ðai rezervâcijai
	*/
	public function GetRezViesnicasId($rez){
		$qry = "select distinct vid from piet_saite ps
			join pieteikums p on ps.pid = p.id
			where 
				p.deleted = 0
				and ps.deleted = 0
				and online_rez = ?
				and isnull(vid,0) <> 0	";
		
		$params = array();
		$params[0] = $rez;
		$result = $this->db->Query($qry,$params);
		
		$rooms = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$rooms[$row['vid']] = $row['vid'];
		}
		return $rooms;		
	}


	/*
		Nodzçð informâciju par viesnicâm ðai rezervâcijai
	*/
	public function ClearRooms($rez){
		$qry = "update piet_saite set vid = NULL
		where id in
		(
			select ps.id from piet_saite ps
			join pieteikums p on ps.pid = p.id
			where 
				p.deleted = 0
				and ps.deleted = 0
				and online_rez = ?
				and isnull(vid,0) <> 0
		)";
		$params = array();
		$params[0] = $rez;
		$this->db->Query($qry,$params);
	}

	/*
		dabon grupas id no viesnicas veida
	*/
	function GetGidByVvid($vvid){
		$query = "select gid from viesnicas_veidi where id = ?";
		$params = array($vvid);
		$result = $this->db->Query($query,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		return $row['gid'];
	}
	
	/*
		Izvçlas vajadzîgâs istabas ko piedâvât lietotâjam
		no konkrçtâ veida
	*/
	function SelectRoomsByType($vvid,$person_count,$room_count,$sex){
		$gid = $this->GetGidByVvid($vvid);
		$output = array();
		
		// visas istabas
		$rooms = $this->GetRooms($gid,0);
		
		// pievienojam daïçji aizpildîtâs istabas
		// pagaidâm tikai twin, bet nâkotnç varçtu bût arî citi
		foreach($rooms as $key => $room) {
			// TWIN vienam cilvçkam
			if ( $room['brivs'] != 0
					&& $room['vvid'] == $vvid 
					&& $room['brivs'] < $room['vietas']
					&& $room['nosaukums'] == 'TWIN')
			{
				if ($person_count==1) {
					if ($sex==$room['dzimums'] && count($output)==0)
					{
						// ja viens cilvçks tad atgrieþ pirmo pustukðo
						$output[$key] = $room;
						return $output;
					}
				}
				else
					$output[$key] = $room;
			}
			// 4 vietîgs diviem
			if ( $room['brivs'] != 0
					&& $room['vvid'] == $vvid 
					&& $room['brivs'] == 2
					&& $room['var2'] == 1)
			{
				if ($person_count==2) {
					// atgrieþ pirmo pustukðo
					$output[$key] = $room;
					return $output;
				}
				else
					$output[$key] = $room;
			}
		}
		
		// pievienojam tukðâs istabas
		$count = 0;
		foreach($rooms as $key => $room) {
			if ( $room['brivs'] == $room['vietas']
					&& $room['vvid'] == $vvid 
					&& $count<$room_count)
			{
				$count++;
				$output[$key] = $room;
			}
		}
		
		return $output;
	}

	/*
		no istabu masîva (GetRooms)
		atlasa atbilstoðos istabu veidus
	*/
	function GetCorrectTypes($rooms,$count,$sex){
		$types = array();
		foreach($rooms as $key => $room) {
			$valid = true;
			
			if ($room['brivs']==0)
				$valid = false;
			
			if ($room['nosaukums']=='DOUBLE' && $count==1)
				$valid = false;
			
			if ($room['nosaukums']=='DOUBLE' && $sex!='mix')
				$valid = false;
			
			if ($valid)
				if ($room['vietas']!=$room['brivs'] && ($sex!=$room['dzimums'] && $sex!='mix'))
					$valid = false;
			
			if ($room['ievietoti']!=0)
				$valid = true;
			
			if ($valid) {
				$vvid = $room['vvid'];
				if (!isset($types[$vvid]))	{
					$types[$vvid] = array();
					$types[$vvid]['id'] = $vvid;
					$types[$vvid]['nosaukums'] = $room['nosaukums'];
					$types[$vvid]['pilns_nosaukums'] = $room['pilns_nosaukums'];
					$types[$vvid]['var2'] = $room['var2'];
					$types[$vvid]['cenaEUR'] = round($room['cenaEUR'],2);
					$types[$vvid]['skaits'] = 1;
				} else {
					$max = (int) ceil($count / $room['vietas']);
					if ($types[$vvid]['skaits']<$max)
						$types[$vvid]['skaits'] = $types[$vvid]['skaits'] + 1;
				}
			}
		}
		return $types;
	}
	
	/*
		atlasa visas grupas istabas
		istabas id
		viesnicas veida id
		nosaukumi
		vietas
		brivas vietas
		dzimums pirmajam cilvçkam
		cik cilvçki numurâ no dotâs rezervâcijas
	*/
	function GetRooms($gid,$rez){
		$qry = "
			select 
				vv.id as vvid
				,v.id as vid
				,vv.nosaukums
				,vv.var2
				,vv.pilns_nosaukums
				,vv.vietas
				,vv.var2
				,case 
					when vv.nosaukums = 'SINGLE' then 
						dbo.fn_grupa_single_piemaksa($gid) + isnull(viet.cenaEUR,0) + dbo.fn_grupa_bazes_cena($gid) 
					else 
						isnull(viet.cenaEUR,0) + dbo.fn_grupa_bazes_cena($gid) 
				end as cenaEUR
				,isnull(viet.cenaEUR,0) + dbo.fn_grupa_bazes_cena_berns($gid) as cena_berns_EUR
				,vv.vietas - (
							select isnull(count(persona),0) 
							from piet_saite ps
							where 
								ps.vid = v.id
								and ps.deleted = 0
							) as brivs
				,(
					select top 1 dzimta 
					from dalibn d
					join piet_saite ps2 on ps2.did = d.id
					where ps2.vid = v.id
					and ps2.deleted = 0
				) as dzimums
				,(
				select isnull(count(persona),0) 
				from piet_saite ps 
				join pieteikums p on ps.pid = p.id
				where 
					ps.vid in 
					(
						select id from viesnicas where id = v.id
					) 
					and ps.deleted = 0
					and p.online_rez = ?
					and p.deleted = 0
				) as ievietoti
			from viesnicas_veidi vv
			join viesnicas v on vv.id = v.veids
			left join vietu_veidi viet on vv.vietu_veidi_id = viet.id
			where vv.gid = ?
			and vv.pieejams_online = 1
			order by vv.id,v.id";
		
		$params = array($gid);
		$params[0] = $rez;
		$params[1] = $gid;
		$result = $this->db->Query($qry,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$rooms = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$rooms[$row['vid']] = $row;
		}
		return $rooms;
	}
	
	/*
		nodroðina konkrçtu skaitu istabiòu
		no norâdîtâ veida
	*/
	function ensure($gid,$room_size,$vv_id,$count){
		$data = array();
		$data['gid'] = $gid;
		$data['vietas'] = $room_size;
		$data['veids'] = $vv_id;
		
		while ($this->count_vv($gid,$vv_id) <$count){
			$this->db->insert('viesnicas',$data);
		}
	}

	function count_vv($gid,$vv_id){

		$query = "select isnull(count(*),0) as c from viesnicas where gid = ? and veids = ?";
		$params = array($gid,$vv_id);
		$result = $this->db->Query($query,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		return $row['c'];
	}
	
	function GetId($id){
		$query = "SELECT viesnicas.id as vid,vv.*
					FROM viesnicas 
					LEFT JOIN viesnicas_veidi vv
						ON viesnicas.veids = vv.id 
					WHERE viesnicas.id = ? ";
					
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;			
		}
	}

	function GetVeidsGid($gid){
		//echo "GID:$gid<br>";
		$qry = "SELECT v.veids,vv.pilns_nosaukums,vv.nosaukums,vv.id
				FROM viesnicas v,viesnicas_veidi vv
				WHERE v.gid=?
				AND v.veids = vv.id
				group by v.veids,vv.pilns_nosaukums,vv.nosaukums,vv.id";
		//echo $qry."<br>";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$veidi[$row['id']] = $row['nosaukums'];
			
		}
		return $veidi;
	}
	
	//atgrieþ informâciju par brîvajiem viesnîcu numuriòiem
	function GetAvailableGid_new($gid,$pid=0){
	
		$params = array();
		$params[] = $gid;
		
		$qry = "SELECT v.veids,v.id,vv.vietas,vv.pilns_nosaukums,vv.nosaukums,vv.pieejams_online,vv.id as vvid
				FROM viesnicas v,viesnicas_veidi vv
				WHERE v.gid=?			
				AND v.veids = vv.id
				AND vv.pieejams_online = 1
				";		
		//echo $qry;
		//var_dump($params);
		$result = $this->db->Query($qry,$params);		
		
		
		$vietu_veidi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$vietas_id = $row['id'];
			$kopa_vietas= $row['vietas'];
			$qry = "SELECT COUNT(ID) as aiznemtas FROM piet_saite WHERE vid=? AND deleted!=1 AND pid!=?";
			
			$par = array($vietas_id,$pid);
			$res = $this->db->Query($qry,$par);
			
			if( $row_skaits = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				//echo "<br>skaits";
				//print_r($row_skaits);
				$aiznemtas_vietas = $row_skaits['aiznemtas'];
				//echo "<br><br>";
			}		
			
			$pieejams = false;
			
			//twinus var pusaizòemtus, pârçjos - pilnîgi brîvus
			$key = strtoupper($row['nosaukums']);
			$vvid = strtoupper($row['vvid']);
			$veids = $row['nosaukums'];
			if ($aiznemtas_vietas==0) {
				$pieejams = true;
				
			}
			else if ($key=='TWIN' && $aiznemtas_vietas == 1){
				$dzimta = $this->GetKaiminsDzimta($row['id']);
				if (!empty($dzimta)){
					$key = "TWIN|".$dzimta;
					$veids = "TWIN|".$dzimta;
					$pieejams = true;	
				}
			}
			
			if ($pieejams){
				if (array_key_exists($key,$vietu_veidi)){
					$skaits = $vietu_veidi[$key]['skaits'] + 1;
				}
				else $skaits = 1;
				$vietu_veidi[$key]['vietas_kopa'] = $kopa_vietas;
				$vietu_veidi[$key]['vietas_aiznemtas'] = $aiznemtas_vietas;
				$vietu_veidi[$key]['veids'] = $veids;
				$vietu_veidi[$key]['nosaukums'] = $row['pilns_nosaukums'];									
				$vietu_veidi[$key]['vvid'] = $row['vvid'];									
				$vietu_veidi[$key]['vietas_bernu'] = $this->GetBernuVietas($vietas_id);					
				$vietu_veidi[$key]['skaits'] = $skaits;
			}	
			
		}
		
		echo  'test';
		echo "<preg>";
		print_r($vietu_veidi);
		echo "</preg>";
		
		
		return $vietu_veidi;
	}
	
	function GetAvailableGid($gid,$pid=0,$id=FALSE){
		
		$params = array();
		$params[] = $gid;
		if ($id){
			$where_id = 'v.id = ?';
			$params[] = $id;
		}
		else{
			$where_id = "1=1";
			
		}
		$qry = "SELECT 
					v.veids
					,v.id
					,vv.vietas
					,vv.pilns_nosaukums
					,vv.nosaukums
					,vv.pieejams_online
					,vv.id as vvid
					,(select top 1 dzimta from dalibn d
						where d.id in 
						(
							select did from piet_saite where vid = v.id and deleted <> 1
						)
					) as dzimums
				FROM 
					viesnicas v
					join viesnicas_veidi vv on v.veids = vv.id
				WHERE 
					v.gid=?
				AND $where_id
				";

		$result = $this->db->Query($qry,$params);
		
		if( $result === false) {
			die( print_r( sqlsrv_errors(), true) );
		}
		
		$istabinas = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$vid = $row['id'];
			$kopa_vietas= $row['vietas'];
			$aiznemtas_vietas = $this->GetOccupiedCountId($vid,$pid);
			
			//atgrieþ tikai tad, ja ir brîvas vietas numuriòâ vai norâdîts istabiòas ID
			if ($kopa_vietas > $aiznemtas_vietas || $id){
				// dati par istabu
				$istabinas[$vid]['vid'] = $vid;
				$istabinas[$vid]['vietas_kopa'] = $kopa_vietas;
				$istabinas[$vid]['vietas_aiznemtas'] = $aiznemtas_vietas;
				$istabinas[$vid]['veids'] = $row['nosaukums'];
				$istabinas[$vid]['nosaukums'] = $row['pilns_nosaukums'];
				$istabinas[$vid]['vietas_bernu'] = $this->GetBernuVietas($vid);
				$istabinas[$vid]['pieejams_online'] = $row['pieejams_online'];
				$istabinas[$vid]['dzimums'] = $row['dzimums'];
				$istabinas[$vid]['vvid'] = $row['vvid'];
			}
		}
		
		return $istabinas;
	}
	
	function RemoveDuplicates($istabas)
	{
		//izmetam no masîva visas istabas lai paliktu tikai no katras pa vienam veidam (un citi parametri)
		foreach ($istabas as $vid => $istaba){
			$istabas[$vid]['delete'] = 0;
		}
		
		//atzîmçjâm dzçðanai dublikâtus
		foreach ($istabas as $vid_search => $istaba_search){
			if ($istabas[$vid_search]['delete']==0)
				foreach ($istabas as $vid => $istaba){
					if ($vid_search!=$vid && $this->CompareRooms($istaba_search,$istaba)==1)
						$istabas[$vid]['delete'] = 1;
				}
		}
		
		//veidojam jaunu masîvu bez dzçstajiem
		$new = array();
		foreach ($istabas as $vid => $istaba){
			if ($istabas[$vid]['delete']==0)
				$new[$vid] = $istabas[$vid];
		}
		
		return $new;
	}
	
	function CompareRooms($v1, $v2){
		if (
			$v1['veids']==$v2['veids']
			&& $v1['vvid']==$v2['vvid']
			&& $v1['dzimums']==$v2['dzimums']
		) 
			return 1;
		else
			return 0;
	}
	
	//atgrieþ istabiòas brîvo vietu skaitu
	function GetOccupiedCountId($vid,$pid=0){

		$qry = "SELECT COUNT(ID) as aiznemtas FROM piet_saite WHERE vid=? AND deleted!=1 AND pid!=?";
			
			$par = array($vid,$pid);
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
	
	//atgrieþ pieejamâs istabiòas	
	function GetAvailable($online_rez_id){
		//----------viesn--------------------------------------------------//			
		/*
		-- viesnicu nevar piedâvât ja nav brîvas tâdas istabas
		-- ja rezervâcijâ ir viens cilvçks, tad nepiedâvâ nekâdas istabas kur ir vairâk par 2 cilvçki (3-uz augðu)
		-- vienam cilvçkam nepiedâva DOUBLE
		-- jebkuram cilvçkam var piedâvât TWIN istabu ar tâ paða dzimuma cilvçku
		-- jâizdrukâ visi pusaizòemtie TWIN ar to paðu dzimumu
		-- ja ir 3 vai 4 vietas tad tâdus numurus tikai ja rezervâcija ir tikpat vai vairâk cilvçku
		-- ja viens cilvçks tad nepiedâvâ pilnu TWIN ja ir pieejams tâ paða dzimuma pustwins
		-- bçrns vai iet pieauguðâ vietâ
		-- pieauguðais nevar iet bçrna vietâ
		-- TWIN var bût daþâdu dzimumu cilvçki no vienas rezervâcijas
		-- beigâs validâcija kad pçdçjais cilvçks izvçlas viesnicu, tad visiem numuriem ar 3 vai vairâk vietâm jâbût pilnîgi aizòemtiem
		--ja ir pusaizòemts numuriòð un rezervâcijâ palicis tikai 1 dalibnieks nelielikts, tad nerada tadu pasu tuksu numurinju
		*/
		
		require_once("m_online_rez.php");
		require_once("m_viesnicas.php");
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");
		require_once("m_viesnicas.php");
		require_once("m_grupa.php");
		require_once("i_functions.php");
		
		$viesnicas = new Viesnicas();
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();
		$viesnicas = new Viesnicas();
		$online_rez = new OnlineRez();
		$gr = new Grupa();
		
		//dabû visu dalîbnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		$_SESSION['reservation']['dalibn_id_arr'] = $dalibn_id_arr;
		
		$istabinu_veidi = $viesnicas->GetVeidsGid($_SESSION['reservation']['grupas_id']);
		
		//atgrieþ 2 dimensiju asociatîvo masîvu ar katras istabiòas nosaukumu, kopçjo/aizòemto/bçrnu vietu skaitu
		$istabinas = $viesnicas->GetAvailableGid($_SESSION['reservation']['grupas_id']);
		
		$radamas_istabas = array();
		
		//dabû brauciena beigu datumu (vecuma rçíinâðanai)							
		$grupa = $gr->GetId($_SESSION['reservation']['grupas_id']);
		$beigu_dat = $grupa['beigu_dat'];		
		if (empty($beigu_dat)) die('<b><font color="red">Kïûda: ceïojumam ar ID# '.$_SESSION['reservation']['grupas_id'].' nav norâdîts beigu datums</font></b>');
		
		//--------------------------ja rezervâcijâ ir 1 cilvçks-----------------//
		//no katra veida vajag vienu numuriòu. 
		if ($_SESSION['reservation']['traveller_count'] == 1){
			
			unset($pilns_twins);
			foreach($istabinas as $istabinas_id=>$istabina){
				if (DEBUG){
					echo $istabina['vietas_kopa'];
					echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				}
				//--- nepiedâvâ nekâdas istabas kur ir vairâk par 2 cilvçki (3-uz augðu)--//
				if ($istabina['vietas_kopa']<=2){
					if (DEBUG){
						echo "<=divvietiga<br>";
					}
					
					// vienam cilvçkam nepiedâva DOUBLE
					//
					if (!Contains($istabina['veids'],'DOUBLE')){
							if (DEBUG) echo "nav double<br>";
						//jebkuram cilvçkam var piedâvât TWIN istabu ar tâ paða dzimuma cilvçku
						if (strtoupper($istabina['veids']) == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas) ){
							if (DEBUG) echo "var piedavat twin!<br>";
							//ja ir pieejams pustwins
							if ($istabina['vietas_aiznemtas'] == 1){
								//echo "<br>viena vieta brîva<br><br>";
								//atrod, kas ir aizòçmis istabiòu
								foreach ($dalibn_id_arr as $active_did){
									$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									if (DEBUG){
										echo "kaimiòa did:<br>";
										var_dump($did_kaimina);
										echo "<br><br>";
									}
									if (!empty($did_kaimina)){
										$kaimins = $dalibn->GetId($did_kaimina[0]);
										/*echo "<br>Kaimiòð:<br>";
										var_dump($kaimins);
										echo "<br><br>";
										echo "<br>ES:<br>";*/
									
										$celotajs = $dalibn->GetId($active_did);
										//var_dump($celotajs);
										//echo "<br><br>";
										//ja sakrît dzimumi, tad ðo istabiòu var piedâvât
										if ($kaimins['dzimta'] == $celotajs['dzimta']){											
											if ($kaimins['dzimta'] == 's')
												$kopa_ar = 'Sieviete';
											elseif ($kaimins['dzimta'] == 'v')
												$kopa_ar = 'Vîrietis';
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
							//visa istabiòa ir tukða
							elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
								//echo "2 vietas brîvas<br>";
								//atcerâs ðo istabiòu gadîjumam, ja nebûs pieejams pustwins ar to paðu dzimumu
								$ist = array('kopa_ar' => array(),
												'vietas_id' => $istabinas_id
												);
								$pilns_twins = $ist;
							}
						
						}
						//SINGLE numuriòiem visticamâk -pieliekam dorðîbai, ka tieðâm tikai single 
						elseif( !array_key_exists($istabina['veids'],$radamas_istabas) && $istabina['veids']=='SINGLE' ){
							if (DEBUG)echo "cita veida istabinja<br>";
							$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
							$radamas_istabas[$istabina['veids']][] = $ist;
						}
					}
				}
				//-------------//
			}
			if (DEBUG){			
				echo "RÂDÂMÂS ISTABAS!!!<br>";
				var_dump($radamas_istabas);
				echo "<br><br>";
			}
			
			//ja ir pieejams twins
			//ja viens cilvçks, tad nepiedâvâ pilnu TWIN, ja ir pieejams tâ paða dzimuma pustwins
			if (in_array('TWIN',$istabinu_veidi)){
				//echo "ir pieejams TWINS<br>";
				//ja NAV pustvins atrasts, piedâvâ pilno twinu
				if (!isset($radamas_istabas['TWIN']) && isset($pilns_twins) ){
					if (DEBUG) echo "pilns twins";
					$radamas_istabas['TWIN'][] = $pilns_twins;
				}
			}
			//ja tâ ir èartergrupa, nepiedâvâ arî TWIN numuriòu
			$carter_gid_arr = $gr->get_carter_full_rooms();
			if (in_array($_SESSION['reservation']['grupas_id'],$carter_gid_arr)){
				$var_piedavat_twin = 0;
				if (isset($radamas_istabas['TWIN'])){
					unset($radamas_istabas['TWIN']);
				}
			}
			else{
				$var_piedavat_twin = 1;
			}
			if (DEBUG){
				echo "var_piedavat TWIN".(int)$var_piedavat_twin."<br>";
			}
			//&& $var_piedavat_twin
		}
		//---------END 1 ceïot.---------------------------------------------------------//
		
		
		//-----------------------------ja ir 2  ceïotâji--------------------------//
		if ($_SESSION['reservation']['traveller_count'] == 2){
			unset($pilns_twins);
			foreach($istabinas as $istabinas_id=>$istabina){
				
				//echo $istabina['vietas_kopa'];
				//echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				//----nepiedâvâ nekâdas istabas kur ir vairâk par 2 cilvçki (3-uz augðu)---//
				if ($istabina['vietas_kopa']<=2){
					//ja twins
					//jebkuram cilvçkam var piedâvât TWIN istabu ar tâ paða dzimuma cilvçku
					if (strtoupper($istabina['veids']) == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas)){
							//ja pustukðs TWINS
							if ($istabina['vietas_aiznemtas'] == 1){
								//echo "<br>viena vieta brîva<br><br>";
								//pârbauda, kas ir aizòçmis istabiòu -
								foreach ($dalibn_id_arr as $active_did){
									/*echo "<br> Râdâmâs istabas<br>";
									var_dump($radamas_istabas);
									echo "<br><br>";
									echo "<br>Istabinja<br>";
									var_dump($istabina);
									echo "<br><br>";
									*/
								//	if (!in_array($istabina,$radamas_istabas)){
									$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									/*echo "<br>Kaimiòð<br>";
									var_dump($did_kaimina);
									echo "<br><br>";*/
									//ja nav rezervçjis ðis pats cilvçks
									if (!empty($did_kaimina)){
										//ja arî otrs cilvçks ir no ðîs paðas rezervâcijas, tad var piedâvât ðo istabiòu
										if (in_array($did_kaimina[0],$dalibn_id_arr)){
										
										//ja rezervçjis ir pats dalîbnieks
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
												if (DEBUG) echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar savçjo<br><br>";
												break;
											}
										}
										//ja no citas rezervâcijas, pârbauda, vai sakrît dzimums
										else{
											$kaimins = $dalibn->GetId($did_kaimina[0]);
											/*echo "<br>Kaimiòð:<br>";
											var_dump($kaimins);
											echo "<br><br>";
											echo "<br>ES:<br>";*/
											$celotajs = $dalibn->GetId($active_did);
											//var_dump($celotajs);
											//echo "<br><br>";
											//ja sakrît dzimums, var piedâvât ðo numuriòu
											if ($kaimins['dzimta'] == $celotajs['dzimta']){
												if ($kaimins['dzimta'] == 's')
													$kopa_ar = 'Sieviete';
												elseif ($kaimins['dzimta'] == 'v')
													$kopa_ar = 'Vîrietis';
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
												if (DEBUG) echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar sveðo<br><br>";
																							
												break;
												}
												//$ir_pustwins = TRUE;
											}
										}
									}
									//ja rezervçjis ðis pats cilvçks
									else{
									}
									
									//}else break;
								}
								
							}
							//visa istabiòa ir tukða
							elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
							//	echo "2 vietas brîvas<br>";
								$ist = array('kopa_ar' => array(),
											'vietas_id' => $istabinas_id
											);
								$radamas_istabas['TWIN_full'][] = $ist;
								
								$pilns_twins = $istabinas_id;
							}
							//ja vietas aizòçmis pats dalîbnieks un vçl kâds no ðîs rezervâcijas
							/*elseif($istabina['vietas_aiznemtas'] == 2){
								echo "<br> 2 Aizòemtas vietas<br><br>";
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
									$radamas_istabas['TWIN|ar']['kopa_ar']='(kopâ ar '.$kaimins['vards'].' '.$kaimins['uzvards'].')';
									$radamas_istabas['TWIN|ar']['vietas_id'] = $istabinas_id;
								}
							}*/
					}
					//ja no ðî veida vçl nav atlasîts piedâvâjamais numurins							
					elseif( !array_key_exists($istabina['veids'],$radamas_istabas)){
						//Istabiòu ar kopîgu gultu piedâvâ tikai tad, ja rezervâcijâ ir cilvçki ar daþâdiem dzimumiem
						if ($istabina['veids'] == 'DOUBLE'){
							$var_piedavat_double = $this->CanOfferDouble($online_rez_id);
							if (DEBUG) {
								echo "<b>Var piedâvât double:</b>";
								var_dump($var_piedavat_double);
							}
							if ($var_piedavat_double){
								//Ja istabiòa ir ar kopîgu gultu un kâds jau ir aizòçmis 1 vietu
								 if ($istabina['vietas_aiznemtas'] == 1){
									 foreach ($dalibn_id_arr as $active_did){
										$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
										//ja nav rezervçjis ðis pats cilvçks
										if (!empty($did_kaimina)){
											//ja arî otrs cilvçks ir no ðîs paðas rezervâcijas UN CITA DZIMUMA, tad ðo numuriòu var piedâvât
											if (in_array($did_kaimina[0],$dalibn_id_arr)){
												
												//ja rezervçjis ir pats dalîbnieks
												//if ($active_did!=$did_kaimina[0]){
												$kaimins = $dalibn->GetId($did_kaimina[0]);
												$celotajs = $dalibn->GetId($active_did);
												if (DEBUG){
													echo "<br>Ceïotâjs:<br>";
													var_dump($celotajs);
													echo "<br><br>";
													echo "<br>Kaimiòð:<br>";
													var_dump($kaimins);
													echo "<br><br>";
												}
													
												//ja NEsakrît dzimumi, tad ðo istabiòu var piedâvât
												if ($kaimins['dzimta'] != $celotajs['dzimta']){
													if (DEBUG) echo "<b>Ðis variants<br></b>";
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
												}
												//}
												/*else{
													$radamas_istabas['DOUBLE']['kopa_ar']='';
													$radamas_istabas['DOUBLE']['vietas_id'] = $istabinas_id;
											
												}*/
												
												//echo "<br><br>DOUBLE ar ID <b>$istabinas_id</b> ar savçjo<br><br>";
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
						}						
						//SINGLE numuriòie visticamâk , pielika,m papildus parbaudi, ka tieðâm tikai single 
						elseif ($istabina['veids'] == 'SINGLE'){
							$ist = array('kopa_ar' => array(),
										'vietas_id' => $istabinas_id
										);
							$radamas_istabas[$istabina['veids']][] = $ist;
						
						}
					}
					
				
					//ja òem double, jâpârbauda, vai abi paòçma doubli
				}
				//--------------------------//
			}
		}
		//------END 2 ceïot.------------------------------------------------//
		
		
		
		//---------------ja ir 3 un vairâk ceïotâji----------------------------//
		if ($_SESSION['reservation']['traveller_count'] >=3 ){
			foreach($istabinas as $istabinas_id=>$istabina){

				//echo $istabina['vietas_kopa'];
				//echo "<br><br>istabas veids:".$istabina['veids']."<br>";
				//Ja istabiòa ir divvietîga ar atseviðíâm gultâm
				if (strtoupper($istabina['veids']) == 'TWIN' && !array_key_exists('TWIN',$radamas_istabas)){
					//ja pustukðs TWINS
					if ($istabina['vietas_aiznemtas'] == 1){
						//echo "<br>viena vieta brîva<br><br>";
						//pârbauda, kas ir aizòçmis istabiòu 
						foreach ($dalibn_id_arr as $active_did){
							$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
							/*echo "KAIMIÒA DID:";
							var_dump($did_kaimina);
							echo "<br><br>";
							echo "<br> Ðajâ rezervâcijâ jau ir:";
							var_dump($_SESSION['reservation']['dalibn_id_arr']);
							echo "<br><br>";*/
							//ja atrasts kaimiòð
							if (!empty($did_kaimina)){
								//ja arî otrs cilvçks ir no ðîs paðas rezervâcijas, tad ðo numuriòu var piedâvât								
								if (in_array($did_kaimina[0],$_SESSION['reservation']['dalibn_id_arr'])){
									//echo "No ðîs paðas rezervâcijas<br>";
									
 									//ja rezervçjis ir pats dalîbnieks
									//if ($active_did!=$did_kaimina[0]){
										//echo "<br>Neskarît ar kaimiòa<br>";
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
										echo "Sakrît ar kaimiòa<br>";
										$ist = array('kopa_ar' => '',
													'vietas_id' => $istabinas_id
													);
										$radamas_istabas['TWIN'][] = $ist;
										
									}*/
									
									//echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar savçjo<br><br>";
								}
								//ja nav, pârbauda, pârbauda, vai sakrît dzimums
								else{
									
									$kaimins = $dalibn->GetId($did_kaimina[0]);
									/*echo "<br>Kaimiòð:<br>";
									var_dump($kaimins);
									echo "<br><br>";
									echo "<br>ES:<br>";*/
									$celotajs = $dalibn->GetId($active_did);
									//var_dump($celotajs);
									//echo "<br><br>";
									//ja sakrît dzimums ar kaimiòu, ðo numuriòu var piedâvât
									if ($kaimins['dzimta'] == $celotajs['dzimta']){
										if ($kaimins['dzimta'] == 's')
											$kopa_ar = 'Sieviete';
										elseif ($kaimins['dzimta'] == 'v')
											$kopa_ar = 'Vîrietis';
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
										//echo "<br><br>pustvins ar ID <b>$istabinas_id</b> ar sveðo<br><br>";
										//$ir_pustwins = TRUE;
									}
								}
							}
						}						
					}
					//visa TWIN istabiòa ir tukða
					elseif ($istabina['vietas_aiznemtas'] == 0 && !isset($pilns_twins)){
						//echo "2 vietas brîvas<br>";
						$ist = array('kopa_ar' => array(),
									'vietas_id' => $istabinas_id
									);
						$radamas_istabas['TWIN_full'][] = $ist;
					
						$pilns_twins = $istabinas_id;
					}					
				}
				//visas pârçjâs istabiòas izòemtot TWIN
				elseif( !array_key_exists($istabina['veids'],$radamas_istabas)){
					if (strtoupper($istabina['veids']) == 'DOUBLE'){
						
						$var_piedavat_double = $this->CanOfferDouble($online_rez_id);
						if (DEBUG) {
							echo "<b>Var piedâvât double:</b>";
							var_dump($var_piedavat_double);
						}
						if ($var_piedavat_double){
							if ($istabina['vietas_aiznemtas'] == 1){
								foreach ($dalibn_id_arr as $active_did){
									$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									if (!empty($did_kaimina)){	
										//ja arî otrs cilvçks ir no ðîs paðas rezervâcijas, tad ðo numuriòu var piedâvât
										if (in_array($did_kaimina[0],$_SESSION['reservation']['dalibn_id_arr'])){
											
											//ja rezervçjis ir pats dalîbnieks
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
											
											//echo "<br><br>DOUBLE ar ID <b>$istabinas_id</b> ar savçjo<br><br>";
										}
									}
								}
							}
							//brîvas abas vietas DOUBLÂ
							else{
								$ist = array('kopa_ar' => array(),
											'vietas_id' => $istabinas_id
											);
								$radamas_istabas[$istabina['veids']][] = $ist;
							}
						}
					}
				
					// ja 3-.. vietîgâ istabâ ir palikuðas brîvas vietas, pârbauda, vai tâs visas nav bçrnu
					//PAGAIDÂM vairs nepiedâvâjam trîsvietîgas istabiòas!!! (no 13.10.2017)
					if ($istabina['vietas_kopa'] >=3 && $istabina['pieejams_online'] && (in_array($_SESSION['profili_id'],$this->db->tester_profiles))){
						$var_piedavat = 0;
						$brivas_vietas = $istabina['vietas_kopa'] - $istabina['vietas_aiznemtas'];
						//piedâvâ tikai tad 3+vietîgâs istabiòas, ja VISAS vietas ir PILNÎBÂ BRÎVAS (saskaòâ ar Artas 06/06/2019 e-pastu)
						//19.06.2019 RT:nepiedâvâ vairâkvietîgas istabiòas nekâ rezrevâcija ir dalîbnieki
						if ($istabina['vietas_kopa'] == $brivas_vietas && $istabina['vietas_kopa'] <= $_SESSION['reservation']['traveller_count']){
							//var_dump($istabina['vietas_kopa']);
							//var_dump($_SESSION['reservation']['traveller_count']);
							//ja tas ir numuriòð ar kopîgu gultu, pârbauda, vai to vispâr drîkst piedâvât:	
							//echo "veids:".$istabina['veids'];
							if (startsWith(strtoupper($istabina['veids']),'DOUBLE')){
				
								$var_piedavat = $this->CanOfferDouble($online_rez_id);
								if (DEBUG){
									echo "var piedâvât: $var_piedavat <br>";
								}
							}
							else $var_piedavat = 1;
						}
					
						
						if ($var_piedavat){
							
							if (DEBUG)	echo "<br>Brîvâs vietas: $brivas_vietas <br>";
							//ja ir palikuðas tikai bçrnu vietas
							//pârbauda, vai rezervâcijâ ir bçrni
							$children = $online_rez->WithChildren($online_rez_id);
							if (DEBUG){
								echo "<br>Bçrnu skaits:";
								var_dump($children);
								echo "<br><br>";
							}
							if ($brivas_vietas == $istabina['vietas_bernu']){
								if (DEBUG) echo "palikuðas tikai bçrnu vietas";					
								
								
								//ja rezervâcija ir bçrns(i)
								if (count($children)>0){
									//$did_kaimina = $pieteikums->GetDidVid($istabinas_id,$active_did);
									$kopa_ar_arr = array();
									//foreach ($dalibn_id_arr as $active_did){
									$did_kaiminu = $pieteikums->GetDidVid($istabinas_id);
										
									foreach ($did_kaiminu as $did_kaimina){
																		
										//vai arî otrs cilvçks ir no ðîs paðas rezervâcijas
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
							//ir brîvas arî pieauguðo vietas 
							else{
								//ja visas vietas vçl brîvas
								if ($brivas_vietas == $istabina['vietas_kopa']){
									//ja rezervâcija ir bçrns(i)
									if (count($children)>0){
										if (DEBUG) echo "visas vietas vçl brîvas";
										$ist = array('kopa_ar' => array(),
												'vietas_id' => $istabinas_id
												);
										$radamas_istabas[$istabina['veids']][] = $ist;
									}
								}
								//ja ir jau kaimiòi
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
									
											//vai arî otrs cilvçks ir no ðîs paðas rezervâcijas
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
													/*echo "KAIMIÒÐ";
													var_dump($kaimins);
													echo "<br><br>";*/
													
												//}
												//paða dalîbnieka rezervçtais numuriòð
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
									$ist = array(//'kopa_ar' => '(kopâ ar '.implode(', ',$kopa_ar_arr).')',
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
					}
					//SINGLE numuriòi
					elseif ($istabina['vietas_kopa']==1){
						$ist = array('kopa_ar' => array(),
									'vietas_id' => $istabinas_id
									);
						$radamas_istabas[$istabina['veids']][] = $ist;
					}
					
				}
			}
		}
	
		//---------END 3 un vairâk ceïot.-----------------------------------//
		
		if (DEBUG){
			echo "<br>Râdâmâs istabas:<br>";
			var_dump($radamas_istabas);	
			echo "<br><br>";
		}
		
		$data['viesnicas']= array();
		//vai vispâr ir istabas, ko piedâvât
		$radamo_ist_id = array();
		if (count($radamas_istabas)>0){
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
				echo "<br>Râdâmâs istabas sakârtoti:<br>";
				var_dump($data['viesnicas']);		
				echo "<br><br>";
			}
		}
		else{					
			//$error['viesnica'] = "Atvainojiet, ðim ceïojumam paðreiz nav iespçjams norezervçt viesnîcas tieðsaitç, lûdzu, sazinieties ar IMPRO.";
			//$data['errors'] = $error;
		}
		//return $data['viesnicas'];
		/*echo "viesnicas<br>";
		var_dump($data['viesnicas']);
		echo "<br><br>";
		*/
		//Atrod jau norezervçtâs istabas
		$istabas  =  $viesnicas->GetViesnicaAll($online_rez_id);
		$rezerveto_vietu_skaits = count(array_filter($istabas));
		$celotaju_skaits = $_SESSION['reservation']['traveller_count'];
		
		if (DEBUG){
			echo "<b>Rezervçtâs Viesnîcas</b><br>";
			var_dump($istabas);
			echo "<br><br>";
		
			echo "<br>radamo istabu id arr<br>";
			var_dump($radamo_ist_id);
			echo "<br><br>";
		}
		
		//Ieliek râdâmo istabu masîvâ, ja vçl nav
		$data['istabas'] = array();
		foreach ($istabas as $key=>$vid){
				if (!empty($vid)){
					//atrod aizòemto un brîvo vietu skaitu istabinjâ
					$aiznemtas_vietas = $this->GetOccupiedCountId($vid);
					if (DEBUG) echo "Aizòemtâs vietas: $aiznemtas_vietas <br>";
					$viesnica = $this->GetId($vid);
					if (DEBUG){
						echo "Viesnica:";
						var_dump($viesnica);
						echo "<br><br>";
					}
					$vietas_kopa = $viesnica['vietas'];
					$brivas_vietas = $vietas_kopa - $aiznemtas_vietas;
					if ($celotaju_skaits - $rezerveto_vietu_skaits <= $brivas_vietas){
						//skatâs, vai ir masîvâ pilnîgi tukðs ðî paða tipa numuriòð
						//ja ir , tad to izòem
					//	echo "IR";
						foreach ($data['viesnicas'] as $key=>$viesn){
							if ($viesn['veids'] == $viesnica['nosaukums'] && count($viesn['kopa_ar'])==0){
								//echo "jâizòem";
								unset($data['viesnicas'][$key]);
							}
						}
					}
					if (!in_array($vid, $radamo_ist_id)){
						$did = $key;
						
						$kaiminu_did_arr = $pieteikums->GetDidVid($vid);
						/*echo "Kaimiòi:";
						var_dump($kaiminu_did_arr);
						echo "<br><br>";
						*/
						$kopa_ar_arr = array();
						foreach($kaiminu_did_arr as $did){
							$kaimins = $dalibn->GetId($did);
							$birthday = $dalibn->Birthday($did);
							if (empty($birthday) or $birthday == null) die('kïûda: Nav iespçjams noteikt vecumu dalîbniekam ar ID#'.$did);
								/*if ($_SESSION['profili_id'] == 5116){
									var_dump($beigu_dat);
									echo "<<<birthday<br>";
									
								}*/
							
							$diff = $beigu_dat->diff($birthday);
							$age = $diff->format('%y');
							//echo "Kaimiòa vecums: $age <br>";
							
							if (in_array($did,$dalibn_id_arr)){
								$savejais = 1;
								$nosaukums = $kaimins['vards'].' '.$kaimins['uzvards'];
							}
							else {
								$savejais = 0;
								if ($kaimins['dzimta'] == 's')
									$nosaukums = 'Sieviete';
								elseif ($kaimins['dzimta'] == 'v')
									$nosaukums = 'Vîrietis';
								 
							}
							
							if ($age<18) $berns = 1; else $berns=0;
							$kopa_ar_arr[]= array('kopa_ar_dzimums' => $kaimins['dzimta'],
													'kopa_ar_nosaukums' => $nosaukums,
													'kopa_ar_savejo' => $savejais,
													'kopa_ar_did' => $did,
													'kopa_ar_berns' => $berns);
								
						}
						$bernu_vietas = $this->GetBernuVietas($vid);
						//tâtad visas vietas aizòemtas ðajâ istabiòâ
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
		//saliek atrastâs viesniicas citaa masiivaa
		if (isset($data['viesnicas'])){
			
			$viesnicas = array();
			foreach ($data['viesnicas'] as $viesnica){
				$data['istabas'][] = $viesnica;
				//$data['istabas'][0][]= $this->GetId($viesnica['vietas_id']);
			}
			//$data['istabas'] = array_map("unserialize", array_unique(array_map("serialize", $data['istabas'])));
			//$data['istabas'] = array_unique($data['istabas']);
		}
		//Ja ir divi dalibnieki un viens ir izvelejies double, bet otrs neko, otram piedava tikai doubli TIKAI TAD JA DAÞÂDOI DZIMUMI 
		//$limit_to_double = false;
		$data_ist_tmp = array();
		if ($_SESSION['reservation']['traveller_count'] == 2){
		//	$skaits = count(array_filter($istabas));
			//Ja ir izvçlçjies tikai viens no dalîbniekiem				
			if ($rezerveto_vietu_skaits == 1) {	
				foreach ($data['istabas'] as $istaba){
					if ($istaba['veids'] == 'DOUBLE' && count($istaba['kopa_ar']) == 1){
						$pirmais_celotajs = $dalibn->GetId($dalibn_id_arr[0]);
						$otrais_celotajs = $dalibn->GetId($dalibn_id_arr[1]);
						if ($pirmais_celotajs['dzimta'] != $otrais_celotajs['dzimta']){
							if (DEBUG){
								var_dump($pirmais_celotajs);
								echo "did_arr:<br>";
								var_dump($dalibn_id_arr);
								echo "<br><br>";
							}
							//echo "<b>DOUBLE</b><br>";
							//$limit_to_double = true;
							$data_ist_tmp[] = $istaba;
						}
					
					}
				}
			}
		}

		if (count($data_ist_tmp)==1){
			$data['istabas'] = $data_ist_tmp;
		}
				
		//sakârtojam pçc vietu skaita UN pçc numuriòu veida
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
	
	//atgrieþ rezervâcijas dalîbnieku rezervçtâs istabiòas
	function GetViesnicaAll($online_rez_id){
		require_once("m_online_rez.php");		
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");		
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();	
		$online_rez = new OnlineRez();
		//dabû visu dalîbnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		if (DEBUG){
			echo "<br>MODELdalîbnieki:</br>";
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
	
	//atgrieþ rezervçto viesnîcas numuriòu, ja tâds ir
	function GetViesnica($pid){
		$qry = "SELECT vid FROM piet_saite WHERE deleted!=1 
				AND vid IS NOT NULL AND vid>0";

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
						
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['vid'];
		}
		else return 0;
		
	}
	
	
	//atgrieþ bçrnu un vietu skaitu istabiòâ: no 03.06.2019 skatâs lauku 'bernu_vietas', nevis analizç nosaukumu
	function GetBernuVietas($id){
		$row = $this->GetId($id);
		$bernu_vietas = (int)$row['bernu_vietas'];
		
		return $bernu_vietas;
	}
	
	//ieliek rezervâcijas dalîbnieku izstabiòâ, ja ir esoðie - tos izòem
	function BookRoomForDid($online_rez_id, $vid,$did,$aiznemis_did){
		require_once("m_pieteikums.php");
		require_once("m_kajite.php");
		require_once("m_online_rez.php");
		$kajites = new Kajite();
		$pieteikums = new Pieteikums();
		$online_rez = new OnlineRez();
		
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		//vçstures saglabâðanai
		$old_vals = $pieteikums->GetId($pid);
		$old_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		
		if ($aiznemis_did){
			$values = array('vid'=>0);
			$where_arr = array('vid' => $vid,
								'did' => $aiznemis_did
								);
			
			$this->db->UpdateWhere('piet_saite',$values,$where_arr);	
		}		
		
		

		//saglabâ jauno istabiòu
		$where_arr = array('pid' => $pid							
							);
		//pârbauda, vai ir kajîtes ðim ceïojumam
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
		$this->db->UpdateWhere('piet_saite',array('vid'=>$vid),$where_arr,$where_cond);
		$new_vals = $pieteikums->GetId($pid);
		$new_saites_arr = $pieteikums->GetSaitesAssoc($pid);
		$this->db->SavePietHistory($old_saites_arr,$new_saites_arr,$pid,$old_vals,$new_vals);		

	}
	
	function RezervetasViesnicas($online_rez_id,$radamo_ist_id = array()){
		$istabas = $this->GetViesnicaAll($online_rez_id);
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
						$viesnica = $this->GetId($vid);

						$kaiminu_did_arr = $pieteikums->GetDidVid($vid);
						if (DEBUG){
							echo "Kaimiòi:";
							var_dump($kaiminu_did_arr);
							echo "<br><br>";
						}
						
						$kopa_ar_arr = array();
						foreach($kaiminu_did_arr as $did){
							$kaimins = $dalibn->GetId($did);
							$birthday = $dalibn->Birthday($did);
							$diff = $beigu_dat->diff($birthday);
							$age = $diff->format('%y');
							//echo "Kaimiòa vecums: $age <br>";
							
							if (in_array($did,$dalibn_id_arr)){
								$savejais = 1;
								$nosaukums = $kaimins['vards'].' '.$kaimins['uzvards'];
							}
							else {
								$savejais = 0;
								if ($kaimins['dzimta'] == 's')
									$nosaukums = 'Sieviete';
								elseif ($kaimins['dzimta'] == 'v')
									$nosaukums = 'Vîrietis';
								 
							}
							
							if ($age<18) $berns = 1; else $berns=0;
							$kopa_ar_arr[]= array('kopa_ar_dzimums' => $kaimins['dzimta'],
													'kopa_ar_nosaukums' => $nosaukums,
													'kopa_ar_savejo' => $savejais,
													'kopa_ar_did' => $did,
													'kopa_ar_berns' => $berns);
								
						}
						$bernu_vietas = $this->GetBernuVietas($vid);
						//tâtad visas vietas aizòemtas ðajâ istabiòâ
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
	
	//atgrieþ 1 vai 0, vai dalîbnieks ir rezervçjis Vienvietîgu numuriòu
	function IsInSingle($pid){
		$vid= $this->GetViesnica($pid);
		$viesn = $this->GetId($vid);
		if ($viesn['vietas'] == 1){
			return 1;
		}
		else return 0;
	}
	
	//atgrieþ 1 vai 0, vai piesaitîtajam numuriòam ir norâdîta cena
	function HasPrice($pid){
		$vid= $this->GetViesnica($pid);
		$viesn = $this->GetId($vid);
		if ($viesn['vietu_veidi_id']){
			return 1;
		}
		else return 0;
	}

	//atgrieþ true, ja rezervâcijâ ir pilngadîgi cilvçki ar daþâdiem dzimumiem
	function CanOfferDouble($online_rez_id){
		require_once("m_online_rez.php");		
		require_once("m_pieteikums.php");
		require_once("m_dalibn.php");		
		$dalibn = new Dalibn();
		$pieteikums = new Pieteikums();	
		$online_rez = new OnlineRez();
		//dabû visu dalîbnieku sarakstu
		$dalibn_id_arr = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
		$dzimumu_arr = array();
		$pieauguso_sk = 0;

		foreach ($dalibn_id_arr as $did){
			$berns = $dalibn->IsChild($did);
			$dalibnieks = $dalibn->GetId($did);
			if (!$berns){
				$pieauguso_sk++;
				if (!in_array($dalibnieks['dzimta'],$dzimumu_arr))
					$dzimumu_arr[] = $dalibnieks['dzimta'];
			}
		}
		//ja rezervâcijâ ir vismaz 2 pieauguðie ar daþâdiem dzimumiem
		if ($pieauguso_sk >= 2 && count($dzimumu_arr) == 2){
			return true;
		}
		else return false;
		
	}
	
	//atgrieþ, ar ko kopâ dalîbnieks ir ielikts istabiòâ
	function GetKaimini($vid,$did,$online_rez){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$qry = "SELECT ps.*,p.online_rez FROM piet_saite ps,pieteikums p 
				WHERE p.id=ps.pid 
				AND vid= ? AND ps.deleted!=1 AND p.deleted=0 AND ps.did!=?";
		$params = array($vid,$did);
		if (DEBUG){
			echo $qry."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($qry,$params);
				
		$dalibnieku_arr = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$kaimins = $dalibn->GetId($row['did']);
			
			//pârbauda, vai daîbnieks ir no ðîs paðas rezervâcijas
			if ($online_rez == $row['online_rez']){
				//var attçlot dalîbnieka vârdu
				
				$dalibnieku_arr[] = $kaimins['vards'].' '.$kaimins['uzvards'];
			}
			else{
				if ($kaimins['dzimta'] == 's') $img = '<i>Sieviete</i>';
				elseif ($kaimins['dzimta'] == 'v') $img= '<i>Vîrietis</i>';
				else $img = '<i>Cits</i>';
				$dalibnieku_arr[] = $img;
				
				//$this->GetDzimtaImg($kaimins['dzimta']);
			}
			
			
		}
		if (DEBUG){
			echo 'kaimiòu arr:<br>';
			var_dump($dalibnieku_arr);
		}
		return $dalibnieku_arr;		
	
	}
	
	//atgrieþ dzimuma atbilstoðu ikonu 
	function GetDzimtaImg($dzimta){
		$img = '';
		if ($dzimta == 's'){
			$img  = $this->bed_images['adult_F'];
		}
		else if ($dzimta == 'v'){
			$img  = $this->bed_images['adult_M'];
		}
		return $img;
	}
	
	//atgrieþ istabiòu veidus, kurus drîkst tirgot online
	function GetViesnicasVeidiOnline(){
		$qry = "SELECT nosaukums FROM viesnicas_veidi_online";		
		$result = $this->db->Query($qry);
		$data = array();			
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;
		}
		return $data;
	}
	
	function GetKaiminsDzimta($vid){
		require_once('m_dalibn.php');
		$dalibn = new Dalibn();
		$qry = "SELECT did from piet_saite WHERE deleted=0 AND vid=?";
		$params = array($vid);
		$result = $this->db->Query($qry,$params);
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$did = $row['did'];
			$kaimins = $dalibn->GetId($did);			
			return $kaimins['dzimta'];
		}		
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
						'vecums' => $age);
			$data[] = $dalibnieks;
		}
		return $data;
	}
}


?>