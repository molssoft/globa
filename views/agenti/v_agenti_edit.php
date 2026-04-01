<?require_once("i_functions.php");
require_once("i_decode.php");

Docstart ("A?enti","y1.jpg",'bootstrap');
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>A?enti</b></font></center><hr>

<?
Headlinks();
?>
<div class="wrapper">
	<div class="row">
		<div class="col-lg-5 offset-lg-4 mt-4 pb-3">
			<form action="c_agenti.php?f=updateAgents&id=<?=$data["id"]?>" method="POST" class="pr-3 pl-3">
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Aktîvs: </label>
					<div class="col-md-5 text-left pt-2">
						<input name="aktivs" type="checkbox"<? if($data["aktivs"] == "1") echo "checked"; else echo "unchecked";?> >
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Pilsçta: </label>
					<div class="col-md-5 text-left">
						<input name="pilseta" class="form-control" type="text" value="<?= Decode($data["pilseta"])?>">
					</div>						
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Vârds: </label>	
					<div class="col-md-5 text-left">
						<input name="vards" class="form-control" type="text" value="<?= Decode($data["vards"])?>" >
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right">Debets: </label>
					<div class="col-md-5 text-left">
						<input name="dkonts" class="form-control" type="text"  value="<?= Decode($data["dkonts"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Kredîts: </label>						
					<div class="col-md-5 text-left">
						<input name="ckonts" class="form-control" type="text"  value="<?= Decode($data["ckonts"])?>" >
					</div>		
				</div>
				<a href="#" class="delete" style="display:none" onclick="Delete(<?= $data["id"]?>)">Dzçst</a>
			
	
				<hr>
				<center><font color="GREEN" size="3"><b>Aìenta lîguma informâcija</b></font></center>
				<br>

				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Lîguma slçgðanas vieta: </label>
					<div class="col-md-5 text-left">
						<input type="text" class="form-control"  name="liguma_vieta" value="<?=Decode($data["liguma_vieta"])?>">
					</div>						
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Lîguma datums: </label>	
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="liguma_datums" value="<?if(!isset($data["liguma_datums"])) echo "";else echo $data["liguma_datums"]->format("d.m.Y");?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Lîguma numurs: </label>
					<div class="col-md-5 text-left">
						<input type="text" class="form-control"  name="liguma_nr" value="<?if(!isset($data["liguma_nr"])) echo "";else echo $data["liguma_nr"]?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Uzòçmums: </label>						
					<div class="col-md-5 text-left">
						<input type="text"  class="form-control" name="uznemums" value="<?=Decode($data["uznemums"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Reì. nr. : </label>						
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="regnr" value="<?=Decode($data["regnr"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Adrese: </label>						
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="adrese" value="<?=Decode($data["adrese"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Tûr. Reì. nr.: </label>						
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="tur_regnr" value="<?=Decode($data["tur_regnr"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Uz ... pamata: </label>						
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="liguma_pamats" value="<?=Decode($data["liguma_pamats"])?>">
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Pârstâvis: </label>						
					<div class="col-md-5 text-left">
						<input type="text" class="form-control" name="parstavis" value="<?=Decode($data["parstavis"])?>">
					</div>		
				</div>
				
						
		
				<center>
					<button  type="submit" class="save btn btn-success" value=""> Saglabât </button>
					<a  class="btn " href="c_agenti.php?f=index" name="cancel" >Atcelt</a>
				</center>
			</form>
			<br>
			<center>
			<a href="c_agenti.php?f=LietotajiView&id=<?=$data['aid'];?>">Lietotâji</a>
		</div>
	</div>
</div>


<style>
@media (max-width: 767px) {
    label.text-right { text-align:left!important }
}
</style>
<script>

</script>