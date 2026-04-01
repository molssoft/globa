<?php

require_once 'E:\globa\wwwroot\online2\bank\vendor\autoload.php';

use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;
use Symfony\Component\Serializer\Encoder\XmlEncoder;
use Symfony\Component\PropertyInfo\Extractor\ReflectionExtractor;

// Create the XML encoder with root attributes
$xmlEncoder = new XmlEncoder([
    'xml_root_node_name' => 'FIDAVISTA', // equivalent to 'rootName' in your old code
    'xml_encoding' => 'UTF-8',           // equivalent to 'encoding'
    'xml_format_output' => true,         // formatted XML
    'xml_standalone' => true,            // equivalent to 'addDecl' => true
    'xml_root_attributes' => [           // equivalent to 'rootAttributes'
        'xmlns' => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1 http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1/fidavista.xsd'
    ],
]);

// Create a normalizer to handle objects
$normalizer = new ObjectNormalizer(null, null, null, new ReflectionExtractor());

// Initialize the Serializer with the normalizer and the XML encoder
$serializer = new Serializer([$normalizer], [$xmlEncoder]);


require_once '../third_party/xmlseclibs.php';
//require_once '../third_party/XML/Serializer.php';
//require_once '../third_party/XML/Unserializer.php';

//require_once('inc/php_functions.php');

//šim failam jābut utf8 kodējumā!!!
//pēc datu posta no asp faila latviešu garumzīmes pazūd, tāpēc postējot simboli tiek aizvietoti ar #simbols

// todo change back to html
file_put_contents("log\post.txt",date("Y-m-d H:i:s")." POST CITADELE ".print_r($_POST,true)."\r\n\r\n",FILE_APPEND);


foreach ($_POST as $key => $value){

		$$key = uncode_latvian_special_chars_utf8($value);       
		//$$key = $value;       
}
$descr = str_replace("_", ".", $descr); //aizvieto neatlautos simbolus

/*print_r($_POST);
print_r("<br><br>".$descr);
die();
*/
//echo "<br>Lūdzu uzgaidiet...<br>";

//Generate PDF
//connect_to_mssql();
//--- izmaiņas 19.dec 2012. katru reizi ģenerēt līgumu nevajag. tikai pirmo reizi.
/*$ligums = get_ligums($rez_id);
if(is_array($ligums)){
	require_once('inc/generate_ligums.php');
	$avanss = $ligums['avanss'];
	$pdf_content = generate_ligums($rez_id, 'official', $avanss);
	$data = unpack("H*hex", $pdf_content);
	mssql_query("UPDATE [ligumi] SET bpdf = 0x{$data['hex']} WHERE [rez_id] = $rez_id AND deleted = 0");
}
*/
//$rez_id = $_POST["rez_id"];
//$summa = $_POST["summa"];
//$descr = "test 12345"; //$_POST["descr"];

//AI
session_save_path('../tmp/');
session_start();

$x = new CitadeleDigiLink(false);
$x->php_session_id = session_id();
$y = $x->start($summa, $descr, $rez_id, $trans_uid);
//AI

//before AI $x = new CitadeleDigiLink(false);
//before AI $y = $x->start($summa, $descr, $rez_id, $trans_uid);

//print_r($y["xmldata"]);

//die($y["xmldata"]); //DEBUG
//header("content-type: text/xml");
//die($y["xmldata"]);

$xml = $y["xmldata"];
header("content-type: text/html; charset=UTF-8");

// tie tagi sheit bija
?>
<html>
<body>
<form name="hbpost" method="POST" action = "<? echo $x->url; ?>">
	<input id="xmldata" type="hidden" name="xmldata" value="<? echo $xml; ?>">
	<!--input type="submit">-->
</form>
<script>document.hbpost.submit();</script>

<?

echo $xml;


//------------------------------------------------------------------------------------------------------

/**
 * Citadele DIGI=Link pieslēguma datu apmaiņas nodrošināšana.
 * Pirkuma sagatavošana, parakstīšana, validēšana.
 * 
 * @uses XML/Serializer.php http://pear.php.net/package/XML_Serializer (pear install XML_Serializer)
 * @uses XML/Unserializer.php http://pear.php.net/package/XML_Serializer
 * @uses xmlseclibs.php http://code.google.com/p/xmlseclibs/
 */
class CitadeleDigiLink
{
	public $php_session_id = null;
   /**
    * Arējai sistēmai piešķirtais kontrakta identifikators.
    */
   const c_from        = '10036';

   /**
    * Saņēmēja konta numurs. Latvijas IBAN formātā
    */
   const ben_acc_no    = 'LV78PARX0006019220002';

   /**
    * Saņēmēja nosaukums. Atļautie simboli: A-Z| a-z| Ā-Ž | ā-ž |0-9|()+. /:-’,
    */
   const ben_name      = 'IMPRO CEĻOJUMI SIA';

