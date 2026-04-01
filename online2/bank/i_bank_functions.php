<?
function CreateDbOrders($rez_id, $p_apmaksas_veids, $trans_id) {
	
	global $uniq_id;
	$f_name = "CreateDbOrders(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")";
	
	Log2File("begin",$f_name);
	
	global $db;

	$EUR_RATE = 0.702804; 
	if ($trans_id=="") {
		Log2File("return (empty trans_id)",$f_name);

		return;
	}

	//res = True
	$str_ord_ids = "";

	//Set $c_cel = $new $cls_celojumi;

	$o_valuta_id = 49; //EUR valuta no 1/1/2014

	//Set r_val = db.Conn.Execute("SELECT id, bankas_konts, mkartes_konts FROM valuta WHERE val = 'LVL'")
	//o_valuta_id = r_val("id")		

	$o_debets = "";
	if ($p_apmaksas_veids == "mk") {
		$o_debets = "2.6.2.5.1";
	} elseif ($p_apmaksas_veids == "ib"){ //--- swedbank
		$o_debets = "2.6.2.4.5"; //"2.6.2.4.1"			
	} elseif ($p_apmaksas_veids == "dnbnord"){
		$o_debets = "2.6.2.2.1"; //"2.6.2.2.1"
	} elseif ($p_apmaksas_veids =="seb"){
		$o_debets = "2.6.2.6.1"; //"2.6.2.6.1" 
	} elseif ($p_apmaksas_veids == "citadele"){
		$o_debets = "2.6.2.1.2"; //"2.6.2.1.1" 
	}
		
	//'db.conn.execute("insert into debug_log (teksts) values ('apmaksas o_debets="+o_debets+"')")


	$ssql = "select distinct p.id as pid, isnull(p.profile_id,'') as profile_id,
			/*pp.vards, pp.uzvards, */
			g.kods, g.sakuma_dat, g.beigu_dat, 
			m.v as nos, 
			d.id as did, d.vards as dal_vards, " .
			"d.uzvards as dal_uzv, 
			p.summaLVL, p.summaEUR, 
			g.konts, g.konts_ava, 
			t.summa as ord_summa, isnull(g.valuta,'LVL') as gvaluta " .
			"from pieteikums p " .
			"/*inner join profili pp on pp.id = p.profile_id */" .
			"inner join dalibn d on d.id = p.did " .
			"inner join grupa g on g.id = p.gid " .
			"inner join marsruts m on g.mid = m.id " .
			"inner join trans_uid t on t.pid = p.id " .
			"where p.deleted=0 and p.tmp=0 and p.atcelts=0 
			and p.online_rez=$rez_id and replace(t.trans_id,'_','-') like '%".str_replace('_','-',$trans_id)."' and t.completed=0 ";

	
	$params = array();
	Log2File("prepare query ".$ssql." with params ".print_r($params,true),$f_name);
	$res = $db->Query($ssql);
	//Set $result = $db.$Conn.Execute($ssql);

	//'db.conn.execute("insert into debug_log (teksts) values ('trans_uid selekts')")

	//response.End
	//ierakstâm failâ atgriezto rindiòu skaitu:
	//

	
	while ($result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
		Log2File("query ".$ssql." with params ".print_r($params,true)." returned ".print_r($result,true),$f_name);
		//file_put_contents($filename,date("Y-m-d H:i:s")."  CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=> query ".$ssql." with params ".print_r($params,true)." returned ".print_r($result,true)." \r\n\r\n",FILE_APPEND);
		//While Not $result.$eof;
		//'db.conn.execute("insert into debug_log (teksts) values ('rindas sakums')")
		
		$o_pid = $result["pid"];
		$o_num = getOrdNum();
		$o_datums = date("d.m.Y H:i:s");
		$o_sakuma_dat = $result["sakuma_dat"];
		
		if (!empty($result['profile_id'])){
			if (file_exists ("m_profili.php")){
				require_once("m_profili.php");
			}
			else require_once("../m_profili.php");
			$profili = new Profili();
			$profils = $profili->GetId($result['profile_id']);
			$vards = $profils['vards'];
			$uzvards = $profils['uzvards'];
		}
		else{
			$vards = $result["dal_vards"];
			$uzvards  = $result["dal_uzv"];
		}
		$o_kas = Upper($vards." ".$uzvards);
		$o_dalibn = $result["did"];
		
		$str_pamatojums = $result["kods"]." ";
		if (!empty($o_sakuma_dat)) 
				$str_pamatojums .= $o_sakuma_dat->format("d.m.Y")." ";
		$str_pamatojums .=$result["nos"].". Dalîbnieks: ".$result["dal_vards"]." ".$result["dal_uzv"];
		$o_pamatojums = $str_pamatojums;
		$o_pielikums = "Rezervacija: ".$o_pid;
		$o_summa = $result["ord_summa"]; //--- dal. maks. izmainas: summaLVL -> ord_summa
		$o_summaval = $o_summa;

		$o_beigu_dat = $result["beigu_dat"];

		//--- kredits
		//--- ja celjojuma beigu datums ir veelaaks par tekosho meenesi, njem avansa kontu
		$now =  new DateTime("now");
		$now->modify('last day of this month');
		if ($o_beigu_dat>$now) {
		   $o_kredits = $result["konts_ava"]; //njem avansa kontu
		} else {
		   $o_kredits = $result["konts"]; //njem ienjemumu kontu
		}
		//'db.conn.execute("insert into debug_log (teksts) values ('o_kredits="+o_kredits+"')")
		
		$o_vesture = $o_kas." - Izveidoja. ".$o_datums;
		$o_nosummaLVL = $o_summa;
		$o_summaLVL = $o_summa;

		$o_kas2 = $o_kas;
		$o_kas2 = EncodeOldCharset($o_kas2);
		
		$o_pamatojums2 = EncodeOldCharset($str_pamatojums);
		$o_pielikums2 =  EncodeOldCharset($o_pielikums);

		$o_parbaude = 1;
		$o_resurss = $result["kods"];
		$o_maks_veids = "banka";

		$o_nosummaEUR = $o_nosummaLVL; //round100(o_nosummaLVL / EUR_RATE)
		$o_summaEUR = $o_summaLVL; //round100(o_summaLVL / EUR_RATE)

		$ssql = "select * from trans_uid where completed = 0 AND replace(trans_id,'_','-') LIKE '%".str_replace('_','-',$trans_id)."'";
		//$params = array ($trans_id);
		//
		echo $ssql."<br>";
		//var_dump($params);
		//echo "<br><br>";
		//Set $transuid = $db.$Conn.Execute($ssql);
		Log2File("query ".$ssql,$f_name);
		//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=> query ".$ssql." \r\n\r\n",FILE_APPEND);
		$transuid = $db->Query($ssql);	

		//--- paarbauda vai orderi shai rezervaacjai jau nav izveidoti
		//--- dal. maks. izmainjas: parbauda vai trans_uid transakcijas lauks ir completed = 1, tas nozime, ka orderi vienreiz jau ir izveidoti. 
		//--- tada gadijuma, jaunus neveido - funkcijas beigas.
		if (!sqlsrv_has_rows($transuid )){
			//die('stop yes');
			//echo 'eksiste';
			//if ($transuid.$eof) {
			//transakcijas orderi jau eksistee
			//'db.conn.execute("insert into debug_log (teksts) values ('transakcijas orderi jau eksiste. Exiting')")
			Log2File("Transkacijas orderi jau eksistç (".$ssql." returned 0 rows)",$f_name);
			//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=> Transkacijas orderi jau eksistç (return (".$ssql." returned 0 rows)) \r\n\r\n",FILE_APPEND);
			//dzçðam ðajâ ciklâ izveidotos orderus, jo iespçjams kâds paralçlais process ir izveidojis jau orderus - RT 10.01.19
			if (!empty($str_ord_ids)){
				$del_qry = "UPDATE orderis SET deleted=0 WHERE id IN ($str_ord_ids)";
				Log2File("Dzçðam ðeit izveidotos orderus: $del_qry",$f_name);
				$db->Query($del_qry);
			}
			Log2File("Atgrieþamies no funkcijas bez orderu izveidoðanas",$f_name);
			return  "";
		}
		else {
			//die('stop no');
			Log2File("Transakcijas orderi vel neesksitç ($ssql returned 0 rows)",$f_name);			
			//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=>Transakcijas orderi vel neesksitç (returned >0 rows) \r\n\r\n",FILE_APPEND);
		}

		//pârbaudam kâdâ valûtâ ir grupas bilance
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));	
		$formated_date = $date->format('Y-m-d H:i:s');
		if ($result["gvaluta"] == "EUR" ) {

			//'db.conn.execute("insert into debug_log (teksts) values ('grupas bilance EUR')")
			
			$o_summa = Round100($o_summaEUR * $EUR_RATE);
			$values = array('pid' => $o_pid,
							'nopid' => 0,
							'num' => $o_num,
							'datums' => $formated_date,
							'kas' => $o_kas,
							'dalib' => $o_dalibn,
							'pamatojums' => $o_pamatojums,
							'pielikums' => $o_pielikums,
							'summaval' => $o_summaval,
							'valuta' => $o_valuta_id,
							'summa' => $o_summa,
							'kredits' => $o_kredits,
							'debets' => $o_debets,
							'deleted' => 0,
							'vesture' => $o_vesture,
							'nosummaEUR' => $o_nosummaEUR,
							'summaEUR' => $o_summaEUR,
							'kas2' => $o_kas2,
							'pamatojums2' => $o_pamatojums2,
							'pielikums2' => $o_pielikums2,
							'parbaude' => $o_parbaude,
							'resurss' => $o_resurss,
							'maks_veids' =>$o_maks_veids 
							);
		
			$ssql = "Set Nocount on; INSERT INTO orderis(pid,nopid,num,datums,kas,dalib,pamatojums,pielikums,summaval,valuta,summa,kredits,debets,deleted,vesture," .
					"nosummaEUR,summaEUR,kas2,pamatojums2,pielikums2,parbaude,resurss,maks_veids) " .
					"VALUES(".$o_pid.",0,'".$o_num."',getdate(),'".$o_kas."','".$o_dalibn."','".$o_pamatojums."'
					,'".$o_pielikums."',".$o_summaval.",".$o_valuta_id.",".$o_summa.",'".$o_kredits."','".$o_debets."',
					0,'".$o_vesture."',".$o_nosummaEUR.",".$o_summaEUR.",'".$o_kas2."','".$o_pamatojums2."','".$o_pielikums2."'
					,".$o_parbaude.",'".$o_resurss."','".$o_maks_veids."'); Select @@IDENTITY as id";
					

		} else {

			$values = array('pid' => $o_pid,
							'nopid' => 0,
							'num' => $o_num,
							'datums' => $formated_date,
							'kas' => $o_kas,
							'dalib' => $o_dalibn,
							'pamatojums' => $o_pamatojums,
							'pielikums' => $o_pielikums,
							'summaval' => $o_summaval,
							'valuta' => $o_valuta_id,
							'summa' => $o_summa,
							'kredits' => $o_kredits,
							'debets' => $o_debets,
							'deleted' => 0,
							'vesture' => $o_vesture,
							'nosummaLVL' => $o_nosummaLVL,
							'summaLVL' => $o_summaLVL,
							'kas2' => $o_kas2,
							'pamatojums2' => $o_pamatojums2,
							'pielikums2' => $o_pielikums2,
							'parbaude' => $o_parbaude,
							'resurss' => $o_resurss,
							'maks_veids' =>$o_maks_veids 
							);
		
			//'conn.execute("insert into debug_log (teksts) values ('grupas bilance cita')")
			/*$ssql = "Set Nocount on; INSERT INTO orderis(pid,nopid,num,datums,kas,dalib,pamatojums,pielikums,summaval,valuta,summa,kredits,debets,deleted,vesture," .
					"nosummaLVL,summaLVL,kas2,pamatojums2,pielikums2,parbaude,resurss,maks_veids) " .
					"VALUES(".$o_pid.",0,'".$o_num."',getdate(),'".$o_kas."','".$o_dalibn."','".$o_pamatojums."'
					,'".$o_pielikums."',".$o_summaval.",".$o_valuta_id.",".$o_summa.",'".$o_kredits."','".$o_debets."',
					0,'".$o_vesture."',".$o_nosummaLVL.",".$o_summaLVL.",'".$o_kas2."','".$o_pamatojums2."','".$o_pielikums2."'
					,".$o_parbaude.",'".$o_resurss."','".$o_maks_veids."'); Select @@IDENTITY as id";
			*/
		}


		


		//'db.conn.execute("insert into debug_log (teksts) values ('tulit bus inserts')")
		//$where_arr = array('pid' => $o_pid, 'num' => $o_num);
		$ord_id = $db->Insert('orderis',$values);
		
		$qry = "SELECT max(id) as ord_id FROM orderis where pid=? and vesture like ?";
		$params = array($o_pid,$o_vesture);
		Log2File("query ".$qry." with params ".print_r($params,true),$f_name);	
		//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=> query ".$qry." with params ".print_r($params,true)." \r\n\r\n",FILE_APPEND);
	
		$result_ord = $db->Query($qry,$params);
		
		while( $row_ord = sqlsrv_fetch_array( $result_ord, SQLSRV_FETCH_ASSOC) ) {
			$ord_id = $row_ord['ord_id'];
		}
		//Set $r_ord = $db.$Conn.Execute($ssql);

		//'db.conn.execute("insert into debug_log (teksts) values ('inserts izpildits')")
		if ($ord_id) {

			
			//'db.conn.execute("insert into debug_log (teksts) values ('vertiba atgriezta. rinda inserteta.')")
			if ($str_ord_ids != "") {
				$str_ord_ids = $str_ord_ids.",";
			}

			$str_ord_ids = $str_ord_ids.$ord_id;

			//--- atzime, ka transakcija ir izpildita, lai neatkartotu orderu veidosanu
			/*$values = array('o_id' => $r_ord,
							'completed' => 1);
			$where_arr = array(*/
			$trans_id = str_replace('_','-',$trans_id);
			$ssql = "UPDATE trans_uid SET o_id = $ord_id, completed = 1 WHERE replace(trans_id,'_','-') LIKE '%" . $trans_id ."' AND pid = $o_pid";
			
			$params = array($ord_id,str_replace('_','-',$trans_id),$o_pid);
			
			//$db->UpdateWhere('trans_uid',$values
			//var_dump($params);

			//	$db->Query($ssql,array());
			/*echo $ssql."<br>";
			var_dump($params);
			echo "<br><br>";*/
			$db->Query($ssql,$params);
			//die($ssql);
			//$db.$Conn.Execute($ssql);
			//'db.conn.execute("insert into debug_log (teksts) values ('updeits izpildits')")

			
		}

		//--- parrekina piet summu
		CalculateSum($o_pid);
		//'db.conn.execute("insert into debug_log (teksts) values ('summas parkakluletas')")

	
		

	}
	Log2File(" returned ord_id: ".$str_ord_ids,$f_name);	
	//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.") returned ord_id: ".$str_ord_ids." \r\n\r\n",FILE_APPEND);
	
	return  $str_ord_ids;

} 
//------------------------------------------------------------------------------
function CreateDbOrders_new($rez_id, $p_apmaksas_veids, $trans_id) {
	 require_once("../m_user_tracking.php");
	$u_track = new UserTracking();
	 require_once("../l_email.php");
	$email = new Email();
	global $uniq_id;
	$f_name = "CreateDbOrders_new(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")";
	
	/*if (file_exists("log\get".date("Y-m").".txt")){
		$filename = "log\get".date("Y-m").".txt";
	}
	elseif (file_exists("bank\log\get".date("Y-m").".txt")){
		$filename = "bank\log\get".date("Y-m").".txt";
	}*/
	Log2File("begin",$f_name);
	//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.") begin \r\n\r\n",FILE_APPEND);
	
	global $db;
	//'db.conn.execute("insert into debug_log (teksts) values ('enter create_db_ordersa rez_id="+CStr(rez_id)+"')")

	//eksistee 1 rezervaacija ar vienu vai vairaakiem pieteikumiem.
	//katram pieteikumam tiek izveidots 1 orderis par kopejo pakalpojumu summu.
	//--- p_apmaksas_veids vertibas: 
	//mk = maksajumu karte; 
	//ib = swedbank internetbanka ; 
	//dnbnord = dnbnord internetbanka ; 
	//atshkir, jo katram savs debeta konts.
	//seb, citadele
	
	//--- izmaiòas 18.dec 2012 online dalîtais maksâjums
	//--- par ceïojumu var maksât vairâkâs daïâs 
	//--- rezultâtâ katram rezervâcijas pieteikumam tiek veidoti viens vai vairâki orderi

	//dim $EUR_DATE;
	//dim $EUR_RATE;
	//$EUR_DATE = DateSerial(2014,1,1);
	//$EUR_RATE = 0.702804; 

	if ($trans_id=="") {
		//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.")=> return (empty trans_id) \r\n\r\n",FILE_APPEND);
		Log2File("Transakcija nav atrasta. return (empty trans_id)",$f_name);
		
		//echo "tukðs trans_id<br>";
		return  "";
		//'db.conn.execute("insert into debug_log (teksts) values ('trans_id is empty. exiting')")

	}
	
	
	$str_ord_ids = "";
	$qry = "{call online_create_orders (?,?,?, ?)}";
	
	//$params  = array(array($rez_id, SQLSRV_PARAM_IN),  array($p_apmaksas_veids, SQLSRV_PARAM_IN), array($trans_id, SQLSRV_PARAM_IN),array($output, SQLSRV_PARAM_OUT));
	$params  = array($rez_id,$p_apmaksas_veids,$trans_id,$uniq_id);//
	$text = "Izsauc db procedru orderu veidosanai: ".$qry." >>> ".print_r($params,true);
	Log2File($text,$f_name);	
		//var_dump($params);
	$result = $db->Query($qry,$params);
	$text = "DB Procedura online_create_orders ir izpildijusies: procedure result: ".print_r($result,true);
	Log2File($text,$f_name);	
		//var_dump($params);
	//echo 'result:';
	//var_dump($result);
	//$has_error = true;
	if( $result === false )  
    {  
        // echo "Error in executing statement 3.\n";  
        // die( print_r( sqlsrv_errors(), true));  
		 $text = "Kïûda 001, veidojot orderus rezervâcijai #$rez_id";
		Log2File($text." ".print_r( sqlsrv_errors(), true),$f_name);	
		$u_track->Save('<font color="red">'.$text.'</font>');
		unset($_SESSION['reg_success']);
		$email->SendMail($text, 'Online orderu kluda','r.treikalisha@gmail.com',$save = true);
		die('<font color="red">Kïûda, veidojot orderus. Lûdzu, sazinieties ar IMPRO. </font><br><a href="/online/c_reservation.php?f=Summary&rez_id='.$rez_id.'">Atgriezties uz rezervâciju</a>');
	
    } 
	
	$qry = "SELECT * FROM online_created_orders WHERE rez_id=? AND apmaksas_veids=? AND trans_id=? and req_id=?";
	//echo $qry;
	$params = array($rez_id,$p_apmaksas_veids,$trans_id,$uniq_id);//
	$text = 'Mekle proceduras izveidotos orderus:'.$qry." >>> ".print_r($params,true);
	Log2File($text,$f_name);	
	$result = $db->Query($qry,$params);
	//var_dump($params);
	if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		//echo 'row:';
		//print_r($row);
		$str_ord_ids = $row['str_ord_ids'];
	}
	else{
		 $text = "Kïûda 002, veidojot orderus rezervâcijai #$rez_id";
			Log2File($text,$f_name);	
			$u_track->Save('<font color="red">'.$text.'</font>');
			unset($_SESSION['reg_success']);
			$email->SendMail($text, 'Online orderu kluda','r.treikalisha@gmail.com',$save = true);
			die('<font color="red">Kïûda, veidojot orderus. Lûdzu, sazinieties ar IMPRO. </font><br><a href="/online/c_reservation.php?f=Summary&rez_id='.$rez_id.'">Atgriezties uz rezrevâciju</a>');
		
	}
