<?
/***********************************/
/* 10.01.2020 RT				   */
/* c_atsk_viss.php Kopçjâ atskaite */
/***********************************/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_pieteikums.php");
$db = New db();
$piet = new Pieteikums();

 $function = $db->GetGet('f');
 if ($function == 'PrintRow'){
	 
	 PrintRow();
 }
 else{

	include_once("v_atsk_viss.php") ;
 }

	
if (isset($_POST)){
	/* global $db;
	 $sak_dat = $db->GetPost('sak_dat');
	$beigu_dat = $db->GetPost('beigu_dat');
	//PrintTable(1);
	PrintRow();
	unset($where_arr);*/
//	var_dump($_POST);
	/*if (strlen($_POST['datums_no'])>0){
		if (!$db->CheckDateFormat($_POST['datums_no'])){
			$error['datums_no'] = 'Datumam jâbût formâ dd.mm.YYYY';
		}
		else{
			$db1 = $db->EscapeValues($_POST,'datums_no');
			$where_arr['datums_no'] = date("Y-m-d",strtotime($db1['datums_no']));
		}
	}
	if (strlen($_POST['datums_lidz'])>0){
		if (!$db->CheckDateFormat($_POST['datums_lidz'])){
			$error['datums_lidz'] = 'Datumam jâbût formâ dd.mm.YYYY';
		}
		else{
			$db1 = $db->EscapeValues($_POST,'datums_lidz');
			$where_arr['datums_lidz'] = date("Y-m-d",strtotime("+1 day",strtotime($db1['datums_lidz'])));
		}
	}
	if (strlen($_POST['dk_numurs'])>0){
		if (!is_numeric($_POST['dk_numurs'])){
			$error['dk_numurs'] = 'D.k. numuram jâbût skaitlim';
		}
		else{
			$db1 = $db->EscapeValues($_POST,'dk_numurs');
			$where_arr['dk_numurs'] = $db1['dk_numurs'];
		}
	}
	if (strlen($_POST['dk_kods'])>0){
		$db1 = $db->EscapeValues($_POST,'dk_kods');
		$where_arr['dk_kods'] = $db1['dk_kods'];
	}
	if (count($error) > 0) {
		// kïûda		
		// râdam vecâs vçrtîbas un kïûdas paziòojumu
		
		$data['errors'] = $error;
	}
	else{
		
		//var_dump($where_arr);					
		$dk = $piet->GetDkWhere($where_arr);
		$data['dk'] = $dk;
		//var_dump($dk);
	}
	
	$data['values'] = $_POST;*/
	
}
else{

}

if (isset($_SESSION["message"]) && $_SESSION["message"] != "") {
	echo "<center><font color='RED' size='5'><b>".$_SESSION["message"]."</b></font>";
	$_SESSION["message"] = "";
}

 
 function PrintTable($num){
	 global $db;

	$grupa_no = $db->GetPost('grupa_no');
	$grupa_lidz = $db->GetPost('grupa_lidz');
	$periods = $db->GetPost('periods');
	$neradit_agentu = $db->Check2Int($db->GetPost('neradit_agentu'));	
	$veids = $db->GetPost('veids');
	$valuta = $db->GetPost('valuta');
	$error = array();
	$data['values'] = $_POST;
	if (empty($sak_dat) or empty($beigu_dat)){
		$error['error'] = "<font color=RED size=3><b>Jânorâda operâcijas/pieteikuma sâkuma un beigu datums</b></font>";
		//$error['beigu_dat'] = "Jânorâda";
		
	}
	if (count($error) > 0) {
		// kïûda		
		// râdam vecâs vçrtîbas un kïûdas paziòojumu		
		$data['errors'] = $error; 
		
	}
	else{
		
	}

 }
 
 function PrintRow(){
	 //var_dump($_POST);
	 global $db;
	 require_once("online2/m_piet_atsk.php");
	
	
	 $sak_dat = $db->GetPost('sak_dat');
	 $lidz_dat = $db->GetPost('lidz_dat');
	 if (isset($_SESSION['tek_dat'])){
		 $tek_dat = $_SESSION['tek_dat'];
	 }
	 else{
		 $tek_dat = strtotime($sak_dat);
	 }
	
	 
	
	$beigu_dat = strtotime($db->GetPost('beigu_dat'));
	$grupa_no = strtotime($db->GetPost('grupa_no'));
	$grupa_lidz = strtotime($db->GetPost('grupa_lidz'));
	$periods = $db->GetPost('periods');
	$neradit_agentu = $db->Check2Int($db->GetPost('neradit_agentu'));	
	$veids = $db->GetPost('veids');
	$valuta = $db->GetPost('valuta');
	$error = array();
	$data['values'] = $_POST;
	if (empty($sak_dat) or empty($beigu_dat)){
		echo '';	
	}
	else{
		/*echo "tekdat:".date("d.m.Y",$tek_dat);	
		echo "<br>";
		echo "Periods:".$periods."<br>";	*/
		
		//ja viss izdrukâts jau
		if ($tek_dat >= $beigu_dat){
			unset($_SESSION['tek_dat'] );
			echo '';
		}
		else {
			$html = "";
			$html .= '
			<tr bgcolor="#fff1cc">
			<td align="right" valign="center">'.date("d.m.Y",$tek_dat).'</td>
			<td>
				Grupas<BR>
				Pieteikumu skaits<BR>
				Orderu skaits<BR>
				Iemaksas<BR>
				Pieteikumu summa
			</td>';			
			
			$pid0 = "select p.id from pieteikums p where isnull(p.deleted,0)=0 and isnull(grupas_vad,0) = 0 ";
			$ord0 = "select id from orderis o where isnull(o.deleted,0)=0 ";
			
			if ($neradit_agentu){
				$pid0 .= " and isnull(agents,0) = 0 ";
				$ord0 .= " and isnull(aid,0) = 0 ";
			}
			
			if (!empty($tek_dat)){
				$pid0 .= " and p.time_stamp >= '".date("Y-m-d",$tek_dat)."'";
				$ord0 .= " and o.datums >= '".date("Y-m-d",$tek_dat)."'";
			}
			if (!empty($lidz_dat)){
				$pid0 .= " and p.time_stamp <= '".date("Y-m-d",$lidz_dat)." 23:59'";
				$ord0 .= " and o.datums <= '".date("Y-m-d",$lidz_dat)." 23:59'";
			}
			
			$piet_atsk = new PietAtsk($pid0,$ord0,$grupa_no,$grupa_lidz);
			
			//--------------------------
			//kompleksie
			//--------------------------		
			$td = $piet_atsk->KompleksieData();		
			$html .= $td;
			
			//--------------------------
			//èarteri
			//--------------------------			
			$td = $piet_atsk->CarteriData();		
			$html .= $td;
			
			//--------------------------
			//vâktâs
			//--------------------------			
			$td = $piet_atsk->VaktasData();		
			$html .= $td;
			
			
			
		
	
			
			$html .= "</tr>";			
				
			$tek_dat = strtotime("+1 $periods",$tek_dat);		
			$_SESSION['tek_dat'] = $tek_dat;
			
			echo $html;
		}
	}
	
 }




