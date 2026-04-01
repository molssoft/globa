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

			<form class="form-signin col-md-4 col-md-offset-4" method="post" id="forma" action="?f=TravellerCount">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<!--<div class="row col-md-10 col-md-offset-1">
				<? /*if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
					<script src="js/CountDown.js"></script>
				
					<p align="right" >Laiks rezervâcijas veikðanai: <span id="CountDownPanel" ></span></p>
				<?}*/?>
				</div>-->
				<div class="col-sm-12">
					<h2>Ceïotâju skaits</h2>
				</div>
				<!--<div class=error><?=$data['message']?></div>-->
				
				<div class="col-sm-4">
				<label for=skaits></label>
			<!--</div>
				<div class="col-sm-12">
					<div class="col-sm-4">-->
					<? //echo $data['traveller_count'];?>
					<select name="skaits" class="form-control col-sm-4" placeholder="" value=""
						
						required autofocus id="skaits" >
						<option></option>
						<? for ($i=1;$i<=7;$i++){?>
						<option value="<?=$i;?>" <? if (isset($data['traveller_count']) && $data['traveller_count']==$i) echo "selected";?>><?=$i;?></option>
						<?}?>
					</select>
				</div>
				<!--</div>-->
				
				
			
				<div class="col-sm-12">
					<div class="checkbox">
							<label for=pats style="font-weight:700">
								<input type="checkbox" name="pats" id="pats"  class="" checked <?=$data['i_travel_ch'];?>>Es 
								<? if ($data['dzimums'] == 's') echo "pati";else echo "pats";?> braucu</label>
					</div>
				</div>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<? if ($data['var_labot']){	?> 
						<button class="btn btn-primary btn-block" type="submit">Turpinât</button>
					<?}
					else{?>
						<div class="col-sm-6 col-sm-offset-3">
							<a class="btn btn-block btn-default" href="?f=Travel" style="background-position:0 0">>> </a>
						</div>
						<br>
						<br>
						
					<?}
					if (!$data['ir_iemaksas'] && isset($_SESSION['reservation'])){
						include("v_cancel_reservation.php");	
					}
					else
					{
						/*?>
						<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
						<?*/
					}
					
					?>
											<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>

				</div>

			</form>
						
		</div>
		<? include 'i_reservation_fb_track.php'?>
	</body>


</html>
<? if (isset($data['test'])){?>
<script>
$(function() {
	setInterval(function(){update_user_sess();}, 10000);
});
function update_user_sess(){
 $.ajax({
    url : 'm_user_session.php?method=save&param=<?=$_SESSION['profili_id'];?>', //
   })
}

</script>
<?}?>
<? if (!$data['var_labot']){?>
<script>
$("#forma :input").attr("disabled", true);
</script>
<?}?>

