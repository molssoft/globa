<?
session_save_path('c:\temp');
session_start();
require_once('m_init_utf.php');
require_once('m_profili_utf.php');
require_once('m_online_rez_utf.php');

$db = new Db;
$profili = new Profili;
$data = array();

if (!$profili->CheckLogin()) {
	header("Location: c_login.php");
	exit();
}

// If id (pieteikums id) is passed, verify it belongs to the current user (did)
if (isset($_GET['id'])) {
	$pid = (int)$_GET['id'];
	if ($pid <= 0) {
		header("Location: c_login.php");
		exit();
	}
	require_once('m_pieteikums_utf.php');
	$pieteikums = new Pieteikums();
	$piet = $pieteikums->GetId($pid);
	if (!$piet) {
		header("Location: c_login.php");
		exit();
	}
	require_once('m_dalibn.php');
	$dalibn = new Dalibn();
	$dalibnieks = $dalibn->GetId();
	if (!$dalibnieks || (int)$piet['did'] !== (int)$dalibnieks['ID']) {
		header("Location: c_login.php");
		exit();
	}
}

if (isset($_POST['post']) && $_POST['post'] == 1) {
	$error = array();
	// optional validation - add if needed
	if (!empty($_POST['company_name']) && strlen($_POST['company_name']) > 255) {
		$error['company_name'] = 'Uzņēmuma nosaukums ir par garu';
	}

	if (count($error) == 0 && isset($_SESSION['profili_id'])) {
		$db1 = $db->EscapeValues($_POST, 'company_name,company_reg,company_vat,company_address,company_bank_name,company_bank_account');
		$profili->Update($db1, $_SESSION['profili_id']);
		$data['success'] = "Izmaiņas veiksmīgi saglabātas!";

		// Ja ir pieteikums ar online rezervāciju, atzīmējam, ka rēķins ir pieprasīts
		if (isset($piet) && !empty($piet['online_rez'])) {
			$onlineRez = new OnlineRez();
			$onlineRez->UpdateInvoiceStatus((int)$piet['online_rez'], 'requested');
		}
	}

	if (count($error) > 0) {
		$data['values'] = $_POST;
		$data['errors'] = $error;
	}
}

// Load current profile for display (record already exists - update only)
if (isset($_SESSION['profili_id'])) {
	$row = $profili->GetId($_SESSION['profili_id']);
	$values = array(
		'company_name'  => isset($row['company_name']) ? $row['company_name'] : '',
		'company_reg'   => isset($row['company_reg']) ? $row['company_reg'] : '',
		'company_vat'   => isset($row['company_vat']) ? $row['company_vat'] : '',
		'company_address' => isset($row['company_address']) ? $row['company_address'] : '',
		'company_bank_name' => isset($row['company_bank_name']) ? $row['company_bank_name'] : '',
		'company_bank_account' => isset($row['company_bank_account']) ? $row['company_bank_account'] : ''
	);
	// If we have POST values (e.g. after validation error), prefer those
	if (isset($data['values'])) {
		$values = array_merge($values, $data['values']);
	}
	$data['values'] = $values;
}

// Invoice status for this reservation (when opened with id= pieteikums id)
if (isset($piet) && !empty($piet['online_rez'])) {
	$onlineRez = new OnlineRez();
	$rez_row = $onlineRez->GetId($piet['online_rez']);
	$data['invoice_status'] = isset($rez_row['invoice_status']) ? trim($rez_row['invoice_status']) : null;
} else {
	$data['invoice_status'] = null;
}

include 'v_invoice_company.php';