//exit();
	/*while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		echo 'row:';
		print_r($row);
		//var_dump( $row['str_ord_str']);
		//$str_ord_ids = $row['str_ord_str'];
		if (array_key_exists('str_ord_ids',$row)){
			$has_error = false;
			$str_ord_ids = $row['str_ord_ids'];
		}
	}*/
	//	sqlsrv_next_result($stmt);

	/*if ($has_error){
		$text = "Kïûda, veidojot orderus rezervâcijai #$rez_id";
		Log2File($text,$f_name);	
		$u_track->Save('<font color="red">'.$text.'</font>');
		unset($_SESSION['reg_success']);
		$email->SendMail($text, 'Online orderu kluda','r.treikalisha@gmail.com',$save = true);
		die('<font color="red">Kïûda, veidojot orderus. Lûdzu, sazinieties ar IMPRO. </font><br><a href="/online/c_reservation.php?f=Summary&rez_id='.$rez_id.'">Atgriezties uz rezrevâciju</a>');
	}
		exit();
*/
	

	Log2File(" returned ord_id: ".$str_ord_ids,$f_name);	
	//file_put_contents($filename,date("Y-m-d H:i:s")." CreateDbOrders_$uniq_id(".$rez_id.",".$p_apmaksas_veids.",".$trans_id.") returned ord_id: ".$str_ord_ids." \r\n\r\n",FILE_APPEND);
	
	return  $str_ord_ids;

}

 


