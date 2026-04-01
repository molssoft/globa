<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Grupu vadîtâji","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Grupu vadîtâji</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>
<div align="center">
<form name="forma" method="POST">
<center> 
<table border="0" ;>
    <tr bgcolor="#ffc1cc">
        <th>Kods</th>
        <th>Vârds</th>
        <th>Uzvârds</th>
        <th>Dalibn. Id</th>
		<th></th>
		<th></th>
		<th></th>
    </tr>
	<tr bgcolor="#fff1cc">
        <td align="center"><input id="id" type="text" maxlength="50" name="id" size="20" maxlength="10"></td>
        <td align="center"><input id="name" type="text" maxlength="50" name="name" size="20" maxlength="50"></td>
        <td align="center"><input id="lastname" type="text" maxlength="50" name="lastname" size="20" maxlength="50"></td>
        <td align="center"><input id="did" type="text" maxlength="50" name="did" size="20" maxlength="50"></td>
        <td width="100"><a class="add" type="image" href="#" onclick="Add()">Pievienot</td>
    </tr>
    <?foreach($data as $d){?>
    <tr bgcolor="#fff1cc" id="row_<?=$d["idnum"]?>" class="clickable-row" height="25" data-href="c_grupu_vaditaji.php?f=edit&idnum=<?=$d["idnum"]?>">
        <td name="userId"><?echo $d["id"]?></td>
        <td name="userName"><?echo $d["vards"]?></td>
        <td name="userLastname"><?echo $d["uzvards"]?></td>
        <td name="userDid"><?echo $d["did"]?> (<?=$d['globa_vards']?>)</td>
		<td width="100">
			<!--<a href="c_grupu_vaditaji.php?f=edit&idnum=<?=$d["idnum"]?>" class="edit" style="display:none">Labot</a> -->
			<a href="#" class="delete" style="display:none" onclick="Delete(<?echo $d["idnum"]?>)">Dzçst</a>
		</td>
    </tr><?   }  ?>
</table>

</form>		
</div>
<style>
table {
	border-spacing: 0em 0.2em;
	border-collapse:separate;
}
#pievienot{
	margin-left: 1em;
}
.clickable-row {
	cursor: pointer;
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

function Delete($idnum){
	if (confirm("Vai tieðâm izdzçst ierakstu?")) {
		$("a.delete").attr("href", function(i, href) {
		  return "c_grupu_vaditaji.php?f=delete&idnum="+$idnum+""
		});
	}
};

function Add()
{
	var id = $("#id").val();
	var name = $("#name").val();
	var lastname = $("#lastname").val();
	var did = $("#did").val();
	if(ValidateInput(id,name,lastname,did)){
		$("a.add").attr("href", function(i, href) {
		  return "c_grupu_vaditaji.php?f=add&id="+id+"&name="+name+"&lastname="+lastname+"&did="+did+""
		});
	}
}
function ValidateInput(id,name,lastname,did)
{
	console.log("test");
	if(id == "")
	{
		alert("Ieraksts nav saglabâts. Nav norâdîts kods.")
		return false;
	};
	if(name == "")
	{
		alert("Ieraksts nav saglabâts. Nav norâdîts vârds.")
		return false;
	};
	if(lastname == "")
	{
		alert("Ieraksts nav saglabâts. Nav norâdîts uzvârds.")
		return false;
	};
	if(id.length > 10)
	{
		alert("Ieraksts nav saglabâts. Kods ir pârâk garð.")
		return false;
	};
	if(name.length > 50)
	{
		alert("Ieraksts nav saglabâts. Vârds ir pârâk garð.")
		return false;
	};
	if(lastname.length > 50)
	{
		alert("Ieraksts nav saglabâts. Uzvârds ir pârâk garð.")
		return false;
	};
	return true;
};

</script>