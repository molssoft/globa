<?php
/**
 * Rēķina (invoice) HTML generation.
 * Generates HTML string similar to the Classic ASP invoice layout.
 */
class Rekins {

	/**
	 * Generate invoice HTML (sample data for now).
	 * @return string HTML string for the invoice
	 */
	public static function generateHtml() {
		$css = self::getStyles();
		$body = self::buildInvoiceBody();
		return $css . $body;
	}

	/**
	 * Invoice CSS (matches ASP layout).
	 * @return string
	 */
	protected static function getStyles() {
		return '<style>
	#r_main{
		font-size:12px;
		background-color:white;
		width:600px;
	}
	table{
		width:600px;
		border-spacing:0;
		border-collapse:collapse;
		font-size:12px;
	}
	td{
		border:1px solid black;
		padding:5px;
	}
	td.nb{
		border:0px;
	}
	#a_r{text-align:right;}
	#a_l{text-align:left;}
	#a_c{text-align:center;}
	.nobr{white-space:nowrap;}
	table.head{
		border-spacing:0px;
		border-collapse:collapse;
	}
	.thin{
		height:5px;
		border:0px;
		padding:0px;
	}
	.hlight{
		font-weight:bold;
		font-size:16px;
	}
</style>';
	}

	/**
	 * Build invoice body HTML with sample data.
	 * @return string
	 */
	protected static function buildInvoiceBody() {
		$html = '<div id="r_main">';

		// --- Company header ---
		$issuer_name = 'SIA "Impro Ceļojumi"';
		$issuer_address = 'Juridiskā adrese: Merķeļa iela 13, Rīga, LV-1050<br>Biroja adrese: Merķeļa iela 13-204, Rīga, LV-1050<br>';
		$issuer_reg = 'Reģ.nr.40003235627, PVN reģ.nr.LV40003235627<br>';
		$issuer_bank = 'Norēķinu konts: A/s Swedbank, LV02HABA0001408051509, HABALV22<br>';
		$issuer_phone = 'Tālr: 67221312, 67507193';

		$invoice_no = '#/A';
		$invoice_date = date('d.m.Y');

		$html .= '<table class="head"><tr>';
		$html .= '<td align="center"><span class="hlight">' . htmlspecialchars($issuer_name) . '</span><br><br>';
		$html .= $issuer_address . $issuer_reg . $issuer_bank . $issuer_phone;
		$html .= '</td>';
		$html .= '<td align="center"><span class="hlight">FAKTŪRRĒĶINS</span><br><br>Nr. ' . htmlspecialchars($invoice_no) . '<br><br>' . $invoice_date . '</td></tr>';
		$html .= '<tr><td colspan="2" class="thin"></td></tr>';

		// --- Payer (maksātājs) - sample ---
		$maks_nos = 'Maksātāja nosaukums SIA';
		$maks_adrese = 'Adrese 1, Rīga, LV-1010';
		$maks_biroja = 'Biroja adrese 2, Rīga';
		$maks_reg_nr = '40003123456';

		$html .= '<tr><td colspan="2"><b>Maksātājs un viņa adrese:</b> ' . htmlspecialchars($maks_nos) . '<br>' . htmlspecialchars($maks_adrese) . '<br>';
		$html .= '<b>Biroja adrese:</b><br>' . htmlspecialchars($maks_biroja) . '<br>';
		$html .= '<b>Uzņēmuma reģistrācijas Nr. (personas kods):</b> ' . htmlspecialchars($maks_reg_nr);
		$html .= '</td></tr>';
		$html .= '<tr><td colspan="2" class="thin"></td></tr>';

		// --- Bank account ---
		$konts = 'LV00BANK0000435195001';
		$kods = 'HABALV22';
		$html .= '<tr><td colspan="2"><b>Konts nr:</b> ' . htmlspecialchars($konts) . '<br>';
		$html .= '<b>Kods:</b> ' . htmlspecialchars($kods);
		$html .= '</td></tr>';
		$html .= '<tr><td colspan="2" class="thin"></td></tr>';

		// --- Receiver (saņēmējs) - same as payer in sample ---
		$sanj = $maks_nos;
		$sanj_adrese = $maks_adrese;
		$sanj_reg_nr = $maks_reg_nr;
		$liguma_nr = 'L-2024/001';

		$html .= '<tr><td colspan="2"><b>Pakalpojuma saņēmējs un viņa adrese:</b> ' . htmlspecialchars($sanj) . '<br>' . htmlspecialchars($sanj_adrese) . '<br>';
		$html .= '<b>Uzņēmuma reģistrācijas Nr. (personas kods):</b> ' . htmlspecialchars($sanj_reg_nr) . '<br>';
		$html .= '<b>Līguma Nr.:</b> ' . htmlspecialchars($liguma_nr);
		$html .= '</td></tr>';
		$html .= '<tr><td colspan="2" class="thin"></td></tr>';
		$html .= '</table>';

		// --- Items table ---
		$str_valuta = 'EUR';
		$html .= '<table>';
		$html .= '<tr><td>Nosaukums</td><td>Cena</td><td>Sk.</td><td class="nobr">Summa<br>' . $str_valuta . '</td></tr>';

		// Sample rows (iemaksas-style)
		$items = array(
			array('apraksts' => 'Ceļojums 01.06.2024-15.06.2024 (Jānis Bērziņš)', 'bez_pvn' => 150.00),
			array('apraksts' => 'Ceļojums 10.07.2024-24.07.2024 (Anna Kalniņa)', 'bez_pvn' => 280.50),
		);

		$sum = 0;
		foreach ($items as $row) {
			$sum += $row['bez_pvn'];
			$html .= '<tr><td>' . htmlspecialchars($row['apraksts']) . '</td><td>' . self::currPrint($row['bez_pvn']) . '</td><td>1</td><td>' . self::currPrint($row['bez_pvn']) . '</td></tr>';
		}

		$pvn = 0;
		$pvn_likme = 0;

		// Summa vārdiem
		$summa_vardiem = self::naudaVardiem($sum, $str_valuta);
		$html .= '<tr><td class="nb" id="a_l">Summa vārdiem: ' . htmlspecialchars($summa_vardiem) . ' </td><td colspan="2" class="nb" id="a_r">Summa</td><td>' . self::currPrint(round($sum - $pvn, 2)) . '</td></tr>';

		if ($pvn_likme > 0 && $pvn != 0) {
			$html .= '<tr><td class="nb" id="a_l">&nbsp;</td><td colspan="2" class="nb" id="a_r">PVN ' . $pvn_likme . '%</td><td>' . self::currPrint($pvn) . '</td></tr>';
		} else {
			$html .= '<tr><td class="nb" id="a_l">Likuma par PVN 136.p.</td><td colspan="2" class="nb" id="a_r">PVN 0%</td><td>0.00</td></tr>';
		}

		$kopa = $sum;
		$apm_dat = date('d.m.Y', strtotime('+5 weekdays'));

		$html .= '<tr><td class="nb" id="a_l">Rēķinu lūdzam apmaksāt līdz ' . $apm_dat . '</td><td colspan="2" class="nb" id="a_r">Kopā</td><td>' . self::currPrint($kopa) . '</td></tr>';
		$html .= '<tr><td class="nb" colspan="3" id="a_l"><br><br><br><br>Dokuments sagatavots bez paraksta saskaņā ar grāmatvedības likuma 11. panta 7. daļu<br><br></td></tr>';
		$html .= '</table>';
		$html .= '</div>';

		return $html;
	}

	/**
	 * Format number as currency (2 decimals).
	 * @param float $num
	 * @return string
	 */
	protected static function currPrint($num) {
		return number_format((float)$num, 2, '.', '');
	}

	/**
	 * Amount in words (Latvian) - simplified sample.
	 * @param float $sum
	 * @param string $valuta e.g. EUR
	 * @return string
	 */
	protected static function naudaVardiem($sum, $valuta = 'EUR') {
		$whole = (int)floor($sum);
		$cents = (int)round(($sum - $whole) * 100);
		// Placeholder: full implementation would convert number to Latvian words
		return $whole . ' ' . $valuta . ' ' . $cents . ' centi';
	}
}