/*function IrLigums($rez_id) { //--- vai ir apstiprinats ligums
	global $db;	
	//--- apstiprinats ir, ja online_rez tabulaa ir liguma id un liguma ierakstam ir accepted = 1

	//dim $query, $result; 
	$query = "select * from online_rez r inner join ligumi l on l.id = r.ligums_id 
				where r.deleted = 0 and l.deleted = 0 and r.id = ?";
	$params = array($rez_id);
	$result = $db->Query($query,$params);
	//Set $result = $db.$Conn.Execute($query);
	
	if (!sqlsrv_has_rows($result)) {
		return  false;
	} else {
		return  true;
	}
}*/

//==========================================================
//' Aizvieto visas mîkstâs zîmes un garos burtus ar # un normâlo burtu vajadzîgs savietojamîbai ar veco DB
function EncodeOldCharset($val) {
	//dim $key, $key_max, regexp;
	//dim regexp_string_array(3, 10);
	$regexp_string_array[0][0] = "â";
	$regexp_string_array[0][1] = "è";
	$regexp_string_array[0][2] = "ç";
	$regexp_string_array[0][3] = "ì";
	$regexp_string_array[0][4] = "î";
	$regexp_string_array[0][5] = "í";
	$regexp_string_array[0][6] = "ï";
	$regexp_string_array[0][7] = "ò";
	$regexp_string_array[0][8] = "ð";
	$regexp_string_array[0][9] = "û";
	$regexp_string_array[0][10] = "þ";

	$regexp_string_array[1][0] = "#a";
	$regexp_string_array[1][1] = "#c";
	$regexp_string_array[1][2] = "#e";
	$regexp_string_array[1][3] = "#g";
	$regexp_string_array[1][4] = "#i";
	$regexp_string_array[1][5] = "#k";
	$regexp_string_array[1][6] = "#l";
	$regexp_string_array[1][7] = "#n";
	$regexp_string_array[1][8] = "#s";
	$regexp_string_array[1][9] = "#u";
	$regexp_string_array[1][10] = "#z";

	$regexp_string_array[2][0] = "Â";
	$regexp_string_array[2][1] = "È";
	$regexp_string_array[2][2] = "Ç";
	$regexp_string_array[2][3] = "Ì";
	$regexp_string_array[2][4] = "Î";
	$regexp_string_array[2][5] = "Í";
	$regexp_string_array[2][6] = "Ï";
	$regexp_string_array[2][7] = "Ò";
	$regexp_string_array[2][8] = "Ð";
	$regexp_string_array[2][9] = "Û";
	$regexp_string_array[2][10] = "Þ";

	$regexp_string_array[3][0] = "#A";
	$regexp_string_array[3][1] = "#C";
	$regexp_string_array[3][2] = "#E";
	$regexp_string_array[3][3] = "#G";
	$regexp_string_array[3][4] = "#I";
	$regexp_string_array[3][5] = "#K";
	$regexp_string_array[3][6] = "#L";
	$regexp_string_array[3][7] = "#N";
	$regexp_string_array[3][8] = "#S";
	$regexp_string_array[3][9] = "#U";
	$regexp_string_array[3][10] = "#Z";

	/*Set regexp = $New RegExp;
		regexp.$IgnoreCase = False; /i
		regexp.$Global = True; preg_match_all*/
	$key_max = 10;
	//$key_max = UBound(Regexp_string_array, 2);
	
	for ($key=0; $key<=$key_max; $key++) {
		$pattern = $regexp_string_array[0][$key];		
		$val = str_replace($pattern, $regexp_string_array[1][$key],$val);

		$pattern = $regexp_string_array[2][$key];		
		$val = str_replace($pattern,  $regexp_string_array[3][$key],$val);			
		
		/*regexp.Pattern = Regexp_string_array(0,key)
		val = regexp.Replace(val, Regexp_string_array(1,key))

		regexp.Pattern = Regexp_string_array(2,key)
		val =  regexp.Replace(val, Regexp_string_array(3,key))*/
	}

	return  $val;

}

function Round100($cip) {
	$cip = $cip*100;
	//dim $lastcip;
	$lastcip = ($cip - floor($cip));
	$round100 =floor($cip);
	if ($lastcip >= 0.5) {return  $round100 + 1;}
	return  $round100 / 100;
}

function CalculateSum($pid) {
 
	global $db;
	$query = "EXEC pieteikums_calculate @pid = ?";
	$params = array($pid);
	$db->Query($query,$params);
	

	//--- updeito pieteikuma lauku papildvieta
	if (file_exists("../m_pieteikums.php")){
		
		require_once("../m_pieteikums.php");
	}
	else require_once("m_pieteikums.php");
	$piet = new Pieteikums();
	$piet->UpdatePietPapildv($pid);


	//db.Conn.Execute("update ["&Application("db_tb_pieteikums")&"] set summaLVL=(select sum(vv.cena) as summa from ["&Application("db_tb_pieteikums")&"] p inner join ["&Application("db_tb_piet_saite")&"] ps on ps.pid=p.id inner join ["&Application("db_tb_vietu_veidi")&"] vv on vv.id=ps.vietas_veids where p.id='"&pid&"') where id='"&pid&"';")
}

