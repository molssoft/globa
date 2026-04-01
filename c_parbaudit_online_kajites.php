<?

//include 'm_init.php';

//echo get_last_id();
//$db = new Db;
$result = $db->Query(" select * from (
	select count(pieteikums.id) as dalibn_skaits,online_rez ,g.id as gid,m.v,g.sakuma_dat,g.beigu_dat
	from pieteikums 
	left join grupa g on pieteikums.gid=g.id
	left join marsruts m on g.mid=m.id
	where deleted=0 and online_rez<>0 and 
	gid in (select id from grupa where sakuma_dat>getdate() and gid in (select gid from kajite))
	group by online_rez,g.id,m.v,g.sakuma_dat,g.beigu_dat
)
t
where t.dalibn_skaits>1");

while ($row = sqlsrv_fetch_array($result)) {

  //  echo "row:<br>"; var_dump($row); echo "<br><br>";
	$rez = $row['online_rez'];
	$gid = $row['v'];
	$sakuma_dat = $db->Date2Str($row['sakuma_dat']);
		$beigu_dat = $db->Date2Str($row['beigu_dat']);
	$qry = "SELECT * FROM piet_saite where deleted=0 and isnull(kid,0)<>0 and kvietas_veids<>6 and kvietas_veids<>3 and pid in (select id from pieteikums where online_rez=?)";
	$params = array($rez);
	$res = $db->Query($qry,$params);
	$prev_kid = 0;
	$pid_arr = array();
	while ($r = sqlsrv_fetch_array($res)) {
		//echo "vid:".$r['vid']."</br>";
		//echo "kid:".$r['kid']."<br>";
		$pid_arr[] = $r['pid'];
		if ($prev_kid!=0){
			if ($prev_kid!=$r['kid']){
				echo "<b>DAÞÂDAS <u>KAJÎTES</u> ONLINE rezervâcijai <a href='http://globa/online_rez_2.asp?rez_id=$rez'>#$rez</a> $gid $sakuma_dat-$beigu_dat: ";
				foreach($pid_arr as $pid){
					echo " pieteikums #<a href='//globa/pieteikums.asp?pid=".$pid."'>".$pid."</a>";
				}
				echo "<br>";
			}
			
		}
		$prev_kid = $r['kid'];
		
	}
	//echo "_______________________________<br>";
}
?>