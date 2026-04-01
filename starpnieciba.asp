<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn


title = "Starpniecîbas noteikumi"
table = "starpnieciba"
order = "nosaukums"
captions = "Nosaukums,Procents,Summa,Online 1%"
captions_mas = split(captions,",")
fields = "nosaukums,procents,summa,online"
fields_mas = split(fields,",")
types = "varchar,money,money,checkbox"
types_mas = split(types,",")
sizes = "20,7,7,7"
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
  elseif types_mas(i) = "checkbox" then
   v = Request.Form(fields_mas(i)+cstr(id))
   if v = "on" then 
	query=query+"1"
   else
	query=query+"0"
   end if
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
 		 elseif types_mas(i) = "money" then
 		  if isnull(r(fields_mas(i))) then
 		   v = ""
 		  else
 		   v = CurrPrint(getnum(r(fields_mas(i))))
 		  end if
 		  %><td><input type="text" name="<%=fields_mas(i)%><%=r("id")%>" size="<%=sizes_mas(i)%>" value="<%=v%>"></td><%
 		 end if
   next 
   %>
		 <td><input type="checkbox" <%if r("online")=true then Response.Write " checked "%> name="online<%=r("id")%>"></td>
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
   if types_mas(i)<>"checkbox" then
	%><td><input type="text" name="<%=fields_mas(i)%>" size="<%=sizes_mas(i)%>"></td><%
   end if
 next %>
 <td></td>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>
<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>