function BankReplyLogSeb($pGet) {
	global $db;
	//dim $s_get, $ssql;
	//dim $IB_SND_ID,$IB_SERVICE,$IB_VERSION,$IB_PAYMENT_ID,$IB_AMOUNT,$IB_CURR,$IB_REC_ID,$IB_REC_ACC,$IB_REC_NAME;
	//dim $IB_PAYER_ACC,$IB_PAYER_NAME,$IB_PAYMENT_DESC,$IB_PAYMENT_DATE,$IB_PAYMENT_TIME,$IB_CRC,$IB_LANG,$IB_FROM_SERVER;
	//dim $IB_STATUS;
 
	$s_get=$pGet;
 
	$IB_SND_ID = $s_get["IB_SND_ID"];
	$IB_SERVICE = $s_get["IB_SERVICE"];
	$IB_VERSION = $s_get["IB_VERSION"];
	$IB_PAYMENT_ID = $s_get["IB_PAYMENT_ID"];
	$IB_AMOUNT = $s_get["IB_AMOUNT"];
	$IB_CURR = $s_get["IB_CURR"];
	$IB_REC_ID = $s_get["IB_REC_ID"];
	$IB_REC_ACC = $s_get["IB_REC_ACC"];
	$IB_REC_NAME = $s_get["IB_REC_NAME"];
	$IB_PAYER_ACC = $s_get["IB_PAYER_ACC"];
	$IB_PAYER_NAME = $s_get["IB_PAYER_NAME"];
	$IB_PAYMENT_DESC = $s_get["IB_PAYMENT_DESC"];
	$IB_PAYMENT_DATE = $s_get["IB_PAYMENT_DATE"];
	$IB_PAYMENT_TIME = $s_get["IB_PAYMENT_TIME"];
	$IB_CRC = $s_get["IB_CRC"];
	$IB_LANG = $s_get["IB_LANG"];
	$IB_FROM_SERVER = $s_get["IB_FROM_SERVER"];
	
	$IB_STATUS = $s_get["IB_STATUS"];
	 
	//--- log bankas atbildi 
	if ($IB_SERVICE == "0003") { //maksâjuma uzdevuma pieòemðana apstrâdei
 
		/*$ssql = "INSERT INTO trans_in_seb(IB_SND_ID,IB_SERVICE,IB_VERSION,IB_PAYMENT_ID,IB_AMOUNT,IB_CURR,IB_REC_ID,IB_REC_ACC,IB_REC_NAME,IB_PAYER_ACC,IB_PAYER_NAME,IB_PAYMENT_DESC,IB_PAYMENT_DATE,IB_PAYMENT_TIME,IB_CRC,IB_LANG,IB_FROM_SERVER) " + _;
			   "VALUES ('".$IB_SND_ID."','".$IB_SERVICE."','".$IB_VERSION."','".$IB_PAYMENT_ID."','".$IB_AMOUNT."','".$IB_CURR."','".$IB_REC_ID."','".$IB_REC_ACC."','".$IB_REC_NAME."','".$IB_PAYER_ACC."','".$IB_PAYER_NAME."','".$IB_PAYMENT_DESC."','".$IB_PAYMENT_DATE."','".$IB_PAYMENT_TIME."','".$IB_CRC."','".$IB_LANG."','".$IB_FROM_SERVER."') ";
 */
		$values = array('IB_SND_ID' => $IB_SND_ID,
						'IB_SERVICE' => $IB_SERVICE,
						'IB_VERSION' => $IB_VERSION,
						'IB_PAYMENT_ID' => $IB_PAYMENT_ID,
						'IB_AMOUNT' => $IB_AMOUNT,
						'IB_CURR' => $IB_CURR,
						'IB_REC_ID' => $IB_REC_ID,
						'IB_REC_ACC' => $IB_REC_ACC,
						'IB_REC_NAME' => $IB_REC_NAME,
						'IB_PAYER_ACC' => $IB_PAYER_ACC,
						'IB_PAYER_NAME' => $IB_PAYER_NAME,
						'IB_PAYMENT_DESC' => $IB_PAYMENT_DESC,
						'IB_PAYMENT_DATE' => $IB_PAYMENT_DATE,
						'IB_PAYMENT_TIME' => $IB_PAYMENT_TIME,
						'IB_CRC' => $IB_CRC,
						'IB_LANG' => $IB_LANG,
						'IB_FROM_SERVER' => $IB_FROM_SERVER
						);
	} elseif ($IB_SERVICE == "0004"){ //maksâjuma uzdevuma atsaukðana vai izpilde
		/*$ssql = "INSERT INTO trans_in_seb(IB_SND_ID,IB_SERVICE,IB_VERSION,IB_REC_ID,IB_PAYMENT_ID,IB_PAYMENT_DESC,IB_FROM_SERVER,IB_STATUS,IB_CRC,IB_LANG) " + _;
			   "VALUES ('".$IB_SND_ID."','".$IB_SERVICE."','".$IB_VERSION."','".$IB_REC_ID."','".$IB_PAYMENT_ID."','".$IB_PAYMENT_DESC."','".$IB_FROM_SERVER."','".$IB_STATUS."','".$IB_CRC."','".$IB_LANG."') ";
		*/
		$values = array('IB_SND_ID' => $IB_SND_ID,
						'IB_SERVICE' => $IB_SERVICE,
						'IB_VERSION' => $IB_VERSION,
						'IB_REC_ID' => $IB_REC_ID,
						'IB_PAYMENT_ID' => $IB_PAYMENT_ID,
						'IB_PAYMENT_DESC' => $IB_PAYMENT_DESC,
						'IB_FROM_SERVER' => $IB_FROM_SERVER,
						'IB_STATUS' => $IB_STATUS,
						'IB_CRC' => $IB_CRC,
						'IB_LANG' => $IB_LANG						
						);
	} else {
		echo "Nav atbildes";
	}
	
	if (isset($values)) {
		$result = $db->Insert('trans_in_seb', $values);

		return  True;
	} else {
		return  False;
	}
	
 
}

 
 
