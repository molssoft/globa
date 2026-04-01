<?
//pârrçíina pieteikuma saiðu summas
function PietSaiteRecalculate($id,$valuta = 'EUR'){
	$piet = new Pieteikums();
	$row = $piet->GetSaiteId($id);
	$db = new Db;
	global $vietu_veidi;
	//var_dump($vietu_veidi);
	$vietu_veidi = new VietuVeidi();
	
	
	if (!empty($row['vietas_veids'])){
				
		$vieta = $vietu_veidi->GetId($row['vietas_veids']);
		//vietas veida ID nav norâdîts
		if (!empty($vieta)){
			
			 //----- saglabâ ðîs vietas cenu, papildv un personas pazimi
			$papildv = ($vieta["papildv"] ? 1 : 0);
			$persona = ($vieta["persona"] ? 1 : 0); 
			if ($row["kid"]!=0 && $row["kvietas_veids"]!=6 && $row["kvietas_veids"]!=3 && $row["kvietas_veids"]!=7) $persona = 1;
			$vietas_cena = $vieta['cena'];
			$vietas_cenaLVL = $vieta['cenaLVL'];
			$vietas_cenaEUR = $vieta['cenaEUR'];
			$vietas_cenaUSD = $vieta['cenaUSD'];
			$data = array('vietas_cena' => $vieta['cena'],
							'vietas_cenaLVL' =>$vieta['cenaLVL'],
							'vietas_cenaEUR' => $vieta['cenaEUR'],
							'vietas_cenaUSD' => $vieta['cenaUSD'],
							'papildv' => $papildv,
							'persona' => $persona);
			//echo "<br>Update data:<br>";
			//print_r($data);
			//echo "<br><br>";
			$db->Update('piet_saite',$data,$row['id']);
			
		/* "UPDATE piet_saite set vietas_cena = " + cstr(getnum(r_cena_l("cena"))) + _
		", vietas_cenaLVL = " + cstr(getnum(r_cena_l("cenaLVL"))) +", vietas_cenaEUR = " + cstr(getnum(r_cena_l("cenaEUR"))) +",vietas_cenaUSD = " + cstr(getnum(r_cena_l("cenaUSD"))) + ", papildv = "+papildv_l+", persona = " + persona_l + whereC + " WHERE id = " + cstr(psid_p)
		*/		
			/*$cenaLVL = $vieta['cenaLVL'];
			$cenaEUR = $vieta['cenaEUR'];
			$cenaUSD = $vieta['cenaUSD'];
			if (empty($cenaLVL)){
				$cenaLVL = $row['cenaLVL'];
			}
			if (empty($cenaEUR)){
				$cenaEUR = $row['cenaEUR'];
			}
			if (empty($cenaUSD)){
				$cenaUSD = $row['cenaUSD'];
			}*/
			
			
			
		}
		else{
			//echo 'nav vietas veida';
			$data = array('vietas_cena' => 0,
							'vietas_cenaLVL' =>0,
							'vietas_cenaEUR' => 0,
							'vietas_cenaUSD' => 0);
			$db->Update('piet_saite',$data,$row['id']);
			$cenaLVL = $row['cenaLVL'];
			$cenaEUR = $row['cenaEUR'];
			$cenaUSD = $row['cenaUSD'];
			
		}
		/*$vietsk = $row['vietsk'];
		$summaLVL = $vietsk * $cenaLVL;
		$summaEUR = $vietsk * $cenaEUR;
		$summaUSD = $vietsk * $cenaUSD;
		$summas  = array ('summaLVL' => $vietsk * $cenaLVL,
							'summaEUR' => $vietsk * $cenaEUR,
							'summaUSD' => $vietsk * $cenaLVL
							);
		//$db->Update('piet_saite',$summas,$row['id']);
		
		print_r($row);
		echo "<br><br>";
		echo "vieta:<br>";
		var_dump($vieta);
			echo "<br><br>";
		echo "Summas:<br>";
		var_dump($summas);
		echo "<br><br>";*/
	}	
	else{
		$data = array('vietas_cena' => 0,
							'vietas_cenaLVL' =>0,
							'vietas_cenaEUR' => 0,
							'vietas_cenaUSD' => 0);
		$db->Update('piet_saite',$data,$row['id']);
	}
	//---- pârbauda vai ir pieðíirta kâda kajîte
	if (!empty($row["kid"])){
		//echo "Jâapdeito kajîtes cena!!!";
		$data = array ('kvietas_cena' => 0, 
						'kvietas_cenaLVL' => 0,
						'kvietas_cenaEUR' => 0,
						'kvietas_cenaUSD' => 0
		);	
		$db->Update('piet_saite',$data,$row['id']);		
		/*"UPDATE piet_saite set kvietas_cena = 0, kvietas_cenaLVL = 0, kvietas_cenaEUR = 0, kvietas_cenaUSD = 0 " + _
			  " WHERE id = " + cstr(psid_p)*/
			  
		//----- Atrod ða kajîti
		$qry ="select * from kajite where kajite.id = ?";
		$params = array($row["kid"]);//		+ cstr(r_l("kid")))
		$resKaj = $db->Query($qry,$params);
		$r_kajite_l =  sqlsrv_fetch_array( $resKaj, SQLSRV_FETCH_ASSOC) ;
		
		//----- saglabâ ðîs vietas cenu
		$kc = KajitesVeidaCena($r_kajite_l["veids"],$row["kvietas_veids"]);
		$data = array ('kvietas_cena' => $kc, 
						'kvietas_cena'.$valuta => $kc
		);	
		$db->Update('piet_saite',$data,$row['id']);		
		/*conn.execute "UPDATE piet_saite set kvietas_cena = " + kc + _
			   ", kvietas_cena"+valuta+" = "+kc+" WHERE id = " + cstr(psid_p)
			   */
 }
 else{
	//----- saglabâ ðîs vietas cenu ka tâ ir 0
	$data = array ('kvietas_cena' => 0, 
						'kvietas_cenaLVL' => 0,
						'kvietas_cenaEUR' => 0,
						'kvietas_cenaUSD' => 0
		);	
		$db->Update('piet_saite',$data,$row['id']);	
 }
  
	//--- vçlreiz atver pieteikuma saiti lai sakalkulçtu cenas
	//echo "<b>CENU KALKULÂCIJA </b><BR><BR>";
	$row = $piet->GetSaiteId($id);	
	$sum = 0;
	 if (empty($row["vietas_cenaLVL"]) && empty($row["vietas_cenaUSD"]) &&  empty($row["vietas_cenaEUR"])){
			$sumLVL = ($row["cenaLVL"]+$row["kvietas_cenaLVL"])*$row["vietsk"];
			$sumEUR = ($row["cenaEUR"]+$row["kvietas_cenaEUR"])*$row["vietsk"];
			$sumUSD = ($row["cenaUSD"]+$row["kvietas_cenaUSD"])*$row["vietsk"];
			//----- Pieskaita vietas cenu
			$sum += $row['vietas_cena'];
			//----- Pieskaita kajîtes cenu
			 $sum += $row['kvietas_cena'];
			//--- pieskaita cenas korekciju korekciju
			$sum  = ($sum + $row['cena']) * $row['vietsk'];
			if ($sumLVL == 0 && $sumEUR ==0 && $sumUSD == 0){
				if ($valuta == "LVL")
					$sumLVL = $row['cena'];
				else
					$sumEUR = $row['cena'];
				
			}
			$data = array('summa' => $sum,
							'summaLVL' =>$sumLVL,
							'summaEUR' =>$sumEUR,
							'summaUSD' =>$sumUSD
									);
			//echo "<br>Update data:<br>";
			//print_r($data);
			//echo "<br><br>";
			$db->Update('piet_saite',$data,$row['id']);
			/*  '----- Pieskaita vietas cenu
			  sum_l = sum_l + getnum(r_l("vietas_cena"))
			  '----- Pieskaita kajîtes cenu
			  sum_l = sum_l + getnum(r_l("kvietas_cena"))
			  '--- pieskaita cenas korekciju korekciju
			  sum_l = (sum_l + getnum(r_l("cena"))) * getnum(r_l("vietsk"))
			  '--- saglabâ sakalkulçto summu tai paðâ ierakstâ
		   if sumLVL_l = 0 and sumUSD_l = 0 and sumEUR_l = 0 then
			if valuta="LVL" then
				sumLVL_l = getnum(r_L("cena"))
			else
				sumEUR_l = getnum(r_L("cena"))
			end if
		   end if
		   conn.execute "UPDATE piet_saite set summa = " + cstr(getnum(sum_l)) + ", summaLVL = "+cstr(sumLVL_l)+", summaEUR = "+cstr(sumEUR_l)+",summaUSD = "+cstr(sumUSD_l)+" " + _
				  " WHERE id = " + cstr(psid_p)
				  */
		 }
		 else{
			 $sumLVL = 0;
			 $sumEUR = 0;
			 $sumUSD = 0;
			 //----- Pieskaita vietas cenu
			 $sumLVL += $row['vietas_cenaLVL'];
			 $sumEUR += $row['vietas_cenaEUR'];
			 $sumUSD += $row['vietas_cenaUSD']; 
			//----- Pieskaita kajîtes cenu
			$sumLVL += $row['kvietas_cenaLVL'];
			$sumEUR += $row['kvietas_cenaEUR'];
			$sumUSD += $row['kvietas_cenaUSD'];
			//--- pieskaita cenas korekciju 	
			$vietsk = $row['vietsk'];
			$sumLVL = ($sumLVL + $row['cenaLVL']) * $vietsk;			
			$sumEUR = ($sumEUR + $row['cenaEUR']) * $vietsk;	
			$sumUSD = ($sumUSD + $row['cenaUSD']) * $vietsk;
			$data = array(
							'summaLVL' =>$sumLVL,
							'summaEUR' =>$sumEUR,
							'summaUSD' =>$sumUSD
									);
			//echo "<br>Update data:<br>";
			//print_r($data);
			//echo "<br><br>";
			$db->Update('piet_saite',$data,$row['id']);
			
			 /*
			  sumUSD_l = 0
			   sumLVL_l = 0
			   sumEUR_l = 0
				  '----- Pieskaita vietas cenu
				  sumLVL_l = sumLVL_l + getnum(r_l("vietas_cenaLVL"))
				  sumUSD_l = sumUSD_l + getnum(r_l("vietas_cenaUSD"))
				  sumEUR_l = sumEUR_l + getnum(r_l("vietas_cenaEUR"))
				  '----- Pieskaita kajîtes cenu
				  sumLVL_l = sumLVL_l + getnum(r_l("kvietas_cenaLVL"))
				  '--- pieskaita cenas korekciju 
				  sumLVL_l = (sumLVL_l + getnum(r_l("cenaLVL"))) * getnum(r_l("vietsk"))
				  sumUSD_l = (sumUSD_l + getnum(r_l("cenaUSD"))) * getnum(r_l("vietsk"))
				  sumEUR_l = (sumEUR_l + getnum(r_l("cenaEUR"))) * getnum(r_l("vietsk"))
				  '--- saglabâ sakalkulçto summu tai paðâ ierakstâ
				  conn.execute "UPDATE piet_saite set summaLVL = " + cstr(getnum(sumLVL_l)) + ", summaUSD = " + cstr(sumUSD_l) + ", summaEUR = " + cstr(sumEUR_l) + _
					 " WHERE id = " + cstr(psid_p)
						 */
		 }
		
	
	
}

