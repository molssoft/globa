<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn


title = "Atrastâs mantas"
table = "mantas"
order = "id"
captions = "Manta,Atraðanâs vieta,Atnests,Paòemts,Atnesa"
captions_mas = split(captions,",")
fields = "Nosaukums,Vieta,Atstats,Panemts,Atnesa"
fields_mas = split(fields,",")
types = "varchar,varchar,date,bit,varchar"
types_mas = split(types,",")
sizes = "40,40,10,10,20"
sizes_mas = split(sizes,",")
defaults = ",,"+dateprint(date)+",,"
defaults_mas = split(defaults,",")
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
  elseif types_mas(i) = "date" then
   v = "'" + SQLDate(Request.Form(fields_mas(i)+cstr(id))) + "'"
   if v = "" then v = "NULL"
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
  elseif types_mas(i) = "date" then
   v = "'" + SQLDate(Request.Form(fields_mas(i))) + "'"
   if v = "" then v = "NULL"
   query=query+v
  elseif types_mas(i) = "bit" then
   if Request.Form(fields_mas(i)) = "" then
    v = "0"
   else
    v = "1"
   end if
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
 		 elseif types_mas(i) = "money" then
 		  if isnull(r(fields_mas(i))) then
 		   v = ""
 		  else
 		   v = CurrPrint(getnum(r(fields_mas(i))))
 		  end if
 		  %><td><input type="text" name="<%=fields_mas(i)%><%=r("id")%>" size="<%=sizes_mas(i)%>" value="<%=v%>"></td><%
 		 elseif types_mas(i) = "date" then
 		  if isnull(r(fields_mas(i))) then
 		   v = ""
 		  else
 		   v = DatePrint(getnum(r(fields_mas(i))))
 		  end if
 		  %><td><input type="text" name="<%=fields_mas(i)%><%=r("id")%>" size="10" value="<%=v%>"></td><%
 		 elseif types_mas(i) = "bit" then
 		  %><td><input type="checkbox" name="<%=fields_mas(i)%><%=r("id")%>" <% if r(fields_mas(i)) = true then Response.Write " checked "%>></td><%
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
 <% 
 for i = 0 to last 
  if types_mas(i) = "bit" then
   %><td><input type="checkbox" name="<%=fields_mas(i)%>" <% if defaults_mas(i)<>"" then Response.Write " checked " %>></td><% 
  else
   %><td><input type="text" name="<%=fields_mas(i)%>" size="<%=sizes_mas(i)%>" value="<%=defaults_mas(i)%>"></td><% 
  end if
 next 
 %>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>
<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>
