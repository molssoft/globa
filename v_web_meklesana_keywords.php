<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Majaslapas meklejumu vesture","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Mâjaslapâ bieþâk meklçtie atslçgas vârdi</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>

	
<div align="center">
<table border="0" bgcolor="#FDFFDD">
	<form action="" method="POST" name=forma>

		<tr>
		 <td align="right" bgcolor="#ffc1cc">Datums (ieskaitot) no: </td>
		 <td bgcolor="#fff1cc">
		  <input type="text" size="10" maxlength="10" name="datums_no" value="<?=$datums_no;?>">
		 lîdz:
		  <input type="text" size="10" maxlength="10" name="datums_lidz" value="<?=$datums_lidz;?>"></td>
		</tr>
</table>
<input type="hidden" name="subm" value="1"> 
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Atlasît" WIDTH="25" HEIGHT="25"> 

<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data['log'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($_SESSION['message'])){
	echo $_SESSION['message']."<br>";
	unset($_SESSION['message']);
}
if (count($data['log'])==0){?>

<font color="red">Nav rezultâtu</font>
<?
}
else{
	?>
	
	 <!-- Rezultâti  --> 
	 <b>Meklçti/s <?=count($data['log']);?> atslçgas vârdi/s</b>
	 <table border = 1 id="atrasts" style="max-width:400px">
	  <tr>
		  <th>Nr.</th>
		  <th>Atsl. vârdi</th>
		 <th>Mekl. skaits</th>
	 </tr>
	  <?//var_dump($data['ligumi']); 
	  $i=1;
	  $i = 1;
		  foreach ($data['log'] as $row){
			 // print_r($row['grupa']);
			 
			?>
			<tr style="" >
				<td><?=$i++;?>.</td>
				<td><?=decode($row['atslegas_vardi']);?></td>
				<td><?=$row['skaits'];?></td>			
			</tr>
		<?}?>
	  </table>
	
	<?}
	?>
	<br>
	
	<?
}?>
</body>
</html>