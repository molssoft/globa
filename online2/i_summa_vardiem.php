<?
/*function galotne($num,$vsk,$dsk)
{
	$s = $dsk;
	if (cipars($num,1)=='1') 
		$s = $vsk;
	if (cipars($num,2)=='1') 
		$s = $dsk;
	return $s;
}


function cipars($num,$k)
{
$num = floor($num);
if (strlen($num)<$k)
	return 0;
return substr($num,strlen($num)-$k,1);
}

function simts($num) {
	$vieni[1]="viens";
	$vieni[2]="divi";
	$vieni[3]="trîs";
	$vieni[4]="èetri";
	$vieni[5]="pieci";
	$vieni[6]="seði";
	$vieni[7]="septiòi";
	$vieni[8]="astoòi";
	$vieni[9]="deviòi";
	$celms[1]="vien";
	$celms[2]="div";
	$celms[3]="trîs";
	$celms[4]="èetr";
	$celms[5]="piec";
	$celms[6]="seð";
	$celms[7]="septiò";
	$celms[8]="astoò";
	$celms[9]="deviò";
	$desm = cipars($num,2);
	$vien = cipars($num,1);
	
	if ($desm == 0) {
		$s = $vieni[$vien]." ";
	}
	if ($desm==1){
		if ($vien!=0) {
			$s=$celms[$vien]."padsmit ";
		}
		else
		{
			$s="desmit ";
		}
	}
	if ($desm>1) {
		if (cipars($num,1)!=0) 
			$s=$celms[$desm]."desmit ".$vieni[$vien]." ";
		else
			$s=$celms[$desm]."desmit ";
	}
	$sim = cipars($num,3);
	if ($sim!=0) 
		$s = $vieni[$sim]." ".galotne($sim,"simts ","simti ").$s;

	return $s;
}

function nauda($num, $valuta_l, $valuta_mv, $valuta_md) {

	$milj = floor($num/1000000);
	if ($milj>0) 
		$s = $s . simts($milj) . galotne($milj,"miljons ","miljoni ");
	
	$tukst = floor($num/1000);
	if ($tukst>0) 
		$s = $s . simts($tukst) . galotne($tukst,"tûkstotis ","tûkstoði ");
	
	$s = $s . simts($num) . $valuta_l . " ";
	$sant = floor($num * 100);
	$s = $s . cipars($sant,2) . cipars($sant,1) . " " . galotne($sant,$valuta_mv,$valuta_md);
	return $s;
}
*/
?>




