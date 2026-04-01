<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Pârbaudâmie viesnîcu un kajîðu salikumi","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Pârbaudâmie viesnîcu un kajîðu salikumi</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>


	
<div align="center">		


<?
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($_SESSION['message'])){
	echo $_SESSION['message']."<br>";
	unset($_SESSION['message']);
}
?>
<h4>Daþâdi <u>viesnîcu numuriòi</u> vienas rezervâcijas ietvaros (2 ceïotâju rezervâcijâs)</h4>
<?
if (!empty($data['viesnicas'])){
	?>
	<table border = 1 id="atrasts">
	<thead>
	  <tr>
		  <th>Lîgums</th>
		  <th>Ceïojums</th>
		  <th>Pieteikumu nr.</th>	 
		  <th></th>
	   </tr>
	  </thead>
	  <tbody>
	 
	<?
	foreach($data['viesnicas'] as $row){
		//print_r($row);
		$style="";
		if ($row['parbaudita']){
			$style .= "background-color:LightGreen;";
		}	
		
		if (!empty($row['online_rez'])){
			$style  .= "color:green;";
		}
		if (!empty($row['agents'])){
			$style  .= "color:blue;";
		}
		?>
		<tr style='<?=$style;?>'>
			<td><a href='http://globa/c_ligumi.php?ligums_id=<?=$row['ligums_id'];?>' target='_blank'>#<?=$row['ligums_id'];?></a></td>
			<td><?=$row['grupa_nosaukums'];?></td>
			<td><? echo implode(", ",$row['pid_arr']);?></td>
			<td>
			<?if ($row['parbauditas']!=1){?>
				<form method="POST" >
					<input type="hidden" name="parbaudita" value="viesnica">
					<input type="hidden" name="ligums_id" value="<?=$row['ligums_id'];?>">
					<button type="submit" onclick="return confirm('Vai tieðâm vçlaties atzîmçt ðo rezervâciju kâ pârbaudîtu?');">Atzîmçt kâ pârbaudîtu</button>
				</form>
			<?}
			else{
				?>Pârbaudîts
			<?}?>
			</td>
		</tr>
		<?
	}
	?>
	</tbody>
	</table>
	<?
	
}else{
	?>
	<font color="green">Nav</font>
	<?
}
?>
<h4>Daþâdas <u>kajîtes</u> vienas rezervâcijas ietvaros (2 un vairâk ceïotâju rezervâcijâs)</h4>
<?
if (!empty($data['kajites'])){
	?>
	<table border = 1 id="atrasts">
	<thead>
	  <tr>
		  <th>Lîgums</th>
		  <th>Ceïojums</th>
		  
		  <th></th>
	   </tr>
	  </thead>
	  <tbody>
	 
	<?
	foreach($data['kajites'] as $row){
		$style="";
		if ($row['parbaudita']){
			$style .= "background-color:LightGreen;";
		}	
		
		if (!empty($row['online_rez'])){
			$style  .= "color:green;";
		}
		if (!empty($row['agents'])){
			$style  .= "color:blue;";
		}
		?>
		<tr style='<?=$style;?>'>
			<td><a href='http://globa/c_ligumi.php?ligums_id=<?=$row['ligums_id'];?>' target='_blank'>#<?=$row['ligums_id'];?></a></td>
			<td><?=$row['grupa_nosaukums'];?></td>
			<!--td><?// echo implode(", ",$row['pid_arr']);?></td-->
			<td>
			<?if ($row['parbauditas']!=1){?>
				<form method="POST" >
					<input type="hidden" name="parbaudita" value="kajite">
					<input type="hidden" name="ligums_id" value="<?=$row['ligums_id'];?>">
					<button type="submit" onclick="return confirm('Vai tieðâm vçlaties atzîmçt ðo rezervâciju kâ pârbaudîtu?');">Atzîmçt kâ pârbaudîtu</button>
				</form>
			<?}else{
				?>Pârbaudîts
			<?}?>
			</td>
		</tr>
		<?
	}
	?>
	</tbody>
	</table>
	<?
}
else{?>
	<font color="green">Nav</font>
<?}?>




	
	

</body>
</html>