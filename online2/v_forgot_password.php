<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">		
			<center>
			<div style="height:50px"></div>
			<div>
			<img src="img/logo2.png" width=200>
			</div>
			<? include 'i_handler_values.php'?>
			<? include 'i_handler_errors.php'?>
			<?//var_dump($data['errors']);?>
			<div style="height:30px"></div>
		
			<form class="form-signin col-md-4 col-md-offset-4" method="post" accept-charset="utf-8" action="c_login.php?f=forgot">
				<input name=post value=1 hidden>
				<div class=error><? if (isset($data['message'])) echo $data['message'];?></div>
				
				<h4>Ievadiet sava lietotâja e-pasta adresi, uz kuru tiks nosûtîta jaunâ parole.</h4>
					<!--<label for="eadr" class="col-sm-4">E-pasts:</label> -->
					
					<label for="eadr"></label>
						<input name="eadr" id="eadr" class="form-control" placeholder="E-pasts" value="<?=$data['eadr'];?>"
							type="email" required autofocus>
				
				
					
					
				
				<label class="forget-pass"> <a href="c_login.php">Atgriezties</a>
				</label>
				<button class="btn btn-lg btn-primary btn-block" type="submit">Nosûtît paroli</button>

			</form>
			
			
			
		</div>
	</body>


</html>

