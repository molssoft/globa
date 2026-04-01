<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Autobusa laboðana","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Autobusa bilþu pievienoðana</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>

	
<div align="center">		
						<form accept-charset="UTF-8"
							class="form-horizontal" method="post"
							autocomplete="off"
							enctype="multipart/form-data">
							
							<input type=hidden name="post" value="1">
												
							<div class="form-group">
								<label class="control-label col-sm-3">Faili:</label>
								<div class="col-sm-4">
									<input autocomplete="off" type="file" name="file_array[]" class="form-control" style="padding:0;" multiple>
								</div>
							</div>
							
							<div class="col-sm-offset-3 col-sm-8" style="margin-top:10px;">
							 <input type=image src="impro/bildes/diskete.jpg" alt="Saglabât izmaiòas.">
								<!--a href="<?=base_url("estate/edit/$estate_id/$token")?>"><span type="button" class="btn btn-primary " onclick="return confirm('Vai tieðâm vçlaties atcelt attçlu pievienoðanu?');">
										Atgriezties</span></a-->
							</div>
						</form>
</body>
</html>