<?require_once("i_functions.php");
require_once("i_decode.php");

Docstart ("Vietu apraksta redi��sana","y1.jpg",'bootstrap');
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Vietu apraksta redi��sana</b></font></center><hr>

<?
Headlinks();
$isNew = empty($data) || empty($data["ID"]) && empty($data["id"]);
$idVal = ($isNew ? "" : (isset($data["ID"]) ? $data["ID"] : $data["id"]));
$nosaukumsVal = (isset($data["nosaukums"]) ? $data["nosaukums"] : "");
$aprakstsVal = (isset($data["apraksts"]) ? $data["apraksts"] : "");
?>
<div class="wrapper">
	<div class="row">
		<div class="col-lg-5 offset-lg-4 mt-4 pb-3">
			<form action="c_vietu_apraksti.php?f=<?= $isNew ? 'insert' : 'update'?>" method="POST" class="pr-3 pl-3">

				<? if(!$isNew){ ?>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >ID: </label>
					<div class="col-md-5 text-left">
						<input readonly name="id" class="form-control" type="text" value="<?= Decode($idVal)?>" >
					</div>
				</div>
				<? } ?>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Nosaukums: </label>
					<div class="col-md-8 text-left">
						<input name="nosaukums" class="form-control" type="text" value="<?= Decode($nosaukumsVal)?>" >
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Apraksts: </label>
					<div class="col-md-8 text-left">
						<textarea name="apraksts" class="form-control" rows=8><?= Decode($aprakstsVal)?></textarea>
					</div>
				</div>

				<center>
					<button  type="submit" class="save btn btn-success" value=""> Saglab�t </button>
					<a  class="btn " href="c_vietu_apraksti.php?f=index" name="cancel" >Atcelt</a>
				</center>
			</form>
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


