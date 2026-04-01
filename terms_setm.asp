<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim count
dim conn
OpenConn
if request.form("mid") = "" then
	session("message") = "Nav norâdîts marðruts."
	response.redirect "terms.asp"
end if
session("lastmid") = request.form("mid")
if request.form("gid") = "" then
	session("message") = "Nav norâdîta grupa."
	response.redirect "terms.asp"
end if
session("lastgid") = request.form("gid")
gid = request.form("gid")
maid = request.form("mid")
set rect = server.createobject("ADODB.Recordset")
set recg = server.createobject("ADODB.Recordset")
set rec = server.createobject("ADODB.Recordset")

rect.open "select * from terms where gid = "+cstr(gid), conn,3,3
recg.open "select * from grupa where mid = "+cstr(maid),conn,3,3
rec.open "select * from terms",conn,3,3
while not recg.eof
if trim(recg("id")) <> trim(cstr(gid)) then
	conn.execute "delete from terms where gid = "+cstr(recg("id"))
	rect.movefirst
	while not rect.eof
		rec.addnew
		rec("gid") = recg("id")
		rec("datums") = rect("datums")
		rec("summa") = rect("summa")
		rec.update
		count = count + 1
		add_log "terms",rec("id"),"INSERT"
		rect.movenext
	wend
end if
recg.movenext
wend
response.redirect "terms.asp"
%>