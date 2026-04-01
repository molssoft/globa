<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Pilna pieteikumu atskaite","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Pilna pieteikumu atskaite</b></font><hr>
<?
// standarta saites 
Headlinks();
?>
<br>
<form name="forma" id="forma"action = "" method = "POST">
	<? include 'online2/i_handler_values.php'?>
	<? include 'online2/i_handler_errors.php'?>
	<label for="error"></label>
	<table>
		<tr>
			<td align="right" bgcolor="#ffc1cc">Operâcijas/pieteikuma datums <b>no: </td>
			<td bgcolor="#fff1cc">
				<input type="text" size="8" maxlength="10" name="sak_dat" value="<?=$data['values']["sak_dat"]?>" required> <b>lîdz:</b> 
				<input type="text" size="8" maxlength="10" name="beigu_dat" value="<?=$data['values']["beigu_dat"]?>" required> 
			</td>
		</tr>
		<tr>
			<td align="right" bgcolor="#ffc1cc">Grupas beigu datums <b>no: </td>
			<td bgcolor="#fff1cc">
				<input type="text" size="8" maxlength="10" name="grupa_no" value="<?=$data['values']["grupa_no"]?>"> <b>lîdz:</b> 
				<input type="text" size="8" maxlength="10" name="grupa_lidz" value="<?=$data['values']["grupa_lidz"]?>"> 
			</td>
		</tr>

		<tr><td align="right" bgcolor="#ffc1cc">Periods</td><td bgcolor="#fff1cc">
			<select name="periods">
				<option <? if ($data['values']["periods"] == "day") echo " selected ";?> value="day">Diena</option>
				<option <? if ($data['values']["periods"] == "month") echo " selected ";?> value="month">Mçnesis</option>
				<option <? if ($data['values']["periods"] == "year") echo " selected ";?> value="year">Gads</option>
			</select></td>
		</tr>
		<tr><td align="right" bgcolor="#ffc1cc">Nerâdît aìentu pieteikumus</td><td bgcolor="#fff1cc">
			<input type="checkbox" <? if ($data['values']["neradit_agentu"]=="on") echo "checked";?> name="neradit_agentu">
				</td></tr>
		<tr><td align="right" bgcolor="#ffc1cc">Nauda vai pasûtîjumi</td><td bgcolor="#fff1cc">
			<select name="veids">
				<option <? if ($data['values']["veids"] == "nauda") echo " selected ";?> value="nauda">Ienâkusî nauda</option>
				<option <? if ($data['values']["veids"] == "pasutijums") echo " selected ";?> value="pasutijums">Pasûtîjumu summa</option>
			</select></td></tr>
		<tr>
			<td align=right bgcolor="#ffc1cc">Valûta</td>
			<td>
				<select name=valuta>
				 <option <? if ($data['values']['valuta']=="Kopa") echo " selected ";?>value=Kopa>Kopâ</option>
				 <option <? if ($data['values']['valuta']="EUR") echo " selected ";?>value=EUR>EUR</option>
				 <option <? if ($data['values']['valuta']=="USD") echo " selected ";?> value=USD>USD</option>
				</select> 
			</td>
		</tr>
	</table>
	<input type="hidden" name="skatit" value="1"/>
	<input type="image" src="impro/bildes/skatit.jpg" WIDTH="116" HEIGHT="25">
</form>

<center>	<img src = "images/loading.gif" id="loading_gif" alt ="loading" style="width:40px;display:none"/>
	<table id="dataTable">
		<thead>
			<tr bgcolor="#ffc1cc">
				<th >Datums</th>
				<th></th>
				<th >Kompleksie</th>
				<th >Èarteri</th>
				<th >Vâktâs</th>
				<th >V Baltija</th>
				<th >V Lidojumi</th>
				<th >V 1D</th>
				<th >Pasûtîjuma</th>
				<th >Pasûtîjuma 1D</th>
				<th >Skolçnu</th>
				<th >Skolçnu 1D</th>
			</tr>
		</thead>
		<tbody id="dataTableBody">
		</tbody>
	</table>

<style>
	td a {
		display:block;
		width:100%;
	}
</style>
<script>
$(function(){
	 $("#forma").on("submit",function(){
		 console.log($("#dataTableBody"));
		 console.log($("#loading_gif"));
		 $("#loading_gif").show();
		 $("#dataTableBody").empty();
		 
		 recursively_ajax(1);
		
		 function recursively_ajax(counter){
			 console.log('sub');
			 console.log($("#loading_gif"));
			
		$.ajax({
		  url: "c_atsk_viss.php?f=PrintRow",
		  data :  $("#forma").serialize(),
		  type: 'POST',
		  async:false, // set async false to wait for previous response
		  dataType: 'html'
		}).done(function(data) {
			
			console.log( "success" );
			console.log(data);
			console.log($.trim(data).length);
			if ($.trim(data).length == 0){
				console.log('tukðs');
			}
			else{
				console.log('nav tukðs');
				console.log('counter:'+counter);
				//if (counter<=3){
					console.log('pievienojam rindinju');
					counter++;
					console.log($('#dataTable'));
					$('#dataTable').append(data);
					recursively_ajax(counter);
				//}
				
			}
		  })
		  .fail(function() {
			console.log( "error" );
		  })
		 
		 }

return false;

	});
}) 
</script>
</body>
</html>