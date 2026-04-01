<?require_once("i_functions.php");
require_once("i_decode.php");
Docstart ("Aìenti","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<!--Rg 14.06.2020 Datatable stili no https://datatables.net-->
<script scr="https://code.jquery.com/jquery-3.5.1.js"></script>
<link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">
<script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>


<script>
    $(document).ready(function() {
       
      
		 $('#tblAgentiNeaktivi').DataTable({
            "order": [[2 , "asc" ]],
            "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.21/i18n/Latvian.json"
            },
             "pageLength": 25
  
        });
     });
</script>
<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Aìenti</b></font><hr>

<?
// standarta saites 
 
Headlinks();
?>
	

<center><h2>Neaktîvie aìenti</h2> 
	<table id="tblAgentiNeaktivi" border="0" class="table" style="border-spacing:2px">
	<thead>
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Aktîvs</th>
		<th>Pilsçta</th>
		<th>Vârds</th>
		<th>Debets</th>
		<th>Kredîts</th>
		<th>Lîgums</th>
		<th>Uzòçmums</th>
		<th>Reì</th>
		<th>Adrese</th>
		<th>TATO</th>
		<th>Pârstâvis</th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<?foreach($data["neaktivi"] as $agents){?>
		<tr style="background-color:#fff1cc" class="clickable-row" data-href="c_agenti.php?f=editAgentsView&id=<?= $agents["id"]?>" id="row_<?= $agents["id"]?>">
			<td width=1 name="id"><?= $agents["id"]?></td>
			<td name="aktivs"><? if($agents["aktivs"] == "1") echo "Jâ"; else echo "Nç";?></td>
			<td name="pilseta"><?= Decode($agents["pilseta"])?></td>
			<td name="vards"><?= Decode($agents["vards"])?></td>
			<td name="dkonts"><?= Decode($agents["dkonts"])?></td>
			<td name="ckonts"><?= Decode($agents["ckonts"])?></td>

			<td><a href="c_agenti.php?f=editLigumsView&id=<?= $agents["id"]?>">[Lîguma info]</a></td>
			<td name="uznemums"><?= Decode($agents["uznemums"]) ?></td>
			<td name="regnr"><?= Decode($agents["regnr"])?></td>
			<td name="adrese"><?= Decode($agents["adrese"])?></td>
			<td name="tur_regnr"><?= Decode($agents["tur_regnr"])?></td>
			<td name="parstavis"><?= Decode($agents["parstavis"])?></td>
			<td class="delete-cell" width="50"><a href="#" class="delete" style="display:none" onclick="Delete(<?= $agents["id"]?>)">Dzçst</a></td>
		 </tr>
	<?}?>
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
<script>

$("tr").mouseenter(overHandler);

$("tr").mouseleave(outHandler);

$(".clickable-row").click(function() {
	console.log("yo");
        window.location = $(this).data("href");
    });

function overHandler(ev) {
    var target = $(ev.target).parent();
    var rowId = target.attr('id');
    if( target.is("tr") ) {
		$("#"+rowId+" .delete").show();
	}
};

function outHandler(ev) {
    var target = $(ev.target).parent();
    var rowId = target.attr('id');
    if( target.is("tr") ) {
		$(".delete").hide();
	}
};

function Delete($id){
	if (confirm("Vai tieðâm izdzçst ierakstu?")) {
		$("a.delete").attr("href", function(i, href) {
		  return "c_agenti.php?f=deleteAgents&id="+$id+""
		});
		
	}	
};
</script>