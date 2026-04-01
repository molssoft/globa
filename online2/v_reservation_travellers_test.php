<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
	<script
		  src="https://code.jquery.com/jquery-3.1.1.min.js"
		  integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
		  crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
		<script src="js/jquery-birthday-picker.js"></script>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
			<BR>
			
			<form class="form-signin col-lg-12 " method="post" id="forma" action="c_reservation.php?f=Travellers_test"
		>
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<!--	<div class="col-md-12">
				<? /*if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
					<script src="js/CountDown.js"></script>
				
					<p align="right" >Laiks rezervâcijas veikðanai: <span id="CountDownPanel" ></span></p>
				<?}*/?>
				</div>-->
				<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
					<div class="col-sm-12">
						<h2>Personas</h2>
					</div>
				</div>
				<? 
				
				if (isset($data['dalibnieki'])){
					$i=0;
					foreach($data['dalibnieki'] as $dalibnieks){	
					//var_dump($dalibnieks['dzimta']);
					/*var_dump($dalibnieks);
					echo "<br><br>";
					echo "Mans did".$data['mans_did']."<br>";
						*/				
					?>
					<div class="row col-md-12"
					 <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>> 
						
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-3"  style="padding-left:0">
							<div class="col-sm-12" style="padding-right:0;padding-left:0">
								<label  ><span <?if ($i>0){?>class="visible-xs"<?}?>>Vârds</span></label>
						
								<input name="vards_<?=$i;?>" class="form-control vards" placeholder="" value="<?=$dalibnieks['vards'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="vards" style="text-transform:uppercase">
							
								<?
								
								/*}
								else{?>
								<input name="vards_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['vards'];?>"
									
									required autofocus id="vards_<?=$i;?>" style="text-transform:uppercase">
								<?}*/
								?>
								<label for="vards_<?=$i;?>"></label>
							</div>
						</div>
						<div class="col-sm-3" style="padding-left:0">
							<div class="col-sm-12" style="padding-right:0;padding-left:0">
								<label  ><span <?if ($i>0){?>class="visible-xs"<?}?>>Uzvârds</span></label>
								
								<input name="uzvards_<?=$i;?>" class="form-control vards" placeholder="" value="<?=$dalibnieks['uzvards'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="uzvards<?=$i;?>" style="text-transform:uppercase">
									<?
								
								/*}
								else{?>
								<input name="uzvards_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['uzvards'];?>"							
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase">
								<?}*/?>
								<label for=uzvards_<?=$i;?>></label>
							</div>
						</div>
						<div class="col-sm-2" style="padding-left:0">	
							<div class="col-sm-12" style="padding-right:0;padding-left:0">
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Personas kods</span></label>
							</div>
							<div class="col-sm-6" style="padding-right:0;padding-left:0">
								
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daïa" value="<?=$dalibnieks['pk1'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="pk1_<?=$i;?>">
									<?
								
								/*}
								else{?>
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daïa" value="<?=$dalibnieks['pk1'];?>"
								
									required autofocus id="pk1_<?=$i;?>">
								<?}*/?>
							</div>
							<div class="col-sm-6" style="padding-right:0 ;padding-left:0">
							
								<input name="pk2_<?=$i;?>" class="form-control col-sm-2" placeholder="2. daïa" value="<?=$dalibnieks['pk2'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="pk2_<?=$i;?>">
									<?
								
								/*}
								else{?>
									<input name="pk2_<?=$i;?>" class="form-control col-sm-2" placeholder="2. daïa" value="<?=$dalibnieks['pk2'];?>"
								
									required autofocus id="pk2_<?=$i;?>">
								<?}*/?>
							</div>
							<div class="col-sm-12" style="padding-right:0">
								<label for="pk1_<?=$i;?>"></label>
							</div>
							
				
						</div>
						<div class="col-sm-2" style="padding-left:0">	
							<div class="col-sm-12" style="padding-right:0;padding-left:0">	
								<label  span <?if ($i>0){?>class="visible-xs"<?}?>>Dzimð. dat.</span></label>
								
								<div id="birthdayPicker" class="bday_<?=$i;?>">
								</div>
								<input type="hidden" id="hidden_b_<?=$i;?>day" name="hidden_b_<?=$i;?>[day]" value="<?=$dalibnieks['birth_array']['day'];?>">
								<input type="hidden" id="hidden_b_<?=$i;?>month" name="hidden_b_<?=$i;?>[month]" value="<?=$dalibnieks['birth_array']['month'];?>">
								<input type="hidden" id="hidden_b_<?=$i;?>year" name="hidden_b_<?=$i;?>[year]" value="<?=$dalibnieks['birth_array']['year'];?>">
								<input type="hidden" id="my_bday_<?=$i;?>" value="<?if ($data['mans_did'] == $dalibnieks['ID']) echo 1;else echo 0;;?>">
								<label for="birth_date_<?=$i;?>"></label>
							</div>
								
								
						</div>
						<div class="col-sm-1"  style="padding-left:0">
							
									
							<div class="col-sm-12" style="padding-right:0;padding-left:0">	
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Dzimums</span></label>
						
								
								<select name="dzimta_<?=$i;?>" class="form-control "
								<? /* if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";*/?>
										required >
									<option></option>
									<option value=s <?if ($dalibnieks['dzimta']=='s') echo "selected";?>>Sieviete</option>
									<option value=v <?if ($dalibnieks['dzimta']=='v') echo "selected";?>>Vîrietis</option>
								</select>
								<label for=dzimta_<?=$i;?>></label>
							</div>
							
						</div>
						<?
						$profile_readonly = FALSE;
						?>
					</div>
					<?
					$i++;	
					}
				}
				else{
					if ($data['i_travel']){
						$profile_readonly = TRUE;
						
					}
					else {
						$profile_readonly = FALSE;
						
					}
				
				
					for ($i=0;$i<$data['traveller_count'];$i++){?>
					<!--<div class=error><?=$data['message']?></div>-->
					<div class="row col-md-12"
					<? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>>
						
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-3">
							<div class="col-sm-12">
								<label  ><span <?if ($i>0){?>class="visible-xs"<?}?>>Vârds</span></label>
								<? if ($profile_readonly){?>
								<input name="vards_<?=$i;?>" class="form-control vards" placeholder="" value="<?=$data['dalibnieks_es']['vards'];?>"
									readonly
									required autofocus id="vards" style="text-transform:uppercase">
							
								<?
								
								}
								else{?>
								<input name="vards_<?=$i;?>" class="form-control" placeholder="" value=""
									
									required autofocus id="vards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
								<label for="vards_<?=$i;?>"></label>
							</div>
						</div>
						<div class="col-sm-3">
							<div class="col-sm-12">
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Uzvârds</span></label>
								<? if ($profile_readonly){?>
								<input  name="uzvards_<?=$i;?>" class="form-control vards" placeholder="" value="<?=$data['dalibnieks_es']['uzvards'];?>"
									readonly
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase">
									<?
								
								}
								else{?>
								<input name="uzvards_<?=$i;?>" class="form-control" placeholder="" value=""							
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase">
								<?}?>
								<label  for=uzvards_<?=$i;?>></label>
							</div>
						</div>
						<div class="col-sm-4" style="padding-right:0">	
							<div class="col-sm-12" style="padding-right:0">
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Personas kods</span></label>
							</div>
							<div class="col-sm-6">
								<? if ($profile_readonly){?>
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daïa" value="<?=$data['dalibnieks_es']['pk1'];?>"
									readonly
									required autofocus id="pk1_<?=$i;?>">
									<?
								
								}
								else{?>
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daïa" value=""
								
									required autofocus id="pk1_<?=$i;?>">
								<?}?>
							</div>
							<div class="col-sm-6">
							<? if ($profile_readonly){?>
								<input name="pk2_<?=$i;?>" class="form-control col-sm-2" placeholder="2. daïa" value="<?=$data['dalibnieks_es']['pk2'];?>"
									readonly
									required autofocus id="pk2_<?=$i;?>">
									<?
								
								}
								else{?>
									<input name="pk2_<?=$i;?>" class="form-control col-sm-2" placeholder="2. daïa" value=""
								
									required autofocus id="pk2_<?=$i;?>">
								<?}?>
							</div>
							<div class="col-sm-12" style="padding-right:0">
								<label for="pk1_<?=$i;?>"></label>
							</div>
						</div>
						<div class="col-sm-2">
						<div id="birthdayPicker" >
					</div>
						</div>
						<div class="col-sm-2">
							<div class="col-sm-12">	
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Dzimums</span></label>
							</div>
							<div class="col-sm-12">	
								<select name="dzimta_<?=$i;?>" class="form-control col-sm-12" 
								
										required >
									<option></option>
									<? if ($profile_readonly){?>
										<option value=s <?if ($data['dalibnieks_es']['dzimta']=='s') echo "selected";?>>Sieviete</option>
										<option value=v <?if ($data['dalibnieks_es']['dzimta']=='v') echo "selected";?>>Vîrietis</option>
									<?
									$profile_readonly = FALSE;
									}
									else{?>
										<option value=s >Sieviete</option>
										<option value=v >Vîrietis</option>
									<?}?>
						
								</select>
								<label for=dzimta_<?=$i;?>></label>
							</div>
						</div>
					</div>
					<?}
				}?>
				
				
				<div class="col-md-4 col-md-offset-4">
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
				
					<a class="btn btn-block btn-default" href="c_reservation.php?f=Travel" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="c_reservation.php?f=Travel" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="c_reservation.php?f=Hotels" style="background-position:0 0">>> </a>
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
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>
<script>
	$(function() {
	$('.vards').bind('change keyup input',function(){
		$(this).val($(this).val().replace(/[^a-þ -]/i, ""))
	});

    $("#birthdayPicker").birthdayPicker({
		
		monthFormat:'long' ,
		maxAge: 110,  
		sizeClass:'col-sm-4',
		dateFormat : "littleEndian",
		
	});
	$("select.birthDate").addClass("form-control");
	$("select.birthDate").css({"width":"25%"});
	$("select.birthMonth").addClass("form-control");
	$("select.birthMonth").css({"width":"40%"});
	$("select.birthYear").addClass("form-control");
	$("select.birthYear").css({"width":"35%"});
	$("fieldset.birthPicker").addClass("row");
	///$("fieldset.birthPicker").css({"width":"100%"});
	for (i=0; i<=<?=$i;?>; i++){
		//console.log($('.bday_'+i));
		var birth_date = $('.bday_'+i+' > fieldset > select.birthDate');
		var birth_month = $('.bday_'+i+' > fieldset > select.birthMonth');
		var birth_year = $('.bday_'+i+' > fieldset > select.birthYear');
		//console.log("bday:");
		//console.log($("#hidden_b_"+i+"day").val());
		birth_date.val($("#hidden_b_"+i+"day").val());
		birth_month.val($("#hidden_b_"+i+"month").val());
		birth_year.val($("#hidden_b_"+i+"year").val());
		
		if ($("#my_bday_"+i).val()){
			$("fieldset").attr("disabled", true); 
		}
	}

});
</script>
<? if (!$data['var_labot']){?>
<script>
	$("#forma :input").attr("disabled", true);
</script>
<?}