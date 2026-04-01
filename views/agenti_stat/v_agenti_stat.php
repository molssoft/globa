<?require_once("i_functions.php");

Docstart ("Aìenti","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="online2/js/datepicker-lv.js" ></script>
<script type="text/javascript">
$( document ).ready(function() {

	  $( ".datepicker").datepicker({
		 format: "dd.mm.yyyy",
        weekStart: 1,
        startDate: "now",
        maxViewMode: 2,
        language: "lv",		
		changeMonth: true,
		changeYear: true,
		  showButtonPanel: true,
            closeText: 'Aizvçrt',
		
		yearRange: "-20:+1",
    });
	

	
});

</script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Aìentu statistika</b></font><hr>

<?
// standarta saites jaja
 
Headlinks();

/*if session("message") <> "" { 
	?>
	<br><font size = 4 color = red><?=session("message")?></font><br>
	<?
	session("message") = ""
end if*/
?>
<table cols="2" rows="5">
<form name="forma" method="POST" action="" border="1">
	<input type="hidden" name="submit" value="1">
<tr>
<td align="right" bgcolor="#ffc1cc">Aìents: </td>
<td align="left" bgcolor="#fff1cc" colspan="2">	<!-------Sâkas pirmâs rindas labâ ðûna-----> 
<?
if (!empty($data['agenti'])){?>
<select name="agents" class="form-control">
		<option value = "0" <? if ($data["agents"] == "0") { echo " selected ";}?>>Tie kam nav aìenta</option>
		<option value = "" <?if($data["agents"] == "") {echo " selected ";} ?>>Visi</option>
	<? foreach ($data['agenti'] as $row):?> 
		<option value = "<?=$row['id']?>" 
		<? if ($data["agents"]==$row["id"]) echo "selected"; ?>
		><?=Decode($row["pilseta"]). " " .Decode($row["vards"]);?></option>
	<?  endforeach;
	?>
	</select>
	</td></tr><!---------Beidzas pirmâ rinda un labâ ðûna---------->
	<!-----------------Sâkas otrâ rinda un pirmâ ðûna------------>
	<tr>
		<td align="right" halign="center" bgcolor="#ffc1cc">Ceïojums sâkas no: </td>
		<td align="left" bgcolor="#fff1cc">	<input name="grupa_no" class=" datepicker" value="<?=$data['grupa_no'];?>"
											autocomplete="off" placeholder="dd.mm.GGGG">
										 lîdz <input name="grupa_lidz" class=" datepicker" value="<?=$data['grupa_lidz'];?>"
											autocomplete="off"  placeholder="dd.mm.GGGG"></td>
	</tr>
	<!--
	<tr>
		<td align="right" halign="center" bgcolor="#ffc1cc">Pieteikuma datums no: </td>
		<td align="left" bgcolor="#fff1cc"><input type="textbox" name="no" size="10" value="<?//=Request.Form("no")?>"> lîdz <input type="textbox" name="lidz" value="<?//=Request.Form("lidz")?>" size="10"></td>
	</tr>
	-->
	<tr>
	 <td align="right" halign="center" bgcolor="#ffc1cc">Zilie:</td>
	 <td align="left" bgcolor="#fff1cc">
	  <select name=zilie class="form-control">
	   <option value="visi" <? if ($data['zilie']=="visi")echo " selected ";?>>Visi</option>
	   <option value="zilie" <? if ($data['zilie']=="zilie") echo " selected ";?>>Zilie</option>
	   <option value="nezilie" <? if ($data['zilie']=="nezilie") echo " selected ";?>>Nezilie</option>
	  </select>
	 </td>
	</tr>

	<!------piektâ rinda--------->
	<tr><td colspan="2" align="center" valign="bottom" bgcolor="#fff1cc">
	&nbsp;<br><input type="submit" class="btn btn-success" value="Izpildît!" name="poga">
	</td></tr>
	</form>
	</table>
	<!---------------------------------Formas un tabulas beigas------------------>
	
<?} else{ // ja aìentu bâzç nav?>
	Aìentu saraksts ir tukðs, tâpçc statistika nav pieejama!
	</body></html>
<?}?>
<hr width="100%">
<?if (empty($data['data']['records'])){
              echo "Par doto aìentu nav datu";
}else{
			 ?>
			<H3>Atskaite par <?
			if ($data["agents"] == "") {
				echo " visiem aìentiem";
			}
			else{
				echo Decode($data['data']["agentaVards"]);
			}
			?>
			</H3><P>
			<center>
			<div>
			<?
			//echo $data['result_count'];
			?>
			<b><?=$data['data']['first_row'];?></b> lîdz <b><?=$data['data']['last_row'];?></b> no <b><?=$data['data']['rowcount'];?></b>
			
			</div>
			<div class="container">
			<div class="row">
			<div class="col-12">
			<table cols="4" class="table table-sm table-bordered table-hover">
			<tr bgcolor="#ffc1cc">
				<th>Nr</th>
				<th>Aìents</th>
				<!--th>Datums</th-->
				<th>Rez. nr.</th>
				<th>Pieteikuma datums</th>
				<th>Ceïojuma sâkums</th>
				
				<th>Pieteikums</th>
				<th>Jâmaksâ</th>
				<th>Iemaksâts</th>
				<th>Aprçíinâts</th>
			</tr>
			<?
			
			$s = 0;
			foreach($data['data']['records'] as $row){

				// Increment
				$s++;
				if (($tiesibas->IsAccess(T_GRAMATVEDIS) or $tiesibas->IsAccess(T_LIETOT_ADMIN)) and isset($row['iemaks']['zils']) 
				and $row['iemaks']["zils"] == 1) {
				 ?><tr bgcolor = lightblue><?
				}else{
				 ?><tr bgcolor = "#fff1cc"><?
				}?>
				<td><?=$s?></td>
				<td><?= Decode($row["vards"])?></td>
				<!--td><?=$db->Date2Str($row["datums"])?></td-->
				<td><?=$row["id"]?></td>
				<td><?=$db->Date2Str($row["piet_datums"])?></td>
				<td><?=$db->Date2Str($row["sakuma_dat"])?></td>
				
				<td><a href="pieteikums.asp?pid=<?=$row["id"]?>" target="none"><?=$row["info"]?>.</a></td>
				<td align = right><?=Curr3Print($row["summaLVL"],$row["summaUSD"],$row["summaEUR"])?></td>
				<td align = right><?=Curr3Print($row["iemaksasLVL"]-$row["izmaksasLVL"],$row["iemaksasUSD"]-$row["izmaksasUSD"],$row["iemaksasEUR"]-$row["izmaksasEUR"])?></td>
				<td align = right><?=Curr3Print($row['starp']["LVL"],$row['starp']["USD"],$row['starp']["EUR"])?></td><?
				
				?>
				</tr>
			<?
				}
			}
		?>
		<tr bgcolor = "#ffc1Ac">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<? $kops = $data['data']['kopsummas'];
		?>
			<td align = right><?=Curr3Print($kops['SummaLVL'],$kops['SummaUSD'],$kops['SummaEUR'])?></td>
			<td align = right><?=Curr3Print($kops['IemaksatsLVL'],$kops['IemaksatsUSD'],$kops['IemaksatsEUR'])?></td>
			<td align = right><?=Curr3Print($kops['AprekinatsLVL'],$kops['AprekinatsUSD'],$kops['AprekinatsEUR'])?></td>
		</tr>
	</table>
	 <? // Use default styling/automatic generation
		if (isset($pagination))echo $pagination->getLinksHtml("c_agenti_stat.php", "pg");

		// custom styling
		//for($i=1; $i<=$pagination->getNumPages(); $i++) {
			//etc etc
		//}
		?>
	</div>
	</div>
	</div>

</body>
</html>
