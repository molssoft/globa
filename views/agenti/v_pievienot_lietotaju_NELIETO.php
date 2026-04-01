<?require_once("i_functions.php");

Docstart ($data['title'],"y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Lietotâjs</b></font><hr>

<?
Headlinks();
?>
<form action="<?=$data['form_action'];?>" method="POST">
<table>
<tr><th>Lietotâjs</th><td bgcolor="#fff1cc"><input type="text" name="lietotajs" size="15" value=""></td></tr>
<tr><th>Vards</th><td><input bgcolor="#fff1cc" type="text" name="vards" size="15" value=""></td></tr>
<tr><th>Uzvards</th><td><input bgcolor="#fff1cc" type="text" name="uzvards" size="15" value=""></td></tr>
<tr><th>Epasts</th><td><input bgcolor="#fff1cc" type="text" name="epasts" size="15" value=""></td></tr>
<tr><th>Parole</th><td><input bgcolor="#fff1cc" type="text" name="parole" size="15" value=""></td></tr>
<tr><th>Aktivs</th><td><input bgcolor="#fff1cc" type="checkbox" name="active" ></td></tr>

</table>
<div class="button-wrapper">
	<input type="submit" class="save" value="[ Pievienot ]"><a type="image" class="cancel-link" href="c_agenti.php?f=index" name="cancel" src="" alt="" width="25" height="25">[ Atcelt ]</a>
</div>
</form>
<style>
.button-wrapper {
	margin-top: 1%;
}
.cancel-link{
	margin-left: 20px;
}
.save { 
     background: none;
     border: none;
     text-decoration: underline;
     cursor: pointer; 
	 font-size:16px;
	 color:#008040;
}
.save:focus{
	color:#804000;
}
table{
	margin-top: 1%;
}
</style>