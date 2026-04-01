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
										Maksājumu termiņi
									</a>
								</h4>
							</div>
							<div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
								<div class="panel-body">
									<h3><?=$data['celojuma_nos'];?> (<?=$data['sakuma_dat'];?> - <?=$data['beigu_dat'];?>)</h3>
									<br>
									<? if (!empty($data['termini'])){
										?>
												<h4>Maksājumu termiņi</h4>
											<ol>
											<? $i=1; 
											foreach($data['termini'] as $termins){
												if ($i==1){
													$papildus_txt = '';
												}
												else if ($i== count($data['termini'])){
													$papildus_txt = 'pilnu summu ';
												}
												else{
														$papildus_txt = 'vēl ';
												}?>
												<li>Līdz <b><?=$termins['datums'];?></b> samaksāt <?=$papildus_txt?><b><?=$termins['summa'];?> <?=$data['grupas_valuta'];?></b></li>
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
										Pasūtītie pakalpojumi
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
											//var_dump( $pakalpojums);
											?>
											<tr>
												<td><?=$pakalpojums['nosaukums'];?></td>
												<td width="200px" align="right"><?=$pakalpojums['summaEUR'];?></td>
											</tr>
											<?
											//print_r($pakalpojums);
											//echo "<br><br>";
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
					<? if (!$data['apstiprinats'] && !$data['rez_apstiprinata']){

						//rāda rezervācijas apstiprināšanas pogu
						?>
						<div class="col-md-5 col-md-offset-4">
					
				 
						<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
							<a href="c_reservation.php?f=AcceptReservation" class="btn btn-primary btn-block" type="submit">Apstiprināt rezervāciju</a>
						
							<a class="btn btn-block btn-default" href="c_reservation.php?f=Documents" style="background-position:0 0">Atgriezties</a>
							<br>
							<br>
							<?
							if (!$data['var_labot']){?>	
								<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sākumu</a>
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
										Norēķini
									</a>
								</h4>
							</div>
							<div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
								<div class="panel-body col-md-5">
								<table class="table">
									<tr>
										<th>Ceļojuma cena:</th>
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
									if ($data['izmaksats'] > 0){
										?>
										<tr>
											<th>Izmaksas:</th>
											<td align="right"><?=$data['izmaksats'];?> <?=$data['grupas_valuta'];?></td>
										</tr>
										<?
									}
									?>
									<tr>
										<th>Iemaksāts:</th>
										<td align="right"><?=$data['iemaksats'];?> <?=$data['grupas_valuta'];?></td>
									</tr>
									
									<tr>
										<th>Vēl jāmaksā:</th>
										<td align="right"><?=$data['jamaksa'];?> <?=$data['grupas_valuta'];?></td>
									</tr>
								</table>
								</div>
								<div class="col-md-12">
								<form class="form-horizontal" method="POST" id="iemaksu_forma" action="c_reservation.php?f=Summary">
									<input name=post value=1 hidden>
								<? /*if ($data['jamaksa'] == 0){?>
								<a id="view_contract" href="c_reservation.php?f=GenerateContract" target="_blank" onclick=''>Skatīt līgumu</a> 
												<? if ($data['apstiprinats']) $text = 'apstiprināts';
												else $text = 'nav apstiprināts';
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
														
														<input name=summa_<?=$dalibn["ID"];?> id="summa_<?=$dalibn["ID"];?>" type="text" class="form-control" step="0.01" min="0" style="width:8em;float:left;text-align:right" value="" required><span  style=""> <label  class="control-label"> <?=$data['grupas_valuta'];?>  <span style="font-weight:normal">(<? if ($dalibn['min_summa']!=$dalibn['jamaksa']) echo $dalibn['min_summa']." ".$data['grupas_valuta']." - ";?><?=$dalibn['jamaksa'];?> <?=$data['grupas_valuta'];?>)</span></label></span>
													</div>
												</div>
										<?}?>
										</ul>	
										<div class="">
										<h4> Maksājuma kopsumma: <b>
											<span id="karteja_iemaksa_sum">0.00</span> <?=$data['grupas_valuta'];?></b></h4>
										</div>
										<?}?>
										<div class="col-sm-12">
											<div class="checkbox">
													<label for=accepted style="font-weight:700">
														<input type="checkbox" name="accepted" id="accepted"  class="" <? if ($data['apstiprinats']) echo "checked";?>>Akceptēt <a id="view_contract" href="c_reservation.php?f=GenerateContract" target="_blank" onclick=' $("#view_contract").attr("href", "c_reservation.php?f=GenerateContract&avanss=" + $("#karteja_iemaksa_sum").html());'>
											līgumu</a></label>
											</div>
										</div>
													<?
										$button = 'Maksāt';
										?> 
										<div class="panel-body col-md-12">
											<!--<a id="view_contract" href="c_reservation.php?f=GenerateContract" target="_blank" onclick=' $("#view_contract").attr("href", "c_reservation.php?f=GenerateContract&avanss=" + $("#karteja_iemaksa_sum").html());'>Skatīt līgumu</a> 
												<? if ($data['apstiprinats']) $text = 'apstiprināts';
												else $text = 'nav apstiprināts';
												?><span class="text-muted">(<?=$text;?>)</span>-->
											<div class=" form-group" style="margin-top:10px;">
											<? if (!$data['apstiprinats'] && $data['jamaksa']<=0 ){?>
												<div class="col-md-4">
												<button id="submitBtn" name="apstiprinat" class="btn btn-primary btn-block submitBtn" type="submit" disabled onclick="BezIemaksam()">Saglabāt</button>
												</div>
											<?}elseif($data['jamaksa']>0 ){
												
												//if ($data['apstiprinats']){
													?>
													<div class="col-md-4">
														<button id="submitBtn"  name="maksat" class="btn btn-primary btn-block submitBtn" type="submit" <?if (!$data['apstiprinats']) echo "disabled";?>>Maksāt</button>
													</div>
													<?
												//}
												/*else{
													?>
													<div class="col-md-4">
															<button id="submitBtn" name="apstiprinat_un_maksat" class="btn btn-primary btn-block" type="submit" >Apstiprināt līgumu un maksāt</button>
													</div>
													<?
												}*/?>
												<?
												//ja ir pārģenerēts esošais līgums globā un iemaksas jau ir veiktas
												if ($data['iemaksats']>0 && !$data['apstiprinats']){
													//if (isset($_SESSION['test'])){
														?>
														<div class="col-md-4">
														<button id="submitBtn1" name="apstiprinat"  class="btn btn-primary btn-block submitBtn" type="submit" disabled onclick="BezIemaksam()">Saglabāt</button>
														</div>
														<?
													//}
												}
												?>
											
											<?}?>
										<div class="clearfix"></div>
										<div class="col-md-4" style="padding-top:5px">
										<?if (!$data['apstiprinats']){?>
											
											<a class="btn btn-block btn-default" href="c_reservation.php?f=Documents" style="background-position:0 0">Atgriezties</a>
										
											<?
										}else{?>
												<div class="col-sm-6 col-sm-offset-3" >
													<a class="btn btn-block btn-default" href="c_reservation.php?f=Documents" style="background-position:0 0"><< </a>
												
												</div>
													
												<br>
												<br>											
												<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sākumu</a>
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
		<? include 'i_reservation_fb_track.php'?>
	</body>
	<div id="payment_dialog" class="modal fade bs-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" >
    <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
	      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Izvēlieties apmaksas veidu</h4>
      </div>
        <div class="modal-body" id="dialog-download" style="text-align:center;margin:auto;">
	
		
			<button class="btn btn-block btn-primary">Ar maksājumu karti</button>
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
	//--- saskaita ievadītās maksājumu summas
		$(':input[type="number"]').bind('keyup mouseup', function () {

			var summa = 0.00;
			$(':input[type="number"]').each(function() {		
				summa += parseFloat(this.value);
			});
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

