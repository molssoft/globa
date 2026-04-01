<? if (!$_SESSION['init']) die('Error:direct access denied');?>

<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head_utf.php'?>
	<body>
		<div class="container">
			<? require ('i_reservation_steps.php'); ?>
			<div style="height:30px"></div>
			<BR>
			<div class="row col-md-10 col-md-offset-1">
				<? if (isset($_SESSION['reservation']['online_rez_id'])){ require_once("i_timer.php"); } ?>
			</div>
			<div class="col-md-4 col-md-offset-4 text-center" style="padding-bottom:20px">
				<div class="col-sm-12">
					<h2>Ceļojuma apmaksa</h2>
				</div>
			</div>
			<div class="col-md-10 col-md-offset-1 text-center">
				<? if (isset($_SESSION["reg_err"])){ ?>
					<div class="alert alert-danger">
						<strong><?=$_SESSION["reg_err"];?></strong>
					</div>
					<? unset($_SESSION["reg_err"]); } ?>
			</div>
			<div class="col-md-10 col-md-offset-1 text-center">
				<? if (isset($_SESSION["reg_success"])){ ?>
					<div class="alert alert-success">
						<strong><?=$_SESSION["reg_success"];?></strong>
					</div>
					<? unset($_SESSION["reg_success"]); }
				else{ ?>
						<? if ($data['result']=='failed') {?>
							<div class="alert alert-danger">	
								<strong>Maksājums neizdevās. Mēģiniet vēlreiz vai sazinieties ar savu banku vai Impro biroju!</strong>
							</div>
						<? } else { ?>
							<div class="alert alert-success">	
								<strong>Paldies! Jūsu maksājums ir veiksmīgi saņemts.</strong>
							</div>
						<? } ?>
				<? } ?>
			</div>
			<div class="col-md-10 col-md-offset-1 text-center" style="margin-top:30px; margin-bottom:200px;">
				<p>
					<? if ($_SESSION['reservation']['online_rez_id']) { ?>
					<a href="c_reservation.php?f=Summary<?=(isset($_SESSION['reservation']['online_rez_id']) ? '&rez_id='.(int)$_SESSION['reservation']['online_rez_id'] : '');?>" class="btn btn-primary btn-lg">Apskatīt rezervācijas kopsavilkumu</a>
					<? } else { ?>
					<a href="c_home.php" class="btn btn-primary btn-lg">Uz sākumu</a>
					<? } ?>
				</p>
			</div>
		</div>
		<? if (!empty($data['show_conversion_script'])){ ?>
		<script>

			(function(){
				// Conversion: reservation has payment and [conversion] was 0/null; now set to 1.
				if (typeof dataLayer !== 'undefined') {
					dataLayer.push({ 'event': 'conversion', 'rez_id': <?=(int)$_SESSION['reservation']['online_rez_id'];?> });
				}

				// Purchase DataLayer event for GTM / GA4 / Meta (duplicate protection)
				var tid = "<?=(int)(isset($data['purchase_order_id']) ? $data['purchase_order_id'] : $_SESSION['reservation']['online_rez_id']);?>";
				var key = "purchase_sent_" + tid;
				try {
					if (sessionStorage.getItem(key)) return;
					sessionStorage.setItem(key, "1");
				} catch(e) {}

				var purchaseValue = <?=(float)(isset($data['purchase_total_value']) ? $data['purchase_total_value'] : 0);?>;
				var purchaseCurrency = "<?=isset($data['purchase_currency']) ? htmlspecialchars($data['purchase_currency'], ENT_QUOTES, 'UTF-8') : 'EUR';?>";
				var purchaseItems = <?=isset($data['purchase_items_json']) ? $data['purchase_items_json'] : '[]';?>;

				window.dataLayer = window.dataLayer || [];
				window.dataLayer.push({
					event: "purchase",
					transaction_id: tid,
					value: purchaseValue,
					currency: purchaseCurrency,
					items: purchaseItems
				});
			})();
		</script>
		<? } ?>
	</body>
</html>
