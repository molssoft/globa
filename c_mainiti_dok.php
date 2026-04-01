<?

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

 
if (isset($_POST['submit'])){
	$error = array();
	//var_dump($_POST);
	$did = (int)$_POST['did'];
	$pid = (int)$_POST['pid'];
	//aizstât ar jauno
	if ($_POST['aizstat_ar'] == 'pid'){
		//update dalibnieks
		$pieteikums = $piet->GetId($pid);
		$dalibnieks = $dalibn->GetId($did);
	//	echo "pieteikums:<br>";
		//var_dump($pieteikums);
		//echo "<br><br>";
		$paseS = (empty($pieteikums['paseS']) ? $dalibnieks['paseS'] : $pieteikums['paseS']);
		$paseNR = (empty($pieteikums['paseNR']) ? $dalibnieks['paseNR'] : $pieteikums['paseNR']);
		$paseDERdat = (empty($pieteikums['paseDERdat']) ? $dalibnieks['paseDERdat'] : $pieteikums['paseDERdat']);
		$idS = (empty($pieteikums['idS']) ? $dalibnieks['idS'] : $pieteikums['idS']);
		$idNR = (empty($pieteikums['idNR']) ? $dalibnieks['idNR'] : $pieteikums['idNR']);
		$idDerDat = (empty($pieteikums['idDerDat']) ? $dalibnieks['idDerDat'] : $pieteikums['idDerDat']);
		/*$upd_array = array('paseS' => $paseS,
							'paseNR' => $paseNR,
							'paseDERdat' => $paseDERdat,
							'idS' => $idS,
							'idNR' => $idNR,
							'idDerDat' => $idDerDat,
						);
		$dalibn->Update($upd_array,$did);*/
	}
	//aizstât ar VECO
	elseif($_POST['aizstat_ar'] == 'did'){
		//update pieteikums
		$dalibnieks = $dalibn->GetId($did);
		//echo "pieteikums:<br>";
		//var_dump($pieteikums);
		//echo "<br><br>";
		$paseS = (!empty($dalibnieks['paseS']) ? $dalibnieks['paseS'] : $pieteikums['paseS']);
		$paseNR = (!empty($dalibnieks['paseNR']) ? $dalibnieks['paseNR'] : $pieteikums['paseNR']);
		$paseDERdat = (!empty($dalibnieks['paseDERdat']) ? $dalibnieks['paseDERdat'] : $pieteikums['paseDERdat']);
		$idS = (!empty($dalibnieks['idS']) ? $dalibnieks['idS'] : $pieteikums['idS']);
		$idNR = (!empty($dalibnieks['idNR']) ? $dalibnieks['idNR'] : $pieteikums['idNR']);
		$idDerDat = (!empty($dalibnieks['idDerDat']) ? $dalibnieks['idDerDat'] : $pieteikums['idDerDat']);
		
	}
	$upd_array = array('paseS' => $paseS,
							'paseNR' => $paseNR,
							'paseDERdat' => $paseDERdat,
							'idS' => $idS,
							'idNR' => $idNR,
							'idDerDat' => $idDerDat,
						);
	$dalibn->Update($upd_array,$did);
	
	$piet->Update($upd_array,$pid);
	$_SESSION['msg'] = "Dati veiksmîgi aizstâti";
	
	
	
}
//atrodam visus dalîbniekus, kam pieteikuma dokumentu dati nesakrît ar dalîbnieka dokumentu datiem

$data['pieteikumi'] = $dalibn->GetMainitiDok();

include_once("v_mainiti_dok.php") ;


?>



