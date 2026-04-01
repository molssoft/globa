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
<table border="0" width="20%" ;>
    <?foreach($user as $u){?>
    <tr bgcolor="#fff1cc" id="row_<?=$u["idnum"]?>" height="25">
        <tr><td bgcolor="#ffc1cc">Kods</td><td bgcolor="#fff1cc"><input type="text" id="id" value="<?echo $u["id"]?>"></td></tr>
        <tr><td bgcolor="#ffc1cc">Vârds</td><td bgcolor="#fff1cc"><input type="text" id="name" value="<?echo $u["vards"]?>"></td></tr>
        <tr><td bgcolor="#ffc1cc">Uzvârds</td><td bgcolor="#fff1cc"><input type="text" id="lastname" value="<?echo $u["uzvards"]?>"></td></tr>
        <tr><td bgcolor="#ffc1cc">Dalibn. Id</td><td bgcolor="#fff1cc"><input type="text" id="did" value="<?echo $u["did"]?>"></td></tr>
    </tr>
</table>
<div class="button-wrapper">
	<a class="save" type="image" href="#" name="save" src="" alt="" width="25" height="25" onclick="Save(<?echo $u["idnum"]?>)">[ Saglabât ]</a><a type="image" class="cancel-link" href="c_grupu_vaditaji.php?f=index" name="cancel" src="" alt="" width="25" height="25">[ Atcelt ]</a>
</div>
<?   }  ?>
</form>		
</div>
<style>
table {
	border-spacing: 0em 0.2em;
	border-collapse:separate;
}
.button-wrapper {
	margin-top: 1%;
}
.cancel-link{
	margin-left: 20px;
}
</style>
<script>
function Save(idnum)
{
	var id = $("#id").val();
	var name = $("#name").val();
	var lastname = $("#lastname").val();
	var did = $("#did").val();
	if(!ValidateInput(id,name,lastname,did)){
		return false;
	}
	else{
		$("a.save").attr("href", function(i, href) {
		  return "c_grupu_vaditaji.php?f=save&idnum="+idnum+"&id="+id+"&name="+name+"&lastname="+lastname+"&did="+did+"";
		});
	}
}
function ValidateInput(id,name,lastname,did)
{
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