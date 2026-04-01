<?php
//Ceļojuma izvēle
function Travel(){
	global $profili;
	if ($profili->CheckLogin()){
		global $db;
		global $u_track;
		global $tabs;
		require_once("m_online_rez.php");
	    $online_rez = new OnlineRez();
		$_SESSION['tabs']['current'] = 1;
		
		$res_status = ResStatus();
		if (!is_array($res_status)){
			echo $res_status;
			exit();
		}
		$data['var_labot'] = $res_status['var_labot'];
		$data['ir_iemaksas'] = $res_status['ir_iemaksas'];
		$online_rez_id = $res_status['online_rez'];
		
		if ($data['var_labot']){
			if (isset($_POST['post']) && $_POST['post'] == 1){
				$text = "<b>REZERVĀCIJA #".$online_rez_id.": ".$tabs[$_SESSION['tabs']['current']]['title'].'</b>:<br>';
				SaveUserTracking($text,$_POST);				
				
				//--------------------------------//
				// Validation
				//--------------------------------//
				$error = array();
				require_once("m_grupa.php");
					$gr = new Grupa();
				if (isset($_POST['travel'])){
					//09.04.2019 RT: pārbauda, vai tas nav kajīšu ceļojums. Kajīšu ceļojumi atļauti līdz 4 dalībniekiem rezervācijā			
					$err = $gr->ValidateSelectedGid($_POST['travel'],$_SESSION['reservation']['traveller_count']);
					if (DEBUG){
						//echo "grupas validācijas kļūda:<br>";
						//var_dump($err);
					}
					if (!empty($err)){
						$error['travel'] = $err;
					}
					
					if (isset($_SESSION['reservation']['grupas_id']) && $_SESSION['reservation']['grupas_id']!=$_POST['travel']){
						//vai dzēst veco rezervāciju šeit?
					}
					$_SESSION['reservation']['grupas_id'] = $_POST['travel'];
					
				}
				else{
					$error['travel'] = 'Nav izvēlēts ceļojums';
				}
				//--------------------------------//
				if (count($error) > 0) {
					// kļūda
					$text = "<b>REZERVĀCIJA #".$online_rez_id.": ".$tabs[$_SESSION['tabs']['current']]['title']."-kļūda</b>:<br>";
					$text .= implode("<br>",$error);
					$u_track->Save($text);
					// rādam vecās vērtības un kļūdas paziņojumu
					$data['values'] = $_POST;
					$data['errors'] = $error;
					//include('v_reservation_travel.php');
					//exit();
				}else{
					// viss pareizi
					
					//23.12.2019 - izveido jau šeit rezervāciju un pieteikumus, lai būtu vietas jau aizņemtas
					$dalibn_id_arr = array();
					//ja rezevācijā ietilpst profila īpašnieks, to saglabā uzreiz jau
					if ($_SESSION['reservation']['i_travel']){
						require_once("m_dalibn.php");
						$dalibn = new Dalibn();
						$es = $dalibn->GetId();
						$mans_did = $es['ID'];
						$dalibn_id_arr[0] = $mans_did;
					}
					else $dalibn_id_arr[0] = 0;
					//
					for($i=1;$i<$_SESSION['reservation']['traveller_count'];$i++){
						$dalibn_id_arr[] = 0;
					}					
					$online_rez_id = $online_rez->CreateNew($dalibn_id_arr);	
					if (!$online_rez_id){
					
						$text = "<b>REZERVĀCIJA #".$online_rez_id.": ".$tabs[$_SESSION['tabs']['current']]['title']."-kļūda</b>:<br>";
						$text .= 'Kļūda, saglabājot rezervāciju. Lūdzu, mēģiniet vēlreiz';
						$u_track->Save($text);
						// rādam vecās vērtības un kļūdas paziņojumu
						$data['values'] = $_POST;
						$data['errors'] = $res;
					} else if ($online_rez_id == -1)
					{
						// kads jau registrejies
						$text = "<b>REZERVĀCIJA #".$online_rez_id.": ".$tabs[$_SESSION['tabs']['current']]['title']."-kļūda</b>:<br>";
						$text .= 'Kāds no dalībniekiem jau reģistrējies šim ceļojumam. Sazinieties ar IMPRO biroju!';
						$u_track->Save($text);
						// rādam vecās vērtības un kļūdas paziņojumu
						echo '<BR><BR><BR><CENTER><p style="font-size:24px">Kāds no dalībniekiem jau reģistrējies šim ceļojumam. Sazinieties ar IMPRO biroju!<BR><a href="https://www.impro.lv/online/c_home.php">Uz sākumu</a></p>';
						die();
					}
					else{				
					//---------------------------//
					
						$celojums = $gr->GetCelojumaNosId($_POST['travel']);
						$text = "<b>REZERVĀCIJA #".$online_rez_id.": "."Izvēlētais ceļojums</b>: ".$celojums;
						$u_track->Save($text);
						// ejam uz nākamo soli
						$_POST['post'] = 0;
						Travellers();
						exit();
					}
				}
			}
			
			if (isset( $_SESSION['reservation']['traveller_count'])){
				$traveller_count = $_SESSION['reservation']['traveller_count'];
				//$i_travel = $_SESSION['reservation']['i_travel'];
			}
			else{
				TravellerCount();
				exit();
			}
			if (isset($_SESSION['reservation']['grupas_id'])){
				$data['travel'] = $_SESSION['reservation']['grupas_id'];
			}
			//ja nonāk no mājaslapas pogas 'PIRKT'
			else if (isset($_SESSION['pirkt']['grupas_id'])){
				$data['travel'] = $_SESSION['pirkt']['grupas_id'];
			}
			
			// sagatavo ceļojumu sarakstu
			require_once("m_grupa.php");
			$grupa = new Grupa();
			$list = $grupa->AvailableList($traveller_count);
			//var_dump(count($list));
			if (count($list)>0){
				require_once("m_marsruts.php");
				$marsruts = new Marsruts();
				$data['celojumi'] = array();
				//$grupas_id_arr = array();
				foreach ($list as $grupa){

					$grupas_id = $grupa['ID'];
					
					$grupas_id_arr[] = $grupas_id;
					$mID = $grupa['mID'];
					$data['celojumi'][$grupa['ID']]['marsruts'] = $marsruts->GetId($mID);
					$data['celojumi'][$grupa['ID']]['grupa']['sakuma_dat'] = $db->Date2Str($grupa['sakuma_dat']);
					$vietas = $grupa['vietas'];

					$data['celojumi'][$grupa['ID']]['grupa']['vietas'] = $vietas;
					
					$data['celojumi'][$grupa['ID']]['grupa']['ID'] = $grupa['ID'];
				}
				$grupas_id_list = implode(",",$grupas_id_arr);
				
			}
						
		}
		//rezervāciju vairs nevar labot
		else{
			//atrod izvēlēto ceļojumu			
			require_once("m_marsruts.php");
			require_once("m_grupa.php");			
			
			$marsruts = new Marsruts();
			$gr = new Grupa();
			
			//dabū grupas ID no online_rez id
			$gid = $online_rez->GetGidId($online_rez_id);
			//echo "gid $gid <br>";
			$data['travel'] = $gid;
			//sagatavo ceļojuma info
		
			$data['celojumi'] = array();
			
			$list = $gr->AvailableList(0,$gid);
			//echo "<br>LIST<br>";
			//var_dump($list);
			//echo "<br><br>";
			$grupa = $list[0];
			//var_dump($grupa);
			$mID = $grupa['mID'];
			$data['celojumi'][$grupa['ID']]['marsruts'] = $marsruts->GetId($mID);
			$data['celojumi'][$grupa['ID']]['grupa']['sakuma_dat'] = $db->Date2Str($grupa['sakuma_dat']);
			$data['celojumi'][$grupa['ID']]['grupa']['vietas'] = $grupa['vietas'];
			$data['celojumi'][$grupa['ID']]['grupa']['ID'] = $grupa['ID'];
		}		
		include('v_reservation_travel.php');
	}
	else{
		header("Location: c_login.php");
	}
}