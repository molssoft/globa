<?
class Ligumi {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;
	
	}
	
	function GetId($id){
		$query = "SELECT * FROM ligumi WHERE ID=?
					AND deleted=0";
		//echo "$query <br>";
		$params = array($id);
		//var_dump($params);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	//atgriež līgumu pēc rezervācijas ID
	function GetRezId($rez_id){
		$query = "SELECT * FROM ligumi WHERE rez_id=? AND deleted=0";
		//echo "$query <br>";
		$params = array($rez_id);
		//var_dump($params);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	function Insert($data,$online_rez){
		$ligums_id= $this->db->Insert('ligumi',$data,array('rez_id' => $online_rez));
		/*
		mssql_query("update pieteikums set ligums_id='".$ligums_id."' where id in (".$_POST['pids'].")");
		*/
		$values = array('ligums_id' => $ligums_id);
		$this->db->Update('online_rez',$values,$online_rez);
		$where_arr = array ('online_rez' => $online_rez);
		$this->db->UpdateWhere('pieteikums',$values, $where_arr);
		
		return $ligums_id;
	}
	
	function Exists($pid_array){
		$pid_list = implode(",",$pid_array);
		$query = "select id,gid,ligums_id from pieteikums where id in (".$pid_list.")";
		//$params = array($);
		$result = $this->db->Query($query);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
		
	}
	//atgriež līguma ID pēc online_rez
	function GetIDByOnlineRez($online_rez){
		$query = "select p.gid,r.ligums_id from online_rez r LEFT JOIN pieteikums p on p.online_rez = r.id
				where r.id=? GROUP BY p.gid, r.ligums_id";
			
		$params = array($online_rez);
			if (DEBUG){
					echo $qry;
					var_dump($params);
				}
		$result = $this->db->Query($query,$params);
				
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$ligums_id = $row['ligums_id'];
			$ligums = $this->GetId($ligums_id);
			if (!empty ($ligums)){
				return $row;
			}
			else{
				return 0;
			}
			
		}		
	}
	//atgriež līgumu pēc online_rez ID
	function GetOnlineRez($online_rez){
		
		$query = "select p.gid,r.ligums_id from online_rez r LEFT JOIN pieteikums p on p.online_rez = r.id
				where r.id=? GROUP BY p.gid, r.ligums_id";
			
		$params = array($online_rez);
		if (DEBUG){
				echo $qry;
				var_dump($params);
			}
		$result = $this->db->Query($query,$params);
				
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$ligums_id = $row['ligums_id'];
			$ligums = $this->GetId($ligums_id);
			
			if (!empty ($ligums)){
				return $row;
			}
			else{
				return 0;
			}
			
		}		
		
	}
	
	//atgriež vai ir apstiprināts līgums pēc online rezervācijas ID
	
	
	function IsAccepted($rez_id) { //--- vai ir apstiprinats ligums
		
		//--- apstiprinats ir, ja online_rez tabulaa ir liguma id un liguma ierakstam ir accepted = 1

		//dim $query, $result; 
		$query = "select * from online_rez r 
					inner join ligumi l 
						on l.id = r.ligums_id 
					where r.deleted = 0 
					and l.deleted = 0 
					and r.id = ?
					AND l.accepted = 1";
		//echo $query."<br>";
		$params = array($rez_id);
		/*var_dump($params);
		echo "<br><br>";*/
		$result = $this->db->Query($query,$params);
	
		//Set $result = $db.$Conn.Execute($query);
		//var_dump($result);
		$row= sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
//		var_dump($row);
		//echo "<br><br>";
		//var_dump(!sqlsrv_has_rows($result));
		//echo "<br><br>";
		if (sqlsrv_has_rows($result)) {
			//echo "Ir apstiprināts līgums<br>";
			return  1;
		} else {
			//echo "Nav apstiprinats līgums <br>";
			return  0;
		}
	}
	
	function getAcceptedOnlineRez($online_rez){
		return $this->IsAccepted($online_rez);
		//exit();
		/*$ligums_id = $this->GetOnlineRez($online_rez);		
	
		if (!empty($ligums_id['ligums_id'])){			
			
			$ligums = $this->GetId($ligums_id['ligums_id']);
			//echo "Līgums:<br>";
			//var_dump($ligums);
			//echo "<br><br>";
			return $ligums['accepted'];
		}
		else return FALSE;
		*/
			
	}

	function Accept($rez_id="") {
		
		// ieliek atziimi, ka ligumam piekritis + ieraksta liguma id rezervacijas tabulā.
		
		//dim $query, $result, $l_id;
		
		//Response.Write("<br>"&rez_id)
		
		if ($rez_id == "") {
			return  false;
		}
		
		$query = "SELECT id FROM ligumi WHERE accepted = 0 AND deleted = 0 AND rez_id=?";
		
		$params = array($rez_id);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$res = $this->db->Query($query,$params);
		//Set $result = $db.$Conn.Execute($query);
		
		if (!sqlsrv_has_rows($res)) {	
			if (DEBUG) echo "nav";
			return  false;
		}
		$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
		$l_id = $result["id"];
		
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));	
		$formated_date = $date->format('Y-m-d H:i:s');
		$values = array('accepted' => 1,
						'accepted_date' => $formated_date);
		$where_arr = array('deleted' => 0,
							'id' => $l_id);
		$this->db->UpdateWhere("ligumi",$values,$where_arr);
		$values = array('ligums_id' => $l_id);
		$where_arr = array('deleted' => 0,
							'id' => $rez_id);
		$this->db->UpdateWhere("online_rez",$values,$where_arr);
		
		
		return  true;

	}
	
	//saglabā pirmā maksājuma datumu pie līguma
	function AcceptWithPayment($rez_id=""){
	
		
		// ieliek atziimi, ka ligumam piekritis + ieraksta liguma id rezervacijas tabulā.
		
		//dim $query, $result, $l_id;
		
		//Response.Write("<br>"&rez_id)
		
		if ($rez_id == "") {
			return  false;
		}
		
		$query = "SELECT id FROM ligumi WHERE accepted = 0 AND deleted = 0 AND rez_id=?";
		
		$params = array($rez_id);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$res = $this->db->Query($query,$params);
		//Set $result = $db.$Conn.Execute($query);
		
		if (!sqlsrv_has_rows($res)) {	
			if (DEBUG) echo "nav";
			return  false;
		}
		$result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);
		$l_id = $result["id"];
		
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));	
		$formated_date = $date->format('Y-m-d H:i:s');
		$values = array('payment' => 1,
						'payment_date' => $formated_date);
		$where_arr = array('deleted' => 0,
							'id' => $l_id);
		$this->db->UpdateWhere("ligumi",$values,$where_arr);
		/*$values = array('ligums_id' => $l_id);
		$where_arr = array('deleted' => 0,
							'id' => $rez_id);
		$this->db->UpdateWhere("online_rez",$values,$where_arr);
		
		*/
		return  true;

	
	}
	
	function IsAcceptedWithPayment($rez_id) { //--- vai ir saņemts puirmais maksajums un saglabaats pie liiguma
		
		//--- apstiprinats ir, ja online_rez tabulaa ir liguma id un liguma ierakstam ir accepted =1 un payment = 1

		//dim $query, $result; 
		$query = "select * from online_rez r 
					inner join ligumi l 
						on l.id = r.ligums_id 
					where r.deleted = 0 
					and l.deleted = 0 
					and r.id = ?
					AND l.accepted = 1
					AND l.payment = 1";
		//echo $query."<br>";
		$params = array($rez_id);
		/*var_dump($params);
		echo "<br><br>";*/
		$result = $this->db->Query($query,$params);
	
		//Set $result = $db.$Conn.Execute($query);
		//var_dump($result);
		$row= sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
//		var_dump($row);
		//echo "<br><br>";
		//var_dump(!sqlsrv_has_rows($result));
		//echo "<br><br>";
		if (sqlsrv_has_rows($result)) {
			//echo "Ir apstiprināts līgums<br>";
			return  1;
		} else {
			//echo "Nav apstiprinats līgums <br>";
			return  0;
		}
	}
	
	
	//atgriež papildus pakalpojumus pēc līguma id
	function GetPakalpId($id){
		$qry = "select 
			count(*) as c, sum(piet_saite.summaEUR) as s,nosaukums, kvietas_veids
				from piet_saite 
					inner join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id 
					inner join pieteikums on piet_saite.pid = pieteikums.id
			where 
				ligums_id = ?
				and piet_saite.deleted = 0
				and pieteikums.deleted = 0
				and not tips in ('CH1','C','G','P')
			group by nosaukums,kvietas_veids";
			$params = array($id);
			$result = $this->db->Query($qry,$params);
			$pakalpojumi = array();
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$pakalpojumi[] = $row;
			}
			return $pakalpojumi;
			
	}
	//atgriež ligumus pec sagatavota vaicājuma
	function GetWhere($qry){
		$result = $this->db->Query($qry);
		$ligumi = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$ligums = $row;
			//atrod atbi;lstošo grupu
			//,g.id as gid,g.kods,g.sakuma_dat,g.beigu_dat,m.v
			//p.agents_izv,p.tmp,p.internets, isnull(p.online_rez,0) as online_rez
			//atrod pieteikumus, kas attiecas uz šo līgumu
			$qry = "SELECT g.id as gid,p.datums,g.kods,g.sakuma_dat,g.beigu_dat,m.v,p.agents_izv,p.tmp,p.internets, isnull(p.online_rez,0) as online_rez, d.id as did, d.vards,d.uzvards,p.id as pid 
				FROM pieteikums p 
				LEFT JOIN dalibn d ON d.id=p.did 
				LEFT JOIN grupa g ON g.id=p.gid
				LEFT JOIN marsruts m ON m.id=g.mID
				WHERE p.deleted=0 AND p.ligums_id=?";
			
			$params = array($row['lid']);
			//echo $qry."<br>";
			//var_dump($params);
			$res = $this->db->Query($qry,$params);
			$ligums['dalibn_vardi'] = '' ;
			$ligums['pieteikumi'] = '';
			while( $row1 = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ) {
				$ligums['gid'] = $row1['gid'];
				$ligums['kods'] = $row1['kods'];
				$ligums['sakuma_dat'] = $row1['sakuma_dat'];
				$ligums['v'] = $row1['v'];
				$ligums['agents_izv'] = $row1['agents_izv'];
				$ligums['tmp'] = $row1['tmp'];
				$ligums['online_rez'] = $row1['online_rez'];
				if (empty($row1['did'])){
					$qry = "SELECT DISTINCT did,d.vards,d.uzvards FROM piet_saite ps, dalibn d WHERE ps.did=d.id AND ps.pid=? AND ps.deleted=0";
					
					$params = array($row1['pid']);
					//echo $qry."<br>";
					//var_dump($params);
					$res2 = $this->db->Query($qry,$params);
					while( $row2 = sqlsrv_fetch_array( $res2, SQLSRV_FETCH_ASSOC) ) {
						$row1['did'] = $row2['did'];
						$row1['vards'] = $row2['vards'];
						$row1['uzvards'] = $row2['uzvards'];
					}
				}
				//print_r($row1);
				
				//echo "<br><br>";
				$ligums['dalibn_vardi'] .= "<a href='dalibn.asp?i=".$row1['did']."' target='dalibnieks'>".$row1['vards'].' '.$row1['uzvards']."</a><br>";
				$ligums['pieteikumi'] .= " <a href='pieteikums.asp?pid=".$row1['pid']."' target='pieteikums'>".$this->db->Date2Str($row1['datums']).";ID#".$row1['pid']."</a><br>";
			}
			$ligumi[] = $ligums;
			
		}
		return $ligumi;
	}
	
}
?>