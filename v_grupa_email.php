<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Grupas dalîbnieku e-pasta adreses","y1.jpg");
DefJavaSubmit();?>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Grupas<br><?=$data['grupa']?><br>dalîbnieku e-pasta adreses</b></font><hr>

<?
// standarta saites 
//Headlinks();
?>
<br>
<form name="forma" id="forma" action = "" method = "POST">
<input type="hidden" name="subm" value="1">
<table>
	<tr>
		<th><input type="checkbox" id="checkAll"   class="ch_dalibn" title="Izvçlçties visus"></th>
		<th>Pieteikuma dat.</th>
		<th>Dalîbnieks</th>		
		<th>E-pasta adreses</th>		
	</tr>
	<tr>
		 <td colspan="3"> &nbsp </td>
		 <td rowspan="10"><textarea cols=30 rows=10 id="emails"></textarea></td>
	</tr>
	 
	<? foreach($data['dalibn'] as $dalibn){
		?>
	<tr>
		<td><?
		if ($dalibn['eadr']!=''){
			?><input type="checkbox" class="ch_dalibn" name="dalibn[]" value="<?=$dalibn['did'];?>">
		<?}?>
		</td>
		<td><a href="pieteikums.asp?pid=<?=$dalibn['pid'];?>" target="_blank"><?=$db->Date2Str($dalibn['datums']);?></a></td>
		<td><a href="dalibn.asp?i=<?=$dalibn['did'];?>" target="_blank"><?=$dalibn['eadr'];?></a></td>
		
		<td></td>
	</tr>
		<?
	}?>
	
</table>
<script>
 $(function(){
	 checkAll();
	 function checkAll(){		
		$('input:checkbox').prop('checked', $('#checkAll').is(":checked"));    
	 }
	 $('#checkAll').click(function () {   
		checkAll();
	}); 
	$(".ch_dalibn").on('change',function(){
		var data = $("#forma").serialize();
		//console.log(data);
		$.ajax({
		  method: "POST",
		  url: "c_grupa_email.php",
		  data: data
		})
		  .done(function( data ) {
			  $("#emails").html(data);
		  });
	});
 })
</script>

</form>
</body>
</html>