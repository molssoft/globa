<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
		
		<div style="width:100%; text-align:center">
			<img src=img/logo2.png style="margin:20px;width:150px;">
		</div>
			
			<div style="height:30px"></div>
			<BR>
			
			
				<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
					<div class="col-sm-12">
						Rezervâcijas veikðanai paredzçtais laiks iztecçjis. Lûdzu, veiciet rezervâciju no jauna!<br />

					</div>
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
				</div>
				
					
			</div>
			</form>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>

