<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
v = request.form("v")

if request.form("old") = "on" then
 old = "1"
else
 old = "0"
end if

q = request.form("qstring")

session("message") = ""
if v = "" then session("message") = "Nav norâdîts marðruta nosaukums."

if session("message") = "" then conn.execute "INSERT INTO marsruts (v,v2,usd,old) VALUES (N'" + v + "',N'"+encode(v2)+"',0,"+old+")"
response.redirect "marsruti.asp"+q
%>


