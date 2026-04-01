<?php
/**
 * Accounting invoices: tables Rekini (header) and Rekini_tr (lines) on the
 * accounting SQL Server. Include m_init_utf.php for the Db class; open the
 * year database with Db::connectAccounting (see dbdoc.php). Use a second
 * Db instance for accounting so the constructor’s Db stays on globa.
 */
class Rekini {
	var $db;

	public function __construct() {
		if (isset($_SESSION['path_to_files'])) {
			$path = $_SESSION['path_to_files'];
		} else {
			$path = '';
		}
		require_once($path . 'm_init_utf.php');
		$this->db = new Db;
	}

	/**
	 * Accounting database name: numeric year (int or digits-only string) -> sYYYY;
	 * otherwise the literal name (e.g. kopiga, s2026).
	 *
	 * @param int|string $yearOrDbName
	 * @return string
	 */
	public static function dbNameForYear($yearOrDbName) {
		if (is_int($yearOrDbName) || (is_string($yearOrDbName) && ctype_digit($yearOrDbName))) {
			return 's' . (int)$yearOrDbName;
		}
		return (string)$yearOrDbName;
	}

	/**
	 * Next invoice number (Rekini.num) for the given invoice type (Rekini.numPostFix).
	 * Numeration is independent per numPostFix within the year database sYYYY.
	 * Starts at 1 when no row exists for that postfix.
	 *
	 * @param int|string $year Fiscal year selecting database sYYYY
	 * @param string|null $numPostFix Category / type (e.g. /ON for gift card online); null or '' for blank type
	 * @return int
	 */
	public function GetNextInvoiceNum($year, $numPostFix) {
		$dbname = self::dbNameForYear($year);

		$dbAcc = new Db();
		$dbAcc->connectAccounting($dbname);

		$pfx = $numPostFix === null ? '' : trim((string)$numPostFix);

		$sql = "
			SELECT MAX(num) AS mx
			FROM Rekini
			WHERE ISNULL(numPostFix, '') = ?
		";
		$res = $dbAcc->Query($sql, array($pfx));
		if ($res === false) {
			return 1;
		}
		$row = sqlsrv_fetch_array($res, SQLSRV_FETCH_ASSOC);
		if (empty($row) || !array_key_exists('mx', $row) || $row['mx'] === null) {
			return 1;
		}

		return (int)$row['mx'] + 1;
	}

