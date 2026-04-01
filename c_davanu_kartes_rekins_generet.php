<?php
session_start();

$_SESSION['path_to_files'] = 'online2/';

require_once('i_functions_utf.php');
require_once('online2/m_init_utf.php');
require_once('online2/m_pieteikums_utf.php');
require_once('online2/m_profili_utf.php');
require_once('online2/m_rekini.php');
require_once('online2/m_orderis_utf.php');

function davanu_rekins_redirect_error($pid, $code) {
	header('Location: c_davanu_kartes_rekins.php?pid=' . (int)$pid . '&err=' . rawurlencode($code));
	exit;
}

if (!isset($_GET['pid']) || (int)$_GET['pid'] <= 0) {
	header('Location: c_davanu_kartes.php');
	exit;
}

$pid = (int)$_GET['pid'];

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['post'])) {
	davanu_rekins_redirect_error($pid, 'post');
}

$db = new Db();
$dbPieg = new Db();
$dbPieg->connectGlobaUtf8();

$pietModel = new Pieteikums();
$piet = $pietModel->GetId($pid);
if (empty($piet)) {
	davanu_rekins_redirect_error($pid, 'notfound');
}

$online_rez_id = (int)($piet['online_rez'] ?? 0);

$profile_id = 0;
$profiliModel = new Profili();
if ($online_rez_id > 0) {
	$profile = $profiliModel->GetOnlineRez($online_rez_id);
	if (!empty($profile['id'])) {
		$profile_id = (int)$profile['id'];
	}
}

$profile_company_name = trim((string)($profile['company_name'] ?? ''));
$profile_company_reg = trim((string)($profile['company_reg'] ?? ''));
$profile_company_vat = trim((string)($profile['company_vat'] ?? ''));
$profile_company_address = trim((string)($profile['company_address'] ?? ''));
$profile_company_bank_name = trim((string)($profile['company_bank_name'] ?? ''));
$profile_company_bank_account = trim((string)($profile['company_bank_account'] ?? ''));
$profile_company_email = trim((string)($profile['company_email'] ?? ''));

$posted_company_email = trim((string)($_POST['company_email'] ?? ''));
if ($posted_company_email !== '' && filter_var($posted_company_email, FILTER_VALIDATE_EMAIL) === false) {
	davanu_rekins_redirect_error($pid, 'email');
}

if ($profile_company_reg === '') {
	davanu_rekins_redirect_error($pid, 'required');
}

$sqlPieg = 'SELECT TOP 1 * FROM Piegadataji WHERE regnr = ? ORDER BY ID DESC';
$resPieg = $dbPieg->Query($sqlPieg, [$profile_company_reg]);
$piegRow = ($resPieg !== false) ? sqlsrv_fetch_array($resPieg, SQLSRV_FETCH_ASSOC) : null;
if (empty($piegRow)) {
	davanu_rekins_redirect_error($pid, 'piegadataji');
}

$piegadataji_id = (int)($piegRow['ID'] ?? 0);
if ($piegadataji_id <= 0) {
	davanu_rekins_redirect_error($pid, 'piegadataji');
}

$company_name = trim((string)($piegRow['nosaukums'] ?? ''));
$company_reg = trim((string)($piegRow['regnr'] ?? ''));
$company_vat = trim((string)($piegRow['PVN_regnr'] ?? ''));
$company_bank_account = trim((string)($piegRow['bankas_konts'] ?? ($piegRow['konts'] ?? '')));

$addr_parts = [];
if (!empty($piegRow['adrese'])) {
	$addr_parts[] = trim((string)$piegRow['adrese']);
}
if (!empty($piegRow['adrese2'])) {
	$addr_parts[] = trim((string)$piegRow['adrese2']);
}
$company_address = trim(implode(', ', $addr_parts));

