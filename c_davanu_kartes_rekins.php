<?php
session_start();

require_once("i_functions_utf.php");

require_once("online2/m_init_utf.php");
require_once("online2/m_pieteikums_utf.php");
require_once("online2/m_profili_utf.php");
require_once("online2/m_orderis_utf.php");

$db = new Db();

if (!isset($_GET['pid']) || (int)$_GET['pid'] <= 0) {
	die('Invalid pid');
}

$pid = (int)$_GET['pid']; // pieteikums.id (same id as in c_invoice.php?id=...)

$pieteikumsModel = new Pieteikums();
$pieteikums = $pieteikumsModel->GetId($pid);
if (empty($pieteikums)) {
	die('Reservation not found');
}

$online_rez_id = (int)($pieteikums['online_rez'] ?? 0);
$dk_summa = $pieteikums['dk_summa'] ?? 0;
$rekina_online_fails = trim((string)($pieteikums['rekina_online_fails'] ?? ''));
$rekina_online_url = '';
if ($rekina_online_fails !== '') {
	$rekina_online_url = 'https://impro.lv/online/rekini/' . rawurlencode($rekina_online_fails);
}

$orderisModel = new Orderis();
$last_payment_datums_raw = $orderisModel->GetLatestPaymentDatums($pid);
// Display as dd.mm.yyyy (user form format); Db::sql_date converts on submit in generet.php
$last_payment_datums_value = '';
if ($last_payment_datums_raw !== null) {
	if ($last_payment_datums_raw instanceof DateTimeInterface) {
		$last_payment_datums_value = $last_payment_datums_raw->format('d.m.Y');
	} else {
		$ts = strtotime((string)$last_payment_datums_raw);
		if ($ts !== false) {
			$last_payment_datums_value = date('d.m.Y', $ts);
		}
	}
}
if (!empty($_POST['post']) && array_key_exists('last_payment_datums', $_POST)) {
	$last_payment_datums_value = trim((string)$_POST['last_payment_datums']);
}

$profiliModel = new Profili();
$profile = [];
$profile_id = 0;

if ($online_rez_id > 0) {
	// Profili::GetOnlineRez($rez_id) returns profili row joined by online_rez.profile_id
	$profile = $profiliModel->GetOnlineRez($online_rez_id);
	if (!empty($profile) && isset($profile['id'])) {
		$profile_id = (int)$profile['id'];
	}
}

$company = [
	'company_name' => $profile['company_name'] ?? '',
	'company_reg' => $profile['company_reg'] ?? '',
	'company_vat' => $profile['company_vat'] ?? '',
	'company_address' => $profile['company_address'] ?? '',
	'company_bank_name' => $profile['company_bank_name'] ?? '',
	'company_bank_account' => $profile['company_bank_account'] ?? '',
	'company_email' => (($profile['company_email'] ?? '') !== '')
		? $profile['company_email']
		: ($profile['eadr'] ?? ''),
];

$message = '';
$errors = [];
$show_no_supplier_msg = false;

if (!empty($_GET['saved'])) {
	$message = 'Dati saglabāti.';
}
if (!empty($_GET['err'])) {
	$err = (string)$_GET['err'];
	if ($err === 'required') {
		$errors[] = 'required';
	} elseif ($err === 'post') {
		$errors[] = 'post';
	} elseif ($err === 'notfound') {
		$errors[] = 'notfound';
	} elseif ($err === 'template') {
		$errors[] = 'template';
	} elseif ($err === 'payment_date') {
		$errors[] = 'payment_date';
	} elseif ($err === 'accounting') {
		$errors[] = 'accounting';
	} elseif ($err === 'piegadataji') {
		$errors[] = 'piegadataji';
	} elseif ($err === 'rekins_exists') {
		$errors[] = 'rekins_exists';
	} elseif ($err === 'file_save') {
		$errors[] = 'file_save';
	} elseif ($err === 'email') {
		$errors[] = 'email';
	} elseif ($err === 'email_queue') {
		$errors[] = 'email_queue';
	}
}

// Compare profile company data with Piegadataji and suggest values for mismatched fields.
$piegadatajs = null;
$supplier_by_field = [];
$field_suggestions = [];

if (!empty($company['company_reg'])) {
	$qry = "SELECT TOP 1 * FROM Piegadataji WHERE regnr=? ORDER BY ID DESC";
	$res = $db->Query($qry, [$company['company_reg']]);
	$piegadatajs = sqlsrv_fetch_array($res, SQLSRV_FETCH_ASSOC);
	if (empty($piegadatajs)) {
		$show_no_supplier_msg = true;
	}
}

if (!empty($piegadatajs)) {
	$addr_parts = [];
	if (!empty($piegadatajs['adrese'])) $addr_parts[] = trim((string)$piegadatajs['adrese']);
	if (!empty($piegadatajs['adrese2'])) $addr_parts[] = trim((string)$piegadatajs['adrese2']);
	$pieg_adrese = trim(implode(', ', $addr_parts));
	$pieg_bank_name = '';
	if (!empty($piegadatajs['banka'])) {
		$bank_res = $db->Query("SELECT TOP 1 nosaukums FROM Bankas WHERE id=?", [(int)$piegadatajs['banka']]);
		if ($bank_row = sqlsrv_fetch_array($bank_res, SQLSRV_FETCH_ASSOC)) {
			$pieg_bank_name = trim((string)($bank_row['nosaukums'] ?? ''));
		}
	}

	$supplier_by_field = [
		'company_name' => (string)($piegadatajs['nosaukums'] ?? ''),
		'company_reg' => (string)($piegadatajs['regnr'] ?? ''),
		'company_vat' => (string)($piegadatajs['PVN_regnr'] ?? ''),
		'company_address' => $pieg_adrese,
		'company_bank_name' => $pieg_bank_name,
		'company_bank_account' => (string)($piegadatajs['bankas_konts'] ?? ($piegadatajs['konts'] ?? '')),
	];

	foreach ($supplier_by_field as $field => $supplier_val) {
		$supplier_val = trim((string)$supplier_val);
		$profile_val = trim((string)($company[$field] ?? ''));
		if ($supplier_val === '') continue;

		$is_same = mb_strtolower($profile_val, 'UTF-8') === mb_strtolower($supplier_val, 'UTF-8');
		if (!$is_same) {
			$field_suggestions[$field] = $supplier_val;
		}
	}
}

?>
<?php
include_once("v_davanu_kartes_rekins.php");
?>