	/**
	 * Insert a new gift-card online invoice into accounting Rekini + Rekini_tr (always insert, no update).
	 * Connects to s{year} on the accounting server. Uses Piegadataji.ID as klients/maksatajs.
	 *
	 * @param int $year Fiscal year (database sYYYY), usually from payment date year
	 * @param int $piegadatajiId Piegadataji.ID on globa
	 * @param string $klientsNos Snapshot name (same as Piegadataji nosaukums)
	 * @param float $amount Invoice amount (e.g. dk_summa), 2 decimals
	 * @param \DateTimeInterface $paymentDate Date only (datums_apm, datums_izr, datums_grm)
	 * @param int $globaPid pieteikums.id for Rekini_tr.globa_pid and Rekini.pid
	 * @return int New Rekini.id; -1 if Rekini row with same pid already exists in s{year}; 0 on failure
	 */
	public function insertDavanuKarteOnlineInvoice($year, $piegadatajiId, $klientsNos, $amount, $paymentDate, $globaPid) {
		$year = (int)$year;
		$piegadatajiId = (int)$piegadatajiId;
		$globaPid = (int)$globaPid;
		$numPostFixDavanu = '/ON';

		$dbAcc = new Db();
		$dbAcc->connectAccounting(self::dbNameForYear($year));

		$resDup = $dbAcc->Query('SELECT TOP 1 id FROM Rekini WHERE pid = ?', array($globaPid));
		if ($resDup !== false) {
			$dupRow = sqlsrv_fetch_array($resDup, SQLSRV_FETCH_ASSOC);
			if (!empty($dupRow)) {
				$dupId = isset($dupRow['id']) ? (int)$dupRow['id'] : (int)($dupRow['ID'] ?? 0);
				if ($dupId > 0) {
					return -1;
				}
			}
		}

		$num = $this->GetNextInvoiceNum($year, $numPostFixDavanu);

		$summa = round((float)$amount, 2);
		$dt = $paymentDate instanceof \DateTimeInterface
			? new \DateTime($paymentDate->format('Y-m-d') . ' 00:00:00')
			: new \DateTime('today');

		$y2 = substr((string)$year, -2);
		$resurss = $y2 . '.D.2';
		$aprakstsRaw = 'Dāvanu karte ON-LINE (' . (string)(int) round($summa) . ')';
		// Rekini: klients_nos / maksatajs_nos nvarchar(100); Rekini_tr.apraksts nvarchar(200)
		$klientsNosDb = function_exists('mb_substr')
			? mb_substr($klientsNos, 0, 100, 'UTF-8')
			: substr($klientsNos, 0, 100);
		$aprakstsDb = function_exists('mb_substr')
			? mb_substr($aprakstsRaw, 0, 200, 'UTF-8')
			: substr($aprakstsRaw, 0, 200);

		// No OUTPUT clause: Rekini may have triggers; OUTPUT without INTO is disallowed then.
		$sqlR = "
			INSERT INTO Rekini (
				num, pid, klients, klients_nos, maksatajs, maksatajs_nos,
				dienas_apm, datums_apm, datums_izr, datums_grm,
				valuta, kurss, summa, summa_val, pvn, pvn_val, summa_pvn, summa_pvn_val,
				document, changed, numPostFix, transp_rek, apmaksats
			)
			VALUES (
				?, ?, ?, ?, ?, ?,
				?, ?, ?, ?,
				?, ?, ?, ?, ?, ?, ?, ?, ?,
				?, ?, ?, ?
			)
		";
		$paramsR = [
			$num,
			$globaPid,
			$piegadatajiId,
			$dbAcc->nvarcharParam($klientsNosDb, 100),
			$piegadatajiId,
			$dbAcc->nvarcharParam($klientsNosDb, 100),
			7,
			$dt,
			$dt,
			$dt,
			$dbAcc->nvarcharParam('EUR', 3),
			1,
			$summa,
			$summa,
			0,
			0,
			$summa,
			$summa,
			null,
			1,
			$dbAcc->nvarcharParam($numPostFixDavanu, 10),
			0,
			0,
		];

		$resR = $dbAcc->Query($sqlR, $paramsR);
		if ($resR === false) {
			return 0;
		}
		$resMax = $dbAcc->Query('SELECT MAX(id) AS id FROM Rekini', array());
		if ($resMax === false) {
			return 0;
		}
		$rowMax = sqlsrv_fetch_array($resMax, SQLSRV_FETCH_ASSOC);
		$rekiniId = 0;
		if (!empty($rowMax)) {
			$rekiniId = (int)($rowMax['id'] ?? $rowMax['ID'] ?? 0);
		}
		if ($rekiniId <= 0) {
			return 0;
		}

		$sqlT = "
			INSERT INTO Rekini_tr (
				num, rekins, resurss, debets, kredits, apraksts,
				cena_val, cena, cena_bez_pvn, skaits,
				summa, summa_val, pvn_koef, pvn, pvn_val, summa_pvn, summa_pvn_val,
				atlaide, pvn_likme_proc, globa_pid
			) VALUES (
				?, ?, ?, ?, ?, ?,
				?, ?, ?, ?,
				?, ?, ?, ?, ?, ?, ?,
				?, ?, ?
			)
		";
		$paramsT = [
			1,
			$rekiniId,
			$dbAcc->nvarcharParam($resurss, 50),
			$dbAcc->nvarcharParam('2.3.4.X', 50),
			$dbAcc->nvarcharParam('5.2.2.4', 50),
			$dbAcc->nvarcharParam($aprakstsDb, 200),
			$summa,
			0,
			$summa,
			1,
			$summa,
			$summa,
			0,
			0,
			0,
			$summa,
			$summa,
			0,
			0,
			$globaPid,
		];
		$dbAcc->Query($sqlT, $paramsT);

		return $rekiniId;
	}
}