$bank_id = !empty($piegRow['banka']) ? (int)$piegRow['banka'] : 0;
$bank_code = '';
$company_bank_name = '';
if ($bank_id > 0) {
	$resBank = $dbPieg->Query('SELECT TOP 1 kods, nosaukums FROM Bankas WHERE id = ?', [$bank_id]);
	if ($resBank !== false && ($rowBank = sqlsrv_fetch_array($resBank, SQLSRV_FETCH_ASSOC))) {
		$bank_code = trim((string)($rowBank['kods'] ?? ''));
		$company_bank_name = trim((string)($rowBank['nosaukums'] ?? ''));
	}
}
if ($company_name === '') {
	$company_name = $profile_company_name;
}
if ($company_reg === '') {
	$company_reg = $profile_company_reg;
}
if ($company_vat === '') {
	$company_vat = $profile_company_vat;
}
if ($company_address === '') {
	$company_address = $profile_company_address;
}
if ($company_bank_name === '') {
	$company_bank_name = $profile_company_bank_name;
}
if ($company_bank_account === '') {
	$company_bank_account = $profile_company_bank_account;
}
if ($company_name === '' || $company_reg === '' || $company_address === '') {
	davanu_rekins_redirect_error($pid, 'required');
}

$company_email = ($posted_company_email !== '') ? $posted_company_email : $profile_company_email;
if ($company_email === '' || filter_var($company_email, FILTER_VALIDATE_EMAIL) === false) {
	davanu_rekins_redirect_error($pid, 'email');
}
if ($profile_id > 0) {
	$profiliModel->Update([
		'company_email' => $company_email,
	], $profile_id);
}

$orderisModel = new Orderis();
$last_payment_datums_raw = $orderisModel->GetLatestPaymentDatums($pid);
if ($last_payment_datums_raw === null) {
	davanu_rekins_redirect_error($pid, 'payment_date');
}
if ($last_payment_datums_raw instanceof DateTimeInterface) {
	$paymentDate = DateTimeImmutable::createFromFormat('Y-m-d', $last_payment_datums_raw->format('Y-m-d'));
} else {
	$ts = strtotime((string)$last_payment_datums_raw);
	$paymentDate = ($ts === false) ? false : (new DateTimeImmutable())->setTimestamp($ts);
}
if ($paymentDate === false) {
	davanu_rekins_redirect_error($pid, 'payment_date');
}

$invoice_year = (int)$paymentDate->format('Y');
$amount = round((float)($piet['dk_summa'] ?? 0), 2);
$rekiniModel = new Rekini();
$rekini_new_id = $rekiniModel->insertDavanuKarteOnlineInvoice(
	$invoice_year,
	$piegadataji_id,
	$company_name,
	$amount,
	$paymentDate,
	$pid
);
if ($rekini_new_id === -1) {
	davanu_rekins_redirect_error($pid, 'rekins_exists');
}
if ($rekini_new_id <= 0) {
	davanu_rekins_redirect_error($pid, 'accounting');
}

$dbAcc = new Db();
$dbAcc->connectAccounting(Rekini::dbNameForYear($invoice_year));
$resInv = $dbAcc->Query('SELECT TOP 1 num, numPostFix FROM Rekini WHERE id = ?', [$rekini_new_id]);
$rowInv = ($resInv !== false) ? sqlsrv_fetch_array($resInv, SQLSRV_FETCH_ASSOC) : null;
$invoice_num = (string)(int)($rowInv['num'] ?? 0);
$invoice_postfix = trim((string)($rowInv['numPostFix'] ?? '/ON'));
$invoice_number_display = $invoice_num . $invoice_postfix;

$apraksts = 'Dāvanu karte ON-LINE (' . (string)(int)round($amount) . ')';
$resTr = $dbAcc->Query('SELECT TOP 1 apraksts FROM Rekini_tr WHERE rekins = ? ORDER BY num', [$rekini_new_id]);
if ($resTr !== false && ($rowTr = sqlsrv_fetch_array($resTr, SQLSRV_FETCH_ASSOC))) {
	$aprakstsDb = trim((string)($rowTr['apraksts'] ?? ''));
	if ($aprakstsDb !== '') {
		$apraksts = $aprakstsDb;
	}
}

// mPDF installation is outside the project, do not modify it.
require 'E:\www\php\vendor\autoload.php';

$template_html_path = __DIR__ . '\rekins_template.htm';
$template_css_path = __DIR__ . '\rekins_template.css';

$template_html = file_get_contents($template_html_path);
$template_css = file_get_contents($template_css_path);

if ($template_html === false || $template_css === false) {
	davanu_rekins_redirect_error($pid, 'template');
}

$summaFormatted = number_format((float)$amount, 2, '.', '');
$invoiceDateText = $paymentDate->format('d.m.Y');
$terminsText = $paymentDate->modify('+7 days')->format('d.m.Y');

