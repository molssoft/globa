<? if (!$_SESSION['init']) die('Error:direct access denied');

?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">
		
			<? require ('i_reservation_steps.php');
			?>
			
			<div style="height:30px"></div>
				<div class="row col-md-8 col-md-offset-2">
				<? 
				if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
				</DIV>
				<?}?>
		</div>
			<div class="col-md-4 col-md-offset-4">
				<div class="col-sm-12">
					<h2 "background-color:#fcf8e3" style="text-align: center;">Viesnîcas</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Hotels2">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="row" >
					<div class="col-md-8 col-md-offset-2">			
						<div class="col-sm-12">
							<label for="viesnica">Personu sadalîðana pa numuriem</label>
							<div class="alert alert-info">Izvçlieties katrai personai atbilstoðo numuru</div>

							<?
							foreach ($data['dalibnieki'] as $key => $dalibn){
								?>
								<div class="row col-lg-12"> 
									<div class="col-md-2 col-md-offset-3" style="padding-right:0;padding-left:0;">
										<label><?=$dalibn['vards']?> <?=$dalibn['uzvards']?></label>
									</div>
									<div class="col-md-4" style="padding-right:0;padding-left:0;">
										<select name="dalibn_<?=$dalibn['ID']?>" class="form-control " required="">
											<option value=0>-</option>
											<? foreach ($data['viesnicas'] as $vid => $room){ ?>
											<option value=<?=$vid?>><?=$room['pilns_nosaukums'].' #'.$room['num'].' '.$room['kopa']?></option>
											<? } ?>
										</select>
									</div>
								</div>
							<? } ?>
						</div>
					</div>
				</div>
				<div class="col-md-4 col-md-offset-4">
					<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
						<? if ($data['var_labot']){	?> 
							<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
							<a class="btn btn-block btn-default" href="?f=Cabins&dir=back" style="background-position:0 0">Atgriezties</a>
							<br>
							<br>
						<?}else {?>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Cabins&dir=back" style="background-position:0 0"></a>
							</div>
								<div class="col-sm-6 " >
									<a class="btn btn-block btn-default" href="?f=Services" style="background-position:0 0"></a>
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

<style>
td {
	padding-bottom:5px;
}
.dropdown-menu{
	top:10%;
}
.box{
	width:100%
}
 .img_person{
	height:40px;
 }
 .img_bed{
	 height:70px;
 }
 .td_bed{
	 height:50px;
 
 }
 .center{
    margin: 0 auto;
}

.right{
    margin-right: 0;
    margin-left: auto;
}

.left{
    margin-left: 0;
    margin-right: auto;
}
a:hover{text-decoration:none}

.dropdown-menu{
	position:fixed
}
</style>



