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
				<div class="row col-md-8 col-md-offset-2">
				<? //var_dump($_SESSION['reservation']['online_rez_id']);
				if (isset($_SESSION['reservation']['online_rez_id'])){
					require_once("i_timer.php");
					?>
				</DIV>
				<?}?>
		</div>
			<div class="col-md-4 col-md-offset-4">
				<div class="col-sm-12">
					<h2 "background-color:#fcf8e3">Viesnîcas</h2>
				</div>
			</div>
			<form class="form-signin col-md-12 " method="post" id="forma" action="?f=Hotels">
				
				<input name=post value=1 hidden>
				
				<? include 'i_handler_values.php'?>
				<? include 'i_handler_errors.php'?>
				<? //var_dump($data['errors']);?>
				<div class="row" >
				
						<div class="col-md-8 col-md-offset-2">			
				
			
				<?
				if (isset($data['viesnicas'])){
					$gultas_nr = 0;
				
					?>
				
				
					<div class="col-sm-12">
						<label for="viesnica">Viesnîcas numuri</label>
						<div class="alert alert-info">Lai izvçlçtos numuriòu, noklikðíiniet uz attçla<?if ($data['celotaju_skaits'] >1) {?> un izvçlieties ceïotâju<?}?>.</div>
					</div>
					
					
					<?
					foreach($data['viesnicas'] as $istaba){
						//echo "key $key<br>";
						//if ($key==0){
						//foreach ($istabas as $istaba){
						/*echo "ISTABA<br>";
						var_dump($istaba);
						echo "<br><br>";
						*/
						?>
						
						<div class="col-sm-6" style="margin-bottom:10px">
						<table frame="box" class="box">
						<tr><td colspan="<?=$istaba['vietas_kopa'];?>" align="center"><h4><?=$istaba['nosaukums'];?></h4></td></tr>
						<tr><? 
						//Numuriòi ar kopîgu gultu (DOUBLE, DOUBLE+x)
						if (strpos(strtoupper($istaba['veids']),'DOUBLE') !== false){
						//if ($istaba['veids'] == 'DOUBLE'){
							
							$kopa_ar_pieaugusie = array();
							$kopa_ar_berni = array();
							foreach ($istaba['kopa_ar'] as  $kopa_ar){
								if ($kopa_ar['kopa_ar_berns'] == 1){
									$kopa_ar_berni[] = $kopa_ar;
								}
								else{
									$kopa_ar_pieaugusie[] = $kopa_ar;
									
								}
							}
							//izdrukâ aizòemtâs pieauguðo vietas
							$i=0;
							$izdrukata_laba_puse = 0;
							$izdrukata_kreisa_puse = 0;
							foreach ($kopa_ar_pieaugusie as  $kopa_ar){
							
								$berna_vieta = 2;
								/*if ($kopa_ar['kopa_ar_berns'] == 1 && $aiznemtas_bernu_vietas<=$brivas_bernu_vietas){
									echo "bçrna";
									$img = $data['bed_images']['child'];
									$berna_vieta = 1;
								}*/
								//else{
									if ($kopa_ar['kopa_ar_dzimums'] == 's'){
										$img_person = $data['bed_images']['adult_F'];
										if (!$izdrukata_kreisa_puse){
											$img = $data['bed_images']['double_left_side'];
											$izdrukata_kreisa_puse = 1;
											$align = "right";
										}
										else{
											$img = $data['bed_images']['double_right_side'];
											$izdrukata_laba_puse = 1;
											$align = "left";
										}
									/*	if($i==0){
											$img = $data['bed_images']['double_left_side_F'];
											$align = "right";
											
										}
										else{
											$img = $data['bed_images']['double_right_side_F'];
											$align = "left";
										}*/
										
									}
									elseif ($kopa_ar['kopa_ar_dzimums'] == 'v'){
										$img_person = $data['bed_images']['adult_M'];
										if (!$izdrukata_kreisa_puse){
											$img = $data['bed_images']['double_left_side'];
											$izdrukata_kreisa_puse = 1;
											$align = "right";
										}
										else{
											$img = $data['bed_images']['double_right_side'];
											$izdrukata_laba_puse = 1;
											$align = "left";
										}
										/*if($i==0){
											$img = $data['bed_images']['double_left_side_M'];
											$align = "right";
										}
										else{
											$img = $data['bed_images']['double_right_side_M'];
											$align = "left";
										}*/
									}
									$i++;
								//}
								?>
								<td class="td_bed">
									<div style="position:relative" >
										<a class="dropdown-toggle" style="position:relative" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_3',0,<?=$berna_vieta;?>,event);">
									 
										<table class="<?=$align;?>">
											<tr>
												<td align="center" bgcolor=""  style=""><div style="<? if ($align == 'right') echo "padding-right:0.5ex"; elseif ($align=='left')
													echo "border: solid 0 black; border-left-width:2px;padding-left:0.5ex;";?>;height:40px;max-height:40px;overflow:hidden">
													<b style="color:#009E59"><?=$kopa_ar['kopa_ar_nosaukums'];?></b></div>
												</td>
											</tr>
											<tr>
												<td align="<?=$align;?>" style="height:40px">
													<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_1',0,<?=$berna_vieta;?>);">
														---><img class="img_person" src="<?=$img_person;?>"/>
													<!--</a> 
													<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

													</ul>-->
												</td>
											</tr>
											<tr>
												<td align="<?=$align;?>" >
												
												<div style="position:relative" >
													<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_2',0,<?=$berna_vieta;?>);">
														-->
														<img class="img_bed" align="<?=$align;?>" src="<?=$img;?>">
													<!--</a> 
													<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

													</ul>
													-->
												</div>
											</td>			
										</tr>										
									</table>			
									</a>
									<ul id="dalibn_sar_<?=$gultas_nr;?>_3" class="dropdown-menu" >
									</ul>
								</div>
							</td>
							<?							
								$gultas_nr++;
								$pedejais_double_kopa_ar = $kopa_ar;
							}
							if (DEBUG){
								var_dump($kopa_ar_pieaugusie);
							}
							//pârbauda, vai DOUBLE palika viena neaizòemta vieta
							if(count($kopa_ar_pieaugusie) >= 1 && (($izdrukata_kreisa_puse && !$izdrukata_laba_puse) || (!$izdrukata_kreisa_puse || $izdrukata_laba_puse)))
							{
								$briva_puse_gultas = 1;
							}
							else $briva_puse_gultas = 0;
								
							$brivas_vietas = $istaba['vietas_kopa'] - count($istaba['kopa_ar']);
						
							$img_person = $data['bed_images']['free'];
							for ($j=0;$j<$brivas_vietas;$j++){
							
								$berna_vieta = 2;
								//echo "<br>I= $i <br>";
								//echo "<br>J= $j <br>";
								//ja viena vieta aizòemta kopîgâ gultâ
								if ($briva_puse_gultas){
									if (DEBUG) echo $kopa_ar['kopa_ar_dzimums'];
									if ($kopa_ar['kopa_ar_dzimums'] == 's'){
										$dzimumam = 'v';
									}
									elseif ($kopa_ar['kopa_ar_dzimums'] == 'v'){
										$dzimumam = 's';
									}
									$briva_puse_gultas = 0;
								}
								else $dzimumam = '0';
								if (!$izdrukata_kreisa_puse){
									$img = $data['bed_images']['double_left_side'];
									$izdrukata_kreisa_puse = 1;
									$align = "right";
								}
								elseif (!$izdrukata_laba_puse){
									$img = $data['bed_images']['double_right_side'];
									$izdrukata_laba_puse = 1;
									$align = "left";
								}
								else{
									$img = $data['bed_images']['single4child'];
									$berna_vieta = 1;
									$dzimumam = '0';
									$align = "center";
								}
								
								/*if($i==0){
									if ($j==0){
										$img = $data['bed_images']['double_left_side'];
										//$align = "right";
									}elseif ($j==1){
										$img = $data['bed_images']['double_right_side'];
										//$align = "left";
										
									}
									else{
										$img = $data['bed_images']['child'];
										$berna_vieta = 1;
									}
									$i++;
								}
								elseif ($i==1){
									$img = $data['bed_images']['double_right_side'];
									//$align = "left";
									$i++;
								}
								else{
									$img = $data['bed_images']['child'];
									$berna_vieta = 1;
								}
								*/?>
								<td class="td_bed">
									<div style="position:relative">
										<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1','<?=$dzimumam;?>',<?=$berna_vieta;?>,event);">
													 
											<table class="<?=$align;?>">
												<tr>
													<td align="center" style="height:40px" ><div style="height:40px"> &nbsp </div></td>
												</tr>
												<tr>
													<td align="<?=$align;?>" style="height:40px">
														<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1',0,<?=$berna_vieta;?>);">
															--><img class="img_person" src="<?=$img_person;?>"/>
														<!--</a> 
														<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

														</ul>-->
													</td>
												</tr>
												<tr>
													<td align="<?=$align;?>" >
													<div style="position:relative">
														<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_2',0,<?=$berna_vieta;?>);">
															--><img class="img_bed" align="<?=$align;?>" src="<?=$img;?>">
														<!--</a> 
														<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

														</ul>-->
													</div>
													
											
												</td>
										
											</tr>
											
										</table>
									</a>
									<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

									</ul>
								</div>
								</td>
								<?
												$gultas_nr++;
												
							}
							//izdrukâ aizòemtâs bçrnu vietas, lai tâs nerâdîtos pa vidu starp aizòemto un brîvo kopîgo gultasvietu
							//ja ir aizòemta arî kâda pieauguðo vieta;
							/*if (count($kopa_ar_berni) > $istaba['bernu_vietas']){
								$show_as_adult = 1;
							}
							else $show_as_adult = 0;*/
							$aiznemtas_bernu_vietas = count($kopa_ar_berni);
							//echo "bçrnu vietas: ".$istaba['bernu_vietas']."<br>";
							
							foreach ($kopa_ar_berni as  $kopa_ar){
								if ($aiznemtas_bernu_vietas > $istaba['bernu_vietas']){
									$show_as_adult = 1;
								
								}								
								else $show_as_adult = 0;
								
								//var_dump($show_as_adult);
								if ($kopa_ar['kopa_ar_dzimums'] == 's'){
										$img_person = $data['bed_images']['child_F'];
								}
								elseif ($kopa_ar['kopa_ar_dzimums'] == 'v'){
									$img_person = $data['bed_images']['child_M'];
								}
								if ($show_as_adult){
									$berna_vieta = 0;
									//echo "peiaguðo vieta";
									$aiznemtas_bernu_vietas--;
									//$show_as_adult = 0;
									
									
									if (!$izdrukata_kreisa_puse){
										$img = $data['bed_images']['double_left_side'];
										$izdrukata_kreisa_puse = 1;
										$align = "right";
									}
									else{
										$img = $data['bed_images']['double_right_side'];
										$izdrukata_laba_puse = 1;
										$align = "left";
									}
								}
								else{
								
									$img = $data['bed_images']['single4child'];
									$berna_vieta = 1;
									$align = "center";
								}
									?>
									<td class="td_bed">
										<div style="position:relative">
											<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_1',0,<?=$berna_vieta;?>,event);">
													
										
												<table class="<?=$align;?>">
													<tr>
														<td align="center" bgcolor="" style="height:40px"><b style="color:#009E59"><div style="<? if ($align == 'right') echo "padding-right:0.5ex"; elseif ($align=='left')
															echo "border: solid 0 black; border-left-width:2px;padding-left:0.5ex;";?>;height:40px;max-height:40px;overflow:hidden"><?=$kopa_ar['kopa_ar_nosaukums'];?></b></div>
														</td>
													</tr>
													<tr>
														<td align="<?=$align;?>" style="height:40px">
															<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_1',0,<?=$berna_vieta;?>);">
																--><img class="img_person" src="<?=$img_person;?>"/>
															<!--</a> 
															<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

															</ul>-->
														</td>
													</tr>
													<tr>
													
														<td align="<?=$align;?>" >
														<div style="position:relative">
															<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_2',0,<?=$berna_vieta;?>);">
																--><img  class="img_bed" align="<?=$align;?>" src="<?=$img;?>">
															<!--</a> 
															<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

															</ul>-->
														</div>
													
												</td>
											</tr>
											
										</table>
									</a>
									<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

									</ul>
								</div>
							</td>
							<?
									
								$gultas_nr++;
													
							}
						}
						//numuriòi ar visâm atseviðíâm gultâm
						else{
							//if (count($istaba['kopa_ar'] >0)){
							//var_dump($istaba['kopa_ar']);
							//echo "<br><br>";
							$dzimumam = 0;
							//divvietîgiem numuriòiem ar aizòemtu vienu vietu nosaka "sveðâ" kaimiòa dzimumu
							if ($istaba['vietas_kopa'] == 2){
								
								foreach($istaba['kopa_ar'] as $kopa_ar){
									//var_dump($kopa_ar);
									//echo "<br><br>";
									//$kopa_ar = $istaba['kopa_ar'][0];
									
									//$bernu_vieta = 0;
									//nosaka dzimumu kaimiòam
									if (!$kopa_ar['kopa_ar_savejo']){
										//echo "dzimums cits";
										//echo $kopa_ar['kopa_ar_dzimums']."<br>";
										$dzimumam = $kopa_ar['kopa_ar_dzimums'];
									}
								}
							}
							$aiznemtas_bernu_vietas = 0;
							$align = "center";
							//izdrukâ aizòemtâs vietas ar attiecîgajiem atttçliem un nosaukumiem
							foreach ($istaba['kopa_ar'] as  $kopa_ar){
							
								$img = $data['bed_images']['single'];
								if ($kopa_ar['kopa_ar_berns']!=0){
									$aiznemtas_bernu_vietas++;
								
									if ($kopa_ar['kopa_ar_dzimums'] == 's'){
										$img_person = $data['bed_images']['child_F'];
									}
									elseif ($kopa_ar['kopa_ar_dzimums'] == 'v'){
										$img_person = $data['bed_images']['child_M'];
									}
									
									//$img = $data['bed_images']['single4child'];
									//$berna_vieta = 1;
									
									
								}else{
									$berna_vieta = 0;
									if ($kopa_ar['kopa_ar_dzimums'] == 's'){
											$img_person = $data['bed_images']['adult_F'];
									}
									elseif ($kopa_ar['kopa_ar_dzimums'] == 'v'){
										$img_person = $data['bed_images']['adult_M'];
									}
										
								}
								?>
								<td class="td_bed">
									<?if ($kopa_ar['kopa_ar_savejo']){?><div style="position:relative">
										<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_1','<?=$dzimumam;?>',0,event);">
									<?}?>		
											<table class="center">
												
												<tr>
													<td align="center" style="height:40px">
														<div style="height:40px;max-height:40px;overflow:hidden"><? if ($kopa_ar['kopa_ar_savejo']){?><b style="color:#009E59"><?}?><?=$kopa_ar['kopa_ar_nosaukums'];?><? if ($kopa_ar['kopa_ar_savejo']){?></b><?}?></div>
													</td>
												</tr>
												<tr>
													<td align="center" style="height:40px">
														
														<?if ($kopa_ar['kopa_ar_savejo']){
															//echo 'kopâ ar savçjo';?>
															<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_1','<?=$dzimumam;?>',0);">
															--><img class="img_person" src="<?=$img_person;?>"/>
														<!--</a> 
														<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

														</ul>-->
														<?}
														else{?>
															<img class="img_person" src="<?=$img_person;?>"/>
													
														<?}?>
													</td>
												</tr>
												<tr>
													<td align="center" >
												<?
													if ($kopa_ar['kopa_ar_savejo']){
													
														
													?>
														<div style="position:relative;">
															<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,<?=$kopa_ar['kopa_ar_did'];?>,'<?=$gultas_nr;?>_2','<?=$dzimumam;?>',0);">
																--><img class="img_bed" align="<?=$align;?>" src="<?=$img;?>">
															<!--</a> 
															<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

															</ul>-->
														</div>
														<?
														
													}
													else{?>
														<img class="img_bed" align="<?=$align;?>" src="<?=$img;?>">
																	
													<?}?>
													</td>
												</tr>
												
											</table>
										<?if ($kopa_ar['kopa_ar_savejo']){?></a>
										<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

										</ul>
										<?}?>
									</div>
								</td>
								<?
								$gultas_nr++;
							}
							
							
							$brivas_vietas = $istaba['vietas_kopa'] - count($istaba['kopa_ar']);
							//if ($brivas_vietas > 0){
								//echo "BRÎVÂS VIETAS:" .$brivas_vietas."<br>";
							if ($istaba['bernu_vietas'] >0){
								$brivas_bernu_vietas = $istaba['bernu_vietas'] - $aiznemtas_bernu_vietas;
							}
							else{
								$brivas_bernu_vietas = 0;
							}
							if ($brivas_bernu_vietas <0) $brivas_bernu_vietas = 0;
						
							$brivas_pieauguso_vietas = $brivas_vietas - $brivas_bernu_vietas;
							IF ($_SESSION['profili_id'] == 5116){
								/*echo $istaba['bernu_vietas'];
								 echo 'aiznemtas bernu vietas:'.$aiznemtas_bernu_vietas."<br>";
								echo "BRÎVÂS VIETAS:" .$brivas_vietas."<br>";
								echo "BRÎVÂS Bçrnu VIETAS:" .$brivas_bernu_vietas."<br>";
								echo "BRÎVÂS pieauguðo VIETAS:" .$brivas_pieauguso_vietas."<br>";*/
							}
							
							$align = "center";
							for ($i=0;$i<$brivas_pieauguso_vietas;$i++){
									?>
									<td class="td_bed">
										<div style="position:relative">
											<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1','<?=$dzimumam;?>',0,event);">
															
												<table class="<?=$align;?>">
													<tr>
														<td height="40px"><div style="height:40px">&nbsp </div>
														</td>
													</tr>
													<tr>
														<td align="center" >
															<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1','<?=$dzimumam;?>',0);">
																--><img class="img_person"  src="<?=$data['bed_images']['free'];?>">
															<!--</a>	
															<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

															</ul>-->
														</td>
													</tr>
													<tr>	
														<td align="center" >
															<div style="position:relative">
																<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_2','<?=$dzimumam;?>',0);">
																	--><img class="img_bed" src="<?=$data['bed_images']['single'];?>">
									
																<!--</a> 
																<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

																</ul>-->
															</div>
														</td>
													</tr>
													
												</table>
											
											</a>
											<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

											</ul>
										</div>
									</td>
									<?
									$gultas_nr++;
								}
								$img = $data['bed_images']['single4child'];
								$img_person = $data['bed_images']['free'];
								$align = "center";
								for ($i=0;$i<$brivas_bernu_vietas;$i++){
									
									?>
									<td class="td_bed">
										<div style="position:relative">
											<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1',<?=$dzimumam;?>,1,event);">
												
												<table class="<?=$align;?>">
													<tr>
														<td align="center" style="height:40px;"><div style="height:40px"> &nbsp </div> </td>
													</tr>
													<tr>
														<td align="center" style="height:40px">
														<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_1',<?=$dzimumam;?>,1);">
															--><img class="img_person" src="<?=$img_person;?>"/>
														<!--</a> 
														<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

														</ul>-->
													</td>
													</tr>
													<tr>
														<td align="center" >
															<div style="position:relative">
																<!--<a class="dropdown-toggle" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onclick="showDalibn(<?=$istaba['vietas_id'];?>,0,'<?=$gultas_nr;?>_2',<?=$dzimumam;?>,1);">
																	--><img class="img_bed" align="" src="<?=$img;?>">
																<!--</a> 
																<ul id="dalibn_sar_<?=$gultas_nr;?>_2" class="dropdown-menu" >

																</ul>-->
															</div>
														</td>
													
													</tr>
													
										
												</table>
											</a>
											<ul id="dalibn_sar_<?=$gultas_nr;?>_1" class="dropdown-menu" >

											</ul>
										</div>
									</td>
									
									<?
									$gultas_nr++;
											
								}
							}
								//}
						
						//}
							?>
						</tr>
						<?//}?>
						<!--<option value="<?=$istaba['vietas_id'];?>"-->
							<? /*if (isset($data['istaba']) && $data['istaba'] == $istaba['vietas_id']) echo "selected";?>
							<?=$istaba['nosaukums'];?></option>
							
						<?*/
						//}
						?>
					</table>
					</div>
				
				
						<?
					}
						//var_dump($istaba);
				}
					?>
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
							<a class="btn btn-block btn-default" href="?f=Cabins&dir=back" style="background-position:0 0"><< </a>
						
						</div>
							<div class="col-sm-6 " >
								<a class="btn btn-block btn-default" href="?f=Services" style="background-position:0 0">>> </a>
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
img {
	//width:50%;
	//height:auto;
	 //display: block;
    //margin: 0 auto;
}
.dropdown-menu{
	top:10%;
}
</style>
<script>


