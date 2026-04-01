<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.querystring("id"))

q = request.form("qstring")
if mid(q,1,1) = "?" then q = "&"+mid(q,2,len(q)-1)

confirmed = request.querystring("confirmed")
if confirmed = "" then
	session("message") = "Vai vçlaties dzçst marðrutu?"
	session("confirm") = "'marsruti_del.asp"+qstring+q+"&confirmed=yes'"
	session("decline") = "'marsruti_del.asp"+qstring+q+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
if confirmed = "yes" then
	set r = conn.execute ("select id from grupa where mid = " + cstr(id))
	if r.eof then
	 conn.execute "DELETE FROM marsruts where id = " + cstr(id)
	 session("message") = ""
	else
	 session("message") = "Marðruts nevar tikt dzçsts, jo tas satur grupas."
	end if
	response.redirect "marsruti.asp?nos="+request.querystring("nos")+"&old="+request.querystring("old")
end if
if confirmed = "no" then
	response.redirect "marsruti.asp?nos="+request.querystring("nos")+"&old="+request.querystring("old")
end if

%>


