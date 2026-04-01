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
				<div class="row col-md-10 col-md-offset-1">
				<? if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
						<?}?>
				</div>
			<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
				<div class="col-sm-12">
					<h2>Kopsavilkums</h2>
				</div>
			</div>
			<div class="col-md-10 col-md-offset-1">
				<? if (isset($_SESSION["reg_err"])){
					?>
					<div class="alert alert-danger">
						<strong><?=$_SESSION["reg_err"];?></strong>
					</div>
					<?
					unset($_SESSION["reg_err"]);
				}?>
				</div>
				<div class="col-md-10 col-md-offset-1">
				<? if (isset($_SESSION["success"])){
					?>
					<div class="alert alert-success">
						<strong><?=$_SESSION["success"];?></strong>
					</div>
					<?
					unset($_SESSION["success"]);
				}?>
				</div>
				<div class="col-md-10 col-md-offset-1">
				<? if (isset($_SESSION["reg_success"])){
					?>
					<div class="alert alert-success">
						<strong><?=$_SESSION["reg_success"];?></strong>
					</div>
					<?
					unset($_SESSION["reg_success"]);
				}?>
				</div>
			<!--<form class="form-signin col-md-12 " method="post" action="c_reservation.php?f=Travellers">-->
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				<? //var_dump($data['errors']);?>
				
				
				
				<div class="col-md-10 col-md-offset-1" style="margin-bottom:200px;">	
					<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="headingOne">
								<h4 class="panel-title">
									<a role="button" data-toggle="collapse" data-parent="#accordion1" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
										<i class="more-less glyphicon glyphicon-plus"></i>
										Maksâjumu termiòi
									</a>
								</h4>
							</div>
							<div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
								<div class="panel-body">
									<h3><?=$data['celojuma_nos'];?> (<?=$data['sakuma_dat'];?> - <?=$data['beigu_dat'];?>)</h3>
									<br>
									<? if (!empty($data['termini'])){
										?>
												<h4>Maksâjumu termiòi</h4>
											<ol>
											<? $i=1; 
											foreach($data['termini'] as $termins){
												$when = "Lîdz <b>".$termins['datums']."</b>";
												if ($i==1){
													$how_much = "<b>".$termins['summa']." ".$data['grupas_valuta']."</b>";
													$when = 'Piesakoties';
												}
												else if ($i== count($data['termini'])){
													$how_much = 'pilna summa';
												}
												else{
														$how_much = 'vçl '."<b>".$termins['summa']." ".$data['grupas_valuta']."</b>";
												}?>
												<li><?=$when;?> jâiemaksâ <?=$how_much?></li>
											<?
												$i++;
											}?>
												
											</ol>
										<?
									}?>
							
								</div>
							</div>
						</div>

						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="headingTwo">
								<h4 class="panel-title">
									<a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion1" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
										<i class="more-less glyphicon glyphicon-plus"></i>
										Pasûtîtie pakalpojumi
									</a>
								</h4>
							</div>
							<div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
								<div class="panel-body">
								<div class="col-md-8">
									<ul class="list-unstyled">
									<?
									foreach ($data['celotaji'] as $dalibn){
										?>
										<li><h4><?=$dalibn['vards'].' '.$dalibn['uzvards'];?></h4>
										
										<table class="table " style="padding-left:20px">
										<?
										foreach ($dalibn['pakalpojumi'] as $pakalpojums){
											?>
											<tr>
												<td><?=$pakalpojums['nosaukums'];?></td>
												<td width="200px" align="right"><?=$pakalpojums['summaEUR'];?></td>
											</tr>
											<?
										}
										
										?>
										</table>
										
										</li>
										<?
									}
									?>
									</ul>
								</div>
							</div>
							</div>
									
						</div>
						
						<? 
						$show = false;
						foreach ($data['celotaji'] as $dalibn){
							foreach ($dalibn['pirkt'] as $pakalpojums){
								$show = true;
							}
						}
						if ($show) {
						?>
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="headingBuy">
								<h4 class="panel-title">
									<a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion1" href="#collapseBuy" aria-expanded="false" aria-controls="collapseBuy">
										<i class="more-less glyphicon glyphicon-plus"></i>
										<font color="green">Pasûtît papildus pakalpojumus</font>
									</a>
								</h4>
							</div>
							<div id="collapseBuy" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingBuy">
								<div class="panel-body">
								<div class="col-md-8">
									<ul class="list-unstyled">
									<?
									foreach ($data['celotaji'] as $dalibn){
										?>
										<li><h4><?=$dalibn['vards'].' '.$dalibn['uzvards'];?></h4>
										
										<table class="table " style="padding-left:20px">
										<?

										
										foreach ($dalibn['pirkt'] as $pakalpojums){
											?>
											<tr>
												<td><font color=green><?=$pakalpojums['nosaukums'];?></font></td>
												<td width="200px" align="right">
													<span style="color: green;">
														<?= number_format($pakalpojums['cenaEUR'], 2); ?> EUR
													</span>
													<button class="buyButton" id="buyButton<?= $dalibn['ID'] . '-' . $pakalpojums['id']; ?>"
														data-id="<?= $dalibn['ID'] . '-' . $pakalpojums['id']; ?>"
														style="background-color: green; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;">
														Pirkt
													</button>
												</td>
											</tr>
											<?
										}
										?>
										</table>
										
																			
										
										</li>
										<?
									}
									?>
									</ul>
								</div>
							</div>
							</div>
									
						</div>	
						
						<!-- Custom confirmation dialog -->
						<div id="confirmDialog" style="display: none; 
							position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
							background-color: rgba(0,0,0,0.5); 
							justify-content: center; align-items: center;">
							<div style="background-color: white; padding: 20px; border-radius: 8px; min-width: 200px; text-align: center;">
								<p>Pievienot pakalpojumu ðai rezervâcijai?</p>
								<button id="confirmYes"
									style="background-color: green; color: white; margin-right: 10px; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;">
									Pievienot
								</button>
								<button id="confirmNo"
									style="background-color: gray; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;">
									Atcelt
								</button>
							</div>
						</div>
						
						<!-- Custom success dialog -->
						<div id="successDialog" style="display: none; 
							position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
							background-color: rgba(0,0,0,0.5); 
							justify-content: center; align-items: center;">
							<div style="background-color: white; padding: 20px; border-radius: 8px; min-width: 200px; text-align: center;">
								<p>Pakalpojums ir pievienots rezervâcijai</p>
								<button id="ok"
									style="background-color: green; color: white; margin-right: 10px; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;">
									Labi
								</button>
							</div>
						</div>
						
						<script>
						$(document).ready(function() {
							let productId = null; // store clicked product id

							// Show dialog and store product ID
							$('.buyButton').on('click', function() {
								productId = $(this).data('id');  // read product ID from clicked button
								$('#confirmDialog').css('display', 'flex');
							});

							// Hide dialog if user clicks No
							$('#ok').on('click', function() {
								$('#successDialog').hide();
								location.reload(); // refresh page
							});

							// Hide dialog if user clicks No
							$('#confirmNo').on('click', function() {
								$('#confirmDialog').hide();
							});
							
							// Attach this only once
							$('#confirmYes').on('click', function() {
								$('#confirmDialog').hide();
								// AJAX request with product ID
								$.ajax({
									url: 'ajax_buy_extra.php',
									type: 'POST',
									data: { action: 'buy', product_id: productId },
									success: function(response) {
										console.log('Success:', response);
										$('#successDialog').css('display', 'flex');
									},
									error: function(xhr, status, error) {
										console.error('Error:', error);
									}
								});
							});
						});
						</script>							
						<? } 
						
						
						?>
						
					<? if (!$data['apstiprinats'] && !$data['rez_apstiprinata']){

						//râda rezervâcijas apstiprinâðanas pogu
						?>
						<div class="col-md-5 col-md-offset-4">
					
				 
						<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
							<a href="?f=AcceptReservation" class="btn btn-primary btn-block" type="submit">Apstiprinât rezervâciju</a>
						
							<a class="btn btn-block btn-default" href="?f=Documents" style="background-position:0 0">Atgriezties</a>
							<br>
							<br>
							<?
							if (!$data['var_labot']){?>	
								<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
							<?}?>
							<? include("v_cancel_reservation.php");	?>
						</div>
				</div>
					<?
					}
					else{?>
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="headingThree">
								<h4 class="panel-title">
									<a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion1" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
										<i class="more-less glyphicon glyphicon-plus"></i>
										Norçíini
									</a>
								</h4>
							</div>
							<div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
								<div class="panel-body col-md-5">
								<table class="table">
									<tr>
										<th>Ceïojuma cena:</th>
										<td align="right"><?=$data['kopsumma'];?> <?=$data['grupas_valuta'];?></td>
									</tr>
									<?
									if ($data['piemaksa'] >0){
										?>
										<tr>
											<th>Piemaksas:</th>
											<td align="right"><?=$data['piemaksa'];?> <?=$data['grupas_valuta'];?></td>
										</tr>
										<?
									}
									if ($data['atlaide'] >0){
										?>
										<tr>
											<th>Atlaides:</th>
											<td align="right"><?=$data['atlaide'];?> <?=$data['grupas_valuta'];?></td>
										</tr>
										<?
									}
								
									?>
									<tr>
										<th>Iemaksâts:</th>
										<td align="right"><?=CurrPrint($data['iemaksats']-$data['izmaksats']);?> <?=$data['grupas_valuta'];?></td>
									</tr>
									
									<tr>
										<th>Vçl jâmaksâ:</th>
										<td align="right"><?=$data['jamaksa'];?> <?=$data['grupas_valuta'];?></td>
									</tr>
								</table>
								</div>
								<div class="col-md-12">
								<form class="form-horizontal" method="POST" id="iemaksu_forma" action="?f=Summary">
									<input name=post value=1 hidden>
								<? /*if ($data['jamaksa'] == 0){?>
								<a id="view_contract" href="c_reservation.php?f=GenerateContract" target="_blank" onclick=''>Skatît lîgumu</a> 
												<? if ($data['apstiprinats']) $text = 'apstiprinâts';
												else $text = 'nav apstiprinâts';
												?><span class="text-muted">(<?=$text;?>)</span>
								<?}
								else*/ if ($data['jamaksa'] > 0){?>
									<h4>Veikt iemaksas</h4>
									
										<ul class="list-unstyled">
										
										<?
										foreach ($data['celotaji'] as $dalibn){
											?>
											<li>
												<div class="col-sm-12">
													<label for="summa_<?=$dalibn["ID"];?>" />
												</div>
												<div class="form-group">
													
													<label  class="control-label col-sm-3"><?=$dalibn['vards'].' '.$dalibn['uzvards'];?></label>
													<div class="col-sm-9">
														
														<input name=summa_<?=$dalibn["ID"];?> id="summa_<?=$dalibn["ID"];?>" type="text" class="form-control summa" step="0.01" min="0" style="width:8em;float:left;text-align:right" value="" required autocomplete="off" />
														<span  style="">
														<label  class="control-label"> <?=$data['grupas_valuta'];?>  <span style="font-weight:normal">(<? if ($dalibn['min_summa']!=$dalibn['jamaksa']) echo $dalibn['min_summa']." ".$data['grupas_valuta']." - ";?><?=$dalibn['jamaksa'];?> <?=$data['grupas_valuta'];?>)</span></label></span>
													</div>
												</div>
										<?}?>
										</ul>	
										<div class="">
										<h4> Maksâjuma kopsumma: <b>
											<span id="karteja_iemaksa_sum">0.00</span> <?=$data['grupas_valuta'];?></b></h4>
										</div>
										<?}?>
										<div class="col-sm-12">
											<div class="checkbox">
												<label for=accepted style="font-weight:700">
													<input type="checkbox" name="accepted" id="accepted"  class="" <? if ($data['apstiprinats']) echo "checked";?>>
														<a id="view_contract" href="?f=GenerateContract" target="_blank" onclick=' $("#view_contract").attr("href", "?f=GenerateContract&avanss=" + $("#karteja_iemaksa_sum").html());'>Apskatît</a>
														un akceptçt 
														<a id="view_contract_2" href="?f=GenerateContract&save=1" target="_blank" onclick='$("#view_contract_2").attr("href", "?f=GenerateContract&save=1&avanss=" + $("#karteja_iemaksa_sum").html());'>
														lîgumu</a>
												</label>
												<br>
												<? if (!empty($data['pdf_apraksts'])){?>
												<a href="https://www.impro.lv/pdf/<?=$data['pdf_apraksts'];?>.pdf" target="_blank"><big><i class="glyphicon glyphicon-file"></i> Lîgums - Marðruta apraksts</big></a><br>
												<?}?>
											</div>
										</div>
										<br>
										<br>
										<div class="col-md-12">
											<?if (!$data['apstiprinats']){?><div class="alert alert-info">Lai veiktu maksâjumu, nepiecieðams akceptçt lîgumu</div> <?}?>
										</div>
													<?
										$button = 'Maksât';
										?> 
										<div class="panel-body col-md-12">
											<!--<a id="view_contract" href="c_reservation.php?f=GenerateContract" target="_blank" onclick=' $("#view_contract").attr("href", "c_reservation.php?f=GenerateContract&avanss=" + $("#karteja_iemaksa_sum").html());'>Skatît lîgumu</a> 
												<? if ($data['apstiprinats']) $text = 'apstiprinâts';
												else $text = 'nav apstiprinâts';
												?><span class="text-muted">(<?=$text;?>)</span>-->
											<div class=" form-group" style="margin-top:10px;">
											<? if (!$data['apstiprinats'] && $data['jamaksa']<=0 ){?>
												<div class="col-md-4">
												<button id="submitBtn" name="apstiprinat" class="btn btn-primary btn-block submitBtn" type="submit" disabled onclick="BezIemaksam()">Saglabât</button>
												</div>
											<?}elseif($data['jamaksa']>0 ){
												
												//if ($data['apstiprinats']){
													?>
													<div class="col-md-4">
														<button id="submitBtn"  name="maksat" class="btn btn-primary btn-block submitBtn" type="submit" <?if (!$data['apstiprinats']) echo "disabled";?>>Maksât</button>
													</div>
													<?
												//}
												/*else{
													?>
													<div class="col-md-4">
															<button id="submitBtn" name="apstiprinat_un_maksat" class="btn btn-primary btn-block" type="submit" >Apstiprinât lîgumu un maksât</button>
													</div>
													<?
												}*/?>
												<?
												//ja ir pârìenerçts esoðais lîgums globâ un iemaksas jau ir veiktas
												if ($data['iemaksats']>0 && !$data['apstiprinats']){
													//if (isset($_SESSION['test'])){
														?>
														<div class="col-md-4">
														<button id="submitBtn1" name="apstiprinat"  class="btn btn-primary btn-block submitBtn" type="submit" disabled onclick="BezIemaksam()">Saglabât</button>
														</div>
														<?
													//}
												}
												?>
											
											<?}?>
										<div class="clearfix"></div>
										<div class="col-md-4" style="padding-top:5px">
										<?if (!$data['apstiprinats']){?>
											
											<a class="btn btn-block btn-default" href="?f=Documents" style="background-position:0 0">Atgriezties</a>
										
											<?
										}else{?>
												<div class="col-sm-6 col-sm-offset-3" >
													<a class="btn btn-block btn-default" href="?f=Documents&dir=back" style="background-position:0 0"><< </a>
												
												</div>
													
												<br>
												<br>											
												<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
											<?}?>
											</div>
											<?if ($data['iemaksats']==0){ 
											?>
											<div class="clearfix"></div>
											<div class="col-md-4">
												<?	
												include("v_cancel_reservation.php");
												?> 
											</div>
												<?												
											}
											?>
											
												</div>
										</div>
									</form>
			
								
								</div>
							</div>
						</div>
					<?}?>

					</div><!-- panel-group -->
					
					



				</div>
				
				
			<!--</form>-->
						
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
		<? } else { ?>
			<? include 'i_reservation_fb_track.php'?>
		<? } ?>
	</body>
	<div id="payment_dialog" class="modal fade bs-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" >
    <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
	      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Izvçlieties apmaksas veidu</h4>
      </div>
        <div class="modal-body" id="dialog-download" style="text-align:center;margin:auto;">
	
		
			<button class="btn btn-block btn-primary">Ar maksâjumu karti</button>
			<button class="btn btn-block btn-primary">Izmantojot Swedbank internetbanku</button>
			<button class="btn btn-block btn-primary">Izmantojot DNB banka internetbanku</button>
			<button class="btn btn-block btn-primary">Izmantojot SEB internetbanku</button>
			<button class="btn btn-block btn-primary">Izmantojot Citadele internetbanku</button>
		</div>
		<div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" style="background-position:0 0">Atcelt</button>
       
      </div>
	</div>
	</div>

