<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.querystring("id"))

conn.execute  "update dalibn set jaunumi = 0 where id in (select did from email_list where id = "+cstr(id)+")"
conn.execute "DELETE FROM email_list where id = " + cstr(id)
session("message") = "Ieraksts dzçsts."
response.redirect "email_list.asp"+Request.form("qstring")

%>


