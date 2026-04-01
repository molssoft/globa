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
			
			
			<div class="row" style="margin-top:50px;margin-bottom:50px">
				<div class="col-12"><h3>Pirkt dâvanu karti</h3></div>
				<div class="col-sm-8" >
				<h4>Reìistrçtiem lietotâjiem</h4>
				<? include("v_login_part.php");?>
				</div>
				<div class="col-sm-4">Nevçlos reìistrçties</h4>
				<a href="" class="btn btn-lg btn-primary btn-block">Tâlâk</a>
				</div>
				</div>
				</div>

	</body>


</html>
<script>
function forgot(){
	var epasts = $("#eadr").val();
	 $("#forgot").attr("href", "c_login.php?f=forgot&eadr=" + $("#eadr").val());
}
</script>
