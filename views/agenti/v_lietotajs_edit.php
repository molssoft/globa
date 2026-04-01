<?require_once("i_functions.php");

Docstart ($data['title'],"y1.jpg",'bootstrap');
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Lietotâjs</b></font><hr>

<?
Headlinks();
?>
<div class="wrapper">
	<div class="row">
		<div class="col-lg-5 offset-lg-4 mt-4">
			
			<form action="<?=$data['form_action'];?>" method="POST"  class="pl-3 pr-3">				
		
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >ID: </label>
					<div class="col-md-5 text-left pt-2">
						<?= $data["lietotajs"]["id"]?>		
					</div>					
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Lietotâjs: </label>
					<div class="col-md-5 text-left">
						<input name="lietotajs" class="form-control" type="text" value="<?= $data["lietotajs"]["Lietotajs"]?>">
					</div>						
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Vârds: </label>	
					<div class="col-md-5 text-left">
						<input name="vards" class="form-control" type="text" value="<?= $data["lietotajs"]["vards"]?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Uzvârds: </label>
					<div class="col-md-5 text-left">
						<input name="uzvards" class="form-control" type="text" value="<?= $data["lietotajs"]["uzvards"]?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >E-pasts: </label>						
					<div class="col-md-5 text-left">
						<input name="epasts" class="form-control" type="text" value="<?= $data["lietotajs"]["epasts"]?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Parole: </label>
					<div class="col-md-5 text-left">
						<input name="parole" class="form-control" type="text" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Aktîvs: </label>
					<div class="col-md-5 text-left pt-2">
						<input name="aktivs" type="checkbox" <?if($data["lietotajs"]["active"] == 1) echo "checked";?>>
					</div>
				</div>
		
		
		
				<center>
				<button  type="submit" class="save btn btn-success" value=""> Saglabât </button>
				<a  class="btn " href="c_agenti.php?f=lietotajiView&id=<?= $data["aid"]?>" name="cancel" >Atcelt</a>
			</form>
		</div>
	</div>
</div>

<style>
@media (max-width: 767px) {
    label.text-right { text-align:left!important }
}
</style>