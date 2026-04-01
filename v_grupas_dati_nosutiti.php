<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Grupas dati nosûtîti","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><?=$data['grupas_nos'];?><br>nosûtîti</font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<form name="forma" id="forma" action = "" method = "POST">
<input name="save" type="hidden">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
<div align="center">
	<center>	
<br>
<br>
<?=$data['show_link'];?>
<br>
<br>
<table border="0">
  
        <tr>
            <td align="right" bgcolor="#ffc1cc">Saòçmçja nosaukums: </td>
            <td bgcolor="#fff1cc"><label for="vards"></label>
			<input type="text" size="16" id="vards" maxlength="80"
            name="sanemejs" value="" placeholder="" required></td>
			<td><input type="image" alt="Saglabât" title="Pievienot" name=pievienot  src="impro/bildes/saglabatjaunu.jpg"></td>
        </tr>
        
		</table>

		
		
      



	</form>
<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data)){
	require_once("online2/i_functions.php");?>
<center>

 <table border = 1 id="atrasts">
  <tr>

  <th>Saòçmçjs</th>
  <th>Pievienoja</th>
  

  <!-- <th>Pirkuma datums</th>
   <th>D.k.summa</th>
  <th>D.k.Nr</th>
  <th>D.k.kods</th>
 <th>Apraksts</th>
  <th>Bilance</th>-->
 
  </tr>
  <? foreach ($data['data'] as $row){
		 //var_dump($profils); ?>
	  <tr >
	 
		<td>
			<?=$row['sanemejs'];?>
		</td>
		<td><?=$db->Date2Str($row['pievienoja_datums']).' '.$db->Time2Str($row['pievienoja_datums']);?> <?=$row['pievienoja_lietotajs'];?></td>
		
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>