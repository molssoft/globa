<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init_utf.php");
require_once("online2/m_pieteikums_utf.php");



$db = New db();
$piet = new Pieteikums();
 
// Cancel requested invoice status for gift card reservation
if (isset($_GET['cancel_invoice']) && $_GET['cancel_invoice'] == '1' && isset($_GET['pid'])) {
	$pid = (int)$_GET['pid'];

	if ($pid > 0) {
		// pid is pieteikums.id, get linked online_rez
		$rez = $piet->OnlineRez($pid);
		if (!empty($rez) && !empty($rez['id'])) {
			$rez_id = (int)$rez['id'];
			$db->Update('online_rez', array('invoice_status' => null), $rez_id);
			$_SESSION["message"] = "Rēķina pieprasījums atcelts.";
		}
		else{
			$_SESSION["message"] = "Neizdevās atrast rezervāciju.";
		}
	}
	else{
		$_SESSION["message"] = "Nederīgs pieteikuma ID.";
	}
	// restore previously loaded filter result after redirect
	$_SESSION['restore_dk_filters'] = 1;
	header("Location: c_davanu_kartes.php");
	exit();
}



if (isset($_POST['submit'])){
	$error = array();
	unset($where_arr);

	if (strlen($_POST['datums_no'])>0){
		if (!$db->CheckDateFormat($_POST['datums_no'])){
			$error['datums_no'] = 'Datumam jābūt formā dd.mm.YYYY';
		}
		else{
			$db1 = $db->EscapeValues($_POST,'datums_no');
			$where_arr['datums_no'] = date("Y-m-d",strtotime($db1['datums_no']));
		}
	}
	if (strlen($_POST['datums_lidz'])>0){
		if (!$db->CheckDateFormat($_POST['datums_lidz'])){
			$error['datums_lidz'] = 'Datumam jābūt formā dd.mm.YYYY';
		}
		else{
			$db1 = $db->EscapeValues($_POST,'datums_lidz');
			$where_arr['datums_lidz'] = date("Y-m-d",strtotime("+1 day",strtotime($db1['datums_lidz'])));
		}
	}
	if (strlen($_POST['dk_numurs'])>0){
		if (!is_numeric($_POST['dk_numurs'])){
			$error['dk_numurs'] = 'D.k. numuram jābūt skaitlim';
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
	if (!empty($_POST['requested_only']) && $_POST['requested_only'] === '1'){
		$where_arr['requested_only'] = 1;
	}
	if (count($error) > 0) {
		
		$data['errors'] = $error;
	}
	else{
		
		//var_dump($where_arr);					
		$dk = $piet->GetDkWhere($where_arr);
		$data['dk'] = $dk;
		// keep successful filter/search in session so it can be restored after cancel action
		$_SESSION['dk_filters_where'] = $where_arr;
		$_SESSION['dk_filters_values'] = $_POST;
		//var_dump($dk);
	}
	
	$data['values'] = $_POST;
	
}

// after cancel redirect, restore previously loaded filtered list
if (!isset($_POST['submit']) && !empty($_SESSION['restore_dk_filters'])) {
	unset($_SESSION['restore_dk_filters']);
	if (isset($_SESSION['dk_filters_where']) && is_array($_SESSION['dk_filters_where'])) {
		$data['dk'] = $piet->GetDkWhere($_SESSION['dk_filters_where']);
	}
	if (isset($_SESSION['dk_filters_values']) && is_array($_SESSION['dk_filters_values'])) {
		$data['values'] = $_SESSION['dk_filters_values'];
	}
}

include_once("v_davanu_kartes.php") ;

if (isset($_SESSION["message"]) && $_SESSION["message"] != "") {
	echo "<center><font color='RED' size='5'><b>".$_SESSION["message"]."</b></font>";
	$_SESSION["message"] = "";
}
 if (isset($_GET['pid']) && (int)$_GET['pid'] >0){
	require_once("online2/m_dalibn_utf.php");
	require_once("online2/m_pieteikums_utf.php");
	$dalibn = new Dalibn();
	$piet = new Pieteikums();
	$pid = (int)$_GET['pid'];
	$pieteikums = $piet->GetId($pid);
	$did = $pieteikums['did'];

	if (empty($did)){
		$did = $dalibn->GetIdPidSaite($pid);
	}
	if (!empty($did)){
		
		$dalibnieks = $dalibn->GetId($did);
	
	}
 }
?>



