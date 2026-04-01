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

			<form class="form-signin col-md-10 col-md-offset-1" method="post" action="c_reservation.php?f=Travellers">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				
				<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
					<h2>Personas</h2>
				</div>
				<? 
				if ($data['i_travel']){
					$profile_readonly = TRUE;
					
				}
				else {
					$profile_readonly = FALSE;
					
				}
				if (isset($data['dalibnieki'])){
					$i=0;
					foreach($data['dalibnieki'] as $dalibnieks){	
										
					?>
					<div class="row col-md-12">
						
						<label for="dalibn_<?=$dalibnieks['ID'];;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-4">
							<div class="col-sm-12">
								<label for="vards_<?=$dalibnieks['ID'];?>" ><span <?if ($i>0){?>class="visible-xs"<?}?>>Vārds</span></label>
								<? if ($data['mans_did'] == $dalibnieks['ID']){?>
								<input name="vards_<?=$i;?>" class="form-control" placeholder="" value="<?=$data['dalibnieks_es']['vards'];?>"
									readonly
									required autofocus id="mans_vards" style="text-transform:uppercase">
							
								<?
								
								}
								else{?>
								<input name="vards_<?=$dalibnieks['ID'];?>" class="form-control" placeholder="" value="<?=$dalibnieks['vards'];?>"
									
									required autofocus id="vards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
							</div>
						</div>
						<div class="col-sm-4">
							<div class="col-sm-12">
								<label for=uzvards_<?=$dalibnieks['ID'];?> ><span <?if ($i>0){?>class="visible-xs"<?}?>>Uzvārds</span></label>
								<? if ($profile_readonly){?>
								<input name="mans_uzvards" class="form-control" placeholder="" value="<?=$data['dalibnieks_es']['uzvards'];?>"
									readonly
									required autofocus id="mans_uzvards" style="text-transform:uppercase">
									<?
								
								}
								else{?>
								<input name="uzvards_<?=$dalibnieks['ID'];?>" class="form-control" placeholder="" value="<?=$dalibnieks['uzvards'];?>"							
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
							</div>
						</div>
						<div class="col-sm-4" style="padding-right:0">	
							<div class="col-sm-12" style="padding-right:0">
								<label for="pk1_<?=$dalibnieks['ID'];?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Personas kods</span></label>
							</div>
							<div class="col-sm-6">
								<? if ($profile_readonly){?>
								<input name="mans_pk1" class="form-control" placeholder="1. daļa" value="<?=$data['dalibnieks_es']['pk1'];?>"
									readonly
									required autofocus id="mans_pk1">
									<?
								
								}
								else{?>
								<input name="pk1_<?=$dalibnieks['ID'];?>" class="form-control" placeholder="1. daļa" value="<?=$dalibnieks['pk1'];?>"
								
									required autofocus id="pk1_<?=$dalibnieks['ID'];?>">
								<?}?>
							</div>
							<div class="col-sm-6">
							<? if ($profile_readonly){?>
								<input name="mans_pk2" class="form-control col-sm-2" placeholder="2. daļa" value="<?=$data['dalibnieks_es']['pk2'];?>"
									readonly
									required autofocus id="mans_pk2">
									<?
								$profile_readonly = FALSE;
								}
								else{?>
									<input name="pk2_<?=$dalibnieks['ID'];?>" class="form-control col-sm-2" placeholder="2. daļa" value="<?=$dalibnieks['pk2'];?>"
								
									required autofocus id="pk2_<?=$dalibnieks['ID'];?>">
								<?}?>
							</div>
						</div>
					</div>
					<?
					$i++;	
					}
				}
				else{
					
				
					for ($i=0;$i<$data['traveller_count'];$i++){?>
					<!--<div class=error><?=$data['message']?></div>-->
					<div class="row col-md-12">
						
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-4">
							<div class="col-sm-12">
								<label for="vards_<?=$i;?>" ><span <?if ($i>0){?>class="visible-xs"<?}?>>Vārds</span></label>
								<? if ($profile_readonly){?>
								<input name="vards_<?=$i;?>" class="form-control" placeholder="" value="<?=$data['dalibnieks_es']['vards'];?>"
									readonly
									required autofocus id="mans_vards" style="text-transform:uppercase">
							
								<?
								
								}
								else{?>
								<input name="vards_<?=$i;?>" class="form-control" placeholder="" value=""
									
									required autofocus id="vards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
							</div>
						</div>
						<div class="col-sm-4">
							<div class="col-sm-12">
								<label for=uzvards_<?=$i;?> ><span <?if ($i>0){?>class="visible-xs"<?}?>>Uzvārds</span></label>
								<? if ($profile_readonly){?>
								<input name="mans_uzvards" class="form-control" placeholder="" value="<?=$data['dalibnieks_es']['uzvards'];?>"
									readonly
									required autofocus id="mans_uzvards" style="text-transform:uppercase">
									<?
								
								}
								else{?>
								<input name="uzvards_<?=$i;?>" class="form-control" placeholder="" value=""							
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
							</div>
						</div>
						<div class="col-sm-4" style="padding-right:0">	
							<div class="col-sm-12" style="padding-right:0">
								<label for="pk1_<?=$i;?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Personas kods</span></label>
							</div>
							<div class="col-sm-6">
								<? if ($profile_readonly){?>
								<input name="mans_pk1" class="form-control" placeholder="1. daļa" value="<?=$data['dalibnieks_es']['pk1'];?>"
									readonly
									required autofocus id="mans_pk1">
									<?
								
								}
								else{?>
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daļa" value=""
								
									required autofocus id="pk1_<?=$i;?>">
								<?}?>
							</div>
							<div class="col-sm-6">
							<? if ($profile_readonly){?>
								<input name="mans_pk2" class="form-control col-sm-2" placeholder="2. daļa" value="<?=$data['dalibnieks_es']['pk2'];?>"
									readonly
									required autofocus id="mans_pk2">
									<?
								$profile_readonly = FALSE;
								}
								else{?>
									<input name="pk2_<?=$i;?>" class="form-control col-sm-2" placeholder="2. daļa" value=""
								
									required autofocus id="pk2_<?=$i;?>">
								<?}?>
							</div>
						</div>
					</div>
					<?}
				}?>
				
				
				<div class="col-md-4 col-md-offset-4">
				
				<? if (isset($_SESSION['username']) && false){ $button= 'Saglabāt';}
				else {$button = 'Turpināt';}
				?> 
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block" type="submit"><?=$button;?></button>
				</div>
				<?if (isset($_SESSION['username']) && false){?>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sākumu</a>
				</div>
				<?}?>
			</div>
			</form>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>

