<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Lîgumu pârskats","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Lîgumu pârskats</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<form name="forma" id="forma" action = "?f=meklet" method = "POST">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
	
<div align="center">
	

<table border="0">
   <tr>
	<td align="right" bgcolor="#ffc1cc">Lîguma izveidoðanas datums no:</td> <td bgcolor="#fff1cc"><input type="text" name="lig_datums_no" size="8" maxlength="10" value="" placeholder="dd.mm.YYYY"/><label for="lig_datums_no"></label></td>
		<td bgcolor="#ffc1cc">lîdz:</td> <td bgcolor="#fff1cc"><input type="text" name="lig_datums_lidz" size="8" maxlength="10" value="" placeholder="dd.mm.YYYY"/><label for="lig_datums_lidz"></label></td>
	</tr>	
       <tr>
		<td align="right" bgcolor="#ffc1cc">Pieteikuma datums no:</td> <td bgcolor="#fff1cc"><input type="text" name="datums_no" size="8" maxlength="10" value="" placeholder="dd.mm.YYYY"/><label for="datums_no"></label></td>
		<td bgcolor="#ffc1cc">lîdz:</td> <td bgcolor="#fff1cc"><input type="text" name="datums_lidz" size="8" maxlength="10" value="" placeholder="dd.mm.YYYY"/><label for="datums_lidz"></label></td>
	</tr>	
	<tr>
		<td align="right" bgcolor="#ffc1cc">Izbraukðanas datums no:</td><td><input type="text" name="cel_datums_no" size="8" maxlength="10" placeholder="dd.mm.YYYY"/><label for="cel_datums_no"></label></td>
		<td bgcolor="#ffc1cc">lîdz:</td> <td bgcolor="#fff1cc"><input type="text" name="cel_datums_lidz" size="8" maxlength="10" value="" placeholder="dd.mm.YYYY"/><label for="cel_datums_no"></label></td>
	</tr>	
	<tr>
		<td align="right" bgcolor="#ffc1cc">Grupas kods:</td><td bgcolor="#fff1cc" colspan="3" align="left"><input type="text" name="gr_kods" size="14" maxlength="14" value="" /></td>
	</tr>
	<tr>
		<td align="right" bgcolor="#ffc1cc">Online rezervâcijas id:</td><td colspan="3" align="left" bgcolor="#fff1cc"><input type="text" name="rez_id" size="10" maxlength="10" value="" /></td>
	</tr>
	<tr>
		<td align="right" bgcolor="#ffc1cc">Pieteikuma id:</td><td colspan="3" align="left" bgcolor="#fff1cc"><input type="text" name="pid" size="10" maxlength="10" value="" /></td>
	</tr>	
	<tr>
		<td align="right" bgcolor="#ffc1cc">Lîguma id:</td><td colspan="3" align="left" bgcolor="#fff1cc"><input type="text" name="lid" size="10" maxlength="10" value="" /></td>
	</tr>
	<!--<tr>
		<td>Grupas veids:</td><td colspan="3" align="left">
			<select name="gr_veids" width="150" style="width: 150px">
				<option value=""></option>
				<option value="kipra_carter" <% If gr_veids="kipra_carter" Then Response.write "selected" %> >Kipras èarteri</option>
			</select>
		</td>
	</tr>-->
	<!--
		 <tr>
            <td align="right" bgcolor="#ffc1cc">Datums no: </td>
            <td bgcolor="#fff1cc"><label for="datums_no"></label>
			<input type="text" size="16" id="datums_no" maxlength="80"
            name="datums_no" value="" placeholder="dd.mm.YYYY"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Datums lîdz: </td>
            <td bgcolor="#fff1cc"><label for="datums_lidz"></label>
			<input type="text" size="16" name="datums_lidz" id="datums_lidz" placeholder="dd.mm.YYYY"value=""></td>
        </tr>
       -->
		</table>

		<input type="submit" name = "search" value="Meklçt!"></td>
      



	</form>
<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data['results']['ligumi'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (count($data['results']['ligumi'])==0){?>
<font color="red">Nav rezultâtu</font>
<?
}
else{?>
	
	  Rezultâti 
	
	<b><?=$data['results']['first_row'];?></b> lîdz <b><?=$data['results']['last_row'];?></b> no <b><?=$data['results']['rowcount'];?></b>
	  <table border = 1 id="atrasts">
	  <tr>
	  <th>Lîgums</th>
	  <th>Lîg. izv. datums</th>
	  <th>Dalîbnieki</th>
	  <th>Grupa</th>
	   <th>Pieteikumi</th>
	  <th>Online rez.</th>
	 
	 
	 

	 
	  </tr>
	  <?//var_dump($data['ligumi']); 
	  
	  foreach ($data['results']['ligumi'] as $ligums){
			 //var_dump($profils); 
			 if ($ligums["agents_izv"])
				$fstyle = " style='color: #0060ff'";
			elseif ($ligums["tmp"] == 0 && $ligums["internets"] &&  $ligums["online_rez"]<>0 ) 
				$fstyle = " style='color: green;';" ;
			else
				$fstyle = "";
		
		?>
		  <tr <?=$fstyle;?>>
		  <td><? if  (empty($ligums['online_rez'])){?><a href="download_pdf.asp?id=<?=$ligums['lid'];?>" target="ligums"><?} else{?><a href="paradit_ligumu.php?id=<?=$ligums['lid'];?>" target="ligums"><?}?><?=$ligums['lid'];?></a></td>
			
			

			</td>
			<td><?=$db->Date2Str($ligums['accepted_date']);?></td>
			<td><?=$ligums['dalibn_vardi'];?></td>
			<td>
				<a href="http://globa/pieteikumi_grupaa.asp?gid=<?=$ligums['gid'];?>&mode=ligums" target="grupa"><?=$ligums['kods'];?></a> 
				<?=$db->Date2Str($ligums['sakuma_dat']).' - '.$db->Date2Str($ligums['beigu_dat']);?> <?=$ligums['v'];?>
			</td>
			<td>
				<?=$ligums['pieteikumi'];?>
			</td>
			<td><? if(!empty($ligums['online_rez'])){?><a href="online_rez_2.asp?rez_id=<?=$ligums['online_rez'];?>"><?=$ligums['online_rez'];?></a><?} else echo "-";?></td>
			
			
			
			
		</tr>
		<?}?>
	  </table>
	 <? // Use default styling/automatic generation
		echo $pagination->getLinksHtml("c_ligumi.php", "pg");

		// custom styling
		for($i=1; $i<=$pagination->getNumPages(); $i++) {
			//etc etc
		}
		?>
	<?}
}?>
</body>
</html>