function PieteikumsCalculate($pid){
	require_once('m_init.php');
	$db = new Db;
	
	if (true){//$_SESSION['profili_id']==5116){
		
		$qry = "EXEC pieteikums_calculate_new2 @pid = ?";
		$params  = array($pid);
		
		$result = $db->Query($qry,$params);
		
		
		return;
		
	}
	
	
	$qry = "SELECT * FROM piet_saite WHERE pid=? AND deleted=0";
	$params  = array($pid);
	
	$result = $db->Query($qry,$params);
	//var_dump($result);

	require_once('m_grupa.php');
	require_once('m_pieteikums.php');
	require_once('m_vietu_veidi.php');
	require_once("m_marsruts.php");
	$mars = new Marsruts();
	$piet = new Pieteikums();
	
	$gr = new Grupa();
	$vietu_veidi = new VietuVeidi();
	$pieteikums = $piet->GetId($pid);
	$gid = $pieteikums['gid'];
		//dabû valûtu
	$valuta = "LVL";
	$grupa = $gr->GetId($gid);
	//var_dump($grupa);
	if (!empty($grupa['valuta'])) 
		$valuta = $grupa['valuta'];

	//echo "Valûta: $valuta <br>";
	if(sqlsrv_has_rows($result) ){
		
		$i=1;
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			//echo "<br><b>Piet_saite $i</b><br>";
			//print_r($row);
			//echo '<br><br>';
			$i++;
			PietSaiteRecalculate($row['id'],$valuta);
			
			
			 
		 }
	}
	
	/*---*/




	$papildvietas = $piet->GetPapildvId($pid);





	$datums = $db->Date2Str($pieteikums['datums']).' '.$db->Time2Str($pieteikums['datums']);
	$marsruts = $mars->GetGid($gid);
	$marsr_nos = $marsruts['v'];
	$info_new = $datums.' '.$marsr_nos;

	/*SELECT @info_new*/

	$dalibnieks = $piet->GetDalibnPid($pid);
	if (is_array($dalibnieks)){
		$info_new .= "<br>Dalîbnieki: <br>" . $dalibnieks['vards'] . " " . $dalibnieks['uzvards'] . " " . $dalibnieks['nosaukums'];
		
	}
	else{
		$info_new .= "Pieteikums nesatur dalîbniekus! ";
	}

	$values = array('personas' => 1, 'papildvietas' => $papildvietas,'info' => $info_new);
	//echo "Pietiekums update:<br>";
	//var_dump($values);
	$db->Update('pieteikums',$values,$pid);


		/*---*/
		/*$qry = "SELECT * FROM piet_saite WHERE pid=?";
		$params  = array($pid);
		$result = $db->Query($qry,$params);	
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
					echo "<br><b>Piet_saite</b><br>";
				print_r($row);
				echo '<br><br>';
			PietSaiteRecalculate($row);
		}*/
			
		$plusLVL = 0;
		$plusEUR = 0;
		$plusUSD = 0;
		$plusBIL = 0;
		$minusLVL = 0;
		$minusEUR = 0;
		$minusUSD = 0;
		$minusBIL = 0;
		
		/* atlaides */
		$qry = "SELECT isnull(sum(atlaideLVL),0) as minusLVL,
					isnull(sum(atlaideEUR),0) as minusEUR,
					isnull(sum(atlaideUSD),0) as minusUSD,
					isnull(sum(atlaideBIL),0) as minusBIL
					FROM piet_atlaides
					WHERE pid=? AND uzcenojums=0";
		$params = array ($pid);
		$result = $db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$minusLVL = $row['minusLVL'];
			$minusEUR = $row['minusEUR'];
			$minusUSD = $row['minusUSD'];
			$minusBIL = $row['minusBIL'];
		}
		/* piemaksas */
		$qry = "SELECT isnull(sum(atlaideLVL),0) as plusLVL,
				isnull(sum(atlaideEUR),0) as plusEUR,
				isnull(sum(atlaideUSD),0) as plusUSD,
				isnull(sum(atlaideBIL),0) as plusBIL
				FROM piet_atlaides
				WHERE pid=? AND uzcenojums=1";
		$params = array ($pid);
		$result = $db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$plusLVL = $row['plusLVL'];
			$plusEUR = $row['plusEUR'];
			$plusUSD = $row['plusUSD'];
			$plusBIL = $row['plusBIL'];
		}
		
		/* iemaksas */
		$qry = "SELECT isnull(sum(summaLVL),0) as iemaksasLVL,
				isnull(sum(summaEUR),0) as iemaksasEUR,
				isnull(sum(summaUSD),0) as iemaksasUSD
				FROM orderis
				WHERE deleted = 0 and pid = ?";
		$params = array ($pid);
		$result = $db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$iemaksasLVL = $row['iemaksasLVL'];
			$iemaksasEUR = $row['iemaksasEUR'];
			$iemaksasUSD = $row['iemaksasUSD'];
			
		}
		/* izmaksas */
		$qry = "SELECT isnull(sum(nosummaLVL),0) as izmaksasLVL,
				isnull(sum(nosummaEUR),0) as izmaksasEUR,
				isnull(sum(nosummaUSD),0) as izmaksasUSD
				FROM orderis
				WHERE deleted = 0 and nopid = ?";
		$params = array ($pid);
		$result = $db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$izmaksasLVL = $row['izmaksasLVL'];
			$izmaksasEUR = $row['izmaksasEUR'];
			$izmaksasUSD = $row['izmaksasUSD'];
			
		}
		
		/* Summas */
		$qry = "SELECT isnull(sum(summaLVL),0) as summaLVL,
				isnull(sum(summaEUR),0) as summaEUR,
				 isnull(sum(summaUSD),0) as summaUSD
				FROM piet_saite
				WHERE deleted = 0 and pid  =?";
		$params = array ($pid);
		$result = $db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$summaLVL = $row['summaLVL'];
			$summaEUR = $row['summaEUR'];
			$summaUSD = $row['summaUSD'];
			
		}
		
		/* Personas */
		$personas = $pieteikums['personas'];
		$re = "/GRUPAS VAD.+/i"; 
			$str = "grupas vadîtâjs"; 
	 
		preg_match($re, $pieteikums['piezimes'], $matches);
		if (count($matches)>0){
			$personas = 0;
		}
		
		$bilanceLVL = -$summaLVL+$iemaksasLVL-$izmaksasLVL+$minusLVL-$plusLVL;
		$bilanceUSD = -$summaUSD+$iemaksasUSD-$izmaksasUSD+$minusUSD-$plusUSD;
		$bilanceEUR = -$summaEUR+$iemaksasEUR-$izmaksasEUR+$minusEUR-$plusEUR;
		/* charteru viesniicas piemaksa par numura tukshajaam vietaam, ja tadas ir _f-jas arguments*/
		/*if (@ch_piemaksa IS NOT null) 
		BEGIN
			SELECT @bilanceLVL = @bilanceLVL - @ch_piemaksa
		END
		*/
	/*--------------------------------------------------------------------------------------------------------------------*/

	$values = array ('atlaidesLVL' => $minusLVL, 
					'atlaidesUSD' => $minusUSD, 
					'atlaidesEUR' => $minusEUR, 
					'atlaidesBIL' => $minusBIL, 
					'sadardzinLVL' => $plusLVL, 
					'sadardzinUSD' => $plusUSD, 
					'sadardzinEUR' => $plusEUR, 
					'sadardzinBIL' => $plusBIL,
					'iemaksasLVL' => $iemaksasLVL,
					'iemaksasEUR' => $iemaksasEUR,
					'iemaksasUSD' => $iemaksasUSD,
					'izmaksasLVL' => $izmaksasLVL,
					'izmaksasEUR' => $izmaksasEUR,
					'izmaksasUSD' => $izmaksasUSD,
					'summaLVL' => $summaLVL,
					'summaEUR' => $summaEUR,
					'summaUSD' => $summaUSD,
					'bilanceLVL' => $bilanceLVL,
					'bilanceEUR' => $bilanceEUR,
					'bilanceUSD' => $bilanceUSD,
					'personas' => $personas);
					//echo "UPDATE with<br>";
					//print_r($values);
					//echo "<br><br>";
	$db->Update('pieteikums',$values,$pid);
}
// kompleksais pid =461429
//testa pid =460048
//nav norâdîts viegtas veids: 453446
//PieteikumsCalculate(460048);
//pieteikuma summas pârrçíinâðana
/*SET NOCOUNT ON;


UPDATE pieteikums SET 
	atlaidesLVL = @minusLVL, 
	atlaidesUSD = @minusUSD, 
	atlaidesEUR = @minusEUR, 
	atlaidesBIL = @minusBIL, 
	sadardzinLVL = @plusLVL, 
	sadardzinUSD = @plusUSD, 
	sadardzinEUR = @plusEUR, 
	sadardzinBIL = @plusBIL,
	iemaksasLVL = @iemaksasLVL,
	iemaksasEUR = @iemaksasEUR,
	iemaksasUSD = @iemaksasUSD,
	izmaksasLVL = @izmaksasLVL,
	izmaksasEUR = @izmaksasEUR,
	izmaksasUSD = @izmaksasUSD,
	summaLVL = @summaLVL,
	summaEUR = @summaEUR,
	summaUSD = @summaUSD,
	bilanceLVL = @bilanceLVL,
	bilanceEUR = @bilanceEUR,
	bilanceUSD = @bilanceUSD,
	personas = @personas
WHERE id = @pid

/* charteru viesniicas piemaksa par numura tukshajaam vietaam, ja tadas ir */
/*if (@ch_piemaksa IS NOT null) 
BEGIN
	SELECT @bilanceLVL = @bilanceLVL - @ch_piemaksa
END
	/*SELECT 
	@iemaksasLVL = isnull(sum(summaLVL),0),
	@iemaksasEUR = isnull(sum(summaEUR),0),
	@iemaksasUSD = isnull(sum(summaUSD),0)
	FROM orderis
	WHERE deleted = 0 and pid = @pid
	*/

	
