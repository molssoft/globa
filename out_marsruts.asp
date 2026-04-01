<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Dalibnieki</title>
</head>

<body background="ice1.jpg" bgproperties="fixed" text="#000000" link="#008040" vlink="#804000" alink="#FF0000">
<%
dim conn
openconn
i=Request.QueryString("i")+""
Set f = conn.execute("select g.*,m.v,m.cena,m.apraksts,m.cenab,m.cenap from marsruts m, grupa g where m.ID=g.mID and m.ID="+cstr(i))
%>

<center><font color="#FF0000" size="5"><b><i><%=f("v")%></i></b></font><hr>
</center>

<center><font size="2">
[ <a href="default.asp">Mājas</a> ] 
[ <a href="dalibn.asp">Dalībnieki</a> ] 
[ <a href="out_grupa.asp">Atrodi savu ceļojumu!</a> ] 
[ <a href="in_marsruts.asp">Maršruti</a> ] 
[ <a href="in_grupa.asp">Grupas</a> ]<br>
</font></center>

<table border="0">
<tr><td align="right"><b>Ceļojums ilgst: </td><td><%=dateprint(f("sakuma_dat"))%> - <%=dateprint(f("beigu_dat"))%> </tr>
<tr><td align="right"><b>Cena: </td><td><%=f("cena")%></tr>
<tr><td align="right"><b>Cena bērniem: </td><td><%=f("cenab")%> </tr>
<tr><td align="right"><b>Papildvietas cena: </td><td><%=f("cenap")%> </tr>
<tr><td align="right"><b>Ceļojuma apraksts: </table>
<%=f("apraksts")%>

<table border="1">
<tr><td align="right"><b>Ceļojuma cenā ietilpst</b>: </td><td>

<%
Set ie = conn.execute("select * from ietilpst ")
do while not ie.eof
%>
<img src="/images/k_dzelte.gif" WIDTH="11" HEIGHT="11"> 
<%

Response.Write ie("v") +"<br>"
ie.MoveNext
loop
%></tr>

<tr><td align="right"><b>Ceļojuma cenā neietilpst</b>: </td><td>
<%
'Set ie = conn.execute("select * from ietilpst ")
'do while not ie.eof
'Response.Write ie("v") +"<br>"
'ie.MoveNext
'loop
%></tr>


<tr><td align="right"><b>Iespējamās papildizmaksas: </td><td>
<%
Set ie = conn.execute("select p.*,v.latv as valsts,vl.val from papildi p,valstis v,valuta vl where p.valstsID=v.ID and p.valutasID=vl.ID order by vards,v")
do while not ie.eof
%>
<img src="/images/k_oranzs.gif" WIDTH="11" HEIGHT="11"> 
<%

Response.Write (ie("valsts") & " - " & ie("v") & " - " & ie("cena") & " " & ie("val") +"<br>" )
ie.MoveNext
loop
%></tr>

<tr><td align="right"><b>Nepieciešamie dokumenti: </td><td>
<%
Set ie = conn.execute("select * from doku")
do while not ie.eof
%>
<img src="/images/k_violet.gif" WIDTH="11" HEIGHT="11"> <%=ie("v")%> <br>
<%
ie.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>

<tr><td align="right"><b>Šī maršruta projekts pa dienām</tr>
</table>
<a href="out_grupa.asp"> Esošo grupu saraksts </a>
</body>
</html>
