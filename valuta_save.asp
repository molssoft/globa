<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim valkurs
dim conn
openconn
kurss = request.form("kurss")
valuta = request.form("valuta")
datums = request.form("datums")

if kurss = "" then
	session("message") = "Nav norâdîts valûtas kurss"
	response.redirect "valuta.asp"
end if

set valkurs = server.createobject("ADODB.Recordset")
valkurs.open "select * from valutakurss where valuta = "+valuta+" and datums = #"+sqldate(datums)+"#",conn,3,3

if request.form("labot.x") <> "" then
	if valkurs.recordcount = 0 then
		session("message") = "Nav iespçjams labot jo, ðajâ dienâ kurss nav norâdîts."
		response.redirect "valuta.asp"
	end if
	valkurs("kurss") = kurss
	valkurs.update
	response.redirect "valuta.asp"
end if

if request.form("pievienot.x") <> "" then
	if valkurs.recordcount <> 0 then
		session("message") = "Nav iespçjams pievienot jo, ðajâ dienâ kurss jau eksistç."
		response.redirect "valuta.asp"
	end if
	conn.execute "INSERT INTO valutakurss (kurss,valuta,datums) VALUES ("+cstr(kurss)+","+cstr(valuta)+",#"+sqldate(datums)+"#)"
	if session("valutaord") <> 0 then 
		session("valutaord") = 0
		session("editedcurrency") = 1
		response.redirect "ord_transf.asp"
	else
		response.redirect "valuta.asp"
	end if
end if

%>