$numToWordsLv = function (int $n) use (&$numToWordsLv): string {
	$ones = [
		0 => 'nulle', 1 => 'viens', 2 => 'divi', 3 => 'trīs', 4 => 'četri',
		5 => 'pieci', 6 => 'seši', 7 => 'septiņi', 8 => 'astoņi', 9 => 'deviņi',
	];
	$teens = [
		10 => 'desmit', 11 => 'vienpadsmit', 12 => 'divpadsmit', 13 => 'trīspadsmit',
		14 => 'četrpadsmit', 15 => 'piecpadsmit', 16 => 'sešpadsmit',
		17 => 'septiņpadsmit', 18 => 'astoņpadsmit', 19 => 'deviņpadsmit',
	];
	$tens = [
		2 => 'divdesmit', 3 => 'trīsdesmit', 4 => 'četrdesmit', 5 => 'piecdesmit',
		6 => 'sešdesmit', 7 => 'septiņdesmit', 8 => 'astoņdesmit', 9 => 'deviņdesmit',
	];
	$parts = [];
	if ($n >= 1000000) {
		$m = intdiv($n, 1000000);
		$parts[] = $numToWordsLv($m);
		$parts[] = ($m % 10 === 1 && $m % 100 !== 11) ? 'miljons' : 'miljoni';
		$n %= 1000000;
	}
	if ($n >= 1000) {
		$t = intdiv($n, 1000);
		if ($t === 1) {
			$parts[] = 'viens';
			$parts[] = 'tūkstotis';
		} else {
			$parts[] = $numToWordsLv($t);
			$parts[] = 'tūkstoši';
		}
		$n %= 1000;
	}
	if ($n >= 100) {
		$h = intdiv($n, 100);
		$parts[] = ($h === 1) ? 'simts' : ($ones[$h] . ' simti');
		$n %= 100;
	}
	if ($n >= 20) {
		$d = intdiv($n, 10);
		$parts[] = $tens[$d];
		$n %= 10;
	}
	if ($n >= 10) {
		$parts[] = $teens[$n];
		$n = 0;
	}
	if ($n > 0) {
		$parts[] = $ones[$n];
	}
	return trim(implode(' ', $parts));
};
$amountToWordsLv = function (float $sum) use ($numToWordsLv): string {
	$sum = round($sum, 2);
	$eiro = (int)floor($sum);
	$centi = (int)round(($sum - $eiro) * 100);
	$eiroWords = ($eiro === 0) ? 'nulle' : $numToWordsLv($eiro);
	$eiroLabel = ($eiro % 10 === 1 && $eiro % 100 !== 11) ? 'eiro' : 'eiro';
	$centiLabel = ($centi % 10 === 1 && $centi % 100 !== 11) ? 'cents' : 'centi';
	return trim($eiroWords . ' ' . $eiroLabel . ' ' . str_pad((string)$centi, 2, '0', STR_PAD_LEFT) . ' ' . $centiLabel);
};
$summaVardiem = $amountToWordsLv((float)$amount);

$replacements = [
	'#num#' => $invoice_number_display,
	'#datums#' => $invoiceDateText,
	'#termins#' => $terminsText,
	'#nosaukums#' => $company_name,
	'#adrese#' => $company_address,
	'#regnr#' => $company_reg,
	'#konts#' => $company_bank_account,
	'#kods#' => $bank_code,
	'#banka#' => $company_bank_name,
	'#apraksts#' => $apraksts,
	'#summa#' => $summaFormatted,
	'#summa_vardiem#' => $summaVardiem,
];
$template_html = strtr($template_html, $replacements);

// Avoid double-loading css from link tag; we inject it inline for mPDF.
$template_html = preg_replace('/<link[^>]*rekins_template\.css[^>]*>/i', '', $template_html);
$html = '<style>body{font-family:calibri,sans-serif;}' . $template_css . '</style>' . $template_html;

// Register custom Calibri TTF fonts from mPDF folder.
$fontDir = 'E:\www\php\mpdf\fonts-ttf';
$resolveTtf = function (array $candidates) use ($fontDir) {
	foreach ($candidates as $name) {
		$full = $fontDir . '\\' . $name;
		if (file_exists($full)) {
			return $name;
		}
	}
	return null;
};

