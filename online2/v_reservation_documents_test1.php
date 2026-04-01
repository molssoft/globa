
<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

<script>
function changeDocument(i){
	
	
	var dok_veids = $('#dok_veids_'+i).val();
	//alert(dok_veids);
	if (dok_veids != ""){
		$("#dok_ievade").show();
	}
	else
		$("#dok_ievade").hide();
	//$('#dok_veids_'+i).change();
	//$('#dok_veids_'+i+' [value="'+dok_veids+'"]').attr('selected',true);
	//alert(dok_veids);
	if (dok_veids == 'pase'){
		$('.ID_kartes_dati_'+i).hide();
		$('.pases_dati_'+i).show();
		var dok_nr_label = "<u>Pases</u> numurs";
		var dok_der_dat_label =  "<u>Pases</u> derîguma termiòð";
		//$("#ID_karte").attr("checked", false);
	}
	else if (dok_veids == 'ID_karte'){
		$('.pases_dati_'+i).hide();
		$('.ID_kartes_dati_'+i).show();
		var dok_nr_label = "<u>Personas apliecîbas</u> numurs";
		var dok_der_dat_label =  "<u>Personas apliecîbas</u> derîguma termiòð";
		//$("#pase").attr("checked", false);
	}
	$("#dok_nr_label").html(dok_nr_label);
	$("#dok_der_dat_label").html(dok_der_dat_label);

}
</script>

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
					<h2>Dokumenti</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Documents">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<? //var_dump($data['errors']);?>
				
				<? 
				
			
				$i=0;
				foreach($data['dalibnieki'] as $dalibnieks){	
				//var_dump($dalibnieks['dzimta']);
				//var_dump($dalibnieks);
				/*echo "<br><br>";
				echo "Mans did".$data['mans_did']."<br>";
					*/				
				?>
					<div class="row col-md-12 " <? if ($i%2 == 0){ ?>
						style="background-color:#faf2cc" <?}else{?>style="background-color:#f5e79e"<?}?>>
						<label for="dalibn_<?=$i;?>" class="col-md-12 text-center"></label>
						<div class="col-sm-2" style="padding-right:0">
							<div class="col-sm-12"  style="padding-right:0">
							<input type="hidden" name="dalibn_id_<?=$i;?>" value="<?=$dalibnieks['ID'];?>"/>
							<br>
								<label ><?=$dalibnieks['vards'].' '.$dalibnieks['uzvards'];?></label>
							</div>
						</div>
						<div class="span 12"><label for="dokuments_<?=$i;?>"></label></div>
						<div class="col-sm-3" >
						<div class="col-sm-12">
							<label for="dok_veids_<?=$i;?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Dok.veids</label>
							<?// echo $data['checked_dok_veids_'.$i];?>
								
							<select name="dok_veids_<?=$i;?>" id="dok_veids_<?=$i;?>" class="form-control" onChange="changeDocument('<?=$i;?>');" style="font-weight: bolder;" required>
								<option></option>
								<option value="pase" <? 
								/*if ($data['checked_dok_veids_'.$i] == 'pase'){ echo "selected"; }*/?>>Pase</option>
								<option value="ID_karte"
								<? /*if ($data['checked_dok_veids_'.$i] == 'ID_karte'){ echo "selected"; }*/?>>Personas apliecîba</option>
							</select>
							</div>
							
						</div>
						
						<div class="col-sm-7" style="display:none" id="dok_ievade">
													
							
							<div class="col-sm-6">
								<label><span id="dok_nr_label" <?if ($i>0){?>class="visible-xs"<?}?>></span></label>
								
									<!--<label for="paseNR_<?=$i;?>"><span <?if ($i>0){?>class="visible-xs"<?}?>>Dokumenta numurs</span></label>
									-->
								<div id="pases_dati_<?=$i;?>" class="pases_dati_<?=$i;?>">
									<input name="paseNR_<?=$i;?>" class="form-control " value="<?=$dalibnieks['paseS'];?><?=$dalibnieks['paseNR'];?>"
										autofocus id="paseNR_<?=$i;?>" style="text-transform:uppercase">
												<label for="paseNR_<?=$i;?>" ></label>
								</div>
								<div  id="ID_kartes_dati_<?=$i;?>" class="ID_kartes_dati_<?=$i;?>">
									<input name="idNR_<?=$i;?>" class="form-control" value="<?=$dalibnieks['idS'].$dalibnieks['idNR'];?>"								
									 autofocus id="idNR_<?=$i;?>" style="text-transform:uppercase">
									 <label for="idNR_<?=$i;?>"></label>
								</div>
							
							
									
							</div>	
							
							<div class="col-sm-6">
								
									<label><span id="dok_der_dat_label" <?if ($i>0){?>class="visible-xs"<?}?>></span></label>
								
									<div class="pases_dati_<?=$i;?>">
										<input name="paseDERdat_<?=$i;?>" class="form-control datepicker" value="<?=$dalibnieks['paseDERdat'];?>"
											autofocus id="paseDERdat_<?=$i;?>" placeholder="dd.mm.GGGG">
										<label for="paseDERdat_<?=$i;?>" style="height:0px;margin:0px"></label>
									
									</div>
									<div class="ID_kartes_dati_<?=$i;?>">
										<input name="idDerDat_<?=$i;?>" class="form-control datepicker"  value="<?=$dalibnieks['idDerDat'];?>"								
											autofocus id="idDerDat_<?=$i;?>" placeholder="dd.mm.GGGG">
										<label for="idDerDat_<?=$i;?>"></label>
									</div>
									
									
							</div>
							
							
						</div>
						<? if (isset($_SESSION['reservation']['documents_step']) && $_SESSION['reservation']['documents_step']==1){?>
						<script>
						//alert('<? echo $data['checked_dok_veids_'.$i];?>');
						$("[name=dok_veids_<?=$i;?>]").val('<? echo $data['checked_dok_veids_'.$i];?>');
						 //	alert($(".dok_veids_<?=$i;?>").val());
						 changeDocument(<?=$i;?>);	
						 
						 
						</script>
						<?}?>
		
					</div>
					<?
					
					$i++;	
				}
				?>
				
			
				
				
				<div class="col-md-4 col-md-offset-4">
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					
					<a class="btn btn-block btn-default" href="?f=ContactData" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
				
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=ContactData" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Summary" style="background-position:0 0">>> </a>
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

<!--<link media="screen" type="text/css" href="css/bootstrap-datepicker.min.css" rel="stylesheet">
<script type="text/javascript" src="js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript" src="js/bootstrap-datepicker.lv.min.js" ></script>-->

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

	<!--<script src="https://code.jquery.com/jquery-1.12.4.js" ></script>-->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="js/datepicker-lv.js" ></script>
<script type="text/javascript">
$( document ).ready(function() {

	  $( ".datepicker").datepicker({
		 format: "dd.mm.yyyy",
        weekStart: 1,
        startDate: "now",
        maxViewMode: 2,
        language: "lv",		
		changeMonth: true,
		changeYear: true,
		minDate: '0',
		yearRange: "0:+50",
    });
	

	
});

</script>
<? if (!$data['var_labot']){?>
<script>
	$("#forma :input:not([id^='dok_veids']) ").attr("disabled", true);
</script>
<?}
?>
<style>
 label {
	// display:inline;
 }
</style>
