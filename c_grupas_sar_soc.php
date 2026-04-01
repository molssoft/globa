<?
/*==================================================*/
// Grupas saraksa izdrukâðana sociâlajiem tîkliem	//
/*==================================================*/

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

require_once("online2/m_pieteikums.php");
require_once("online2/m_dalibn.php");
require_once("online2/m_marsruts.php");
require_once("online2/m_grupa.php");

$db = New Db();

$piet = new Pieteikums();

$dalibn = new Dalibn();

$marsruts = new Marsruts();

$gr = new Grupa();

$gid = (int)$_GET['gid'];
if ($gid>0){
	
	$grupa = $gr->GetId($gid);
	//var_dump($grupa);
	$nosaukums = $grupa['v'];
	$datums_no = $db->date2Str($grupa['sakuma_dat']);
	$datums_lidz = $db->date2Str($grupa['beigu_dat']);
	$vaditajs = $gr->GetVaditajs($gid);
	$vaditajs = $vaditajs['vards'].' '.$vaditajs['uzvards'];
	$dalibn_list = $gr->GetDalibnList($gid);
	
	
	require 'vendor/autoload.php';
	//die('asdf');
	$mpdf = new \Mpdf\Mpdf([
    'tempDir' => 'C:\temp\mpdf',  // Replace with your desired temporary directory path
    'mode' => 'utf-8',      // Mode (default is 'utf-8')
    'format' => 'A4',       // Page format
    'margin_left' => 0,     // Left margin
    'margin_right' => 0,    // Right margin
    'margin_top' => 0,      // Top margin
    'margin_bottom' => 0,   // Bottom margin
    'margin_header' => 0,   // Header margin
    'margin_footer' => 0    // Footer margin	
	]);


	
	$mpdf->showImageErrors = true; 
	$mpdf->SetDisplayMode('fullpage');
	$text = "<html>";
	$text .= "
		<head>
			<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
			<style>
			@page {
     margin: 1cm 1cm 1cm 2cm;
    }
				.img {position:absolute;}
				.text {
					position:absolute;
					top:5px;
					left:10px;
					width:100%;
					
					}
				.center{
					text-align:center
				}
				.right{
					text-align:right
				}
				p , .big{
					font-size: 18px;
				}
				
.big-font{
	font-size:16px
}
				
			</style>
		</head>";

	$text .= "<body>
		
		<div>
		<p>SIA IMPRO CEÏOJUMI, reìistrâcijas Nr.40003235627, biroja adrese Meríeïa ielâ 13-204, Rîgâ, LV-1050, turpmâk – Impro, sniedzot tûrisma pakalpojumu:  
		</p>
		<table>
			<tr><td>ceïojuma nosaukums:</td><td><b class=big-font>$nosaukums</b></td></tr>
			<tr><td>ceïojuma laiks:</td><td><b class=big-font>no $datums_no lîdz $datums_lidz</b></td></tr>
			<tr><td>grupas vadîtâjs:</td><td><b class=big-font>$vaditajs</b></td></tr>
		</table>
		<ol>
		<li>Ceïojuma laikâ veic fotografçðanu un filmçðanu, lai nodroðinâtu ceïojuma atspoguïojumu uzòçmuma likumîgo intereðu un tiesîbu realizâcijai.</li>
		<li>Ceïojuma laikâ iegûtâs fotogrâfijas un video ieraksti var tikt ievietoti sociâlajos tîklos, uzòçmuma mâjas lapâ www.impro.lv un Impro ceïojumu katalogâ.</li>
		<li>Lûdzam Jûs ierakstît tabulâ “<b>JÂ</b>” vai “<b>NÇ</b>”, norâdot, vai Jûs piekrîtat vai nepiekrîtat, ka ðî ceïojuma laikâ varat tikt fotografçts un filmçts, iegûtâs fotogrâfijas un video ieraksti var tikt publicçti sociâlajos tîklos, uzòçmuma mâjas lapâ www.impro.lv un Impro ceïojumu katalogâ.</li>
		<li>Savu piekriðanu Jûs varat atsaukt jebkurâ laikâ, par to informçjot grupas vadîtâju (ceïojumu laikâ), vai Impro administrâciju (pçc ceïojuma).</li>

			</ol>
			<table border=1 style='width:100%'>
			<tr ><td class='center' style='width:2em'>Nr.<br>p.k.</td><td class='center' >	Vârds</td><td class='center' >	Uzvârds</td><td class='center'  style='width:120px'>	Piekrîtu “<b>JÂ</b>” /<br>
		Nepiekrîtu “<b>NÇ</b>”</td><td class='center'  style='width:200px'>	Paraksts</td></tr>
		";
		if (!empty($dalibn_list)){
			
			$i=1;
			foreach($dalibn_list as $row){
				
				$vards = $row['vards'];
				$uzvards = $row['uzvards'];
				if (empty($uzvards) and empty($vards)){
					$vards = $row['nosaukums'];
					$uzvards = "";
				}
				$text .= "<tr><td  >".$i++.".</td><td>".$vards."</td><td>".$uzvards."</td><td></td><td></td></tr>";
			}
			
		}		
		$text .= "
 
			</table>
	</div>
		</body>";
		$text = iconv("windows-1257","utf-8",$text);
		$mpdf->WriteHTML($text);
		echo $mpdf->Output();
		die();


		ob_clean();
		echo $mpdf->Output('davanu karte','D');
}
else{
	die("Nav norâdîts grupas Nr.");
}

	 
?>