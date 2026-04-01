<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_grupa.php");


$db = New Db();
$gr = new Grupa();

if (isset($_POST['subm'])){
	$dalibn = $db->GetPost('dalibn');
	if ($dalibn){
		$qry = "SELECT DISTINCT eadr FROM dalibn WHERE id in (".implode(",",$dalibn).")
		and 
		eadr like '%@%'";		
		
		$result = $db->Query($qry);
		$i=1;
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			if ($i>1)
				echo ", ";
			echo $row['eadr'];
			$i++;
		}
	}
}
else{
	
	$gid = $_GET['gid'];
	if (!empty($gid)){
		$data['grupa'] = $gr->GetFullNosaukums($gid);
		$data['dalibn'] = $gr->GetDalibnList($gid);
		require_once("v_grupa_email.php");
	}
	else{
		exit('Nav norâdîts grupas ID#');
	}
}

?>