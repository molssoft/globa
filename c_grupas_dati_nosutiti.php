<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
$db = New Db();
require_once($_SESSION['path_to_files']."m_grupas_dati_nosutiti.php");
$gr_d_nos = new GrupasDatiNosutiti();

require_once($_SESSION['path_to_files']."m_grupa.php");
$gr = new Grupa();

/*$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'meklet';
if ($function == 'neapmaksatas') Neapmaksatas();
if ($function == 'dzest') Dzest();
*/
$gid = (int)$_GET['gid'];
$pid = (int)$_GET['pid'];
if ($gid<=0 and $pid<=0){
	
	
	die('Nav norâdîts grupas vai pietiekuma Nr.');
}
if ($gid){
	$grupas_nos = $gr->GetFullNosaukums($gid);
	//var_dump($_POST);
	if (isset($_POST['save'])){
		$data = $db->EscapeValues($_POST,'sanemejs');
		$data['pievienoja_lietotajs'] = $db->GetUser();
		$data['pievienoja_datums'] = date("Y-m-d H:i:s");
		$data['gid'] = $gid;
		//var_dump($data);
		$gr_d_nos->Insert($data);
		
		
		
	}
	//

	$data['data'] = $gr_d_nos->GetGid($gid);
	$data['grupas_nos'] = "Grupas <br>".$grupas_nos." dati";

}
//komplekasiejm un individuâlajiem pakalpjumaime
elseif ($pid){
		if (isset($_POST['save'])){
		$data = $db->EscapeValues($_POST,'sanemejs');
		$data['pievienoja_lietotajs'] = $db->GetUser();
		$data['pievienoja_datums'] = date("Y-m-d H:i:s");
		$data['pid'] = $pid;
		//var_dump($data);
		$gr_d_nos->Insert($data);
		
		
		
	}
	//
	require_once($_SESSION['path_to_files']."m_pieteikums.php");
	$piet = new Pieteikums();
	$data['dalibn'] = $piet->GetDalibnPid($pid);
	//var_dump($data['dalibn']);
	$data['data'] = $gr_d_nos->GetPid($pid);
	$data['grupas_nos'] = "Pieteikuma <a href='pieteikums.asp?pid=$pid'>Nr.".$pid. "</a><br> dati par klientu <a href='dalibn.asp?i=".$data['dalibn']['id']."'>".$data['dalibn']['vards']." ".$data['dalibn']['uzvards']."</a>";
}
	include_once("v_grupas_dati_nosutiti.php");
//var_dump($data);




	
?>