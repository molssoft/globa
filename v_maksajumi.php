<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Maksâjumi","y1.jpg");
DefJavaSubmit();?>
<? if (isset($data['script'])){
	echo $data['script'];
}?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Maksâjumi</b></font><hr>

<?
// standarta saites
 
Headlinks();

 

 

?>
<br>

<? include 'online2/i_handler_values.php'?>
<? include 'online2/i_handler_errors.php'?>
<div align="center"><center>
<font color="GREEN" size="4"><b><?=$data['celojums'];?></b></font>
</center>
<br>
<br>

<form action="c_maksajumi.php" method="post" id="upload" enctype="multipart/form-data">

Ðobrîd var importçt ðâdus faila formâtus: 
<ul style="width:300px;text-align:left">
<li>SWEDBANK: xml (FiDAViSta)</li>
<li>SEB banka: csv</li>
</ul>
<label for="file"><b>Izvçlieties failu augðupielâdei:</b></label>
<br>
<br>
	<input type="file" id="file" name="file" size="50" required />

	<input name="upload" value="1" type="hidden">
<!--	<img src="impro/bildes/saglabat.jpg" alt="Augðupielâdçt" title="Augðupielâdçt" onclick="$('#upload').submit()" />-->
	<input type="submit"  name = "submit" value="Augðupielâdçt" />

		
	
	


  


  
</form>
<?
	require_once("online2/i_functions.php");?>
<center>

