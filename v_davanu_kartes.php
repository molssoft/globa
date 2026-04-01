<?require_once("i_functions_utf.php");

//standarts visām lapām
Docstart ("Dāvanu kartes","");
?>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Dāvanu kartes</b></font><hr>

<?
// standarta saites 
Headlinks();
?>
<br>
<form name="forma" id="forma" action = "" method = "POST">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
	<div align="center"><center>
	<table border="0">
        <tr>
            <td align="right" class="td-filter-label">Pirkuma datums no: </td>
            <td class="td-filter-input"><label for="datums_no"></label>
			<input type="text" size="16" id="datums_no" maxlength="80"
            name="datums_no" value="" placeholder="dd.mm.YYYY"></td>
        </tr>
        <tr>
            <td align="right" class="td-filter-label">Pirkuma datums līdz: </td>
            <td class="td-filter-input"><label for="datums_lidz"></label>
			<input type="text" size="16" name="datums_lidz" id="datums_lidz" placeholder="dd.mm.YYYY"value=""></td>
        </tr>
        <tr>
            <td align="right" class="td-filter-label">D.k. Nr.: </td>
            <td class="td-filter-input">
				<label for="dk_numurs"></label>
				On-<input type="text" size="12" maxlength="80"
				name="dk_numurs" id="dk_numurs"value="" >
			</td>
        </tr>
        <tr>
            <td align="right" class="td-filter-label">D.k. drošības kods: </td>
            <td class="td-filter-input">
				<label for="dk_kods"></label>
				<input type="text" size="16" name="dk_kods" id="dk_kods" value="">
      	</tr>
		<tr>
			<td align="right" class="td-filter-label">Pieprasits rēķins: </td>
			<td class="td-filter-input">
				<label for="requested_only"></label>
				<input type="checkbox" name="requested_only" id="requested_only" value="1" <?php if (!empty($data['values']['requested_only'])) echo 'checked'; ?>>
				
			</td>
		</tr>
	</table>
	<BR>
	<input type="submit" name="submit" value="Meklēt" class="btn-normal">
	<div id="search_form_error" style="color:#b00; margin-top:8px; display:none;">Ievadiet meklēšanas kritērījus</div>
</form>
<br>
<br>
<script>
(function() {
	var form = document.getElementById('forma');
	if (!form) return;

	var fieldIds = ['datums_no', 'datums_lidz', 'dk_numurs', 'dk_kods'];
	var err = document.getElementById('search_form_error');

	form.addEventListener('submit', function(e) {
		var hasValue = false;
		for (var i = 0; i < fieldIds.length; i++) {
			var el = document.getElementById(fieldIds[i]);
			if (el && el.value && el.value.trim() !== '') {
				hasValue = true;
				break;
			}
		}
		var requestedOnly = document.getElementById('requested_only');
		if (requestedOnly && requestedOnly.checked) {
			hasValue = true;
		}

		if (!hasValue) {
			e.preventDefault();
			if (err) err.style.display = 'block';
			return false;
		}

		if (err) err.style.display = 'none';
		return true;
	});
})();
</script>
<? 

if (isset($data['dk'])){
	require_once("online2/i_functions_utf.php");?>
<center>
  Atrasto pieteikumu skaits <?=count($data['dk']);?>
  <table border = 1 id="atrasts">
	<tr>
		<th>Piet.Nr.</th>
		<th>Pirkuma datums</th>
		<th>D.k.summa</th>
		<th>D.k.Nr</th>
		<th>D.k.kods</th>
		<th>Apraksts</th>
		<th>Bilance</th> 
		<th>Rēķins</th> 
		<th></th> 
	</tr>
  <? foreach ($data['dk'] as $dk){
	  //--------------------
	  //19.12.2019 RT:
	  //ja dk ir att?lota, bet tai nav iemaksu, to att?lo sarkanu:
	  //-----------------------

	  $row_class = "";
	  
	  
	  $online_rez = $piet->OnlineRez($dk['id']);
	  
	  if (!$piet->HasPayment($dk['id']) && $online_rez['dk_attelota']==1){
		  $row_class = "row-no-payments";
	  }
		  ?>
	  <tr class="<?=$row_class;?>">
		<td><a href="pieteikums.asp?pid=<?=$dk['id'];?>" target="_blank"><?=$dk['id'];?></a></td>		
		<td><?=$db->Date2Str($dk['datums']);?></td>
		<td align=right><?=CurrPrint($dk['dk_summa']);?></td>
		<td><? if (!empty($dk['dk_serija'])) echo $dk['dk_serija'].'-';?><?=$dk['dk_numurs'];?></td>
		<td><?=$dk['dk_kods'];?></td>
		<td><?=_utf($dk['info']);?></td>
		<td align=right><?=CurrPrint($dk['bilanceEUR']);?></td>
		<td>
			<? 

				if (!empty($dk['invoice_status'])) {
					if ($dk['invoice_status'] === 'requested') {
						$pid = (int)$dk['id']; // pieteikums.id (used by c_invoice.php?id=...)
						echo "<a href='c_davanu_kartes_rekins.php?pid={$pid}'>Pieprasīts</a>";
						echo " | <a href='c_davanu_kartes.php?cancel_invoice=1&pid={$pid}' onclick=\"return confirm('Vai tiešām atcelt rēķina pieprasījumu?');\">Atcelt</a>";
					} elseif ($dk['invoice_status'] === 'sent') {
						echo 'Nosūtīts';
					} else {
						echo htmlspecialchars($dk['invoice_status']);
					}
				}
			?>
		</td>
		<? 
			if ($_GET['pid']!='') echo "<td><a href='operacija.asp?nopid=".$dk['id']."&pid=".$_GET['pid']."&did=-1'>Pārskaitīt]</a></td>";
		?>
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>