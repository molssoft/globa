<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

confirmed = request.querystring("confirmed")
if confirmed = "" then
	session("message") = "Vai vçlaties dzçst jaunumu?"
	session("confirm") = "'jaunumi_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'jaunumi_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
if confirmed = "yes" then
	conn.execute "DELETE FROM jaunumi where id = " + cstr(id)
	session("message") = ""
	response.redirect "jaunumu_lab.asp"
end if
if confirmed = "no" then
	response.redirect "jaunumu_lab.asp"
end if

%>


