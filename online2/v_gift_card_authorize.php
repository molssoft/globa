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
				<div class="col-12"><p>Ðeit vari nopirkt IMPRO Dâvanu karti,<br>

apmaksâjot to ar <b>bankas karti</b> <br>vai <b>interneta bankâ</b> (Swedbank, Luminor/DNB, SEB, Citadele).<br><br></p></div>
				<? if (isset($data['disabled_bankas']) && !empty($data['disabled_bankas'])){
					?>
					<div class="alert alert-warning col-sm-4 col-sm-offset-4"><?=$data['disabled_bankas'];?></div>
					<?
					
				}?>
				<div class="col-sm-6" id="gift-card-login">
				<div class="col-sm-offset-3 col-sm-9" >
				<h4 class="text-left">Reìistrçtiem lietotâjiem<br><br></h4>
				
				<? include("v_login_part.php");?>
				<div class="text-right">
				<h4>Kâpçc reìistrçties?</h4>
				Nav nepiecieðams atkârtoti ievadît datus par sevi.<br>
Pirkumus var apskatît no jebkura datora jebkurâ laikâ.<br>
Pirkumu dokumentus var izdrukât, kad vien nepiecieðams.<br><br><br>
				</div>
				</div>
				</div>
				<div class="col-sm-6">
				<div class="col-sm-8 ">
				<h4 class="text-left">Nevçlos reìistrçties<br><br></h4>
				
				<a href="c_reservation.php?f=BuyGiftCardNoUser" class="btn btn-lg btn-primary btn-block">Tâlâk</a>
				</div>
				</div>
				<br><br>
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
