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
					<h2 "background-color:#fcf8e3">Kajîtes</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Cabins">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="col-md-4 col-md-offset-4">
					
					<div class="col-md-12">
						<label for="kajite">Kajîtes veids</label>
											
	
				<?
			
					?>
					<select name="kveids" id="kveids" class="form-control col-sm-2" onChange="selectCabin();">
						<option></option>
					<?	if (count($data['kajites_veidi'])>0){
					foreach($data['kajites_veidi'] as $kajites_veids){
					//	print_r($kajites_veids);
						?>
						<option value="<?=$kajites_veids['kveids_id'];?>" <? if ($data['izveletais_kajites_veids']['kveids_id'] == $kajites_veids['kveids_id']) echo "selected";?>><?=$kajites_veids['nosaukums'];?></option>
						<?
					}	}
					?>
					</select>
					<br>
					<div style="display:none" id="piemaksa_div"> <input type="checkbox" name="piemaksa" value="" id="piemaksa" <? if ($data['ir_piemaksa']==1) echo "checked";?>/>Piemaksât <span id="piemaksas_summa"></span> EUR, lai rezervçtu visu kajîti </div>
					<?
			
				

				?>
			</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12">
					<?if (isset($data['kajites_veidi'])){
						foreach($data['kajites_veidi'] as $kajites_veids){
						$kveids = $kajites_veids['kveids'];
						?>
						<h4><?=$kajites_veids['nosaukums'];?></h4>
						Cena: <?=number_format($kveids['standart_cena'],2);?> EUR <br>
						<? if ($data['ir_berni']){?>
						Bçrnu cena: <?=number_format($kveids['bernu_cena'],2);?> EUR <br>
						<?}?>
						<? if (!empty($kveids['pusaudzu_cena']) && $kveids['pusaudzu_cena'] != '0.00'){
								echo "Pusaudþu cena: ".number_format($kveids['pusaudzu_cena'],2)."<br>";
						}?>
						<? if (!empty($kveids['senioru_cena']) && $kveids['senioru_cena'] != '0.00'){
								echo "Senioru cena: ".number_format($kveids['senioru_cena'],2)."<br>";
						}?>
					
					<?}
					}?>
					</div>
					</div>
				
			
				
				
				
	
				<div class="col-md-4 col-md-offset-4">
				
				
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					
					<a class="btn btn-block btn-default" href="?f=Travellers" style="background-position:0 0">Atgriezties</a>
					<br>
					<br>
					
					<?}else {?>
						<div class="col-sm-6 " >
							<a class="btn btn-block btn-default" href="?f=Travellers" style="background-position:0 0"><< </a>
						
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
        <!--h4 class="modal-title" id="myModalLabel">Dzimðanas datums</h4-->
      </div>
      <div class="modal-body col-sm-8 col-sm-offset-2 ">
		<div class="alert alert-warning">  
		<? if (isset($data['modal_msg'])) echo $data['modal_msg'];?>
		</div>
		<center >
		<a href='?f=Hotels' class="btn btn-primary btn-block">Turpinât</a>
	
      </div>
      <div class="modal-footer ">
       <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>-->
       
					
      </div>
    </div>
  </div>
</div>


</html>
<script>
$(function(){
	selectCabin();
})
function selectCabin(){
	//alert( $(sel).val());
	kveids = $("#kveids").val();
	//if (kveids
	var request = $.ajax({
		url:      "?f=SelectCabin",
		data: { kveids: kveids},
		type:       'POST',
		cache:      false,
		dataType : 'html',
		
		success: function(html){ 
			//console.log(html);				
			//alert('izòemts')0;
			if (html == 'next' && false){
				//ja visiem ceïotâjiem ir izvçlçti numuriòi
				$("#forma").submit();
			}
			else{
				//document.location.href = "?f=Cabins";
			}
			//window.location.reload();
			//$('#shortlist_container_view_'+user_shortlist_id).html(html)
		}           
	  });
	  request.done(function( msg ) {
		  //$( "#log" ).html( msg );
		  console.log(msg);
		  //if($.isNumeric(msg)){
		 if (msg.indexOf("japiedava_piemaksa") >= 0){
			 var cena_start_ind = msg.indexOf("japiedava_piemaksa") + 19;
			// console.log(msg.indexOf("japiedava_piemaksa"));
			 var piemaksa = msg.substring(cena_start_ind);
			// console.log(msg.substring(cena_start_ind));
			 //alert('jâpiedâvâ piemaksa');
			 $("#piemaksa_div").show();
			 $("#piemaksas_summa").html(piemaksa);
			// $('#piemaksa').attr('checked', true); // Checks it

		  //if (msg == 'piemaksa'){
		  }
		  else{
			   $("#piemaksa_div").hide();
			   $('#piemaksa').attr('checked', false); // Unchecks it
		  }
		});
}
</script>

<? if (!$data['var_labot']){?>
<script>
	$("#forma :input:not(#talr_veids, #dok_veids) ").attr("disabled", true);
</script>
<?}

