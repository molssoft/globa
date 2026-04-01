<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
			<div style="width:100%; text-align:center">
				<a href="c_home.php"><img src=img/logo2.png style="margin:20px;width:150px;"></a>
			</div>
			<div style="height:30px"></div>
			<BR>		
			<div class="col-sm-8 col-sm-offset-2">
			
				<div class="alert alert-danger text-center">
					<? if (isset($data['message'])) { ?>
						<strong><?=$data['message']?></strong>
					<? } else { ?>
						<strong>Sistçmas kïûda. Lûdzu sazinieties ar IMPRO.</strong>
					<? } ?>
				</div>
				<div  style="width:100%; text-align:center" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
			</div>		
		</div>
	</body>
</html>


