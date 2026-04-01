<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_grupa.php");

$db = new Db;
$grupa = new Grupa;
if (isset($_POST['parbaudita'])){
	$kas = $_POST['parbaudita'];
	$ligums_id = (int)$_POST['ligums_id'];
	if ($kas == 'viesnica'){
		$qry = "UPDATE ligumi SET parbauditas_viesnicas=1 WHERE id=?";
	
	}
	elseif($kas == 'kajite'){
		$qry = "UPDATE ligumi SET parbauditas_kajites=1 WHERE id=?";
		
	}
	$params = array($ligums_id);
	//echo $qry;
	//var_dump($params);
	$db->Query($qry,$params);
}
$data = array();
$data['viesnicas'] = GetViesnicas();
$data['kajites'] = GetKajites();

require_once("v_parbaudit_online_viesnicas_kajites.php");

function GetViesnicas(){
	global $db;
	global $grupa;
	$viesnicas = array();
	$qry = " select * from (
		select count(p.id) as dalibn_skaits,online_rez ,g.id as gid,p.ligums_id,p.agents,l.parbauditas_viesnicas as parbauditas
		from pieteikums p
		left join grupa g on p.gid=g.id
		left join marsruts m on g.mid=m.id
		LEFT JOIN ligumi l on p.ligums_id=l.id
		where p.deleted=0 and p.ligums_id<>0 and 
		p.ligums_id IN (select id from ligumi where accepted=1) and
		p.gid in (select id from grupa where sakuma_dat>getdate() and p.gid in (select gid from viesnicas))
		group by p.ligums_id,g.id,m.v,g.sakuma_dat,g.beigu_dat,l.parbauditas_viesnicas,p.online_rez,p.agents
		
	)
	t
	where t.dalibn_skaits=2";
	/*$only_online_qry = "select * from (
		select count(pieteikums.id) as dalibn_skaits,online_rez ,g.id as gid,rez.parbauditas_viesnicas
		from pieteikums 
		left join grupa g on pieteikums.gid=g.id
		left join marsruts m on g.mid=m.id
		LEFT JOIN online_rez rez ON pieteikums.online_rez = rez.id
		where pieteikums.deleted=0 and online_rez<>0 and 
		gid in (select id from grupa where sakuma_dat>getdate() and gid in (select gid from viesnicas))
		group by online_rez,g.id,m.v,g.sakuma_dat,g.beigu_dat,rez.parbauditas_viesnicas
		
	)
	t
	where t.dalibn_skaits=2";*/
	$result = $db->Query($qry);

	while ($row = sqlsrv_fetch_array($result)) {

	  //  echo "row:<br>"; var_dump($row); echo "<br><br>";
		$ligums_id = $row['ligums_id'];
		$gr = $grupa->GetCelojumaNosId($row['gid']);
		//$sakuma_dat = $db->Date2Str($row['sakuma_dat']);
		//$beigu_dat = $db->Date2Str($row['beigu_dat']);
		$qry = "SELECT * FROM piet_saite where deleted=0 and vid is not null and pid in (select id from pieteikums where ligums_id=?)";
		$params = array($ligums_id);
		$res = $db->Query($qry,$params);
		$prev_vid = 0;
		$pid_arr = array();
		while ($r = sqlsrv_fetch_array($res)) {
			//echo "vid:".$r['vid']."</br>";
			$pid_arr[] = $r['pid'];
			if ($prev_vid!=0){
				if ($prev_vid!=$r['vid']){
					$row = array('online_rez'=>$row['online_rez'],
								'grupa_nosaukums'=>$gr,
								'pid_arr' => $pid_arr,
								'parbauditas'=>$row['parbauditas'],
								'ligums_id'=>$row['ligums_id'],
								'agents'=>$row['agents']
									);
					$viesnicas[] = $row;
					//echo "<b>DAÞÂDAS <u>ISTABIÒAS</u> rezervâcijai <a href='http://globa/online_rez_2.asp?rez_id=$rez'>#$rez</a> $gid $sakuma_dat-$beigu_dat: ";
					/*foreach($pid_arr as $pid){
						echo " pieteikums #<a href='//globa/pieteikums.asp?pid=".$pid."'>".$pid."</a>";
					}
					echo "<br>";*/
				}
				
			}
			$prev_vid = $r['vid'];
			
		}
		//echo "_______________________________<br>";
	}
	return $viesnicas;
}
function GetKajites(){
	global $db;
	global $grupa;
	require_once("online2/m_kajite.php");
	$m_kajite = new Kajite;

	$viesnicas = array();
	$result = $db->Query(" select * from (
		select count(p.id) as dalibn_skaits,online_rez ,g.id as gid,l.parbauditas_kajites as parbauditas,p.ligums_id
		from pieteikums p
		left join grupa g on p.gid=g.id
		left join marsruts m on g.mid=m.id
		LEFT JOIN ligumi l on p.ligums_id=l.id
		where p.deleted=0 and p.ligums_id<>0 and 
		p.ligums_id IN (select id from ligumi where accepted=1) and
		p.gid in (select id from grupa where sakuma_dat>getdate() and p.gid in (select gid from kajite))
		group by p.ligums_id,online_rez,g.id,m.v,g.sakuma_dat,g.beigu_dat,l.parbauditas_kajites
	)
	t
	where t.dalibn_skaits>1");

	while ($row = sqlsrv_fetch_array($result)) {
		$ligums_id = $row['ligums_id'];
	
		$kid_arr = $m_kajite->GetKidLigumsId($ligums_id);
		if (count($kid_arr)>1){
			$gr = $grupa->GetCelojumaNosId($row['gid']);
			$row = array('online_rez'=>$row['online_rez'],
								'grupa_nosaukums'=>$gr,
								//'pid_arr' => $pid_arr,
								'parbauditas'=>$row['parbauditas'],
								'ligums_id'=>$row['ligums_id'],
								'agents'=>$row['agents']	
								);
			$kajites[] = $row;
		}

	  //  echo "row:<br>"; var_dump($row); echo "<br><br>";

		
		//$sakuma_dat = $db->Date2Str($row['sakuma_dat']);
//$beigu_dat = $db->Date2Str($row['beigu_dat']);
		/*$qry = "SELECT * FROM piet_saite where deleted=0 and isnull(kid,0)<>0 and kvietas_veids<>6 and kvietas_veids<>3 and pid in (select id from pieteikums where ligums_id=?)";
		$params = array($ligums_id);
		$res = $db->Query($qry,$params);
		$prev_kid = 0;
		$pid_arr = array();
		while ($r = sqlsrv_fetch_array($res)) {
			//echo "vid:".$r['vid']."</br>";
			//echo "kid:".$r['kid']."<br>";
			$pid_arr[] = $r['pid'];
			if ($prev_kid!=0){
				if ($prev_kid!=$r['kid']){
					$row = array('online_rez'=>$row['online_rez'],
								'grupa_nosaukums'=>$gr,
								'pid_arr' => $pid_arr,
								'parbaudita'=>$row['parbauditas_kajites'],
								'ligums_id'=>$row['ligums_id'],
								'agents'=>$row['agents']	
								);
					$kajites[] = $row;
					/*echo "<b>DAÞÂDAS <u>KAJÎTES</u> ONLINE rezervâcijai <a href='http://globa/online_rez_2.asp?rez_id=$rez'>#$rez</a> $gid $sakuma_dat-$beigu_dat: ";
					foreach($pid_arr as $pid){
						echo " pieteikums #<a href='//globa/pieteikums.asp?pid=".$pid."'>".$pid."</a>";
					}
					echo "<br>";*/
			/*	}
				
			}
			$prev_kid = $r['kid'];
			
		}
		//echo "_______________________________<br>";
		*/
	}
	return $kajites;
}

?>