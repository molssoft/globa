<?
function db_open(){
    global $conn;
    $conn = mssql_connect("192.168.1.100",'web','web777') or DIE("");
    mssql_select_db("globa") or DIE("DB unavailable");
    return $conn;
}

function db_execute($query){
    global $conn;
    mssql_query($query);
}

function db_select_array($query){
    $arr = array();
    global $conn;
    $result = mssql_query($query);
    $i=0;
    $j=0;
    $myarray = array();
    while ($myarray = mssql_fetch_array($result)){
        $arr[$i] = array();
        $k = array_keys($myarray);
        $j=0;
        while ($j<count($myarray)){
            $arr[$i][$k[$j]] = $myarray[$k[$j]];
            $j++;
        }
        $i++;
    };
    return $arr;
}

function db_select_row($query){
    global $conn;
    $result = mssql_query($query);
	return mssql_fetch_array($result);
}

function db_select_value($query){
    global $conn;
    $result = mssql_query($query);
	if ($a = mssql_fetch_array($result))
		return $a[0];
}

function db_select_result($query){
    global $conn;
	return mssql_query($query);
}

?>