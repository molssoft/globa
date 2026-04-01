<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Autobusi","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Autobusi</b></font><hr>

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
<? if (isset($data['autobusi'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($_SESSION['message'])){
	echo $_SESSION['message']."<br>";
	unset($_SESSION['message']);
}
if (count($data['autobusi'])==0){?>

<font color="red">Nav rezultâtu</font>
<?
}
else{
	?>
	
	 <!-- Rezultâti 
	
	<b><?=$data['first_row'];?></b> lîdz <b><?=$data['last_row'];?></b> no <b><?=$data['rowcount'];?></b>
	 --> <table border = 1 id="atrasts">
	  <tr>
	  <th>Modelis</th>
	  <th>Partneris</th>
	  <th>Nosaukums</th>	  
	  <th>Nr.</th>
	  <th>Ðoferis</th>
	  <th>Mobilais</th>
	   <th>Vietas</th>
	  <th>Krâsa</th>
	  <th></th>
	  <th></th>
	 
	 
	 

	 
	  </tr>
	  <?//var_dump($data['ligumi']); 
	  
	  foreach ($data['autobusi'] as $autobuss){
		  if ($autobuss['radit_web']){
			  $style="style='color:green'";		
		  }
			 else $style="";
		?>
		<tr <?=$style;?>>
			<td><?=$autobuss['modelis'];?></td>
		  <td><?=decode($autobuss['pnos']);?></td>
		  <td><a href="?f=edit&id=<?=$autobuss['id'];?>" target="autobuss"><?=decode($autobuss['nosaukums']);?></a></td>
			<td><?=$autobuss['nr'];?></td>
			<td><?=decode($autobuss['soferis']);?></td>
			<td><?=$autobuss['mobilais'];?></td>
			<td><?=$autobuss['vietas'];?><? if (!empty($autobuss['papildv'])) echo "+".$autobuss['papildv'];?></td>
			<td><?=$autobuss['krasa'];?></td>
			<td></td>
			<td>
				<form action="?f=delete" method="POST" id="dzesanas_forma_<?=$autobuss['id'];?>">
					<input type="hidden" name="id" value="<?=$autobuss['id'];?>" />
					<img title="Dzçst autobusu" src="impro/bildes/dzest.jpg" alt="" onclick="if (confirm('Vai tieðâm dzçst ðo autobusu?')){ $('#dzesanas_forma_<?=$autobuss['id'];?>').submit();}">
				</form>
			</td>
			
			
		</tr>
		<?}?>
	  </table>
	
	<?}
	?>
	<br>
	<a href="?f=edit"><img border="0" title="Pievienot jaunu atobusu" src="impro/bildes/pievienot.jpg"></a>
	<?
}?>
</body>
</html>