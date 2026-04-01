
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
gid=Request.QueryString("gid")+""
if gid="" then
	message = "Nav norādīta grupa!"
end if

%>

<html>
<% docstart "Pieteikums","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Grupas saraksta parametri <%=pid%></b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>
<% headlinks 
DefJavaSubmit %>
<head>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<meta NAME="Generator" CONTENT="Microsoft Word 97">
<meta NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
</head>
<body LINK="#0000ff" VLINK="#800080">

<center>
<font size="4"><%=message%></font><br>

<form name="forma" method="POST" action="grupa_dal.asp<%=qstring()%>">
<table>
    <tr bgcolor=#ffc1cc>
     <td align=center colspan=2>Kolonnas</td>
     <td align=center>Iespējas</td>
    </tr>
	<tr>
	 <td align="left" valign="top" bgcolor="#fff1cc">
		<input type="checkbox" name="vards" value="yes" checked>
		Vārds*
		<BR><input type="checkbox" name="uzvards" value="yes" checked>
		Uzvārds*
		<BR><input type="checkbox" name="zidainis" value="yes">
		Zīdainis
		<BR><input type="checkbox" name="pk" value="yes">
		<font color="magenta">Personas kods*</font>
		<BR><input type="checkbox" name="pase" value="yes">
		<font color="magenta">Pases dati*</font>
		<BR><input type="checkbox" name="pases_der" value="yes">
		<font color="magenta">Pases derīguma term.*</font>
		<BR><input type="checkbox" name="id_karte" value="yes">
		<font color="magenta">ID kartes dati*</font>
		<BR><input type="checkbox" name="id_der" value="yes">
		<font color="magenta">ID derīguma term.*</font>
		<BR><input type="checkbox" name="dokumenti" value="yes">
		<font color="magenta">Dokumenti*</font>
		<BR><input type="checkbox" name="dzimsanas_datums" value="yes">
		Dzimšanas datums*
		<BR><input type="checkbox" name="talrunism" value="yes">
		<font color="brown">Mājas tālrunis*</font>
		<BR><input type="checkbox" name="talrunisd" value="yes">
		<font color="brown">Darba tālrunis*</font>
		<BR><input type="checkbox" name="talrunisMob" value="yes">
		<font color="brown">Mobilais tālrunis*</font>
		<BR><input type="checkbox" name="epasts" value="yes">
		<font color="brown">E-pasts*</font>
		<BR><input type="checkbox" name="adrese" value="yes">
		<font color="brown">Adrese*</font>
		<BR><input type="checkbox" name="dalibn_piezimes" value="yes">
		<font color="blue">Dalībnieka piezīmes*</font>
		<BR><input type="checkbox" name="piezimes" value="yes" >
		<font color="blue">Pieteikuma piezīmes*</font>
		<BR><input type="checkbox" name="visas" value="yes">
		<font color="blue">Vīzas*</font>
	 </td>
	 <td align="left" valign="top" bgcolor="#fff1cc">
		<input type="checkbox" name="jamaksa" value="yes" onclick="$('#kopsumma').prop( 'checked', true );">
		<font color="green">Jāmaksā</font>
		<BR><input type="checkbox" name="iemaksas" value="yes" onclick="$('#kopsumma').prop( 'checked', true );">
		<font color="green">Iemaksu vēsture</font>
		<BR><input type="checkbox" name="summa" value="yes" onclick="$('#kopsumma').prop( 'checked', true );">
		<font color="green">Iemaksu kopsumma</font>
		<BR><input type="checkbox" name="cena" value="yes">
		<font color="green">Bāzes cena</font>
		<BR><input type="checkbox" name="atlaides" value="yes">
		<font color="green">Atlaides/piemaksas</font>
		<BR><input type="checkbox" name="bilance" value="yes" onclick="$('#kopsumma').prop( 'checked', true );">
		<font color="green">Bilance</font>
		<BR><input type="checkbox" name="neapstiprinatas" value="yes" >
		<font color="green">Neapstiprinātas op.</font>
		<BR><input type="checkbox" name="vardadienas" value="yes">
		<font color="red">Vārda diena*</font>
		<BR><input type="checkbox" name="dzimsanas_diena" value="yes">
		<font color="red">Dzimšanas diena*</font>
		<BR><input type="checkbox" name="gdatumi" value="yes">
		Grupas datumi
		<BR><input type="checkbox" name="datums" value="yes">
		Pieteikuma datums*
		<BR><input type="checkbox" name="kajite" value="yes">
		Kajīte
		<BR><input type="checkbox" name="pakalpojumi" value="yes">
		Papildus pakalpojumi		
		<BR><input type="checkbox" name="pakalpojumi_det" value="yes">
		Visi papildus pakalpojumi
	 </td>
	 <td align="left" valign="top" bgcolor="#fff1cc">
		<input type="checkbox" name="mazie" value="yes">
		Ar maziem burtiem
		<BR><input type="checkbox" name="tikai_kajites" value="yes">
		Tikai kajītes		
		<BR><input type="checkbox" name="papildvieta" value="yes">
		Papildvieta*
		<BR><input type="checkbox" name="vienureizi" value="yes">
		Katra persona vienu reizi
		<BR><input type="checkbox" name="blitkas" value="yes">
		Breletes
		<BR><input type="checkbox" name="anglu" value="yes">
		Angļu burtiem
		<BR>No datuma:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<BR>Līdz datumam:<input type="text" name="datums_lidz" maxlength="10" size="10"></input>
		<BR><input type="checkbox" name="ar_atlikumu" value="yes">
		Tikai ar atlikumiem
		<BR><input type="checkbox" name="ligums" value="yes">
		Līguma nr.
		<BR><input type="checkbox" name="saites" value="yes">
		Iekļaut saites uz dalībniekiem
		<BR><input type="checkbox" name="kopsumma" value="yes"  id="kopsumma">
		Rādīt summu
		<BR><input type="checkbox" name="borders" value="yes"  id="borders">
		Biezākas līnijas
		<BR><input type="checkbox" name="vaditajs" value="yes"  id="vaditajs">
		Iekļaut grupas vadītāju
		<BR><a href="c_grupa_email.php?gid=<%=gid%>">
		Epasta adreses vienā rindā</a>
	 </td>
	</tr>
	<tr>
	 <td align="left" bgcolor="#fff1cc"></td>
	 <td align="left" bgcolor="#fff1cc"></td>
	 <td align="left" bgcolor="#fff1cc">.</td>
	</tr>	
	<tr>
	 <td align="left" bgcolor="#fff1cc"></td>
	 <td align="left" bgcolor="#fff1cc"></td>
	 <td align="left" bgcolor="#fff1cc">.</td>
	</tr>	
	<tr>
		<td align="center" colspan=3 bgcolor="#fff1cc">
			<input type="radio" name="sort" value="uzvards">Sakārtot pēc uzvārda<br>
			<input type="radio" name="sort" value="piezimes">Sakārtot pēc piezīmēm<br>
			<input type="radio" name="sort" value="datums" checked>Sakārtot pēc pieteikuma datuma
		</td>
	</tr>
</table>
	<input type="submit" value="Dalībnieki" name="dalibnieki" src="impro/bildes/dalibnieki.jpg" alt="Parāda grupas dalībnieku izdrukas formu ar izvēlētajiem laukiem" onclick="TopSubmit(&quot;grupa_dal.asp<%=qstring()%>&quot;)" WIDTH="116" HEIGHT="25">
	<input type="submit" value="Uzlīmes" name="uzlimes" src="impro/bildes/uzlimes.jpg" alt="Parāda grupas dalībnieku vārdu un adresu izdrukas formu. Izvēlētajiem laukiem nav nozīmes" onclick="TopSubmit(&quot;uzlimes.asp<%=qstring()%>&quot;)" WIDTH="116" HEIGHT="25">
	<!--<input type="submit" value="Lejupielādēt word failu*" name="word" onclick="TopSubmit('php8/generate_grupa_doc.php<%=qstring()%>')">-->
	<!--
	<input type="button" name="generate-doc" value="Ģenerēt Word dokumentu" onclick="TopSubmit(&quot;http://globa/php8/generate-doc.php<%=qstring()%>&quot;)" width="116" height="25" />
	-->
</form>


</body>
</html>
