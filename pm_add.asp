<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
gid = request.form("gid")
pm_cena = request.form("pm_cena")

session("message") = ""
if pm_cena = "" then session("message") = "Norâdiet pçdçjâs minûtes cenu."

query = "UPDATE grupa SET pm = true,pm_cena = " + pm_cena + " WHERE id = " + gid

if session("message") = "" then conn.execute Query
response.redirect "pm_cenas.asp"
%>


