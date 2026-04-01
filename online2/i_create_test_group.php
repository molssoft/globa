<?

//izveido testa grupu, nokopçjot esoðo
function createTestGroup($gid){
//setlocale(LC_CTYPE, 'lv_LV');

	session_start();
	define("DEBUG","1");
	require_once('m_init.php');
	$db = new Db();
	
	
	//$old_mid = $grupa['mID'];
	require_once("m_marsruts.php");
	$marsruts = new Marsruts();
	$marsr_arr = $marsruts->GetGid($gid);
	if (count($marsr_arr) >0){
	unset($marsr_arr['ID']);
//require_once("i_functions.php");

	$marsr_arr['v'] = 'TEST GRUPA: '.str_replace('"','\"',$marsr_arr['v']);//'test';//
	
	$marsr_arr['v2'] = 'TEST GRUPA: '.str_replace('"','\"',$marsr_arr['v2']);
		var_dump($marsr_arr);
	echo "<br><br>";

	
	
	$mID = $marsruts->Insert($marsr_arr);
	//echo "Mid : $mID <br>";	
	
	/*$values = array('v' => 'TESTA MARSRUTS: '.$marsr_arr['v'],
					'cena' => $marsr_arr['cena'],
					'old' => $marsr_arr['old'],
	$qry = "INSERT INTO  marsruts (v,cena,USD,old,v2,need_check,valsts,klubins,kajites)   
			SELECT 'TESTA MARSRUTS: '+m.v,m.cena,m.USD,m.old,m.v2,m.need_check,m.valsts,m.klubins,m.kajites
			from grupa g,marsruts m WHERE g.mID=m.ID and g.ID=?";
	echo $qry."<br>";
	var_dump($gid);
	$params = array($gid);
	$db->Query($qry,$params);
	//var_dump($result);
	*/
	
	echo "Mid : $mID <br>";	
require_once("m_grupa.php");
	$gr = new Grupa();
	$grupa = $gr->GetId($gid);
	echo "Grupa:<br>";
	var_dump($grupa);
	echo "<br><br>";
	$grupa['TESTAM'] = 1;
	$grupa['mID'] = $mID;
	$grupa['kods'] = $grupa['kods'].'_test';
	$grupa['kontrolieris'] = NULL;
	$grupa['kurators'] = NULL;
	$grupa['vaditajs'] = NULL;
	$grupa['vaditajs2'] = NULL;
	$grupa['piezimes'] = "Testa grupa. <font color=\"red\">Izmantot tikai online rezervâciju testçðanai!</font>";
	$grupa['pardot_agentiem'] = 0;
	unset($grupa['sapulces_dat']);
	unset($grupa['sapulces_laiks_no']);
	unset($grupa['sapulces_laiks_lidz']);
	unset($grupa['ID']);
	unset($grupa['v']);
	echo "Grupa:<br>";
	var_dump($grupa);
	echo "<br><br>";
	$grupas_id = $db->Insert('grupa',$grupa);
	$qry = "SELECT MAX(id) as id FROM grupa WHERE mID=?";
	echo $qry."<br>";
	$params = array($mID);
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		$new_gid = $row['id'];
		
	}
	
	echo "jaunais grupas ID $new_gid<br>";
	
	 //conn.execute ("delete from vietas where gid = "+cstr(id))
	//conn.execute ("
	$qry = "DELETE FROM vietas WHERE gid=?";
	echo $qry."<br>";
	$params = array($new_gid);
	 $db->Query($qry,$params);
	$qry = "insert into vietas (gid,vietas) values ($new_gid,isnull(dbo.fn_brivas_vietas($new_gid),0))";
	echo $qry."<br>";
	 $db->Query($qry);
	/*$qry = "SELECT vietas FROM vietas WHERE gid=?";
	echo $qry."<br>";
	$params = array($gid);
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		//$vietas = $row['vietas'];
		$values = array('gid' => $new_gid,
						'vietas' => $vietas);
		$db->Insert('vietas',$values);
	}*/
		
		
		
	$qry = "SELECT * FROM vietu_veidi WHERE gid=?";
	echo $qry."<br>";
	$params = array($gid);
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		//$new_gid = $row['id'];
		$values = $row;
		$values['gid'] = $new_gid;
		unset($values['id']);
		echo "values:<br>";
		var_dump($values);
		echo "<br><br>";
		$db->Insert('vietu_veidi',$values);
		
	}
	
	$qry = "SELECT * FROM viesnicas_veidi WHERE gid=?";
	
	$params = array($gid);
	echo $qry."<br>";
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		//$new_gid = $row['id'];
		$values = $row;
		$values['gid'] = $new_gid;
		
		$viesnicas_veida_id = $values['id'];
		unset($values['id']);
		echo "values:<br>";
		var_dump($values);
		echo "<br><br>";
		$where_arr = array('gid' => $new_gid);
		$jaunais_veids = $db->Insert('viesnicas_veidi',$values,$where_arr);
		echo "Jaunais viesnicas veida iud: $jaunais_veids <br>";
		$qry = "SELECT * FROM viesnicas WHERE veids=?";
		$params = array($viesnicas_veida_id);
		echo $qry."<br>";
		var_dump($params);
		$res1 = $db->Query($qry,$params);
		while( $row1 = sqlsrv_fetch_array( $res1, SQLSRV_FETCH_ASSOC) ) {
			$values1 = $row1;
			unset($values1['id']);
			$values1['gid'] = $new_gid;
			$values1['veids'] = $jaunais_veids;
			$db->Insert('viesnicas',$values1);
			
		}
		
		
		
		
	}
	$qry = "SELECT * FROM kajites_veidi WHERE gid=?";
	
	$params = array($gid);
	echo $qry."<br>";
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		//$new_gid = $row['id'];
		$values = $row;
		$values['gid'] = $new_gid;
		
		$veida_id = $values['id'];
		unset($values['id']);
		echo "values:<br>";
		var_dump($values);
		$where_arr = array('gid' => $new_gid);
		echo "<br><br>";
		$jaunais_veids = $db->Insert('kajites_veidi',$values,$where_arr);
		echo "Jaunais veida iud: $jaunais_veids <br>";
		$qry = "SELECT * FROM kajite WHERE veids=?";
		$params = array($veida_id);
		echo $qry."<br>";
		var_dump($params);
		$res1 = $db->Query($qry,$params);
		while( $row1 = sqlsrv_fetch_array( $res1, SQLSRV_FETCH_ASSOC) ) {
			$values1 = $row1;
			unset($values1['id']);
			$values1['gid'] = $new_gid;
			$values1['veids'] = $jaunais_veids;
			$db->Insert('kajite',$values1);
			
		}
		
		
		
		
	}
	/*$qry = "SELECT * FROM kajites WHERE gid=?";
	echo $qry."<br>";
	$params = array($gid);
	var_dump($params);
	$res = $db->Query($qry,$params);
	while( $row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
		//$new_gid = $row['id'];
		$values = $row;
		$values['gid'] = $new_gid;
		unset($values['id']);
		echo "values:<br>";
		var_dump($values);
		echo "<br><br>";
		$db->Insert('vietu_veidi',$values);
		
	}*/
	}
	else echo "grupa nav atrasta";
	
}

if (isset($_GET['gid']) && (int)$_GET['gid'] >0 ){
	$grupas_id=(int)$_GET['gid'];
}
else{
	//ðeit norâda grupas ID

	$grupas_id = 21312;
}
//$grupas_id = 20951;
createTestGroup($grupas_id);


?>