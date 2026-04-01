<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Online profili","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Online profili</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<form name="forma" id="forma" action = "?" method = "POST">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
<div align="center">
	<center>	Kopâ ir <?=$data['pabeigto_profilu_sk'];?> pabeigti profili
<br>
<br>
<?=$data['show_link'];?>
<br>
<br>
<table border="0">
  
        <tr>
            <td align="right" bgcolor="#ffc1cc">Vârds: </td>
            <td bgcolor="#fff1cc"><label for="vards"></label>
			<input type="text" size="16" id="vards" maxlength="80"
            name="vards" value="" placeholder=""></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Uzvârds: </td>
            <td bgcolor="#fff1cc"><label for="uzvards"></label>
			<input type="text" size="16" id="uzvards" maxlength="80"
            name="uzvards" value="" placeholder=""></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">E-adrese: </td>
            <td bgcolor="#fff1cc">
				<label for="eadr"></label>
				<input type="text" size="16" maxlength="80"
				name="eadr" id="eadr" value="" >
			</td>
        </tr>
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
       
		</table>

		<input type="submit" name = "submit" value="Meklçt!"></td>
      



	</form>
<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data['profili'])){
	require_once("online2/i_functions.php");?>
<center>
<? if (isset($data['top_n'])){?>
Jaunâkie
<?}else{?>
  Atrasti 
<?}?>
<b><?=$data['profilu_skaits'];?></b> profili
  <table border = 1 id="atrasts">
  <tr>
  <th>Reìistrâcijas laiks</th>
  <th>Vârds, uzvârds</th>
  <th>Pers. kods</th>
  <th>E-adrese</th>
  <th></th>
  <!-- <th>Pirkuma datums</th>
   <th>D.k.summa</th>
  <th>D.k.Nr</th>
  <th>D.k.kods</th>
 <th>Apraksts</th>
  <th>Bilance</th>-->
 
  </tr>
  <? foreach ($data['profili'] as $profils){
		 //var_dump($profils); ?>
	  <tr <? if(empty($profils['eadr']) || empty($profils['did'])){?>style="color:red"<?}?> >
	  <td><?=$db->Date2Str($profils['time_stamp']).' '.$db->Time2Str($profils['time_stamp']);?></td>
		<td>
			<? if (!empty($profils['did'])){?><a title="skatît dalîbnieku" href="dalibn.asp?i=<?=$profils['did'];?>" target="_blank"><?}?>
			<?=$profils['vards'].' '.$profils['uzvards'];?>
			<? if (!empty($profils['did'])){?></a><?}?>
		</td>
		<td><a title="uz profilu" href="profils.asp?pk1=<?=$profils['pk1'];?>&pk2=<?=$profils['pk2'];?>" target="_blank"><?=$profils['pk1'].'-'.$profils['pk2'];?></a></td>
		<td><?=$profils['eadr'];?></td>
		<td><? if(empty($profils['eadr']) ){?>
		<form action="?delete_pid" method="POST" id="dzesanas_forma_<?=$profils['id'];?>">
		<img title="Dzçst profilu" src="impro/bildes/dzest.jpg" alt="" onclick="if (confirm('Vai tieðâm dzçst ðo profilu?')){ $('#dzesanas_forma_<?=$profils['id'];?>').submit();}">
		<input type="hidden" name="delete_pid" value="<?=$profils['id'];?>"/>
		<? if(isset($data['nepabeigtie'])){?><input type="hidden" name="radit_nepabeigtos" value="1"/><?}?>
		
		</form>
		<?}?>
		</td>
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>