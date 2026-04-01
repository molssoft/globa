<? //if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body 
		onkeypress="if(event.key='q') { 
			$('#new').css('color', 'red');
			$('#new').attr('href', 'c_reservation2.php?f=TravellerCount&par=new');
		}"
	>
		
		<?if (isset($data['script'])) echo $data['script'];?>
		<div class="container">		
			<center>
			<div style="height:50px"></div>
			<div>
				<a href="c_home.php"><img src="img/logo2.png" width=200></a>
			</div>
			<div class="row" style="margin-top:20px; ">
			<? if (isset($data['uncompleted_res']) && !empty($data['uncompleted_res'])){
				?>
				<div class="col-sm-6 col-sm-offset-3">
					<div class="alert alert-warning text-left">
						<center><b class="text-center">Jums ir nepabeigtas rezervâcijas:</b></center>
						<br>
						<?
						foreach($data['uncompleted_res'] as $res){
							if ($res['var_labot']){
								if ($res['ir_kajites']){
									$func = "Cabins";
								}
								else{
									$func= "Hotels";
								}
							}
							else{	
								$func = "Summary";
							}
						
						
							?>
							<a href="c_reservation.php?f=<?=$func;?>&rez_id=<?=$res['rez_id'];?>"><?echo $res['sakuma_dat']; if (!empty($res['beigu_datums'])){ echo '-'.$res['beigu_dat'];}?> <?=$res['celojuma_nos'];?>
							<br><?
							//print_r($row);
						}
						?>
					</div>
				</div>
			<?
				
			}?>
			<div class="col-md-4 col-md-offset-4">
			<div class="col-md-12" style="margin-bottom:25px">
				<? if (isset($_SESSION['new_user']) ){?>
					<div class="col-md-12" style="margin-top:20px;">
						<div class="alert alert-success">
							<strong>Reìistrâcija notikusi veiksmîgi!</strong>
						</div>
					</div>
					<script>
						!function(f,b,e,v,n,t,s)
						{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
						n.callMethod.apply(n,arguments):n.queue.push(arguments)};
						if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
						n.queue=[];t=b.createElement(e);t.async=!0;
						t.src=v;s=b.getElementsByTagName(e)[0];
						s.parentNode.insertBefore(t,s)}(window, document,'script',
						'https://connect.facebook.net/en_US/fbevents.js');
						fbq('init', '563346587997689');
						fbq('track', 'CompleteRegistration');
					</script>
					<noscript><img height="1" width="1" style="display:none"
						src="https://www.facebook.com/tr?id=563346587997689&ev=PageView&noscript=1"
					/></noscript>
				<?
					unset($_SESSION['new_user']);
				}?>	
				<? if (isset($_SESSION["reg_err"])){?>
				<div class="col-md-12" style="margin-top:20px;">
					<div class="alert alert-danger">
					<strong><?=$_SESSION["reg_err"];?></strong>
					</div>
				</div>
					<?
					unset(	$_SESSION["reg_err"]);
				}?>
				<? if (isset($_SESSION["reg_warning"])){?>
				<div class="col-md-12" style="margin-top:20px;">
					<div class="alert alert-warning">
					<strong><?=$_SESSION["reg_warning"];?></strong>
					</div>
				</div>
					<?
					unset(	$_SESSION["reg_warning"]);
				}?>
				
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_reservation.php?f=TravellerCount&par=new" id="new">Jauna rezervâcija</a>
				</div>
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_reservation.php?f=SavedReservations">Manas rezervâcijas</a>
				</div>
				
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_reservation.php?f=BuyGiftCard">Pirkt dâvanu karti</a>
				</div>
				
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_register.php?f=name">Mans profils</a>
				</div>
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_change_password.php">Paroles maiòa</a>
				</div>
				<div class="col-md-12" style="margin-top:20px;">
					<a class="btn btn-home btn-primary btn-block btn-lg" href="c_logout.php">Iziet</a>
				</div>
			</div>
			</div>
		</div>
	</body>


</html>

