<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Anketas","y1.jpg");
DefJavaSubmit();?>
<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
  <!-- jQuery Modal -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<center><b><font face=tahoma>
<?=$db->Date2Str($data['grupa']["sakuma_dat"]) . " " . $data['grupa']["v"]." ".$data['grupa']["kods"];?></b>
<br>
<br>
<a href="#" id="show_full_info" onclick="$('.full-info').show();$('#show_full_info').hide();">+ Râdît pilnu anketu informâciju</a>
<a href="#" id="" class="full-info" onclick="$('.full-info').hide();$('#show_full_info').show();">- Râdît saîsinâtu anketu informâciju</a><br>
<br>


<table border=0 cellpadding=3>
	<tr>
		<th colspan="7" class="full-info"></th>
		<th colspan="1" class="left-right-borders"></th>
		<th colspan="2" class="left-right-borders">Marðuts</th>
		<th colspan="2" class="left-right-borders">Naktsmîtne</th>
		<th colspan="2" class="left-right-borders">Transports</th>
		<th colspan="2" class="left-right-borders">Vadîtâjs</th>
		<th colspan="2" class="left-right-borders">Gids</th>
		<th class="left-right-borders"></th>
		<th colspan="4" class="">Kontaktinfo</th>
		<!--th></th-->
	</tr>
	<tr bgcolor=#fff1cc>
		
		<th class="right-border">Nr.</th>
		<th class="right-border full-info">Datums</th>
		<th class="full-info"><small>Braucis (reizes)</small></th>
		<th class="full-info"><small>Ir pircis online</small></th>
		<th class="full-info">Izvçles iemesls</th>
		<th class="full-info">Info avots</th>
		<th class="full-info">Soc.tîklu konts</th>
		<th class="right-border full-info">Grib aizbraukt uz</th>

		<th>Atz.</th>
		<th class="right-border">Komentârs</th>
		<th>Atz.</th>
		<th class="right-border">Komentârs</th>
		<th>Atz.</th>
		<th class="right-border">Komentârs</th>
		<th>Atz.</th>
		<th class="right-border">Komentârs</th>
		<th>Atz.</th>
		<th class="right-border">Komentârs</th>
		
		<th class="right-border">Iespaidi</th>

		<th>Vârds</th>
		<th>Uzvârds</th>
		<th>Tâlr.</th>
		<th class="">E-pasts</th>
		
		<!--th></th-->
	</tr>