<? if (isset($_SESSION['message'])){
	echo '<font color="green">'.$_SESSION['message']."</font><br>";
	unset($_SESSION['message']);
}?>
<? if (!empty($data['maksajumi'])){?>
  <table border = 1 id="atrasts">
  <tr>
	<th>Maks. datums</th>
	<th style="min-width:270px">Konti</th>
	
	<th>Bank.ref.</th>
	
	<th>Online</th>
	<th>Vârds, uzvârds</th>
	
	<th>Personas_kods</th>
	<th>Detaïas</th>
	<th>Summa</th>
	<!--th>Valûta</th-->
	<th>Atrast_pieteikumus</th>
	<th></th>
	<th></th>

  </tr>
  <? foreach ($data['maksajumi'] as $row){
	//  print_r($row);
	  if ($row['pabeigts'])
		  $color = '#9dd49d';
	  else $color = '';
	?>
	<tr style="background-color:<?=$color;?>">
		<td><?=$db->Date2Str($row['maks_datums']);?></td>
		<td>
			<table><tr><td>Saò.konts:</td><td><small> <?=$row['san_konts'];?></small></td></tr>
			<tr><td>Maks.konts:</td><td> <small><?=$row['maks_konts'];?></small></td></tr></table>
		</td>
	
		<td><small><?=$row['bank_ref'];?></small></td>
		
			<td><? if($row['online']) echo '&#x2714; Online';?> </td>
		<td>
			<? if (!empty($row['did'])){?><a href="dalibn.asp?i=<?=$row['did'];?>"><?}?>
			<?=$row['maks_nos'];?>
			<? if (!empty($row['did'])){?></a><?}?>
		</td>
		
		<td><?=$row['maks_reg_nr'];?></td>
		<td><?=$row['detalas'];?></td>
		<td><?=$row['summa'];?> <?=$row['valuta'];?></td>
		
		<td><?
		 if (!empty($row['orderi'])){
			 ?>
			 Izveidoti orderi:
			 <ul style="padding-left:25px">
			 <?
			 foreach($row['orderi'] as $orderis){
				 ?>
				<li><a href="ordedit.asp?oid=<?=$orderis['id'];?>" target="_blank"><small>#<?=$orderis['num'];?></small> <?=number_format($orderis['summaval'],2);?> <?=$orderis['val'];?></a></li>
				 <?
			 }
			 ?>
			</ul>
			 <?
		 }
		?>
		Atlikums: <?=number_format($row['atlikums'],2);?> <?=$row['valuta'];?><br><br>
		<?		 
		 if(!$row['pabeigts']){?>
		
		
			<? if (isset($data['pid_arr'][$row['id']])){
				
				?>
				Grupa: <select onchange="showPids($(this).val())">
					</option></option>
				<?
				$first_gid = $data['pid_arr'][$row['id']]['grupas'][0]['ID']; 
				//echo "first gid: $first_gid<br>";
				foreach($data['pid_arr'][$row['id']]['grupas'] as $grupa){
					//var_dump($grupa);
				?>
				<option value="<?=$grupa['ID'];?>"><?=$grupa['kods'];?> <?=$grupa['v'];?> <?=$db->Date2Str($grupa['sakuma_dat']);?></option>
				<?
				}
				?>
				</select>
				
				<?
				
				foreach($data['pid_arr'][$row['id']]['pieteikumi'] as $gid=>$pieteikumi){
					?>
					<form action="c_maksajumi.php?f=CreateOrders" method="POST">
					<input name="post" type="hidden" value="1">
						<input name="maks_id" type="hidden" value="<?=$row['id'];?>">
						<input name="gid" type="hidden" value="<?=$gid;?>">
					<div id="gid_<?=$gid;?>" class="pid" style="display:none">
						<table>
							<tr>
								<th></th><th>Pieteikums</th><th>Ordera summa</th>
							</tr>
					<?
					foreach($pieteikumi as $piet){
					?>
						<tr>
							<td>
								<input type="checkbox" value="<?=$piet['pid'];?>" name="pid[]" checked onclick="if($(this).is(':checked')) {$('#summa_pid_<?=$piet['pid'];?>').prop('disabled', false);}else{$('#summa_pid_<?=$piet['pid'];?>').prop('disabled', true);}"></td>
								<td><a href="pieteikums.asp?pid=<?=$piet['pid'];?>" target="_blank"><?=$piet['pid'];?></a></td>
							<td>
								<input type="number" id="summa_pid_<?=$piet['pid'];?>" name="summa_pid[<?=$piet['pid'];?>]" value="<?=round($piet['bilance'],2);?>" required min="0.01" step="0.01"/>
							</td>
						</tr>
						
						<?
					}
					if (count($pieteikumi) == 1){
						$text = 'Sagatavot orderi<br>izvçlçtajam pieteikumam';
					}
					else{
						$text = 'Sagatavot orderus<br>izvçlçtajiem pieteikumiem';
					}
					?>
						</table>
						<button type="submit"><?=$text;?></button>
						</form>
						</div>
						<?
				}
				?>
				<script>
					function showPids(gid){
						$('.pid').hide();
						$('#gid_'+ gid + '').show();
					}
					$(function() {
						showPids(<?=$first_gid;?>);
					});
				</script>
				<?
			}
			else{
				?><a href="c_maksajumi.php?f=GetPossiblePids&id=<?=$row['id'];?>">Atrast pieteikumus</a>
				<?
			}
		}?></td>
		<td>
		<? $btn_text=($row['pabeigts'] ? 'Nav pabeigts' : 'Pabeigts');?>
			<form id="update_form" action="c_maksajumi.php?f=completed" method="POST">
				<input type="hidden" name="update_id" value="<?=$row['id'];?>">
				<input type="hidden" name="pabeigts" value="<?=(int)!$row['pabeigts'];?>"/>
				<button type="submit"><?=$btn_text;?></button>
			</form>
		</td>
		<td><form id="delete_form_<?=$row['id'];?>" action="c_maksajumi.php?f=delete" method="POST"><input type="hidden" name="delete_id" value="<?=$row['id'];?>">
			<img src="impro/bildes/dzest.jpg" onclick="if (confirm('Vai tieðâm vçlaties dzçst ðo maksâjumu?')) $('#delete_form_<?=$row['id'];?>').submit(); " alt="Dzçst" title="Dzçst" /></form></td>
	</tr>
	<?


  }
  ?>
  </table>
  <?
}?>

<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>


</body>
</html>