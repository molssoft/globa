<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn

gid = request.querystring("gid")
title = "Interesenti"
table = "Interesenti"
order = "laiks"
captions = "Vârds,Uzvârds,Telefons,E-pasts,Vietu skaits,Piezîmes,Laiks"
captions_mas = split(captions,",")
fields = "vards,uzvards,telefons,epasts,personas,piezimes,laiks"
fields_mas = split(fields,",")
types = "varchar,varchar,varchar,varchar,varchar,varchar,datetime"
types_mas = split(types,",")
sizes = "12,12,8,16,12,20,8"
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
  elseif types_mas(i) = "int" then
	query=query+Request.Form(fields_mas(i)+cstr(id))
  end if
  if i<>last then
   query = query+","
  end if
 next
 query = query + " WHERE id = " + cstr(id)
 'rw query
 conn.execute query
 LogEditAction "Interesenti",id

'delete
elseif act = "delete" then
 conn.execute "DELETE FROM "+table+" WHERE id = " + cstr(id)
 
'insert
elseif act = "insert" then
 query = "insert into Interesenti (vards,uzvards,telefons,epasts,laiks,piezimes,personas,pievienoja_user) VALUES ("
 query=query+"'"+SQLText(encode(Request.Form("vards")))+"'"
 query=query+",'"+SQLText(encode(Request.Form("uzvards")))+"'"
 query=query+",'"+SQLText(encode(Request.Form("telefons")))+"'"
 query=query+",'"+SQLText(encode(Request.Form("epasts")))+"'"
 query=query+",getdate()"
 query=query+",'"+SQLText(encode(Request.Form("piezimes")))+"'"
  query=query+",'"+SQLText(encode(Request.Form("personas")))+"'"
 query=query+",'"+Request.ServerVariables("LOGON_USER")+"'"
 query = query + ")"
 conn.execute query
 set rGid = conn.execute("select max(id) as xid from "+table)
 conn.execute ("update "+table+" set gid = "+gid+" where id = "+cstr(rGid("xid")))
 LogInsertAction  "Interesenti",rGid("xid")
end if

docstart title,"y1.jpg" %>
<center><font color="GREEN" size="5"><b><%=Title%></b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr><hr>
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

ssql = "Select l.vards as agents, i.* " +_
		"from interesenti i left join agenti l on l.id = i.pievienoja " +_
		"where i.gid = "+gid+" ORDER BY i."+order

r.open ssql,conn,3,3

'r.open "Select id,"+fields+" from "+table+" where gid = "+gid+" ORDER BY "+order,conn,3,3
	%> 
	<center> <table border="0">
	
	<tr bgcolor="#ffc1cc">
	<th>Pievienoja</th>
	<th>Aìents</th>
	<% for i = 0 to last %>
	 <th><%=captions_mas(i)%></th>
	<% next %>
	<th></th>
	<th></th>
	<th></th>
	
	</tr>
	<%
if r.recordcount <> 0 then
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
		<td><%=decode(r("pievienoja_user"))%></td>
		<td><%=decode(r("agents"))%></td>
		<% 
   for i = 0 to last 
    if types_mas(i) = "varchar" then
 		  %><td><input type="text" name="<%=fields_mas(i)%><%=r("id")%>" size="<%=sizes_mas(i)%>" value="<%=decode(NullPrint(r(fields_mas(i))))%>"></td><%
 		 elseif types_mas(i) = "datetime" then
 		   v = TimePrint(r(fields_mas(i)))
 		  %><td><%=v%></td><%
 		  Response.Write "<input type=hidden name="+Fields_mas(i)+cstr(r("id"))+" value='"+cstr(v)+"'></input></td>"
		  elseif types_mas(i) = "int" then
		  %>
		  <td><input type="number" name="<%=fields_mas(i)%><%=r("id")%>" style="width:<%=sizes_mas(i)%>em" value="<%=getnum(r(fields_mas(i)))%>"></td>
		  <%
		  
 		 end if
   next 
   %>
		 <td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='delete';return confirm('Vai dzçst ierakstu?');" alt="Dzçst ierakstu."></td>
		 <td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='update'" alt="Saglabât ierakstu."></td>
		 <td>
		 <a target = none href = "interesenti_vesture.asp?iid=<%=r("id")%>"><img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît ðî interesenta vçsturi."></a>
		 </td>
		 </tr>
		<%
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
<td>&nbsp;</td>
<td>&nbsp;</td>
 <% for i = 0 to last %>
   <% 
   If types_mas(i) = "datetime" then
     Response.Write "<td nowrap>" & TimePrint(Now)
     Response.Write "<input type=hidden name="+Fields_mas(i)+" value='"+cstr(TimePrint(Now))+"'></input></td>"
   elseif types_mas(i) = "int" then
	%>
	<td><input type="number" name="<%=fields_mas(i)%>" style="width:<%=sizes_mas(i)%>em"></td>
	<%
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
</body>
</html>
