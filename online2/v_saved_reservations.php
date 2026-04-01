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
				<? if (isset($data['msg'])){
					?>
					<div class="alert alert-success">
						<strong><?=$data['msg'];?></strong>
					</div>
					<?
				}?>
				</div>
				<div class="col-sm-8 col-sm-offset-2">
				<? if (isset($_SESSION["reg_err"])){
					?>
					<div class="alert alert-danger">
						<strong><?=$_SESSION["reg_err"];?></strong>
					</div>
					<?
					unset($_SESSION["reg_err"]);
				}?>
				</div>
				<div class="clearfix"></div>
		
					
					<div  style="width:100%; text-align:center">
					<h2>Manas rezervâcijas</h2>
					<br>
				</div>
				
				<div class="col-sm-8 col-sm-offset-2">
				<? if (count($data['reservations'])>0){ 
				foreach ($data['reservations'] as $res){
					
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
					
					}?>
					
					<div class="col-sm-8">
						<? if (!$res['atcelta_grupa']){?><a href="c_reservation.php?f=<?=$func;?>&rez_id=<?=$res['rez_id'];?>"><?echo $res['sakuma_dat']; if (!empty($res['beigu_datums'])){ echo '-'.$res['beigu_dat'];}?> <?=$res['celojuma_nos'];?></a>
						<?}
						else{?>
						<font color="gray">Atcelta grupa: <?echo $res['sakuma_dat']; if (!empty($res['beigu_datums'])){ echo '-'.$res['beigu_dat'];}?> <?=$res['celojuma_nos'];?></font>
						<?}?>
						
					</div>
					<div class="col-sm-4 text-right">
					
					<?if ($res['atcelta_grupa'] == 0){
						if ($res['pabeigta']){
						 if ($res['cena'] == $res['iemaksats']){
							echo "Viss samaksâts"; 
						}
						else{	?>
							Cena: <?=$res['cena'];?>EUR 
						<?}
					}
					else{?>
						Rezervâcija nav pabeigta
					<?}
					}?>
					</div>
						
				
					<div class="col-sm-4 col-sm-offset-8 text-right">
				<?if ($res['atcelta_grupa'] == 0){
					if ($res['pabeigta'] ){
						if ($res['cena'] != $res['iemaksats']){
							?>
							Iemaksâts: <?=$res['iemaksats'];?>EUR
							<?
						}
					}
					else{
						?>
						<a  href="c_reservation.php?f=CancelReservation&rez_id=<?=$res['rez_id'];?>" 
							 class="btn btn-block btn-default"
							 style="background-position:0 0"
								onclick="return confirm('Vai tieðâm vçlaties dzçst rezervâciju?');">
								Atcelt
						</a>
						<?
													
					}
				}
				else{
					if (isset($res['orderi'])){
						?>
						<div class="row">
							<div class="col-sm-4">
							Iemaksâts: 
							</div>
							<div class="col-sm-8">
							<?=$res['orderi']['iemaksats'];?>
							</div>
							</div>
						<div class="row">
							<div class="col-sm-4">
							Izmaksâts: 
							</div>
							<div class="col-sm-8">
							-<?=$res['orderi']['izmaksats'];?>
							</div>
							</div>
							<!--	<div class="row">
								<div class="col-sm-12">______________
								</div>
							</div>-->
								<div class="row">
							<div class="col-sm-4">
							Bilance: 
							</div>
							<div class="col-sm-8">
							<?=$res['orderi']['bilance'];?>
							</div>
						</div>
						<?
					}
					
				}?>
				
				</div>
				<div class="col-sm-12">
				<hr>
				</div>
					
				<?}
				}
				else{
					?>
						<div  style="width:100%; text-align:center;margin-bottom:20px">
					Nav aktîvu rezervâciju<br><br>
					</div>
					<?
				}?>
			
				</div>
				<div class="clearfix"></div>
				
				<!----------------- DÂVANU KARTES ----------------------------------------------------->
				<div  style="width:100%; text-align:center">
					<h2>Nopirktâs dâvanu kartes</h2>
					<br>
				</div>
				<div class="col-sm-8 col-sm-offset-2">
				<??>
			
				</div>
				<!--------------------------------------------------------------->
						<div class="col-sm-12">
				<? if (count($data['gift_cards'])>0){
					?>
						
						<div class="col-sm-2"><b>Iegâdes datums</b></div>
						<div class="col-sm-2"><b>Summa</b></div>
						<div class="col-sm-3"><b>Kam</b></div>
						<div class="col-sm-1"><b>Nr.</b></div>
						<div class="col-sm-2"><b>Droðîbas kods</b></div>
						<div class="col-sm-2"> &nbsp </div>
					
					<?					
					foreach($data['gift_cards'] as $res){
						//var_dump($res);
						//die();
					?>
					<div class="col-sm-2"><?=$res['sakuma_datums'];?></div>
						<div class="col-sm-2"><?=$res['cena'];?> EUR</div>
						<div class="col-sm-3"><?=$res['dk_kam'];?></div>
						<div class="col-sm-1"><? if (!empty($res['dk_serija'])) echo $res['dk_serija']."-";?><?=$res['dk_numurs'];?></div>
						<div class="col-sm-2"><?=$res['dk_kods'];?></div>
						<form action="c_reservation.php?f=PrintDk" method="POST">
							<input type="hidden" name="dk_numurs" value="<?=$res['dk_numurs'];?>">
							<input type="hidden" name="dk_kods" value="<?=$res['dk_kods'];?>">
							<div class="col-sm-1">
								<center><a href="c_invoice.php?id=<?=$res['pid']?>">Izveidot rçíinu</a></center>
							</div>	
							<div class="col-sm-1">
								<button value="Drukât" class="btn btn-home btn-primary btn-sm" type="submit">Drukât</button>
							</div>
						</form>
					</div>
				
					
					
				
				<div class="col-sm-12">
				<hr>
				</div>
					
				
				
				
					
					<?}
					?>
				
					<?}
				
				else{
					?>
						<div  style="width:100%; text-align:center;margin-bottom:20px">
					Nav iegâdâta neviena dâvanu karte<br><br>
					</div>
					<?
				}?>
			
				</div>
				<!--------------------------------------------------------------->
				<div class="col-sm-4 col-sm-offset-4">
			
				<!--</div>-->
				
				
			
				
				<div  style="width:100%; text-align:center" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
					
				</div>
			

			</form>
						
		</div>
		<? if (isset($_SESSION['reservation']['summa'])) { ?>
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
				fbq('track', 'Purchase', { value: <?= $_SESSION['reservation']['summa']; ?>, currency: 'EUR' });
			</script>
		<? } ?>
	</body>


</html>


