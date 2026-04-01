<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
$db = New Db();
require_once($_SESSION['path_to_files']."m_online_rez.php");
$online_rez = new OnlineRez();

/*$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'meklet';
if ($function == 'neapmaksatas') Neapmaksatas();
if ($function == 'dzest') Dzest();
*/
if (isset($_POST['delete_id'])){
	//dzçð rezervâciju
	$db->Update('online_rez',array('no_delete'=>0),(int)$_POST['delete_id']);
	
	$online_rez->Delete((int)$_POST['delete_id']);
		
	$data['script'] = "<script>alert('Rezervâcija ir izdzçsta!');</script>";
	
}

//râda online rezervâcijas, kurâm ir uzstâdîts no_delete, bet nav izveidojuðies orderi (SEB kïûdainâs, kam nepienâk 0004 statuss)
$data['neapmaksatas'] = $online_rez->GetNeapmaksatas();
//var_dump($data);
include_once("v_online_rez_neapmaksatas.php");



	
?>