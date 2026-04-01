<?
$connection = odbc_connect ("globa", "", "");
$result = odbc_exec($connection,"select * from email_history where id = $id");
if ($result) echo "Result OK<br>";
echo "<table border=1>";
for ($i=1;odbc_fetch_row($result,$i);$i++)
{
	odbc_fetch_into($result,&$my_array);
	echo "<tr><td>$my_array[0]</td><td>$my_array[1]</td></tr>";
} 
echo "</table>";
?>
