<? if (!$_SESSION['init']) die('Error:direct access denied');?>

<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_register_steps.php');?>
			
			<div style="height:30px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_register.php?f=name">
				<div class="row">
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
				</div>
			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>


</html>

