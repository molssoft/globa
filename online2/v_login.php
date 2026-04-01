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
			
			<? 
			$disabled = false;
			if (isset($_GET['a']))
				$disabled = false;
			
			if ($disabled) { ?>
			<div class="col-md-12" style="margin-top:50px;margin-bottom:50px">
				<h5>Paðreiz notiek servera uzlaboðanas darbi. </h5>
				<h5>Lai rezervçtu ceïojumus, zvaniet 67221312</h5>
				<h5>vai rakstiet uz impro@impro.lv.</h5>
				<h5>Atvainojamies par sagâdâtâjâm neçrtîbâm.</h5>
			</div>
			<? } ?>
			
			<? if (!$disabled) { ?>
			<div class="col-md-12" style="margin-top:50px;margin-bottom:50px">
				<h5>Ðeit vari rezervçt ceïojumu un </h5>
				<h5>apmaksât to ar <b>bankas karti</b> vai, izmantojot</h5>
<h5><b>interneta banku</b> (Swedbank, Luminor, SEB, Citadele).</h5>
				<h5>Apmaksu var veikt pa daïâm.</h5>
				<h5>Par kârtçjo maksâjumu vari saòemt atgâdinâjumu e-pastâ.</h5>
				<br>
				<div class="col-md-4 col-md-offset-4" style="padding:0">
				<? if (isset($data['disabled_bankas']) && !empty($data['disabled_bankas'])){
					?>
					<div class="alert alert-danger"><?=$data['disabled_bankas'];?></div>
					<?
					
				}?>
				<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Swedbank internetbanku</b>.</div-->
					<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Maksâjumu kartes</b>.</div-->
					<!--<div class="alert alert-info">Paðlaik maksâjumus var veikt, izmantojot <b>maksâjumu karti</b>, <b>Swedbank internetbanku</b> un <b>Citadele internetbanku</b>.</div>
					-->
					<!--<div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>DNB internetbanku</b>.</div>-->
					<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Citadele internetbanku</b>.</div-->
					<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>SEB internetbanku</b>.</div-->
					<!--<div class="alert alert-warning">Ðobrîd, veicot maksâjumus ar MasterCard maksâjumu karti, iespçjamas problçmas.<br>
					Ja varat, lûdzu, izmantojiet kâdu no internetbankâm (SEB, Swedbank vai Citadele).
					</div>-->
			
		
			</div>
			<div class="col-md-4 col-md-offset-4">
					<? include("v_login_part.php");?>
			<br><br>
				</div>
			
			
			
			<? } ?>
		</div>
	</body>


</html>
<script>
function forgot(){
	var epasts = $("#eadr").val();
	 $("#forgot").attr("href", "c_login.php?f=forgot&eadr=" + $("#eadr").val());
}
</script>
