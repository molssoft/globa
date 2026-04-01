<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Ceïojuma apraksts","y1.jpg");
DefJavaSubmit();?>
<? if (isset($data['script'])){
	echo $data['script'];
}?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Ceïojuma apraksts</b></font><hr>

<?
// standarta saites
 
Headlinks();

 

 

?>
<br>

<? include 'online2/i_handler_values.php'?>
<? include 'online2/i_handler_errors.php'?>
<div align="center"><center>
<font color="GREEN" size="4"><b><?=$data['celojums'];?></b></font>
</center>
<br>
<br>
<? if (!empty($data['apraksts']) ){?>
<form action="c_celojuma_apraksts.php" method="post" id="dzest" enctype="">

	<a href="http://www.impro.lv/pdf/<?=$data['apraksts'];?>.pdf" target="_blank"><b><?=basename($data['apraksts']);?>.pdf</b></a>
	<input type="hidden" name="gid" value="<?=$data['gid'];?>" />
	<input type="hidden" name="delete" value="1"/>
	<img alt="Noòemt aprakstu" title="Noòemt aprakstu" src="impro/bildes/dzest.jpg" onclick="if (confirm('Vai tieðam vçlaties noòemt grupai aprakstu?')){$('#dzest').submit()};" WIDTH="25" HEIGHT="25"/>
	<!--<input type="submit"  name = "delete" onclick="return confirm('Vai tieðam vçlaties noòemt grupai aprakstu?');" value="Noòemt aprakstu" />-->
	</form>
<?}
else{?>
<form action="c_celojuma_apraksts.php" method="post" id="upload" enctype="multipart/form-data">
<label for="file">Izvçlieties failu augðupielâdei:</label>
<br>
	<input type="file" id="file" name="file" size="50" required />

	<input type="hidden" name="gid" value="<?=$data['gid'];?>" />
	<input name="upload" value="1" type="hidden">
	<img src="impro/bildes/saglabat.jpg" alt="Augðupielâdçt" title="Augðupielâdçt" onclick="$('#upload').submit()" />
	<!--<input type="submit"  name = "submit" value="Augðupielâdçt" />-->
	</form>
		<br>
	<br>
	<font color="red">VAI</font>
		<br>
	<br>
	<form action="c_celojuma_apraksts.php" method="post" id="link" enctype="multipart/form-data">
	<label for="tags">Izvçlçties jau augðupielâdçtu failu: </label>
	<br>
	<select id="tags" name="apraksts" required>
		<option></option>
	<?foreach($data['esosie_apraksti'] as $pdf){
		if (strpos($pdf, '.pdf') !== false) {
			?><option value="<?=$pdf;?>"><?=$pdf;?></option>
			<?
		}
	}?>
	</select>

	<input type="hidden" name="gid" value="<?=$data['gid'];?>" />
<input name="link" value="1" type="hidden">
<img src="impro/bildes/saglabat.jpg" alt="Saglabât" title="Saglabât" onclick="$('#link').submit()" />
<!--	<input type="submit"  name = "link" value="Saglabât" />-->
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
  <script>
  $( function() {
    var availableTags = [<?
	foreach($data['esosie_apraksti'] as $pdf){
		echo '"'.$pdf.'",';
	}?>
    ];
    $( "#tags" ).select2({
     
    });
  } );
  </script>


  
</form>
<?}?>
	




<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>


</body>
</html>