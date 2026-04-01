<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
gid = request.querystring("gid")

if gid = 0 or gid = "" then 
	session("message") = "Nav norâdîts grupas nummurs"
end if
	
docstart "Viesnicas numuru vçsture","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Viesnîcas numuru vçsture</b></font><hr>
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
	qry = "select vv.nosaukums,vesture from viesnicas v,viesnicas_veidi vv WHERE v.veids=vv.id and v.gid = " & cstr(gid) & ""
	'rw qry
	set r = conn.Execute(qry)
	'set r = conn.Execute("Select vv.nosaukums,JN_veids, JN_laiks, JN_lietotajs FROM viesnicas_jn jn,viesnicas v,viesnicas_veidi vv WHERE v.id=jn.id AND v.veids=vv.id AND jn.gid = " & cstr(gid) & " ORDER BY JN_laiks")
	  'rw "Select JN_veids, JN_laiks, JN_lietotajs FROM viesnicas_jn WHERE gid = " & cstr(gid) & " ORDER BY JN_laiks"
	
	%>

	
	<% while not r.eof
	%><tr bgcolor="#ffc1cc">
		<td><%=cstr(r("nosaukums"))%>
		</td><td align="right" ><%
		Response.write r("vesture")
		r.movenext 
	%></td></tr><%
	Wend
	
	%>
	</table>
	
	
	
	
	
<% end if %>