</html>
<style>
/*******************************
* ACCORDION WITH TOGGLE ICONS
* Does not work properly if "in" is added after "collapse".
* Get free snippets on bootpen.com
*******************************/
	.panel-group .panel {
		border-radius: 0;
		box-shadow: none;
		border-color: #EEEEEE;
	}

	.panel-default > .panel-heading {
		padding: 0;
		border-radius: 0;
		color: #212121;
		background-color: #FAFAFA;
		border-color: #EEEEEE;
	}

	.panel-title {
		font-size: 14px;
	}

	.panel-title > a {
		display: block;
		padding: 15px;
		text-decoration: none;
	}

	.more-less {
		float: left;
		padding-right:10px;
		color: #212121;
	}

	.panel-default > .panel-heading + .panel-collapse > .panel-body {
		border-top-color: #EEEEEE;
	}

</style>
<script>
$( document ).ready(function() {
	if (<? echo $data['apstiprinats'];?> || <? echo $data['rez_apstiprinata'];?>){
		$('#collapseThree').collapse('show');
	}
	else{
		
		$('#collapseOne').collapse('show');
		$('#collapseTwo').collapse('show');
	}
	var the_terms = $("#accepted");

    the_terms.click(function() {
        if ($(this).is(":checked")) {
            $(".submitBtn").removeAttr("disabled");
        } else {
            $(".submitBtn").attr("disabled", "disabled");
        }
    });
	//--- saskaita ievadîtâs maksâjumu summas
		$(":input[name^='summa_']").bind('keyup mouseup', function () {

			var summa = 0.00;
			$(":input[name^='summa_']").each(function() {	
				var summa_dalibn = parseFloat(this.value);
				if( isNaN( summa_dalibn ) ) summa_dalibn = 0.00; 			
				summa += summa_dalibn;
				
			});
			//console.log(summa)
			if( isNaN( parseFloat( summa ) ) ) summa = 0.00; 
			$("#karteja_iemaksa_sum").html( parseFloat(summa).toFixed(2));
		});
});
/*$("#iemaksu_forma").submit(function(e){
    e.preventDefault();
    $.ajax({
        type : 'POST',
        data: $("#iemaksu_forma").serialize(),
        url : 'c_reservation.php?f=MakePayment',
        success : function(data){
           // $("#download_link").html(data);
            $("#payment_dialog").modal("show");
        }
    });
    return false;
});*/
	function toggleIcon(e) {
        $(e.target)
            .prev('.panel-heading')
            .find(".more-less")
            .toggleClass('glyphicon-plus glyphicon-minus');
    }
    $('.panel-group').on('hidden.bs.collapse', toggleIcon);
    $('.panel-group').on('shown.bs.collapse', toggleIcon);
	
	
	function BezIemaksam(){
		$("input[name^='summa_']").removeAttr('required');
	}
</script>