   /**
    * Saņēmēja reģistrācijas numurs vai nodokļu maksātāja kods. Atļautie simboli: A-Z| a-z| 0-9|()+. /:-’,”& Maksimālais garums: 13
    */
   const ben_legal_id  = 'LV40003235627';

   /**
    * Valsts kods, kurā reģistrēts saņēmējs. Vērtība=LV
    */
   const ben_country   = 'LV';

   /**
    * Produkcijas vides url
    */
   const production_url= 'https://online.citadele.lv/amai/start.htm';

   /**
    * Testēšanas url
    */
   const testing_url   = 'https://astra.parex.lv/amai/start.htm';

   /**
    * Valūta
    *
    * @var string
    */
   private $currency = 'EUR'; //'LVL';

   /**
    * Atbildes url
    *
    * @var string
    */
   private $return_url = 'https://www.impro.lv/online/bank/get_citadele.php';
   //private $return_url = 'test_url';
   /**
    * ceļš līdz privātajai atslēgai
    */
   private $private_key = 'e:\\globa\\wwwroot\\online2\\bank\\citadele\\private_key.pem';

   /**
    * ceļš līdz publiskajai atslēgai / sertifikātam
    */
   //private $public_cert  = 'e:\\globa\\wwwroot\\online2\\bank\\citadele\\PublicKey.crt'; //impro_x509.cer //impro_x509.cer //pub_key.pem //selfcert.pem
   private $public_cert  = 'e:\\globa\\wwwroot\\online2\\bank\\citadele\\sendMeToCitadeleCert.pem'; //impro_x509.cer //impro_x509.cer //pub_key.pem //selfcert.pem

   /**
    * citadele sertifikāts
    * netiek lietots, jo tiek padots kopā ar datiem
    */
   private $ssl_public_cert = 'DIGILINK_CITADELE_TEST.cer';

   /**
    * citadele url uz kuru tiek sūtīts pieprasījums
    */
   public $url = '';

   var $db;
   /**
    * inicializējam klasi
    *
    * @param bool $test
    */
   function __construct($test = true){
      $this->url = $test ? self::testing_url : self::production_url;
	  $dont_init_header = true;
	  require_once('../m_init.php');
		$this->db = new Db;
   }

   /**
    * Starts citadele transaction
    * 
    * @param float $amount transaction amount
    * @param string $description transaction description
    * @return array data for request <form> <input type=hidden > element
    */
   function start($amount, $description = null, $rez_id, $trans_uid){
	
      $this->trans_id = substr(uniqid(), 0, 10); 
	  //$this->trans_uid = $trans_uid; //--- dalita maksajuma trans_id
 
      $xml = $this->createPaymentXml($amount, $description);   


	  //header("content-type: text/xml");die($xml); //DEBUG
	  $xml = $this->sign($xml);                                
	  //header("content-type: text/xml");die($xml); //DEBUG

      $this->log($this->trans_id, $rez_id, $amount, $description, $xml, $trans_uid);

      if($this->verify($xml)){
		
		// todo change back
		return array('xmldata' => str_replace('"', '&quot;', $xml));// prepare data for HTTP POST Form; remove quotes
		//return array('xmldata' => $xml);
      }
      
      /**
       * @todo handle error
       */
      die('error signing data');
   }

