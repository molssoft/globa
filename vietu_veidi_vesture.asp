<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
gid = request.querystring("gid")

if gid = 0 or gid = "" then 
	session("message") = "Nav norâdîts grupas nummurs"
end if
	
docstart "Vietu veidu vçsture","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Vietu veidu vçsture</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if gid <> 0 and gid <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Grupai <%=grupas_nosaukums (gid,NULL)%></b></font>
	<center>
	<table border="1">
	<%
	qry = "select nosaukums,vesture from vietu_veidi where gid = " & cstr(gid) & ""
	'rw qry
	set r = conn.Execute(qry)
	'rw "Select AuditDMLAction, AuditDateTime,AuditUser FROM dalibn_Audit WHERE  id = " & cstr(did) & " ORDER BY AuditDateTime"
	while not r.eof
	%><tr bgcolor="#ffc1cc">
	<td style="vertical-align:top;text-align:right"><%=cstr(r("nosaukums"))%></td>
	<td align="right" ><%	
		Response.write r("vesture") 
		r.movenext 
	%></td></tr><%
	Wend
	%>
	</table>
<% end if %>

