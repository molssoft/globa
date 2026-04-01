<?require_once("i_functions.php");

Docstart ("Lietotâji","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Lietotâji</b></font><hr>

<?
Headlinks();
?>
<center><h2>Aìenta lietotâji</h2> <table border="0">
<a href="c_agenti.php?f=addNewLietotajsView&aid=<?=$aid?>">Pievienot lietotaju</a>
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Lietotâjs</th>
		<th>Vârds</th>
		<th>Uzvârds</th>
		<th>Epasts</th>		
		<th>Aktîvs</th>
		<th></th>
	</tr>
	<?foreach($data as $lietotajs){?>
		<tr bgcolor="#fff1cc" id="row_<?= $lietotajs["id"]?>" class="clickable-row" data-href="c_agenti.php?f=editLietotajsView&id=<?= $lietotajs["id"]?>">
			<td width=1><?= $lietotajs["id"]?></td>
			<td><?= $lietotajs["Lietotajs"]?></td>
			<td><?= $lietotajs["vards"]?></td>
			<td><?= $lietotajs["uzvards"]?></td>
			<td><?= $lietotajs["epasts"]?></td>
			
			<td><? if($lietotajs["active"] == 1) echo "Jâ"; else echo "Nç";?></td>
			<td class="delete-cell" width="50"><a href="#" class="delete" style="display:none" onclick="Delete(<?= $lietotajs["id"]?>)">Dzçst</a></td>
		</tr>
	<?}?>
</table>
<div class="button-wrapper">
	<a type="image" class="cancel-link" href="c_agenti.php?f=index" name="cancel" src="" alt="" width="25" height="25">[ Atpakal ]</a>
</div>
<style>
.button-wrapper {
	margin-top: 1%;
}
.clickable-row {
	cursor: pointer;
}
.delete-cell {
	text-align: center;
}
table {
	margin-top: 1%;
}
</style>
<script>

$("tr").mouseenter(overHandler);

$("tr").mouseleave(outHandler);

$(".clickable-row").click(function() {
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
	if (confirm("Vai tiešam izdzest ierakstu?")) {
		$("a.delete").attr("href", function(i, href) {
		  return "c_agenti.php?f=deleteLietotajs&id="+$id+""
		});
		
	}	
};	
</script>