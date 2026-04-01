<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Online mainîtie dokumenti","y1.jpg");
DefJavaSubmit();?>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Online mainîtie dokumenti</b></font><hr>

<?
// standarta saites
 
Headlinks();

 

 

?>
<br>

<? if (isset($data['pieteikumi'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($_SESSION['msg'])){?>
	<font color=red><?=$_SESSION['msg'];?></font>
	<br>
	<br>
<? 
	unset($_SESSION['msg']);
}?>
  Atrasto pieteikumu skaits: <?=count($data['pieteikumi']);?>
  <table border = 1 id="atrasts">
  <tr>
	  <th width="180px">Dalîbnieks</th>
	   <th>Piet.</th>
	   <th>Grupa</th>
	  <th width="350px">Vecie dati</th>
	  <th width="350px">Jaunie dati</th>
 
 
  </tr>
  <? foreach ($data['pieteikumi'] as $piet){
	  //-----------------
// noformçjumam
//--------------------
//pasei
if (empty($piet['piet_paseS'])){ 
	$color_paseS = 'green';
	//$piet_paseS = "-";
}
else{ 
	$piet_paseS = $piet['piet_paseS'];
	if ($piet['piet_paseS'] == $piet['dalibn_paseS']) $color_paseS='green';
	else $color_paseS='red';
}
if (empty($piet['piet_paseNr'])){ 
	$color_paseNR = 'green';
	//$piet_paseNR = "-";
}
else{ 
	//$piet_paseNR = $piet['piet_paseNR'];
	if ($piet['piet_paseNr'] == $piet['dalibn_paseNr']) $color_paseNR='green';
	else $color_paseNR='red';
}
if (empty($piet['piet_paseDerDat'])){ 
	$color_paseDERdat = 'green';
	//$piet_paseDERdat = "-";
}
else{ 
	//$piet_paseDERdat = $db->Date2Str($pieteikums['paseDERdat']);
	if ($piet['piet_paseDerDat'] == $piet['dalibn_paseDerDat']) $color_paseDERdat='green';
	else  $color_paseDERdat='red';
}
	//id kartei
if (empty($piet['piet_idS'])){ 
	$color_idS = 'green';
	//$piet_idS = "-";
}
else{ 
	//$piet_idS = $pieteikums['idS'];
	if ($piet['piet_idS'] == $piet['dalibn_idS']) $color_idS='green';
	else $color_idS='red';
}
if (empty($piet['piet_idNr'])){ 
	$color_idNR = 'green';
	//$piet_idNR = "-";
}
else{ 
	//$piet_idNR = $piet['piet_idNR'];
	if ($piet['piet_idNr'] == $piet['dalibn_idNr']) $color_idNR='green';
	else  $color_idNR='red';
}
if (empty($piet['piet_idDerDat'])){ 
	$color_idDerDat = 'green';
	//$piet_idDerDat = "-";
}
else{ 
	//$piet_idDerDat = $db->Date2Str($pieteikums['idDERdat']);
	if ($piet['piet_idDerDat'] == $piet['dalibn_idDerDat']) $color_idDerDat='green';
	else $color_idDerDat='red';
}
		  ?>
	  <tr>
		<td><a href="dalibn.asp?i=<?=$piet['did'];?>" target="_blank"><?=$piet['vards']." ".$piet['uzvards'];?></a></td>		
		<td><a href="pieteikums.asp?pid=<?=$piet['pid'];?>" target="_blank"><?=$piet['pid'];?></a></td>
		<td><a href="grupa.asp?gid=<?=$piet['gid'];?>"><?=$piet['v'].'<br>'.$db->Date2Str($piet['sakuma_dat']).' - '.$db->Date2Str($piet['beigu_dat']);?></td>
		<td>
			<table>
				<tr>
					<td>Pase:</td><td><font color="<?=$color_paseS;?>"><?=$piet['dalibn_paseS'];?></font><font color="<?=$color_paseNR;?>"><?=$piet['dalibn_paseNr'];?></font><? if (($db->Date2Str($piet['dalibn_paseDerDat']))!="&nbsp;"){?>, derîga lîdz <font color="<?=$color_paseDERdat;?>"><?=$db->Date2Str($piet['dalibn_paseDerDat']);?></font><?}?></td>
					
				</tr>
				<tr>
					<td>ID karte:</td><td><font color="<?=$color_idS;?>"><?=$piet['dalibn_idS'];?></font><font color="<?=$color_idNR;?>"><?=$piet['dalibn_idNr'];?></font><? if (($db->Date2Str($piet['dalibn_idDerDat']))!="&nbsp;"){?>, derîga lîdz <font color="<?=$color_idDerDat;?>"><? echo $db->Date2Str($piet['dalibn_idDerDat']);?></font><?}?></td>
			
				</tr>
				
			</table>
			<center>
				<form method="POST" action="c_mainiti_dok.php">
					<input type="hidden" name="aizstat_ar" value="pid">
					<input type="hidden" name="pid" value="<?=$piet['pid'];?>">
					<input type="hidden" name="did" value="<?=$piet['did'];?>">
					<button type="submit" name="submit">Aizstât ar jauno</button>
				</form>
			</center>
		</td>
		<td>
			<table>
				<tr>
					<td>Pase:</td><td><font color="<?=$color_paseS;?>"><?=$piet['piet_paseS'];?></font><font color="<?=$color_paseNR;?>"><?=$piet['piet_paseNr'];?></font><? if (($db->Date2Str($piet['piet_paseDerDat']))!="&nbsp;"){?>, derîga lîdz <font color="<?=$color_paseDERdat;?>"><?=$db->Date2Str($piet['piet_paseDerDat']);?></font><?}?></td>
				</tr>
				<tr>
					<td>ID karte:</td><td><font color="<?=$color_idS;?>"><?=$piet['piet_idS'];?></font><font color="<?=$color_idNR;?>"><?=$piet['piet_idNr'];?></font><? if (($db->Date2Str($piet['piet_idDerDat']))!="&nbsp;"){?>, derîga lîdz <font color="<?=$color_idDerDat;?>"><?=$db->Date2Str($piet['piet_idDerDat']);?></font><?}?></td>
			
				</tr>
			</table>
			<center>
				<form method="POST" action="c_mainiti_dok.php">
					<input type="hidden" name="aizstat_ar" value="did">
					<input type="hidden" name="pid" value="<?=$piet['pid'];?>">
					<input type="hidden" name="did" value="<?=$piet['did'];?>">
					<button type="submit" name="submit">Aizstât ar veco</button>
				</form>
			</center>
		</td>
	
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>