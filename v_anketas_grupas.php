<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Anketas","y1.jpg");
DefJavaSubmit();?>

<font face=Tahoma>
<Center><font size=4>Anketas</font><br><br>

<?if (count($data['grupas'])){
	foreach($data['grupas'] as $row){
		
	?>
		<a href=c_anketas.php?gid=<?=$row["ID"];?>>			
			<?=$db->Date2Str($row["sakuma_dat"]) . " " . $row["v"]." ".$row["kods"];?>
		</a>
		<br>
		
<?	}
}
else echo "Grupas ar anketâm pçc ievadîtajiem kritçrijiem nav atrastas"?>

<br><br>

<a href=anketa_grupa.asp>Uz anketçjamo grupu meklçðanu</a><br>
<a href=default.asp>Uz mâjâm</a>