<? foreach($data['anketas'] as $row){
	//var_dump($row["pircis_online"]);
	?>
	<tr bgcolor=#fff1cc>
		<td class="right-border"><?=$row['id'];?></td>
		<td align=center  class="right-border full-info"><?=$db->Date2Str($row['datums']);?></td>
		<td align=center class="full-info"><? if ($row["braucis"] != 3) echo $row["braucis"]; else echo "3+"; ?></td>
		<td align=center class="full-info"><? if (!is_null($row["pircis_online"])){ if ($row["pircis_online"])  echo "jâ"; else echo "nç";}?></td>
		<td class="full-info" ><?=$anketas->PrintMultiAnswers($row["izveles_iemesls"]);?></td>
		<td  class="full-info"><?=$anketas->PrintMultiAnswers($row["avots"]);?></td>
		<td  class="full-info"><?=$anketas->PrintMultiAnswers($row["socialais_konts"]);?></td>
		<td  class="right-border full-info"><?=$anketas->PrintMultiAnswers($row["grib_aizbraukt"]);?></td>

		<td align=center><?=$row["atz_marsruts"]?></td>
		<td  class="right-border"><?=PrintTextShort('piezimes_marsruts',$row['id'],$row['piezimes_marsruts']);?></td>
		<td align=center><?=$row["atz_naktsmitne"]?></td>
		<td  class="right-border"><?=PrintTextShort('piezimes_naktsmitne',$row['id'],$row['piezimes_naktsmitne']);?></td>
		<td align=center><?=$row["atz_transports"]?></td>
		<td  class="right-border"><?=PrintTextShort('piezimes_transports',$row['id'],$row['piezimes_transports']);?></td>
		<td align=center><?=$row["atz_vaditajs"]?></td>
		<td  class="right-border"><?=PrintTextShort('piezimes_vaditajs',$row['id'],$row['piezimes_vaditajs']);?></td>
		<td align=center><?=$row["atz_gids"]?></td>
		<td  class="right-border"><?=PrintTextShort('piezimes_gids',$row['id'],$row['piezimes_gids']);?></td>
		
		<td  class="right-border">
		<?=PrintTextShort('iespaidi',$row['id'],$row['iespaidi']);?>
		</td>
		
		<td><?=$row['vards'];?></td>
		<td><?=$row['uzvards'];?></td>
		<td><?=$row['talr'];?></td>
		<td class=""><?=$row['epasts'];?></td>
		<!--td><? if (!empty($row['braucis']) or !empty($row['pircis_online']) or !empty($row['izveles_iemesls']) or !empty($row['avots']) or !empty($row['socialais_konts']) or !empty($row['grib_aizbraukt'])){?><a  href="#papild_info_<?=$row['id'];?>" rel="modal:open">Skatît papildinfo</a><?}?>
		</td-->
		<!--td><a href=anketa_del.asp?gid=<?=$row['gid'];?>&id=<?=$row["id"]?> onclick="return confirm('Vai vçlaties dzçst anketu?')">Dzçst</a></td-->
  </tr>
  
  <!-- Modal HTML embedded directly into document -->
	<div id="papild_info_<?=$row['id'];?>" class="modal">
		<p>
			<b>Braucis:</b> <? if ($row["braucis"] != 3) echo $row["braucis"]; else echo "3+"; ?><br>
			<b>Ir pircis online:</b>  <? if (!is_null($row["pircis_online"])){ if ($row["pircis_online"])  echo "jâ"; else echo "nç";}?><br>
			<b>Izvçles iemesls:</b>  <?=$anketas->PrintMultiAnswers($row["izveles_iemesls"]);?><br>
			<b>Info avots:</b>  <?=$anketas->PrintMultiAnswers($row["avots"]);?><br>
			<b>Soc.tîklu konts:</b>  <?=$anketas->PrintMultiAnswers($row["socialais_konts"]);?><br>
			<b>Grib aizbraukt uz:</b>  <?=$anketas->PrintMultiAnswers($row["grib_aizbraukt"]);?>
		</p>
		<a href="#" rel="modal:close">Aizvçrt</a>
	</div>
  <?
}
?><tr bgcolor=#fff1cc>
	<td colspan = "7" class="full-info top-border"></td>
	<td align=right colspan="1" class="right-border top-border"><b>Vidçji</td>
	<td align=center class="top-border"><b><?=$anketas->GetAverage('atz_marsruts',$gid)?></td>
	<td align=center class="right-border top-border"></td>
	<td align=center class="top-border"><b><?=$anketas->GetAverage('atz_naktsmitne',$gid)?></td>
	<td align=center class="right-border top-border"></td>
	<td align=center class="top-border"><b><?=$anketas->GetAverage('atz_transports',$gid)?></td>
	<td align=center class="right-border top-border"></td>
	<td align=center class="top-border"><b><?=$anketas->GetAverage('atz_vaditajs',$gid)?></td>
	<td align=center class="right-border top-border"></td>
	<td align=center class="top-border"><b><?=$anketas->GetAverage('atz_gids',$gid)?></td>
	<td align=center class="right-border top-border"></td>

	<td colspan="5" class="top-border"></td>
 </tr>
 <!--tr bgcolor=#fff1cc><form name=forma action=anketa_add.asp method=POST>
  <td align=right><b></td>
  <td align=center><input type=text name=braucis size=4></td>
  <td align=center><input type=text name=atz_marsruts size=4></td>
  <td align=center><input type=text name=atz_naktsmitne size=4></td>
  <td align=center><input type=text name=atz_transports size=4></td>
  <td align=center><input type=text name=atz_vaditajs size=4></td>
  <td align=center><input type=text name=atz_gids size=4></td>
  <td align=center><input type=hidden name=gid value=<%=Request.QueryString("gid")%>>
   <input type=submit value=Pievienot name=poga></td>
 </tr>
  </form-->
 </table>


<br>
<a href="default.asp">Uz mâjâm</a>
<a href="anketa_grupa.asp">Cita grupa</a>


</body>
</html>

<style>
td{
	vertical-align:top
}
.left-right-borders{
	border-right: 1px solid black;

}
.right-border{
	border-right: 1px solid black;
}
.full-info{
	display:none
}
.top-border{
	border-top:2px solid black
}
</style>
<? 
//funkcijas
function PrintTextShort($column_name,$id,$text){
	if (!empty($text)){
		if (strlen($text)>30){
		return '<span class="'.$column_name.'_'.$id.'">'.substr($text,0,30)."...".'<a href="#" onclick="$(\'.'.$column_name.'_'.$id.'\').toggle();">skatît vairâk</a></span>
		<span style="display:none " class="'.$column_name.'_'.$id.'">'.$text.' <a href="#" onclick="$(\'.'.$column_name.'_'.$id.'\').toggle();">paslçpt</a></span>';
		}
		else{
			return $text;
		}
	}
}
?>