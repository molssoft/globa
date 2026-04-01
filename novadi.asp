<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn


title = "Novadi"
table = "novads"
order = "nosaukums"
'captions = "Novads"
'captions_mas() = split(captions,",")
Dim captions_mas(0)
captions_mas(0) = "Novads"
fields = "nosaukums"
'fields_mas = split(fields,",")
Dim fields_mas(0)
fields_mas(0) = "nosaukums"
'types = "varchar"
'types_mas = split(types,",")
Dim types_mas(0)
types_mas(0) = "varchar"
'sizes = "52"
'sizes_mas = split(sizes,",")
Dim sizes_mas(0)
sizes_mas(0) = "50"
last = ubound(fields_mas)

act = Request.Form("act")
id = Request.Form("id")

'update
if act="update" then
 query = "update "+table+" SET "
 for i = 0 to last
  query=query + fields_mas(i)+"="
  if types_mas(i) = "varchar" then
   'query=query+"'"+SQLText(encode(Request.Form(fields_mas(i)+cstr(id))))+"'"
   query=query+"'"+SQLText(Request.Form(fields_mas(i)+cstr(id)))+"'"
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
   'query=query+"'"+SQLText(encode(Request.Form(fields_mas(i))))+"'"
   query=query+"'"+SQLText(Request.Form(fields_mas(i)))+"'"
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
r.open "Select id,"+fields+" from "+table+" ORDER BY "+order,conn,3,3
	%> 
	<center> <table border="0">
	<tr bgcolor="#ffc1cc">
	<% for i = 0 to last %>
	 <th><%=captions_mas(i)%></th>
	<% next %>
	<th></th>
	<th></th>
	</tr>
	<%
if r.recordcount <> 0 then
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
   <% 
   for i = 0 to last 
    if types_mas(i) = "varchar" then
 		  %><td><input type="text" name="<%=fields_mas(i)%><%=r("id")%>" size="<%=sizes_mas(i)%>" value="<%=decode(NullPrint(r(fields_mas(i))))%>"></td><%
	end if
   next 
   %>
		 <td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='delete';return confirm('Vai dzçst ierakstu?');" alt="Dzçst ierakstu."></td>
		 <td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='update'" alt="Saglabât ierakstu."></td></tr>
		<%
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
 <% for i = 0 to last %>
  <td><input type="text" name="<%=fields_mas(i)%>" size="<%=sizes_mas(i)%>"></td>
 <% next %>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>
<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>
