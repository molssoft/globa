<? 
 
 
$link = mssql_connect('SER-DB', 'www', 'www');
if (!$link) {
	die(1);
}

$db_selected = mssql_select_db('globa', $link);
if (!$db_selected) {
	die (2);
}
///phpinfo();
$r = mssql_query("select min(id) as x  from ligumi where file_name is null");
$m = mssql_fetch_array($r);
$id = $m['x'];

$r = mssql_query("select datalength(bpdf) as size,bpdf from ligumi where id = $id");
$m = mssql_fetch_array($r);
$size = $m['size'];
$bpdf = $m['bpdf'];

if (!$size)
{
	mssql_query("update ligumi set file_name = '' where id = $id");
	echo $id . ' no binary data';
}
else 
{
	$thousands = floor($id/1000)+1;
	//$dir  = '\\\\ser-db3\\e$\\pdf-ligumi\\'.$thousands;
	$dir  = $thousands;
	mkdir($dir);
	$file_name = $dir . '\\'. $id . '-' . random_str(10) . '.pdf';
	$file = fopen('\\\\ser-db3\\e$\\pdf-ligumi\\'.$file_name, 'wb');
	// Create File
	fwrite($file, $bpdf);
	fclose($file);

	echo $id;
	//mssql_query("update ligumi set file_name = '$file_name',bpdf=null where id = $id");
}

?>
<html>
<head>
<meta http-equiv="refresh" content="0">
</head>
</body>
</body>
<?


function make_seed()
{
  list($usec, $sec) = explode(' ', microtime());
  return (float) $sec + ((float) $usec * 100000);
}

function random_str($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyz')
{
    $str = '';
    $max = mb_strlen($keyspace, '8bit') - 1;
    for ($i = 0; $i < $length; ++$i) {
		srand(make_seed());
        $str .= $keyspace[rand(0, $max)];
    }
    return $str;
}


?>

