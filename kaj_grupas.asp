<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

dim conn
openconn
docstart "Kajîğu grupas","y1.jpg" 
set r = conn.execute ("select distinct gid from kajite where not (deleted = 1)")
if not r.eof then 
	g_list = cstr(r("gid"))
	r.movenext
	while not r.eof
		g_list = g_list + "," + cstr(r("gid"))
		r.movenext
	wend
	set r= conn.execute("select grupa.id as gid, * from marsruts INNER JOIN grupa ON marsruts.id = grupa.mid WHERE grupa.id IN ("+g_list+") and sakuma_dat > '"+sqldate(now-20)+"' ORDER BY v,sakuma_dat")
end if
%>
<center>
<b><font size = 5 color = green>Kajîğu grupas</font></b><br><br>
<% headlinks %>
<hr>
<%
marid = 0
while not r.eof
	if marid <> r("mid") then
		response.write "<br><br><b>"+r("v")+"</b><br>"
		marid = r("mid")
	end if 
	response.write "<a href = 'kajite.asp?gid=" + cstr(r("gid"))+"'>" + dateprint(r("sakuma_dat"))+"</a> "
	r.movenext
wend
%>