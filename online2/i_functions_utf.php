<?
$EUR_RATE = 0.702804;
$EUR_DATE = mktime(0,0,0,1,1,2014);
function CurrPrint($val){
	return number_format(round($val,2), 2, '.', '');
}
function Decode($s) {
    // Map of placeholders back to original Latvian letters
    $map = array(
        // lowercase
        '#a' => 'ā',
        '#c' => 'č',
        '#e' => 'ē',
        '#g' => 'ģ',
        '#i' => 'ī',
        '#k' => 'ķ',
        '#l' => 'ļ',
        '#n' => 'ņ',
        '#s' => 'š',
        '#u' => 'ū',
        '#z' => 'ž',
        // uppercase
        '#A' => 'Ā',
        '#C' => 'Č',
        '#E' => 'Ē',
        '#G' => 'Ģ',
        '#I' => 'Ī',
        '#K' => 'Ķ',
        '#L' => 'Ļ',
        '#N' => 'Ņ',
        '#S' => 'Š',
        '#U' => 'Ū',
        '#Z' => 'Ž'
    );

    // Replace all placeholders with original letters
    $s = strtr($s, $map);

    return $s;
}

function make_seed(){
	MakeSeed();
}
function MakeSeed()
{
  list($usec, $sec) = explode(' ', microtime());
echo "Sec: $sec <br>";
echo "uSec: $usec <br>";
  return (float) $sec + ((float) $usec * 100000);
}
function RandomStr($length = 10) {
    $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}
