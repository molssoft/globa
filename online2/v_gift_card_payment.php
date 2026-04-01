<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<?if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
	<div style="width:100%; text-align:center">
			<a href="https://www.impro.lv/online"><img src=img/logo2.png style="margin:20px;width:150px;"></a>
		</div>
			
			
			<div style="height:50px"></div>
		
				
				
				<br>
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php';
				//var_dump($data['errors']);
				?>
				<div class="col-sm-4 col-sm-offset-4">
				<div class=error><? if(isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				<? if (isset($_SESSION["reg_err"])){?>
				<div class="col-md-12" style="margin-top:20px;">
					<div class="alert alert-danger">
					<strong><?=$_SESSION["reg_err"];?></strong>
					</div>
				</div>
					<?
					//unset(	$_SESSION["reg_err"]);
				}
				//else{?>
				<? if (isset($data['dk'])  && !isset($_SESSION["reg_err"])){?>
					<h2>Paldies, ka iegâdâjâties dâvanu karti!</h2>
				<?//}?>
				
			
						<form action="c_reservation.php?f=PrintDk" method="POST">
							<input type="hidden" name="dk_numurs" value="<?=$dk['dk_numurs'];?>">
							<input type="hidden" name="dk_kods" value="<?=$dk['dk_kods'];?>">
							<button value="Drukât" class="btn btn-home btn-primary btn-block btn-sm" type="submit">Drukât</button>
						</form>
					
				<?}?>
				
				</div>
				
				
				
			
				
				
			
				
				
				

			
			
		</div>
	</body>


</html>


