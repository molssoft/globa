<? if (!$_SESSION['init']) die('Error:direct access denied');?>

<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	
	<body>
		<script
		  src="https://code.jquery.com/jquery-3.1.1.min.js"
		  integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
		  crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
		<script src="js/jquery-birthday-picker.js"></script>
		
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_register_steps.php');?>
			
			<div style="height:30px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_register.php?f=name">
				
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
						required autofocus id="vards" style="text-transform:uppercase">
				</div>
				
				<div class="col-sm-12">
					<label for=uzvards>Uzvârds</label>
					<input name="uzvards" class="form-control col-md-2" placeholder="" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="uzvards" style="text-transform:uppercase">
				</div>
					
				<div class="col-sm-12">
					<label for="pk1">Personas kods</label>
				</div>
				<div class="col-sm-6">
					<input name="pk1" class="form-control" placeholder="1. daïa" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="pk1" maxlength="6">
				</div>
				<div class="col-sm-6">
					<input name="pk2" class="form-control col-sm-2" placeholder="2. daïa" value=""
						<? if (isset($_SESSION['profili_id'])) echo ' readonly '; ?>
						required autofocus id="pk2" maxlength="5">
				</div>
				<div class="col-sm-12">
					<label for="birth_date">Dzimðanas datums</label>
				</div>
					<div class="col-sm-12 ">
						<div id="birthdayPicker" >
					</div>
					<input type="hidden" name="hidden_b[day]" value="<?=$birth_array['day'];?>">
					<input type="hidden" name="hidden_b[month]" value="<?=$birth_array['month'];?>">
					<input type="hidden" name="hidden_b[year]" value="<?=$birth_array['year'];?>">
				</div>
				
				<div class="col-sm-12">
					<label for=dzimta>Dzimums</label>
					<select name="dzimta" class="form-control col-sm-12">
						<option></option>
						<option value=s>Sieviete</option>
						<option value=v>Vîrietis</option>
					</select>
				</div>
				
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

			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>
</html>
<? if( isset($_SESSION['profili_id'])){
	$disable_bday = 1;
}
else $disable_bday = 0;
?>
<script type="text/javascript">
$(document).ready(function() {
    $("#birthdayPicker").birthdayPicker({
		
		monthFormat:'long' ,
		maxAge: 110,  
		sizeClass:'col-sm-4',
		dateFormat : "littleEndian",
		
	});
	/*$(".birthDate").attr('id','birthDay');
	$(".birthMonth").attr('id','birthMonth');
	$(".birthYear").attr('id','birthYear');
*/
	$("select.birthDate").val('<?=$birth_array['day'];?>'); 
	$("select.birthMonth").val('<?=$birth_array['month'];?>'); 
	$("select.birthYear").val('<?=$birth_array['year'];?>'); 
	$("select.birthDate").addClass("form-control col-sm-4");
	$("select.birthDate").css({"width":"25%"});
	$("select.birthMonth").addClass("form-control col-sm-4");
	$("select.birthMonth").css({"width":"40%"});
	$("select.birthYear").addClass("form-control col-sm-4");
	$("select.birthYear").css({"width":"35%"});
	$("fieldset.birthPicker").addClass("row");
	$("fieldset.birthPicker").css({"width":"100%"});

	if (<?=$disable_bday?>){
		$("fieldset").attr("disabled", true); 
	}
})
	
</script>
