<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Mâjaslapâ bieþâk skatîtâs grupas","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Mâjaslapâ bieþâk skatîtâs grupas</b></font><hr>

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
<? if (isset($data['skatijumi'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($_SESSION['message'])){
	echo $_SESSION['message']."<br>";
	unset($_SESSION['message']);
}
if (count($data['skatijumi'])==0){?>

<font color="red">Nav rezultâtu</font>
<?
}
else{
	?>
	
	<b>Skatîta(s) <?=count($data['skatijumi']);?> grupa(s)</b>
	 <!-- Rezultâti --> 
	 <table border = 1 id="atrasts" style="max-width:900px">
		  <tr>
			  <th>Nr.</th>
			  <th>Ceïojums</th>
			 <th>Skatîjumu skaits</th>
		 
		  </tr>
		  <?
		  $i = 1;
		  foreach ($data['skatijumi'] as $row){
			 // print_r($row['grupa']);
			 
			?>
			<tr style="" >
				<td><?=$i++;?>.</td>
			  <td><a href="//globa/grupa_edit.asp?gid=<?=$row['gid'];?>" target="_blank"><?=$db->Date2Str($row['grupa']['sakuma_dat']);?></a> <?=$row['grupa']['v'];?></td>
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