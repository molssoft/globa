<?
	require_once($path.'../m_init.php');
	$db = new Db;	
	$trans = $db->Query("INSERT INTO swedbank_trans (rez_id,description,status) VALUES (?,?,?) ",
		[
			0
			,$_SERVER['QUERY_STRING']
			,'notify'
		]
	);
?>