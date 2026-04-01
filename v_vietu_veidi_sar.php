<?require_once("i_functions.php");
//standarts visaam lapaam
//Docstart ("Grupas dati nosūtīti","y1.jpg");
DefJavaSubmit();?>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<META NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080" >
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?><? if (isset($data)){
	require_once("online2/i_functions.php");?>
<center>
<div class="no-print">
	<?
	$params = (!empty($vietu_veidi) ? http_build_query($vietu_veidi) : "'vv=".$vietas_veids);
	if ($data['kartot_pec'] == 'datums'){
		?>
		<a href="c_vietu_veidi.php?kartot_pec=vards" class="no-print">Sakārtot alfabētiski</a>
	<?}
	else{?>
		<a href="c_vietu_veidi.php?kartot_pec=datums" class="no-print">Sakārtot pēc pieteikuma datuma</a>
	<?}
	?>
	<br>
</div>

<center><h4><?=$data['grupas_nos'];?><br><?=(isset($data['vv']) ? $data['vv']['nosaukums'] : '');?></h4>


<style>
  .rotated-text {
    display: inline-block;
    overflow: hidden;
    width: 1.5em;

}
.rotated-text__inner {
	text-align:left;
    display: inline-block;
    white-space: nowrap;
    /* this is for shity "non IE" browsers
       that doesn't support writing-mode */
    -webkit-transform: translate(1.1em,0) rotate(90deg);
       -moz-transform: translate(1.1em,0) rotate(90deg);
         -o-transform: translate(1.1em,0) rotate(90deg);
            transform: translate(1.1em,0) rotate(90deg);
    -webkit-transform-origin: 0 0;
       -moz-transform-origin: 0 0;
         -o-transform-origin: 0 0;
            transform-origin: 0 0;
   /* IE9+ */
   -ms-transform: none;
   -ms-transform-origin: none;
   /* IE8+ */
   -ms-writing-mode: tb-rl;
   /* IE7 and below */
   *writing-mode: tb-rl;
}
.rotated-text__inner:before {
    content: "";
    float: left;
    margin-top: 100%;
}

/* mininless css that used just for this demo */
.container {
  float: left;
}

td,th,table {
font-size:11pt;
	border-collapse: collapse;
	padding: 2px;
	border-width:0.25pt;
}

</style>



<table class="rotate-table-grid" border="1"><!--style="font-size:12px"-->
	<tr>
		<th>Nr.</th>
		<th>Uzvārds</th>
		<th>Vārds</th>

		<th>Dzimšanas datums</th>
		<th>Mobilais tālr.</th>
		<th>Piet. datums</th>
		<? if (isset($data['vv_arr'])){
			foreach($data['vv_arr'] as $val){
				?>
				<th style="vertical-align:bottom"><div class="rotated-text"><span class="rotated-text__inner"><?=$val['nosaukums'];?></span></div></th>
				<?
				
			}
		}?>
	</tr>
  <? $i = 1;
  foreach ($data['pieteikumi'] as $row){
		?>
	  <tr >
		<td><?=$i++;?>.</td>
		<td><?=$row['uzvards'];?></td>
		<td>
			<?=$row['vards'];?>
		</td>
		<td><?=$db->Date2Str($row['dzimsanas_datums']);?></td>
		<td><?=$row['talrunisMobvalsts'].$row['talrunisMob'];?></td>
		<td><?=$db->Date2Str($row['piet_datums']);?></td>
		<? if (isset($data['vv_arr'])){
			foreach($data['vv_arr'] as $val){
			?>
			<td>
			<? 
				$count = $row['vv'.$val['id']];
				if ($count == 0) echo "&nbsp"; 
				if ($count == 1) echo "&#10004;"; 
				if ($count > 1) echo "<font color=red>" . $count . "</font>"; 
			?>
			</td>
			<?
			}
		}?>
	</tr>
	<?}?>
  </table>
<?}?>
</body>
</html>