<!-- #include file = dbprocs.inc -->
<!-- #include file = procs.inc -->

<%docstart "Pçdçjâs minûtes cenas","y1.jpg" 
DefJavaSubmit %>

<center><font color="GREEN" size="5"><b>Pçdçjâs minûtes cenas</b></font><hr>
<%
headlinks 
Dim conn
OpenConn


if session("message") <> "" then response.write "<font color = red>"+ session("message") + "</font>"
session("message") = ""

set r = conn.execute ("select grupa.*,marsruts.v from grupa INNER JOIN marsruts ON grupa.mid = marsruts.id where pm = true and sakuma_dat >= #"+sqldate(date)+"# order by sakuma_dat ")

%> <form name = forma method = POST> <%


if r.eof then
	%>
	<br>Paðreiz aktîvu pçdçjâs minûtes cenu nav.<br><br>
	<%
else
	%>
		<table border = 1>
		<tr  bgcolor = #ffc1cc><th>Izbraukðana</th><th>Marðruts</th><th>Bâzes cena</th><th>PM Cena</th></tr>
	<%
	while not r.eof
		%>
		<tr  bgcolor = #fff1cc><td><%=DatePrint(r("sakuma_dat"))%></td><td><%=Nullprint(r("v"))%></td><td><%=Getnum(r("i_cena"))%></td><td><%=Getnum(r("pm_cena"))%>
		</td><td><input type="image" src="impro/bildes/dzest.jpg" onclick="TopSubmit('pm_del.asp?id=<%=r("id")%>')" alt = "Atcelt pçdçjâs minûtes cenu."></td></tr>
		<%
		r.movenext
	wend
	%>	
	</table>
<%
end if
%>

<center><hr><font color="BLACK" size="4"><b>Pçdçjâs minûtes cenas pievienoðana</b></font><hr>
<table>
<tr><td bgcolor = #ffc1cc align = right>Grupa</td><td  bgcolor = #fff1cc><% grupas_combo_piet gid,0 %></td></tr>
<tr><td bgcolor = #ffc1cc>Pçdçjâs minûtes cena</td><td  bgcolor = #fff1cc><input type = text size = 10 name = pm_cena ></td></tr>
</table>
<input type="image" src="impro/bildes/pievienot.jpg" onclick="TopSubmit('pm_add.asp')" alt = "Pievienot pçdçjâs minûtes cenu.">
</form> 


