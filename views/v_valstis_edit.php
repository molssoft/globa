<?require_once("i_functions.php");
require_once("i_decode.php");

Docstart ("Valsts rediìçðana","y1.jpg",'bootstrap');
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Valsts rediìçðana</b></font></center><hr>

<?
Headlinks();
?>
<div class="wrapper">
	<div class="row">
		<div class="col-lg-5 offset-lg-4 mt-4 pb-3">
			<form action="c_valstis.php?f=update" method="POST" class="pr-3 pl-3">

                <div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >ID: </label>	
					<div class="col-md-5 text-left">
						<input readonly name="id" class="form-control" type="text" value="<?= Decode($data["ID"])?>" >
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Slug: </label>	
					<div class="col-md-5 text-left">
						<input name="slug" class="form-control" type="text" value="<?= Decode($data["slug"])?>" >
					</div>		
				</div>
                <div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Meta apraksts: </label>	
					<div class="col-md-5 text-left">
						<textarea name="meta_desc" class="form-control" type="text" rows=5><?= Decode($data["meta_desc"])?></textarea>
					</div>		
				</div>

		
				<center>
					<button  type="submit" class="save btn btn-success" value=""> Saglabât </button>
					<a  class="btn " href="c_valstis.php?f=index" name="cancel" >Atcelt</a>
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