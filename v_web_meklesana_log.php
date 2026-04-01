<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Majaslapas meklejumu vesture","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Mâjaslapâ meklçto ceïojumu vçsture</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>

	
<div align="center">
<table border="0" bgcolor="#FDFFDD">
	<form action="" method="POST" name=forma>

<tr>
 <td align="right" bgcolor="#ffc1cc">Datums no: </td>
 <td bgcolor="#fff1cc">
  <input type="text" size="10" maxlength="10" name="datums_no" value="<?=$datums_no;?>">
 lîdz:
  <input type="text" size="10" maxlength="10" name="datums_lidz" value="<?=$datums_lidz;?>"></td>
</tr>



</table>
<input type="hidden" name="subm" value="1"> 
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem." WIDTH="25" HEIGHT="25"> 

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
	
	 <!-- Rezultâti 
	
	<b><?=$data['first_row'];?></b> lîdz <b><?=$data['last_row'];?></b> no <b><?=$data['rowcount'];?></b>
	 --> 
	 <table border = 1 id="atrasts">
	  <tr>
		  <th>Datums</th>
		  <th>Atslçgas vârds</th>
		 <th>Atrastâs grupas</th>
		 
		 
	 

	 
	  </tr>
	  <?//var_dump($data['ligumi']); 
	  
	  foreach ($data['log'] as $row){
		  $style="";
		 if ($row['atrastas_grupas']==0){
			 $style="color:red";
		 }
		?>
		<tr style="<?=$style;?>" >
			<td><?=$db->Date2Str($row['datums'])." ".$db->Time2Str($row['datums']);?></td>
		  <td><?=decode($row['atslegas_vardi']);?></td>
			<td><?=$row['atrastas_grupas'];?></td>
			
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