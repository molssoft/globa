<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
		
			<div style="height:30px"></div>
			<BR>
				<div class="row col-md-12">
				<? if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
				}?>
				</div>
			<div class="col-md-4 col-md-offset-4">
				<div class="col-sm-12">
					<h2 "background-color:#fcf8e3">Pakalpojumi</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Services">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
			
				<div class="col-sm-12">
					
					<label for="celojuma_cena"></label>
					<label for="pakalpojumu_limits"></label>
				</div>
				
				<?
				//ja ir atrasta ceïojuma cena
				if (!isset($data['errors']['celojuma_cena'])){
				$i=0;
					foreach ($data['dalibnieki'] as $dalibnieks){
						if (DEBUG){
							//var_dump($dalibnieks);
							//echo "<br><br>";
						}
						?>
					<div class="row col-md-12" <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>>
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-2" style="padding-right:0">
							<div class="col-sm-12"  style="padding-right:0">
							<input type="hidden" name="dalibn_id_<?=$i;?>" value="<?=$dalibnieks['data']['ID'];?>"/>
							<br>
								<label ><?=$dalibnieks['data']['vards'].' '.$dalibnieks['data']['uzvards'];?></label>
							</div>
						</div>
						<? if (isset($dalibnieks['pakalpojums']['cena'])){ ?>
						<div class="col-sm-5" style="padding-right:0">
							<div class="col-sm-12" style="padding-right:0">
								<label for="cena_<?=$i;?>" ><span <?if ($i>0){?>class="visible-xs"<?}?>>Ceïojuma cena</span></label>
				

							<? 
							$cena_ir = 0;
							if (count($dalibnieks['pakalpojums']['cena']) == 1)
							{
								$cena = $dalibnieks['pakalpojums']['cena'][0];
								if ($cena['cenaEUR']==0)
								{
									?><input type="hidden" name="cena_<?=$i;?>" id="cena" value="<?=$cena['id']?>"><?
									
									//echo $dalibnieks['saglabata_cena'];
									?><input type=text class="form-control" readonly value="<?=number_format(round($dalibnieks['saglabata_cena'],2),2,'.',' ') . ' EUR'?>"><?
									$cena_ir = 1;
								}
								
							}
							
							if ($cena_ir == 0) {
							?>
							<select class="form-control" name="cena_<?=$i;?>" id="cena">
						
								<?
									foreach ($dalibnieks['pakalpojums']['cena'] as $cena){					
										?>
										
										<option value="<?=$cena['id'];?>"
										<?  if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$cena['id']]>0) echo "selected";?>><?=number_format(round($cena['cenaEUR'],2),2,'.',' ');?> EUR - <?=$cena['nosaukums'];?>
										</option>
										<?
									}
								
								?>
							</select>
							<? } ?>
							
								
							</div>
						</div>
						<?}?>
						<div class="col-sm-5" style="padding-right:0">
								<br>
						
								<!--<label for="pakalpojumi_<?=$i;?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Citi pakalpojumi</span></label>
								--><?
				if (isset($dalibnieks['pakalpojums']['v1']) && isset($dalibnieks['radit_v1'])){
					foreach($dalibnieks['pakalpojums']['v1'] as $v1){
						
					?>
					<div class="col-sm-12">
						<label for="v1">
							<input class="" type="checkbox" 
								checked disabled
								<? //if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$v1['id']]>0) echo "checked"; ?>>
								Piemaksa par vienvietîgu numuriòu - <?=number_format(round($v1['cenaEUR'],2),2,'.',' ');?> EUR
						</label>
						<input type="hidden" id="v1" name="v1_<?=$i;?>" value="<?=$v1['id'];?>">
						
					</div>
					<?
					}
					
				}
				
				if (isset($dalibnieks['pakalpojums']['vv'])){
					foreach($dalibnieks['pakalpojums']['vv'] as $vv){
						
					?>
					<div class="col-sm-12">
						<label for="vv">
							<input class="" type="checkbox" name="vv_<?=$i;?>[]" value="<?=$vv['id'];?>"	checked
							onclick="event.preventDefault();" >
								<?=$vv['nosaukums'];?> - <?=number_format(round($vv['cenaEUR'],2),2,'.',' ');?> EUR
						</label>
						
					</div>
					<?
					}
				}

				
				if (isset($dalibnieks['pakalpojums']['papildvieta'])){
					foreach($dalibnieks['pakalpojums']['papildvieta'] as $papildvieta){
						
					?>
					<div class="col-sm-12">
						<label for="papildvieta">
							<input class="" type="checkbox" id="papildvieta" name="papildvieta_<?=$i;?>[]" value="<?=$papildvieta['id'];?>"
								<?php if(isset($_POST['papildvieta_'.$i]) && !empty($_POST['papildvieta_'.$i]) && in_array($papildvieta['id'],$_POST['papildvieta_'.$i])) echo "checked='checked'";?>
							
								<? if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$papildvieta['id']]>0) echo "checked"; ?>>
								<?=$papildvieta['nosaukums'];?> - <?=number_format(round($papildvieta['cenaEUR'],2),2,'.',' ');?> EUR
						</label>
						
					</div>
					<?
					}
				}

				if (isset($dalibnieks['pakalpojums']['ekskursija'])){
					foreach($dalibnieks['pakalpojums']['ekskursija'] as $ekskursija){
						/*echo "<br>pieteiktie pak<br>";
						var_dump($dalibnieks['pieteiktie_pak']);
						echo "<br><br>";*/
					?>
					<div class="col-sm-12">
						<label for="ekskursija">
							<input class="" type="checkbox" id="ekskursija" name="ekskursija_<?=$i;?>[]" value="<?=$ekskursija['id'];?>"
							 <?php if(isset($_POST['ekskursija_'.$i]) && !empty($_POST['ekskursija_'.$i]) && in_array($ekskursija['id'],$_POST['ekskursija_'.$i])) echo "checked='checked'";?>
								
							<? if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$ekskursija['id']]>0) echo "checked"; ?>>
								 <?=$ekskursija['nosaukums'];?> - <?=number_format(round($ekskursija['cenaEUR'],2),2,'.',' ');?> EUR</label>
					</div>
					<?
					}
				}
				
				if (isset($dalibnieks['pakalpojums']['edinasana'])){
					foreach($dalibnieks['pakalpojums']['edinasana'] as $edinasana){
					?>
					<div class="col-sm-12">
						<label for="edinasana">
							<input 
								class="ser<?=$edinasana['id']?>_<?=$edinasana['istabas_id']?>" 
								type="checkbox" 
								id="edinasana_<?=$i;?>" 
								name="edinasana_<?=$i;?>[]" 
								value="<?=$edinasana['id'];?>"
								
								<?php if(isset($_POST['edinasana_'.$i]) && !empty($_POST['edinasana_'.$i]) && in_array($edinasana['id'],$_POST['edinasana_'.$i])) echo "checked='checked'";?>
								
								<? if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$edinasana['id']]>0) echo " checked "; ?>
								
								<? /* ja pakalpojums domâts visai istabai*/
								if ($edinasana['visa_istaba']) {?>
								onclick="
									var ch = $('#edinasana_<?=$i;?>').prop('checked');
									$('.ser<?=$edinasana['id']?>_<?=$edinasana['istabas_id']?>').prop('checked',ch);
								"
								<? } ?>
							>
							<?=$edinasana['nosaukums'];?> - <?=number_format(round($edinasana['cenaEUR'],2),2,'.',' ');?> EUR</label>
					</div>
					<?
					}
				}

				if (isset($dalibnieks['pakalpojums']['cits'])){
					foreach($dalibnieks['pakalpojums']['cits'] as $cits){
					?>
					<div class="col-sm-12">
						<label for="cits_<?= $dalibnieks['data']['ID'] . '_' . $cits['id']; ?>">
							<input class="cits_id_<?= $cits['id']; ?> <?= ($cits['visa_istaba']) ? 'visa_istaba' : ''; ?> <?= ($dalibnieks['istabas_id']) ? 'istabas_id_' . $dalibnieks['istabas_id'] : ''; ?>" type="checkbox" data-class-list=".cits_id_<?= $cits['id']; ?><?= ($cits['visa_istaba']) ? '.visa_istaba' : ''; ?><?= ($dalibnieks['istabas_id']) ? '.istabas_id_' . $dalibnieks['istabas_id'] : ''; ?>" id="cits_<?= $dalibnieks['data']['ID'] . '_' . $cits['id']; ?>" name="cits_<?=$i;?>[]" value="<?=$cits['id'];?>"
								 <?php if(isset($_POST['cits_'.$i]) && !empty($_POST['cits_'.$i]) && in_array($cits['id'],$_POST['cits_'.$i])) echo "checked='checked'";?>
								<? if (isset($dalibnieks['pieteiktie_pak']) && $dalibnieks['pieteiktie_pak'][$cits['id']]>0) echo "checked"; ?>>
							 <?=$cits['nosaukums'];?> - <?=number_format(round($cits['cenaEUR'],2),2,'.',' ');?> EUR</label>
					</div>
					<?
					}
				}?>
								
						
						</div>
						</div>
						
						<?
						$i++;
					}
				?>
				
				<!--
				<div class="col-md-6 col-md-offset-3" style="margin-top:30px;">
					<label for="komentars">Komentârs</label>
				</div>
				<div class="col-md-6 col-md-offset-3">
					<textarea class="form-control" value="" autofocus id="komentars" name="komentars" placeholder="Komentârs"></textarea>	
				</div>
				-->
				</div>
				<div class="col-md-4 col-md-offset-4">
				
				
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					
					<a class="btn btn-block btn-default" href="?f=Hotels&dir=back" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
					
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=Hotels&dir=back" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=ContactData" style="background-position:0 0">>> </a>
							</div>
						<br>
						<br>
						<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
					<?}
					if (!$data['ir_iemaksas']){
						include("v_cancel_reservation.php");	
					}
					?>
					</div>
				</div>
			</form>
				<?}?>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>


<? if (!$data['var_labot']){?>
<script>
	$("#forma :input:not(#talr_veids, #dok_veids) ").attr("disabled", true);
</script>
<?}?>

<script>
	$("input.visa_istaba").on('change', function() {
		var status = $(this).is(':checked');
		$($(this).data('class-list')).prop('checked', status);
	});
</script>