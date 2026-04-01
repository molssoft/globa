<!-- #include file = "conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Maršrutu grupas</title>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">


</head>


<body>

<p align="center">

<font size=6>Maršrutu grupas</font><br>
<% top_links %>
<center>
<hr>
<a href=mgrupa.asp?id=NEKLASIF>Neklasificētie maršruti</a><br>
<a href=add_marsruts.asp>Jauns maršruts</a><br><br>

Pēc valsts<br><br>
<% set r = conn.execute ("select * from geo where type_id = 'V' or type_id = 'D' order by title" )
while not r.eof
 %><a href=mgrupa.asp?valsts=<%=r("id")%>><%=r("title")%></a><%=" | "%><%
 r.movenext
wend%>
<br><br>

Pēc intereses<br><br>
<% set r = conn.execute ("select * from temas order by nosaukums" )
while not r.eof
 %><a href=mgrupa.asp?tema=<%=r("id")%>><%=r("nosaukums")%></a><%=" | "%><%
 r.movenext
wend%>
<br><br>

Pēc kategorijas<br><br>
<% set r = conn.execute ("select * from kategorijas order by nosaukums" )
while not r.eof
 %><a href=mgrupa.asp?kat=<%=r("id")%>><%=r("nosaukums")%></a><%=" | "%><%
 r.movenext
wend%>
<br><br>

</body>
