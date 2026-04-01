<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

id = request.querystring("id")
confirmed = request.querystring("confirmed")
if confirmed = "" then
	session("message") = "Vai vçlaties dzçst dalîbnieku no kajîtes?"
	session("confirm") = "'kajite_dal_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'kajite_dal_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")

if confirmed = "yes" then
	if isGroupBlocked(Session("LastGid")) then
		session("message") = "Grupa ir bloíçta. Dalîbnieku nevar izòemt no kajîtes. Lûdzu griesties pie grupas kuratora."
		response.redirect ("kajite.asp?gid="+Session("LastGid"))
	end if
	del_piet_saite(id)
	if session("message") = ""  then session("message") = "Dalîbnieks ir dzçsts"
	response.redirect ("kajite.asp?gid="+Session("LastGid"))
end if
if confirmed = "no" then
	session("message") = ""
	response.redirect ("kajite.asp?gid="+Session("LastGid"))
end if
%>


