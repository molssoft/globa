<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
set rec = server.createobject("ADODB.Recordset")
set dal = server.createobject("ADODB.Recordset")
set ord = server.createobject("ADODB.Recordset")


pid = request.querystring("pid")
did = request.querystring("did")

'Pârbauda vai pieteikumam ir iemaksas
ord.open "Select * from orderis where (deleted = 0 ) and pid = "+cstr(pid),conn,3,3
if ord.recordcount <> 0 then
	session("dmessage") = "<font size = 5 color = red>Pieteikumu nevar dzçst jo zem tâ ir reìistrçtas iemaksas.</font>"
	response.redirect ("dalibn.asp?i="+cstr(did))
end if


confirmed = request.querystring("confirmed")
if confirmed = "" then
	rec.open "Select * from pieteikums where (deleted = 0 ) and id = "+cstr(pid),conn,3,3
	dal.open "Select * from piet_saite where (deleted = 0 ) and pid = "+cstr(pid),conn,3,3

	
	
	session("message") = "<center>Vai vçlaties dzçst pieteikumu?<p>"+ _
		"Pieteikumâ ietilpstoðo dalîbninieku skaits: "+cstr(dal.recordcount) + "<p>"+ _
		"Pieteikumam piesaistîto operâciju skaits: "+cstr(ord.recordcount)
		
	set rOnline = conn.execute("select isnull(online_rez,0) from pieteikums where id = " + cstr(pid))
	set online_rez = rOnline(0)
	
	set rOnlineExists = conn.execute("select * from online_rez where id = " + cstr(online_rez))
	
	if not rOnlineExists.eof then
		if online_rez<>0 then
			set rNoDelete = conn.execute("select no_delete from online_rez where id = " + cstr(online_rez))
			set no_delete = rNoDelete(0)
			if no_delete = 1 then
				session("message") = session("message") + "<p>Online rezervâcijai uzstâdîts parametrs no_delete=1 (iespçjams, ka ir maksâjumi, kuriem nav izveidojuðies orderi)"
			end if
		end if
	end if
	session("confirm") = "'piet_del.asp"+qstring()+"&confirmed=yes'"
	session("decline") = "'piet_del.asp"+qstring()+"&confirmed=no'"
	response.redirect ("bridinajums.asp")
end if

rec.open "Select * from pieteikums where id = "+cstr(pid),conn,3,3

if confirmed = "yes" then
	
	Del_piet pid
	
	'--- dzçð ierakstu tabulâ balle
		conn.execute("DELETE FROM balles_pieteikumi where pid="+pid)
	'---
	
	session("message") = "Pieteikums ir dzçsts"
	response.redirect ("dalibn.asp?i="+cstr(did))

end if

if confirmed = "no" then
	response.redirect ("dalibn.asp?i="+cstr(did))
end if
%>


