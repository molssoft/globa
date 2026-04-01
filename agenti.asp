<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn


title = "Aìenti"
table = "agenti"
order = "pilseta,vards"
captions = "Aktîvs,Vârds,Debeta konts,Kredîta konts"
captions_mas = split(captions,",")
fields = "aktivs,vards,dkonts,ckonts,pilseta"
fields_mas = split(fields,",")
types = "bool,varchar,varchar,varchar,varchar"
types_mas = split(types,",")
sizes = "40,12,12"
sizes_mas = split(sizes,",")
last = ubound(fields_mas)

act = Request.Form("act")
id = Request.Form("id")

'update
if act="update" then
 query = "update "+table+" SET "
 for i = 0 to last
  query=query + fields_mas(i)+"="
  if types_mas(i) = "varchar" then
   query=query+"'"+SQLText(encode(Request.Form(fields_mas(i)+cstr(id))))+"'"
  elseif types_mas(i) = "money" then
   v = Request.Form(fields_mas(i)+cstr(id))
   if v = "" then v = "NULL"
   query=query+v
  elseif types_mas(i) = "bool" then
   v = Request.Form(fields_mas(i)+cstr(id))
   if v = "" then 
	v = "0"
   Else
    v = "1"
   End if
   query=query+v
  end if
  if i<>last then
   query = query+","
  end if
 next
 query = query + " WHERE id = " + cstr(id)
 conn.execute query

'delete
elseif act = "delete" then
 conn.execute "DELETE FROM "+table+" WHERE id = " + cstr(id)
 
'insert
elseif act = "insert" then
 query = "insert into "+table+" ("
 for i = 0 to last
  query=query + fields_mas(i)
  if i<>last then
   query = query+","
  end if
 next
 query = query + ") VALUES ("
 for i = 0 to last
  if types_mas(i) = "varchar" then
   query=query+"'"+SQLText(encode(Request.Form(fields_mas(i))))+"'"
  elseif types_mas(i) = "money" then
   v = Request.Form(fields_mas(i))
   if v = "" then v = "NULL"
   query=query+v
  elseif types_mas(i) = "bool" then
   v = Request.Form(fields_mas(i)+cstr(id))
   if v = "" then 
	v = "0"
   Else
    v = "1"
   End if
   query=query+v
  end if
  if i<>last then
   query = query+","
  end if
 next
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
r.open "Select *,(select count(id) from lietotaji where aid = agenti.id) as lsk from agenti where aktivs = 1 ORDER BY "+order,conn,3,3
	%> 
	<center><h2>Aktîvie aìenti</h2> <table border="0">
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Aktîvs</th>
		<th>Pilsçta</th>
		<th>Vârds</th>
		<th>Debets</th>
		<th>Kredîts</th>
		<th>Lietotâji</th>
		<th>Lîgums</th>
		<th>Uzòçmums</th>
		<th>Reì</th>
		<th>Adrese</th>
		<th>TATO</th>
		<th>Pârstâvis</th>
	</tr>
	<%
if r.recordcount <> 0 then
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
			<td width=1><%=r("id")%></td>
			<td><input type="checkbox" name="aktivs<%=r("id")%>" <%if r("aktivs") = True then response.write " checked "%>></td>
			<td><input type="text" name="pilseta<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("pilseta")))%>"></td>
			<td><input type="text" name="vards<%=r("id")%>" size="25" value="<%=decode(NullPrint(r("vards")))%>"></td>
			<td><input type="text" name="dkonts<%=r("id")%>" size="8" value="<%=decode(NullPrint(r("dkonts")))%>"></td>
			<td><input type="text" name="ckonts<%=r("id")%>" size="8" value="<%=decode(NullPrint(r("ckonts")))%>"></td>
			<td><a href=agenta_lietotaji.asp?id=<%=getnum(r("id"))%>><%=getnum(r("lsk"))%></a></td>

			<td><a href=agenta_liguma_info.asp?id=<%=r("id")%>>[Lîgums]</a></td>
			<td><%=decode(r("uznemums"))%></td>
			<td><%=decode(r("regnr"))%></td>
			<td><%=decode(r("adrese"))%></td>
			<td><%=decode(r("tur_regnr"))%></td>
			<td><%=decode(r("parstavis"))%></td>
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
			<td><input type="checkbox" name="aktivs" value="1"></td>
			<td><input type="text" name="pilseta" size="15" value=""></td>
			<td><input type="text" name="vards" size="25" value=""></td>
			<td><input type="text" name="dkonts" size="8" value=""></td>
			<td><input type="text" name="ckonts" size="8" value=""></td>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>


<%
'------------- Selektç aìentus --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select * from agenti where aktivs = 0 ORDER BY "+order,conn,3,3
	%> 
	<center><h2>Neaktîvie aìenti</h2> <table border="0">
	<tr bgcolor="#ffc1cc">
		<th>ID</th>
		<th>Aktîvs</th>
		<th>Pilsçta</th>
		<th>Vârds</th>
		<th>Debets</th>
		<th>Kredîts</th>
	</tr>
	<%
if r.recordcount <> 0 then
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
			<td width=1><%=r("id")%></td>
			<td><input type="checkbox" name="aktivs<%=r("id")%>" <%if r("aktivs") = True then response.write " checked "%>></td>
			<td><input type="text" name="pilseta<%=r("id")%>" size="15" value="<%=decode(NullPrint(r("pilseta")))%>"></td>
			<td><input type="text" name="vards<%=r("id")%>" size="25" value="<%=decode(NullPrint(r("vards")))%>"></td>
			<td><input type="text" name="dkonts<%=r("id")%>" size="8" value="<%=decode(NullPrint(r("dkonts")))%>"></td>
			<td><input type="text" name="ckonts<%=r("id")%>" size="8" value="<%=decode(NullPrint(r("ckonts")))%>"></td>

			<td><a href=agenta_liguma_info.asp?id=<%=r("id")%>>[Lîguma info]</a></td>
			<td><%=decode(r("uznemums"))%></td>
			<td><%=decode(r("regnr"))%></td>
			<td><%=decode(r("adrese"))%></td>
			<td><%=decode(r("tur_regnr"))%></td>
			<td><%=decode(r("parstavis"))%></td>
			<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='delete';return confirm('Vai dzçst ierakstu?');" alt="Dzçst ierakstu."></td>
			<td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='update'" alt="Saglabât ierakstu."></td>
		 </tr>
		<%
		r.MoveNext
	wend
end if

%>

</table>

<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>
