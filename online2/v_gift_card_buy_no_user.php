<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>
<script>
		
	function changePhone(){
		
		var talr_veids = $('#talr_veids').val();
		
		if (talr_veids == 'mobile_number'){
			$('#home_phone').hide();
			$('#work_phone').hide();
			$('#cell_phone').show();
		
		}
		else if (talr_veids == 'home_number'){
			$('#work_phone').hide();
			$('#cell_phone').hide();
			$('#home_phone').show();
		
		}
		else if (talr_veids == 'work_number'){
			$('#cell_phone').hide();
			$('#home_phone').hide();
			$('#work_phone').show();
		
		}

	}
	</script>
	<body>
		<?if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
			<div style="width:100%; text-align:center">
				<a href="https://www.impro.lv/online"><img src=img/logo2.png style="margin:20px;width:150px;"></a>
			</div>
			
			
			<!--div style="height:50px"></div-->
				<br>
			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="?f=BuyGiftCardNoUser">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php';
				//var_dump($data['errors']);?>
				
				<div class="col-sm-12">
					<h2>Pirkt dâvanu karti</h2>
				
				<div class=error><? if(isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="vards">Vârds</label>
					<input name="vards" class="form-control" placeholder="" value=""
					
						required autofocus id="vards" style="text-transform:uppercase" autocomplete="off">
				</div>
				
				<div class="col-sm-12">
					<label for=uzvards>Uzvârds</label>
					<input name="uzvards" class="form-control col-md-2" placeholder="" value=""
					
						required id="uzvards" style="text-transform:uppercase" autocomplete="off">
				</div>
				<div class="col-sm-12">
					<label for="eadr">E-pasts</label>
					<input name="eadr" type="email" class="form-control" placeholder="" value=""
						required autofocus id="eadr" required autocomplete="off">
				</div>
				<div class="" >
					<label class="col-sm-12" style=""  for="phone_number">Tâlruòa numurs</label>
					
					<div class="col-sm-12 col-md-5" style="" >
						<?// echo $data['checked_talr_veids_'.$i];?>
						<select name="talr_veids" id="talr_veids" onChange="changePhone()" class="form-control" >
							<option value="mobile_number" selected >Mobilais</option>
							<option value="home_number" >Mâjas</option>
							<option value="work_number" >Darba</option>
							
						</select>
					</div>
			
			
					<div class="col-sm-12 col-md-7" style=""  id="home_phone" >
						<input name="home_numberr" class="form-control" placeholder="" value=""
							id="home_number" autocomplete="off">
					</div>
					<div class="col-sm-12 col-md-7"  style="" id="work_phone" >
						<input name="work_numberr" class="form-control" placeholder="" value=""
							id="work_number" autocomplete="off">
					</div>
					<div class="col-sm-12 col-md-7"  style=""  id="cell_phone" >
						<input name="mobile_numberr" class="form-control" placeholder="" value=""
							id="mobile_number" autocomplete="off">
					</div>
				</div>
						
						
				
				
				<div class="col-sm-12">
					<label for="summa">Summa</label>
					<!--<input name="summa" class="form-control" placeholder="" value=""
					 autofocus id="summa" >-->
					 <br>
					  <small id="emailHelp" class="form-text text-muted">Minimâlâ dâvanu kartes summa ir 10.00 EUR</small>
					
					<input name="summa" type="text" min="<?=$data['min_summa'];?>" max="<?=$data['max_summa'];?>" class="form-control" placeholder="" value=""
						required autofocus id="summa" autocomplete="off" >
				</div>
				<div class="col-sm-12">
					<label for="kam">Kam <small>(Ðis teksts parâdsies uz dâvanu kartes)</small></label>
					<!--<input name="summa" class="form-control" placeholder="" value=""
					 autofocus id="summa" >-->
					<input name="kam" type="text" id="kam" class="form-control" placeholder="" value=""
						autofocus id="summa"  autocomplete="off">
				</div>

				<div class="col-sm-12">
					<div class="checkbox">
						<label for="issue_company_invoice">
							<input type="checkbox" name="issue_company_invoice" id="issue_company_invoice" value="1">
							Izrakstît uzòçmuma rçíinu
						</label>
					</div>
				</div>
				<div id="gift_card_invoice_section" style="display:none;">
					<div class="col-sm-12">
						<label for="company_name">Uzòçmuma nosaukums <span style="color:#c00">*</span></label>
						<input name="company_name" class="form-control" id="company_name" placeholder="Uzòçmuma nosaukums" value="" autocomplete="off">
					</div>
					<div class="col-sm-12">
						<label for="company_reg">Reìistrâcijas numurs <span style="color:#c00">*</span></label>
						<input name="company_reg" class="form-control" id="company_reg" placeholder="Reìistrâcijas numurs" value="" autocomplete="off">
					</div>
					<div class="col-sm-12">
						<label for="company_vat">PVN maksâtâja numurs</label>
						<input name="company_vat" class="form-control" id="company_vat" placeholder="PVN maksâtâja numurs" value="" autocomplete="off">
					</div>
					<div class="col-sm-12">
						<label for="company_address">Juridiskâ adrese <span style="color:#c00">*</span></label>
						<textarea name="company_address" class="form-control" id="company_address" placeholder="Juridiskâ adrese" rows="3"></textarea>
					</div>
					<div class="col-sm-12">
						<label for="company_bank_name">Bankas nosaukums</label>
						<input name="company_bank_name" class="form-control" id="company_bank_name" placeholder="Bankas nosaukums" value="" autocomplete="off">
					</div>
					<div class="col-sm-12">
						<label for="company_bank_account">Bankas konta numurs</label>
						<input name="company_bank_account" class="form-control" id="company_bank_account" placeholder="Bankas konta numurs" value="" autocomplete="off">
					</div>
				</div>
				<div class="col-sm-12">
					<div class="checkbox">
							<label for=accepted style="font-weight:700">
								<input type="checkbox" name="accepted" id="accepted"  required>Esmu iepazinies ar lietoðanas <a href="files/Online davanu kartes.pdf" target="_blank">noteikumiem</a> un tiem piekrîtu
					</label>
					</div>
				</div>
				<div class="col-sm-12 text-center">
					<a id="previewGiftCard">Priekðskatît dâvanu karti</a>
				</div>
				<!--<div class="col-sm-12">
				 <b>Noteikumi</b>
				 <p></p>
				</div>-->
					
				
				
			
				
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block submitBtn" type="submit" >Pirkt</button>
				</div>
				
				

			</form>
			
			
		</div>
	</body>


</html>
<script>
$("#previewGiftCard").on('click',function(){
	var cena = $("#summa").val();
	var kam = $("#kam").val();
	$.ajax({
	  method: "POST",
	  url: "c_reservation.php?f=ViewDk",
	  data: { cena: cena, kam: kam }
	})
	.done(function( data ) {
	 
		var links = document.createElement('a');
                  document.body.appendChild(links); 
                  links.download = 'davanu_kartes_paraugs.pdf';
                  links.href = data;
                  links.click();
                  document.body.removeChild(links); 
    
  });
});
$( document ).ready(function() {
		changePhone();
	$("#issue_company_invoice").on("change", function() {
		if ($(this).is(":checked")) {
			$("#gift_card_invoice_section").show();
		} else {
			$("#gift_card_invoice_section").hide();
		}
	});
	if ($("#issue_company_invoice").is(":checked")) {
		$("#gift_card_invoice_section").show();
	}
	var the_terms = $("#accepted");
  
});
</script>


