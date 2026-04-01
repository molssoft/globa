<?require_once("i_functions_utf.php");

//standarts visām lapām
DocStart ("Dāvanu kartes rēķins","");
?>
	<div class="container" style="margin-top:20px; max-width:900px;">
		<?php Headlinks(); ?>
		<div style="text-align:center; margin-bottom:15px;">
			<h2>Rēķina dati (dāvanu karte)</h2>
		</div>

		<?php if ($message !== ''): ?>
			<div class="alert alert-success"><?=htmlspecialchars($message);?></div>
		<?php endif; ?>
		<?php if (!empty($rekina_online_url)): ?>
			<div class="alert alert-info">
				Rēķina fails:
				<a href="<?=htmlspecialchars($rekina_online_url, ENT_QUOTES, 'UTF-8');?>" target="_blank" rel="noopener">
					<?=htmlspecialchars($rekina_online_url, ENT_QUOTES, 'UTF-8');?>
				</a>
			</div>
		<?php endif; ?>

		<?php if (!empty($errors)): ?>
			<div class="alert alert-danger">
				<?php if (in_array('required', $errors, true)): ?>
					Lūdzu aizpildiet obligātos laukus (uzņēmums, reģ. nr., adrese).
				<?php elseif (in_array('post', $errors, true)): ?>
					Nederīgs pieprasījums. Lūdzu izmantojiet formu.
				<?php elseif (in_array('notfound', $errors, true)): ?>
					Pieteikums nav atrasts.
				<?php elseif (in_array('template', $errors, true)): ?>
					Neizdevās ielādēt rēķina veidni (PDF).
				<?php elseif (in_array('payment_date', $errors, true)): ?>
					Norādiet derīgu pēdējās iemaksas datumu (formāts dd.mm.gggg).
				<?php elseif (in_array('accounting', $errors, true)): ?>
					Neizdevās saglabāt rēķinu grāmatvedības datubāzē.
				<?php elseif (in_array('piegadataji', $errors, true)): ?>
					Neizdevās noteikt piegādātāja ierakstu.
				<?php elseif (in_array('rekins_exists', $errors, true)): ?>
					Rekins jau izveidots
				<?php elseif (in_array('file_save', $errors, true)): ?>
					Neizdevās saglabāt PDF failu diskā.
				<?php elseif (in_array('email', $errors, true)): ?>
					Lūdzu ievadiet korektu e-pastu.
				<?php elseif (in_array('email_queue', $errors, true)): ?>
					Neizdevās pievienot e-pastu nosūtīšanas rindai.
				<?php else: ?>
					Lūdzu aizpildiet obligātos laukus.
				<?php endif; ?>
			</div>
		<?php endif; ?>

		<form method="post" class="form-horizontal">
			<input type="hidden" name="post" value="1">

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_name">Uzņēmuma nosaukums *</label>
				<div class="col-sm-8">
					<input name="company_name" id="company_name" class="form-control"
						value="<?=htmlspecialchars((string)$company['company_name']);?>">
					<?php if (!empty($field_suggestions['company_name'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_name" data-value="<?=htmlspecialchars((string)$field_suggestions['company_name'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_name']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_reg">Reģistrācijas numurs *</label>
				<div class="col-sm-8">
					<input name="company_reg" id="company_reg" class="form-control"
						value="<?=htmlspecialchars((string)$company['company_reg']);?>">
					<?php if (!empty($show_no_supplier_msg)): ?>
						<div style="color:green; margin-top:4px;">
							Uzņēmums nav atrasts grāmatvedības sistēmā
						</div>
					<?php endif; ?>
					<?php if (!empty($field_suggestions['company_reg'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_reg" data-value="<?=htmlspecialchars((string)$field_suggestions['company_reg'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_reg']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_vat">PVN maksātāja numurs</label>
				<div class="col-sm-8">
					<input name="company_vat" id="company_vat" class="form-control"
						value="<?=htmlspecialchars((string)$company['company_vat']);?>">
					<?php if (!empty($field_suggestions['company_vat'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_vat" data-value="<?=htmlspecialchars((string)$field_suggestions['company_vat'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_vat']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_address">Juridiskā adrese *</label>
				<div class="col-sm-8">
					<textarea name="company_address" id="company_address" class="form-control" rows="3"><?=htmlspecialchars((string)$company['company_address']);?></textarea>
					<?php if (!empty($field_suggestions['company_address'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_address" data-value="<?=htmlspecialchars((string)$field_suggestions['company_address'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_address']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_bank_name">Bankas nosaukums</label>
				<div class="col-sm-8">
					<input name="company_bank_name" id="company_bank_name" class="form-control"
						value="<?=htmlspecialchars((string)$company['company_bank_name']);?>">
					<?php if (!empty($field_suggestions['company_bank_name'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_bank_name" data-value="<?=htmlspecialchars((string)$field_suggestions['company_bank_name'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_bank_name']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_bank_account">Bankas konta numurs</label>
				<div class="col-sm-8">
					<input name="company_bank_account" id="company_bank_account" class="form-control"
						value="<?=htmlspecialchars((string)$company['company_bank_account']);?>">
					<?php if (!empty($field_suggestions['company_bank_account'])): ?>
						<div style="color:#b00; margin-top:4px;">
							<a href="#" class="supplier-suggestion" data-target="company_bank_account" data-value="<?=htmlspecialchars((string)$field_suggestions['company_bank_account'], ENT_QUOTES, 'UTF-8');?>"><?=htmlspecialchars((string)$field_suggestions['company_bank_account']);?></a>
						</div>
					<?php endif; ?>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="company_email">E-pasts rēķina saņemšanai</label>
				<div class="col-sm-8">
					<input name="company_email" id="company_email" class="form-control" type="email"
						value="<?=htmlspecialchars((string)$company['company_email']);?>">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label">Dāvanu kartes summa</label>
				<div class="col-sm-8">
					<input class="form-control" type="text" readonly
						value="<?=htmlspecialchars((string)number_format((float)$dk_summa, 2, '.', ''));?> EUR">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label" for="last_payment_datums">Pēdējās iemaksas datums</label>
				<div class="col-sm-8">
					<input class="form-control" type="text" name="last_payment_datums" id="last_payment_datums"
						placeholder="dd.mm.yyyy"
						value="<?=htmlspecialchars($last_payment_datums_value, ENT_QUOTES, 'UTF-8');?>">
				</div>
			</div>

			<div class="form-group">
				<div class="col-sm-12" style="text-align:center; margin-top:15px;">
					<button type="button" class="btn-normal" onclick="window.location.href='c_davanu_kartes.php';">Atcelt</button>
					&nbsp;
					<button type="submit" formaction="c_davanu_kartes_rekins_generet.php?pid=<?=(int)$pid?>" name="go_invoice" value="1" class="btn-normal">Veidot rēķinu</button>
				</div>
			</div>
		</form>
	</div>
	<script>
	(function() {
		var links = document.querySelectorAll('.supplier-suggestion');
		for (var i = 0; i < links.length; i++) {
			links[i].addEventListener('click', function(e) {
				e.preventDefault();
				var targetId = this.getAttribute('data-target');
				var val = this.getAttribute('data-value') || '';
				var el = document.getElementById(targetId);
				if (!el) return;
				el.value = val;
				el.focus();
			});
		}
	})();
	</script>
</body>
</html>

