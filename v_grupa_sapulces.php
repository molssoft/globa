<?require_once("i_functions_utf.php");
// Grupas ar nākotnes sapulces datumu un laiku
Docstart ("Grupu sapulces","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Grupu sapulces</b></font><hr>

<?
Headlinks();
?>
<br>
<div align="center">
<form name="forma" method="POST">
<center>
<table border="0" cellpadding=2>
    <tr bgcolor="#ffc1cc">
        <th>Sapulces <BR>datums</th>
        <th>Sapulces <BR>laiks</th>
        <th>Kods</th>
        <th>Maršruts</th>
    </tr>
    <?foreach($data as $d){?>
    <tr bgcolor="#fff1cc" height="25">
        <td><?=!empty($d['sapulces_dat']) ? $db->Date2Str($d['sapulces_dat']) : '&nbsp;'?></td>
        <td><?=!empty($d['sapulces_laiks_no']) ? $db->Time2Str($d['sapulces_laiks_no']) : '&nbsp;'?></td>
        <td><?=htmlspecialchars($d['kods'] ?? '')?></td>
        <td><?=htmlspecialchars(_utf($d['v']) ?? '')?></td>
    </tr><?}?>
</table>
</form>
</div>
<style>
table {
	border-spacing: 0em 0.2em;
	border-collapse: separate;
}
</style>
