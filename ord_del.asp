<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

set rOrd = Server.CreateObject("ADODB.Recordset")
oid = request.querystring("oid")
rOrd.Open "SELECT * FROM Orderis WHERE id = " + cstr(oid),conn,3,3
'response.write FormatDateTime(rOrd("datums"),2)

if rOrd("datums") <> Date then

	if not IsAccess(T_VEC_ORD_DZ) then
		session("message") = "Nevar izdzçst orderi, jo tas nav ðodien reìistrçts. Autorizâcijas kïûda."
		response.redirect ("pieteikums.asp?pid="+Session("LastPid"))
	end if
end if

confirmed = request.querystring("confirmed")
'response.write qstring()
if confirmed = "" then
	session("message") = "Vai vçlaties dzçst iemaksas orderi?"
	session("confirm") = "'ord_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'ord_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
rec.open "Select * from orderis where id = "+cstr(oid),conn,3,3
if confirmed = "yes" then
	'nosaka iesaistitos pieteikumus
	set r = conn.execute("select * from orderis where id = "+cstr(oid))
	pid = getnum(r("pid"))
	nopid = getnum(r("nopid"))
	DelOrderis(oid)
	session("message") = "Orderis izdzçsts"
	pieteikums_recalculate pid
	pieteikums_recalculate nopid
	response.redirect ("pieteikums.asp?pid="+Session("LastPid"))
end if
if confirmed = "no" then
	response.redirect ("pieteikums.asp?pid="+Session("LastPid"))
end if
%>


