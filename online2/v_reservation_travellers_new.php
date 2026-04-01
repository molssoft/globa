<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

	<!--<script src="https://code.jquery.com/jquery-1.12.4.js" ></script>-->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="js/datepicker-lv.js" ></script>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
			<BR>
			
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Travellers"
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
				
				if (isset($data['dalibnieki']) && !empty($data['dalibnieki'])){

					$i=0;
					foreach($data['dalibnieki'] as $dalibnieks){	
					//var_dump($dalibnieks['dzimta']);
					/*var_dump($dalibnieks);
					echo "<br><br>";
					echo "Mans did".$data['mans_did']."<br>";
						*/				
					?>
				<div class="row col-lg-12"
					 <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>> 
						
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
					
						<div class="col-sm-3"  style="padding-left:0">
							<div class="col-sm-12" style="padding-right:0;padding-left:0">
								<label  ><span <?if ($i>0){?>class="visible-xs"<?}?>>Vârds</span></label>
						
								<input name="vards_<?=$i;?>" class="form-control vards" placeholder="" value="<?=$dalibnieks['vards'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="vards" style="text-transform:uppercase" autocomplete="off">
							
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
									required autofocus id="uzvards<?=$i;?>" style="text-transform:uppercase" autocomplete="off">
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
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Pers. kods</span></label>
							</div>
							<div class="col-sm-6" style="padding-right:0;padding-left:0">
								
								<input name="pk1_<?=$i;?>" class="form-control" placeholder="1. daïa" value="<?=$dalibnieks['pk1'];?>"
									<? if ($data['mans_did'] == $dalibnieks['ID'])  echo "readonly";?>
									required autofocus id="pk1_<?=$i;?>" autocomplete="off">
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
									required autofocus id="pk2_<?=$i;?>" autocomplete="off">
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
							<label  ><span <?if ($i>0){?>class="visible-xs"<?}?>>Dzimð. dat.</span></label>
								
								<input class="form-control datepicker" placeholder="" value="<?=$db->Date2Str($dalibnieks['dzimsanas_datums']);?>"
									<? if ($data['mans_did'] == $dalibnieks['ID']) echo "disabled readonly";
						else echo 'required name="dzimsanas_datums_'.$i.'"';?> autofocus id="dzimsanas_datums<?=$i;?>" style="text-transform:uppercase" autocomplete="off">
									<?
								
							?>
								<label for=dzimsanas_datums_<?=$i;?>></label>
							</div>
								
								
						</div>
						<div class="col-sm-1"  style="padding-right:0;padding-left:0;">
							
									
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
									
									required autofocus id="vards_<?=$i;?>" style="text-transform:uppercase" autocomplete="off">
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
									required autofocus id="uzvards_<?=$i;?>" style="text-transform:uppercase" autocomplete="off">
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
								
									required autofocus id="pk1_<?=$i;?>" autocomplete="off">
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
								
									required autofocus id="pk2_<?=$i;?>" autocomplete="off">
								<?}?>
							</div>
							<div class="col-sm-12" style="padding-right:0">
								<label for="pk1_<?=$i;?>"></label>
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
				
					<a class="btn btn-block btn-default" href="?f=Travel" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=Travel" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Hotels" style="background-position:0 0">>> </a>
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
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">

  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Dzimðanas datums</h4>
      </div>
      <div class="modal-body col-sm-10 col-sm-offset-1 ">
		  <form method="POST" action="?f=Travellers">
			<input type="hidden" name="subm" value="2">
			<?
				//var_dump($data['dalibn']);
			if (isset($data['dalibn'])){
				$i=0;
				foreach($data['dalibn'] as $dalibnieks){	
				//var_dump($dalibnieks['dzimta']);
				/*var_dump($dalibnieks);
				echo "<br><br>";
				echo "Mans did".$data['mans_did']."<br>";
					*/				
				?>
			<div class="row "
			 <? if ($i%2 == 0){ ?>
				style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>> 
				<div class="col-sm-6">
					<div class="col-sm-12" >
						<input type="hidden" name="dalibn_id_<?=$i;?>" value="<?=$dalibnieks['id'];?>" />
							<br>
							<label ><?=$dalibnieks['nos'];?></label>
					</div>
				</div>
				<div class="col-sm-6" >
				<div class="col-sm-12" >				
					<label >
						<span <?if ($i>0){?>class="visible-xs"<?}?>>Dzimðanas datums		</span>
					</label>
				</div>
				<div class="col-sm-12" >
					<input  class="form-control datepicker" value="<?=$dalibnieks['dzimsanas_datums'];?>" 					
						autofocus id="" placeholder="dd.mm.GGGG" 
						<? /*if ($data['mans_did'] == $dalibnieks['id']) echo "disabled readonly";
						else*/ echo 'required name="dzimsanas_datums_'.$dalibnieks['id'].'"';?> />
					<label for="dzimsanas_datums_<?=$dalibnieks['id'];?>"></label>
				</div>
			</div>
		</div>
					<?
				$i++;
				}
			}?>
			<br>
		<div class="col-sm-4 col-sm-offset-4">
			<button class="btn btn-primary btn-block" type="submit">Saglabât</button>
		 </div>
		</form>
      </div>
      <div class="modal-footer ">
       <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
       
					
      </div>
    </div>
  </div>
</div>

</html>



<script type="text/javascript">
$(document).ready(function() {


 $( ".datepicker").datepicker({
        format: "dd.mm.yyyy",
        weekStart: 1,
        startDate: "now",
        maxViewMode: 2,
        language: "lv",		
		changeMonth: true,
		changeYear: true,
		maxDate: '0',
		yearRange: "-100:+0", // last hundred years
		//showButtonPanel: true
    });
})
	
</script>
<script>
$(function() {
$('.vards').bind('change keyup input',function(){
    $(this).val($(this).val().replace(/[^a-þ -]/i, ""))
})
});
</script>
<? if (!$data['var_labot']){?>
<script>
	$("#forma :input").attr("disabled", true);
</script>
<?}

