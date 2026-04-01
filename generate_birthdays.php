<?
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");


require_once("online2/m_dalibn.php");

$db = New Db();
$dalibn = new Dalibn();

$id_from = 13000;
$id_to = $id_from+2000;
$qry = "SELECT * FROM dalibn where ID>=$id_from AND ID<$id_to  AND deleted=0 AND pk1 IS NOT NULL  AND dzimsanas_datums is null";
$result = $db->Query($qry);
while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
	$did = $row['ID'];
	//echo $did;
	//echo $row['vards'].' '.$row['uzvards'].': '.$row['pk1'];
	$birthday = $dalibn->Birthday($did);
	//echo " >>>> ";
	//echo $db->Date2Str($birthday);
	//echo "<br>";
	if ($birthday){
		$dalibn->Update(array('dzimsanas_datums'=>$birthday),$did);
	}
	
	
}
echo "done";

?>