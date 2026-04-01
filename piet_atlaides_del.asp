<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
id=Request.QueryString("id")
pid = request.querystring("pid")

confirmed = request.querystring("confirmed")
if confirmed = "" then 'ja nav nekas apstiprinâts vai neapstiprinâts
	session("message") = "Vai vçlaties dzçst atlaidi?"
	session("confirm") = "'piet_atlaides_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'piet_atlaides_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if

'rada savienojumu, caur kuru tad arî notiks darbîbas
dim conn
openconn
if confirmed = "yes" then
response.write cstr(id) + ","
 set r = conn.execute("select * from piet_atlaides where id = "+cstr(id))
 pid_l = r("pid")
 piet_atlaide_del(id) 
 pieteikums_recalculate(pid_l)
 session("message") = "Cenas korekcija izdzçsta."
 response.redirect ("pieteikums.asp?pid="+Session("pid"))
end if

if confirmed = "no" then
	response.redirect ("pieteikums.asp?pid="+Session("LastPid"))
end if
%>
