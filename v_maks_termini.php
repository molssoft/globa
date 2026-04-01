<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Maksâjumu termiòi","y1.jpg");
DefJavaSubmit();?>

<font face=Tahoma>


<? if (!empty($data['termini'])){
?>
<h4>Maksâjumu termiòi</h4>
<ol>
<? $i=1; 
foreach($data['termini'] as $termins){
	$when = "Lîdz <b>".$termins['datums']."</b>";
	if ($i==1){
		$how_much = "<b>".$termins['summa']." ".$data['grupa']['valuta']."</b>";
		$when = 'Piesakoties';
	}
	else if ($i== count($data['termini'])){
		$how_much = "pilna summa: <b>".$termins['summa']." ".$data['grupa']['valuta']."</b>";
	}
	else{
			$how_much = 'vçl '."<b>".$termins['summa']." ".$data['grupa']['valuta']."</b>";
	}?>
	<li><?=$when;?> jâiemaksâ <?=$how_much?></li>
<?
	$i++;
}?>
	
</ol>
<?
}?>
<!--Ðobrîd jâiemaksâ <b><?=CurrPrint($data['min_summa'])." ".$data['grupa']['valuta'];?></b-->

<?


?>
