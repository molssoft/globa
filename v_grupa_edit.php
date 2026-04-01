<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Grupas labošana","y1.jpg");
DefJavaSubmit();?>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Grupas labošana</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<br>

	
<div align="center">		

<form name=forma  method=POST>
<input type=hidden name="grupa_id" value="<?=$data["id"];?>">

<table>
	<tr><td>
		<table>
		<tr>
			<td align=right><font size=2>
			<strong>Kods:</strong></td>
			<?
			if (!$data['gr_lab2']){ ?>
			 <td align=left><?=$data["kods"];?><input type=hidden name=kods value="<?=$data["kods"]?>" size=15>
			<?} else {?>
			 <td align=left><input size=15 type=text name=kods value="<?=$data["kods"]?>">
			<?}?>
		    </td>
		</tr>
		
  <? if (!$tiesibas->IsAccess(T_DROSIBA)) { ?>
  
		<? if  (strpos($data['kods'], '.V.') !== false) { ?>
		<tr>
			<td align=right><font size=2>
			<strong>Grupa bloíçta: </strong></td>
			<?
			if (!$gr_lab2) { ?>
			 <td align=left><?=$gr->GetBlockType($data['blocked'])?><input type=hidden name=blocked value="<?=$gr->GetBlockType($data['blocked'])?>" size=15>
			<?} else {?>
			 <td align=left><?=$gr->ComboBlockType($data['blocked'])?>
			<?}?>
		    </td>
		</tr>
		<? } else {?>
		<!--tr>
			<td></td>
			<td>Grupas bloíçðana pagaidâm nav pieejama. Tiek veiktas izmaiòas.</td>
		</tr-->
		<? }?>	
		<tr>
			<td align=right><font size=2><strong>Pârdot Online: </strong></font></td>
			<td><input name="online" type="checkbox" <? if($data["internets"]){ echo " checked ";}?> >
			<input type=hidden name=internets_no size=8 value=<?=$db->Date2Str($data["internets_no"])?>>
			</td>
		</tr>
		<tr>
			<td align=right>
				<font size=2><strong>LV ceïojums, online nevajag norâdît pasi:</font></td>
			<td>	<input name="nevajag_pases" type="checkbox" <?if ($data['nevajag_pases']){ echo " checked ";}?> >
			
			</td>
		</tr>			
		<tr>
			<td align=right><font size=2><strong>Pârdot aìentiem sâkot ar: </strong></font></td>
			<td><input name="pardot_agentiem" type="hidden" <?if ($data['pardot_agentiem']) {echo " checked ";}?> > <input type=text name=pardot_agentiem_no size=8 value=<?=$db->Date2Str($data["pardot_agentiem_no"]);?>></td>
		</tr>	
		<!--
		<tr>
			<td align=right><font size=2><strong>E-klase: </strong></font></td>
			<td><input name="eklase" type="checkbox" <?//if eklase then echo " checked "?> >
			E-klases lietotâjiem ceïojums ar atlaidi 5%
			</td>
		</tr>			  -->
		<tr>
			<td align=right><font size=2>
			<strong><font size=2>Ieòçmumu konts: </strong></td>
			<td align=left>
			<?if (!$data['gr_lab2']) { ?>
			 <?=$data["konts"];?><input type=hidden name=konts value="<?=$data["konts"];?>" size=10>
			<?} else {?>
			 <input type=text name=konts value="<?=$data["konts"];?>" size=10>
			<?}?>
			</td>
		</tr>
		<? } ?>
		 <input type=hidden name=konts value="<?=$data["konts"];?>" size=10>
 <? ?>
		
  <? if (!$tiesibas->isaccess(T_DROSIBA)) { ?>
		<tr>
			<td align=right><font size=2>
			<strong><font size=2>Avansa konts: </strong></td>
			<td align=left>
			<?if (!$data['gr_lab2']) { ?>
			 <?=$data["konts_ava"]?><input type=hidden name=konts_ava value="<?=$data["konts_ava"]?>" size=10>
			<?} else {?>
			 <input type=text name=konts_ava value="<?=$data["konts_ava"];?>" size=10>
			<?}?>
			</td>
		</tr>
		<? } ?>
   <input type=hidden name=konts_ava value="<?=$data["konts_ava"]?>" size=10>		
		<? ?>
		<tr>
			<td align=right><font size=2><strong>Marðruts:</strong></td>
			<td align=left>
			 <input type=text name=v value="<?=str_replace('"','&#34',$data["marsruts"]["v"])?>" size=60><a href=marsruts_add.asp?gid=<?=$data["id"]?> target=new>+</a>
			 <?' 
				if(!is_null($data["beigu_dat"]){
				$result = $marsruts->IsDouble($data)
			}
				if($result > 0){
				echo "<br>Dubultie marðruti:"+cstr(r(0)); 
				}?> <a href=marsruts_apvienot.asp?id=<?=$data["marsruts"]["id"]?>&gads=<?substr($data("beigu_dat"),0,4)?> target=new>Apvienot</a><?
			 '?>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Èarteris: </strong></font></td>
			<td>
			<input id="carter" name="carter" type="checkbox" <?if($data["carter"] > 0){echo"checked";}?>>
			<span id="carter_viesn">
				<font size=2><strong>Viesnîca: </strong>
				<select id="carter_viesn_id" name="carter_viesn_id">
				  <option value="0">-</option>
				  <?
				  //'--- vecaas carter viesnicas jaunaam grupaam sleepj'
				  if(intval(substr($data["kods"],0,2)) == intval(date("Y"))){
					$wherec = " and old=0 ";
					}
 				  else{
					$wherec = "";
					}
					$query = "select * from carter_viesnicas where 1=1 ".$wherec." order by valsts,nosaukums";
				   $rVeids = $db->Query($query);
				  foreach($rVeids as $value)
				  {
				   echo "<option value=".strval($value["id"])." ";
				   if($value["id"] = $data["carter_viesn_id"]){ 
					   echo " selected ";
				   }
				   echo ">[".$Value["valsts"]."] " . $Value["nosaukums"];
				   echo "</Option>";
				  }
				  ?></select> <a href="carter_viesnicas.asp" target=carter_viesn>Labot</a>
			</span>
			</td> 
		</tr>
	 <?'<!input type=hidden name=lidojums value="<?=dateprint(lidojums)?>" size=8'?>		
		<tr>
			<td align=right><font size=2><strong>Lidojuma datums vietu kontrolei:</strong></td>
			<td align=left>
				<input type=text name=lidojums value="<?=date('d-m-Y',strtotime($data["lidojums"]))?>" size=8 >
			</td>
		</tr>
		<?'input type=hidden name=lidojums_vietas value="<?=lidojums_vietas?>" size=4 '?>
		<tr>
			<td align=right><font size=2><strong>Vietas lidojumâ:</strong></td>
			<td align=left>
			<?
				$query = "SELECT * from lidojums_vietas where lidojums = '?'";
				$params = array($data["lidojums"]);
				$lidojums = $db->Query($query,$params); 
			?>
				<input type=text name=lidojums_vietas value="<?$lidojums["vietas"]?>" size=4 >
			</td>
		</tr>
		<?'
		<tr>
			<td align=right><font size=2><strong>Marðruts novecojis:</strong></td>
			<td align=left><input type=checkbox name=old <?if rMarsruts("old") then echo " checked "?> size=50></td>
		</tr> '
		?>
		<tr>
			<td align=right><font size=2><strong>Standarta viesnîcas:</strong></td>
			<td align=left>
				<input type=checkbox name=standarta_viesnicas id="standarta_viesnicas" <?
				$query = "select g.standarta_viesnicas as sv, g.*, g.pdf as apraksts, lidojums, carter_viesn_id as c_vid,kede from grupa g left join portal.dbo.grupas pg ON pg.gr_kods = g.kods AND g.pdf IS NOT NULL where g.id = ?";
				$params = array($data["id"]);
				$rGrupa = $db->Query($query,$params);
				if ($rGrupa["sv"] == true){
					echo(" checked ");}?> size=50><br/>
					
            </td>
		</tr>
        <tr>
            <td></td>
            <td><div id="standarta_viesnicas_message" style="width: 500px; display: none;">Ja vçlaties, lai pie sandarta viesnîcâm tiktu izveidoti arî SINGLE numuriòi,lûdzu, pârliecinieties vai grupai ir pievienots pakalpojums ar tipu "Piemaksa SGL"! <a href = 'vietu_veidi.asp?gid=<?=$data["id"]?>' target="_blank"><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></div></td>
        </tr>
		<?'
		<tr>
			<td align=right><font size=2><strong>Sûtît epastu par atteikumiem:</strong></td>
			<td align=left><input type="checkbox" name="atteikumu_epasts" <?if $data["atteikumu_epasts")=true then echo(" checked ") end if?> size="50"></td>
		</tr>'?>
		<tr>
			<td align=right><font size=2><strong>Veids:</strong></td>
			<td><select name=veids>
			  <option value="0">-</option>
			  <? $rVeids = $db->Query("select * from grveidi ");
				foreach($rVeids as $veids)
				{
					echo "<option value=" . strval($veids["id"])+" ";
					if($veids["id"] == $rGrupa["veids"]){
						echo " selected ";
					} 
					echo ">" . $veids["vards"];
					echo "</Option>";
				}
			  ?></select>
			</td>
		</tr>
		<? if($rGrupa["veids"] = 2) 
		{ ?>
		<tr>
		<td align=right><font size=2><strong>Klients (obligâts):</strong></td>
			<td align=left>
			  <input type=hidden name=klients value=<?=$rGrupa["pasutitajs"]?>>
			  <input type=button value=Meklçt onclick="window.open('dalibn_izvele.asp?return_id=forma.klients&return_name=klients')" id=button1 name=button1>
			  <?
			  	$query = "select vards, uzvards from dalibn where id = '?'";
				$params = array($rGrupa["pasutitajs"]);
				$rKli = $db->Query($query,$params); 
			  ?>
			  <div id=klients><?
			  if($rKli == null){ 
			   echo "nav";
			  } 
			  else{ 
			   ?><a target="_blank" href="dalibn.asp?i=<?=$rGrupa["pasutitajs"];?>"><?echo $rKli["vards"] . " " . $rKli["uzvards"];?></a>
		<?}?>
			  </div>
		 </td>
		</tr>
		<? } ?>
		 <input type=hidden name=klients>
		<tr>
			<td align=right><font size=2><strong>Valsts:</strong></td>
			<td align=left>
				<select name=valsts>
				<option value="X">-</option>
				<?
				$query = "select * from valstis WHERE globa=1 order by title"; 
				$rValstis = $db->Query($query);
				foreach($rValstis as $valsts)
				{
					echo "<option value=" . strval($valsts["id"]) . " ";
					if (trim($rValstis["id"]) == trim($data["marsruts"]["valsts"])) { 
						echo " selected ";
						echo ">" . $valsts["title"];
						echo "</Option>";
					}
				}
				?></select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Grupa atcelta:</strong></td>
			<td align=left><input type=checkbox name=atcelta <?if($rGrupa("atcelta")){
				 echo " checked ";
				 }?> size=50></td>
		</tr>
		<input type=hidden name=valuta value="<?=$valuta?>" size=3 >
		<?'<tr>
			<td align=right><font size=2><strong>Valûta:</strong></td>
			<td align=left nowrap><input type=text name=valuta value="<?=valuta?>" size=3 ></td>
		</tr>'?>		
		<tr>
			<td align=right><font size=2><strong>Sâkuma datums:</strong></td>
			<td align=left nowrap><input type=text name=sakuma_dat value="<?=date('d-m-Y',strtotime($rGrupa["sakuma_dat"]))?>" size=15></td>
		</tr>
		<tr>
			<td align=right><font size=2>
			<?if(strpos($rGrupa["kods"],".V.7.") === FALSE) { ?>			
				<strong>Izlidoðanas laiks un vieta: </strong>
			<?} else {?>
				<strong>Izbraukðanas laiks un vieta: </strong>
			<?}?>
			</font>
		</td>
		<td>
			<input type=text name=izbr_laiks value="<?date("H:i",strtotime($data["izbr_laiks"])) //'if rGrupa("izbr_vieta")>1 then rw timeprint2(izbr)'?>" size=5>
			<select name=izbr_vieta>
			<?
				$query = "select * from grupa_izbr_vieta";
				$departureLocations = $db->Query($query); ?>
				<option value=0 <?if ($data["izbr_vieta"] == 0)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(0)?></option>
				<option value=1 <?if ($data["izbr_vieta"] == 1)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(1)?></option>
				<option value=2 <?if ($data["izbr_vieta"] == 2)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(2)?></option>
				<option value=3 <?if ($data["izbr_vieta"] == 3)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(3)?></option>
				<option value=4 <?if ($data["izbr_vieta"] == 4)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(4)?></option>
				<option value=5 <?if ($data["izbr_vieta"] == 5)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(5)?></option>
				<option value=6 <?if ($data["izbr_vieta"] == 6)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(6)?></option>
				<option value=7 <?if ($data["izbr_vieta"] == 7)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(7)?></option>
				<option value=8 <?if ($data["izbr_vieta"] == 8)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(8)?></option>
				<option value=9 <?if ($data["izbr_vieta"] == 9)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(9)?></option>
				<option value=10 <?if ($data["izbr_vieta"] == 10)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(10)?></option>
				<option value=11 <?if ($data["izbr_vieta"] == 11)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(11)?></option>
				<option value=12 <?if ($data["izbr_vieta"] == 12)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(12)?></option>
				<option value=13 <?if ($data["izbr_vieta"] == 13)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(13)?></option>
			</select>
			</td>
		</tr>
		<?if (strpos($rGrupa["kods"],".V.7.") === FALSE) { 'lidojumu grupas'?>	
		<tr>
			<td align=right><strong><font size=2>Ielidošanas laiks galamērķī:</font></strong></td>
			<td align=left><input type=text name=ielid_laiks_uz value="<?date("H:i",strtotime($data["izbr_laiks"])) ?>" size=5></td>
		</tr>
			<?}?>
		<tr>
			<td align=right><font size=2><strong>Beigu datums:</strong></td>
			<td align=left><input type=text name=beigu_dat value="<?date('d.m.Y',strtotime($rGrupa["beigu_dat"]))?>" size=15>
			</td>
		</tr>
		<input type=hidden name=ielid_laiks_no value="<?date("H:i",strtotime($data["ielid_laiks_no"])) ?>" size=5>
		<!--tr>
			<td align=right><strong><font size=2>Izlido�anas laiks no galam�r�a:</font></strong></td>
			<td align=left><input type=text name=ielid_laiks_no value="<%rw timeprint2(ielid_laiks_no) %>" size=5></td>
		</tr-->
		<tr>
			<td align=right><strong><font size=2>Drukāt vaučeri:</font></strong></td>
			<td align=left><input type=checkbox name=drukat_vauceri <?
				if ($data["drukat_vauceri"] > 0) { 
					echo ("checked");
					}?> size=50></td>
		</tr>
		<input type=hidden name=reiss_uz value="<?$data["reiss_uz"] ?>" size=5>
		<!--tr>
			<td align=right><strong><font size=2>Reisa numuri (turp, atpaka�):</font></strong></td>
			<td align=left><input type=text name=reiss_uz value="<%rw reiss_uz %>" size=5><input type=text name=reiss_no value="<%rw reiss_no %>" size=5></td>
		</tr-->

		<tr>
			<td align=right><font size=2>
				<?if (strpos($rGrupa["kods"],".V.7.") === FALSE) {?>	
					<strong>Ielidošanas laiks un vieta: </strong>
				<?}else{?>
					<strong>Iebraukšanas laiks un vieta: </strong>
				<?}?>		
				</font>							
			</td>	
			<td>
			<input type=text name=iebr_laiks value="<?date("H:i",strtotime($data["iebr_laiks"])); 'if rGrupa("iebr_vieta")>1 then rw timeprint2(iebr)'?>" size=5>
			<select name=iebr_vieta>
			<?
				$query = "select * from grupa_izbr_vieta";
				$departureLocations = $db->Query($query); ?>
				<option value=0 <?if ($data["izbr_vieta"] == 0)
				{ 
					echo("selected");
				}?>><?=$gr->GetDepartureLocation(0)?></option>
				<option value=1 <?if ($data["izbr_vieta"] == 1)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(1)?></option>
				<option value=2 <?if ($data["izbr_vieta"] == 2)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(2)?></option>
				<option value=3 <?if ($data["izbr_vieta"] == 3)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(3)?></option>
				<option value=4 <?if ($data["izbr_vieta"] == 4)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(4)?></option>
				<option value=5 <?if ($data["izbr_vieta"] == 5)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(5)?></option>
				<option value=6 <?if ($data["izbr_vieta"] == 6)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(6)?></option>
				<option value=7 <?if ($data["izbr_vieta"] == 7)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(7)?></option>
				<option value=8 <?if ($data["izbr_vieta"] == 8)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(8)?></option>
				<option value=9 <?if ($data["izbr_vieta"] == 9)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(9)?></option>
				<option value=10 <?if ($data["izbr_vieta"] == 10)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(10)?></option>
				<option value=11 <?if ($data["izbr_vieta"] == 11)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(11)?></option>
				<option value=12 <?if ($data["izbr_vieta"] == 12)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(12)?></option>
				<option value=13 <?if ($data["izbr_vieta"] == 13)
				{ 
					echo("selected");
				};?>><?=$gr->GetDepartureLocation(13)?></option>
			</select>
			</td>
		</tr>	
		<tr>
			<td align=right><font size=2><strong>Sapulces datums:</strong></td>
			<td align=left>
				<input type=text name=sapulces_dat value="<?=date('d.m.Y',strtotime($rGrupa["sapulces_dat"]))?>" size=15>
				<font size=2><strong>Laiks:</strong>
				<input type=text name="sapulces_laiks_no" value="<?=$rGrupa["sapulces_laiks_no"]?>" size=5>
				<strong>-</strong>
				<input type=text name="sapulces_laiks_lidz" value="<?=$rGrupa["sapulces_laiks_lidz"]?>" size=5>
				</font>
			</td>
		</tr>
		<!--
		<tr>
			<td align=right><font size=2><strong>Iebrauc Lietuv�:</strong></td>
			<td align=left><input type=text name=polijas_dat value="<%=TimePrint(rGrupa("polijas_dat"))%>" size=15></td>
		</tr>-->
		<!--
		<tr>
			<td align=right><font size=2><strong>Grupu v�c l�dz:</strong></td>
			<td align=left><input type=text name=vac_dat value="<%=TimePrint(rGrupa("vac_dat"))%>" size=15></td>
		</tr>-->
		<tr>
			<td align=right><font size=2><strong>1. termiņš:</strong></td>
			<td align=left><input type=text name=term1_dat value="<?date('d.m.Y',strtotime($data["term1_dat"]))?>" size=15>
			<strong><font size=2>1. summa <?$data["valuta"]?>:</strong>
			<input type=text name=term1_summa value="<?=$rGrupa["term1_summa"]?>" size=5>
			<strong><font size=2>zaud. <?$data["valuta"]?>:</strong>
			<input type=text name=term1_zaud_summa value="<?=$rGrupa["term1_zaud_summa"]?>" size=5>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>2. termiņš:</strong></td>
			<td align=left><input type=text name=term2_dat value="<?date('d.m.Y',strtotime($data["term2_dat"]))?>" size=15>
			<strong><font size=2>2. summa <?$data["valuta"]?>:</strong>
			<input type=text name=term2_summa value="<?=$rGrupa["term1_summa"]?>" size=5>
			<strong><font size=2>zaud. <?$data["valuta"]?>:</strong>
			<input type=text name=term2_zaud_summa value="<?=$rGrupa["term1_zaud_summa"]?>" size=5>			
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Apmaksas gala termiņš:</strong></td>
			<td align=left><input type=text name=term3_dat value="<?date('d.m.Y',strtotime($data["term3_dat"]))?>" size=15>
			</td>
		</tr>
		<!-- cik pieteikumi? -->
		<?
		$query = "select count(*) from piet_saite where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and gid = ?)";
		$params = $data["id"];
		$piet_saite_sk = $db->Query($query,$params);
		if ($piet_saite_sk > 1 && strtoupper(substr($data["kods"],4,1)) == "P" || strtoupper(substr($data["kods"],4,1)) == "S") {
			$query = "select sum(summaLVL) as lvl,sum(summaUSD) as usd,sum(summaEUR) as eur from pieteikums where deleted = 0 and gid = '?'";
			$params = strval($data["id"]);
			$rcenas = $db->Query($query,$params); 
			?>
			<tr>
				<td align=right><font size=2><strong>Cena EUR:</strong></td>
				<td><input type=hidden name=i_cena_eur value="<?=$rGrupa["i_cena_eur"]?>" size=8><?=$rcenas["eur"]?></td>
			</tr>
		<?}else{?>
			<tr>
			<td align=right><font size=2><strong>Cena EUR:</strong></td>
			<td><input type=text name=i_cena_eur value="<?=$rGrupa["i_cena_eur"]?>" size=8></td>
			</tr>
				<tr>
			<td align=right><font size=2><strong>Pēdējās dienas cena EUR:</strong></td>
			<td><input type=text name=pm_cena value="<?=$rGrupa["pm_cena"]?>" size=8></td>
			</tr>
			<tr>
			<td align=right><font size=2><strong>Pēdējās vietas dzimums:</strong></td>
			<td>
				<select name="ped_vietas_dzimums">
					<option value=""></option>
					<option value="S" <? if ($rGrupa["ped_vietas_dzimums"] == "S") {
						echo ("selected"); }?>>Sieviete</option>
					<option value="V" <? if ($rGrupa["ped_vietas_dzimums"] == "V") {
						echo ("selected");} ?>>Vīrietis</option>
				</select>
			</td>
			</tr>
		<?}?>
		<tr>
			<td align=right><font size=2><strong>Vietas autobusā:</strong></td>
			<td align=left><input type=text name=vietsk value="<?=$rGrupa("vietsk")?>" size=3>
			  <font size=2><strong>Vietas naktsmītnēs:</strong>
			  <input type=text name=vietsk_nakts value="<?=$rGrupa["vietsk_nakts"]?>" size=3>
			  <font size=2><strong>Avio vietas:</strong>
			  <input type=text name=avio_vietas value="<?=$data["avio_vietas"]?>" size=3>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>1. Vadītājs:</strong></td>
			<td>
			 <select name=vaditajs>
			  <option value=0>Nav norādīts</option>
			  <? 
			   $query = "select * from grupu_vaditaji where deleted=0 order by vards, uzvards";
			   $rVaditaji = $db->Query($query);
			   foreach($rVaditaji as $vaditajs){
			    ?><option 
			    <? if ($rGrupa["vaditajs"] == $rVaditajs["idnum"]) { 
					echo (" selected ");?>
			    value=<?=$rVaditajs["idnum"]?>><?=$rVaditajs["vards"] ." ". $rVaditajs["uzvards"]?></option><?
			   }
			}?>
			 </select>
			 <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
			 <input type=hidden name=vad size=15 value="<?=$rGrupa["vad"]?>"><?=$rGrupa["vad"]?>
			  <a href="c_grupu_vad_grafiks.php?datums=<?=date('Y',strtotime($rGrupa["sakuma_dat"]))?>_<?=date('m',strtotime($rGrupa["sakuma_dat"]))?>" target="_blank">Skatīt grupas vadītāju grafiku</a></td> 
		</tr>
		<tr>
		<td align=right><font size=2><strong>1. Vadītājs:</strong></td>
			<td>
			 <select name=vaditajs>
			  <option value=0>Nav noradīts</option>
			  <? 
			   $query = "select * from grupu_vaditaji where deleted=0 order by vards, uzvards";
			   $rVaditaji = $db->Query($query);
			   foreach($rVaditaji as $vaditajs){
			    ?><option 
			    <? if ($rGrupa["vaditajs"] == $rVaditajs["idnum"]) { 
					echo (" selected ");?>
			    value=<?=$rVaditajs["idnum"]?>><?=$rVaditajs["vards"] ." ". $rVaditajs["uzvards"]?></option><?
			   }
			}
			  ?>
			 </select>
			 <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Kurators:</strong></td>
			<td><select name=kurators>
			  <option value="0">-</option>
			  <?$query = "select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12) order by vards ";
			  $rKuratori = $db->Query($query);
			  foreach($rKuratori as $rKurators)
			  {
			   echo "<option value=" . strval($rKurators["id"]) ." ";
			   if ($rKurators["id"] == $rGrupa["kurators"]){
					echo " selected ";
			   }
				echo ">" . $rKurators["uzvards"] ." ". $rKurators["v"];
				echo "</Option>";
			  }
			  ?></select>
			</td>
		</tr>
		<? if (substr($data["kods"],4,1) == "V" || substr($data["kods"],4,1) == "T") { ?>
		<tr>
			<td align=right><font size=2><strong>Kavētāju meklētājs:</strong></td>
			<td><? 'response.write(getnum(rGrupa("kontrolieris")))response.write("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by vards ")'?> 
			  <select name=kontrolieris>
			  <option value="0">-</option>
			  <? $query = "select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by vards ";
			  	$rKuratori = $db->Query($query);
			  ?>
			  <?foreach($rKuratori as $rKurators)
			  {
				echo "<option value=" . strval($rKurators["id"]) . " ";
				if ($rKurators["id"] == intval($rGrupa["kontrolieris"])) {
					echo " selected ";
				}
				echo ">" . rKurators("uzvards") . " " . rKurators("v");
				echo "</Option>";
			  }
			  ?></select>&nbsp;
			  <input type="image" src="impro/bildes/diskete.jpg" alt="Saglabāt izmaņas laukā - Kavētāju meklētājs." onclick="javascript: TopSubmit('grupa_save.asp?kontrolieris='+ forma.kontrolieris.value)" name="save_kontrolieri">
			  
			</td>
		</tr>
		<? }else {?>
		 <input type=hidden value=<?=$rGrupa["kontrolieris"]?> name=kontrolieris>
		<? }?>
		<tr>
			<?'<td align=right><font size=2><strong>Starpnieks:</strong></td>
			<td>
			 <input type=text name=starpnieks size=6 value="<%=rGrupa("starpnieks")%>">'?>
			 <?
			 if(!is_null($rGrupa["starpnieks"])) {
				 $query = "select * from dalibn where id = ". strval($rGrupa["starpnieks"]);
			  $rStarpnieki = $db->Query($query);
			  foreach($rStarpnieki as $rStarpnieks)
			  {
			   ?><a href=dalibn.asp?i=<?=$rStarpnieks["id"]?> target=_new><?
			   echo $rStarpnieks["vards"] . " ";
			   echo $rStarpnieks["uzvards"] . " ";
			   echo $rStarpnieks["nosaukums"];
			   ?></a><?
			  }}
			 ?>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Autobuss:</strong></td>
			<td align=left>
				<select name=autobuss_id  style="width:40%;">
				<option value=0>Nav norādīts</option>
				<? 
				$query = "select autobusi.nosaukums as anos, partneri_auto.nosaukums as pnos,autobusi.id from Autobusi,partneri_auto where autobusi.partneris = partneri_auto.id and autobusi.deleted=0 order by pnos,autobusi.nosaukums";
				$rAutobusi = $db->Query($query);
				foreach($rAutobusi as $rAutobuss){
					?><option 
					<? if ($rAutobuss["id"] == $rGrupa["autobuss_id"]){
						 echo " selected ";
					}?>
					value=<?=$rAutobuss["id"]?>><?=$rAutobuss["pnos"] . " - " . $rAutobuss["anos"];?></option>
					</select><font size=2> 
					<a href="c_autobusi.php" target="autobusi"> Labot</a>
					<font size=2><strong> A.piezīmes: </strong></font><input name=autobuss  value="<?=$rGrupa["autobuss"]?>"/>
				<!--<input type=hidden name=autobuss value="<%=rGrupa("autobuss")%>" size=8><%=rGrupa("autobuss")%>-->
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Ķēde:</strong></td>
			<td align=left><select name="kede">
			<option></option>
			<? for( $i=1; $i < 25; $i++) {
				?><option value="<?=$i?>" <? if ($rGrupa["kede"] == strval($i)) {
					echo "selected";
				}?>><?=$i?>.</option><?
			}?></select></td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Dokumenti:</strong></td>
			<td align=left><textarea name=dokumenti cols=70 rows=3><?=$rGrupa["dokumenti"]?></textarea>
			</td>
		</tr>
			<? if(IsAccess("T_GRUPU_PAPILD_INFO")) { ?>
			<tr><td colspan=2><hr></td></tr>
			
		<tr>
			<td align=right><font size=2><strong>Pazīme:</strong></td>
			<td align=left><input type=text name=ln value="<?=trim($rGrupa["ln"])?>" maxlength=1 size=1>
			<strong><font size=2>Vadītājs:</strong>
			<select name=vad_id>
				<option value="">-</option>
				<? 
				foreach($rVaditaji as $rVaditajs)
				{
				 echo "<option value=" . strval($rVaditajs["id"]) . " ";
				 if($rVaditajs["id"] == $rGrupa["vad_id"]) {
					 echo " selected ";
				 }
				 echo ">".  $rVaditajs["vards"] . " " . $rVaditjas["uzvards"];
				 echo "</Option>";
				}?>
			</select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Papildus piezīmes:</strong></td>
			<td align=left><input type=text name=piezimes2 value="<?=$rGrupa["piezimes2"]?>"  size=35>
		<? } ?>	
		<tr>
			<td align=right><font size=2><strong>Pazīmes:</strong></td>
			<td align=left><input type=text name=pazimes value="<?=$rGrupa["pazimes"]?>"  size=10> (D - dāvanu karte)
		</tr>
		<tr>
			<td align=right></td>
			<td align=left></td>
		</tr>

		</table>
	</td>
	<td valign=top>
		<li><a href = 'grupa_param.asp<?='qstring()'?>'><font color="GREEN" size="3"><b>Grupas saraksts</b></font></a></li>
		<? if(rGrupa("kajites_gid") != 0) { ?>
			<li><a href = 'kajite.asp?gid=<?=$rGrupa["kajites_gid"]?>'><font color="GREEN" size="3"><b>Kajītes</b></font></a></li>
			<li><a href = 'kajites_veidi.asp?gid=<?=$rGrupa["kajites_gid"]?>'><b><font color = "GREEN">Kajīšu veidi</b></font></a></li>
		<? }else{ ?>
			<li><a href = 'kajite.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Kajītes</b></font></a></li>
			<li><a href = 'kajites_veidi.asp?gid=<?=$data["id"]?>'><b><font color = "GREEN">Kajīšu veidi</b></font></a></li>
		<? } ?>
		<li><a href = 'viesnicas.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Viesnicu numuri</b></font></a></li>
			<li><a href = 'viesnicas_veidi.asp?gid=<?=$data["id"]?>'><b><font color = "GREEN">Viesnicu numuru veidi</b></font></a></li>
		<li><a href = 'vietu_veidi.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></li>
		<li><a href = 'limits.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Vietu ierobe�ojumi</b></font></a></li>
		<li><a href = 'pieteikumi_grupaa.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Pieteikumi grup�</b></font></a></li>
		<li><a href="pieteikumi_grupaa.asp?gid=<?=$data["id"]?>&mode=ligums"><font color="GREEN" size="3"><b>L�gumi</b></font></a></li>
		<? if($rGrupa["veids"] == "1"){ ?>
		<li><a href = 'interesenti.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Interesenti</b></font></a></li>
		<? 
		}elseif(strlen($rGrupa["kods"]) > 4){
		  if (substr($rgrupa["kods"],4,1) == "P" || substr($rgrupa["kods"],4,1) == "S") {
		  ?><li><a href = 'kontakti.asp?gid=<?=$data["id"]?>'><font color="GREEN" size="3"><b>Kotaktpersonas</b></font></a></li><? 
			}
		} ?>
		<li><a href="grupa_voucer_edit.asp?gid=<?=$data["id"]?>"><font color="GREEN" size="3"><b>Vaučera rediģēšana</b></a></li>
		<li><a href="c_grupas_dati_nosutiti.php?gid=<?=$data["id"]?>"><font color="GREEN" size="3"><b>Grupas dati nosūtīti</b></a></li>
		<? if(IsAccess("T_CELOJUMU_APR")){ ?>
		<li><a href="c_celojuma_apraksts.php?gid=<?=$data["id"]?>"><font color="GREEN" size="3"><b>Ceļojuma apraksta pievienošana</b></a></li>
		<? } ?>
		<? if ($data["apraksts"] != "") {?>
		<br>
		<li><a href="http://www.impro.lv/pdf/<?=$data["apraksts"]?>.pdf" target="_blank"><font color="GREEN" size="3"><b>Ceļojuma apraksts</b></a></li>
		<? }?>
		<li><a href="c_grupas_sar_soc.php?gid=<?=$data["id"]?>" target="_blank"><font color="GREEN" size="3"><b>Saraksts sociālajiem tīkliem</b></a></lid>
		<!--<li><a href = 'piet_summas.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>P�rr��in�t summas</b></font></a></li>-->
		<br><br>
		<table>
		
			<?
			$query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " .
			" and gid = ". $data["id"] ." and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) and piet_saite.deleted = 0 " . 
			" and (kvietas_veids in (1,2,4,5) or persona = 1 )  and (not isnull(kvietas_veids,0) = 3)";
			$aizn_vietas = $db->Query($query);

			$personas = $db->Query($query . " and (not isnull(kvietas_veids,0) = 3)");

			$query = "select sum(piet_saite.vietsk) as sk " .
				"FROM grupa,pieteikums,piet_saite " .
				"WHERE grupa.id = ". strval($data["id"]) ."AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id and piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) );";
			$pap = $db->Query($query);

			$query = "select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where deleted = 0 and pid in (select id from pieteikums where gid = ". strval($data["id"]) .")";
			$riemaksas = $db->Query($query);

			$query = "select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where parbaude = 1 and deleted = 0 and pid in (select id from pieteikums where gid = ". strval($data["id"]) .")";
			$riemaksasN = $db->Query($query);

			$query = "select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd  from orderis where deleted = 0 and nopid in (select id from pieteikums where gid = ". strval($data["id"]) .")";
			$rizmaksas = $db->Query($query);

			
			$query = "select sum(atlaidesLVL) as atLVL, sum(atlaidesUSD) as atUSD, sum(atlaidesEUR) as atEUR, sum(atlaidesBIL) as atBIL, sum(sadardzinLVL) as piemLVL, sum(sadardzinUSD) as piemUSD, sum(sadardzinEUR) as piemEUR, sum(sadardzinBIL) as piemBIL, sum(summaLVL) as sumLVL, sum(summaUSD) as sumUSD, sum(summaEUR) as sumEUR, sum(iemaksasLVL) as iemLVL, sum(iemaksasUSD) as iemUSD, sum(iemaksasEUR) as iemEUR, sum(izmaksasLVL) as izmLVL, sum(izmaksasUSD) as izmUSD, sum(izmaksasEUR) as izmEUR, sum(bilanceLVL) as bilLVL, sum(bilanceUSD) as bilUSD, sum(bilanceEUR) as bilEUR from pieteikums where gid=". strval($data["id"]) ." and (deleted = 0) and (isnull(tmp,0)=0 OR agents_izv=1) and id in (select pid from piet_saite where deleted = 0)";
			$rnauda2 = $db->Query($query);
			?>
			<tr>
				<td align=right><font size=2><strong>Personas:</strong></td>
				<td ><font size=2><?=$personas["aizn"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Papildvietas:</strong></td>
				<td ><font size=2><?$pap["sk"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Brīvas vietas:</strong></td>
				<td ><font size=2><?='BrivasVietasGrupa(gid)'?>
				</td>
			</tr>
			<? 

			'if 1=1 then
			if rGrupa("veids") <> 2 and rGrupa("veids") <> 3 then 
			izmain�ts, ja viss b�s k�rt�b� else zaru j�met �r�'
			?>
			<tr>
				<td align=right><font size=2><strong>Jāmaksā:</strong></td>
				<td ><font size=2><font color=blue><?='Curr3Print2',$rnauda2["sumLVL"],$rnauda2["sumUSD"],$rnauda2["sumEUR"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Atlaides:</strong></td>
				 <td ><font size=2><font color=green><?='Curr3Print2',$rnauda2["atLVL"],$rnauda2["atUSD"],$rnauda2["atEUR"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Piemaksas:</strong></td>
				 <td ><font size=2><font color=blue><?='Curr3Print2',$rnauda2["piemLVL"],$rnauda2["piemUSD"],$rnauda2["piemEUR"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Faktiski jāmaksā:</strong></td>
				<td ><font size=2><font color=blue><?='Curr3Print2',$rnauda2["sumLVL"]-$rnauda2["atLVL"]+$rnauda2["piemLVL"],$rnauda2["sumUSD"]-$rnauda2["atUSD"]+$rnauda2["piemUSD"],$rnauda2["sumEUR"]-$rnauda2["atEUR"]+$rnauda2["piemEUR"]?></td>
			</tr>
			<!-- <% else %> -->
			<tr>
				<td align=right><font size=2><strong>Jāmaksā pieteikumos:</strong></td>
				<?'<td ><font size=2><font color=blue><?Curr3Print2,$rnauda2["sumLVL"],$rnauda2["sumUSD"],$rnauda2["sumEUR"]?></td>'?>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Jāmaksā:</strong></td>
				<td ><font size=2><font color=blue><?='Curr3Print2',$rGrupa["i_cena"],$rGrupa["i_cena_usd"],$rGrupa["i_cena_eur"]?></td>
			</tr>
			<!-- <% end if %> -->
			<tr>
				<td align=right><font size=2><strong>Iemaksāts:</strong></td>
				<td><nobr><font size=2 color=green><?='Curr3Print2',$rnauda2["iemLVL"],$rnauda2["iemUSD"],$rnauda2["iemEUR"]?></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Izmaksāts:</strong></td>
				<td ><nobr><font size=2><font color=blue><?='Curr3Print2',$rnauda2["izmLVL"],$rnauda2["izmUSD"],$rnauda2["izmEUR"]?></td>
			</tr>
			<? 
			'if 1=1 then 
			if rGrupa("veids") <> 2 and rGrupa("veids") <> 3 then' 
			?>
			<tr>
				<td align=right><font size=2><strong>Bilance:</strong></td>
				<td ><font size=2><b>
				<?if(rnauda2("bilLVL") < 0 || rnauda2("bilUSD") < 0 || rnauda2("bilEUR") < 0){ ?>
				 <font color=red>
				<?} else {?>
				 <font color=green>
				<? } ?>
				<?='Curr3Print2',$rnauda2["bilLVL"],$rnauda2["bilUSD"],$rnauda2["bilEUR"]?></td>
		    	</tr>
				<? 'else' ?>
			<tr>
				<td align=right><font size=2><strong>Bilance:</strong></td>
				<td ><font size=2><b>
				<?'if -getnum(rGrupa("i_cena"))+getnum(rnauda2("iemLVL"))-getnum(rnauda2("izmLVL"))<0 or -getnum(rGrupa("i_cena_usd"))+getnum(rnauda2("iemUSD"))-getnum(rnauda2("izmUSD"))<0 or -getnum(rGrupa("i_cena_eur"))+getnum(rnauda2("iemEUR"))-getnum(rnauda2("izmEUR"))<0 then ?>
				 <font color=red>
			   <?} else{ ?>
				 <font color=green>
				<? } ?>
				<?=Curr3Print2(-getnum(rGrupa("i_cena"))+getnum(rnauda2("iemLVL"))-getnum(rnauda2("izmLVL")),-getnum(rGrupa("i_cena_usd"))+getnum(rnauda2("iemUSD"))-getnum(rnauda2("izmUSD")),-getnum(rGrupa("i_cena_eur"))+getnum(rnauda2("iemEUR"))-getnum(rnauda2("izmEUR")))?></td>
			</tr>
			   <? } '?>
		</table><br><br>
		<table>
		 <tr><td colspan=2 align=center><b>Bilancei</td></tr>
		 <tr>
		  <td><font size=2><b>Iemaksas</td>
		  <?
		  
		  ?>
		  <td><font size=2><?=curr3total(riemaksas("lvl"),riemaksas("usd"),riemaksas("eur"))?>
		   <? 'if getnum(riemaksasN(0)) <> 0 then ?>
		    <BR>- <?=curr3total(riemaksasN("lvl"),riemaksasN("usd"),riemaksasN("eur"))?> (neapstiprināts) 
			<BR>= <b> <?=curr3total(getnum(riemaksas("lvl"))-getnum(riemaksasN("lvl")), getnum(riemaksas("usd"))-getnum(riemaksasN("usd")), getnum(riemaksas("eur"))-getnum(riemaksasN("eur")))?></b>
		   <?  '?>
		  </td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Izmaksas</td>
		  <td><font size=2><?=curr3total(rizmaksas("lvl"),rizmaksas("usd"),rizmaksas("eur"))?></td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Atlaides</td>
		  <td><font size=2><?=curr3total(rnauda2("atlvl"),rnauda2("atusd"),rnauda2("ateur"))?></td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Piemaksas</td>
		  <td><font size=2><?=curr3total(rnauda2("piemlvl"),rnauda2("piemusd"),rnauda2("piemeur"))?></td>
		 </tr>
		</table>
	</td>

	</tr>
</table>
<center>
<?if ($gr_lab1){ ?> 
 <input type=image src="impro/bildes/diskete.jpg" alt="Saglabāt izmaiņas.">
<? } ?>
<input type=image src="impro/bildes/aizvert.bmp" alt="Aizvērt logu. Atgriezties uz sarakstu." onclick="window.close();return false;">
<a href="vesture.asp?tabula=grupa&id=<%=gid%>" target=vesture><img style="border:0px" src="impro/bildes/clock.bmp" alt="Vēsture"></a>
<?
$query = "select isnull(count(id),0) as x from pieteikums where deleted = 0 and gid = ". strval($data["id"]);
$r = $db->Query($query);
if ($r["x"] == 0){
	?>
	<a href="grupa_del.asp?gid=<%=gid%>"><img style="border:0px" onclick="return confirm('Dzēst grupu?');" src="impro/bildes/dzest.jpg" alt="Dzest"></a>
	<?
}
?>

</body> 
</html>