   /**
    * Create clean payment xml. Must sign after.
    *
    * @param float $amount
    * @param string $description optional
    * @return xml
    */
   function createPaymentXml($amount, $description = null, $language = 'LV'){
      $digilink_params = array(
          'Header' => array(
             'Timestamp' => substr(date('YmdHisu'), 0, 17), //Sagatavošanas datums un laiks formātā YYYYMMDDHHMMSSsss.
             'From'      => self::c_from,                   //Arējai sistēmai piešķirtais kontrakta identifikators.
             'Extension' => array(
                'Amai' => array(
                   'Request'       => 'PMTREQ',          //Pieprasījums. Vērtība: PMTREQ
                   'RequestUID'    => $this->trans_id,   //Pieprasījuma unikāls identifikators.
                   'Version'       => '1.0',             //Versija. Vērtība=1.0
                   'Language'      => $language,         //Valoda. Iespējamas vērtības: LV, RU, EN.
                   'ReturnURL'     => $this->return_url, //Atgriešanas URL. Tiek izmantots, lai atgrieztos uz Ārējās sistēmas portāla lapu.
                   'SignatureData' => ''                 //Tiks aizpildīts parakstot
                )
             )
          ),
          'PaymentRequest' => array(                     //Maksājuma dati
             'ExtId'     => $this->trans_id,               //Maksājuma unikāls identifikators Ārējā sistēmā.
             'DocNo'     => $this->trans_id,             //Maksājuma numurs.
             'TaxPmtFlg' => 'N',                         //Pazīme par to vai maksājums ir vai nav nodokļu maksājums. Vērtība=N
             'Ccy'       => $this->currency,             //Maksājuma valūta. LVL | EUR
             'PmtInfo'   => $description,                //Maksājuma detaļas (informācija saņēmējam). Obligāts lauks. Atļautie simboli: A-Z| a-z| Ā-Ž | ā-ž |0-9|()+. /:-’,
             'BenSet' => array(                          //Maksājuma saņēmēja dati.
                'Priority'   => 'N',                     //Maksājuma prioritāte. Vērtība=N
                'Comm'       => 'OUR',                   //Komisijas tips. Vērtība=OUR
                'Amt'        => sprintf('%0.2f', str_replace(',', '.', $amount)), //Maksājuma summa. <= 50 000
                'BenAccNo'   => self::ben_acc_no,        //Saņēmēja konta numurs. Latvijas IBAN formātā
                'BenName'    => self::ben_name,          //Saņēmēja nosaukums. Atļautie simboli: A-Z| a-z| Ā-Ž | ā-ž |0-9|()+. /:-’,
                'BenLegalId' => self::ben_legal_id,      //Saņēmēja reģistrācijas numurs vai nodokļu maksātāja kods. Atļautie simboli: A-Z| a-z| 0-9|()+. /:-’,”& Maksimālais garums: 13
                'BenCountry' => self::ben_country        //Valsts kods, kurā reģistrēts saņēmējs. Vērtība=LV
              )
           )
      );

      // Instantiate the serializer
	  /*
      $serializer = new XML_Serializer(array(
         'addDecl'         => true,
         'encoding'        => 'UTF-8',
         'rootName'        => 'FIDAVISTA',
         'attributesArray' => '_attributes',
          //XML_SERIALIZER_OPTION_INDENT        => '    ',//for debugging
         'rootAttributes'  => array(
            'xmlns'              => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1',
            'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
            'xsi:schemaLocation' => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1 http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1/fidavista.xsd'
         )
      ));
		*/
      
	  //$serializer->serialize($digilink_params);
      //$xml = $serializer->getSerializedData();
	  global $serializer;
	  
	  // Define context options including root attributes and other XML settings
		$context = [
			XmlEncoder::ROOT_NODE_NAME => 'FIDAVISTA', // Root element name
			'xml_encoding' => 'UTF-8',  // Set encoding
			'xml_format_output' => true, // Pretty print the XML
			'xml_standalone' => true,    // Add standalone declaration
			'xml_root_attributes' => [   // Root attributes for the XML document
				'xmlns' => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-2',
				'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
				'xsi:schemaLocation' => 'http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-1 http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista.xsd'
			],
		];
	  
	  //$xml = $serializer->serialize($digilink_params, 'xml');  
	  

	  $xml = $serializer->encode($data, 'xml', $context);
	  
	  
	  $xml = $serializer->encode($digilink_params, 'xml', $context);
	  
	  
	  $full_fida = "<FIDAVISTA xmlns='http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-2'
           xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
           xsi:schemaLocation='http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-2 http://ivis.eps.gov.lv/XMLSchemas/100017/fidavista/v1-2/fidavista.xsd'>";
	  $xml = str_replace("<FIDAVISTA>",$full_fida,$xml);
	  
	  $full_amai = "<Amai xmlns='http://online.citadele.lv/XMLSchemas/amai/'
						xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
						 xsi:schemaLocation='http://online.citadele.lv/XMLSchemas/amai/
						http://online.citadele.lv/XMLSchemas/amai/amai.xsd'>";
	  $xml = str_replace("<Amai>",$full_amai,$xml);
	  
		 
	  return $xml;
      //return str_replace(array("\n", "\t", "\r", "\r\n"), '', trim($xml)); // clean xml
   }

   /**
    * Sign xml data and return signed xml
    *
    * @param xml $xml
    * @return xml
    */
   function sign($xml){
      $doc = new DOMDocument();
      $doc->loadXML($xml);

      $objDSig = new XMLSecurityDSig();

      $objDSig->setCanonicalMethod(XMLSecurityDSig::EXC_C14N);
      //$objDSig->setCanonicalMethod(XMLSecurityDSig::C14N);//vajag būt, bet ar šo nesanāk validēt

      $objDSig->addReference($doc, XMLSecurityDSig::SHA1, array('http://www.w3.org/2000/09/xmldsig#enveloped-signature'), array('force_uri' => true));

	  

	  $objKey = new XMLSecurityKey(XMLSecurityKey::RSA_SHA1, array('type'=>'private'));
	  $objKey->passphrase = "ms410a";
	  $objKey->loadKey($this->private_key, TRUE);

      $objDSig->sign($objKey);
      
	  $objDSig->add509Cert(file_get_contents($this->public_cert));

	  $appendSignatureTo = $doc->getElementsByTagName('SignatureData')->item(0);
	  
	  $objDSig->appendSignature($appendSignatureTo);

      return $doc->saveXML();

   }

