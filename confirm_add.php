<?
$connection = odbc_connect ("globa", "", "");
?>

$result = odbc_exec($connection,"select id,kods from email_list where email = '$email'");
if (odbc_fetch_row($result,1))
{
 $id = odbc_result($result,1);
 $kods = odbc_result($result,2);
 mail($email,"Apstipriniet parakstisanos uz IMPRO zinam.", "Lai apstiprinatu parakstisanos uz IMPRO zinam noklikskiniet uz so saiti:\nwww.impro.lv?id=$id&kods=$kods");
}

Adrese veiksmîgi pievienota. Jûs saòemsiet ziòojumu uz savu e-pastu, kurâ bûs doti turpmâkie norâdîjumi.