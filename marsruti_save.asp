<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
v = request.form("v"+cstr(id))
q = request.form("qstring")

if request.form("usd"+cstr(id)) = "on" then
 usd = "1"
else
 usd = "0"
end if

if request.form("old"+cstr(id)) = "on" then
 old = "1"
else
 old = "0"
end if

session("message") = ""
if v = "" then session("message") = "Nav norâdîts marðruta nosaukums."
if session("message") = "" then conn.execute "UPDATE marsruts SET v = N'" + v + "',v2=N'"+encode(v)+"', usd = "+usd+", old = "+old+" WHERE id = " + cstr(id)
response.redirect "marsruti.asp"+q
%>


