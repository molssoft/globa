<!-- #include file = "../conn.asp" -->
<!-- #include file = procs.asp -->
<!-- #include file = procs.inc -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>New Page 2</title>
</head>

<%docstart "Jaunumi","Y1.jpg" 
DefJavaSubmit %>

<center><font color="GREEN" size="5"><b>Jaunumi</b></font><br>
<% top_links %>
<hr>
<%
Dim conn
OpenConn


if session("message") <> "" then response.write "<font color = red>"+ session("message") + "</font>"
session("message") = ""

set r = conn.execute ("select * from jaunumi where (s_datums+7 > '"+sqldate(now)+"' and b_datums is null) or (b_datums+1>'"+sqldate(now)+"' and not b_datums is null) order by s_datums ")

%><center><hr><font color="BLACK" size="4"><b>Tekošie jaunumi</b></font><hr><%
%> <form name = forma method = POST> <%

if r.eof then
	%>
	Patreiz jaunumu nav<br>
	<%
else
	while not r.eof
		%>
		<table>
		<tr><td bgcolor = #ffc1cc>Virsraksts</td><td  bgcolor = #fff1cc><input type = text size = 40 name = virsraksts<%=r("id")%> value = "<%=nullprint(r("virsraksts"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Sākuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums<%=r("id")%> value = "<%=dateprint(r("s_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums<%=r("id")%> value = "<%=dateprint(r("b_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Īsais apraksts</td><td  bgcolor = #fff1cc><input type = text size = 53 name = iis<%=r("id")%> value = "<%=nullprint(r("iis"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts<%=r("id")%> cols = 40 rows = 6><%=nullprint(r("apraksts"))%></textarea></td></tr>
		<tr><td bgcolor = #ffc1cc>1. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde1<%=r("id")%> value = "<%=nullprint(r("bilde1"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>2. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde2<%=r("id")%> value = "<%=nullprint(r("bilde2"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Īpašs piedāvājums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass<%=r("id")%>   <%if r("ipass")=true then response.write " checked"%> ></td></tr>
		</table>
		<input type="image" src="bildes/saglabat.jpg" onclick="TopSubmit('jaunums_save.asp?id=<%=r("id")%>')" alt = "Saglabāt jaunumu.">
		<input type="image" src="bildes/dzest.jpg" onclick="TopSubmit('jaunumi_del.asp?id=<%=r("id")%>')" alt = "Dzēst jaunumu.">
		<hr>
		<%
		r.movenext
	wend
	%>	
<%
end if

%><center><font color="BLACK" size="4"><b>Bijušie jaunumi</b></font><hr><%

set r = conn.execute ("select * from jaunumi where not ((s_datums+7 > '"+sqldate(now)+"' and b_datums is null) or (b_datums+1>'"+sqldate(now)+"' and not b_datums is null)) order by s_datums ")

if r.eof then
	%>
	Patreiz jaunumu nav<hr>
	<%
else
		%> <form name = forma method = POST> <%
	while not r.eof
		%>
		<table>
		<tr><td bgcolor = #ffc1cc>Virsraksts</td><td  bgcolor = #fff1cc><input type = text size = 40 name = virsraksts<%=r("id")%> value = "<%=nullprint(r("virsraksts"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Sākuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums<%=r("id")%> value = "<%=dateprint(r("s_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums<%=r("id")%> value = "<%=dateprint(r("b_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Īsais apraksts</td><td  bgcolor = #fff1cc><input type = text size = 53 name = iis<%=r("id")%> value = "<%=nullprint(r("iis"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts<%=r("id")%> cols = 40 rows = 6><%=nullprint(r("apraksts"))%></textarea></td></tr>
		<tr><td bgcolor = #ffc1cc>1. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde1<%=r("id")%> value = "<%=nullprint(r("bilde1"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>2. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde2<%=r("id")%> value = "<%=nullprint(r("bilde2"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Īpašs piedāvājums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass<%=r("id")%>   <%if r("ipass")=true then response.write " checked"%> ></td></tr>
		</table>
		<input type="image" src="bildes/saglabat.jpg" onclick="TopSubmit('jaunums_save.asp?id=<%=r("id")%>')" alt = "Saglabāt jaunumu.">
		<input type="image" src="bildes/dzest.jpg" onclick="TopSubmit('jaunumi_del.asp?id=<%=r("id")%>')" alt = "Dzēš jaunumu.">
		<hr>
		<%
		r.movenext
	wend
	%>	
<%
end if
%>

<center><font color="BLACK" size="4"><b>Jaunuma pievienošana</b></font><hr>
<table>
<tr><td bgcolor = #ffc1cc>Virsraksts</td><td  bgcolor = #fff1cc><input type = text size = 40 name = virsraksts></td></tr>
<tr><td bgcolor = #ffc1cc>S&acirc;kuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums value="<%=dateprint(date)%>"></td></tr>
<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums ></td></tr>
<tr><td bgcolor = #ffc1cc>Īsais apraksts</td><td  bgcolor = #fff1cc><input type = text size = 52 name = iis></td></tr>
<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts cols = 40 rows = 6></textarea></td></tr>
<tr><td bgcolor = #ffc1cc>1. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde1></td></tr>
<tr><td bgcolor = #ffc1cc>2. attēls</td><td bgcolor = #fff1cc ><input type = text name = bilde2></td></tr>
<tr><td bgcolor = #ffc1cc>Īpašs piedāvājums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass></td></tr>
</table>
<input type="image" src="bildes/pievienot.jpg" onclick="TopSubmit('jaunumi_add.asp')" alt = "Pievienot jaunumu.">
</form> 


