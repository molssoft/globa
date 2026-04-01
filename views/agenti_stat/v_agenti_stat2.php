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

<!--Princips: pirmoreiz pievienojas db un dabû aìentu sarakstu, lai bûtu, no kâ izvçlçties;
tâlak: ja forma ir izsaukusi pati sevi, tad notiek otrs konnekts pie bâzes un tiek atgriezti
ieraksti, kas raksturo konkrçto aìentu.
-->


<meta name="expires" value="0">
<center><font color="GREEN" size="5"><b>Aìentu statistika</b></font><hr>

<table cols="2" rows="5">
<form name="forma" method="POST" action="" border="1">
<tr>
<td align="right" bgcolor="#ffc1cc">Aìents: </td>
<td align="left" bgcolor="#fff1cc">	<!-------Sâkas pirmâs rindas labâ ðûna-----> 

	<?
	//------------- Selektç aìentus --------------
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
	<tr><td align="right" halign="center" bgcolor="#ffc1cc">Laikâ no: </td>
	<!-----otrâs rindas labâ ðûna-->
	<td align="left" bgcolor="#fff1cc">
	<input name="no" class=" datepicker" value="<?=$data['no'];?>"
											autocomplete="off" placeholder="dd.mm.GGGG"></td></tr>
	<!--Treðâ rinda--> 
	<tr><td align="right" halign="center" bgcolor="#ffc1cc">Lîdz: </td>
	<td align="left" bgcolor="#fff1cc"><input name="lidz" class=" datepicker" value="<?=$data['lidz'];?>"
											autocomplete="off" placeholder="dd.mm.GGGG"></td></tr>
	<!----------beidzas treðâ tabulas rinda------->
	<!------Ceturtâ rinda, pirmâ ðûna------->
	<tr><td align="right" bgcolor="#ffc1cc">Ðíirot pçc:<br></td>
	<td align="left" bgcolor="#fff1cc">
	<!--------------otrâ ðûna ceturtajâ rindâ-->
	<input type="radio" name="sortby" value="agents,isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))"<? if ($data['orderfield'] == "agents,isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))") echo "checked"; ?>> Aìenta<br>
	<input type="radio" name="sortby" value="isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))"<? if ($data['orderfield'] == "isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))" or $data['ordfield'] == "")  echo "checked"; ?>> Datuma<br>
	<input type="hidden" name="submit" value="1">
	</td></tr>

	<!------piektâ rinda--------->
	<tr><td colspan="2" align="center" valign="bottom" bgcolor="#fff1cc">
	&nbsp;<br><input type="submit" value="Izpildît!" name="poga">
	</td></tr>
	</form>
	</table>
	<!---------------------------------Formas un tabulas beigas------------------>
	
<?}else{ // ja aìentu bâzç nav?>
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
				<th>Datums</th>
				<th>Pieteikums</th>
				<th>Jâmaksâ</th>
				<th>Iemaksâts</th>
				<th>Aprçíinâts</th>
			</tr>
			<?
			
			$s = 0;
			foreach($data['data']['records'] as $row){

				// Increment
				$s++;?>
			<tr bgcolor = "#fff1cc">
				
				<td><?=$s?></td>
				<td><?= Decode($row["vards"])?></td>
				<td><?=$db->Date2Str($row["datums"])?></td>
				<td><a href="pieteikums.asp?pid=<?=$row["id"]?>" target="none"><?=$row["info"]?>.</a></td>
				<td align = right><?=Curr3Print($row["summaLVL"],$row["summaUSD"],$row["summaEUR"])?></td>
				<td align = right><?=Curr3Print($row["iemaksasLVL"]-$row["izmaksasLVL"],$row["iemaksasUSD"]-$row["izmaksasUSD"],$row["iemaksasEUR"]-$row["izmaksasEUR"])?></td>
				<td align = right><?=Curr3Print($row['starp']["LVL"],$row['starp']["USD"],$row['starp']["EUR"])?></td>
				
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
			
			<? $kops = $data['data']['kopsummas'];
		?>
			<td align = right><?=Curr3Print($kops['SummaLVL'],$kops['SummaUSD'],$kops['SummaEUR'])?></td>
			<td align = right><?=Curr3Print($kops['IemaksatsLVL'],$kops['IemaksatsUSD'],$kops['IemaksatsEUR'])?></td>
			<td align = right><?=Curr3Print($kops['AprekinatsLVL'],$kops['AprekinatsUSD'],$kops['AprekinatsEUR'])?></td>
		</tr>
	</table>
	 <? // Use default styling/automatic generation
		if (isset($pagination))echo $pagination->getLinksHtml("c_agenti_stat.php?f=stat2", "pg");

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