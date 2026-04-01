<?
require_once("i_reservation_head.php");
function Hotels(){
	
	//jaunais variants:
	if (isset($_GET['p']) && isset($_GET['rez_id'])){
		require("m_online_rez.php");
		$online_rez = new OnlineRez();
		$rez = $online_rez->GetId((int)$_GET['rez_id']);
		//var_dump($rez['tmp_password'] );
		if ($rez['tmp_password'] == $_GET['p']){
			//$_SESSION['reservation']['online_rez_id']  = (int)$_GET['id'];
			$_SESSION['reservation']['from_email'] = (int)$_GET['rez_id'];
		}
	//var_dump($_SESSION);
		//exit();
	}
	if (isset($_GET['p']) && isset($_GET['id'])){
		require("m_online_rez.php");
		$online_rez = new OnlineRez();
		$rez = $online_rez->GetId((int)$_GET['id']);
		if ($rez['tmp_password'] == $_GET['p']){
			$_SESSION['reservation']['online_rez_id']  = (int)$_GET['id'];
			$_SESSION['reservation']['from_email'] = (int)$_GET['id'];
		}
		//var_dump($_SESSION);
		//exit();
	}
	
	global $profili;
	
	if ($profili->CheckLogin()){
		//pārbauda, vai ceļojumam ir pieejama viesnīca
		require_once("m_viesnicas.php");
		$viesnicas = new Viesnicas();
		if (isset($_SESSION['reservation']['grupas_id'])){
			$gid = $_SESSION['reservation']['grupas_id'];
		}
		else{
			$res_status = ResStatus();
			if (!is_array($res_status)){
				echo $res_status;
				exit();
			}
			$online_rez_id = $res_status['online_rez'];
			require_once("m_online_rez.php");
			$online_rez = new OnlineRez();
			$gid = $online_rez->GetGidId($online_rez_id);
		}
		$istabinu_veidi = $viesnicas->GetVeidsGid($gid);
		/*echo "viesnīcu viedi<br>";
		var_dump($istabinu_veidi);
		echo "<br><br>";*/
		//ja ceļojumam ir pieejama viesnīca
		if (count($istabinu_veidi)>0){
			global $u_track;
			global $tabs;
				
			$_SESSION['tabs']['current'] = 4;
			global $db;
			require_once("m_dalibn.php");
			require_once("m_pieteikums.php");
			require_once('m_vietu_veidi.php');
			require_once('m_viesnicas.php');
			require_once("m_online_rez.php");
			require_once("m_grupa.php");
			
			
			$res_status = ResStatus();
			if (!is_array($res_status)){
				echo $res_status;
				exit();
			}
			if (DEBUG){
				var_dump($res_status);
				echo "<br><br>";
			}
			$data['var_labot'] = $res_status['var_labot'];
			$data['ir_iemaksas'] = $res_status['ir_iemaksas'];
			$online_rez_id = $res_status['online_rez'];
			if (DEBUG){
				echo "Rezervācijas ID#: ";
				echo "$online_rez_id<br>";
			}
			$error = array();
			if ($data['var_labot']){
				if (isset($_SESSION['reservation']['online_rez_id']) && (int)$_SESSION['reservation']['online_rez_id']>0){
				
					//if (isset($_SESSION['reservation']['grupas_id']) && $_SESSION['reservation']['grupas_id']>0){
					//$online_rez_id = $_SESSION['reservation']['online_rez_id'];
					
					$dalibn = new Dalibn();				
					$pieteikums = new Pieteikums();	
					$vietu_veidi = new VietuVeidi();			
					$viesnicas = new Viesnicas();
					//$data['checked_dok_veids'] = 'pase';
					//$data['checked_talr_veids'] = 'home';
					if (isset($_POST['post']) && $_POST['post'] == 1){
						$text = "<b>REZERVĀCIJA #".$_SESSION['reservation']['online_rez_id'].": ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
						SaveUserTracking($text,$_POST);
						/*foreach ($_POST as $key=> $val){					
							$text .= $key."=".$val."<br>";					
						}				
						$u_track->Save($text);*/
						//Validation
						$error = array();
						$online_rez = new OnlineRez();
						$dalibnieki = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
						//var_dump($dalibnieki);
						$viesnicas_id_arr = $viesnicas->GetViesnicaAll($online_rez_id);
						$text_arr = array();
						foreach($viesnicas_id_arr as  $did => $rezerveta_istaba){
							$dalibnieks = $dalibn->GetId($did);
							$numurins = $viesnicas->GetId($rezerveta_istaba);
							$text_arr[] = $dalibnieks['vards']." ".$dalibnieks['uzvards'].": ".$numurins['pilns_nosaukums'];
						}
						$text = "<b>REZERVĀCIJA #".$_SESSION['reservation']['online_rez_id'].": Izvēlētie viesnīcas numuriņi</b>:<br>".implode("<br>",$text_arr);
						$u_track->Save($text);
						/*echo "Viesnīcas: <br>";
						var_dump($viesnicas_id_arr);
						echo "<br><br>";*/
						if (count(array_filter($viesnicas_id_arr)) != count($dalibnieki) ){
							$error['viesnica'] = 'Nav izvēlēti viesnīcas numuriņi visiem ceļotājiem.';
						}
						else{						
							//pārbaude grupām, kas ir čarteri vai nav atstāts pusaizņemts TWINS
							$gr = new Grupa();
							$carter_gid_arr = $gr->get_carter_full_rooms();
							if (DEBUG){
								echo "<br>Čartergrupas:<br>";
								var_dump($carter_gid_arr);
								echo "<br><br>";
							}
							if (in_array($gid,$carter_gid_arr)){
								//echo "Būs jāpārbauda";
								foreach ($viesnicas_id_arr as $did => $rezerveta_istaba){
									
									$gid = $online_rez->GetGidId($online_rez_id);
									$vieta = $viesnicas->GetAvailableGid($gid,0,$rezerveta_istaba);
									//echo "REZREVĒTĀ ISTABA: $rezerveta_istaba <br><br>";
									//echo "VIETA:<br>";
									//var_dump($vieta);
									//echo "<br><br>";
									
									
									//dabū istabiņas brīvo vietu skaitu
								//	var_dump($vieta[$rezerveta_istaba]);
									if ($vieta[$rezerveta_istaba]['vietas_kopa'] == 2 && $vieta[$rezerveta_istaba]['veids'] == 'TWIN'){
										if ($vieta[$rezerveta_istaba]['vietas_aiznemtas'] != $vieta[$rezerveta_istaba]['vietas_kopa']){
											$error['pustukss'] = 'Kļūda rezervācijā: divvietīgais numuriņš ir jāaizņem pilnībā.';
										}
									}
								}								
								
							}

							if ($_SESSION['reservation']['traveller_count'] >= 2){
								// beigās validācija kad pēdējais cilvēks izvēlas viesnicu, tad visiem numuriem ar 3 vai vairāk vietām jābūt pilnīgi aizņemtiem
								foreach ($viesnicas_id_arr as $did => $rezerveta_istaba){
									
									$gid = $online_rez->GetGidId($online_rez_id);
									$vieta = $viesnicas->GetAvailableGid($gid,0,$rezerveta_istaba);
									//echo "REZREVĒTĀ ISTABA: $rezerveta_istaba <br><br>";
									//echo "VIETA:<br>";
									//var_dump($vieta);
									//echo "<br><br>";
									
									
									//dabū istabiņas brīvo vietu skaitu
									if ($vieta[$rezerveta_istaba]['vietas_kopa'] >= 3){
										if ($vieta[$rezerveta_istaba]['vietas_aiznemtas'] != $vieta[$rezerveta_istaba]['vietas_kopa']){
											$error['pustukss'] = 'Kļūda rezervācijā: 3 un vairākvietīgie numuriņi ir jāaizņem pilnībā.';
										}
									}
								}								
							}
							//jāuztaisa pārbaudi rezervācijas beigās vai doublā nav cilvēki no dažādām rezervācijām
							//un vai twinā nav cilvēki dažādiem dziumumiem no dažādām rezervācijām
							//kā arī pārbauda, vai nav pārsniegtrs dalībnieku skaits vienā istabiņā
							//vai double ir aizņemts pilnībā
							//if (isset($_SESSION['reservation']['viesnicas_id_arr'])){
								foreach ($viesnicas_id_arr as $did => $rezerveta_istaba){
									//echo "REZREVĒTĀ ISTABA: $rezerveta_istaba <br><br>";
									$vieta = $viesnicas->GetId($rezerveta_istaba);
									//var_dump($vieta);
									$vid = $vieta['vid'];
									//echo "<br><br>";
									$kaiminu_did = $pieteikums->GetDidVid($vid,$did=0);
									if (count($kaiminu_did) > $vieta['vietas']){
										$error['parpildits'] = 'Kļūda: viesnīcas numuriņam ar ID# '.$vid.' ir pārsniegts maksimālais'
															.' iemītnieku skaits ('.count($kaiminu_did).'|'.$vieta['vietas'].'). Lūdzu, sazinieties ar IMPRO.';
										break;
									}
									//vai double ir aizņemts pilnībā
									if ($vieta['nosaukums'] == 'DOUBLE'){
										if (count($kaiminu_did) == 1){
											$error['double'] = 'Kļūda: divvietīgais numuriņš ar kopīgu gultu ir jāaizņem pilnībā.';
															
										}
									}
									//vai doublā nav cilvēki no dažādām rezervācijām
									//un vai twinā nav cilvēki dažādiem dziumumiem no dažādām rezervācijām
							
									if ($vieta['nosaukums'] == 'DOUBLE' || $vieta['nosaukums'] == 'TWIN'){
										
										//echo "Kaimiņi:";
										//var_dump($kaiminu_did);
										//echo "<br><br>";
										
										//pārbauda, vai no vienas rezervācijas, ja abas vietas aizņemtas							
										if (count($kaiminu_did) == 2){
											foreach($kaiminu_did as $did){
												if (!in_array($did,$_SESSION['reservation']['dalibn_id_arr'])){
													if ($vieta['nosaukums'] == 'TWIN' ){
														$kaimins = $dalibn->GetId($kaiminu_did[0]);
														/*echo "<br>Kaimiņš:<br>";
														var_dump($kaimins);
														echo "<br><br>";
														echo "<br>ES:<br>";*/
														$celotajs = $dalibn->GetId($kaiminu_did[1]);
													//	var_dump($celotajs);
														//echo "<br><br>";
														if ($kaimins['dzimta'] != $celotajs['dzimta']) {	
															$error['dazadi_dzimumi'] = 'Kļūda: divvietīgā numuriņā ir dalībnieki no dažādām rezervācijām ar atšķirīgiem dzimumiem. Lūdzu, sazinieties ar IMPRO.';
															break;
														}
													}
													else{
														$error['dazadi_dzimumi_double'] = 'Kļūda: divvietīgā numuriņā ar kopīgu gultu ir dalībnieki no dažādām rezervācijām. Lūdzu, sazinieties ar IMPRO.';
														break;
													}										
												}
											}
										}
									}
								}
							//}	
						}

						if (count($error) == 0){
							// ejam uz nākamo soli
							$_POST['post'] = 0;
							Services();
							exit();
						}
						else{
							$text = "<b>REZERVĀCIJA #".$_SESSION['reservation']['online_rez_id'].": ".$tabs[$_SESSION['tabs']['current']]['title']."-kļūda:</b><br>";
							$text .= implode("<br>",$error);
							$u_track->Save($text);
							
							$error['viesnica'] = implode("<br>",$error);
							$data['errors'] = $error;
						}
						//var_dump($_POST['cena']);
						$count = $_SESSION['reservation']['traveller_count'];
					}
					//echo "rez id: $online_rez_id";
				
				
					$online_rez = new OnlineRez();
					$dalibnieki = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
					//var_dump($dalibnieki);
					
					
					
					//dabū pārējo ceļotāju datus priekš 
					$data['dalibnieki'] = array();
					foreach($dalibnieki as $did){
						$data['dalibnieki'][] = $dalibn->GetId($did);
					
					}
					
					//echo "dalibnieki:";
					//var_dump($dalibnieki);
						
					
					$data['vietu_veidi'] = $vietu_veidi->GetAvailable($_SESSION['reservation']['grupas_id']);

					
					$pid=0;
					//unset($mana_istaba);
					//ja šī dalībnieka dati un pakalpojumi jau ir saglabāti
					/*if (isset($_SESSION['reservation']['completed_did'])&& in_array($active_did, $_SESSION['reservation']['completed_did']) && count($error)==0){
						//nolasa saglabātos pakalpojumus
						
						$pid = $pieteikums->GetOnlineRezDid($_SESSION['reservation']['online_rez_id'],$active_did);
						
						
						//echo "<br><br>";
						//get istabas
						$data['istaba']  =  $pieteikums->GetViesnica($pid);
						//echo "istabas ID: ".$data['istaba']." <br><br>";
						//$mana_istaba = $viesnicas->GetAvailableGid($_SESSION['reservation']['grupas_id'],0,$data['istaba']);
						
						//echo "MANA ISTABA:";
						//var_dump($mana_istaba);
						//echo " <br><br>";
						
					}*/
					
					
					
					//----------atlasa pieejamās viesnīcas---------------------------------------------//
					//if (count($istabinu_veidi)>0){
						
					$data['viesnicas'] = $viesnicas->GetAvailable($online_rez_id);
					if (DEBUG){
						echo "<b>Viesnīcas:</b><br>";
						print_r($data['viesnicas']);
					}
					//var_dump($data['viesnicas']);
					//var_dump(count($data['viesnicas']));
					//nav atrasts neviens derīgs numuriņš
					if (count($data['viesnicas'])==0){
						$error['viesnica'] = 'Kļūda: nav pieejams neviens viesnīcas numuriņš. Lūdzu, sazinieties ar IMPRO.';
													
					}
					
					else{
						//brīvo vietu skaitu salīdzina ar neivietoto dalībnieku skaitu
						
						$vietas = 0;
						foreach($data['viesnicas'] as $istaba){
							$vietas += $istaba['vietas_kopa'];// - count($istaba['kopa_ar']);
							//echo "Vietas : $vietas<br>";
							
						}
						$brivas_vietas = $vietas;// - $aiznemtas_vietas;
						//echo "BRĪVAS VIETAS $brivas_vietas <br>";
						$viesnicas_id_arr = $viesnicas->GetViesnicaAll($online_rez_id);
						$aiznemtas_vietas = count(array_filter($viesnicas_id_arr));
						//echo "AIznemtas vietas : $aiznemtas_vietas <br>";
						if ($brivas_vietas < $_SESSION['reservation']['traveller_count'] - $aiznemtas_vietas){
							$error['viesnica'] = 'Kļūda: nav pieejami viesnīcas numuriņi visiem rezervācijas dalībniekiem. Lūdzu, sazinieties ar IMPRO.';
						
						}
					}
					if (isset($error)){
						$data['errors'] = $error;	
					}
					if (DEBUG){
							echo "<br><br>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<br>";
							echo "<h4>Viesnīcas</h4><br>";
						
						foreach ($data['viesnicas'] as $key=>$viesnica){
							//echo "<b>Dalībniekam: $key<br></b>";
							if (is_array($viesnica)){
								if (array_key_exists('0',$viesnica)){
									foreach($viesnica as $viesn){
										if (DEBUG){
											var_dump($viesn);
											echo "<br><br>";
										}
									}
								}
								else{
									if (DEBUG){
										var_dump($viesnica);
										echo "<br><br>";
									}
								}
								
							}
							else{
								if (DEBUG){
									var_dump($viesnica);
									echo "<br><br>";
								}
							}
						}
					 echo "<br><br>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<br>";
					}	
						

						/*foreach ($data['istabas'] as $key=>$viesnica){
							
							echo "<b>$key<br></b>";
							var_dump($viesnica);
							echo "<br><br>";
						}*/
						
						
					//}
					
					
				}
				else{
					Travellers();
					exit();
				}
			}
			//rezervāciju vairs nevar labot
			else{
				if (DEBUG) echo "nevar labot";
				
				//dabū visus dalībniekus un to pieteikumus
			
				$online_rez = new OnlineRez();
				$dalibn = new Dalibn();
				$pieteikums = new Pieteikums();
				$vietu_veidi = new VietuVeidi();
				$viesnicas = new Viesnicas();
				//testam:
				//$_SESSION['profili_id'] = 6341;
				//$online_rez_id = $res_status['online_rez'];
				//$dalibnieki = $online_rez->GetDalibnList($online_rez_id,$_SESSION['profili_id']);
				
				$data['viesnicas'] = $viesnicas->RezervetasViesnicas($online_rez_id);
				if (DEBUG) {
					echo "rezrevētās istabas:<br>";
					var_dump($data['viesnicas']);
					echo "<br><br>";
				}
				
			}
			$data['bed_images'] = $viesnicas->bed_images;
			/*$data['bed_images'] = array ('child_M' => 'img/boy.svg',
											'child_F' => 'img/girl.svg',
											'adult_M' => 'img/male.svg',
											'adult_F' => 'img/female.svg',
											'double_right_side' => 'img/DOUBLE_R.svg',
											'double_left_side' => 'img/DOUBLE_L.svg',
											'free' => 'img/brivs.png',
											'single' => 'img/SINGLE.svg');*/
												//'double_left_side_F' => 'img/double_left_side_F.bmp',
												//'double_left_side_M' => 'img/double_left_side_M.bmp',
												//'double_right_side_F' => 'img/double_right_side_F.bmp',
												//'double_right_side_M' => 'img/double_right_side_M.bmp',
												
												//'adult_F' => 'img/single_grown_up_F.bmp',
												//'adult_M' => 'img/single_grown_up_M.bmp');
			$data['celotaju_skaits'] = $_SESSION['reservation']['traveller_count'];
			if ($data['celotaju_skaits']==1){$data['celotaja_did'] = $data['dalibnieki'][0]['ID'];}
			if (in_array($_SESSION['profili_id'],$db->tester_profiles)){
				include('v_reservation_hotels_new.php');
			}
			else{
				include('v_reservation_hotels.php');
			}
		
		//Ceļojumam nav pieejamas viesnīcas	
		}
		else{
			//Ja šeit nonāk, spiežot pogu 'Atgriezties'
			if (isset($_GET['dir']) && $_GET['dir'] == 'back'){
				Cabins();
			}
			else{
				Services();
			}
			exit();
		}
	}
	else{
		header("Location: c_login.php");
	}
	
}