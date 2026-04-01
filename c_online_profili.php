<?
//-------------------------------------------
// Saraksts ar online lietotâju profiliem
//-------------------------------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_profili.php");
require_once("online2/m_dalibn.php");
$db = New db();
$profili = new Profili();
$dalibn = new Dalibn();

 
//$data['values']['datums_lidz'] = date("d.m.Y");
//var_dump($_POST);
if (isset($_POST['delete_pid'])){
	//f-ja kas dzçð profilu
	$deleted_rows = $profili->Delete((int)$_POST['delete_pid']);
	//var_dump($deleted_rows);
	if ($deleted_rows==0){
		$data['script'] = "<script>alert('Profils nav atrasts vai ir jau izdzçsts!');</script>";
	}
	else
		$data['script'] = "<script>alert('Profils ir izdzçsts!');</script>";
	$radit_nepabeigtos = $_POST['radit_nepabeigtos'];
}
if (isset($_POST['submit'])){
	$error = array();
	unset($where_arr);
//	var_dump($_POST);
	
	if (strlen($_POST['vards'])>0){
		$db1 = $db->EscapeValues($_POST,'vards');
		
		$where_arr['vards'] = $db1['vards'];
	}
	if (strlen($_POST['uzvards'])>0){
		$db1 = $db->EscapeValues($_POST,'uzvards');
		$where_arr['uzvards'] = $db1['uzvards'];
	}
	if (strlen($_POST['eadr'])>0){
		$db1 = $db->EscapeValues($_POST,'eadr');
		$where_arr['eadr'] = $db1['eadr'];
	}
	if (strlen($_POST['datums_no'])>0){
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
	if (count($error) > 0) {
		// kïûda		
		// râdam vecâs vçrtîbas un kïûdas paziòojumu
		
		$data['errors'] = $error;
	}
	else{
		
		//var_dump($where_arr);					
		//$dk = $piet->GetDkWhere($where_arr);
		$where = ' 1=1';
		if (!empty($where_arr)){
			$where_arr1 = array();
			//echo "where arr:<br>";
			//var_dump($where_arr);
			foreach($where_arr as $key=>$val){
				if ($key=='datums_no'){
					$where_arr1[] = "time_stamp>='$val'";
				}
				else if($key=='datums_lidz'){
					$where_arr1[] = "time_stamp<='$val'";
				}
				else{
					$where_arr1[] = "$key like '%$val%'";
				}
			}
			//echo "<br><br>";
			//var_dump($where_arr1);
			$where = implode(" AND ",$where_arr1);
		}
		//echo $where;
		$data['profili'] = $profili->GetWhere($where);
		//var_dump($dk);
	}
	
	$data['values'] = $_POST;
	$data['show_link'] = '<a href="?nepabeigtie=1">Râdît visus nepabeigtos profilus</a>';
	$data['show_link'] .= '<br><a href="?">Râdît pçdçjos 50 profilus</a>';
}
else{
	if (isset($_GET['nepabeigtie']) || isset($_POST['radit_nepabeigtos'])){
		$data['show_link'] = '<a href="?">Râdît pçdçjos 50 profilus</a>';
		$data['profili'] = $profili->GetWhere("eadr is NULL");
		$data['nepabeigtie'] = 1;
		
	}
	else{
		$data['top_n'] = 1;
		$data['show_link'] = '<a href="?nepabeigtie=1">Râdît visus nepabeigtos profilus</a>';
		$data['profili'] = $profili->GetLastProfiles();
		
	}
}
$data['profilu_skaits'] = count($data['profili']);
$data['pabeigto_profilu_sk'] = $profili->GetCountCompleted();
//var_dump($data['profili']);
include_once("v_online_profili.php") ;
if (isset($_SESSION["message"]) && $_SESSION["message"] != "") {
	echo "<center><font color='RED' size='5'><b>".$_SESSION["message"]."</b></font>";
	$_SESSION["message"] = "";
}
 
 
?>



