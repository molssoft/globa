<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn


'--- saglabâ izmaiòas
if request.form("subm") = 1 then
	jb =  request.form("jaunumu_bildes") 
	if jb<> "" then
		if mid(jb,len(jb),1) <> "\" then jb = jb + "\"
	end if
	if len(jb)>255 then 
		session("message") = session("message") + "Parametrs- jaunumu bildes ir par garu.<br>"
	else
		conn.execute "UPDATE parametri set jaunumu_bildes = '"+jb+"'"
	end if
end if




docstart "Parametri","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Programmas parametri</b></font><hr>
<%
headlinks 

dim r 
set r = conn.execute ("select * from parametri")
%>

<form name = forma method = POST>
<table border = 0>
<tr><td bgcolor = #ffc1cc>Jaunumu attçlu katalogs</td><td bgcolor = #fff1cc><input type = "text" name = "jaunumu_bildes" value = "<%=nullprint(r("jaunumu_bildes"))%>"></td></tr>
<tr><td colspan = 2 align = center><input type="image" src="impro/bildes/saglabat.jpg" alt = "Saglabât parametru vçrtîbas."><input type = "hidden" name = "subm" value = "1"></td></tr>
<tr><td><a href = "jaunumu_lab.asp">Jaunumi mâjas lapâ</a></td>
	<td><a href = "pm_cenas.asp">Pçdçjâs minûtes cenas</a></td></tr>
</table>
</form>
</body>
</html>
