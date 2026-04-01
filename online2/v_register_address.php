<? if (!$_SESSION['init']) die('Error:direct access denied'); 


?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body>
		<? if (isset($data['script'])) echo $data['script'];?>
		<div class="container">		
		
			<? include 'i_register_steps.php'?>
			
			<div style="height:50px"></div>
			<BR>

			<form class="form-signin col-md-4 col-md-offset-4" method="post" action="c_register.php?f=address" style="margin-bottom:25px">
				<div class="row">
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				
				<div class="col-sm-12">
					<h1>Adrese</h1>
			
				<div class=error><? if (isset($data['message'])) echo $data['message'];?></div>
				<? if (isset($data['success'])){?><div class="alert alert-success"><?=$data['success'];?></div>
			
				<?}?>
				</div>
				<div class="col-sm-12">
					<label for="adrese">Mâja, iela, numurs</label>
					<input name="adrese" class="form-control" placeholder="" value="<?=$data['values']['adrese']?>"
						required autofocus id="adrese" autocomplete="off">
				</div>
				
				<div class="col-sm-12">
					<label for="pilseta">Pilsçta/Pagasts</label>
					<input name="pilseta" class="form-control" placeholder="" value="<?=$data['values']['pilseta']?>"
						 autofocus id="pilseta" autocomplete="off">
				</div>
				
				<div class="col-sm-12">
					<label for="novads">Novads</label>						
					<select name="novads" class="form-control col-sm-12" >
						<option value=0></option>
						<? foreach ($data['novadi'] as $novads){?>
							<?//if ((isset($_SESSION['username'])) || ((!isset($_SESSION['username'])) && (strpos($novads['nosaukums'], '*') == false))){//nerâdît vecos novadus jaunâm reìistrâcijâm?>
							<?if (strpos($novads['nosaukums'], '*') == false){//nerâdît vecos novadus?>
								<option value=<?=$novads['id'];?> <? if ($novads['id'] == $data['values']['novads']) echo "selected";?>><?=$novads['nosaukums'];?></option>
							<?}?>
						<?}?>
					</select>
					<!--
					<?if (isset($_SESSION['username'])){?>
						<div>(*) Novads pirms 2021. gada administratîvi teritoriâlâs reformas.</div>
					<?}?>
					-->
				</div>
				<div class="col-sm-12">
						<label  for="indekss" >Pasta indekss</label>
						<table width="100%">
							<tr>
							<td style="padding-bottom:10px">LV-</td>
							<td><input maxlength="4" name="indekss" id="indekss" class="form-control" placeholder="" value="<?=$data['values']['indekss']?>	"
								 autofocus autocomplete="off"></td>
							</tr>
						</table>
					</div>
				<!--<div class="col-sm-12">
				
					<label for="indekss">Pasta indekss</label>
					<input name="indekss" class="form-control" placeholder="" value=""
						required autofocus id="indekss">
				</div>-->
				
				<? if (isset($_SESSION['username'])){ $button= 'Saglabât';}
				else {$button = 'Turpinât';}
				?> 
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<button class="btn btn-primary btn-block" type="submit"><?=$button;?></button>
				</div>
					<?if (isset($_SESSION['username'])){?>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
					<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
				</div>
				<?}?>
</div>
			</form>
			
			
		</div>
		<? include 'i_register_fb_track.php'?>
	</body>


</html>

