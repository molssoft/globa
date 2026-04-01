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
			<? //require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
			<BR>
			<div class="col-md-4 col-md-offset-4">
				<? if (isset($_SESSION['reservation']['online_rez_id']) && $data['include_timer']){
					$timer_text = 'maksâjuma';
					require_once("i_timer.php");
				}?>
				</div>
			<form class="form-signin col-md-4 col-md-offset-4" method="post"  action="c_reservation.php?f=MakePayment" id="payment_form">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				<?
				$testing = false;
				if (isset($_GET['a']) || isset($_SESSION['test']) || $_SESSION['profili_id']==84  || $_SESSION['profili_id']==51116 || $_SESSION['profili_id']==5585 /* Maris */ || $_SESSION['profili_id'] == 7996 /*Liene */)
					$testing = true;
				
				$bankas = array('ar_karti'=>'','swedbank'=>'','dnb'=>'','seb'=>'','citadele'=>'','revolut'=>'');
				
				if (isset($data['bankas_settings'])){
					foreach ($data['bankas_settings'] as $key=>$val){
						if ($val == '0') {
							$bankas[$key] = ' disabled ';
						}
					}
				}
				
				
				?>
				<div class="col-sm-12">
				

					<h2>Apmaksas veids</h2>
				</div>
			<div class="col-sm-12 ">
			<? if (isset($data['disabled_bankas']) && !empty($data['disabled_bankas'])){
					?>
					<div class="alert alert-danger"><?=$data['disabled_bankas'];?></div>
					<?
					
				}
				/*
				?>
			<div class="alert alert-info">Paðlaik maksâjumus var veikt, izmantojot <b>maksâjumu karti</b>, <b>Swedbank internetbanku</b> un <b>Citadele internetbanku</b>.</div>-->
				<!--<div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>DNB internetbanku</b>.</div>-->
				<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Maksâjumu kartes</b>.</div-->
				<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Citadele internetbanku</b>.</div-->
									<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>SEB internetbanku</b>.</div-->
				<!--div class="alert alert-warning">Paðlaik nav iespçjams veikt maksâjumus, izmantojot <b>Swedbank internetbanku</b>.</div-->
				<!--<div class="alert alert-warning">Ðobrîd, veicot maksâjumus ar MasterCard maksâjumu karti, iespçjamas problçmas.<br>
Ja varat, lûdzu, izmantojiet kâdu no internetbankâm (SEB, Swedbank vai Citadele).</div>
		*/
		?>
			
				<button class="btn btn-block btn-primary submit" style="white-space: normal;" name="banka" type="submit" value="merchant" <?=$bankas['ar_karti'];?>>Maksâjumu kartes</button>
				<button class="btn btn-block btn-primary  submit" style="white-space: normal;" name="banka" type="submit" value="swedbank" <?=$bankas['swedbank'];?>>Swedbank internetbanka</button>
				<button class="btn btn-block btn-primary submit" style="white-space: normal;" name="banka" type="submit" value="dnbnord" <?=$bankas['dnb'];?>>Luminor internetbanka</button>
				<button class="btn btn-block btn-primary submit" style="white-space: normal;" name="banka" type="submit" value="seb" <?=$bankas['seb'];?>>SEB internetbanka</button>
				<button class="btn btn-block btn-primary submit" style="white-space: normal;" name="banka" type="submit" value="citadele" <?=$bankas['citadele'];?>>Citadele internetbanka</button>
				<button class="btn btn-block btn-primary submit" style="white-space: normal;" name="banka" type="submit" value="revolut" <?=$bankas['revolut'];?>>Revolut</button>
				
				
			</div>
			<div class="row">
			<div class="col-sm-12 ">
			&nbsp
			
			</div>
			</div>
			<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_reservation.php?f=<?=$data['return_url'];?>" style="background-position:0 0">Atcelt</a>
				</div>
				<div class="col-sm-8 col-sm-offset-2 ">
				
				<br><br>
		<b style="text-align:center;font-size:110%">Tirgotâjs</b><br>SIA "IMPRO CEÏOJUMI"<br>
<b>Reì. nr.:</b> 40003235627<br>
<b>Juridiskâ adrese:</b><br>Meríeïa iela 13,<br> Rîga, LV-1050, Latvija<br><br>

</div>
			</div>
			</form>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>
<? if (isset($_SESSION['profili_id'])){?>
<!-- Taimeris, kas saglabâ lietotâja aktivitâti, lai varçtu kosntatçt, kad lietotâjs atslçdzies no sistçmas un izsûtît atgâdinâjumu par nepabeigtu rezervâciju -->	
<script>
$(function() {
	update_user_sess();
	setInterval(function(){update_user_sess();}, 10000);
});
function update_user_sess(){
 $.ajax({
    url : 'm_user_session.php?method=Save&param=<?=$_SESSION['profili_id'];?>', //
   })
}

</script>
<?}?>

