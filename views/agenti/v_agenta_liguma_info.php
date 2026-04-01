<?require_once("i_functions.php");
require_once("i_decode.php");

Docstart ("Aìenti","y1.jpg");
DefJavaSubmit();?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<font face="Tahoma">
<center><font color="GREEN" size="5"><b>Aìenta lîguma informâcija</b></font><hr>

<?
Headlinks();
?>



<form action="c_agenti.php?f=updateAgents&id=<?=$data[0]["id"]?>" method="POST">

<?foreach($data as $agents){?>
<center>

<font size=4>Aìents: <?=Decode($agents["vards"]);?></font>
<br>
<br>

<table border=0>
	<tr>
		<th>Lîguma slçgðanas vieta</th><td><input type="text" size="20" name="liguma_vieta" value="<?=Decode($agents["liguma_vieta"])?>"></td>
	<tr>
		<th>Lîguma datums</th><td><input type="text" name="liguma_datums" value="<?if(!isset($agents["liguma_datums"])) echo "";else echo $agents["liguma_datums"]->format("d.m.Y");?>"></td>
	</tr>
	<tr>
		<th>Lîguma numurs</th><td><input type="text" size="20" name="liguma_nr" value="<?if(!isset($agents["liguma_nr"])) echo "";else echo $agents["liguma_nr"]?>"></td>
	</tr>
	<tr>
		<th>Uzòçmums</th><td><input type="text" size=50 name="uznemums" value="<?=Decode($agents["uznemums"])?>"></td>
	</tr>
	<tr>
		<th>Reì. nr. </th>
		<td><input type="text" size=10 name="regnr" value="<?=Decode($agents["regnr"])?>"></td>
	</tr>

	<tr>
		<th>Adrese</th>
		<td><input type="text" size=50 name="adrese" value="<?=Decode($agents["adrese"])?>"></td>
	</tr>
	<tr>
		<th>Tûr. Reì. nr. </th>
		<td><input type="text" size=10 name="tur_regnr" value="<?=Decode($agents["tur_regnr"])?>"></td>
	</tr>
	<tr>
		<th>Uz ... pamata</th>
		<td><input type="text" size=20 name="liguma_pamats" value="<?=Decode($agents["liguma_pamats"])?>"></td>
	</tr>
	<tr>
		<th>Pârstâvis</th>
		<td><input type="text" size=20 name="parstavis" value="<?=Decode($agents["parstavis"])?>"></td>
	</tr>
</table>
</form>
<?}?>
<div class="button-wrapper">
	<input type="submit" class="save" value="[ Saglabât ]"><a type="image" class="cancel-link" href="c_agenti.php?f=index" name="cancel" src="" alt="" width="25" height="25">[ Atcelt ]</a>
</div>
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
form {
	margin-top: 1%;
}
</style>