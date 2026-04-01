<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Online apmaksas veidu izmaiòu vçsture","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Online apmaksas veidu izmaiòu vçsture</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>


	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
<center>

	
<table>
<tr>
<? foreach ($data as $key=>$row){
	
	?>
	<th><?=$key;?></th>
	
	<?
	
}?>
</tr>
<tr bgcolor="#fff1cc">
<? foreach ($data as $key=>$row){
	?>
	<td><?=$row['vesture'];?></td>
	<?
	
}?>
</tr>
</table>

<br>
		
<a href="c_online_settings.php">Atgriezties</a>


<br>
<br>
<style>
 #atrasts td{
	 vertical-align:top;
 }
</style>
<script>
$("#forma").on("submit",function(){
	return confirm('Vai tieðâm vçlaties saglabât izvçlçtos iestatîjumus?');
})
</script>
</body>
</html>