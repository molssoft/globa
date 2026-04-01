<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Autobusa laboðana","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Autobusa laboðana</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>

	
<div align="center">		
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data['autobuss'])){
	require_once("online2/i_functions.php");?>
<center>
<? 
if (isset($_SESSION['message'])){
	echo $_SESSION['message']."<br>";
	unset($_SESSION['message']);
}
if (count($data['autobuss'])==0){?>
<font color="red">Nav rezultâtu</font>
<?
}
else{?>

	<form action="?f=edit&id=<?=$data['autobuss']['id'];?>" method="POST">
	<input type="hidden" name="post" value="1">
	<table border = 1 id="atrasts">
		<tr>
			<th align=right>Partneris:</th><td colspan="3"><select name="partneris"><option></option>
				<? foreach ($data['partneri'] as $partneris){
					?>
					<option value="<?=$partneris['id'];?>" <? if ($partneris['id'] == $data['autobuss']['partneris']) echo "selected";?>><?=decode($partneris['Nosaukums']);?></option>
					<?
				}?></select></td>
		</tr>
		<tr>
			<th align=right>Modelis:</th>
			<td colspan="3" ><input size="" type="text" name="modelis" value="<?=$data['autobuss']['modelis'];?>" required /></td>
		</tr>
		<tr>
			<th align=right>Autobusa nosaukums:</th>
			<td colspan="3" ><input size="" type="text" name="nosaukums" value="<?=decode($data['autobuss']['nosaukums']);?>" required /></td>
		</tr>
	   <tr> <th align=right>Nr.:</th>
		<td colspan="3"><input type="text"  size="" name="nr" value="<?=$data['autobuss']['nr'];?>"/></td>
		</tr>
	   <tr> <th align=right>Ðoferis:</th>
			<td colspan="3"><input type="text"  size="" name="soferis" value="<?=decode($data['autobuss']['soferis']);?>"/></td>
		</tr>
	   <tr> <th align=right>Mobilais:</th>
			<td><input type="text"  size="" name="mobilais" value="<?=$data['autobuss']['mobilais'];?>"/></td>
		</tr>
	   <tr>  <th align=right>Vietas:</th>
			<td><input type="number"  size="" name="vietas" value="<?=$data['autobuss']['vietas'];?>"/></td>
			<th align=right>Papildvietas:</th>
			<td><input type="text"  size="" name="papildv" value="<?=$data['autobuss']['papildv'];?>"/></td>
		</tr>
		<tr>  
		</tr>
	   <tr> <th align=right>Krâsa:</th>
			<td colspan="3"><input type="text"  size="" name="krasa" value="<?=$data['autobuss']['krasa'];?>"/></td>
		</tr>
		  <tr> <th align=right>Râdît mâjaslapâ:</th>
			<td colspan="3"><input type="checkbox"  size="" name="radit_web" <? if ($data['autobuss']['radit_web']) echo "checked";?>></td>
		</tr>
		 <tr> <th align=right>Bagâþas telpas tilpums:</th>
			<td colspan="3"><input type="number" step="any" size="" name="bagaza" value="<?=$data['autobuss']['bagaza'];?>"/>m3</td>
		</tr>
		  <tr> <th align=right>Aprîkojums:</th>
			<td colspan="3"><textarea name="aprikojums" rows="5" cols="50"><?=$data['autobuss']['aprikojums'];?></textarea></td>
		</tr>
		  <tr> <th align=right>Bâkas tilpums:</th>
			<td colspan="3"><input type="number" step="any" size="" name="baka" value="<?=$data['autobuss']['baka'];?>"/>l</td>
		</tr>
		  <tr> <th align=right>Augstums:</th>
				<td colspan="3"><input type="number" step="any" size="" name="augstums" value="<?=$data['autobuss']['augstums'];?>"/>m</td>
		</tr>
		 <tr> <th align=right>Platums:</th>
			<td colspan="3"><input type="number" step="any" size="" name="platums" value="<?=$data['autobuss']['platums'];?>"/>m</td>
		</tr>
		<tr> <th align=right>Garums:</th>
			<td colspan="3"><input type="number" step="any" size="" name="garums" value="<?=$data['autobuss']['garums'];?>"/>m</td>
		</tr>
		 <tr> <th align=right>Degvielas patçriòð:</th>
			<td colspan="3"><input type="text" size="" name="paterins" value="<?=$data['autobuss']['paterins'];?>"/>l/100km</td>
		</tr>
		
	
	 
	 
	 

	 
	  </table>
	   <br>
	  <input type=image src="impro/bildes/diskete.jpg" alt="Saglabât izmaiòas.">
	  <br><br>
	  <table border = 1>
	  <tr>
			<th align=center>Plâna bilde:</th></tr>
		<? if (!empty($data['autobuss']['plans'])){
			$folder = "https://www.impro.lv/autobusu_bildes/";
			$text = "Mainît";?>  <tr>	<td colspan="2">
			
				
				
				<img src="<?=$folder.$data['autobuss']['plans'];?>" alt="Autobusa plâns" /> 
			
			</td></tr>
			<?}
			else $text = "Augðupielâdçt";?>
		  <tr>	<td align=center><a href="?f=upload_plans&id=<?=$data['autobuss']['id'];?>"><?=$text;?></a></td>
		</tr>
	  </table>
	 
	  
	<?}
}?>
</body>
</html>