<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>


	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" id="forma" action="?f=Travel">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<!--	<div class="row col-md-10 col-md-offset-1">
				<? /*if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
					<script src="js/CountDown.js"></script>
				
					<p align="right" >Laiks rezervâcijas veikðanai: <span id="CountDownPanel" ></span></p>
				<?}*/?>
				</div>-->
				<div class="row">
				<div class="col-sm-12">
					<h2>Ceïojums</h2>
				</div>
				</div>
				<? if (isset($_SESSION['error_already_registered'])){
					?>
					<div class="alert alert-danger"><?=$_SESSION['error_already_registered'];?></div>
					<?
					unset($_SESSION['error_already_registered']);
				}?>
				<!--<div class=error><?=$data['message']?></div>-->
					<div class="row" >
				<div class="col-sm-12"  >
				<label for=travel></label>
				</div>
				<div class="col-sm-12" >
			<!--</div>
				<div class="col-sm-12">
					<div class="col-sm-4">-->
					<select name="travel" class="form-control primary selectpicker" data-container="travel" placeholder="" value="" 
						data-live-search="true"
						required autofocus id="travel" >
						<option></option>
						<? foreach ($data['celojumi'] as $celojums){
							//var_dump($celojums);
							?>
						<option <? if (isset($data['travel']) && $data['travel']==$celojums['grupa']['ID']) echo "selected";?> value="<?=$celojums['grupa']['ID'];?>"><?=$celojums['grupa']['sakuma_dat'].' '.$celojums['marsruts']['v'];?>   &nbsp Brîvs:<? if ($celojums['grupa']['vietas'] >7 ) echo ">7"; else echo $celojums['grupa']['vietas'];?></option>
						<?}?>
					</select>
				</div>
				</div>
				<!--</div>-->
				
				
				<div class="row">
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
						<a class="btn btn-block btn-default" href="?f=TravellerCount" style="background-position:0 0">Atgriezties</a>
						<br>
						<br>
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=TravellerCount" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Travellers" style="background-position:0 0">>> </a>
							</div>
						<br>
						<br>
						<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
					<?}
					if (!$data['ir_iemaksas']){
						include("v_cancel_reservation.php");	
					}
					?>
				</div>
				</div>

			</form>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>
<? if (!$data['var_labot']){?>
<script>
$("#travel").attr({title:$("#travel").text()});

$("#forma :input").attr("disabled", true);
</script>
<?}else{?>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css">

	<!-- Latest compiled and minified JavaScript -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/bootstrap-select.min.js"></script>
	<!-- (Optional) Latest compiled and minified JavaScript translation files -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/js/i18n/defaults-lv_LV.min.js"></script>
	
	<script>
	// opcijas: https://silviomoreto.github.io/bootstrap-select/options/
	$( document ).ready(function() {
		$('#travel').selectpicker({
		  style: 'form-control',
		  size: 10,
		  noneSelectedText: 'Izvçlçties ceïojumu'
		  
		 
		});
	});

	</script>
	<style>
	.form-control.bootstrap-select{
		outline:2px solid #f5e79e;
	}
	.dropdown-menu>.active>a, .dropdown-menu>.active>a:focus, .dropdown-menu>.active>a:hover {
    background-color: green;
		
	}
	.bootstrap-select:not([class*=col-]):not([class*=form-control]):not(.input-group-btn) {
		width: auto;
	}
	
	.dropdown-menu{
		max-width:50vw;
		
	}
	
	</style>
<?}?>