   /**
    * Verify xml request
    *
    * @param xml $xml
    * @return bool
    */
   function verify($xml){
      $doc = new DOMDocument();
      $doc->loadXML($xml);
      $objXMLSecDSig = new XMLSecurityDSig();

      if(!$objDSig = $objXMLSecDSig->locateSignature($doc)){
         throw new Exception("Cannot locate Signature Node");
      }
      $objXMLSecDSig->canonicalizeSignedInfo();
      $objXMLSecDSig->idKeys = array('wsu:Id');
      $objXMLSecDSig->idNS   = array('wsu'=>'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd');

      if(!$retVal = $objXMLSecDSig->validateReference()){
         throw new Exception("Reference Validation Failed");
      }

      if(!$objKey = $objXMLSecDSig->locateKey()){
         throw new Exception("We have no idea about the key");
      }
      $key = NULL;


	  //print_r($objKey);

      $objKeyInfo = XMLSecEnc::staticLocateKeyInfo($objKey, $objDSig);

	  //echo "<br>so far.. <br>";

      // ja nav norādīta atslēga, tad norāda to. šajā gadījumā nav vajadzīgs, jo tiek norādīta xml`ā
      //if(!$objKeyInfo->key && empty($key)){
      //  $objKey->loadKey($this->public_cert, TRUE);
      //}

      return $objXMLSecDSig->verify($objKey);
   }


   /**
    * Translates xml response into mixed array
    *
    * @param xml string $response
    * @return array
    */
   public function xmlToArray($serializer, $response){
	   

      //$unserializer = new XML_Unserializer();
      //$status = $unserializer->unserialize($response);

	  return $serializer->deserialize($response, 'array', 'xml');

      /*
	  if(PEAR::isError($status)){
         //$status->getMessage(); //error message
         return false;
      }
      return $serializer->deserialize();
	  */
   }

   /**
    * Log text to ...
    *
    * @todo make logging
    * @param string $text
    */
   function log($p_trans_id, $p_rez_id, $p_amount, $p_description, $p_xml, $trans_uid) {
	   
		//AI
		$php_sid = (isset($this->php_session_id) && $this->php_session_id !== '') ? "'" . $this->db->MsEscapeString($this->php_session_id) . "'" : "NULL";
		$ssql = "INSERT INTO trans_citadele(RequestUID,rez_id,summa,descr,xml_body,trans_uid,php_session_id) VALUES('$p_trans_id',$p_rez_id,$p_amount,'$p_description','$p_xml','$trans_uid',$php_sid)";
		$this->db->Query($ssql);
		//AI

		//$ssql = "INSERT INTO trans_citadele(RequestUID,rez_id,summa,descr,xml_body,trans_uid) VALUES('$p_trans_id',$p_rez_id,$p_amount,'$p_description','$p_xml','$trans_uid')";
		//$this->db->Query($ssql);
		
   }
}

function uncode_latvian_special_chars_utf8($string) {
	$search = array();
	$replace = array();
	$search[] = '#a';
	$replace[]  = 'ā';
	$search[] = '#c';
	$replace[]  = 'č';
	$search[] = '#e';
	$replace[]  = 'ē';
	$search[] = '#g';
	$replace[]  = 'ģ';
	$search[] = '#i';
	$replace[]  = 'ī';
	$search[] = '#k';
	$replace[]  = 'ķ';
	$search[] = '#l';
	$replace[]  = 'ļ';
	$search[] = '#n';
	$replace[]  = 'ņ';
	$search[] = '#s';
	$replace[]  = 'š';
	$search[] = '#u';
	$replace[]  = 'ū';
	$search[] = '#z';
	$replace[]  = 'ž';
	$search[] = '#A';
	$replace[]  = 'Ā';
	$search[] = '#C';
	$replace[]  = 'Č';
	$search[] = '#E';
	$replace[]  = 'Ē';
	$search[] = '#G';
	$replace[]  = 'Ģ';
	$search[] = '#I';
	$replace[]  = 'Ī';
	$search[] = '#K';
	$replace[]  = 'Ķ';
	$search[] = '#L';
	$replace[]  = 'Ļ';
	$search[] = '#N';
	$replace[]  = 'Ņ';
	$search[] = '#S';
	$replace[]  = 'Š';
	$search[] = '#U';
	$replace[]  = 'Ū';
	$search[] = '#Z';
	$replace[]  = 'Ž';

	return str_replace($search, $replace, $string);
}

?>

