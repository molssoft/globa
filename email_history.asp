<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

if not IsAccess(T_SUT_EMAILI) then
 session("message") = "Emailu vçsture jums nav pieejama"
 Response.Redirect "default.asp"
end if

docstart "Izsûtîtâ e-pasta vçsture","y1.jpg" 
PageSize = 20

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>Izsûtîtâ e-pasta vçsture</b></font><hr>
<%
headlinks 



if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

if Request.QueryString("add") <> "" then
  id = Request.QueryString("add")
  conn.execute ("update email_history set sent = 0 where id = "+cstr(id))
end if

if Request.QueryString("del") <> "" then
  id = Request.QueryString("del")
  conn.execute ("update email_history set sent = 1 where id = "+cstr(id))
end if

DefJavaSubmit
%>
<form name="forma_mekl" action="email_history.asp" method=PUT>
<center> 
<table border="0">
 <tr>
  <td bgcolor="#ffc1cc">Vçstule satur</td>
  <td><input type=text name="contains" value="<%=request.querystring("contains")%>"></td>
 </tr>
 <tr>
  <td bgcolor="#ffc1cc">Sakârtojums</td>
  <td><select name="order">
   <option value="subject" <%if request.querystring("order")="subject" then response.write "selected"%>>alfabçtiski</option>
   <option value="kad" <%if request.querystring("order")="kad" then response.write "selected"%>>kad izsûtîts</option>
   <option value="kas" <%if request.querystring("order")="kas" then response.write "selected"%>>kas sûtîjis</option>
  </select></td>
 </tr>
</table>
<input type="image" name="meklet" src="impro/bildes/meklet.jpg">
<a href=message_compose.asp><img border=0 src="impro/bildes/pievienot.jpg"></a>
</form>

<form name="forma" method="POST">
<table border="0">
<tr bgcolor="#ffc1cc">
<th>Nr.</th>
<th>Kad</th>
<th>Kas</th>
<th>Tçma</th>
<th></th>
</tr>
<%
query = "Select id,subject,kad,kas,next_id,max_id,sent from email_history where 1=1 "
if request.querystring("contains")<>"" then query = query + " and (subject like N'%"+request.querystring("contains")+"%' or message like N'"+request.querystring("contains")+"')"
order = Request.QueryString("order")
if order = "" then order = " id desc "
query = query + " ORDER BY "+order
set r = server.createobject("ADODB.Recordset")
r.PageSize = PageSize
r.open query,conn,3,3

if not r.eof then
  r.AbsolutePage = p
	rec = 1
	while not r.eof and rec<=PageSize
		Response.Write "<tr"
		 'Response.Write r("id") & " " & r("sent") & " " & r("next_id") & " " & r("max_id") & "<br>" %>
	    <% if not r("sent") then
	     Response.Write " bgcolor = ""#80ff80"">"
	    else
	     Response.Write " bgcolor = ""#fff1cc"">"
	    end if%>
	    <td><%=r("id")%></td>
	    <td><%=r("kad")%></td>
	    <td><%=r("kas")%></td>
	    <td><a href="email_history_item.asp?id=<%=r("id")%>" target=_blank><%=r("subject")%></a></td>
	    <% 
	    if not r("sent") then
	      Response.Write ("<td><a href=""email_history.asp?del=" + cstr(r("id")) + "&contains="+request.querystring("contains")+"&p="+request.querystring("p")+"&order="+Request.QueryString("order")+""">Apturçt</a></td> ")
	    else
	      Response.Write ("<td></td><td></td>")
	    end if
	    %>
	    </font>
	    </tr>
	    <%
		rec=rec+1
		r.MoveNext
	wend
end if

%>
</table>
<%
if r.RecordCount > 0 then
 for i = 1 to r.PageCount
  if cstr(p) = cstr(i) then
   response.write "<b>["+cstr(i)+"]</b> "
  else
   response.write "<a href=""email_history.asp?contains="+request.querystring("contains")+"&p="+cstr(i)+"&order="+Request.QueryString("order")+""">["+cstr(i)+"]</a> "
  end if
 next
end if
%>

</body>
</html>
