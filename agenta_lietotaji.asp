<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn

aid = request.querystring("id")

title = "Lietotâji"
table = "lietotaji"
order = "id"
captions = "Lietotâjs,Vârds,Uzvârds"
captions_mas = split(captions,",")
fields = "lietotajs,vards,uzvards"
fields_mas = split(fields,",")
types = "varchar,varchar,varchar"
types_mas = split(types,",")
sizes = "12,12,12"
sizes_mas = split(sizes,",")
last = ubound(fields_mas)

act = Request.Form("act")
id = Request.Form("id")

'update
if act="update" then
	lietotajs = request.form("lietotajs"+cstr(id))
	vards = request.form("vards"+cstr(id))
	uzvards = request.form("uzvards"+cstr(id))
	epasts = request.form("epasts"+cstr(id))
	parole = request.form("parole"+cstr(id))
	active = request.form("active"+cstr(id))
	if active = "" then	active = "0" else active = "1"
	query = "UPDATE lietotaji set "
	query = query + " lietotajs = '"+lietotajs+"', "
	query = query + " vards = '"+vards+"', "
	query = query + " uzvards = '"+uzvards+"', "
	query = query + " epasts = '"+epasts+"', "
	if parole<>"" then
		query = query + " parole = '"+parole+"', "
	end if
	query = query + " active = "+active+" "
	query = query + " WHERE id = " + cstr(id)
	conn.execute query
end if

'delete
if act = "delete" then
 conn.execute "DELETE FROM lietotaji WHERE id = " + cstr(id)
 
'insert
elseif act = "insert" then
	lietotajs = request.form("lietotajs")
	vards = request.form("vards")
	uzvards = request.form("uzvards")
	epasts = request.form("epasts")
	parole = request.form("parole")
	active = request.form("active")
	if active = "" then	active = "0" else active = "1"

	query = "insert into lietotaji (aid,lietotajs,vards,uzvards,epasts,parole,active) values ("
	query = query + aid+", "
	query = query + "'"+lietotajs+"', "
	query = query + "'"+vards+"', "
	query = query + "'"+uzvards+"', "
	query = query + "'"+epasts+"', "
	query = query + "'"+parole+"', "
	query = query + active
	query = query + ")"

	conn.execute query
end if

docstart title,"y1.jpg" %>
<center><font color="GREEN" size="5"><b><%=Title%></b></font><hr>
<%
headlinks 

if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
%>
<form name="forma" method="POST">
<%
'------------- Selektç aìentus --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select * from lietotaji where aid = "+cstr(aid)+" ORDER BY "+order,conn,3,3
	%> 
	<center><h2><a href=agenti.asp>Aìenta lietotâji</a></h2> <table border="0">
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Lietotâjs</th>
		<th>Vârds</th>
		<th>Uzvârds</th>
		<th>Epasts</th>
		<th>Parole</th>
		<th>Aktîvs</th>
	</tr>
	<%
if r.recordcount <> 0 then
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
			<td width=1><%=r("id")%></td>
			<td><input type="text" name="lietotajs<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("lietotajs")))%>"></td>
			<td><input type="text" name="vards<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("vards")))%>"></td>
			<td><input type="text" name="uzvards<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("uzvards")))%>"></td>
			<td><input type="text" name="epasts<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("epasts")))%>"></td>
			<td><input type="text" name="parole<%=r("id")%>" size="15" value=""></td>
			<td><input type="checkbox" name="active<%=r("id")%>" <%if r("active") = True then response.write " checked "%>></td>
			<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='delete';return confirm('Vai dzçst ierakstu?');" alt="Dzçst ierakstu."></td>
			<td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='update'" alt="Saglabât ierakstu."></td>

		</tr>
		<%
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
<td></td>
			<td><input type="text" name="lietotajs" size="15" value=""></td>
			<td><input type="text" name="vards" size="15" value=""></td>
			<td><input type="text" name="uzvards" size="15" value=""></td>
			<td><input type="text" name="epasts" size="15" value=""></td>
			<td><input type="text" name="parole" size="15" value=""></td>
			<td><input type="checkbox" name="active" ></td>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>

<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>
