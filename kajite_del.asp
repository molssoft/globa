<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

kid = request.querystring("kid")
confirmed = request.querystring("confirmed")
if confirmed = "" then
	session("message") = "Vai vçlaties dzçst kajîti?"
	session("confirm") = "'kajite_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'kajite_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
rec.open "Select * from kajite where id = "+cstr(kid),conn,3,3
if confirmed = "yes" then
	Del_Kajite(kid)
	session("message") = "Kajîte ir dzçsta"
	response.redirect ("kajite.asp?gid="+Session("LastGid"))
end if
if confirmed = "no" then
	response.redirect ("kajite.asp?gid="+Session("LastGid"))
end if
%>


