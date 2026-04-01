<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

docstart "Pâsûtîjuma grupu klienti","y1.jpg" 
PageSize = 20

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>Pasûtijuma grupu klienti</b></font><hr>
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
<form name="forma_mekl" action="dalibn_pas.asp" method=PUT>
<center> 
<table border="0">
 <tr>
  <td bgcolor="#ffc1cc">Eadrese satur</td>
  <td><input type=text name="email" value="<%=request.querystring("email")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Vârds</td>
  <td><input type=text name="vards" value="<%=request.querystring("vards")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Uzvârds</td>
  <td><input type=text name="uzvards" value="<%=request.querystring("uzvards")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Sakârtojums</td>
  <td><select name="order">
   <option value="id" <%if request.querystring("order")="id" then response.write "selected"%> >Ievadîðanas secîbâ</option>
   <option value="uzvards" <%if request.querystring("order")="uzvards" then response.write "selected"%>>Uzvârds</option>
   <option value="pilseta" <%if request.querystring("order")="pilseta" then response.write "selected"%>>Pilsçta</option>
  </select></td>
 </tr>
</table>
<input type="image" name="meklet" src="impro/bildes/meklet.jpg">
</form>

<form name="forma" method="POST">
<table border="0">
<tr bgcolor="#ffc1cc">
<th>Nr.</th>
<th>Vârds</th>
<th>Uzvârds</th>
<th>Pilsçta</th>
<th>Adrese</th>
<th>Indekss</th>
<th>E-pasts</th>
<th></th>
<th></th>
</tr>
<%
query = "Select * from dalibn_pas where 1=1 "
if request.querystring("email")<>"" then query = query + " and epasts like '%"+request.querystring("email")+"%'"
if request.querystring("vards")<>"" then query = query + " and vards like N'%"+request.querystring("vards")+"%'"
if request.querystring("uzvards")<>"" then query = query + " and vards like N'%"+request.querystring("uzvards")+"%'"
order = Request.QueryString("order")
if order = "" then order = "id"
query = query + " ORDER BY "+order
set r = server.createobject("ADODB.Recordset")
r.PageSize = PageSize
r.open query,conn,3,3

if not r.eof then
  r.AbsolutePage = p
	rec = 1
	while not r.eof and rec<=PageSize
		%>
	 <tr bgcolor="#fff1cc">
	  <td><%=rec+(p-1)*pagesize%></td>
	  <td><input type="text" name="vards<%=r("id")%>" size="10" value="<%=NullPrint(r("vards"))%>"></td>
	  <td><input type="text" name="uzvards<%=r("id")%>" size="10" value="<%=NullPrint(r("uzvards"))%>"></td>
	  <td><input type="text" name="pilseta<%=r("id")%>" size="15" value="<%=NullPrint(r("pilseta"))%>"></td>
	  <td><input type="text" name="adrese<%=r("id")%>" size="20" value="<%=NullPrint(r("adrese"))%>"></td>
	  <td><input type="text" name="indeks<%=r("id")%>" size="5" value="<%=NullPrint(r("indeks"))%>"></td>
	  <td><input type="text" name="epasts<%=r("id")%>" size="20" value="<%=NullPrint(r("epasts"))%>"></td>
		 <td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.action = 'dalibn_pas_del.asp?id=<%=cstr(r("id"))%>'; return confirm('Vai vçlaties dzçst ierakstu?'); " alt="Dzçst ierakstu." WIDTH="25" HEIGHT="25"></td>
		 <td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.action =  'dalibn_pas_save.asp?id=<%=cstr(r("id"))%>'; return true;" alt="Saglabât izdarîtâs izmaiòas ðajâ rindâ." WIDTH="25" HEIGHT="25"></td>
  </tr><%
		rec=rec+1
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
 <td></td>
	<td><input type="text" name="vards" size="10" ></td>
	<td><input type="text" name="uzvards" size="10" ></td>
	<td><input type="text" name="pilseta" size="15" ></td>
	<td><input type="text" name="adrese" size="20" ></td>
	<td><input type="text" name="indeks" size="5" ></td>
	<td><input type="text" name="epasts" size="20" ></td>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.action = 'dalibn_pas_add.asp'; return true;" alt="Pievienot ierakstu." WIDTH="25" HEIGHT="25"></td>
</tr></table>
<input type=hidden name=qstring value="<%=qstring%>">
</form>

<%
if r.RecordCount > 0 then
 for i = 1 to r.PageCount
  if cstr(p) = cstr(i) then
   response.write "<b>["+cstr(i)+"]</b> "
  else
   response.write "<a href=""dalibn_pas.asp?epasts="+request.querystring("epasts")+"&vards="+request.querystring("vards")+"&uzvards="+request.querystring("uzvards")+"&order="+request.querystring("order")+"&p="+cstr(i)+""">["+cstr(i)+"]</a> "
  end if
 next
end if
%>

</body>
</html>
