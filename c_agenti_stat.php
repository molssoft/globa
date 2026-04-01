<?session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_agenti.php");
require_once("online2/m_tiesibas.php");



$db = New Db();
$tiesibas = new Tiesibas();

$function = $_GET["f"];

if(!isset($_GET["f"])) $function = "index";
if($function == "index") Index();
if($function == "stat2") Stat2();

function Index() {
	global $db;
	global $tiesibas;
	require_once("online2/i_functions.php");
	$agenti = new Agenti();
	
	$data['agents'] = $_POST['agents'];
	$data['grupa_no'] = $_POST['grupa_no'];
	$data['grupa_lidz'] = $_POST['grupa_lidz'];
	$data['zilie'] = $_POST['zilie'];
	//$data['data'] = $agenti->GetStatLimited($data['agents'],$data['grupa_no'],$data['grupa_lidz'],$data['zilie']);//todo - select records
	//$qc = $data['data']['recordCount'];
	//$data['result_count'] = Galotne($qc,"Atrasta","Atrastas"). " ".$qc." ".Galotne($qc,"operâcija","operâcijas");
		

	$data['agenti'] = $agenti->GetActive();
	if (isset($_POST['submit'])){
		$currPage = ($_GET["pg"])?$_GET["pg"]:1;
		$limit=300;
		$data['data'] = $agenti->GetStatLimited($data['agents'],$data['grupa_no'],$data['grupa_lidz'],$data['zilie'],false,$currPage,$limit);
		require_once($_SESSION['path_to_files']."l_pagination.php");
		$pagination = new Pagination($data['data']['rowcount'] , $limit, $currPage);
	}
	require_once("views/agenti_stat/v_agenti_stat.php");
}

function Stat2(){
	global $tiesibas;
	if (!($tiesibas->IsAccess(T_GRAMATVEDIS) or $tiesibas->IsAccess(T_LIETOT_ADMIN))){
		exit('Jums nav pieejas tiesîbu ðai lapai');
	}
	global $db;
	require_once("online2/i_functions.php");
	$agenti = new Agenti();
	$data['agents'] = $_POST['agents'];
		$data['no'] = $_POST['no'];
		$data['lidz'] = $_POST['lidz'];
		$data['orderfield'] = $_POST['sortby'];
	if (isset($_POST['submit'])){
		
		$currPage = ($_GET["pg"])?$_GET["pg"]:1;
		$limit=300;
		$data['data'] = $agenti->GetStatLimited($data['agents'],$data['no'],$data['lidz'],'visizilie',$data['orderfield'],$currPage,$limit);
		require_once($_SESSION['path_to_files']."l_pagination.php");
		$pagination = new Pagination($data['data']['rowcount'] , $limit, $currPage);
	}
	$data['agenti'] = $agenti->GetActive();
	require_once("views/agenti_stat/v_agenti_stat2.php");
}



?>