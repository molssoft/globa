<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
Set dal = Server.createobject("ADODB.Recordset")
Set ord = Server.createobject("ADODB.Recordset")
psid = request.querystring("psid")
pid = id_field("piet_saite",psid,"pid")
dal.open "Select * from piet_saite where (deleted = 0 ) and pid = "+cstr(pid),conn,3,3
ord.open "Select * from orderis where (deleted = 0 ) and pid = "+cstr(pid),conn,3,3

if dal.recordcount = 1 and ord.recordcount > 0 then
	session("message") = "Dzçðot ðo dalîbnieku tiktu izdzçsts pieteikums. Pieteikumu nav iespçjams dzçst, jo tas satur iemaksas."
	response.redirect ("pieteikums.asp?pid="+cstr(pid))
end if

confirmed = request.querystring("confirmed")
'response.write qstring()
if confirmed = "" then
	if dal.recordcount > 1 then 
		session("message") = "Vai vçlaties dzçst pakalpojumu?"
	else
		session("message") = "Vai vçlaties dzçst pakalpojumu? <p> Ðis ir pçdçjais dalîbnieks, ja tas tiks izdzçsts, tad tiks izdzçsts arî pieteikums un tam piesaistîtâs operâcijas!"
	end if
	session("confirm") = "'piet_saite_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'piet_saite_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if
set rec = server.createobject("ADODB.Recordset")
rec.open "Select * from piet_saite where id = "+cstr(psid),conn,3,3
if confirmed = "yes" then
	Del_Piet_saite psid
	dal.close
	dal.open "Select * from piet_saite where (deleted = 0 ) and pid = "+cstr(pid),conn,3,3
	if dal.recordcount = 0 then Del_Piet pid
	session("message") = "Dalîbnieks ir dzçsts"
	
	
	if dal.recordcount = 0 then
		response.redirect ("dalibn.asp?i="+cstr(id_field("piet_saite",psid,"did")))
	else
		response.redirect ("pieteikums.asp?pid="+cstr(rec("pid")))
	end if
end if
if confirmed = "no" then
	response.redirect ("pieteikums.asp?pid="+cstr(rec("pid")))
end if
%>


