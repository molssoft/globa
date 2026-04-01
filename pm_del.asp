<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

confirmed = request.querystring("confirmed")
if confirmed = "" then
	session("message") = "Vai vçlaties atcelt pçdçjâs minûtes cenu?"
	session("confirm") = "'pm_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'pm_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
if confirmed = "yes" then
	conn.execute "UPDATE grupa set pm = false where id = " + cstr(id)
	session("message") = ""
	response.redirect "pm_cenas.asp"
end if
if confirmed = "no" then
	response.redirect "pm_cenas.asp"
end if

%>