/*SELECT 
	@plusLVL = isnull(sum(atlaideLVL),0),
	@plusEUR = isnull(sum(atlaideEUR),0),
	@plusUSD = isnull(sum(atlaideUSD),0),
	@plusBIL = isnull(sum(atlaideBIL),0)
	FROM piet_atlaides
	WHERE pid = @pid AND uzcenojums = 1
/*SELECT 
	@minusLVL = isnull(sum(atlaideLVL),0),
	@minusEUR = isnull(sum(atlaideEUR),0),
	@minusUSD = isnull(sum(atlaideUSD),0),
	@minusBIL = isnull(sum(atlaideBIL),0)
	FROM piet_atlaides
	WHERE pid = @pid AND uzcenojums = 0
	
}
function PietAtlaides($pid){
	$summa = 0;
	

/*
USE [globa]
GO

/****** Object:  StoredProcedure [dbo].[pieteikums_calculate]    Script Date: 09/05/2016 12:20:49 ******/
/*SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[pieteikums_calculate] 
	@pid int,
    	@ch_piemaksa  money = null
AS

declare @plusLVL money
declare @plusEUR money
declare @plusUSD money
declare @plusBIL money
declare @minusLVL money
declare @minusEUR money
declare @minusUSD money
declare @minusBIL money

/* atlaides */
/*SELECT 
	@minusLVL = isnull(sum(atlaideLVL),0),
	@minusEUR = isnull(sum(atlaideEUR),0),
	@minusUSD = isnull(sum(atlaideUSD),0),
	@minusBIL = isnull(sum(atlaideBIL),0)
	FROM piet_atlaides
	WHERE pid = @pid AND uzcenojums = 0

/* piemaksas */
/*SELECT 
	@plusLVL = isnull(sum(atlaideLVL),0),
	@plusEUR = isnull(sum(atlaideEUR),0),
	@plusUSD = isnull(sum(atlaideUSD),0),
	@plusBIL = isnull(sum(atlaideBIL),0)
	FROM piet_atlaides
	WHERE pid = @pid AND uzcenojums = 1

declare @iemaksasLVL money
declare @iemaksasEUR money
declare @iemaksasUSD money
declare @izmaksasLVL money
declare @izmaksasEUR money
declare @izmaksasUSD money

SELECT 
	@iemaksasLVL = isnull(sum(summaLVL),0),
	@iemaksasEUR = isnull(sum(summaEUR),0),
	@iemaksasUSD = isnull(sum(summaUSD),0)
	FROM orderis
	WHERE deleted = 0 and pid = @pid

SELECT 
	@izmaksasLVL = isnull(sum(nosummaLVL),0),
	@izmaksasEUR = isnull(sum(nosummaEUR),0),
	@izmaksasUSD = isnull(sum(nosummaUSD),0)
	FROM orderis
	WHERE deleted = 0 and nopid = @pid

declare @summaLVL money
declare @summaEUR money
declare @summaUSD money

SELECT 
	@summaUSD = isnull(sum(summaUSD),0),
	@summaEUR = isnull(sum(summaEUR),0),
	@summaLVL = isnull(sum(summaLVL),0)
	FROM piet_saite
	WHERE deleted = 0 and pid  = @pid

declare @personas int
declare @piezimes varchar(3000)
SELECT 
	@personas = personas,
	@piezimes = piezimes
	FROM pieteikums
	WHERE id = @pid

if @piezimes like 'GRUPAS VAD%'
begin
	set @personas = 0
end





declare @bilanceLVL money
declare @bilanceUSD money
declare @bilanceEUR money

SELECT @bilanceLVL = -@summaLVL+@iemaksasLVL-@izmaksasLVL+@minusLVL-@plusLVL
SELECT @bilanceUSD = -@summaUSD+@iemaksasUSD-@izmaksasUSD+@minusUSD-@plusUSD
SELECT @bilanceEUR = -@summaEUR+@iemaksasEUR-@izmaksasEUR+@minusEUR-@plusEUR


SELECT @bilanceLVL = -@summaLVL+@iemaksasLVL-@izmaksasLVL+@minusLVL-@plusLVL
SELECT @bilanceLVL

/* charteru viesniicas piemaksa par numura tukshajaam vietaam, ja tadas ir */
/*if (@ch_piemaksa IS NOT null) 
BEGIN
	SELECT @bilanceLVL = @bilanceLVL - @ch_piemaksa
END
/*--------------------------------------------------------------------------------------------------------------------*/