function RandomStr1($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyz')
{
    $str = '';
    $max = mb_strlen($keyspace, '8bit') - 1;
    for ($i = 0; $i < $length; ++$i) {
		srand(MakeSeed());
        $str .= $keyspace[rand(0, $max)];
    }
	echo $str;
	
}

//sadala pases nr pa da��m,ja ir nor�d�ts s�rijas numurs
function DokNr($nr){
	$re = "/([a-z]*)([\\d]+)/i"; 
	//$str = "LVd225252525"; 
	 
	preg_match($re, $nr, $matches);
	//echo "pases nr:<br>";
	//var_dump($matches);
	//echo "<br><br>";
	$numurs = array ('S' => FALSE,
					'NR' => FALSE);
	if (count($matches) == 3 && !empty($matches[1]) &&  !empty($matches[2])){
		//if (isset($matches[1])){
			$numurs['S'] = $matches[1];
			//$db1['paseS'] = 
		//}
		//if (isset($matches[2])){
			$numurs['NR'] = $matches[2];
		//}
	}
	return $numurs;
}

function GUID()
{
    if (function_exists('com_create_guid') === true)
    {
        return trim(com_create_guid(), '{}');
    }

    return sprintf('%04X%04X-%04X-%04X-%04X-%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(16384, 20479), mt_rand(32768, 49151), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}

function GetRealIpAddr(){
	if (!empty($_SERVER['HTTP_CLIENT_IP'])){   //check ip from share internet
		$ip=$_SERVER['HTTP_CLIENT_IP'];
	} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){   //to check ip is pass from proxy
		$ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
	} else {
		$ip=$_SERVER['REMOTE_ADDR'];
	}
	return $ip;
}
function Encode($s) {
    // Map of accented/foreign letters to placeholders
    $map = array(
        // lowercase
        'ā' => '#a',
        'č' => '#c',
        'ē' => '#e',
        'ģ' => '#g',
        'ī' => '#i',
        'ķ' => '#k',
        'ļ' => '#l',
        'ņ' => '#n',
        'š' => '#s',
        'ū' => '#u',
        'ž' => '#z',
        // uppercase
        'Ā' => '#A',
        'Č' => '#C',
        'Ē' => '#E',
        'Ģ' => '#G',
        'Ī' => '#I',
        'Ķ' => '#K',
        'Ļ' => '#L',
        'Ņ' => '#N',
        'Š' => '#S',
        'Ū' => '#U',
        'Ž' => '#Z'
    );

    // Replace all letters according to map
    $s = strtr($s, $map);

    return $s;
}

function uncode_latvian_special_chars_utf8($string) {
	$search = array();
	$replace = array();
	$search[] = '#a';
	$replace[]  = 'a';
	$search[] = '#c';
	$replace[]  = 'c';
	$search[] = '#e';
	$replace[]  = 'e';
	$search[] = '#g';
	$replace[]  = 'g';
	$search[] = '#i';
	$replace[]  = 'i';
	$search[] = '#k';
	$replace[]  = 'k';
	$search[] = '#l';
	$replace[]  = 'l';
	$search[] = '#n';
	$replace[]  = 'n';
	$search[] = '#s';
	$replace[]  = 's';
	$search[] = '#u';
	$replace[]  = 'u';
	$search[] = '#z';
	$replace[]  = 'z';
	$search[] = '#o';
	$replace[]  = 'o';
	$search[] = '#A';
	$replace[]  = 'A';
	$search[] = '#C';
	$replace[]  = 'C';
	$search[] = '#E';
	$replace[]  = 'E';
	$search[] = '#G';
	$replace[]  = 'G';
	$search[] = '#I';
	$replace[]  = 'I';
	$search[] = '#K';
	$replace[]  = 'K';
	$search[] = '#L';
	$replace[]  = 'L';
	$search[] = '#N';
	$replace[]  = 'N';
	$search[] = '#S';
	$replace[]  = 'S';
	$search[] = '#U';
	$replace[]  = 'U';
	$search[] = '#Z';
	$replace[]  = 'Z';
	$search[] = '#O';
	$replace[]  = 'O';
	return str_replace($search, $replace, $string);
}


	function Galotne($num,$vsk,$dsk) {
		$s = $dsk;
		if (Cipars($num,1)==1) $s = $vsk;
		if (Cipars($num,2)==1) $s = $dsk;
		return $s;
	}

	function Cipars($num, $k) {
		$my = floor($num/(pow(10,($k-1))));
		return $my-(floor($my/10)*10);
	}
function Simts($num) {

    $vieni[1] = "viens";
    $vieni[2] = "divi";
    $vieni[3] = "trīs";
    $vieni[4] = "četri";
    $vieni[5] = "pieci";
    $vieni[6] = "seši";
    $vieni[7] = "septiņi";
    $vieni[8] = "astoņi";
    $vieni[9] = "deviņi";

    $celms[1] = "vien";
    $celms[2] = "div";
    $celms[3] = "trīs";
    $celms[4] = "četr";
    $celms[5] = "piec";
    $celms[6] = "seš";
    $celms[7] = "septiņ";
    $celms[8] = "astoņ";
    $celms[9] = "deviņ";

    $s = "";

    $desm = Cipars($num,2);
    $vien = Cipars($num,1);

    if ($desm == 0) {
        $s = $vieni[$vien]." ";
    }

    if ($desm == 1) {
        if ($vien != 0) {
            $s = $celms[$vien]."padsmit ";
        } else {
            $s = "desmit ";
        }
    }

    if ($desm > 1) {
        if ($vien != 0) {
            $s = $celms[$desm]."desmit ".$vieni[$vien]." ";
        } else {
            $s = $celms[$desm]."desmit ";
        }
    }

    $sim = Cipars($num,3);

    if ($sim != 0) {
        $s = $vieni[$sim]." ".Galotne($sim,"simts ","simti ").$s;
    }

    return $s;
}

function Nauda($num,$lielie,$mazie) {

    $s = "";

    $milj = (int)($num/1000000);
    if ($milj > 0) {
        $s .= Simts($milj).Galotne($milj,"miljons ","miljoni ");
    }

    $tukst = (int)($num/1000);
    if ($tukst > 0) {
        $s .= Simts($tukst).Galotne($tukst,"tūkstotis ","tūkstoši ");
    }

    $lati = Simts($num);

    if (trim($lati)) {
        $s .= $lati." ".$lielie." ";
    } else {
        $s .= "nulle ".$lielie." ";
    }

    $sant = $num * 100;
    $s .= Cipars($sant,2).Cipars($sant,1)." ".$mazie;

    return $s;
}

function IsEuro()
{
	$EUR_DATE = strtotime("2014-01-01");
	$NOW_DATE = strtotime(date("Y-m-d"));
	if ($NOW_DATE>=$EUR_DATE)
		return 1;
	else
		return 0;
}

function CurrCode()
{
	if (!IsEuro()) 
		return "LVL";
	else
		return "EUR";
	
}

function CurrName()
{
	if (!IsEuro()) 
		return "lati";
	else
		return "eiro";
	
}

function CurrNameSmall()
{
	if (!IsEuro()) 
		return "sant�mi";
	else
		return "centi";
	
}

function Curr2TotalNumeric($lvl_amount,$eur_amount){

	$ret = 0;
	global $EUR_RATE;

	if (!IsEuro())
	{
		//pirms eiro �ra
		$total = GetNum($lvl_amount);
		$total = $total + GetNum($eur_amount) * $EUR_RATE;
		$ret = CurrPrint($total);
	}
	else
	{
		//eiro �ra
		$total = GetNum($eur_amount);
		$total = $total + GetNum($lvl_amount) / $EUR_RATE;
		$ret = CurrPrint($total);
	}

	return $ret;
	
}
function Curr3Print($lvl_amount,$usd_amount,$eur_amount){

 $str = "";
 if ($lvl_amount!=0) $str = CurrPrint($lvl_amount)." LVL";
 if ($usd_amount!=0) $str .= " ".CurrPrint($usd_amount)." USD";
 if ($eur_amount!=0) $str .= " ".CurrPrint($eur_amount)." EUR";
 if ($str == "") $str = "0.00";
 return $str;
}
function EuroRate()
{
	return 0.702804;
}

function EuroDate()
{
	return EUR_DATE;
}

//---------------------------------------
//funkcija r�da kop�jo summu latos vai eiro 
//atkar�b� no datuma (pirms vai p�c eiro ievie�anas)
//priek� USD tiek izmantots �odienas kurss
//---------------------------------------
function Curr2Total($lvl_amount,$eur_amount)
{
	$ret = 0;
	global $EUR_RATE;

	if (!IsEuro())
	{
		//pirms eiro �ra
		$total = GetNum($lvl_amount);
		$total = $total + GetNum($eur_amount) * $EUR_RATE;
		$ret = CurrPrint($total)." LVL <font color=#AAAAAA>(".CurrPrint($total/EuroRate())." EUR)</font>";
		return $ret;
	}
	else
	{
		//eiro �ra
		$total = GetNum($eur_amount);
		$total = $total + GetNum($lvl_amount) / $EUR_RATE;
		$ret = CurrPrint($total)." EUR <font color=#AAAAAA>(".CurrPrint($total*EuroRate())." LVL)</font>";
		return $ret;
	}
}

function Curr2TotalPlain($lvl_amount,$eur_amount)
{

	$ret = 0;
	if (!IsEuro())
	{
		//pirms eiro �ra
		$total = GetNum($lvl_amount);
		$total = $total + GetNum($eur_amount) * EuroRate();
		$ret = CurrPrint($total)." LVL (".CurrPrint($total/EuroRate())." EUR)";
		return $ret;
	}
	else
	{
		//eiro �ra
		$total = GetNum($eur_amount);
		$total = $total + GetNum($lvl_amount) / EuroRate();
		$ret = CurrPrint($total)." EUR (".CurrPrint($total*EuroRate())." LVL)";
		return $ret;
	}
}

//Personas koda valid�cija
function PkValid($pk) { 
//testam:
return true;
	$pk = trim(str_replace("-", "", $pk)); 
	if (!$pk || !strlen($pk)==11) return false;
	$checksum = 1;
	for ($i=0; $i<10; $i++) 
		$checksum -= (int)substr($pk, $i, 1) *(int)substr("01060307091005080402", $i*2,  2);
	//echo "checksum: $checksum";
	//($checksum - floor($checksum / 11)*11
	//$checksum%11
	if ( ($checksum - floor($checksum / 11)*11)!= (int)substr($pk, 10, 1) ) 
		return false; 
	return true; 
}


/**
 * Replaces special characters in a string with their "non-special" counterpart.
 *
 * Useful for friendly URLs.
 *
 * @access public
 * @param string
 * @return string
 */
function convertAccentsAndSpecialToNormal($string) {
       $table = array(
        'Ā' => 'A',
        'Č' => 'C',
        'Ē' => 'E',
        'Ģ' => 'G',
        'Ī' => 'I',
        'Ķ' => 'K',
        'Ļ' => 'L',
        'Ņ' => 'N',
        'Š' => 'S',
        'Ū' => 'U',
        'Ž' => 'Z',

        'ā' => 'a',
        'č' => 'c',
        'ē' => 'e',
        'ģ' => 'g',
        'ī' => 'i',
        'ķ' => 'k',
        'ļ' => 'l',
        'ņ' => 'n',
        'š' => 's',
        'ū' => 'u',
        'ž' => 'z'
    );

    $string = strtr($string, $table);

    $string = preg_replace("/[^\x9\xA\xD\x20-\x7F]/u", "", $string);
	
    return $string;
}
// dzimšanas datuma validācija
function ValidateBirthday($birth_array){
    $error_birth = array();

    if ($birth_array['day'] == 0){
        $error_birth[] = 'Dzimšanas diena nav norādīta';
    }

    if ($birth_array['month'] == 0){
        $error_birth[] = 'Dzimšanas mēnesis nav norādīts';
    }

    if ($birth_array['year'] == 0){
        $error_birth[] = 'Dzimšanas gads nav norādīts';
    }

    return $error_birth;
}
function SanitizeFilename($string){

    $string = str_replace('–','-',$string);

    // Remove special accented characters
    $clean_name = convertAccentsAndSpecialToNormal($string);

    $clean_name = strtr($clean_name, array(
        'Þ' => 'TH',
        'þ' => 'th',
        'Ð' => 'DH',
        'ð' => 'dh',
        'ß' => 'ss',
        'Œ' => 'OE',
        'œ' => 'oe',
        'Æ' => 'AE',
        'æ' => 'ae',
        'ü' => 'u'
    ));

    // visus tukšumus aizvieto ar _, vairākus punktus ar vienu punktu, punktu faila beigās ar _
    $clean_name = preg_replace(
        array('/\s/', '/\.[\.]+/', '/[^\w_\.\-]/', '/[\.]+$/m'),
        array('_', '.', '', '_'),
        $clean_name
    );

    return $clean_name;
}	
function StartsWith($haystack, $needle)
{
     $length = strlen($needle);
     return (substr($haystack, 0, $length) === $needle);
}

function Contains($string,$needle){
	if (strpos($string, $needle) !== false) {
		return true;
	}
	return false;
}

function GetKeysForDuplVal($my_arr, $clean = false) {
    if ($clean) {
        return array_unique($my_arr);
    }

    $dups = $new_arr = array();
	var_dump($my_arr);

    foreach ($my_arr as $key => $val) {
		
      if (!isset($new_arr[$val])) {
         $new_arr[$val] = $key;
      } else {
        if (isset($dups[$val])) {
           $dups[$val][] = $key;
        } else {
           $dups[$val] = array($key);
           // Comment out the previous line, and uncomment the following line to
           // include the initial key in the dups array.
           // $dups[$val] = array($new_arr[$val], $key);
        }
      }
    }
    return $dups;
}

// pārbauda, vai strings satur tikai latviešu alfabēta burtus un simbolus
function AllLVSymbols($string){
    $re = "/[^a-zA-ZāčēģīķļņšūžĀČĒĢĪĶĻŅŠŪŽ_\-0-9)(.,;:!?+=\/\"' -]/u";

    if (preg_match($re, $string)){
        return false;
    }
    else {
        return true;
    }
}
?>