<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<script>
		
	function changePhone(i){
		
		var talr_veids = $('#talr_veids_'+i).val();
		if (talr_veids == 'mobile_number'){
			$('#home_phone_'+i).hide();
			$('#work_phone_'+i).hide();
			$('#cell_phone_'+i).show();
		
		}
		else if (talr_veids == 'home_number'){
			$('#work_phone_'+i).hide();
			$('#cell_phone_'+i).hide();
			$('#home_phone_'+i).show();
		
		}
		else if (talr_veids == 'work_number'){
			$('#cell_phone_'+i).hide();
			$('#home_phone_'+i).hide();
			$('#work_phone_'+i).show();
		
		}

	}
	</script>
	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
			<BR>
			
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=ContactData">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="row col-md-10 col-md-offset-1">
				<? if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
				}?>
				</div>
				<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
					<div class="col-sm-12">
						<h2>Kontaktdati</h2>
					</div>
				</div>
				<? 
				
			
				$i=0;
				foreach($data['dalibnieki'] as $dalibnieks){	
				
				//var_dump($dalibnieks);
				/*echo "<br><br>";
				echo "Mans did".$data['mans_did']."<br>";
					*/				
				?>
					<div class="row col-md-10 col-md-offset-1" <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>>
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-2" style="padding-right:0">
							<div class="col-sm-12"  style="padding-right:0">
							<input type="hidden" name="dalibn_id_<?=$i;?>" value="<?=$dalibnieks['ID'];?>"/>
							<br>
								<label ><?=$dalibnieks['vards'].' '.$dalibnieks['uzvards'];?></label>
							</div>
						</div>
						<div class="col-sm-6" >
							<label class="col-sm-12" for="phone_number_<?=$i;?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Tâlruòa numurs</span></label>
							
							<div class="col-sm-4" >
								<?// echo $data['checked_talr_veids_'.$i];?>
								<select name="talr_veids_<?=$i;?>" id="talr_veids_<?=$i;?>" onChange="changePhone('<?=$i;?>')" class="form-control" >
									<option value="mobile_number" <? /*if ($data['checked_talr_veids_'.$i] == 'cell'){ echo "selected"; }*/?>>Mobilais</option>
									<option value="home_number" <?/* if ($data['checked_talr_veids_'.$i] == 'home'){ echo "selected"; }*/?>>Mâjas</option>
									<option value="work_number" <? /*if ($data['checked_talr_veids_'.$i] == 'work'){ echo "selected"; }*/?>>Darba</option>
									
								</select>
							</div>
					
					
							<div class="col-sm-8" id="home_phone_<?=$i;?>" >
								<div class="row ">
									<div class="col-sm-5">
										<div class="input-group ">
										  <span class="input-group-addon" id="basic-addon1">+</span> 
										  <input name="home_number_country_<?=$i;?>" class="form-control" placeholder="371" style="" value="<?=$dalibnieks['talrunisMvalsts'];?>"
											 id="home_number_country_<?=$i;?>" autocomplete="off">
											
										</div>
									 </div>
									<div class="col-sm-7" style="padding-left:0;">
											<input name="home_number_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['talrunisM'];?>"
												autofocus id="home_number_<?=$i;?>" autocomplete="off">
										
									</div>
									<div class="col-sm-12">
										<label for="home_number_<?=$i;?>" ></label>
									</div>
								</div>
							</div>
							<div class="col-sm-8" id="work_phone_<?=$i;?>" >
								<div class="row ">
									<div class="col-sm-5">
										<div class="input-group ">
										  <span class="input-group-addon" id="basic-addon1">+</span> 
										  <input name="work_number_country_<?=$i;?>" class="form-control" placeholder="371" style="" value="<?=$dalibnieks['talrunisDvalsts'];?>"
											 id="work_number_country_<?=$i;?>" autocomplete="off">
											
										</div>
									 </div>
									<div class="col-sm-7" style="padding-left:0;">
										<input name="work_number_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['talrunisD'];?>"
											autofocus id="work_number_<?=$i;?>" autocomplete="off">
										
									</div>
									<div class="col-sm-12">
										<label for="work_number_<?=$i;?>"></label>
									</div>
								</div>
							</div>
							
							<div class="col-sm-8" id="cell_phone_<?=$i;?>" >
								<div class="row ">
									<div class="col-sm-5">
										<div class="input-group ">
										  <span class="input-group-addon" id="basic-addon1">+</span> 
										  <input name="mob_number_country_<?=$i;?>" class="form-control" placeholder="371" style="" value="<?=$dalibnieks['talrunisMobvalsts'];?>"
											 id="mob_number_country_<?=$i;?>" autocomplete="off">
											
										</div>
									 </div>
									<div class="col-sm-7" style="padding-left:0;">
										<input type="text" name="mob_number_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['talrunisMob'];?>"
											autofocus id="mob_number_<?=$i;?>" autocomplete="off" >
											
									</div>
									<div class="col-sm-12">
										<label for="mobile_number_<?=$i;?>"></label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-4">
							<label class="col-sm-12" for="eadr_<?=$i;?>" ><span <?if ($i>0){?>class="visible-xs"<?}?>>E-pasts</span></label>
							<div class="col-sm-12">
							<input type="email" name="eadr_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['eadr'];?>"
								autofocus id="eadr_<?=$i;?>" autocomplete="off">
								</div>
						</div>
						
				
</div>					
		
				
					<?
				// if ($data['checked_dok_veids_'.$i] == 'Pase'){
					 ?>
					<script>
						$("[name=talr_veids_<?=$i;?>]").val('<? echo $data['checked_talr_veids_'.$i];?>');
						changePhone(<?=$i;?>);
						/*if ($("#talr_veids_<?=$i;?>").val() == 'home'){
								$("#work_phone_<?=$i;?>").hide();
								$("#cell_phone_<?=$i;?>").hide();
								$("#home_phone_<?=$i;?>").show();
						 }
						 else if ($("#talr_veids_<?=$i;?>").val() == 'work'){
									$("#cell_phone_<?=$i;?>").hide();
									$("#home_phone_<?=$i;?>").hide();
									$("#work_phone_<?=$i;?>").show();
						 }
						 else if ($("#talr_veids_<?=$i;?>").val() == 'cell'){
									$("#home_phone_<?=$i;?>").hide();
									$("#work_phone_<?=$i;?>").hide();
									$("#cell_phone_<?=$i;?>").show();
						 }*/
					</script>
				 <? /*}else{?>
						<script>
							$('#pases_dati_<? echo $i;?>').hide();
							$('#ID_kartes_dati_<? echo $i;?>').show();
						</script>
					<?}*/
					$i++;	
				}
				?>
				
				<div class="col-md-4 col-md-offset-4">
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					
					<a class="btn btn-block btn-default" href="?f=Services" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
				
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=Services" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Documents" style="background-position:0 0">>> </a>
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
$( document ).ready(function() {

});

/*$( "input[name=talr_veids]" ).change(function() {
  // Check input( $( this ).val() ) for validity here
  var talr_veids = $('input[name=talr_veids]:checked').val();
  
  
});*/



</script>
<? if (!$data['var_labot']){?>
<script>
	$("#forma :input:not([id^='talr_veids']) ").attr("disabled", true);
</script>
<?}