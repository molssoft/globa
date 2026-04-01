<?
require_once("i_functions.php");
require_once("i_decode.php");
Docstart ("Valstis","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<!--Rg 14.06.2020 Datatable stili no https://datatables.net-->
<script scr="https://code.jquery.com/jquery-3.5.1.js"></script>
<link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">
<script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>


<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Valstis</b></font><hr>

<?
// standarta saites 
 
Headlinks();
?>
	<table id="tblValstis" class="table" style="border-spacing:2px">
	<thead>
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Slug</th>
		<th>Meta apraksts</th>
		<th>Aktîvas grupas</th>
        <th></th>
	</tr>
	</thead>
	<tbody>
	<?
	foreach($data as $valsts){?>
		<tr style="background-color:#fff1cc" class="clickable-row" data-href="c_valstis.php?f=editValstisView&id=<?= $valsts["id"]?>" id="row_<?= $valsts["id"]?>">
			<td width=1 name="id"><?= $valsts["ID"]?></td>
			<td name="slug"><?= Decode($valsts["slug"])?></td>
			<td name="meta_desc"><?= Decode($valsts["meta_desc"])?></td>
			<td name="aktivi"><? if($valsts["aktivi"] > 0){echo $valsts["aktivi"];}?></td>
            <td><a href="c_valstis.php?f=edit&id=<?= $valsts["ID"]?>">Labot</a></td>
	</tr><?}?>
	</tbody>
</table>

<style>
table {
	margin-top: 1%;
}
.clickable-row {
	cursor: pointer;
}
</style>
