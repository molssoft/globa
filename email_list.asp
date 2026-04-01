<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

if not IsAccess(T_SK_EMAILI) then 
 session("message") = "Interesentu adreses nav pieejamas"
 Response.Redirect "default.asp"
end if

docstart "Interesentu e-pasta adreses","y1.jpg" 
PageSize = 20

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>Interesentu e-pasta adreses</b></font><hr>
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
<form name="forma_mekl" action="email_list.asp" method=PUT>
<center> 
<table border="0">
 <tr>
  <td bgcolor="#ffc1cc">E-adrese satur</td>
  <td><input type=text name="email" value="<%=request.querystring("email")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Pievienoðanas periods</td>
  <td><input type=text name="dat_no" size=10 value="<%=request.querystring("dat_no")%>">-
  <input type=text name="dat_lidz" size=10 value="<%=request.querystring("dat_lidz")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Sakârtojums</td>
  <td><select name="order">
   <option value="datums_izv" <%if request.querystring("order")="datums_izv" then response.write "selected"%>>pievienoðanas datums</option>
   <option value="datums_status" <%if request.querystring("order")="datums_status" then response.write "selected"%>>statusa izmaiòas datums</option>
   <option value="email" <%if request.querystring("order")="email" then response.write "selected"%>>e-adrese</option>
  </select></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Tikai atslçgtâs</td>
  <td><input type=checkbox name="signedout" <%If request.querystring("signedout")="on" then Response.Write " checked "%>></input></td>
 </tr>
</table>
<input type="image" name="meklet" src="impro/bildes/meklet.jpg">
</form>

<form name="forma" method="POST">
<table border="0">
<tr bgcolor="#ffc1cc">
<th>Nr.</th>
<th>e-adrese</th>
<th></th>
<th>Pievienota</th>
<th>Mainîts st.</th>
<th>Stat.</th>
<th></th>
<th></th>
</tr>
<%
query = "Select id,email,parole,datums_izv,datums_status,status,did from email_list where 1=1 "
if request.querystring("email")<>"" then query = query + " and email like N'%"+request.querystring("email")+"%'"
if Request.QueryString("signedout")="on" then query = query + " and status = 'N'"
dat_no = Request.QueryString("dat_no")
dat_lidz = Request.QueryString("dat_lidz")
if dat_no<>"" then query = query + " and datums_izv >= '" + SQLDate(Formateddate(dat_no,"dmy")) + "'"
if dat_lidz<>"" then query = query + " and datums_izv < '" + SQLDate(Formateddate(dat_lidz,"dmy")+1) + "'"
order = Request.QueryString("order")
if order = "" then order = "datums_izv"
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
	    <td><input type="text" name="email<%=r("id")%>" size="30" value="<%=NullPrint(r("email"))%>"></td>
	    <td><%=r("parole")%></td>
		<td><%=dateprint(r("datums_izv"))%></td>
		<td><%=dateprint(r("datums_status"))%></td>
		<td align="center">
		 <select name="status<%=r("id")%>">
		  <option value="X">-</option>
		  <option value="Y" <% if r("status")="Y" then Response.Write "selected"%> >Pieslçgta</option>
		  <option value="N" <% if r("status")="N" then Response.Write "selected"%> >Atslçgta</option>
		 </select></td>
		<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.action = 'email_list_del.asp?id=<%=cstr(r("id"))%>'; return confirm('Vai vçlaties dzçst ierakstu?'); " alt="Dzçst ierakstu." WIDTH="25" HEIGHT="25"></td>
		<td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.action =  'email_list_save.asp?id=<%=cstr(r("id"))%>'; return true;" alt="Saglabât izdarîtâs izmaiòas ðajâ rindâ." WIDTH="25" HEIGHT="25"></td>
		<%
		if not isnull(r("did")) then
		 Response.Write "<td><a href=dalibn.asp?i="+cstr(r("did"))+">GLOBA</a></td>"
		end if
		%></tr><%
		rec=rec+1
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
 <td></td>
 <td align="center"><input type="text" size="30" name="email"></td>
 <td></td>
 <td></td>
 <td align="center">
  <select name="status">
   <option value="Y">Pieslçgta</option>
   <option value="N">Atslçgta</option>
  </select></td>
 <td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.action = 'email_list_add.asp'; return true;" alt="Pievienot ierakstu." WIDTH="25" HEIGHT="25"></td>
</tr></table>
<input type=hidden name=qstring value="<%=qstring%>">
</form>

<%
if r.RecordCount > 0 then
 for i = 1 to r.PageCount
  if cstr(p) = cstr(i) then
   response.write "<b>["+cstr(i)+"]</b> "
  else
   response.write "<a href=""email_list.asp?email="+request.querystring("email")+"&dat_no="+Request.QueryString("dat_no")+"&dat_lidz="+Request.QueryString("dat_lidz")+"&order="+request.querystring("order")+"&signedout="+Request.QueryString("signedout")+"&p="+cstr(i)+""">["+cstr(i)+"]</a> "
  end if
 next
end if
%>

</body>
</html>
