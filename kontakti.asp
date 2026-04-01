<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn


if Request.Form("act") = "dalibn" then
 conn.execute ("insert into interesenti (gid,vards,uzvards,telefons,epasts,pilseta,adrese,indekss,laiks) select "+Request.QueryString("gid")+",vards2,uzvards2,isnull(talrunisM,'')+' '+isnull(talrunisD,'')+' '+isnull(talrunisMob,''),eadr,pilseta2,adrese2,indekss,'"+sqldate(now)+"' from dalibn where id = "+Request.Form("did"))
end if

title = "Kontaktpersonas"
table = "Interesenti"
order = "id"
captions = "Vârds,Uzvârds,Uzòçmums,Telefons,E-pasts,Pilsçta,Adrese,Indekss"
captions_mas = split(captions,",")
fields = "vards,uzvards,uznemums,telefons,epasts,pilseta,adrese,indekss"
fields_mas = split(fields,",")
types = "varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar"
types_mas = split(types,",")
sizes = "8,8,12,8,12,10,15,6"
sizes_mas = split(sizes,",")
last = ubound(fields_mas)

act = Request.Form("act")
id = Request.Form("id")
gid = Request.QueryString("gid")
If gid = "" then gid = Request.Form("gid")

'update
if act="update" then
 query = "update "+table+" SET "
 for i = 0 to last
  query=query + fields_mas(i)+"="
  if types_mas(i) = "varchar" then
   query=query+"'"+SQLText(encode(Request.Form(fields_mas(i)+cstr(id))))+"'"
  elseif types_mas(i) = "datetime" then
   v = SQLTime(Formatedtime(Request.Form(fields_mas(i)+cstr(id)),"dmyhns"))
   if v = "" then v = "NULL"
   query=query+"'"+v+"'"
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
  elseif types_mas(i) = "datetime" then
   v = SQLTime(Formatedtime(Request.Form(fields_mas(i)),"dmyhns"))
   if v = "" then v = "NULL"
   query=query+"'"+v+"'"
  end if
  if i<>last then
   query = query+","
  end if
 next
 query = query + ")"
 conn.execute query
 set rGid = conn.execute("select max(id) as xid from "+table)
 conn.execute ("update "+table+" set gid = "+gid+" where id = "+cstr(rGid("xid")))
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
<input type=hidden name=gid value=<%=gid%>>
<%
'------------- Selektç aìentus --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select id,"+fields+" from "+table+" where gid = "+gid+" ORDER BY "+order,conn,3,3
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
 		 elseif types_mas(i) = "datetime" then
 		   v = TimePrint(r(fields_mas(i)))
 		  %><td><%=v%></td><%
 		  Response.Write "<input type=hidden name="+Fields_mas(i)+cstr(r("id"))+" value='"+cstr(v)+"'></input></td>"
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
   <% 
   If types_mas(i) = "datetime" then
     Response.Write "<td nowrap>" & TimePrint(Now)
     Response.Write "<input type=hidden name="+Fields_mas(i)+" value='"+cstr(TimePrint(Now))+"'></input></td>"
   else
   %>
     <td><input type="text" name="<%=fields_mas(i)%>" size="<%=sizes_mas(i)%>"></td>
   <% end if %>
 <% next %>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu." ></td>
</tr></table>
<input type=hidden name=id>
<input type=hidden name=act>
</form>

<br><br>
Iespçjams pievienot informâciju arî no dalîbnieku tabulas. <br>Lai to izdarîtu ierakstiet dalîbnieka ID.
<form name=fdalibn method=POST>
<input type=hidden name=act value=dalibn>
<input type=text name=did value="">
<input type=image src="impro/bildes/pievienot.jpg" onclick="if (fdalibn.did.value=='') {alert ('Norâdiet dalîbnieka ID!');return false;}">
</form>

</body>
</html>
