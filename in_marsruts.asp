<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<meta http-equiv="Content-Type"
content="text/html; charset=windows-1257">
<title>Dalibnieki</title>
</head>

<body background="ice1.jpg" text="#000000"
link="#008040" vlink="#804000" alink="#FF0000">
<center><font color="#FF0000" size="5"><b><i>Jauna marðruta reìistrçðana, esoða laboðana</i></b></font><hr>

<center><font size=2>
[ <a href="default.asp">Mâjas</a> ] 
[ <a href="dalibn.asp">Dalîbnieki</a> ] 
[ <a href="out_grupa.asp">Atrodi savu ceïojumu!</a> ] 
[ <a href="in_marsruts.asp">Marðruti</a> ] 
[ <a href="in_grupa.asp">Grupas</a> ]<br><br>
</font></center>


<%
Set lists = Server.CreateObject("ADODB.Connection")
lists.Open "DSN=ai"
dID=Request.QueryString("i")+""
if dID="" then i=Request.Form("dID")
%>

<table border=0>
<form action="IN_grupa.asp?i=2" method="POST">

<tr><td align="right">Sâkuma datums: </td><td><input type="text" size="25" maxlength="20" name="datums"> </tr>
<tr><td align="right">Marðruta nosaukums: </td><td><input type="text" size="20" maxlength="20" name="v"> </tr>
<tr><td align="right">Cena: </td><td><input type="text" size="15" maxlength="255" name="cena"> </tr>
<tr><td align="right">Cena bçrniem: </td><td><input type="text" size="15" maxlength="10" name="cenab"> </tr>
<tr><td align="right">Papildvietas cena: </td><td><input type="text" size="15" maxlength="10" name="cenap"> </tr>
<tr><td align="right">Ceïojuma apraksts: </td><td>
<textarea name="preces_apr1" rows="7" cols="75"></textarea></tr>

<tr><td align="right">Ceïojuma cenâ <b>ietilpst</b>: </td><td>
<%
Set ie = lists.execute("select * from ietilpst ")
Response.Write "<select name=" & "ietilpstID" & " size=" & "4" & ">"
'------- Loop through the RECORDS
do while not ie.eof

Response.Write "<option value='" & ie("ID") & "'>" & ie("v") & "</option>"
ie.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>

<tr><td align="right">Ceïojuma cenâ <b>neietilpst</b>: </td><td>
<%
Set ie = lists.execute("select * from ietilpst ")
Response.Write "<select name=" & "neietilpstID" & " size=" & "4" & ">"
'------- Loop through the RECORDS
do while not ie.eof

Response.Write "<option value='" & ie("ID") & "'>" & ie("v") & "</option>"
ie.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>

<tr><td align="right">Iespçjamâs papildizmaksas: </td><td>
<%
Set ie = lists.execute("select p.*,v.latv as valsts,vl.val from papildi p,valstis v,valuta vl where p.valstsID=v.ID and p.valutasID=vl.ID order by vards,v")
Response.Write "<select name=" & "papildi" & " size=" & "4" & ">"
'------- Loop through the RECORDS
do while not ie.eof

Response.Write "<option value='" & ie("ID") & "'>" & ie("valsts") & " - " & ie("v") & " - " & ie("cena") & " " & ie("val") & "</option>"
ie.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>

<tr><td align="right">Nepiecieðamie dokumenti: </td><td>
<%
Set ie = lists.execute("select * from doku")
Response.Write "<select name=" & "doku" & " size=" & "4" & ">"
'------- Loop through the RECORDS
do while not ie.eof

Response.Write "<option value='" & ie("ID") & "'>" & ie("v") & "</option>"
ie.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>




<tr><td align="right">Parole: </td><td><input type="password" size="10" maxlength="10" name="parole"> 




<input type="hidden" name="subm" value="1"> 
<input type="submit" name="poga" value="Reìistret"> </tr>
</table>
</form>
<a href="proj.asp"> Ðî marðruta projekts pa dienâm </a><br>
<a href="out_grupa.asp"> Esoðo grupu saraksts </a>
</body>
</html>
