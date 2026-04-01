<?function Decode($string){
    $newString = $string;

	 $newString = str_replace("#a","â",$newString);
	 $newString = str_replace("#c","è",$newString);
	 $newString = str_replace("#e","ç",$newString);
	 $newString = str_replace("#g","ì",$newString);
	 $newString = str_replace("#i","î",$newString);
	 $newString = str_replace("#k","í",$newString);
	 $newString = str_replace("#l","ï",$newString);
	 $newString = str_replace("#n","ò",$newString);
	 $newString = str_replace("#s","ð",$newString);
	 $newString = str_replace("#u","û",$newString);
	 $newString = str_replace("#z","þ",$newString);
	 $newString = str_replace("#A","Â",$newString);
	 $newString = str_replace("#C","È",$newString);
	 $newString = str_replace("#E","Ç",$newString);
	 $newString = str_replace("#G","Ì",$newString);
	 $newString = str_replace("#I","Î",$newString);
	 $newString = str_replace("#K","Í",$newString);
	 $newString = str_replace("#L","Ï",$newString);
	 $newString = str_replace("#N","Ò",$newString);
	 $newString = str_replace("#S","Ð",$newString);
	 $newString = str_replace("#U","Û",$newString);
	 $newString = str_replace("#Z","Þ",$newString);
 
    return $newString;
}
?>