/*SET NOCOUNT ON;


UPDATE pieteikums SET 
	atlaidesLVL = @minusLVL, 
	atlaidesUSD = @minusUSD, 
	atlaidesEUR = @minusEUR, 
	atlaidesBIL = @minusBIL, 
	sadardzinLVL = @plusLVL, 
	sadardzinUSD = @plusUSD, 
	sadardzinEUR = @plusEUR, 
	sadardzinBIL = @plusBIL,
	iemaksasLVL = @iemaksasLVL,
	iemaksasEUR = @iemaksasEUR,
	iemaksasUSD = @iemaksasUSD,
	izmaksasLVL = @izmaksasLVL,
	izmaksasEUR = @izmaksasEUR,
	izmaksasUSD = @izmaksasUSD,
	summaLVL = @summaLVL,
	summaEUR = @summaEUR,
	summaUSD = @summaUSD,
	bilanceLVL = @bilanceLVL,
	bilanceEUR = @bilanceEUR,
	bilanceUSD = @bilanceUSD,
	personas = @personas
WHERE id = @pid

GO



*/

function KajitesVeidaCena ($kv_p,$kvv_p) {
	global $db;
	$qry = "SELECT * FROM kajites_veidi WHERE id = ?";
	$params = array($kv_p);
	$result = $db->Query($qry,$params);
	$cena = 0;
	if( $r_l = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		if ($kvv_p == 1) {$cena =  $r_l["standart_cena"];}
		if ($kvv_p == 2) {$cena =  $r_l["bernu_cena"];}
		if ($kvv_p == 3) {$cena =  $r_l["papild_cena"];}
		if ($kvv_p == 6) {$cena =  $r_l["papild2_cena"];}
		if ($kvv_p == 7) {$cena =  $r_l["papild3_cena"];}
		if ($kvv_p == 4) {$cena =  $r_l["senioru_cena"];}
		if ($kvv_p == 5) {$cena =  $r_l["pusaudzu_cena"];}
	}
	
	return $cena;
}


?>
