<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
set piet = server.createobject("ADODB.Recordset")
set dal = server.createobject("ADODB.Recordset")


did = request.querystring("did")
confirmed = request.querystring("confirmed")
if confirmed = "" then
	piet.open "Select * from piet_saite where deleted = 0 and did = "+cstr(did),conn,3,3
	dal.open "Select * from dalibn where id = "+cstr(did),conn,3,3
	if piet.recordcount <> 0 then 
		session("dmessage") = "Dalîbnieku nevar dzçst, jo tas ir reìistrçts pieteikumos"
		response.redirect "dalibn.asp?i="+cstr(did)
	else
		session("message") = "<center>Vai vçlaties dzçst dalîbnieku: "+nullprint(dal("vards")) + " " + nullprint(dal("uzvards")) + " " + nullprint(dal("nosaukums"))+"?<p>"
		session("confirm") = "'dalibn_del.asp"+qstring()+"&confirmed=yes'"
		session("decline") = "'dalibn_del.asp"+qstring()+"&confirmed=no'"
		response.redirect ("bridinajums.asp")
	end if
end if
piet.open "Select * from piet_saite where deleted = 0 and did = "+cstr(did),conn,3,3
if piet.recordcount <> 0 then 
	session("dmessage") = "Dalîbnieku nevar dzçst, jo tas ir reìistrçts pieteikumos"
	response.redirect "dalibn.asp?i="+cstr(did)
end if

if confirmed = "yes" then
	Del_dal did
	session("dmessage") = "Dalîbnieks ir dzçsts"
	response.redirect ("dalibn.asp")
end if
if confirmed = "no" then
	response.redirect ("dalibn.asp?i="+cstr(did))
end if
%>