function SendOrderSeb($pay_data, $p_pamatojums, $p_ord_ids, $rez_id) {

	global $db;
	//$id = $pay_pid; 
	$summa = $pay_data;
	
	//--- izveido tukshu log ierakstu un saglabaa id
	$date = new DateTime();
	$date->setTimezone(new DateTimeZone('Europe/Riga'));	
	$formated_date = $date->format('Y-m-d H:i:s');
	$values = array('datums' => $formated_date,
					'IB_SERVICE' => '');
	$log_res_id = $db->Insert('trans_seb',$values,array('datums'=> $formated_date));
	/*$query = "SELECT MAX(id) as id FROM trans_seb WHERE datums = ?";
	$params = array($formated_date);
	$result = $db->Query($query,$params);*/
	
	//$ssql = "Set Nocount on; INSERT INTO trans_seb(IB_SERVICE) VALUES(''); Select @@IDENTITY as id";
	//$log_res = $db.$Conn.Execute($ssql);
 
 
	$IB_SND_ID = "IMPSELOSIA";
	$IB_SERVICE = "0002";
	$IB_VERSION = "001";
	$IB_AMOUNT = $summa; //<---maksaajuma summa 
	$IB_CURR = "EUR"; // "LVL"
	$IB_NAME = "Impro Ceïojumi";
	$IB_PAYMENT_ID = $p_ord_ids; //rezervacijas id numurs. reference
	// echo "IB_PAYMENT_DESC: $p_pamatojums<br>";
	$IB_PAYMENT_DESC = $p_pamatojums;
 
	//---nepiedalâs elektr. paraksta aprçíinâ
	$IB_CRC = ""; //digitaalais paraksts
	$IB_FEEDBACK = $_SESSION['application']["sebReturnGET"];
	$IB_LANG = "LAT";
 
 //echo "IB_PAYMENT_DESC: $IB_PAYMENT_DESC <br>";
	//--- Formee IB_CRC parakstu ----------------------------------------
 
	$vk_mac_stringlen = strlen($IB_SND_ID);
	if($vk_mac_stringlen <=10 && $vk_mac_stringlen>0){
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_SND_ID;
	} else { 
		echo "IB_SND_ID error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_SERVICE);
	if($vk_mac_stringlen = 4)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_SERVICE;
	} else { 
		echo "IB_SERVICE error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_VERSION);
	if($vk_mac_stringlen = 3)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_VERSION;
	} else { 
		echo "IB_VERSION error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_AMOUNT);
	if($vk_mac_stringlen <=17 && $vk_mac_stringlen>0){
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_AMOUNT;
	} else { 
		echo "IB_AMOUNT error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_CURR);
	if($vk_mac_stringlen = 3)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_CURR;
	} else { 
		echo "IB_CURR error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($IB_NAME);
	if($vk_mac_stringlen <=30 && $vk_mac_stringlen>0)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_NAME;
	} else { 
		echo "IB_NAME error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_PAYMENT_ID);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_PAYMENT_ID;
	} else { 
		echo "IB_PAYMENT_ID error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($IB_PAYMENT_DESC);
	if($vk_mac_stringlen <=100 && $vk_mac_stringlen>0)	{
		$IB_CRC = $IB_CRC.SkaitlaGarums($vk_mac_stringlen).$IB_PAYMENT_DESC;
	} else { 
		echo "IB_PAYMENT_DESC error. Contact administrator!";
		exit();
	}
//  echo "IB_PAYMENT_DESC: $IB_PAYMENT_DESC<br>";
	//--- log bankas pieprasijumu 0002
	$values = array('IB_SND_ID' => $IB_SND_ID,
					'IB_SERVICE' => $IB_SERVICE,
					'IB_VERSION' => $IB_VERSION,
					'IB_AMOUNT' => $IB_AMOUNT,
					'IB_CURR' => $IB_CURR,
					'IB_NAME' => $IB_NAME,
					'IB_PAYMENT_ID' => $IB_PAYMENT_ID,
					'IB_PAYMENT_DESC' => $IB_PAYMENT_DESC,
					'IB_CRC' => $IB_CRC,
					'IB_FEEDBACK' => $IB_FEEDBACK,
					'IB_LANG' => $IB_LANG
					
					);
					//var_dump($values);
				//	exit();
	$log_res = $db->Update('trans_seb',$values,$log_res_id);
	//$ssql = "UPDATE trans_seb SET IB_SND_ID='".$IB_SND_ID."',IB_SERVICE='".$IB_SERVICE."',IB_VERSION='".$IB_VERSION."',
	//IB_AMOUNT='".$IB_AMOUNT."',IB_CURR='".$IB_CURR."',IB_NAME='".$IB_NAME."',IB_PAYMENT_ID='"
	//.$IB_PAYMENT_ID."',IB_PAYMENT_DESC='".$IB_PAYMENT_DESC."',IB_CRC='".$IB_CRC."',IB_FEEDBACK='".$IB_FEEDBACK."'
	//,IB_LANG='".$IB_LANG."' WHERE id=".CStr($log_res["id"]);
 
	//SET $log_res = $db.$Conn.Execute($ssql);
 
 
	//Response.Write("<br>updated ok")
	//response.end
 
	//------------------------------------------------------------------------------
	//sheit postojam datus uz php failu, kas shifree datus ar sha-1 algoritmu, izveido digitaalo parakstu un aizsuuta datus uz banku
 	?>
	<!--html>
	<head>
	  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
	</head>
	<body-->
	
	<form name="php_post" action="bank/post_seb.php" method="post">
		<input type="hidden" name="IB_SND_ID"	maxlength="10"	value="<?=$IB_SND_ID;?>"	>
		<input type="hidden" name="IB_SERVICE"	maxlength="4"	value="<?=$IB_SERVICE;?>"	>
		<input type="hidden" name="IB_VERSION"	maxlength="3"	value="<?=$IB_VERSION;?>"		>
		<input type="hidden" name="IB_AMOUNT"	maxlength="17"	value="<?=$IB_AMOUNT;?>"		>
		<input type="hidden" name="IB_CURR"		maxlength="3"	value="<?=$IB_CURR;?>"		>
		<input type="hidden" name="IB_NAME"		maxlength="30"	value="<?=EncodeLV($IB_NAME);?>"		>
		<input type="hidden" name="IB_PAYMENT_ID"	maxlength="20" value="<?=$IB_PAYMENT_ID;?>">
		<input type="hidden" name="IB_PAYMENT_DESC"	maxlength="100" value="<?=EncodeLV($IB_PAYMENT_DESC);?>">
		<input type="hidden" name="IB_CRC"		maxlength="300"	value="<?=$IB_CRC;?>"		>
		<input type="hidden" name="IB_FEEDBACK"	maxlength="150"	value="<?=$IB_FEEDBACK;?>"		>
		<input type="hidden" name="IB_LANG"		maxlength="3"	value="<?=$IB_LANG;?>"		>
		<input type="hidden" name="rez_id"		value="<?=$rez_id;?>"	>
	</form>
	<script>
	
		document.php_post.submit();
	</script>
	<?
 
	//------------------------------------------------------------------------------
 
 
 
} 

 

//==========================================================
//== DnB NORD ===
//==========================================================
function SendOrderDnbnord($pay_data, $p_pamatojums, $p_ord_ids, $rez_id) {
	global $db;
	//dim $id,  $maksatajs, $summa;
	//dim $vk_mac_stringlen, $vk_mac_string;
	//dim $VK_SERVICE, $VK_VERSION, $VK_SND_ID, $VK_STAMP, $VK_AMOUNT, $VK_CURR, $VK_REF, $VK_MSG, $VK_MAC, $VK_RETURN, $VK_LANG;
	//dim $ssql, $log_res;
 
 
//	$id = $pay_pid; 
	$summa = $pay_data;
	
	//--- izveido tukshu log ierakstu un saglabaa id
	$date = new DateTime();
	$date->setTimezone(new DateTimeZone('Europe/Riga'));	
	$formated_date = $date->format('Y-m-d H:i:s');
	$values = array('datums' => $formated_date,
					'VK_SERVICE' => '');
	$log_res_id = $db->Insert('trans_dnbnord',$values,array('datums' => $formated_date));
	
	//$ssql = "Set Nocount on; INSERT INTO trans_dnbnord(VK_SERVICE) VALUES(''); Select @@IDENTITY as id";
	//SET $log_res = $db.$Conn.Execute($ssql);
 
 
 
	$VK_SERVICE = "1002"; //Pieprasijuma tips, kuru tirgotajs suuta bankai
	$VK_VERSION = "101"; //algoritma tips
	$VK_SND_ID ="10022"; //Tirgotaaja identifikators bankâ
	$VK_STAMP = $log_res_id; //db log ieraksta id, kaa reference
	$VK_AMOUNT = $summa; //maksaajuma summa 
	$VK_CURR = "EUR"; //"LVL"	
	$VK_ACC = "LV76RIKO0002010047384"; //impro bankas konts
	$VK_NAME = "IMPRO CEÏOJUMI"; //nosaukums
	$VK_REG_ID = "40003235627"; //impro reìistracijas numurs																		'valuuta
	$VK_SWIFT = "RIKOLV2X"; //bankas kods
	$VK_REF = $p_ord_ids; //$maks. $transakcijas $id ->; //Maksaajuma uzdevuma references numurs - db jaabuut kolonnai, kas raada, kura peec kaartas ir konkreetaa atbilde no bankas
	$VK_MSG = $p_pamatojums;
	$VK_RETURN = $_SESSION['application']["dnbnordReturnGET"]; //adrese uz kuru suuta status atbildi
	$VK_RETURN2 = $_SESSION['application']["dnbnordReturnGET2"]; //lietotaja redirect adrese
	
	//---nepiedalâs elektr. parakstâ	
	$VK_MAC= ""; //shis mainiigais buus digitaalais paraksts
	$VK_TIME_LIMIT = date("d.m.Y 21:00:00",strtotime("+10 days"));//(DateAdd("d", 10, Date())]+" 21:00:00"); //"17.01.2010 12:00:00"; //datums laiks pec, kura notiek pieprasîjuma anulçðana
	$VK_LANG= "LAT"; //valoda
 
	//response.write "VK_RETURN = "+VK_RETURN
	//response.end
 
	//--- Formee VK_MAC parakstu ----------------------------------------
 
	$vk_mac_stringlen = strlen($VK_SERVICE);
	if($vk_mac_stringlen ==4){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SERVICE;
	} else { 
		echo "VK_SERVICE error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_VERSION);
	if($vk_mac_stringlen ==3){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_VERSION;
	} else { 
		echo "VK_VERSION error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_SND_ID);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SND_ID;
	} else { 
		echo "VK_SND_ID error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_STAMP);
	if($vk_mac_stringlen <=32 && $vk_mac_stringlen>0){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_STAMP;
	} else { 
		echo "VK_STAMP error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_AMOUNT);
	if($vk_mac_stringlen <=13 && $vk_mac_stringlen>0){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_AMOUNT;
	} else { 
		echo "VK_AMOUNT error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_CURR);
	if($vk_mac_stringlen == 3){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_CURR;
	} else { 
		echo "VK_CURR error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_ACC);
	if($vk_mac_stringlen <=21 && $vk_mac_stringlen>0){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_ACC;
	} else { 
		echo "VK_ACC error. Contact administrator!";
		exit();
	}
	
	
	$vk_mac_stringlen = strlen($VK_NAME);
	if($vk_mac_stringlen <=105 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_NAME;
	} else { 
		echo "VK_NAME error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_REG_ID);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_REG_ID;
	} else { 
		echo "VK_REG_ID error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_SWIFT);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SWIFT;
	} else { 
		echo "VK_SWIFT error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_REF);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_REF;
	} else { 
		echo "VK_REF error. Contact administrator!";
		//response.write VK_REF
		exit();
	}
	
	//Response.Write("<br>VK_MSG = "+VK_MSG)
	//Response.Write("<br>VK_MSG = "+EncodeUTF8(VK_MSG))
	//Response.end
	
	$vk_mac_stringlen = strlen($VK_MSG);
	
	if($vk_mac_stringlen <=140 && $vk_mac_stringlen>0){
	
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_MSG;
		
	} else { 
		echo "VK_MSG error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_RETURN);
	if($vk_mac_stringlen <=400 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_RETURN;
	} else { 
			echo "VK_RETURN error. Contact administrator!";
			exit();
	}
	
	$vk_mac_stringlen = strlen($VK_RETURN2);
	if($vk_mac_stringlen <=400 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_RETURN2;
	} else { 
		echo "VK_RETURN2 error. Contact administrator!";
		exit();
	}
 
	//--- log bankas pieprasijumu 1002
	//ssql = "Set Nocount on; INSERT INTO bankas_pieprasijumi(VK_SERVICE,VK_VERSION,VK_SND_ID,VK_STAMP,VK_AMOUNT,VK_CURR,VK_REF,VK_MSG,VK_MAC,VK_RETURN,VK_LANG) VALUES ('"&VK_SERVICE&"','"&VK_VERSION&"','"&VK_SND_ID&"','"&VK_STAMP&"','"&VK_AMOUNT&"','"&VK_CURR&"','"&VK_REF&"','"&VK_MSG&"','"&VK_MAC&"','"&VK_RETURN&"','"&VK_LANG&"'); Select @@IDENTITY as id"
	$values = array('VK_SERVICE' => $VK_SERVICE,
					'VK_VERSION' => $VK_VERSION,
					'VK_SND_ID' => $VK_SND_ID,
					'VK_STAMP' => $VK_STAMP,
					'VK_AMOUNT' => $VK_AMOUNT,
					'VK_CURR' => $VK_CURR,
					'VK_ACC' => $VK_ACC,
					'VK_NAME' => $VK_NAME,
					'VK_REG_ID' => $VK_REG_ID,
					'VK_SWIFT' => $VK_SWIFT,
					'VK_REF' => $VK_REF,
					'VK_MSG' => $VK_MSG,
					'VK_MAC' => $VK_MAC,
					'VK_TIME_LIMIT' => $VK_TIME_LIMIT,
					'VK_RETURN' => $VK_RETURN,
					'VK_RETURN2' => $VK_RETURN2,
					'VK_LANG' => $VK_LANG,
					'php_session_id' => session_id()	//AI
					);
	$log_res = $db->Update("trans_dnbnord",$values,$log_res_id);
	
	
			//."' WHERE id=".CStr($log_res["id"]);

	//$ssql = "UPDATE trans_dnbnord SET VK_SERVICE='".$VK_SERVICE."',VK_VERSION='".$VK_VERSION."',VK_SND_ID='".$VK_SND_ID."',VK_STAMP='".$VK_STAMP."',VK_AMOUNT='".$VK_AMOUNT."',VK_CURR='".$VK_CURR."',VK_ACC='".$VK_ACC."',VK_NAME='".$VK_NAME."',VK_REG_ID='".$VK_REG_ID."',VK_SWIFT='".$VK_SWIFT."',VK_REF='".$VK_REF."',VK_MSG='".$VK_MSG."',VK_MAC='".$VK_MAC."',VK_TIME_LIMIT='".$VK_TIME_LIMIT."',VK_RETURN='".$VK_RETURN."',VK_RETURN2='".$VK_RETURN2."',VK_LANG='".$VK_LANG."' WHERE id=".CStr($log_res["id"]);
 
	//SET $log_res = $db.$Conn.Execute($ssql);
 
 
//Response.Write("<br>updated ok")
//response.end
 
	//------------------------------------------------------------------------------
	//sheit postojam datus uz php failu, kas shifree datus ar sha-1 algoritmu, izveido digitaalo parakstu un aizsuuta datus uz banku
 
 ?>
	<!--html>
	<head>
	  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
	</head>
	<body-->
	<form name="php_post" action="bank/post_dnbnord.php" method="post">
		<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?=$VK_SERVICE?>"	>
		<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?=$VK_VERSION?>"	>
		<input type="hidden" name="VK_SND_ID"	maxlength="20"	value="<?=$VK_SND_ID?>"		>
		<input type="hidden" name="VK_STAMP"	maxlength="32"	value="<?=$VK_STAMP?>"		>
		<input type="hidden" name="VK_AMOUNT"	maxlength="13"	value="<?=$VK_AMOUNT?>"		>
		<input type="hidden" name="VK_CURR"	maxlength="3"	value="<?=$VK_CURR?>"		>
		<input type="hidden" name="VK_ACC"	maxlength="21" value="<?=$VK_ACC?>">
		<input type="hidden" name="VK_NAME"	maxlength="105" value="<?=EncodeLV($VK_NAME)?>">
		<input type="hidden" name="VK_REG_ID" maxlength="20" value="<?=$VK_REG_ID?>">
		<input type="hidden" name="VK_SWIFT" maxlength="20" value="<?=$VK_SWIFT?>">
		<input type="hidden" name="VK_REF"	maxlength="20"	value="<?=$VK_REF?>"		>
		<input type="hidden" name="VK_MSG"	maxlength="140"	value="<?=EncodeLV($VK_MSG)?>"		>
		<input type="hidden" name="VK_MAC"	 maxlength="300"	value="<?=$VK_MAC?>"		>
		<input type="hidden" name="VK_RETURN"	maxlength="400"	value="<?=$VK_RETURN?>"		>
		<input type="hidden" name="VK_RETURN2"	maxlength="400"	value="<?=$VK_RETURN2?>"		>
		<input type="hidden" name="VK_TIME_LIMIT" maxlength="19" value="<?=$VK_TIME_LIMIT?>"		>
		<input type="hidden" name="VK_LANG"	maxlength="3"	value="<?=$VK_LANG?>">
		<!--<input type="hidden" name="rez_id"	value="<?=$rez_id?>"-->	
	</form>
	<script>
	//alert('post');
		document.php_post.submit();
	</script>
	<!--/body>
	</html-->
	<?
 
	//------------------------------------------------------------------------------
 
 
 
} 
//------------------------------------------------------------------------------


//==========================================================
//== SWEDBANK ===
//==========================================================
function SendOrder($pay_data, $p_pamatojums, $p_ord_ids, $rez_id,$test=false) {
	
	global $db;
	//$id = $pay_pid; 
	$summa = $pay_data;
	
	//--- izveido tukshu log ierakstu un saglabaa id
	$date = new DateTime();
	$date->setTimezone(new DateTimeZone('Europe/Riga'));	
	$formated_date = $date->format('Y-m-d H:i:s');
	$values = array('p_datums' => $formated_date,
	                'VK_SERVICE' => '');
	
	//exit('...');
	$log_res_id = $db->Insert('bankas_pieprasijumi',$values,array('p_datums' => $formated_date),true);
	//exit('...');
	
	if (empty($log_res_id)) die("Kïûda. Nav izdevies pieslçgties bankai. Lûdzu, mçìiniet vçlreiz.");
	//$ssql = "Set Nocount on; INSERT INTO bankas_pieprasijumi(VK_SERVICE) VALUES(''); Select @@IDENTITY as id";
	//SET $log_res = $db.$Conn.Execute($ssql);
	
	$VK_SERVICE=	"1002"	;		//$Pieprasijuma $tips, $kuru $tirgotajs $suuta $bankai;
	$VK_VERSION = "008";//$algoritma $tips;
	$VK_SND_ID="IMPRO";	//$Tirgotaaja $identifikators. $sho $veertiibu $janomaina,$kad $taa $buus $zinaama;
	$VK_STAMP = $log_res_id; //log faila id, kaa reference
	$VK_AMOUNT = $summa; //	"0.01"; //		//sii ir maksaajuma summa. Testa versijaa veertiiba ir 1 santiims. Peec tam nomainit uz - summa
	$VK_CURR= "EUR"; //"LVL"																				'valuuta
	$VK_REF = $p_ord_ids; //globas orderu id numuri																	'Maksaajuma uzdevuma references numurs - db jaabuut kolonnai, kas raada, kura peec kaartas ir konkreetaa atbilde no bankas
	$VK_MSG = $p_pamatojums; //"Maksajums par IMPRO celojumu: "&summa&" "&VK_CURR	'maksaajuma uzdevuma detaljas
	$VK_MAC= ""	;	//'$shis $mainiigais $buus $digitaalais $paraksts;
	$VK_RETURN =	$_SESSION['application']["hansabankReturnGET"];  //'."?id=".$p_ord_ids														'$uz $sho $linku $banka $suutiis $atbildi;
	$VK_LANG= "LAT"	;//$valoda;
	
	//response.write VK_REF
	//response.end
	
	//--- Formee VK_MAC parakstu ----------------------------------------

	$vk_mac_stringlen = strlen($VK_SERVICE);
	if($vk_mac_stringlen == 4 ){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SERVICE;
	} else { 
		echo "VK_SERVICE error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_VERSION);
	if($vk_mac_stringlen == 3){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_VERSION;
	} else { 
		echo "VK_VERSION error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_SND_ID);
	if($vk_mac_stringlen <=10 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_SND_ID;
	} else { 
		echo "VK_SND_ID error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_STAMP);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
	$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_STAMP;
	} else { 
		echo "VK_STAMP error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_AMOUNT);
	if($vk_mac_stringlen <=17 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_AMOUNT;
	} else { 
		echo "VK_AMOUNT error. Contact administrator!";
		exit();
	}
	
	$vk_mac_stringlen = strlen($VK_CURR);
	if($vk_mac_stringlen == 3){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_CURR;
	} else { 
		echo "VK_CURR error. Contact administrator!";
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_REF);
	if($vk_mac_stringlen <=20 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_REF;
	} else { 
		echo "VK_REF error. Contact administrator!";
		//response.write VK_REF
		exit();
	}
 
	$vk_mac_stringlen = strlen($VK_MSG);
	if($vk_mac_stringlen <=70 && $vk_mac_stringlen>0){
		$VK_MAC = $VK_MAC.SkaitlaGarums($vk_mac_stringlen).$VK_MSG;
	} else { 
		echo "VK_MSG error. Contact administrator!";
		exit();
	}
 
	
 
 
	//--- log bankas pieprasijumu 1002
	//ssql = "Set Nocount on; INSERT INTO bankas_pieprasijumi(VK_SERVICE,VK_VERSION,VK_SND_ID,VK_STAMP,VK_AMOUNT,VK_CURR,VK_REF,VK_MSG,VK_MAC,VK_RETURN,VK_LANG) VALUES ('"&VK_SERVICE&"','"&VK_VERSION&"','"&VK_SND_ID&"','"&VK_STAMP&"','"&VK_AMOUNT&"','"&VK_CURR&"','"&VK_REF&"','"&VK_MSG&"','"&VK_MAC&"','"&VK_RETURN&"','"&VK_LANG&"'); Select @@IDENTITY as id"
	$values = array('VK_SERVICE' => $VK_SERVICE,
					'VK_VERSION' => $VK_VERSION,
					'VK_SND_ID' => $VK_SND_ID,
					'VK_STAMP' => $VK_STAMP,
					'VK_AMOUNT' => $VK_AMOUNT,
					'VK_CURR' => $VK_CURR,
					'VK_REF' => $VK_REF,
					'VK_MSG' => $VK_MSG,
					'VK_MAC' => $VK_MAC,
					'VK_RETURN' => $VK_RETURN,
					'VK_LANG' => $VK_LANG
					);
	
	if ($test){
		//var_dump($values);
		
	}
	$log_res = $db->Update("bankas_pieprasijumi",$values,$log_res_id,true);

 
	//------------------------------------------------------------------------------
	//sheit postojam datus uz php failu, kas shifree datus ar sha-1 algoritmu, izveido digitaalo parakstu un aizsuuta datus uz Hansabanku
 ?>
	<form name="hbpost" action="bank/hbpost.php" method="post">
		<input type="hidden" name="VK_SERVICE"	maxlength="4"	value="<?=$VK_SERVICE?>"	>
		<input type="hidden" name="VK_VERSION"	maxlength="3"	value="<?=$VK_VERSION?>"	>
		<input type="hidden" name="VK_SND_ID"	maxlength="10"	value="<?=$VK_SND_ID?>"		>
		<input type="hidden" name="VK_STAMP"	maxlength="20"	value="<?=$VK_STAMP?>"		>
		<input type="hidden" name="VK_AMOUNT"	maxlength="17"	value="<?=$VK_AMOUNT?>"		>
		<input type="hidden" name="VK_CURR"	maxlength="3"	value="<?=$VK_CURR?>"		>
		<input type="hidden" name="VK_REF"	maxlength="20"	value="<?=$VK_REF?>"		>
		<input type="hidden" name="VK_MSG"	maxlength="70"	value="<?=EncodeLV($VK_MSG)?>"		>
		<input type="hidden" name="VK_MAC"	 maxlength="300"	value="<?=EncodeLV($VK_MAC)?>"		>
		<input type="hidden" name="VK_RETURN"	maxlength="65"	value="<?=$VK_RETURN?>"		>
		<input type="hidden" name="VK_LANG"	maxlength="3"	value="<?=$VK_LANG?>"		>
		<input type="hidden" name="rez_id"	value="<?=$rez_id?>"		>
	</form>
	<script>
		document.hbpost.submit();
	</script>
	<?
 
	//------------------------------------------------------------------------------
 
 
 
} 
//------------------------------------------------------------------------------

 

//==========================================================
//== CITADELE Banka ===
//==========================================================
function SendOrderCitadele( $pay_data, $p_pamatojums, $p_ord_ids, $rez_id) {
 
	
	
	//Dim IB_SND_ID,IB_SERVICE,IB_VERSION,IB_AMOUNT,IB_CURR,IB_NAME,IB_PAYMENT_ID,IB_PAYMENT_DESC,IB_CRC,IB_FEEDBACK,IB_LANG
	
	//Response.Write("send_order_citadele<br>")
	//Response.Write("->"&pay_pid&", "&pay_data&", "&p_pamatojums&", "&p_ord_ids&", "&rez_id&", ")
	//Response.end
	
	//->, 230, Impro online rezervcija. Adventes laiks Bav... (rez_id=4424), 53_4424, 4424, 
	
	$summa = $pay_data;
		
	$descr = EncodeLV($p_pamatojums);

	//--- izveido tukshu log ierakstu un saglabaa id
	//ssql = "Set Nocount on; INSERT INTO trans_citadele(IB_SERVICE) VALUES(''); Select @@IDENTITY as id"
	//SET log_res = db.Conn.Execute(ssql)
 
	//--- log bankas pieprasijumu 0002
	//ssql = "UPDATE trans_seb SET IB_SND_ID='"&IB_SND_ID&"',IB_SERVICE='"&IB_SERVICE&"',IB_VERSION='"&IB_VERSION&"',IB_AMOUNT='"&IB_AMOUNT&"',IB_CURR='"&IB_CURR&"',IB_NAME='"&IB_NAME&"',IB_PAYMENT_ID='"&IB_PAYMENT_ID&"',IB_PAYMENT_DESC='"&IB_PAYMENT_DESC&"',IB_CRC='"&IB_CRC&"',IB_FEEDBACK='"&IB_FEEDBACK&"',IB_LANG='"&IB_LANG&"' WHERE id="&CStr(log_res("id"))
 
	//SET log_res = db.Conn.Execute(ssql)
 
	//------------------------------------------------------------------------------
	//sheit postojam datus uz php failu, kas shifree datus ar sha-1 algoritmu, izveido digitaalo parakstu un aizsuuta datus uz banku

	//exit();
	?>
	<!--html>
	<head>
	  <meta http-equiv="Content-type" value="text/html; charset=utf-8">
	</head>
	<body-->
	
	<form name="php_post" action="bank/post_citadele.php" method="post">
		<input type="hidden" name="rez_id" value="<?=$rez_id?>"	>
		<input type="hidden" name="summa" value="<?=$summa?>"	>
		<input type="hidden" name="descr" value="<?=$descr?>"	>
		<input type="hidden" name="trans_uid" value="<?=$p_ord_ids?>"	>
	</form>
	<script>
		document.php_post.submit();
	</script>
	<!--/body>
	</html-->
	<?
 
 
} 


function SkaitlaGarums($garums) {
 
		Switch (strlen($garums)){
			Case 0;
				return  "000";
			Case 1;
				return  "00".$garums;
			Case 2;
				return  "0".$garums;
			Case 3;
				return  $garums;
		}
 
	}
//------------------------------------------------------------------------------

 


	//===========================================================
function EncodeLV($s) {
	 
	 $enlett = "âèçìîíïòðûþôÂÈÇÌÎÍÏÒÐÛÞÔ";
	 $encodeLV = '';
	 for ($u=0; $u<strlen($s); $u++) {;
	  $z = substr($s,$u,1);
	  if (stripos($enlett,$z) != false) { $encodeLV .= "#";}
	  if ($z == "â") {$z = "a";}
	  if ($z == "è") {$z = "c";}
	  if ($z == "ç") {$z = "e";}
	  if ($z == "ì") {$z = "g";}
	  if ($z == "î") {$z = "i";}
	  if ($z == "í") {$z = "k";}
	  if ($z == "ï") {$z = "l";}
	  if ($z == "ò") {$z = "n";}
	  if ($z == "ð") {$z = "s";}
	  if ($z == "û") {$z = "u";}
	  if ($z == "þ") {$z = "z";}
	  if ($z == "Â") {$z = "A";}
	  if ($z == "È") {$z = "C";}
	  if ($z == "Ç") {$z = "E";}
	  if ($z == "Ì") {$z = "G";}
	  if ($z == "Î") {$z = "I";}
	  if ($z == "Í") {$z = "K";}
	  if ($z == "Ï") {$z = "L";}
	  if ($z == "Ò") {$z = "N";}
	  if ($z == "Ð") {$z = "S";}
	  if ($z == "Û") {$z = "U";}
	  if ($z == "Þ") {$z = "Z";}
	  if ($z == "Ô") {$z = "O";}
	  if ($z == "ô") {$z = "o";}
	  if ($z == "=") {$z = "_";} //--- specialais simbols, kuru banka nenjem
	  
	  $encodeLV .= $z;
	 }
	 return  $encodeLV;
}


/*function TwoD($val) {
 
	if (floor($val)>0 && floor($val)<10) {
		$return  "0".$val;
	} else { 
		return  $val;
	}
	
	
}
function DatePrint2($d_p) {
		
		if (!empty($d_p) && $d_p!=NULL) {
			return  $TwoD($d_p->format('d'))."/".TwoD($d_p->format("m"))."/".$d_p->format("Y");
		} else {
			return  "&nbsp;";
		}
		
	}
	*/

function DebugLog($p_key, $p_val) {	
	LogPost(array($p_key => $p_val),777);
	/*global $db;
	$values = array('session_id' => '777',
					'[key]' => $p_key,
					'value' => $p_val
					);
	$db->Insert('session_variables',$values); */
}

function LogPost($vars = array(),$session_id = 0) { ///not secure!!!!
	global $db;
	
	if (!is_array($vars))
		$vars = array();
	if (is_array($vars)&&(count($vars)>0)) {
		//$query = "";
	
		foreach ($vars as $key => $value) {
			$values = array('session_id' => $session_id,
							"[key]" => ''.$key,
							'value' => ''.$value,
							'laiks' => date("Y-m-d H:i:s"));
	
			$res = $db->Insert('session_variables',$values);
			//$query .= "INSERT INTO [globa].[dbo].[session_variables] ([session_id], [key], [value]) VALUES ($session_id, '$key', '$value');";
		}
		//$res = $db->Query($query);
		//return $res;
		//die("log_post query = ".$query);
	//} else{
		//die("log_post empty");
	}else if(count($vars)==1){

		$values = array('session_id' => $session_id,
						'[key]' => 'log_post value',
						'value' => $vars);
		$res = $db->Insert('session_variables',$values);
		//$query = "INSERT INTO [globa].[dbo].[session_variables] ([session_id], [key], [value]) VALUES ($session_id, 'log_post value', '$vars');";
		//$res = mssql_query($query);
	}
	//return $hash_result;
}

function LogDnbnordStatus($vars = array()){
	global $db;
	if ($vars) {

		foreach ($vars as $key => $value) {
			$$key = $value; 
		}

		//--- log bankas atbildi 
		if ($VK_SERVICE == "1102") {

			
			$query = "INSERT INTO trans_in_dnbnord(VK_SERVICE,VK_VERSION,VK_SND_ID,VK_REC_ID,VK_STAMP,VK_T_NO,VK_AMOUNT,VK_CURR,VK_REC_ACC,VK_REC_NAME,VK_REC_REG_ID,VK_REC_SWIFT,VK_SND_ACC,VK_SND_NAME,VK_REF,VK_MSG,VK_T_DATE,VK_T_STATUS,VK_MAC,VK_LANG,status) VALUES ('$VK_SERVICE','$VK_VERSION','$VK_SND_ID','$VK_REC_ID','$VK_STAMP','$VK_T_NO','$VK_AMOUNT','$VK_CURR','$VK_REC_ACC','$VK_REC_NAME','$VK_REC_REG_ID','$VK_REC_SWIFT','$VK_SND_ACC','$VK_SND_NAME','$VK_REF','$VK_MSG','$VK_T_DATE','$VK_T_STATUS','$VK_MAC','$VK_LANG',1) ";
			$res = $db->Query($query);
			//$res = mssql_query($query);
			
			return true;

		}
		
	}
	return false;
}


function LogSebStatus($vars = array()){
	global $db;
	if ($vars) {

		foreach ($vars as $key => $value) {
			$$key = $value; 
		}

		//--- log bankas atbildi 
		if ($IB_SERVICE == "0003") { //maksâjuma uzdevuma pieòemðana apstrâdei
			
			$query = "INSERT INTO trans_in_seb(IB_SND_ID,IB_SERVICE,IB_VERSION,IB_PAYMENT_ID,IB_AMOUNT,IB_CURR,IB_REC_ID,IB_REC_ACC,IB_REC_NAME,IB_PAYER_ACC,IB_PAYER_NAME,IB_PAYMENT_DESC,IB_PAYMENT_DATE,IB_PAYMENT_TIME,IB_CRC,IB_LANG,IB_FROM_SERVER) VALUES ('$IB_SND_ID','$IB_SERVICE','$IB_VERSION','$IB_PAYMENT_ID','$IB_AMOUNT','$IB_CURR','$IB_REC_ID','$IB_REC_ACC','$IB_REC_NAME','$IB_PAYER_ACC','$IB_PAYER_NAME','$IB_PAYMENT_DESC','$IB_PAYMENT_DATE','$IB_PAYMENT_TIME','$IB_CRC','$IB_LANG','$IB_FROM_SERVER')";
			$res = $db->Query($query);
			//$res = mssql_query($query);
			
			return true;


		}else if($IB_SERVICE == "0004"){

			$query = "INSERT INTO trans_in_seb(IB_SND_ID,IB_SERVICE,IB_VERSION,IB_REC_ID,IB_PAYMENT_ID,IB_PAYMENT_DESC,IB_FROM_SERVER,IB_STATUS,IB_CRC,IB_LANG) VALUES ('$IB_SND_ID','$IB_SERVICE','$IB_VERSION','$IB_REC_ID','$IB_PAYMENT_ID','$IB_PAYMENT_DESC','$IB_FROM_SERVER','$IB_STATUS','$IB_CRC','$IB_LANG') ";
			$res = $db->Query($query);
			//$res = mssql_query($query);
			
			return true;

		}
		
	}
	return false;
}

Function getOrdNum() {
	global $db;
	
	$ssql = "EXEC get_order_num";
			
	$params = array();
	$res = $db->Query($ssql,$params);
	
	
	if ($r = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){

		return $r['x'];

	}
	Else {
		return 0;
	}

}


	function connectPage($curl, $method = "get", $data = array(), $file_data = array()){
		  require_once("../m_user_tracking.php");
		$u_track = new UserTracking();
		  $ret = "";
		  switch  ($method) {
			 case "get":
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, $curl);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
				curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
				curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
				curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3000);
				$ret = curl_exec ($ch);
			
				$text = "<b>Maksâðana caur banku - kïûda</b>:<br>";
				$text .= curl_error($ch)."<br>";	
				$u_track->Save($text);
				//echo ."<br>";
				curl_close ($ch);
				break;
			 case "post":
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, $curl);
				curl_setopt($ch, CURLOPT_HEADER, 0);             
				curl_setopt($ch, CURLOPT_POST, true);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER , 1);
				curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
				curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
				curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
				curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3000);
				$ret = curl_exec ($ch);
				curl_close ($ch);
				break;
		  }
		  
		  return $ret;
	}
	
	//atgrieþ maksâjuma kopsummu
	function GetSumma($rez_id,$trans_id){
		global $db;
		$qry = "select SUM(t.summa ) as summa,
			 isnull(g.valuta,'LVL') as gvaluta from pieteikums p /*inner join profili pp on pp.id = p.profile_id */inner join dalibn d on d.id = p.did inner join grupa g on g.id = p.gid inner join marsruts m on g.mid = m.id inner join trans_uid t on t.pid = p.id where p.deleted=0 and p.tmp=0 and p.atcelts=0 
			and p.online_rez=? and t.trans_id like '%$trans_id'  group by g.valuta";
		$params = array($rez_id);
		$res = $db->Query($qry,$params);
		if ($r = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC)){
			$summa = round($r['summa'],2)." ".$r['gvaluta'];
			//echo $summa;
			return $summa;
		}
		
		
	}
	//saglabâ informâciju par maksâjuma apstrâdi atkïûdoðanai
	function Log2File($text,$from_funcion = ""){
		global $uniq_id;
		
		$path = "E:\\globa\\wwwroot\\online2\\bank\\log\\";
		$file = "get".date("Y-m-d").".txt";
		/*if (file_exists("log\get".date("Y-m").".txt")){
			$filename = "log\get".date("Y-m").".txt";
		}
		elseif (file_exists("bank\log\get".date("Y-m").".txt")){
			$filename = "bank\log\get".date("Y-m").".txt";
		}
		else{
			$filename = "log\get".date("Y-m").".txt";
		}*/
		$filename = $path.$file;
		$output = date("Y-m-d H:i:s")." || ".$uniq_id." || ".$from_funcion." || ".$text."\r\n\r\n";
		file_put_contents($filename,$output,FILE_APPEND);
	}
	
	/*if (isset($_GET['test'])){
		require_once('../m_init.php');

		$db = new Db;
		GetSumma(30498,'24A207FF-A928-');
	}*/
	function Upper($s)
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
?>