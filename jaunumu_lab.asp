<!-- #include file = dbprocs.inc -->
<!-- #include file = procs.inc -->

<%docstart "Jaunumi","y1.jpg" 
DefJavaSubmit %>

<center><font color="GREEN" size="5"><b>Jaunumi</b></font><hr>
<%
headlinks 
Dim conn
OpenConn


if session("message") <> "" then response.write "<font color = red>"+ session("message") + "</font>"
session("message") = ""

set r = conn.execute ("select * from jaunumi where (s_datums+7 > now and isnull(b_datums)) or (b_datums+1>now and not isnull(b_datums)) order by s_datums ")

%><center><hr><font color="BLACK" size="4"><b>Tekoðie jaunumi</b></font><hr><%
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
		<tr><td bgcolor = #ffc1cc>Sâkuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums<%=r("id")%> value = "<%=dateprint(r("s_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums<%=r("id")%> value = "<%=dateprint(r("b_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts<%=r("id")%> cols = 40 rows = 6><%=nullprint(r("apraksts"))%></textarea></td></tr>
		<tr><td bgcolor = #ffc1cc>1. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde1<%=r("id")%> value = "<%=nullprint(r("bilde1"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>2. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde2<%=r("id")%> value = "<%=nullprint(r("bilde2"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Îpaðs piedâvâjums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass<%=r("id")%>   <%if r("ipass")=true then response.write " checked"%> ></td></tr>
		</table>
		<input type="image" src="impro/bildes/saglabat.jpg" onclick="TopSubmit('jaunums_save.asp?id=<%=r("id")%>')" alt = "Saglabât jaunumu.">
		<input type="image" src="impro/bildes/dzest.jpg" onclick="TopSubmit('jaunumi_del.asp?id=<%=r("id")%>')" alt = "Dzçð jaunumu.">
		<hr>
		<%
		r.movenext
	wend
	%>	
<%
end if

%><center><font color="BLACK" size="4"><b>Bijuðie jaunumi</b></font><hr><%

set r = conn.execute ("select * from jaunumi where not ((s_datums+7 > now and isnull(b_datums)) or (b_datums+1>now and not isnull(b_datums))) order by s_datums ")

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
		<tr><td bgcolor = #ffc1cc>Sâkuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums<%=r("id")%> value = "<%=dateprint(r("s_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums<%=r("id")%> value = "<%=dateprint(r("b_datums"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts<%=r("id")%> cols = 40 rows = 6><%=nullprint(r("apraksts"))%></textarea></td></tr>
		<tr><td bgcolor = #ffc1cc>1. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde1<%=r("id")%> value = "<%=nullprint(r("bilde1"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>2. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde2<%=r("id")%> value = "<%=nullprint(r("bilde2"))%>"></td></tr>
		<tr><td bgcolor = #ffc1cc>Îpaðs piedâvâjums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass<%=r("id")%>   <%if r("ipass")=true then response.write " checked"%> ></td></tr>
		</table>
		<input type="image" src="impro/bildes/saglabat.jpg" onclick="TopSubmit('jaunums_save.asp?id=<%=r("id")%>')" alt = "Saglabât jaunumu.">
		<input type="image" src="impro/bildes/dzest.jpg" onclick="TopSubmit('jaunumi_del.asp?id=<%=r("id")%>')" alt = "Dzçð jaunumu.">
		<hr>
		<%
		r.movenext
	wend
	%>	
<%
end if
%>

<center><font color="BLACK" size="4"><b>Jaunuma pievienoðana</b></font><hr>
<table>
<tr><td bgcolor = #ffc1cc>Virsraksts</td><td  bgcolor = #fff1cc><input type = text size = 40 name = virsraksts></td></tr>
<tr><td bgcolor = #ffc1cc>Sâkuma datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = s_datums value = <%=dateprint(date)%>></td></tr>
<tr><td bgcolor = #ffc1cc>Beigu datums</td><td  bgcolor = #fff1cc><input type = text size = 10 name = b_datums ></td></tr>
<tr><td bgcolor = #ffc1cc>Apraksts</td><td  bgcolor = #fff1cc><textarea name = apraksts cols = 40 rows = 6></textarea></td></tr>
<tr><td bgcolor = #ffc1cc>1. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde1></td></tr>
<tr><td bgcolor = #ffc1cc>2. attçls</td><td bgcolor = #fff1cc ><input type = text name = bilde2></td></tr>
<tr><td bgcolor = #ffc1cc>Îpaðs piedâvâjums</td><td bgcolor = #fff1cc ><input type = checkbox name = ipass></td></tr>
</table>
<input type="image" src="impro/bildes/pievienot.jpg" onclick="TopSubmit('jaunumi_add.asp')" alt = "Pievienot jaunumu.">
</form> 


