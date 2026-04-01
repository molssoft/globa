<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<?if (isset($data['script'])) echo $data['script'];?>
		<div class="container">

			<? include 'i_register_steps.php'?>
			
			<div style="height:50px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_register.php?f=email_new">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="col-sm-12">
					<h4>Autorizâcijas informâcija</h4>
				
				<div class=error><? if(isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="epasts">E-pasts</label>
					<input name="epasts" class="form-control" placeholder="" value=""
						required autofocus id="epasts" required>
				</div>
					
				
				
				
				<? if ($data['prasit_paroli']){?>
				<div class="col-sm-12">
					
					<label for="old_pass">Esoðâ parole</label>
					
				</div>
				<div class="col-sm-12">
					<input type=password name="old_pass" class="form-control" placeholder="esoðâ parole" value=""
						autofocus id="old_pass" required>
				</div>
				
				
				<?}
				else{
					?>
					<div class="col-sm-12">
					
					<label for="pass">Parole</label>
					
				</div>
					
			
				<div class="col-sm-12">
					<input type=password name="pass1" class="form-control" placeholder="parole" value=""
						autofocus id="pass1" >
				</div>
				<div class="col-sm-12">
					<input type=password name="pass2" class="form-control col-sm-2" placeholder="parole atkartoti" value=""
						autofocus id="pass2" >
				</div>
					<?}?>
				
				<? if (isset($_SESSION['username'])) { $button= 'Saglabât';}
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

