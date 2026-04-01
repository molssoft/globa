<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">

			<? include 'i_register_steps.php'?>
			
			<div style="height:50px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_register.php?f=phone" style="margin-bottom:25px">
				<div class="row">
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
								
				<div class="col-sm-12">
					<h1>Tâlruòa numurs</h1>
				
				<div class=error><? if (isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="mobile_number">Mobilais</label>
					<div class="row ">
						<div class="col-sm-4">
								<div class="input-group ">
								  <span class="input-group-addon" id="basic-addon1">+</span>
								  <input type="tel" name="mobile_number_country" class="form-control" placeholder="" style="" value="371"
									autofocus id="mobile_number_country" maxlength="3">
									
								</div>
							 </div>
							<div class="col-sm-8">
							<input type="tel" name="mobile_number" class="form-control" placeholder="" value=""
								autofocus id="mobile_number" autocomplete="off">
						</div>
					</div>
				</div>
				<div class="col-sm-12">
					<label for="home_number">Mâjas</label>
					<div class="row ">
						<div class="col-sm-4">
							<div class="input-group ">
							  <span class="input-group-addon" id="basic-addon1">+</span>
							  <input type="tel" name="home_number_country" class="form-control" placeholder="371" style="" value=""
								 id="home_number_country" maxlength="3">
								
							</div>
						 </div>
						<div class="col-sm-8">
							<input type="tel" name="home_number" class="form-control" placeholder="" value="" style="width:100%"
							autofocus id="home_number" autocomplete="off">
						</div>
					</div>
				</div>
				
				<div class="col-sm-12">
					<label for="work_number">Darba</label>
					<div class="row ">
						<div class="col-sm-4">
								<div class="input-group ">
								  <span class="input-group-addon" id="basic-addon1">+</span>
								  <input type="tel" name="work_number_country" class="form-control" placeholder="" style="" value="371"
									autofocus id="work_number_country" maxlength="3">
									
								</div>
							 </div>
							<div class="col-sm-8">
								<input type="tel" name="work_number" class="form-control" placeholder="" value=""
								autofocus id="work_number" autocomplete="off">
						</div>
					</div>
				</div>		
				
			 
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block" type="submit">Saglabât</button>
				</div>
					<?if (isset($_SESSION['username'])){?>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
					</div>
				<?}?>
				</DIV>
			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>


</html>