$calibriR = $resolveTtf(['calibri.ttf', 'CALIBRI.TTF']);
$calibriB = $resolveTtf(['calibrib.ttf', 'CALIBRIB.TTF', 'calibri-bold.ttf']);
$calibriI = $resolveTtf(['calibrii.ttf', 'CALIBRII.TTF', 'calibri-italic.ttf']);
$calibriBI = $resolveTtf(['calibriz.ttf', 'CALIBRIZ.TTF', 'calibri-bolditalic.ttf']);

$mpdfConfig = [
	'tempDir' => 'C:\temp\mpdf',
	'mode' => 'utf-8',
	'format' => 'A4',
];

if ($calibriR) {
	$defaultConfig = (new \Mpdf\Config\ConfigVariables())->getDefaults();
	$fontDirs = $defaultConfig['fontDir'];
	$defaultFontConfig = (new \Mpdf\Config\FontVariables())->getDefaults();
	$fontData = $defaultFontConfig['fontdata'];

	$calibriMap = ['R' => $calibriR];
	if ($calibriB) {
		$calibriMap['B'] = $calibriB;
	}
	if ($calibriI) {
		$calibriMap['I'] = $calibriI;
	}
	if ($calibriBI) {
		$calibriMap['BI'] = $calibriBI;
	}

	$mpdfConfig['fontDir'] = array_merge($fontDirs, [$fontDir]);
	$mpdfConfig['fontdata'] = $fontData + ['calibri' => $calibriMap];
	$mpdfConfig['default_font'] = 'calibri';
}

$mpdf = new \Mpdf\Mpdf($mpdfConfig);

$mpdf->WriteHTML($html);
$pdfDir = __DIR__ . '\online2\rekini';
if (!is_dir($pdfDir) && !mkdir($pdfDir, 0777, true)) {
	davanu_rekins_redirect_error($pid, 'file_save');
}

$filename = '';
for ($i = 0; $i < 5; $i++) {
	try {
		$filename = 'rekins_' . bin2hex(random_bytes(8)) . '.pdf';
	} catch (Exception $e) {
		$filename = 'rekins_' . uniqid('', true) . '.pdf';
		$filename = str_replace('.', '', $filename);
	}
	if (!file_exists($pdfDir . '\\' . $filename)) {
		break;
	}
	$filename = '';
}
if ($filename === '') {
	davanu_rekins_redirect_error($pid, 'file_save');
}

$fullPdfPath = $pdfDir . '\\' . $filename;
$mpdf->Output($fullPdfPath, 'F');
if (!file_exists($fullPdfPath)) {
	davanu_rekins_redirect_error($pid, 'file_save');
}

$pietModel->Update(['rekina_online_fails' => $filename], $pid);
$invoicePublicUrl = 'https://impro.lv/online/rekini/' . rawurlencode($filename);
$emailSubject = 'IMPRO rēķins ir pieejams lejupielādei';
$emailText = '<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	</head>
	<body>
	<b>Jūsu rēķins ir sagatavots.</b><br>
	<br>
	Rēķina numurs: ' . htmlspecialchars($invoice_number_display, ENT_QUOTES, 'UTF-8') . '<br>
	Summa: ' . htmlspecialchars($summaFormatted, ENT_QUOTES, 'UTF-8') . ' EUR<br>
	<br>
	Lai lejupielādētu rēķina PDF failu, spiediet
	<a href="' . htmlspecialchars($invoicePublicUrl, ENT_QUOTES, 'UTF-8') . '">šeit</a>.<br>
	<br><br>
	<i>SIA IMPRO Ceļojumi</i>
	</body>
	</html>';
$emailValues = [
	'[to]' => $company_email,
	'[subject]' => $emailSubject,
	'[text]' => $emailText,
	'date' => date('Y-m-d H:i:s'),
	'from_proc' => 'davanu_kartes_rekins',
	'encoded' => 1,
];
$emailInsertResult = $dbPieg->Insert('epasts', $emailValues);
if (empty($emailInsertResult)) {
	davanu_rekins_redirect_error($pid, 'email_queue');
}
if ($online_rez_id > 0) {
	$dbPieg->Update('online_rez', ['invoice_status' => 'sent'], $online_rez_id);
}
header('Location: c_davanu_kartes_rekins.php?pid=' . (int)$pid . '&saved=1');
exit;
