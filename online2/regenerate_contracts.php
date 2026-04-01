<?require_once('m_init.php');



$db = new Db;
//izveido un saglabâ lîgumu
function Contract($rez_id = 0){
	//echo "contract";
	require_once('m_ligumi.php');
	$ligumi = new Ligumi();
	
	if (empty($rez_id)){
		//$online_rez = 19921;
		$res_status = ResStatus();
		if (!is_array($res_status)){
			echo $res_status;
			exit();
		}
		$rez_id = $res_status['online_rez'];
	}
	$ligums = $ligumi->GetOnlineRez($rez_id);
	if (DEBUG){
		echo "Lîgums:<br>";
		var_dump($ligums);
		echo "<br><br>";
	}
	
	
	
	if (empty($ligums['ligums_id'])){
	
		//jâtaisa jauns lîgums

		$values = array( 'ligums' => 'skatît pdf',
						'gid' => $ligums['gid'],
						'rez_id' => $rez_id/*,
						'accepted' => 1,
						'accepted_date' => date('Y-m-d H:i:s')*/
						);
		$ligums_id = $ligumi->Insert($values,$rez_id);
		//global $db;
		
		//echo "upd";
		//$db->UpdateWhere('pieteikums',array('ligums_id' => $ligums_id), array('online_rez' => $_SESSION['reservation']['online_rez_id']));
		//mssql_query("update pieteikums set ligums_id='".$ligums_id."' where id in (".$_POST['pids'].")");
		
	}
	else{
		$ligums_id = $ligums['ligums_id'];
	}
	//echo "Lîguma ID: $ligums_id <br><br>";
	return $ligums_id;
	//exit();
	/*
	$pieteikumsQuery=mssql_query("select id,gid,ligums_id from pieteikums where id in (".$_POST['pids'].")");
	$pieteikums=mssql_fetch_array($pieteikumsQuery);
	if($pieteikums['ligums_id']==""){
		mssql_query("insert into ligumi (ligums, gid, accepted, accepted_date) values ('skat?t pdf','".$pieteikums['gid']."', '1', '".date('Y-m-d H:i:s')."')");
		$newIdQuery=mssql_query("SELECT IDENT_CURRENT('ligumi') as newId");
		$newIdResult=mssql_fetch_array($newIdQuery);
		$ligums_id=$newIdResult['newId'];
		mssql_query("update pieteikums set ligums_id='".$ligums_id."' where id in (".$_POST['pids'].")");
	}else{
		$ligums_id=$pieteikums['ligums_id'];
		mssql_query("update pieteikums set ligums_id='".$ligums_id."' where id in (".$_POST['pids'].")");
	}
	*/
}
function ReGenerateContract($online_rez){
	$show=false;
	$avanss =  0;
	if (DEBUG) echo "AVANSS:$avanss<br>";
	if (DEBUG)	echo "ìenerçjam lîgumu";
	global $db;
	require_once("i_functions.php");
	require_once('m_ligumi.php');
	$ligumi  = new Ligumi();
/*	$ligums = $ligumi->GetOnlineRez($_SESSION['reservation']['online_rez_id']);*/

	$ligums_id = Contract($online_rez);
	if (DEBUG)	echo "lîguma id ir: $ligums_id <br>";
	//echo "Lîgums:<br>";
	//$ligums_id = $ligums['ligums_id'];
	//var_dump($ligums_id);
	
	$ligums = $ligumi->GetId($ligums_id);
	//var_dump($ligums);
	//	exit();
	

	
	$thousands = floor($ligums_id/1000)+1;
	$dir  = '\\\\ser-db3\\pdf-ligumi$\\'.$thousands;	
	

	
	//$dir  = '\\\\ser-db3\\e$\\pdf-ligumi\\'.$thousands;
	//$dir  = 'ligumi-pdf\\' . $thousands;
	//$dir = 'ligumi';
	if (DEBUG){
		echo "<br>DIR:</br>";
		var_dump($dir);
		echo "<br><br>";
		
	}
	if (!is_dir($dir)){
		
		mkdir($dir,0777);
	}
	
	

	if (DEBUG){
		echo "DIR: $dir <br>";
		echo "Lîgums:<br>";
		var_dump($ligums['file_name']);
		echo "<br><br>";
	}
	//$res_status = ResStatus();
	$ir_iemaksas = true; //$res_status['ir_iemaksas'];
	if (!empty($ligums['file_name'])){
		//echo "ir lôigums";
		$old_filename = $dir. '\\'. $ligums['file_name'];
		//echo "OLD FILENAME: $old_filename <br>";
		//JA LÎGUMS IR AKCEPTÇTS un veikta pirmâ iemaksa, NEKO JAUNU NEÌENERÇ, ATTÇLO ESOÐO
	//ja ir uzìenerçts iepriekð pdf fails, to nodzçð
			if (file_exists($old_filename)){
				if (DEBUG)echo "dzçðam";
				//unlink($old_filename);
			}
		
	}
	
		
			

	

	require_once('m_grupa_izbr_vieta.php');
	require_once('m_init.php');
	require_once('m_marsruts.php');
	require_once('m_profili.php');
	require_once('m_pieteikums.php');
	require_once('m_grupa.php');
	require_once('m_vietu_veidi.php');
	$gr = new Grupa();
	$gr_izbr_vieta = new GrupaIzbrVieta();
	$marsruts = new Marsruts();
	$pieteikums = new Pieteikums();
	$vietu_veidi = new VietuVeidi();		
	
	include 'i_summa_vardiem.php';
	//include 'i_functions.php';
	//echo phpinfo();

	include_once("MPDF57/mpdf.php");
	 
	$mpdf=new mPDF('utf-8','A4','','' , 0 , 0 , 0 , 0 , 0 , 0); 
	$mpdf->showImageErrors = true; 
	$mpdf->SetDisplayMode('fullpage');
	 

	//$r = mssql_query("select vards,adrese from dalibn where id =1885");
	//$m = mssql_fetch_array($r);

	//$ligums_id = $_POST['ligums_id'];

	$cena = 0;
	$papild = 0;
	$atlaide = 0;
	$piemaksa = 0;
	//$avanss = 0;

	/*$r = mssql_query("select id,gid,summaEUR,iemaksasEUR,izmaksasEUR,atlaidesEUR,sadardzinEUR from pieteikums where deleted = 0 
	and ligums_id = $ligums_id");*/
	$pieteikumi = $pieteikums->GetPietOnlineRez($online_rez);
	//echo "Pietiekumi:<br>";
	//var_dump($pieteikumi);
	//echo "<br><br>";
	/*$r = mssql_query("select id,gid,summaEUR,iemaksasEUR,izmaksasEUR,atlaidesEUR,sadardzinEUR 
						from pieteikums where deleted = 0 
					and online_rez = $online_rez");*/
	$dal = array();
	foreach ($pieteikumi as $m){
		$liguma_datums = $db->Date2Str($m['datums']);
		//var_dump($m);
		//echo "<br><br>";
	//while ($m=mssql_fetch_array($r)) {
		$cena = $cena + $m['summaEUR'];
		$avanss = $avanss + $m['iemaksasEUR'] - $m['izmaksasEUR'];
		$atlaide = $atlaide + $m['atlaidesEUR'];
		$piemaksa = $piemaksa + $m['sadardzinEUR'];
		$pid = $m['id'];
		$gid = $m['gid'];
		//echo "GRpas ID<b>$gid</b><br>";
		// atrodam cenu par papildvietam
		
		// atrodam cilvçku
		//atrod dalîbniekus pçc pieteikuma ID
		$pers = array();
		$mdal= $pieteikums->GetDalibnPid($pid);
		if (!empty($m['paseNR']) && !empty($m['paseS']) && !empty($m['paseDERdat'])){
			$mdal['paseS'] = $m['paseS'];
			$mdal['paseNR'] = $m['paseNR'];
			$mdal['paseDERdat'] = $m['paseDERdat'];
			
		}
		if (!empty($m['idNR']) && !empty($m['idS']) && !empty($m['idDerDat'])){
			$mdal['idS'] = $m['idS'];
			$mdal['idNR'] = $m['idNR'];
			$mdal['idDerDat'] = $m['idDerDat'];
		}
		//echo "<br>Dalîbnieki:<br>";
		//var_dump($mdal);
		//echo "<br><br>";
		/*$rdal = mssql_query("select vards,uzvards,pk1,pk2,paseS,paseNr,convert(varchar,paseDerDat,104) as paseDerDat,idS,idNr,convert(varchar,idDerDat,104) as idDerDat,adrese,pilseta,indekss,talrunisM,talrunisD,talrunisMob,eadr,novads,dzimta 
							from dalibn 
							where id in (select did from piet_saite where deleted = 0 and pid = $pid)");*/
		
		//if ($mdal = mssql_fetch_array($rdal)) {
			$mdal['cena'] = $m['summaEUR'];
			
			$dal[] = $mdal;
		//}
		//die("select isnull(sum(summaEUR),0) x from piet_saite inner join 
		//	vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id
		//	where pid = $pid and tips = 'P' and piet_saite.deleted = 0");
		
		//atrod papildvietu cenu
		
		/*$rpap = mssql_query("select isnull(sum(summaEUR),0) x from piet_saite inner join 
							vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id
							where pid = $pid and tips = 'P' and piet_saite.deleted = 0");*/
		$mpap = $pieteikums->GetPapildvSummaPid($pid);
		//if ($mpap = mssql_fetch_array($rpap)) {
			$papild += $mpap['x'];
		//}
		
	}
//	var_dump($liguma_datums);
	if (!$avanss){
		if (isset($_GET['avanss'])){
			$avanss = $_GET['avanss'];
		}
	}
	if (DEBUG)echo "avanss: $avanss <br><br>";
	$cena = $cena - $atlaide + $piemaksa;

	$cenav = nauda($cena,'eiro','cents','centi');

	// saformatjema cenas
	$cena = number_format($cena,2);
	$papild = number_format($papild,2);
	$avanss = number_format($avanss,2);
	$atlaide = number_format($atlaide,2);
	/*
	$rgrupa = mssql_query("select mid,izbr_vieta,convert(varchar,izbr_laiks,120) as izbr_laiks, convert(varchar,sakuma_dat,104) as sakuma_dat, convert(varchar,beigu_dat,104) as beigu_dat from grupa where id = $gid");
	$mgrupa = mssql_fetch_array($rgrupa);*/
	//atrod grupu
	$mgrupa = $gr->GetId($gid);
	//echo "GRUPA<br>";
//	var_dump($mgrupa);
	//echo "<br><br>";
	$mid = $mgrupa['mID'];
//	echo "sakuma dat";
//	var_dump($mgrupa['sakuma_dat']);
	$sakums = $db->Date2Str($mgrupa['sakuma_dat']);
	$beigas = $db->Date2Str($mgrupa['beigu_dat']);
	//echo "izbraukðanas laiks:";
	//var_dump($mgrupa['izbr_laiks']);
	//echo "<br><br>";
	$laiks_a = $db->Time2Str($mgrupa['izbr_laiks']);
	$laiks = date("H:i",strtotime($laiks_a));
	/*
	$laiks_a = explode(' ',$mgrupa['izbr_laiks']);
	$laiks_aa = explode(':',$laiks_a[1]);
	$laiks = $laiks_aa[0].':'.$laiks_aa[1];*/

	$izbr_vieta = $mgrupa['izbr_vieta'];

	//dabû marðrutu
	$mmars = $marsruts->GetId($mid);
	//echo "Marðruts:<br>";
	//var_dump($mmars);
	//echo "<br><br>";
	/*
	$rmars = mssql_query("select v2 from marsruts where id = $mid");
	$mmars = mssql_fetch_array($rmars);
	*/
	$mvieta = $gr_izbr_vieta->GetId($izbr_vieta);
	if (!empty($mvieta)){
		$vieta = $mvieta['nosaukums'];
	}
	else $vieta = '-';
		
	/*
	$rvieta = mssql_query("select nosaukums from grupa_izbr_vieta where id = $izbr_vieta");
	if ($mvieta = mssql_fetch_array($rvieta))
		$vieta = $mvieta['nosaukums'];
	else
		$vieta = '-';
	*/
	
	$celojums = Decode($mmars['v2']);

	

	//echo $dal[0]['vards'];
	//die();


	$text = "<html>";
	$text .= "<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /></head>";
	$text .= "<body>";
	$text .= "<div style='margin:50px'><BR>

		<table cellspacing=0 cellpadding=0 border=0 width=100%>";
	$text .= "<tr>";
	$text .= "<td><img src=img/logo2.png width=120></td>";
	$text .= "	<td align=right valign=top>
					<div style='font-size:22px;font-family:Arial'>LÎGUMS<div>
					<div style='font-size:12px;font-family:Arial'><BR><BR>".$liguma_datums."<div>
				</td>
			</tr>
		</table>
		<BR><BR>
		<style>
			body{line-height:165%;}
			.base {font-size:9px;font-family:Arial;line-height:125%;}
			.base {font-size:9px;font-family:Arial;}
			.normal {font-size:12px;font-family:Arial;line-height:150%;}
			.bold {font-size:12px;font-family:Arial;font-weight:bold;font-style:italic;}
			.bbold {font-size:14px;font-family:Arial;font-weight:bold;}
			.td {font-size:12px;font-family:Arial;}
			.tdb {font-size:12px;font-family:Arial;font-weight:bold;}
			.tbl {background-color:#000;border-spacing: 2px;}
			.tbl td,th,caption{background-color:#fff}
		</style>
		
		
		<p class=base>SIA IMPRO CEÏOJUMI, reìistrçta LR Uzòçmumu reìistrâ 1994.gada 19.decembrî ar reì. Nr.40003235627, biroja adrese: Meríeïa iela
13-122, Rîgâ, LV-1050, reìistrâcijas Nr. tûrisma pakalpojumu sniedzçju datu bâzç TATO – 2010 - 7, turpmâk tekstâ “IMPRO”, no vienas
puses, un persona, kuras dati uzrâdîti ðî lîguma ailç “KLIENTS”, turpmâk tekstâ KLIENTS, no otras puses, bet abi kopâ turpmâk tekstâ
“PUSES”, ievçrojot PUÐU nopietni, apzinîgi un brîvi, bez viltus, maldiem un spaidiem pausto gribu, noslçdz* ðo lîgumu par sekojoðo:</p>
		<div class=bold>
			Ziòas par KLIENTU
		</div>
		
		<table width=100% class=tbl>
			<tr>
				<td class=td>Vârds</td>
				<td class=td>P.K.</td>
				<td class=td>Pase</td>
				<td class=td>Der. Term.</td>
				<td class=td>Pers. apl.</td>
				<td class=td>Der. term.</td>
				<td class=td>Cena</td>
			</tr>
		";
		$dalibn_skaits = count($dal);
		foreach ($dal as $d) {
			if (DEBUG){
				echo "<br>DALÎBNIEKS<br>";
				var_dump($d);
				echo "<br><br>";
			}
		//	var_dump($db->Date2Str($d['paseDerDat']));
		//	echo "<---pases term <br>";
			if ((int) $d['novads']>0){
				require_once('m_novads.php');
				$novads = new Novads();
				
				$nov = $novads->GetId($d['novads']);
				$d['novads'] = $nov['nosaukums'].' novads';
			}
			$text .= "<tr>
				<td class=td><b>".strtoupper($d['vards']).' '.strtoupper($d['uzvards'])."</b></td>
				<td class=td >".$d['pk1'].'-'.$d['pk2']."</td>
				<td class=td width='90px'>".$d['paseS'].$d['paseNR']."</td>
				<td class=td width='70px'>".$db->Date2Str($d['paseDERdat'])."</td>
				<td class=td width='90px'>".$d['idS'].$d['idNR']."</td>
				<td class=td width='70px'>".$db->Date2Str($d['idDerDat'])."</td>
				<td class=td align='right'>".number_format($d['cena'],2)."</td>
			</tr>";
			if (!empty($d['adrese'])){
			$text .= "<tr>
						<td class=td colspan=7>Adrese: ".$d['adrese'].', '.$d['pilseta'].', '.$d['novads'].', LV-'.$d['indekss']."</td>
					</tr>";
			}
			$text .= "<tr>
						<td class=td colspan=7>";
			if ($d['talrunisM'])
				$text .= 'Tel. mâjâs. '.' '.$d['talrunisM'].'; ';
			if ($d['talrunisD'])
				$text .= 'Tel. darbâ. '.' '.$d['talrunisD'].'; ';
			if ($d['talrunisMob'])
				$text .= 'Mob. '.' '.$d['talrunisMob'].'; ';
			if ($d['eadr'])
				$text .= 'E-pasts '.' '.$d['eadr'].'; ';
			
			$text .= "	</td></tr>";
		}
		
		$text .= "

		
		</table>
		<div class=normal>
			Lai saòemtu aktuâlo informâciju par IMPRO piedâvâjumiem e-pastâ, iespçjams reìistrçties mûsu mâjaslapâ www.impro.lv!
		</div>

			<BR>
			<div class=bold>1. Lîguma priekðmets</div>
			<div class=normal>1.1. IMPRO sagatavo un pârdod, bet KLIENTS pçrk tûrisma pakalpojumus, turpmâk tekstâ \"Ceïojums\", saskaòâ ar ðî lîguma un
			abpusçji apspriesta ceïojuma apraksta (pakalpojumu programmas) noteikumiem, kas ir ðî lîguma neatòemama sastâvdaïa.	</div>
			<BR>
			<div class=bbold>Ceïojuma nosaukums: $celojums</div>
			<div class=normal>Izbraukðanas datums, laiks un vieta: $sakums $laiks, $vieta.</div>
			<div class=normal>Ceïojuma beigu datums: $beigas</div>
		<p class=normal>
			Akceptçjot ðo lîgumu, KLIENTS apliecina, ka ir informçts par iespçjamâm izmaiòâm pakalpojumu programmâ ðî lîguma atrunâtos
			ietvaros un piekrît tiem bez papildus PUÐU rakstiskas vienoðanâs
		</p>

		<div class=normal><b><i>2. Papildu pakalpojumi un cena</i></b></div>

		<div class=normal>2.1. KLIENTS Ceïojuma laikâ rezervç papildvietu(-as) autobusâ par cenu $papild EUR</div>";
		//dabû kajîtes no peteikuma saites pçc rezervâcijas id
		
	/*
		
		$rkaj = mssql_query("select kvietas_veids,nosaukums from piet_saite 
			inner join kajite on kajite.id = piet_saite.kid
			inner join kajites_veidi on kajite.veids = kajites_veidi.id
			where 
			kvietas_veids <> 0
			and piet_saite.deleted = 0 
			and pid in 
			(select id from pieteikums where ligums_id = $ligums_id)");
	*/
		$kajites = '';
		$kveidi = array();
		$kveidi[1] = 'Standarta';
		$kveidi[2] = 'Bçrnu';
		$kveidi[5] = 'Pusaudþu';
		//echo "Kajîtes <br>";
		$rkaj = $pieteikums->GetKajitesOnlineRez($online_rez);
		//var_dump($rkaj);
	//	echo "<br><br>";
		if (count($rkaj)>0){
			foreach($rkaj as $mkaj){
			//while ($mkaj=mssql_fetch_array($rkaj)) {
				$kajites .= $mkaj['nosaukums'] .' '. $kveidi[$mkaj['kvietas_veids']].'; ';
			}
		}
		else{
			$kajites =  " ---";
		}
		
		$text .= "<div class=normal>2.2. KLIENTS izvçlas sekojoðus nakðòoðanas apstâkïus uz prâmjiem (Ziemeïvalstu marðrutos): $kajites</div>
		
		<div class=normal>2.3. KLIENTA îpaðâs prasîbas un izvçlçtie papildu pakalpojumi:</div>";
		//dabû pakalpjumus
		//$vietu_veidi1 = $vietu_veidi->GetAvailable($gid);
		//$rpak = $pieteikums->GetPakalp(0,$online_rez,$vietu_veidi1);
		/*if (DEBUG){
			echo "<br>Vietu veidi:<br>";
			var_dump($vietu_veidi);
			echo "<br><br>";
					echo "<br>pakalpojumi<br>";
				var_dump($rpak);
				echo "<br><br>";
				$pakalpojumi = $ligumi->GetPakalpId($ligums_id);
				var_dump($pakalpojumi);
				echo "<br><br>";
				
		}*/
		$rpak=$ligumi->GetPakalpId($ligums_id);
	/*
		$rpak = mssql_query("select 
			count(summaEUR) as sk,nosaukums,sum(summaEUR) as sum,tips from vietu_veidi inner join
			piet_saite on vietu_veidi.id = piet_saite.vietas_veids
			where deleted = 0 
			and kvietas_veids <> 3
			and isnull(kid,0) = 0
			and pid in 
			(select id from pieteikums where ligums_id = $ligums_id)
			group by nosaukums,tips");
			
	*/
		foreach ($rpak as $mpak){
			if (DEBUG){
					echo "vieta:<br>";
					var_dump($mpak);
					echo "<br><br>";
				}
			/*if ($count>0){
				$mpak = $vietu_veidi->GetId($vietas_id);
				*/
				
			//while ($mpak=mssql_fetch_array($rpak)) {
				//if (($mpak['sum']+0) && ($mpak['tips']=='X' || $mpak['tips']=='ED' || $mpak['tips']=='EX' || $mpak['tips']=='V1')) {
				//if($mpak['tips']=='X' || $mpak['tips']=='ED' || $mpak['tips']=='EX' || $mpak['tips']=='V1')) {
									
				//$text .= "<div class=normal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ".$mpak['nosaukums']." (".$mpak['sk']." gb. ".number_format($mpak['sum'],2)." EUR) </div>";
				if (!$mpak['kvietas_veids']) {
					
				$text .= "<div class=normal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ".$mpak['nosaukums'] . ' ('.$mpak['c'].' gab.) '.number_format($mpak['s'],2). " EUR</div>";
				
				}
			//}
		}
		$text .= "<div class=normal>2.4. KLIENTA pasûtîjumam tiek piemçrota atlaide: $atlaide EUR</div>

		<div class=normal>
			2.5.Ceïojuma pieteikumu IMPRO fiksç pçc tam, kad KLIENTS iepazinies ar lîgumu, akceptçjis to un veicis avansa iemaksu $avanss
			EUR apmçrâ, kura ietilpst Ceïojuma cenâ.	
		</div>
		<BR>
		<table width=100% class=tbl >
			<tr><td class=bold>
			2.6. Ceïojuma kopçjâ cena ir $cena EUR ($cenav)
			</td></tr>
		</table>";
	//	<table width=100% class=tbl style='page-break-after: always;' >

	$termini = $gr->GetPaymentDeadlinesId($gid);
	//var_dump($termini);
//	echo "<br><br>";
	$data['termini'] = array();
	$data['kopsumma'] = $cena;
	if ($termini['term1_dat'] && $termini['term1_summa']){
		
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term1_dat']),
										'summa' => number_format(round($termini['term1_summa']*$dalibn_skaits,2),2,'.',' ')
										);

	}
	if ($termini['term2_dat'] && $termini['term2_summa']){
		//if (($termini['term2_summa'] + $termini['term1_summa'])*$dalibn_skaits !=$data['kopsumma']){
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term2_dat']),
										'summa' => number_format(round(($termini['term2_summa'])*$dalibn_skaits,2),2,'.',' ')
										);
		//}
		
	}
	if ($termini['term3_dat']){
		$data['termini'][] = array ('datums' => $db->Date2Str($termini['term3_dat']),
										'summa' => $data['kopsumma']
										);
		
	}
	
	//echo "<br>Termiòi<br>";
	//var_dump($data['termini']);
	//echo "<br><br>";
	$text .="<br>
	<div class=normal><b><i>2.7. Samaksas grafiks</i></b></div>";
	$num=1;
	foreach ($data['termini'] as $key=>$termini){
		if ($key==0){
			$text .= "<div class=normal>2.7.$num Piesakoties jâiemaksâ ".$termini['summa']." EUR</div>";
		}
		elseif ($key == count($data['termini']) - 1){
			$text .= "<div class=normal>2.7.$num Lîdz ".$termini['datums']." jâiemaksâ pilna summa </div>";
		}
		else{
			$text .= "<div class=normal>2.7.$num Lîdz ".$termini['datums']." jâiemaksâ vçl ".$termini['summa']." EUR</div>";
		
		}
		
		$num++;
	
	
	}
	$text .="<p class=base>*Impro on-line sistçmâ lîgums tiek uzskatîts par parakstîtu (akceptçtu) ar brîdi, kad Klients apstiprinâjis savu piekriðanu lîguma
noteikumiem ar klikðíi akcepta lodziòâ</p>";
	$text .= "<p class=br></p>";
	$text .= "</div>";
	
	//$img_file = "img/2lpp_globa.gif";
	$img_file = "img/impro_ligums_online.png";
	$text .= "	<img src=$img_file style='width:100%'>
		
		</body></html>";
	//die('ss');
	$img_file = "files/jaunais_online_ligums_1.png";
//	$img_file = "e:\\LanPub\\portal\\php\\tmp_pdf\\impro_ligums_online.png";
	
	$text = iconv("windows-1257","utf-8",$text);
	$mpdf->WriteHTML($text);
	
	
	//------------pieliek pdf aprakstu ------------------------//
	/*$qry = "SELECT isnull(g.pdf, 0) AS pdf, isnull(m.pdf, 0) AS pdf_main 
			FROM portal.dbo.grupas g 
			INNER JOIN portal.dbo.marsruti m 
				ON m.id = g.marsruts 
			WHERE g.gr_kods IN (
				SELECT kods from grupa where id=?
			)  
			order by pdf desc";*/
	$qry = "SELECT isnull(gg.pdf, 0) AS pdf, isnull(m.pdf, 0) AS pdf_main 
				FROM grupa gg , portal.dbo.grupas pg
				INNER JOIN portal.dbo.marsruti m 
					ON m.id = pg.marsruts 
				WHERE pg.gr_kods = gg.kods
				AND gg.id=?				
			order by pdf desc";
	//echo $qry."<br>";
	//echo "Grupas ID: $gid<br>";
	$params = array($gid);
	//var_dump($params);
	$result = $db->Query($qry,$params);
	//var_dump($result);
	
	$pdf_r = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
	//echo "apraksts:<br>";
//var_dump($pdf_r);
//	echo "<br><br>";
	//$ssql ="SELECT isnull(g.pdf, 0) AS pdf, isnull(m.pdf, 0) AS pdf_main FROM portal.dbo.grupas g INNER JOIN portal.dbo.marsruti m ON m.id = g.marsruts WHERE g.gr_kods IN (SELECT kods from grupa where id='".$summary["gid"]."')  order by pdf desc";

	//$pdf_r = mssql_fetch_assoc(mssql_query($ssql)); 
 
	$apr_1 = $pdf_r['pdf'];
	$apr_main = $pdf_r['pdf_main'];
		
	if($apr_1){
			$pdf_apraksts = $apr_1;	
		}else if($apr_main){
			$pdf_apraksts = $apr_main;	
		}else{
			$pdf_apraksts = "";	
		}

		//die("http://www.impro.lv/pdf/$pdf_apraksts.pdf");
		
	if($pdf_apraksts && false){

		$mpdf->SetImportUse();
	
		$dir2 = "tmp_pdf";	
		$file_name_apr = $dir2."\\".time()."tmp_apraksts.pdf";
		$handle = fopen($file_name_apr, 'w');		
		fwrite($handle, file_get_contents("F:\\pdf\\$pdf_apraksts.pdf"));
		fclose($handle);
	
		//echo substr(sprintf('%o', fileperms($file_name)), -4);
		
		$pagecount= $mpdf->setSourceFile($file_name_apr); 	
	

		for ($i=1; $i<=($pagecount); $i++) {
			/*if($mpdf->getRotation($filename)==90){
					$size = $mpdf->addPage('l'); //landscape orientation
				}else{
					$size = $mpdf->addPage('P'); //portrait
				}
				*/
			$size =$mpdf->AddPage();
			$import_page = $mpdf->ImportPage($i);
			$mpdf->UseTemplate($import_page);
		}
	}
	//--------------------------------------------------------------//

	//die();
	// saglabâjam datubâzç“
	//$data = $mpdf->Output('','S');
	//eksistç lîguma ID, bet pats lîgums vçl nav uzìenerçts
	
	//saglabâ lîguma failu
	/*

	// Create File
	fwrite($file, $bpdf);
	fclose($file);

	echo $id;
	//mssql_query("update ligumi set file_name = '$file_name',bpdf=null where id = $id");
}



*/
		
	//$filename = $ligums_id . '-' . RandomStr(10) . '.pdf';
	//$file = $dir . '\\'. $filename;	
	
	
	//$thousands = floor($ligums_id/1000)+1;
	//$dir  = '\\\\ser-db3\\e$\\pdf-ligumi\\'.$thousands;
	//$dir  = $thousands;
	//var_dump($dir);
	//echo "<br><br>";
	/*if (!file_exists($dir)) {
		
		mkdir($dir);
	}*/

	require_once("i_functions.php");
	//$filename = $dir . '\\'. $ligums_id . '-' . RandomStr(10) . '.pdf';
	$filename =  $ligums_id . '-' . RandomStr(10) . '.pdf';
	//$file = fopen('\\\\ser-db3\\e$\\pdf-ligumi\\'.$filename, 'wb');
	$file = $dir.'\\'.$filename;
	
	//var_dump(file_exists('\\\\ser-db3\\e$\\pdf-ligumi\\'.$dir));
	
	
	//$filename = 'ligums.pdf';
	 $mpdf->Output($file,'F');
	// echo "Saglabâjâm";
	 
	


	
	
	
	//$data = $mpdf->Output('ligumi/ligums.pdf','S');
	//$hex = bin2hex($data);
	//echo $ligums_id;
	//die();

	//echo  $text;
	$result = $db->Update('ligumi',array('file_name' => $filename), $ligums_id);
	//var_dump($result);
	//mssql_query("update ligumi set bpdf = 0x$hex where id = $ligums_id");
	
	//attçlo lîgumu

	if ($show && !DEBUG){
		ob_clean();
		echo $mpdf->Output();
	}
	unset($mpdf);
	
	//nodzçðam pagiadu apraksta failu
	if (is_file($file_name_apr)) {

	   if (unlink($file_name_apr)) {
		 // echo 'File deleted';
	   } else {
		 // echo 'Cannot remove that file';
	   }

	} else {
		//  echo 'File does not exist';
	}
	//var_dump(error_get_last());
}
define("DEBUG",  "1");
$qry = "SeLECT id FROM online_rez where deleted=0 and id in (26715,26687) and datums>='2017-12-20' and ligums_id is not null and ligums_id in (select id from ligumi where accepted=1) and datums<='2017-12-29 17:30'";
$result = $db->Query($qry);
	while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		$online_rez = $row['id'];
		var_dump($online_rez);
		echo "<br>";
		ReGenerateContract($online_rez);
	}
//
//ReGenerateContract(26687);
?>