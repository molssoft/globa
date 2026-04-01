<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Online apmaksas veidi","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Online apmaksas veidi</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<p><small>Ja vçlaties Online vidç atslçgt iespçju samaksât, izmantojot kâdu no maksâjumu veidiem, lûdzu, izòemiet íeksi no attiecîgâ apmaksas veida un nospiediet pogu <i>Saglabât izmaiòas</i>.<br>Lai to atkal pieslçgtu, ielieciet íeski atpakaï un atkal nospiediet pogu.</small></p>

<form name="forma" id="forma" action = "?" method = "POST" style="width:400px">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
<div align="left">
	

<? foreach ($data as $key=>$row){
	$checked="";
	$style="color:red";
	if ($row['valu']){
		$checked = 'checked';
		$style="";
	}
	?>
	<label style="<?=$style;?>"><input type="checkbox" name="variable[<?=$row['variable'];?>]" <?=$checked?> /><?=$key;?></label><br>
	<?
	//print_r($row);
}?>

<br>
		<input type="submit" name = "submit" value="Saglabât izmaiòas">
		<br>
		<br>
		
      <a target = none href = "c_online_settings.php?f=Vesture"><img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît izmaiòu vçsturi."></a>
	



	</form>
<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<script>
$("#forma").on("submit",function(){
	return confirm('Vai tieðâm vçlaties saglabât izvçlçtos iestatîjumus?');
})
</script>
</body>
</html>