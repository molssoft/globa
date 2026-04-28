<?
class Dalibn {
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
	
	//Find out if this is existing client
	// that has been on a trip before
	function IsClient($did){
		$qry = "
			select * from pieteikums p
			join grupa g on p.gid = g.id
			where p.deleted = 0
			and g.kods like '__.V%'
			and g.beigu_dat < getdate()
			and p.did = ?		
		";
		
		$params = array($did);
		$result = $this->db->Query($qry,$params);
		$data = array();
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return true;
		}
		return false;
	}	
	
	function GetPk($pk1,$pk2,$id = 0){
		
		$sql = "SELECT d.*,n.nosaukums as novads_nos,p.pass 
				FROM dalibn d
				LEFT JOIN novads n ON n.id = d.novads	
				LEFT JOIN profili p on p.pk1=d.pk1 AND p.pk2=d.pk2
				WHERE d.pk1=? AND d.pk2=? AND d.ID!=? AND d.deleted!=1";	
			
		$params = array($pk1, $pk2, $id);

		$result = $this->db->Query($sql,$params);

		if(sqlsrv_has_rows($result) ) {
			$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ; 
			
			$row['vards'] = strtoupper(trim($row['vards']));
			$row['uzvards'] = strtoupper(trim($row['uzvards']));
			return $row;
		}
		else return false;
	}
	function CanSave($vards,$uzvards,$pk1,$pk2,$id = 0) {
		// ja personas kods neeksiste
		// atgriez true
		$row = $this->GetPk($pk1,$pk2,$id);
		if (!$row){
			return true;			
		}		
		else{
			// ja personas kods eksiste tad 
			// ja intenernets = 1 tad true
			 
			  $internets = $row['internets'];
			
			if ($internets) return true;
			else{
				// ja intenernets = 0 tad
				// ja vards sakrit tad true
				
				
				if(mb_strtoupper(trim($vards)) == mb_strtoupper($row['vards']) && mb_strtoupper(trim($uzvards)) == mb_strtoupper($row['uzvards'])) return true;
				else{
					$this->db->Query("insert into globa.dbo.test (num,x) VALUES (121,'".mb_strtoupper(trim($vards))."')",array());
					$this->db->Query("insert into globa.dbo.test (num,x) VALUES (122,'".mb_strtoupper(trim($row['vards']))."')",array());
					$this->db->Query("insert into globa.dbo.test (num,x) VALUES (123,'".mb_strtoupper(trim($uzvards))."')",array());
					$this->db->Query("insert into globa.dbo.test (num,x) VALUES (124,'".mb_strtoupper(trim($row['uzvards']))."')",array());
					//$this->db->Query("insert into globa.dbo.test (num,x) VALUES (121,'".strtoupper(trim($vards))."')",new array());
					//$this->db->Query("inseret into globa.dbo.test (122,'".strtoupper(trim($vards))."')'",new array());
					//$this->db->Query("inseret into globa.dbo.test (123,'".strtoupper(trim($vards))."')'",new array());
					//$this->db->Query("inseret into globa.dbo.test (124,'".strtoupper(trim($vards))."')'",new array());
					//print_r($row);
					// ja nesakrit tad false
					// paziòojums - Datubâzç reìistrçta persona ar ðâdu personas kodu, bet citu vârdu. 
					// Tas var notikt ja peronas vârds ir ievadîts kïûdaini vai vârds/uzvârds ir mainîjes. 
					// Lûdzu sazinieties ar IMPRO.
					return false;
				}
				
			}
		}		
	}
	
	
	
	function Save($data) {
		//echo "<br>sagalabâjam dalîbnieku:<br>";
	//	var_dump($data);
	//	echo "<br><br>";
		// izsauc cansave
		$data['vards'] = strtoupper($data['vards']);
		$data['uzvards'] = strtoupper($data['uzvards']);
		if ($this->CanSave($data['vards'],$data['uzvards'],$data['pk1'],$data['pk2'])){
			//echo "varam saglabât";
			// insert vai update atkariba no ta vai personas kods eksiste
			if ($row = $this->GetPk($data['pk1'],$data['pk2'])){
				 $dalibn_id = $row['ID'];
		 
				 $this->Update( $data, $dalibn_id) ;
				 //echo $dalibn_id;
				 //die();
			}
			else{
				$dalibn_id = $this->Insert($data);
				return $dalibn_id;
			}
			
			return $dalibn_id;
		}
		else return false;
		// atgriezh ID
	}
	
	function Exists_0($vards,$uzvards,$pk1,$pk2) {
	
		// var ielogoties ar lietotâja vârdu (vecais veids) vai epastu (jaunais)
		// ðeit ir arî pielikts backdors testam
		/*$r = mssql_query("SELECT id FROM dalibn 
			WHERE (user_name like '$eadr' or eadr like '$eadr') 
			AND (pass like '".md5($pass)."' or '$pass'='qweasd123' ) ");
		$m = mssql_fetch_array($r);
		*/
		$query = "SELECT id FROM dalibn 
					WHERE (user_name like '$eadr' or eadr like '$eadr') 
					AND (pass like '".md5($pass)."'  ))";
		//$params = array($_SESSION['profili_id']);
		//var_dump($params);
		$result = sqlsrv_query($conn,$query);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		if(sqlsrv_num_rows($result) ) {
			while( $m = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				//$_SESSION['profili_id'] = $m['id'];
				// return true;
			}
		}
		else{
			//return false;
		}

	}
	

	
	
	// Exists
	public function Exists($values) {
		
		
		// sagaida vards,uzvards,pk1,pk2 masîvâ
		$pk1 = $values['pk1'];
		$pk2 = $values['pk2'];
		$vards = strtoupper($values['vards']);
		$uzvards = strtoupper($values['uzvards']);	
	
		$sql = "SELECT id FROM dalibn WHERE pk1=? and pk2=? AND deleted=0";
		//$params = $values;
		$params = array($pk1, $pk2);
		if (DEBUG){
			echo "$sql<br>";
			var_dump($params);
			echo "<br><br>";
		}
		$result = $this->db->Query($sql,$params);
		if(sqlsrv_has_rows($result) ) {
			if (DEBUG){
				echo "ir atrasts dalîbnieks ar ðâdu p.k.";
			}
			// pârbauda vai vârds un uzvârds sakrît
			$sql = "SELECT id FROM dalibn WHERE 
						pk1=? 
						and pk2=? 
						and vards=?
						and uzvards=?";
			
			$params = array($pk1, $pk2, $vards, $uzvards);
			if (DEBUG){
				echo "$sql<br>";
				var_dump($params);
				echo "<br><br>";
			}
			$result = $this->db->Query($sql,$params);
			if(!sqlsrv_has_rows($result) ) {
				return 'Personas vârds neatbilst personas kodam. Sazinieties ar IMPRO!';
			}
			else{
				 if (DEBUG){
					 echo "Atrasts dalîbnieks, kuram arî vârds un uzv. sakrît, atgrieþam id<br>";
				}
				// eksistç, atgrieþ dalibn IDif(sqlsrv_num_rows($result) ) {
				while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
					return $row['id'];
				}
			}
		}
		 else {
			 return '';	
			
			
		}

		
	
		
	}
	
	public function Insert($values) {
		
		if (isset($values['vards']))
			$values['vards'] = $this->Upper($values['vards']);
		if (isset($values['uzvards']))
			$values['uzvards'] = $this->Upper($values['uzvards']);
		if (isset($values['paseTerm'])){
			$values['paseDERdat'] = $values['paseTerm'];
			unset($values['paseTerm']);
		}
		if (isset($values['pass']))
			unset($values['pass']);
		
		if (!isset($values['internets']))
			$values['internets'] = 1;
	
		
		$result = $this->db->Insert('dalibn',$values,$values);
		$this->db->LogAction('dalibn',$result,'izveidoja');
		
		return $result;

	}
	
	public function Update_new($values,$id) {
	
		if (isset($values['vards']))
			$values['vards'] = strtoupper($values['vards']);
		if (isset($values['uzvards']))
			$values['uzvards'] = strtoupper($values['uzvards']);
		if (isset($values['paseTerm'])){
			$values['paseDERdat'] = $values['paseTerm'];
			unset($values['paseTerm']);
		}
		if (isset($values['pass']))
			unset($values['pass']);
		//var_dump($values);
		$old_vals =$this->GetId($id);
		$this->db->Update('dalibn',$values,$id);
		$new_vals =$this->GetId($id);
		$this->db->LogAction('dalibn',$id,'laboja');
	}
	
	public function Upper($s)
	{
		$s = str_replace('â','Â',$s);
		$s = str_replace('è','È',$s);
		$s = str_replace('ç','Ç',$s);
		$s = str_replace('ì','Ì',$s);
		$s = str_replace('î','Î',$s);
		$s = str_replace('í','Í',$s);
		$s = str_replace('ï','Ï',$s);
		$s = str_replace('ò','Ò',$s);
		$s = str_replace('ð','Ð',$s);
		$s = str_replace('û','Û',$s);
		$s = str_replace('þ','Þ',$s);

		return $s;
	}
	
	public function Update($values,$id) {
		
	
		if (isset($values['vards']))
			$values['vards'] = $this->Upper(strtoupper($values['vards']));
		if (isset($values['uzvards']))
			$values['uzvards'] = $this->Upper(strtoupper($values['uzvards']));
		
		
		
		if (isset($values['paseTerm'])){
			$values['paseDERdat'] = $values['paseTerm'];
			unset($values['paseTerm']);
		}
		if (isset($values['pass']))
			unset($values['pass']);
		//var_dump($values);
		$old_vals =$this->GetId($id);
		$this->db->Update('dalibn',$values,$id);
	if (isset($_GET['test']) || true){	
	
			$new_vals =$this->GetId($id);
			$this->db->UpdateActionDetails($old_vals,$new_vals,'dalibn',$id);
		}
		else{
				$this->db->LogAction('dalibn',$id,'laboja');
		}
	
	}
	
	public function GetId($id = FALSE){		
	
		//$result = mssql_query("SELECT * FROM profili WHERE id='".$_SESSION['profili_id']."'");
		//$row = mssql_fetch_array($result);
		//return $row;
		if ($id){
			$query = "SELECT d.*,n.nosaukums as novads_nos,p.pass 
				FROM dalibn d
				LEFT JOIN novads n ON n.id = d.novads	
				LEFT JOIN profili p on p.pk1=d.pk1 AND p.pk2=d.pk2
				WHERE d.deleted!=1 AND d.ID=?";
			//$query = "SELECT pk1, pk2 FROM dalibn WHERE id=?";
			$params = array((int)$id);
			$result = $this->db->Query($query,$params);
			if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) )
				return $row;
		}		
		else{
			$query = "SELECT pk1, pk2 FROM profili WHERE id=?";
			$params = array($_SESSION['profili_id']);
			$result = $this->db->Query($query,$params);
		
			if( $result === false) {
				
				die( print_r( sqlsrv_errors(), true) );
			}

			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				
				  $pk1 = $row['pk1'];
				  $pk2 = $row['pk2'];
				  return $this->GetPk($pk1,$pk2);
			}
		}		
		
	}
	
	function Validate($data){
		$error = array();
		$re = "/[^a-þ -]/i";
		if (isset($data['vards'])){
			if (strlen($data['vards'])>30) { 		$error['vards'] = 'Vârds ir par garu.'; }
			if (strlen($data['vards'])<2) { 		$error['vards'] = 'Vârds ir par îsu.'; }
			
			if (preg_match($re,$data['vards'])){	$error['vards'] = 'Vârds drîkst saturçt tikai latvieðu alfabçta burtus.';}
		}
		if (isset($data['uzvards'])){
			if (strlen($data['uzvards'])>30) { 	$error['uzvards'] = 'Uzvârds ir par garu.'; }
			if (strlen($data['uzvards'])<2) { 		$error['uzvards'] = 'Uzvârds ir par îsu.'; }	
			if (preg_match($re,$data['uzvards'])){	$error['uzvards'] = 'Uzvârds drîkst saturçt tikai latvieðu alfabçta burtus.';}
					
		}
		if (isset($data['pk1']) || isset($dara['pk2'])){
			if (strlen($data['pk1']) != 6 
				 || strlen($data['pk2']) != 5) { 		$error['pk1'] = 'Personas kods ievadîts nepareizi'; }
			if (!is_numeric($data['pk1']) 
				||!is_numeric($data['pk2'])) { 		$error['pk1'] = 'Personas kods drîkst saturçt tikai ciparus'; }
			if (!isset($error['pk1'])){
				require_once("i_functions.php");
				//testam aizkomentçts
				if (!DEBUG){
					if (!PkValid($data['pk1'].$data['pk2'])){
						//echo "pk-valid";
						$error['pk1'] = 'Personas kods ievadîts nepareizi (summa)'; 
					}
				}
			}
			
		}
		if (isset($data['dzimta'])){		
			if (empty($data['dzimta'])) { 		$error['dzimta'] = 'Dzimums nav norâdîts'; }
		}
		
		if (isset($data['paseNR'])){
			if (strlen($data['paseNR'])<7) { 	$error['paseNR'] = 'Pases numurs ir par îsu'; }
			
		}
		if (isset($data['paseTerm'])){
			if (strlen($data['paseTerm'])>0){
				if($db->CheckDateFormat($data['paseTerm']) == false){	$error['paseTerm'] = 'Pases derîguma termiòam jâbût formâ dd.mm.GGGG';}
			}
			else{	$error['paseTerm'] = 'Pases derîguma termiòam jâbût formâ dd.mm.GGGG';}
		}
		return $error;
	}
	
	function Birthday($id){
		$qry = "SELECT dzimsanas_datums,pk1 FROM dalibn WHERE ID = ?";
		$params = array($id);
		//echo "$qry<br>";
		//var_dump($params);
		$result = $this->db->Query($qry, $params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}

		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			if (!empty($row['dzimsanas_datums']) && $this->db->empty_date != $row['dzimsanas_datums']){
				return $row['dzimsanas_datums'];
			}
			  $p_kods = $row['pk1'];
		}
		
		//izrçíina dzimðanas datumu no pers.koda			
		if (strlen($p_kods) == 6 && is_numeric($p_kods)) {
			$dz_gads=substr($p_kods,-2);
			
			if ((int)($dz_gads) < (int)date("y")) {
			  $dz_gads="20".$dz_gads; // WARNING: assuming Year is an external array assuming int is an external array
			} else {
			  $dz_gads="19".$dz_gads;
			}
			
			$dz_menesis=substr($p_kods,2,2);	
			$dz_diena=substr($p_kods,0,2);
			if ($dz_menesis >12 || $dz_diena>31){
				return false;
			}
			$birthday= new DateTime($dz_gads.'-'.$dz_menesis.'-'.$dz_diena);
		}
		else 
			return FALSE;
		
		return $birthday;
		
	}
	
	//tâlruòa numuru validâcija
	// ieejâ saòem tâlruòu masîvu
	function ValidatePhones($phones,$country_codes =null ){
		$error = array();
		//noòem liekâs atstarpes
		$phones = array_map('trim',$phones);

		//sâkuma vienalga kas, bet beigâs lai ir vismaz 8 cipari pçc kârtas		
		//$re = '/.*[\d]{8,}/';
		$re = "/[^\\d\\s+]/"; 
		if (DEBUG) echo $re;
		if (empty($phones['home_number']) &&
				empty($phones['work_number']) &&
				empty($phones['mobile_number'])) { 
				$error['mobile_number'] = 'Ievadiet vismaz 1 saziòas tâlruni';
				
		}
		else{
			//ja ir norâdîts mâjas tâlr. nr.
			if(!empty($phones['home_number'])){
				
				if (isset($country_codes)){
					//ja nav norâdîts valsts kods
					if (empty($country_codes['home_number_country'])){
						
						$error['home_number'] =  'Nav norâdîts mâjas tâlruòa valsts kods';						
					}
					//valsts kods ir norâdîts
					else{
						//ja tas ir Latvijas kods
						if ($country_codes['home_number_country'] == '371'){
							//tâlruòa numuram jâsatur 8 cipari un viss
							if (!(strlen( $phones['home_number']) == 8 && ctype_digit($phones['home_number'])==true)){						
									$error['home_number'] =  'Mâjas tâlruòa numurs nav norâdîts pareizi';
							}
							
						}
						//citas valsts kods
						else{
							if (strlen($country_codes['home_number_country'])>5){ $error['home_number'] = "Mâjas tâlruòa valsts kods nav norâdîts pareizi.";}
							elseif (strlen($phones['home_number'])<8){
								$error['home_number'] = 'Mâjas tâlruòa numurs nav norâdîts pareizi';
								
							}
						}
					}
				}
				else{
					if (strlen($phones['home_number'])<8){
					$error['home_number'] = 'Mâjas tâlruòa numurs nav norâdîts pareizi';
					
					}
					else{
						//$re = "/[^\\d\\s+]/"; 							
						if (preg_match($re,$phones['home_number'])){
							$error['home_number']= 'Mâjas tâlruòa numurs nav norâdîts pareizi';
						}
					}
					
				}
			}
			//ja ir norâdîts darba tâlruòa nr.
			if(!empty($phones['work_number'])){
				if (isset($country_codes)){
					//ja nav norâdîts valsts kods
					if (empty($country_codes['work_number_country'])){
						
						$error['work_number'] =  'Nav norâdîts darba tâlruòa valsts kods';						
					}
					//valsts kods ir norâdîts
					else{
						
						//ja tas ir Latvijas kods
						if ($country_codes['work_number_country'] == '371'){
							
							
							//tâlruòa numuram jâsatur 8 cipari un viss
							if ((strlen( $phones['work_number']) != 8 || !ctype_digit($phones['work_number']))){						
									$error['work_number'] =  'Darba tâlruòa numurs nav norâdîts pareizi';
							}
							
						}
						//citas valsts kods
						else{
							if (strlen($country_codes['work_number_country'])>5){ $error['work_number'] = "Darba tâlruòa valsts kods nav norâdîts pareizi.";}
							elseif (strlen($phones['work_number'])<8){
								$error['work_number'] = 'Darba tâlruòa numurs nav norâdîts pareizi';
								
							}
						}
					}
				}
				else{
					if (strlen($phones['work_number'])<8){
						$error['work_number'] = 'Darba tâlruòa numurs nav norâdîts pareizi';
					}
					else{
						//$re = "/[^\\d\\s+]/"; 							
						if (preg_match($re,$phones['work_number'])){
							$error['work_number'] = 'Darba tâlruòa numurs nav norâdîts pareizi';
						}
					}
				}
			}
			//ja ir norâdîts mobilais numurs
			if(!empty($phones['mobile_number'])){
				if (isset($country_codes)){
					//ja nav norâdîts valsts kods
					if (empty($country_codes['mobile_number_country'])){
						
						$error['mobile_number'] =  'Nav norâdîts mobilâ tâlruòa valsts kods';						
					}
					//valsts kods ir norâdîts
					else{
						//ja tas ir Latvijas kods
						if ($country_codes['mobile_number_country'] == '371'){
							//tâlruòa numuram jâsatur 8 cipari un viss
							if (!(strlen( $phones['mobile_number']) == 8 && ctype_digit($phones['mobile_number'])==true)){						
									$error['mobile_number'] =  'Mobilais tâlruòa numurs nav norâdîts pareizi';
							}
							
						}
						//citas valsts kods
						else{
							if (strlen($country_codes['mobile_number_country'])>5){ $error['mobile_number'] = "Mobilâ tâlruòa valsts kods nav norâdîts pareizi.";}
							elseif (strlen($phones['mobile_number'])<8){
								$error['mobile_number'] = 'Mobilais tâlruòa numurs nav norâdîts pareizi';
								
							}
						}
					}
				}
				else{
					if (strlen($phones['mobile_number'])<8){
						$error['mobile_number'] = 'Mobilais tâlruòa numurs nav norâdîts pareizi';
					}
					else{
						//$re = "/[^\\d\\s+]/"; 							
						if (preg_match($re,$phones['mobile_number'])){
							$error['mobile_number'] = 'Mobilais tâlruòa numurs nav norâdîts pareizi';
							
						}
					}
				}
			}
		}
		//var_dump($error);
		return $error;
	}
	
	//dokumentu validâcija
	// ieejâ saòem dokumentu masîvu
	function ValidateDocuments($documents){
		//var_dump($documents);
		$error = array('pase' => array(),'abi' => array(),'id_karte' => array());

		if (strlen($documents['paseNR'])<7 && strlen($documents['idNR'])<7 ){
			$error['abi']['dokuments'] = 'Jânorâda vismaz viena dokumenta numurs';
	
		}
		else{
			if (strlen($documents['paseNR'])>0 || strlen($documents['paseDERdat'])>0){
				
				//if (strlen($documents['paseS'])<2) { 	$error['paseS'] = 'Pases numura pirmâ daïa ir par îsu'; }
				//$error = $dalibn->Validate(array($documents['paseNR'],$documents['paseTerm']));
				if (strlen($documents['paseNR'])<7) { 	
					$error['pase']['paseNR'] = 'Pases numurs ir par îsu'; 
				
				}
				else{
					//$re = '/[a-z]{2}\d{7}\d*/i';
					//if (!preg_match($re, $documents['paseNR'])){
//						$error['pase']['paseNR'] = 'Pases numurs nav norâdîts pareizi'; 
					//}
				}
				if (strlen($documents['paseDERdat'])>0){
					if (DEBUG){
						echo "pase derdat:<br>";
						var_dump($documents['paseDERdat']);
						echo "<br><br>";
						echo "+10gadu:<br>";
						var_dump(date('d.m.Y',strtotime("+10 years")));
						echo "<br><br>";
						
					}
					if($this->db->CheckDateFormat($documents['paseDERdat']) == false){	
						$error['pase']['paseDERdat'] = 'Pases derîguma termiòam jâbût formâ dd.mm.GGGG';
						
					}
					//neïauj ceïot ar pasçm, kam ir 50gadu derîguma termiòð
					elseif(strtotime($documents['paseDERdat'])>strtotime("+10 years")){
							$error['pase']['paseDERdat'] = 'No 20.11.2017. ceïojumiem ârpus Latvijas <u>neder pases ar derîguma termiòu uz 50 gadiem</u> (izsniedza lîdz 19.11.2007.)<u> un pases ar ielîmçtu fotokartîti </u>(izsniedza lîdz 30.06.2002.).';
					}
				}
				else{	
					$error['pase']['paseDERdat'] = 'Pases derîguma termiòam jâbût formâ dd.mm.GGGG';
					
				}	
			}
		
			
			
			if (strlen($documents['idNR'])>0 || strlen($documents['idDerDat'])>0){
				$documents['idNR'] = trim($documents['idNR']);
				//if (strlen($documents['idS'])<2) { 	$error['idS'] = 'ID kartes pirmâ daïa ir par îsu'; }
				
				if (strlen($documents['idNR'])!=9) { 	
					$error['id_karte']['idNR'] = 'Personas apliecîbas numura garumam jâbût 9 zîmçm';
				}
				else{
					//$re = "/[a-z]{2}\\d{7}/i"; 
					//echo "id nr:".$documents['idNR']."<br>";
					//if (!preg_match($re, $documents['idNR'])){
						//$error['id_karte']['idNR'] = 'Personas apliecîbas numurs nav norâdîts pareizi'; 
					//}
				}
				
				if (strlen($documents['idDerDat'])>0){
					if($this->db->CheckDateFormat($documents['idDerDat']) == false){
						$error['id_karte']['idDerDat'] = 'Personas apliecîbas derîguma termiòam jâbût formâ dd.mm.GGGG';
						
					}
				}
				else{	
					$error['id_karte']['idDerDat'] = 'Personas apliecîbas derîguma termiòam jâbût formâ dd.mm.GGGG';
					
				}
			}
		
		
			
		}

		return $error;
					
	}
	//Atjauno dokumentu informâciju
	function UpdateDocuments($documents,$did,$update_profile = 0,$online_rez_id=0){
		require_once("i_functions.php");
		$es = $this->GetId();
		$mans_did = $es['ID'];
		//ja labo cita ceïotâja datus
		//if ($did != $mans_did){
			
			$dalibnieks = $this->GetId($did);
			
		//}
		//if (strlen($documents['paseNR'])>0 ){
			$db1 = $this->db->EscapeValues($documents,'paseNR');
		
			
			$numurs = DokNr($db1['paseNR']);
			if ($numurs['S']){
				$db1['paseS'] = strtoupper($numurs['S']);
			}
			else{
				$db1['paseS'] = '';
			}
			if ($numurs['NR']){
				$db1['paseNR'] = $numurs['NR'];
			}
			
			$paseTerm= $this->db->EscapeValues($documents,'paseDERdat');
				
			if (strlen($paseTerm['paseDERdat']) >0 )
				$db1['paseDERdat'] = $this->db->Str2SqlDate($paseTerm['paseDERdat']);	
			else $db1['paseDERdat'] = NULL;
			
			$values = array('paseS' => $db1['paseS'],
							'paseNR' => $db1['paseNR'],
							'paseDERdat' => $db1['paseDERdat']
							);
			if (DEBUG){
				echo "pases dati<br>";
				var_dump($values);
				echo "<br><br>";
			}
			$jasalidzina = 0;			
			if ($online_rez_id != 0 && $did != $mans_did){
				
					if (!empty($dalibnieks['paseNR'])){
						//ja pieteikuma dati neskarît ar dalîbnieka datiem
						if	($db1['paseNR'] != strtoupper($dalibnieks['paseNR']) || $db1['paseS'] != strtoupper($dalibnieks['paseS']) || $db1['paseDERdat'] != $dalibnieks['paseDERdat']){
							
							$jasalidzina = 1;
						}
						//ja viss sakrît, bet tikai derîguma termiòð nav norâdîts
						if ($db1['paseNR'] == strtoupper($dalibnieks['paseNR']) && $db1['paseS'] == strtoupper($dalibnieks['paseS']) && $this->db->IsEmptyDate($dalibnieks['paseDERdat'])){
							$jasalidzina = 0;
						}
						
					}
					else $jasalidzina = 1;
				
						
			}
			
			//pârbauda, vai iepriekð ir bijis norâdîts pases NR vai ja sakrit ar iepriekð norâdîto
				//var saglabât dalibn tabulâ uzreiz
			if (!$jasalidzina){
				if (DEBUG){
					echo 'Nav jâsalîdzinaa<br>';
					var_dump($dalibnieks['paseNR']);
				}
			//if (!empty($dalibnieks['paseNR'])){
					$this->Update($values,$did);
					if (DEBUG){
				echo "pases dati<br>";
				var_dump($values);
				echo "<br><br>";
			}
					if ($update_profile){
						$values = array('paseS' => $db1['paseS'],
									'paseNR' => $db1['paseNR'],
									'paseTerm' => $db1['paseDERdat']
									);
						$this->db->Update('profili',$values,$_SESSION['profili_id']);
						
					}
				//}
			}
			else{
				//saglabâ dokumenta izmaiòas tikai pieteikuma tabulâ
				require_once("m_pieteikums.php");
				$piet = new Pieteikums();				
				$pid = $piet->GetOnlineRezDid($online_rez_id,$did);
				
				$old_vals= $piet->GetId($pid);
				
				
				
				$this->db->Update('pieteikums',$values,$pid);
				$new_vals= $piet->GetId($pid);
				
				$this->db->UpdateActionDetails($old_vals,$new_vals,"pieteikums",$pid);
			}
			
			
			
				
				
		//}
		//if (strlen($documents['idNR'])>0 ){
		//}elseif($documents['document_type'] == 'id_card'){
			//$documents['idS'] = $documents['document1'];
			//$documents['idNr'] = $documents['document2'];
			$db1 = $this->db->EscapeValues($documents,'idNR');
		
			$numurs = DokNr($db1['idNR']);
			if ($numurs['S']){
				$db1['idS'] = strtoupper($numurs['S']);
			}
			else{
				$db1['idS'] = '';
			}
			if ($numurs['NR']){
				$db1['idNR'] = $numurs['NR'];
			}
			
											
			$idDerDat = $this->db->EscapeValues($documents,'idDerDat');
			if (strlen($idDerDat['idDerDat'])>0)
				$db1['idDerDat'] = $this->db->Str2SqlDate($idDerDat['idDerDat']);
			else $db1['idDerDat'] = NULL;
			
			$values = array('idS' => $db1['idS'],
							'idNR' => $db1['idNR'],
							'idDerDat' => $db1['idDerDat']
							);
			$jasalidzina = 0;			
			if ($online_rez_id != 0  && $did != $mans_did){
			//pârbauda, vai iepriekð ir bijis norâdîts id NR vai ja sakrit ar iepriekð norâdîto
				if (!empty($dalibnieks['idNR'])){
					//ja pieteikuma dati neskarît ar dalîbnieka datiem
					if ($db1['idNR'] != strtoupper($dalibnieks['idNR']) || $db1['idS'] != strtoupper($dalibnieks['idS']) || $db1['iDERdat'] != $dalibnieks['idDerDat'])
					{
						$jasalidzina = 1;
					}
					//ja viss sakrît, bet tikai derîguma termiòð nav norâdîts
					if ($db1['idNR'] == strtoupper($dalibnieks['idNR']) && $db1['idS'] == strtoupper($dalibnieks['idS']) && $this->db->IsEmptyDate($dalibnieks['idDerDat'])){
						$jasalidzina = 0;
					}
				}
				else $jasalidzina = 1;
			}
			if (!$jasalidzina){
				//if (!empty($dalibnieks['idNR'])){
					//var saglabât dalibn tabulâ uzreiz
					$this->Update($values,$did);
					if ($update_profile){
						$values = array('idS' => $db1['idS'],
									'idNr' => $db1['idNR'],
									'idDerDat' => $db1['idDerDat']
									);
						$this->db->Update('profili',$values,$_SESSION['profili_id']);
						
					}
				//}
			}
			else{
				//saglabâ dokumenta izmaiòas tikai pieteikuma tabulâ
				require_once("m_pieteikums.php");
				$pieteikums = new Pieteikums();
				$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
				$this->db->Update('pieteikums',$values,$pid);
			}
		//}
	}
	
	//Adreses validâcija
	function ValidateAddress($address){
		$error = array();
		if (strlen($address['adrese'])<5) { 	$error['adrese'] = 'Adrese nav ievadîta'; }
				
		if (strlen($address['pilseta'])<3 && empty($address['novads'])) {
			if (strlen($address['pilseta'])<3) 
				$error['pilseta'] = 'Pilsçta/Pagasts nav ievadîts'; 
			if (empty($address['novads'])) { 		
				$error['novads'] = 'Novads nav izvçlçts'; }
		}
	
	
	
		
		//if (empty($address['indekss'])) { 	$error['indekss'] = 'Pasta indekss nav norâdîts'; }
		//else
		if (!empty($address['indekss'])){
			
			if (strlen($address['indekss']) !=4 || !ctype_digit($address['indekss'])){
				$error['indekss'] = 'Pasta indekss nav norâdîts pareizi';
			}
			
		}
		return $error;
	}
	
	//atgrieþ dokumentu datus kâ masîvu - ja ir pietekumâ, tad no pieteikuma, ja nav, tad no dalibn tabulas
	function GetDocuments($online_rez_id,$did){
		
		require_once("m_pieteikums.php");
		$pieteikums = new Pieteikums();
		$pid = $pieteikums->GetOnlineRezDid($online_rez_id,$did);
		$qry = "SELECT paseS, paseNR, paseDERdat, idS, idNR, idDerDat 
					FROM pieteikums WHERE id = ? AND deleted=0";
		$params = array($pid);
		$result = $this->db->Query($qry,$params);
		/*$dokumenti = array ('paseS' => '',
							'paseNR' => '',
							'paseDERdat' => '',
							'idS' => '',
							'idNR' => '',
							'idDerDat' => ''
							);
		*/					
		

		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$dokumenti = $row;
		}
		if (DEBUG){
			echo "<br>dokumenti<br>:";
			var_dump($dokumenti);
			echo "<br><br>";
		}
		$select_arr = array();
		if (empty($dokumenti['paseS']))
			$select_arr[] = 'paseS';
		if (empty($dokumenti['paseNR']))
			$select_arr[] = 'paseNR';
		if (empty($dokumenti['paseDERdat']))
			$select_arr[] = 'paseDERdat';
			if (empty($dokumenti['idS']))
			$select_arr[] = 'idS';
		if (empty($dokumenti['idNR']))
			$select_arr[] = 'idNR';
		if (empty($dokumenti['idDerDat']))
			$select_arr[] = 'idDerDat';
		if (!empty($select_arr)){
			$fields = implode(", ",$select_arr);
			$qry = "SELECT $fields FROM dalibn WHERE id=?";
			if (DEBUG) echo $qry."<br>";
			$params = array($did);
			$result = $this->db->Query($qry,$params);
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				foreach ($select_arr as $key){
					$dokumenti[$key] = $row[$key];
				}
			}
		}
		return $dokumenti;
		
	}
	
	//atgrieþ dalîbnieka id pçc pietiekuma ID no pieteikuma saites
	function GetIdPidSaite($pid){
		$qry = "select ID from dalibn where id in (select did from piet_saite where pid = ?)";
		$params = array($pid);
		$result = $this->db->Query($qry,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row['ID'];
		}
		
	}	
	
	//atrodam visus dalîbniekus, kam pieteikuma dokumentu dati nesakrît ar dalîbnieka dokumentu datiem
	function GetMainitiDok(){
		$qry = "SELECT d.ID as did,d.vards,d.uzvards,
				d.paseS dalibn_paseS,p.paseS as piet_paseS,
				d.paseNr dalibn_paseNr,p.paseNr as piet_paseNr,
				d.paseDerDat as dalibn_paseDerDat, p.paseDerDat as piet_paseDerDat,
				d.idS as dalibn_idS, p.idS as piet_idS,
				d.idNr as dalibn_idNr, p.idNR as piet_idNr,
				d.idDerDat as dalibn_idDerDat, p.idDerDat as piet_idDerDat,
				p.id as pid,p.gid,g.sakuma_dat,g.beigu_dat,m.v
				FROM pieteikums p,dalibn d,grupa g,marsruts m
				WHERE p.deleted=0 AND p.did=d.id AND p.gid=g.id AND g.mid = m.id
				AND (p.paseS IS NOT NULL OR p.paseNr IS NOT NULL OR p.paseDerDat IS NOT NULL
						OR p.idS IS NOT NULL OR p.idNr IS NOT NULL OR p.idDerDat IS NOT NULL) 
				AND (isnull(p.paseS,d.paseS)!=isnull(d.paseS,'')
				OR isnull(p.paseNr,d.paseNr)!=isnull(d.paseNr,'')
				OR isnull(p.paseDerDat,d.paseDerDat)!=isnull(d.paseDerDat,'')
				OR isnull(p.IDS,d.IDS)!=isnull(d.IDS,'')
				OR isnull(p.idNr,d.idNr)!=isnull(d.idNr,'')
				OR isnull(p.idDerDat,d.idDerDat)!=isnull(d.idDerDat,''))
				ORDER BY g.sakuma_dat ASC,m.v ASC";
		$result = $this->db->Query($qry);
		$result_array = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$result_array[] = $row;
		}
		return $result_array;
	}
	
	//atgrieþ dalîbnieka vecumu uz konkrçto datumu (pçc noklusçjuma - ðo dienu)
	function GetAgeId($id,$day = null){
		$dalibn = $this->GetId($id);
		if (!isset($day))
			$day = new DateTime();
		$birthday = $dalibn['dzimsanas_datums'];
		$empty_date = new DateTime('1900-01-01');
	
		if (!empty($birthday) && $birthday != $empty_date){
			$diff = $day->diff($birthday);
			$age = $diff->format('%y');
			return $age;
		}
		else return false;
	}
	
	//atgrieþ dalîbnieka vecumu uz aktîvâs rezervâcijas ceïojuma pçdçjo dienu
	function GetAgeIdRes($did,$online_rez_id){
		
		require_once("m_grupa.php");
		require_once("m_online_rez.php");
		
		$gr = new Grupa();
		$online_rez = new OnlineRez();		
		
		$gid = $online_rez->GetGidId($online_rez_id);
		$grupa = $gr->GetId($gid);
		$beigu_dat = $grupa['beigu_dat'];	
		
		$age = $this->GetAgeId($did,$beigu_dat);
		return $age;
	}
	//atgrieþ true, ja dalîbnieks ir bçrns, false - ja pieauguðais uz aktîvâs rezervâcijas ceïojuma beigâm
	function IsChild($id,$max_age = 18){
		$age = $this->GetAgeIdRes($id);
		$child = ($age < $max_age ? 1 : 0);
		return $child;
	}
	//pârbauda, vai dzimðanas datums ir ievadîts pareizi
	function ValidateBirthday($dzimsanas_datums){
		$error = array();
		if (strlen($dzimsanas_datums)>0){
			if($this->db->CheckDateFormat($dzimsanas_datums) == false){	
				$error['dzimsanas_datums'] = 'Dzimðanas datumam jâbût formâ dd.mm.GGGG';		
			}
		}
		else{	
			$error['dzimsanas_datums'] = 'Dzimðanas datumam jâbût formâ dd.mm.GGGG';			
		}
		return $error;		
	}
	
	//saglabâjam lietotâju, kas pçrk dk bez reìistrâcijas(vai atgrieþam esoða dalibn.id)
	function SaveDkBuyer($data){
		$where_cond = "pk1 IS NULL AND pk2 IS NULL AND deleted=0 AND internets=1";
		$result = $this->db->GetWhere('dalibn',$data,$where_cond);
		
		

		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$did = $row['ID'];
			//echo "eksistç";
			
		}
		else {
			//echo "neesksistç";
			$did = $this->Insert($data);
		}
		return $did;
	}
	
	
	//atgrieþ dalîbnieku(s) prçc rezervâcijas id (online vai pieteikuma)
	function GetByRez($rez_id){
		$qry = "SELECT * FROM dalibn WHERE id in (select did from pieteikums where online_rez=? AND deleted=0) or id in (select did from piet_saite where pid=? and deleted=0)";
		//echo $qry;
		$params = array($rez_id,$rez_id);
		///var_dump($params);
		//echo "<br><br>";
		$result = $this->db->Query($qry,$params);
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			$data[] =$row;
		}
		return $data;
	}
	
	//atgrieþ dalîbnieka vecumu uz doto datumu
	function GetAge($did,$beigu_dat){
				//var_dump($beigu_dat);
				//echo $did;
		$birthday = $this->Birthday($did);
		//var_dump($birthday);
		$diff = $beigu_dat->diff($birthday);
		$age = $diff->format('%y');
		return $age;
	}
	

	
	

	
}
?>