<?php
if (!isset($_POST['submit'])) { 
?>

<html>
<head>
	<title>Hokeja anketa</title>
    <meta http-equiv="content-type" content="text/html; charset=windows-1257">
</head>
<script language="javascript">

	function verify(pForm){
		
		if ((pForm.vards.value!='')){

			return true;	

		}else{
			alert('Lūdzu aizpildiet obligātos(*) laukus');
			return false;
		}
	}
</script>
<body>
<center>

<form name=forma method="post" action="<?php echo $PHP_SELF;?>">

	
	<table cellspacing=10 style="border: 1px solid grey">
		
		<tr>
			<td colspan=2 align=left><img src="logo.jpg" ></td>
		</tr>
		<tr>
			<td><b>1. Vārds, uzvārds,</b> iesauka vai uzraksts uz krekla...</td>
			<td><b>personas kods</b></td>
		</tr>
		<tr>
			<td>* <input type=text name=vards size="80%"></td>
			<td><input type=text name=pkods1 size=6 maxlength=6>&nbsp;&nbsp;
			<input type=text name=pkods2 size=5 maxlength=5></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=2 align=center>
			
			<table>
				<tr>
					<td align=center colspan=2><b>2. Kopā ar <i>IMPRO</i> grupu esmu apmeklējis</b></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><input type=checkbox name="chk1" value="Pasaules čempionātu hokejā 1999.gadā Norvēģijā"> Pasaules čempionātu hokejā 1999.gadā Norvēģijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk2" value="Pasaules čempionātu hokejā 2000.gadā Krievijā"> Pasaules čempionātu hokejā 2000.gadā Krievijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk3" value="Pasaules čempionātu hokejā 2001.gadā Vācijā"> Pasaules čempionātu hokejā 2001.gadā Vācijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk4" value="Pasaules čempionātu hokejā 2002.gadā Zviedrijā"> Pasaules čempionātu hokejā 2002.gadā Zviedrijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk5" value="Pasaules čempionātu hokejā 2003.gadā Somijā"> Pasaules čempionātu hokejā 2003.gadā Somijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk6" value="Pasaules čempionātu hokejā 2004.gadā Čehijā"> Pasaules čempionātu hokejā 2004.gadā Čehijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk7" value="Pasaules čempionātu hokejā 2005.gadā Austrijā"> Pasaules čempionātu hokejā 2005.gadā Austrijā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk8" value="Olimpisko kvalifikācijas turnīru Klāgenfurtē"> Olimpisko kvalifikācijas turnīru Klāgenfurtē</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk9" value="Eurochallenge turnīru Minskā"> Eurochallenge turnīru Minskā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk10" value="Eurochallenge turnīru Kijevā"> Eurochallenge turnīru Kijevā</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="chk11" value="2006. gada ziemas olimpisko spēļu hokeja turnīru Turīnā"> 2006. gada ziemas olimpisko spēļu hokeja turnīru Turīnā</input></td>
				</tr>				
			</table>

			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=2 align=center>
			
			<table>
				<tr>
					<td align=center colspan=2><b>3. Vislabprātāk apmeklētu</b></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td><input type=checkbox name="ck1" value="spēli 05.05.06 LAT - CZE (FIN - SLO)"> spēli 05.05.06 LAT - CZE (FIN - SLO)</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="ck2" value="spēli 07.05.06 FIN - LAT (CZE - SLO)"> spēli 07.05.06 FIN - LAT (CZE - SLO)</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="ck3" value="spēli 05.05.06 SLO - LAT (CZE - FIN)"> spēli 05.05.06 SLO - LAT (CZE - FIN)</input></td>
				</tr>				
				<tr>
					<td><input type=checkbox name="ck4" value="nav būtiski"> nav būtiski</input></td>
				</tr>				
				
			</table>

			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=2 align=center><b>4. Jūsu kontaktinformācija </b>(tālrunis, e-pasts u.c)</td>
		</tr>
		<tr>
			<td width="100%" colspan=2 align=center><TEXTAREA NAME="kontakti" COLS=80 ROWS=6></TEXTAREA></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan=2 align=center><input type=submit name=submit value="Nosūtīt" onclick="return verify(document.forma);"></td>
		</tr>
	

	</table>
</form>
</center>
</body>
</html>
<?
} else { 



	$vards = $_POST["vards"];
	$pkods1 = $_POST["pkods1"];
	$pkods2 = $_POST["pkods2"];
	$kontakti = $_POST["kontakti"];
	
	$body1 = "";

	for($i=1;$i<=11;$i++){
		if (isset($_POST["chk".$i])){
			$body1 .= "\r\n ". $_POST["chk".$i];
		}
	}

	$body2 = "";

	for($i=1;$i<=4;$i++){
		if (isset($_POST["ck".$i])){
			$body2 .= "\r\n ". $_POST["ck".$i];
		}
	}
	
	$to = "hokejs@impro.lv";
	$subject = "Hokeja anketa";
	$body = "VĀRDS, UZVĀRDS, iesauka vai uzraksts uz krekla: $vards 
		
		PERSONAS KODS: $pkods1-$pkods2
		
		APMEKLĒJIS:
		$body1

		VISLABĀK APMEKLĒTU:
		$body2
		
		KONTAKTINFORMĀCIJA:
		$kontakti
		";
	if (mail($to, $subject, $body)) {
		echo "<center><b>Anketa ir nosūtīta. Paldies!</b></center>";
	} else {
		echo "<center><b>Kļūda! Anketa nav nosūtīta.</b></center>";
	}

}
?> 
