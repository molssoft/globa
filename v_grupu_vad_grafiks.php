<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Grupu vadîtâju grafiks","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Grupu vadîtâju grafiks</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<form name="forma"id="gr_vad_grafiks_form"action = "" method = "GET">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
	
	<select id="sel_menesis" name="datums">
	<?php
	$curr_date = strtotime(date('Y-m-01')); // first day of current month

	for ($i = 1; $i <= 12; $i++) {
		$y_curr = date("Y", $curr_date);
		$m_curr = date("n", $curr_date);
	?>
		<option value="<?=$y_curr?>_<?=$m_curr?>" <?php if ($datums == $y_curr."_".$m_curr) echo "selected"; ?>>
			<?=$y_curr?>.gada <?=$data['menesis'][$m_curr]?>
		</option>
	<?php
		$curr_date = strtotime("+1 month", $curr_date);
	}
	?>
	</select>
</form>
<table>
	<tr>
		<th style="width:200px"></th>
		<?
		for ($d=1;$d<=$data['days_in_month'];$d++){
			?>
			<th style="width:25px"><?=$d?>.</th>
			<?
		}

	?>
	</tr>
	<?
foreach ($data['grafiks'] as $vaditajs=>$row){
	$tmp = explode("_",$vaditajs);
	$vad_nos = $tmp[1];
	?>
	<tr>
		<th align="right"><?=$vad_nos;?></th><?

	
		foreach($row as $d=>$aiznemts_grupa){
			$tmp = explode("_",$aiznemts_grupa);
			$gid = $tmp[0];
			$gr_nos = $tmp[1];
			$bg = "background-color:	#5cb85c";
			if ($aiznemts_grupa) $bg = "background-color:#d9534f";
				?><td style="width:20px;<?=$bg?>" >
				<? if ($aiznemts_grupa){ ?>
				<a href="grupa_edit.asp?gid=<?=$gid?>" target="_blank" title="<?=$gr_nos?>"> &nbsp </a>
				<?} else {?>
				&nbsp
				<? } ?>
				</td><?
		} 
		echo "</tr>";
}
?>
</table>
<style>
	td a {
		display:block;
		width:100%;
	}
</style>
<script>
$(function(){
	 $("#sel_menesis").on("change",function(){
		this.form.submit(); 
	});
}) 
</script>
</body>
</html>