
<? //include "dbprocs.inc"; ?>
<? //include "procs.inc"; ?>

<?
//atver datu baazi
//dim $conn;
//openconn;
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
$db = New db();
require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Dalîbnieks dokumenti pieteikumam","y1.jpg");
DefJavaSubmit();
 
 
if (isset($_SESSION["message"]) && $_SESSION["message"] != "") {
	echo "<center><font color='RED' size='5'><b>".$_SESSION["message"]."</b></font>";
	$_SESSION["message"] = "";
}
 if (isset($_GET['pid']) && (int)$_GET['pid'] >0){
	require_once("online2/m_dalibn.php");
	require_once("online2/m_pieteikums.php");
	$dalibn = new Dalibn();
	$piet = new Pieteikums();
	$pid = (int)$_GET['pid'];
	$pieteikums = $piet->GetId($pid);
	//var_dump($pieteikums);
	$did = $pieteikums['did'];
	//var_dump($pieteikums);
	if (empty($did)){
		$did = $dalibn->GetIdPidSaite($pid);
	//	var_dump($did);
		//echo "<br>DID:<br><b>$did</b><<<<<br><br>";
	}
	if (!empty($did)){
		
		$dalibnieks = $dalibn->GetId($did);
	
 
?>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Dalîbnieka <a href="dalibn.asp?i=<?=$did;?>"><?=$dalibnieks['vards'].' '.$dalibnieks['uzvards'];?></a>
dokumenti pieteikumam #<a href="pieteikums.asp?i=<?=$pid;?>"><?=$pid;?></a></b></font><hr>

<?
// standarta saites
 
Headlinks();

 

 

?>

<form name="forma" action = "valuta.asp" method = "POST">

<br>
<table style="width:500px">
<caption><font color="BLACK" size="3"><b>PASE</b></font></caption>
<tbody>
<tr><td></td>	<th>Sçrija</th>
<th>Numurs</th>
<th>Derîguma termiòð</th>
</tr>
<?
//-----------------
// noformçjumam
//--------------------
//pasei
if (empty($pieteikums['paseS'])){ 
	$color_paseS = 'green';
	$piet_paseS = "-";
}
else{ 
	$piet_paseS = $pieteikums['paseS'];
	if (trim($pieteikums['paseS']) == trim($dalibnieks['paseS'])) $color_paseS='green';
	else $color_paseS='red';
}
if (empty($pieteikums['paseNR'])){ 
	$color_paseNR = 'green';
	$piet_paseNR = "-";
}
else{ 
	$piet_paseNR = $pieteikums['paseNR'];
	if (trim($pieteikums['paseNR']) == trim($dalibnieks['paseNR'])) $color_paseNR='green';
	else $color_paseNR='red';
}
if (empty($pieteikums['paseDERdat'])){ 
	$color_paseDERdat = 'green';
	$piet_paseDERdat = "-";
}
else{ 
	$piet_paseDERdat = $db->Date2Str($pieteikums['paseDERdat']);
	if ($pieteikums['paseDERdat'] == $dalibnieks['paseDERdat']) $color_paseDERdat='green';
	else  $color_paseDERdat='red';
}
	//id kartei
if (empty($pieteikums['idS'])){ 
	$color_idS = 'green';
	$piet_idS = "-";
}
else{ 
	$piet_idS = $pieteikums['idS'];
	if (trim($pieteikums['idS']) == trim($dalibnieks['idS'])) $color_idS='green';
	else $color_idS='red';
}
if (empty($pieteikums['idNR'])){ 
	$color_idNR = 'green';
	$piet_idNR = "-";
}
else{ 
	$piet_idNR = $pieteikums['idNR'];
	if (trim($pieteikums['idNR']) == trim($dalibnieks['idNR'])) $color_idNR='green';
	else  $color_idNR='red';
}
if (empty($pieteikums['idDerDat'])){ 
	$color_idDerDat = 'green';
	$piet_idDerDat = "-";
}
else{ 
	$piet_idDerDat = $db->Date2Str($pieteikums['idDerDat']);
	if ($pieteikums['idDerDat'] == $dalibnieks['idDerDat']) $color_idDerDat='green';
	else $color_idDerDat='red';
}
?>
	<tr bgcolor="#ffc1cc"><th>Pieteikuma dati</th>
		<td><font color="<?=$color_paseS;?>"><?=$piet_paseS;?></font></td>
		<td><font color="<?=$color_paseNR;?>"><?=$piet_paseNR;?></font></td>
		<td><font color="<?=$color_paseDERdat;?>"><?=$piet_paseDERdat;?></font></td>
	</tr>
	<tr bgcolor="#ffc1cc"><th>Dalîbnieka dati</th>
		<td><font color="<?=$color_paseS;?>"><?=$dalibnieks['paseS'];?></font></td>
		<td ><font color="<?=$color_paseNR;?>"><?=$dalibnieks['paseNR'];?></font></td>
		<td><font color="<?=$color_paseDERdat;?>"><?=$db->Date2Str($dalibnieks['paseDERdat']);?></font></td>
	</tr>
</table>
<br><br>

<table style="width:500px">
	<caption><font color="BLACK" size="3"><b>ID karte</b></font></caption>
	<tr><td></td>	<th>Sçrija</th>
	<th>Numurs</th>
	<th>Derîguma termiòð</th>
	</tr>
	</tr>
	<tr bgcolor="#ffc1cc"><th>Pieteikuma dati</th>
		<td><font color="<?=$color_idS;?>"><?=$piet_idS;?></font></td>
		<td><font color="<?=$color_idNR;?>"><?=$piet_idNR;?></font></td>
		<td><font color="<?=$color_idDerDat;?>"><?=$piet_idDerDat;?></font></td>
	</tr>
	<tr bgcolor="#ffc1cc"><th>Dalîbnieka dati</th>
		<td><font color="<?=$color_idS;?>"><?=$dalibnieks['idS'];?></font></td>
		<td ><font color="<?=$color_idNR;?>"><?=$dalibnieks['idNR'];?></font></td>
		<td><font color="<?=$color_idDerDat;?>"><?=$db->Date2Str($dalibnieks['idDerDat']);?></font></td>
	
	</tr>
	</tbody>
</table>
	<? }else echo "Dalîbnieks nav atrasts"; }
else echo "Pieteikums nav atrasts"; ?>
</form>
</body>
</html>

