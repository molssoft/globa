<? if (!$_SESSION['init']) die('Error:direct access denied');?>

<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head_utf.php'?>
	<body>
		<div class="container">
			<div style="width:100%; text-align:center">
				<a href="c_home.php"><img src="img/logo2.png" style="margin:20px;width:150px;"></a>
			</div>
			<div style="height:30px"></div>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_invoice.php<? if (isset($_GET['id'])) echo '?id='.(int)$_GET['id']; ?>" style="margin-bottom:25px" id="invoice_company_form">
				<div class="row">
					<input name="post" value="1" type="hidden">
					<? include 'i_handler_values.php'?>
					<? include 'i_handler_errors.php'?>

					<div class="col-sm-12">
						<h2>Uzņēmuma dati (rēķiniem)</h2>
						<? 
						$message = '';
						if (isset($data['invoice_status']) && $data['invoice_status'] === 'requested') {
							$message = 'Rēķins pieprasīts';
						} elseif (isset($data['invoice_status']) && $data['invoice_status'] === 'sent') {
							$message = 'Rēķins nosūtīts';
						} elseif (isset($data['success'])) {
							$message = $data['success'];
						}
						if ($message !== '') { ?>
							<div class="alert alert-success"><?=$message;?></div>
						<? } ?>
					</div>

					<div class="col-sm-12">
						<label for="company_name">Uzņēmuma nosaukums <span style="color:#c00">*</span></label>
						<input name="company_name" class="form-control" id="company_name" placeholder="Uzņēmuma nosaukums" value="" autocomplete="off">
					</div>

					<div class="col-sm-12">
						<label for="company_reg">Reģistrācijas numurs <span style="color:#c00">*</span></label>
						<input name="company_reg" class="form-control" id="company_reg" placeholder="Reģistrācijas numurs" value="" autocomplete="off">
					</div>

					<div class="col-sm-12">
						<label for="company_vat">PVN maksātāja numurs</label>
						<input name="company_vat" class="form-control" id="company_vat" placeholder="PVN maksātāja numurs" value="" autocomplete="off">
					</div>

					<div class="col-sm-12">
						<label for="company_address">Juridiskā adrese <span style="color:#c00">*</span></label>
						<textarea name="company_address" class="form-control" id="company_address" placeholder="Juridiskā adrese" rows="3"></textarea>
					</div>

					<div class="col-sm-12">
						<label for="company_bank_name">Bankas nosaukums</label>
						<input name="company_bank_name" class="form-control" id="company_bank_name" placeholder="Bankas nosaukums" value="" autocomplete="off">
					</div>

					<div class="col-sm-12">
						<label for="company_bank_account">Bankas konta numurs</label>
						<input name="company_bank_account" class="form-control" id="company_bank_account" placeholder="Bankas konta numurs" value="" autocomplete="off">
					</div>

					<div id="invoice_validation_error" class="col-sm-12" style="display:none; color:#c00; margin-top:10px; font-weight:bold;"></div>

					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
						<? if (!isset($data['invoice_status']) || ($data['invoice_status'] !== 'requested' && $data['invoice_status'] !== 'sent')) { ?>
							<button class="btn btn-primary btn-block" type="submit" id="invoice_submit_btn">Pieprasīt rēķinu</button>
						<? } ?>
					</div>
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
						<a class="btn btn-block btn-default" href="c_home.php">Atgriezties uz sākumu</a>
					</div>
				</div>
			</form>
		</div>
		<script>
		(function() {
			var form = document.getElementById('invoice_company_form');
			var errEl = document.getElementById('invoice_validation_error');
			var mandatoryFields = [
				{ id: 'company_name', label: 'Uzņēmuma nosaukums' },
				{ id: 'company_reg', label: 'Reģistrācijas numurs' },
				{ id: 'company_address', label: 'Juridiskā adrese' }
			];
			form.addEventListener('submit', function(e) {
				e.preventDefault();
				errEl.style.display = 'none';
				errEl.textContent = '';
				var missing = [];
				for (var i = 0; i < mandatoryFields.length; i++) {
					var inp = document.getElementById(mandatoryFields[i].id);
					var val = (inp && inp.value) ? inp.value.trim() : '';
					if (val === '') missing.push(mandatoryFields[i].label);
				}
				if (missing.length > 0) {
					errEl.textContent = 'Lūdzu aizpildiet obligātos laukus: ' + missing.join(', ') + '.';
					errEl.style.display = 'block';
					return false;
				}
				form.submit();
			});
		})();
		</script>
	</body>
</html>
