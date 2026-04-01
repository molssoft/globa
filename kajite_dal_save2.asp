<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
Dim Conn
OpenConn
if Request.QueryString("did") <> "" then
	session("did") = getnum(Request.QueryString("did"))
end if

set r = server.CreateObject("ADODB.Recordset")

if session("did") = 0 then
	'Add person to database
	r.Open "select * from dalibn where id = 0",conn,3,3
	r.AddNew
	if session("vards") <> "" then r("vards") = session("vards")
	if session("uzvards") <> "" then r("uzvards") = session("uzvards")
	if session("dzim_datums") <> "" then r("pk1") = session("dzim_datums")
	if session("PaseS") <> "" then r("PaseS") = session("PaseS")
	if session("PaseNr") <> "" then r("PaseNr") = session("PaseNr")
	if session("dzimta") <> "" then r("dzimta") = session("dzimta")
	r.Update
	r.Close
	r.Open "select * from dalibn where uzvards = '"+session("uzvards")+"' ORDER BY ID",conn,3,3
	r.MoveLast
	session("did") = r("id")
	r.Close
end if

'Pârbauda vai dalîbniekam jau ir pieteikums uz ðo grupu
set rCheck = conn.execute("SELECT * FROM pieteikums INNER JOIN piet_saite ON pieteikums.id = piet_saite.pid WHERE pieteikums.deleted = 0 and gid = " + cstr(Session("LastGid")) + " AND piet_saite.did = " + cstr(Session("did")))
if rCheck.eof then
	'Izveido jaunu pieteikumu
	conn.execute "INSERT INTO Pieteikums (gid) VALUES (" + cstr(session("Lastgid")) + ")"
	r.Open "SELECT id FROM Pieteikums WHERE gid = " + cstr(session("Lastgid")) + " ORDER BY ID ",conn,3,3
	r.MoveLast
	pid = r("id")
else
	'Izmanto esoðo
	pid = rCheck("pid")
end if

' --- pievieno saiti
'--- kadu vietu izveeleeties

set rVV = conn.execute("select id from vietu_veidi where gid = "+cstr(session("LastGid"))+" and persona = 1 ")
normala_vieta = 0
if not rVV.eof then
 normala_vieta = rVV("id")
end if

set rVV = conn.execute("select id from vietu_veidi where gid = "+cstr(session("LastGid"))+" and papildv = 1 ")
papild_vieta = 0
if not rVV.eof then
 papild_vieta = rVV("id")
end if


if session("kvietas_veids") = 3 and session("papildv") = "TRUE" then
 conn.execute "INSERT INTO Piet_saite (pid,did,kid,kvietas_veids,vietas_veids,vietsk,papildv2,papildv) VALUES (" + cstr(pid) + "," + cstr(session("did")) + ",0,0,"+cstr(papild_vieta)+",1,0,1)"
 papildv2 = "1"
 vietsk = 0
end if
if session("kvietas_veids") <> 3 and session("papildv") = "TRUE" then
 conn.execute "INSERT INTO Piet_saite (pid,did,kid,kvietas_veids,vietas_veids,vietsk,papildv2,papildv) VALUES (" + cstr(pid) + "," + cstr(session("did")) + ",0,0,"+cstr(papild_vieta)+",1,0,1)"
 papildv2 = "1"
 vietsk = 1
end if
if session("kvietas_veids") = 3 and session("papildv") <> "TRUE" then
 vietsk = 0
 papildv2 = "0"
end if
if session("kvietas_veids") <> 3 and session("papildv") <> "TRUE" then
 vietsk = 1
 papildv2 = "0"
end if

conn.execute "INSERT INTO Piet_saite (pid,did,kid,kvietas_veids,vietas_veids,vietsk,papildv2) VALUES (" + cstr(pid) + "," + cstr(session("did")) + "," + cstr(session("kid")) + "," + cstr(session("kvietas_veids")) + ","+cstr(normala_vieta)+","+cstr(vietsk)+","+papildv2+")"
pieteikums_recalculate pid

Response.Redirect "kajite.asp?gid=" + cstr(session("LastGid"))
%>