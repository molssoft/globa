<?require_once("i_functions.php");

Docstart ("Pievienot aìentu","y1.jpg",'bootstrap');
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Pievienot aìentu</b></font><hr>

<?
Headlinks();
?>
<div class="wrapper">
	<div class="row">
		<div class="col-lg-5 offset-lg-4 mt-4">
			<form action="c_agenti.php?f=addAgents" method="POST"  class="pl-3 pr-3">
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Aktîvs: </label>
					<div class="col-md-5 text-left pt-2">
						<input name="aktivs" type="checkbox" >
					</div>
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Pilsçta: </label>
					<div class="col-md-5 text-left">
						<input name="pilseta" class="form-control" type="text" >
					</div>						
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Vârds: </label>	
					<div class="col-md-5 text-left">
						<input name="vards" class="form-control" type="text" >
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Debets: </label>
					<div class="col-md-5 text-left">
						<input name="dkonts" class="form-control" type="text" >
					</div>		
				</div>
				<div class="form-group row">
					<label class="col-md-4 col-sm-12 col-form-label  text-right" >Kredîts: </label>						
					<div class="col-md-5 text-left">
						<input name="ckonts" class="form-control" type="text" >
					</div>		
				</div>
				
				
		
		
		
	<center>
		<button  type="submit" class="save btn btn-success" value=""> Saglabât </button>
		<a  class="btn " href="c_agenti.php?f=index" name="cancel" >Atcelt</a>
</form>
</div>
</div>
</div>
<style>
@media (max-width: 767px) {
    label.text-right { text-align:left!important }
}
</style>
