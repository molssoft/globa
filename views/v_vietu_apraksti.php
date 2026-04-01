<?
require_once("i_functions.php");
require_once("i_decode.php");
Docstart ("Vietu apraksti","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<!--Rg 14.06.2020 Datatable stili no https://datatables.net-->
<script scr="https://code.jquery.com/jquery-3.5.1.js"></script>
<link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">
<script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>


<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Vietu apraksti</b></font><hr>

<?
// standarta saites 
 
Headlinks();
?>
<div style="margin-bottom:10px">
	<br>
	<a class="btn btn-success" href="c_vietu_apraksti.php?f=add">Pievienot jaunu</a>
</div>
	<table id="tblVietuApraksti" class="table" style="border-spacing:2px">
	<thead>
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th style="width:35%">Nosaukums</th>
		<th style="width:50%">Apraksts</th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<?
	foreach($data as $row){
		$id = (isset($row["ID"]) ? $row["ID"] : (isset($row["id"]) ? $row["id"] : ""));
		$nameKey = (isset($row["nosaukums"]) ? "nosaukums" : (isset($row["title"]) ? "title" : (isset($row["name"]) ? "name" : (isset($row["slug"]) ? "slug" : ""))));
		$nameVal = ($nameKey!="" ? Decode($row[$nameKey]) : "");
	?>
		<tr style="background-color:#fff1cc" class="clickable-row" data-href="c_vietu_apraksti.php?f=edit&id=<?= $id?>" id="row_<?= $id?>">
			<td width=1 name="id"><?= $id?></td>
			<td name="nosaukums"><?= $nameVal?></td>
			<td name="apraksts"><?
				$ap = (isset($row["apraksts"]) ? Decode($row["apraksts"]) : "");
				echo substr($ap,0,100);
			?></td>
			<td>
				<a href="c_vietu_apraksti.php?f=edit&id=<?= $id?>">Labot</a>
				<? if(!empty($id)){?> | <a onclick="return confirm('Dz�st ierakstu?');" href="c_vietu_apraksti.php?f=delete&id=<?= $id?>">Dz�st</a><? }?>
			</td>
		</tr>
	<?}?>
	</tbody>
</table>

<div style="margin-bottom:10px">
	<br>
	<a class="btn btn-success" href="c_vietu_apraksti.php?f=add">Pievienot jaunu</a>
</div>


<style>
table {
	margin-top: 1%;
}
.clickable-row {
	cursor: pointer;
}
</style>


