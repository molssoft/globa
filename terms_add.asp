<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
OpenConn
if request.form("gid") = "" then
	session("message") = "Nav norâdîta grupa."
	response.redirect "terms.asp"
end if
session("lastgid") = request.form("gid")
if request.form("datums") = "" then
	session("message") = "Nav norâdîts datums."
	response.redirect "terms.asp"
end if
if request.form("summa") = "" then
	session("message") = "Nav norâdîta summa."
	response.redirect "terms.asp"
end if
set rec = server.createobject("ADODB.Recordset")
rec.open "select * from terms", conn,3,3
rec.addnew
rec("gid") = request.form("gid")
rec("datums") = request.form("datums")
rec("summa") = getnum(request.form("summa"))
rec("vietas_veids") = getnum(Request.Form("vietas_veids"))
rec.update
response.redirect "terms.asp"
%>