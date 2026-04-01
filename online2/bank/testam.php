<?
	require_once('../m_init.php');
	$db = new Db;
	$output='22';
	$qry = "{call testproc_with_transaction (1,?)}";
	
	$params  = array($output, SQLSRV_PARAM_OUT);
	$result = $db->Query($qry,$params);
	echo '<br>output:';
		var_dump($output);
	/*var_dump($result);
	while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
		 var_dump($row['str_ord_str']);
		}
		echo '<br>output:';*/
		 $data = array();
    while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
        $data[] = $row;
    }
	sqlsrv_next_result($result);
	var_dump($data);
	echo '<br>output:';
		var_dump($output);
		
?>