</script>
<? if ($data['var_labot']){
		if ($data['celotaju_skaits'] > 1){?>
<script>
	
	$( document ).ready(function() {
			//$('#dropdown-toggle1').dropdown();	
				$('.dropdown-toggle').dropdown();	
			//$('#dropdown-toggle2').dropdown();	
			$('.dropdown-toggle').on('show.bs.dropdown', function () {
alert('s');
  // do something…
})
		});
		</script>
		<?}?>
		<script>
function showDalibn(vid,did_aiznemis,gultas_nr,dzimumam,berna_vieta,e){
	//alert(id);
	/*if (aiznemta){
		var html0 = '<li><a onclick="cancelRoom('+id+')">Izòemt</a></li>';
	}
	else{
		var html0 = '';
	}*/
	if (<?=$data['celotaju_skaits'];?> > 1){
	$.ajax({
				url:      "?f=GetDalibnForRoom",
				//encoding:	"UTF-8",
				data: { vid: vid, did_aiznemis:did_aiznemis,dzimumam:dzimumam,berna_vieta:berna_vieta},
				type:       'POST',
				cache:      false,
				
				success: function(html){ 
					//console.log(html);	
					var left  = e.clientX   + "px";
					var top  = e.clientY  + "px";

					var div = document.getElementById("dalibn_sar_"+gultas_nr);

					div.style.left = left;
					div.style.top = top;					
					$("#dalibn_sar_"+gultas_nr).html(html);
					/*$("#dalibn_sar_"+gultas_nr).css({
					left: e.clientX + "px",
					top: e.clientY + "px"  });*/
		
  
					//$('#shortlist_container_view_'+user_shortlist_id).html(html)
				}           
			  });
	}
	else{
		//alert('<?=$data['celotaja_did'];?>');
		$("#dalibn_sar_"+gultas_nr).hide();
		bookRoom(vid,'<?=$data['celotaja_did'];?>',did_aiznemis);
		//alert('booked');
	}
			  
	//var html = '<li><a>Izòemt</a></li><li><a>test test</a></li>';
	//$("#dalibn_sar_"+id).html(html);

}
function bookRoom(vid,did,did_aiznemis){
	var request = $.ajax({
		url:      "?f=BookRoom",
		data: { vid: vid, did:did, did_aiznemis: did_aiznemis},
		type:       'POST',
		cache:      false,
		dataType : 'html',
		
		success: function(html){ 
		
			//console.log(html);
			//console.log('success');			
			//alert('izòemts')0;
			if (html == 'next' && false){
				//ja visiem ceïotâjiem ir izvçlçti numuriòi
				$("#forma").submit();
			}
			else{
				//document.location.href = "?f=Hotels";
				var url = window.location.href;
				var host = window.location.host;
				if(url.indexOf('?f=Hotels') != -1) {
				   //match
				   console.log('match');
				   location.reload(true);
				}
				else{
					console.log(url);
					console.log(host);
					location.replace("?f=Hotels");
				}
				//window.location.reload();
			}
			
			//$('#shortlist_container_view_'+user_shortlist_id).html(html)
		}           
	  });
	  request.done(function( msg ) {
  //$( "#log" ).html( msg );
 // console.log("request done"+msg);
});
 
request.fail(function( jqXHR, textStatus ) {
  alert( "Request failed: " + textStatus );
});
}
//izòem personu no numuriòa
function cancelRoom(vid,did){
	$.ajax({
		url:      "?f=CancelRoom",
		data: { vid: vid, did:did},
		type:       'POST',
		cache:      false,
		
		success: function(html){ 
			//console.log(html);				
			//alert('izòemts');
			window.location.href = "?f=Hotels";
			window.location.reload(true);
			//$('#shortlist_container_view_'+user_shortlist_id).html(html)
		}           
	  });
	
}
</script>
<?}
else{
	?>
	<script>

	
	$( document ).ready(function() {
		
		$(".dropdown-toggle").addClass('disabled');
		//$(".dropdown-toggle").off('click'); //disables click event
	});
	</script>
	<style>
		a.disabled {
			pointer-events: none;
			cursor: default;
		}
	</style>
	<?
}
?>
<style>
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



