<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Online rezervâcijas","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Pârbaudâmâs online rezervâcijas</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>


<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<? if (isset($data['neapmaksatas'])){
	require_once("online2/i_functions.php");?>
<center>

<b><?=count($data['neapmaksatas']);?></b> rezervâcijas
  <table border = 1 id="atrasts">
  <tr>
  <th>Nr.</th>
  <th>Rez.id.</th>
  <th>Datums</th>
  <th>Rezervçja</th>
  <th>Grupas kods</th>
  <th>Ceïojums</th>
  <th>Summa</th>
  <th>Bilance</th>
  <th></th>
  
 
 
  </tr>
  <?require_once("i_functions.php");
  $i=1; foreach ($data['neapmaksatas'] as $row){
	  
	  $pietsumma = CurrPrint($row['summaEUR']);
	  $pietbilance = CurrPrint($row['bilanceEUR']);
				
		?>
	 <tr>
		<td><?=$i++;?></td>
		<td><a href="online_rez_2_details.asp?id=<?=$row["id"];?>"><?=$row['id'];?></a></td>
		<td><?=$db->Date2Str($row['datums']);?></td>
		<td><?=$row['vards'].' '.$row['uzvards'];?></td>
		<td><?=$row['grupa']['kods'];?></td>
		<td><?=$db->Date2Str($row['sakuma_dat']);?> - <?=$row['v'];?></td>
		<td><?=$pietsumma;?></td>
		<td><?=$pietbilance;?></td>
		<td>
		<form action="?delete" method="POST" id="dzesanas_forma_<?=$row['id'];?>">
		<img title="Dzçst rezervâciju" src="impro/bildes/dzest.jpg" alt="" onclick="if (confirm('Vai tieðâm dzçst ðo rezervâciju?')){ $('#dzesanas_forma_<?=$row['id'];?>').submit();}">
		<input type="hidden" name="delete_id" value="<?=$row['id'];?>"/>
		
		
		</form>
		
		</td>
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>