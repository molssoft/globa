<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
vards = trim(request.form("vards"))
uzvards = trim(request.form("uzvards"))
pilseta = trim(request.form("pilseta"))
adrese = trim(request.form("adrese"))
indeks = trim(request.form("indeks"))
epasts = trim(request.form("epasts"))

q = request.form("qstring")

session("message") = ""

if session("message") = "" and epasts<>"" then
 set r = conn.execute("select * from dalibn_pas where epasts like '"+epasts+"'")
 if not r.eof then
   session("message") = "Ðâds emails jau ir ievadîts."
 end if
end if
if session("message") = "" and epasts<>"" then
 if CheckEmail(epasts) = False then session("message") = "Emails ir kïûdains."
end if
if session("message") = "" then 
 conn.execute "INSERT INTO dalibn_pas (vards,uzvards,pilseta,adrese,indeks,epasts) VALUES (N'" + vards + "',N'" + uzvards + "',N'" + pilseta + "',N'" + adrese + "','" + indeks + "','" + epasts + "')"
end if

response.redirect "dalibn_pas.asp"+q

%>


