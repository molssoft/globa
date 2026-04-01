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
			<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
				<div class="col-sm-12">
					<h2>Adreses</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="c_reservation.php?f=Addresses">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				
				
				<? 
				
			
				$i=0;
				foreach($data['dalibnieki'] as $dalibnieks){	
				//var_dump($dalibnieks['dzimta']);
				//var_dump($dalibnieks);
				/*echo "<br><br>";
				echo "Mans did".$data['mans_did']."<br>";
					*/				
				?>
					<div class="row col-md-12" <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>>
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-2" style="padding-right:0">
							<div class="col-sm-12"  style="padding-right:0">
							<input type="hidden" name="dalibn_id_<?=$i;?>" value="<?=$dalibnieks['ID'];?>"/>
							<br>
								<label ><?=$dalibnieks['vards'].' '.$dalibnieks['uzvards'];?></label>
							</div>
						</div>
						<div class="col-sm-3" style="padding-right:0">
							<div class="col-sm-12" style="padding-right:0">
								<label ><span <?if ($i>0){?>class="visible-xs"<?}?>>Mâja, iela, numurs</span></label>
									<input name="adrese_<?=$i;?>" id="adrese_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['adrese'];?>"
										required autofocus>	
								<label for="adrese_<?=$i;?>"></label>
								
							</div>
						</div>
						<div class="col-sm-2" style="padding-right:0">
							<div class="col-sm-12" style="padding-right:0">
								<label><span <?if ($i>0){?>class="visible-xs"<?}?>>Pilsçta</span></label>
								
								<input name="pilseta_<?=$i;?>" id="pilseta_<?=$i;?>"class="form-control" placeholder="" value="<?=$dalibnieks['pilseta'];?>"
									required autofocus >
								<label for="pilseta_<?=$i;?>"></label>
								
							</div>
						</div>
						<div class="col-sm-2" style="padding-right:0">	
							<div class="col-sm-12" style="padding-right:0">
								<label><span <?if ($i>0){?>class="visible-xs"<?}?>>Novads</span></label>						
								
								<select name="novads_<?=$i;?>" id="novads_<?=$i;?>" class="form-control" required>
									<option></option>
									<? foreach ($data['novadi'] as $novads){?>
									<option value=<?=$novads['id'];?> <? if ($novads['id'] == $dalibnieks['novads']) echo "selected";?>><?=$novads['nosaukums'];?></option>
									<?}?>
									
								</select>
								<label for="novads_<?=$i;?>"></label>
							</div>
						</div>
						<div class="col-sm-2">
					
							
							<div class="col-sm-12" style="padding-right:0">
								<label><span <?if ($i>0){?>class="visible-xs"<?}?>>Pasta indekss</span></label>
								
								<table>
									<tr>
									<td style="padding-bottom:10px">LV-</td>
									<td><input maxlength="4" name="indekss_<?=$i;?>" id="indekss_<?=$i;?>" class="form-control" placeholder="" value="<?=$dalibnieks['indekss'];?>"
										required autofocus ></td>
									</tr>
								</table>
								<label  for="indekss_<?=$i;?>"></label>
							</div>
								
						</div>
					</div>
					<?
					$i++;	
				}
				?>
				
			
				
				
				<div class="col-md-4 col-md-offset-4">
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					<?}
					else{?>
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
<style>
.currencyinput {
    border: 1px inset #ccc;
}
.currencyinput input {
    border: 0;
}
</style>
<? if (!$data['var_labot']){?>
<script>
	$("#forma :input").attr("disabled", true);
</script>
<?}