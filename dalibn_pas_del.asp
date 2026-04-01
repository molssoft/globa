<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.querystring("id"))

conn.execute "DELETE FROM dalibn_pas where id = " + cstr(id)
session("message") = "Ieraksts dzçsts."
response.redirect "dalibn_pas.asp"+Request.form("qstring")

%>


