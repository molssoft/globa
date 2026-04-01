<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<!--<script src="https://code.jquery.com/jquery-1.12.4.js" ></script>-->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="js/datepicker-lv.js" ></script>
	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
			
			<? include 'i_register_steps.php'?>
			
			<div style="height:50px"></div>
			<BR>

			<form class="form-signin col-md-6 col-md-offset-3" method="post" action="c_register.php?f=passport" style="margin-bottom:25px">
				<div class="row">
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="col-sm-12 text-center">
					<h1>Dokuments</h1>
				
				<div class=error><? if (isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<!--<div class="col-sm-12">
					<label for="document_type">Dokumenta veids</label>
					<select name="document_type" class="form-control">
						<option></option>
						<option value="passport">Pase</option>
						<option value="id_card">ID karte</option>
					</select>
				</div>-->
				<div class="col-sm-12">
					<label for="dokuments"></label>
				</div>
				<div class="row">
					<div class="col-md-6 col-sm-12">
						<label >Pases numurs</label>
						<input name="paseNR" class="form-control col-sm-2" value=""
							autofocus id="paseNR" style="text-transform:uppercase" autocomplete="off">
						<label for="paseNR"></label>
					</div>
					<div class="col-md-6 col-sm-12">	
						<label >Derîguma termiòð</label>
						<input name="paseDERdat" class="form-control datepicker" value=""
							 autofocus id="paseDERdat" placeholder="dd.mm.GGGG" autocomplete="off">
						<label for="paseDERdat"></label>
					</div>
		</div>
				<!--<div class="col-sm-4">
					<input name="paseS" class="form-control" value=""
						 autofocus id="paseS">
				</div>-->
				
				
				
			<div class="row">
					<div class="col-md-6 col-sm-12">
						<label >Personas apliecîbas nr.</label>
						<input name="idNR" class="form-control col-sm-2" value=""
							 autofocus id="idNR" style="text-transform:uppercase" autocomplete="off">
						<label for="idNR"></label>
					</div>
					<div class="col-md-6 col-sm-12">
						<label >Derîguma termiòð</label>
						<input name="idDerDat" class="form-control datepicker" value=""
							autofocus id="idDerDat" placeholder="dd.mm.GGGG" autocomplete="off">
						<label for="idDerDat"></label>
					</div>
				</div>
				</div>
				<!--<div class="col-sm-4">
					<input name="idS" class="form-control" value=""
					 autofocus id="idS">
				</div>-->
				
				
				<? if (isset($_SESSION['username'])){ $button= 'Saglabât';}
				else {$button = 'Turpinât';}
				?> 
			
				<div class="col-sm-12 col-md-9 col-md-offset-2">
					<div class="btn-toolbar" style="margin-top:10px;">
						<button class="btn btn-primary btn-block" type="submit"><?=$button;?></button>
					</div>
						<?if (isset($_SESSION['username'])){?>
					<div class=" btn-toolbar" style="margin-top:10px;">
						<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
					</div>
				</div>
			
				<?}?>
			</div>
			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>


</html>

<!--<link media="screen" type="text/css" href="css/bootstrap-datepicker.min.css" rel="stylesheet">
<script type="text/javascript" src="js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript" src="js/bootstrap-datepicker.lv.min.js" ></script>-->

<!--
<link media="screen" type="text/css" href="css/jquery-ui.css" rel="stylesheet">
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/jquery.ui.datepicker-lv.js?v=1"></script>-->
<script>
$( document ).ready(function() {
	//$( "#datepicker" ).datepicker({ dateFormat: "dd/mm/yy" });
	//$( ".datepicker" ).datepicker({ dateFormat: "dd.mm.yy" });
	  $( ".datepicker").datepicker({
        format: "dd.mm.yyyy",
        weekStart: 1,
        startDate: "now",
        maxViewMode: 2,
        language: "lv",		
		changeMonth: true,
		changeYear: true,
		minDate: '0'
    });
});
</script>

