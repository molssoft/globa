<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
iid = request.querystring("iid")

if iid = 0 or iid = "" then 
	session("message") = "Nav norâdîts interesenta nummurs"
end if
	
docstart "Interesenta vçsture","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Interesenta vçsture</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if iid <> 0 and iid <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Interesents nr. <%=cstr(iid)%></b></font>
	<center>
	<table border="1">
	<%
	set r = conn.Execute("Select JN_veids, JN_laiks, JN_lietotajs FROM interesenti_jn WHERE id = " & cstr(iid) & " ORDER BY JN_laiks")
	Dim action
	%>

	<tr>
		
		<th>Izmaiòu veicçjs</th>
		<th>Izmaiòu veids</th>
		<th>Datums un laiks</th>
	</tr>
	
	<% while not r.eof
	%><tr bgcolor="#ffc1cc"><td><%
		Response.write r("JN_lietotajs")
		%></td><td><%
		Select Case r("JN_veids")
			Case "I"
				action = "Izveidoja"
			Case "U"
				action = "Laboja"
			Case "D"
				action = "Dzçsa"
		End Select
		Response.Write action
		
	%></td>
	<td align="right" ><%
		Response.write r("JN_laiks")
		%></td></tr><%
		r.movenext 
	Wend
	set r = conn.Execute("Select vesture FROM interesenti WHERE id = " + cstr(iid))
	%>
	<tr><td align="right" bgcolor="#ffc1cc" colspan="3"><%=r("vesture")%></td></tr>
	
	
	</table>
<% end if %>

