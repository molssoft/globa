<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Marðruti","y1.jpg" 
PageSize = 20

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>Marðruti</b></font><hr>
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
<form name="forma_mekl" action="marsruti.asp" method=PUT>
<center> 
<table border="0">
 <tr>
  <td bgcolor="#ffc1cc">Nosaukums satur</td>
  <td><input type=text name="nos" value="<%=request.querystring("nos")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Veids</td>
  <td><select name="old">
   <option value="x" <%if request.querystring("old")="x" then response.write "selected"%>>Visi</option>
   <option value="0" <%if request.querystring("old")="0" then response.write "selected"%>>Tikai jaunie</option>
   <option value="1" <%if request.querystring("old")="1" then response.write "selected"%>>Tikai vecie</option>
  </select></td>
 </tr>
</table>
<input type="image" name="meklet" alt="Atrod marðrututs pçc formâ norâdîtajiem datiem." src="impro/bildes/meklet.jpg">
</form>

<form name="forma" method="POST">
<table border="0">
<tr bgcolor="#ffc1cc">
<th>Nr.</th>
<th>Nosaukums</th>
<th>USD</th>
<th>Vecs</th>
<th></th>
<th></th>
</tr>
<%
query = "Select id,v,old,usd from marsruts where 1=1 "
if request.querystring("nos")<>"" then query = query + " and v like N'%"+request.querystring("nos")+"%'"
if request.querystring("old")<>"x" and request.querystring("old")<>"" then query = query + " and old = "+request.querystring("old")
query = query + " ORDER BY v"
set r = server.createobject("ADODB.Recordset")
r.PageSize = PageSize
r.open query,conn,3,3

if not r.eof then
  r.AbsolutePage = p
	rec = 1
	while not r.eof and rec<=PageSize
		%>
	    <tr bgcolor="#fff1cc">
	    <td><%=r("id")%></td>
	    <td><input type="text" name="v<%=r("id")%>" size="80" value="<%=NullPrint(r("v"))%>"></td>
		<td><input disabled type="checkbox" name="usd<%=r("id")%>" <%if r("usd")=true then response.write " checked "%>></td>
		<td><input type="checkbox" name="old<%=r("id")%>" <%if r("old")=true then response.write " checked "%>></td>
		<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.action = 'marsruti_del.asp?id=<%=cstr(r("id"))%>'; return true;" alt="Dzçst marðrutu." WIDTH="25" HEIGHT="25"></td>
		<td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.action =  'marsruti_save.asp?id=<%=cstr(r("id"))%>'; return true;" alt="Saglabât izdarîtâs izmaiòas ðajâ rindâ." id="image1" name="image1" WIDTH="25" HEIGHT="25"></td></tr>
		<%
		rec=rec+1
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
 <td></td>
 <td align="center"><input type="text" size="80" name="v" size="30"></td>
 <td><input disabled type="checkbox" name="usd" ></td>
 <td><input type="checkbox" name="old" ></td>
<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.action = 'marsruti_add.asp'; return true;" alt="Pievienot aìentu." WIDTH="25" HEIGHT="25"></td>
</tr></table>
<input type=hidden name=qstring value="<%=qstring%>">
</form>

<%
if r.RecordCount > 0 then
 for i = 1 to r.PageCount
  if cstr(p) = cstr(i) then
   response.write "<b>["+cstr(i)+"]</b> "
  else
   response.write "<a href=""marsruti.asp?nos="+request.querystring("nos")+"&old="+request.querystring("old")+"&meklet.x="+request.querystring("meklet.x")+"&p="+cstr(i)+""">["+cstr(i)+"]</a> "
  end if
 next
end if
%>

</body>
</html>
