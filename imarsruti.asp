<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
'standarts visaam lapaam
docstart "Interneta marðruti","y1.jpg"

set r = conn.execute ("select * from marsruts where old = false and not (v like '!%') order by v ")

poga = request.form("poga")
apraksts = request.form("apraksts")
if apraksts = "" then apraksts = 0
marsruts = request.form("marsruts")

if poga = "Saglabât" then
	conn.execute ("UPDATE marsruts SET apraksts = '" + apraksts + "' where id = " + cstr(marsruts))
	conn.execute ("UPDATE grupa SET internets = true where mid = " + cstr(marsruts))
end if

if poga = "Atjaunot" then
	set rm = conn.execute ("select * from marsruts where id = " + cstr(marsruts))
	apraksts = rm("apraksts")
end if
%>

<center><font color="GREEN" size="5"><b>Interneta marðruti</b></font><hr>

<form action = imarsruti.asp method = POST>
<select name = marsruts>
	<% while not r.eof 
	if marsruts = cstr(r("id")) then
		response.write "<option selected value = " + cstr(r("id")) + ">" + r("v") + "</option>"
	else
		response.write "<option value = " + cstr(r("id")) + ">" + r("v") + "</option>"
	end if
	r.movenext 
	wend %>
</select>
<input type = submit name = poga value = "Atjaunot"> <br>
<textarea name = "apraksts" cols=50 rows = 10>
<%=apraksts%>
</textarea><br>
<input type = submit name = poga value = "Saglabât"> 
</form>