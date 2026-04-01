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
	
	$query = "EXEC pieteikums_calculate_new @pid = ?";
		$params = array($pid);
		//echo $query."<br>";
		//var_dump($params);
		//echo "<br><br>";
		$db->Query($query,$params);

}

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