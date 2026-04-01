<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<?if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
	<div style="width:100%; text-align:center">
			<img src=img/logo2.png style="margin:20px;width:150px;">
		</div>
			
			
			<div style="height:50px"></div>
		
				
				<? //var_dump($_SESSION['reservation']['online_rez_id']);
				/*if (isset($_SESSION['reservation']['online_rez_id'])){
					?>
					<div class="col-md-4 col-md-offset-4"><?
					require_once("i_timer.php");
					?>
				</DIV>
				<?}*/?>
				<br>
			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_reservation.php?f=BuyGiftCard">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="col-sm-12">
					<h4>Pirkt dâvanu karti</h4>
				
				<div class=error><? if(isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="summa">Summa</label>
					<!--<input name="summa" class="form-control" placeholder="" value=""
					 autofocus id="summa" >-->
					 <br>
					 <small id="emailHelp" class="form-text text-muted">Minimâlâ dâvanu kartes summa ir 10.00EUR</small>
					<input name="summa" id="summa" type="text" step="0.01" min="<?=$data['min_summa'];?>" max="<?=$data['max_summa'];?>" class="form-control" placeholder="" value=""
						required autofocus id="summa" autocomplete="off" >
						
				</div>
				<div class="col-sm-12">
					<label for="kam">Kam <small>(ðis teksts parâdîsies uz dâvanu kartes)</small></label>
					<!--<input name="summa" class="form-control" placeholder="" value=""
					 autofocus id="summa" >-->
					<input name="kam" type="text" id="kam" class="form-control" placeholder="" value=""
						autofocus autocomplete="off" >
				</div>
				<!--<div class="col-sm-12">
				 <b>Noteikumi</b>
				 <p></p>
				</div>-->
				<div class="col-sm-12">
					<div class="checkbox">
							<label for=accepted style="font-weight:700">
								<input type="checkbox" name="accepted" id="accepted"  required>Esmu iepazinies ar lietoðanas <a href="files/Online davanu kartes.pdf" target="_blank">noteikumiem</a> un tiem piekrîtu
						</label>
					</div>
				</div>
				<div class="col-sm-12 text-center">
					<a id="previewGiftCard">Priekðskatît dâvanu karti</a>
					<? if (isset($_GET['test'])){?><a id="previewGiftCardTest" >Priekðskatît dâvanu karti</a><?}?>
				</div>
				

			
				
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block" type="submit">Pirkt</button>
				</div>
				<?if (isset($_SESSION['username'])){?>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
				<?}?>
				

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
                  document.body.removeChild(link); 
    
  });
});
$("#previewGiftCardTest").on('click',function(){
	var cena = $("#summa").val();
	var kam = $("#kam").val();
	$.ajax({
	  method: "POST",
	  url: "c_reservation.php?f=ViewDkTest",
	  data: { cena: cena, kam: kam }
	})
	.done(function( data ) {
	 
		var links = document.createElement('a');
                  document.body.appendChild(links); 
                  links.download = 'davanu_kartes_paraugs.pdf';
                  links.href = data;
                  links.click();
                  document.body.removeChild(link); 
    
  });
});
</script>

