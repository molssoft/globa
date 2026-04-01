<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

vards = trim(request.form("vards"+cstr(id)))
uzvards = trim(request.form("uzvards"+cstr(id)))
pilseta = trim(request.form("pilseta"+cstr(id)))
adrese = trim(request.form("adrese"+cstr(id)))
indeks = trim(request.form("indeks"+cstr(id)))
epasts = trim(request.form("epasts"+cstr(id)))

q = request.form("qstring")

session("message") = ""
if session("message") = "" and epasts <> "" then
 if Not CheckEmail(epasts) then session("message") = "Emails ir nepareizs."
end if

if session("message") = "" then
	'Pârbauda vai status ir mainîjies
 conn.execute "UPDATE dalibn_pas SET vards = N'" + vards + "',uzvards = N'" + uzvards + "',pilseta = N'" + pilseta + "',adrese = N'" + adrese + "',indeks = '" + indeks + "',epasts = N'" + epasts + "' WHERE id = " + cstr(id)
end if
response.redirect "dalibn_pas.asp"+q
%>


