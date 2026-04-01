<? if (!$_SESSION['init']) die('Error:direct access denied');?>

<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<? include 'i_register_fb_track.php'?>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<!--<script src="https://code.jquery.com/jquery-1.12.4.js" ></script>-->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="js/datepicker-lv.js" ></script>
	
	<body>
		
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_register_steps.php');?>
			
			<div style="height:30px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4 " method="post" action="c_register.php?f=name" style="margin-bottom:25px">
				<div class="row  ">
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				
				<div class="col-sm-12">
					<h2>Personas dati</h2>
				
				<!--<div class=error><?=$data['message']?></div>-->
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="vards">Vârds</label>
					<input name="vards" class="form-control" placeholder="" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="vards" style="text-transform:uppercase" autocomplete="off">
				</div>
				
				<div class="col-sm-12">
					<label for=uzvards>Uzvârds</label>
					<input name="uzvards" class="form-control col-md-2" placeholder="" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="uzvards" style="text-transform:uppercase" autocomplete="off">
				</div>
					
				<div class="col-sm-12">
					<label for="pk1">Personas kods</label>
				</div>
				<div class="col-sm-6">
					<input name="pk1" class="form-control" placeholder="1. daïa" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="pk1" maxlength="6" autocomplete="off">
				</div>
				<div class="col-sm-6">
					<input name="pk2" class="form-control col-sm-2" placeholder="2. daïa" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="pk2" maxlength="5" autocomplete="off">
				</div>
				<? if (isset($data['values']['dzimsanas_datums'])){?>
				<div class="col-sm-12">
					<label for="birth_date">Dzimðanas datums</label>
				</div>
				<div class="col-sm-12">
					<input  class="form-control" value="" autofocus id="dzimsanas_datums" name="dzimsanas_datums" placeholder="dd.mm.GGGG" readonly>		
				</div>
				<?}?>
				<div class="col-sm-12">
					<label for=dzimta>Dzimums</label>
					<select name="dzimta" class="form-control col-sm-12">
						<option></option>
						<option value=s>Sieviete</option>
						<option value=v>Vîrietis</option>
					</select>
				</div>
				
				<!--
				<div class="col-sm-12">
					<label for="user_piezimes">Piezîmes vai îpaðas vajadzîbas</label>
				</div>
				<div class="col-sm-12">
					<textarea class="form-control" value="" autofocus id="user_piezimes" name="user_piezimes" placeholder="Piezîmes vai îpaðas vajadzîbas"></textarea>	
				</div>
				-->
				
				<? if (isset($_SESSION['username'])){ $button= 'Saglabât';}
				else {$button = 'Turpinât';}
				?> 
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block" type="submit"><?=$button;?></button>
				</div>
				<?if (isset($_SESSION['username'])){?>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
				<?}?>
				</div>	
			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>

<!--<link media="screen" type="text/css" href="css/bootstrap-datepicker.min.css" rel="stylesheet">
<script type="text/javascript" src="js/bootstrap-datepicker.min.js"></script>-->

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">

  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Dzimðanas datums</h4>
      </div>
      <div class="modal-body col-sm-4 col-sm-offset-4">
		  <form method="POST" action="c_register.php?f=name">
			<input type="hidden" name="subm" value="2">
			<label for="dzimsanas_datums">Dzimðanas datums<!--<span class="visible-xs">Dzimðanas datums</span>--></label>
			
			<input name="dzimsanas_datums" class="form-control datepicker" value="<?=$data['dzimsanas_datums'];?>"								
				autofocus id="" placeholder="dd.mm.GGGG" required>
			
		
			 <button class="btn btn-primary btn-block" type="submit">Saglabât</button>
		</form>
      </div>
      <div class="modal-footer ">
       <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
       
					
      </div>
    </div>
  </div>
</div>
</html>
<? if( isset($_SESSION['profili_id'])){
	$disable_bday = 1;
}
else $disable_bday = 0;
?>
<script type="text/javascript">
$(document).ready(function() {


 $( ".datepicker").datepicker({
        format: "dd.mm.yyyy",
        weekStart: 1,
        startDate: "now",
        maxViewMode: 2,
        language: "lv",		
		changeMonth: true,
		changeYear: true,
		maxDate: '0',
		yearRange: "-100:+0", // last hundred years
		//showButtonPanel: true
    });
})
	
</script>
