<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

conn.execute "UPDATE darbi SET pabeigts = GETDATE() WHERE id = " + cstr(id)

response.redirect "darbi.asp"
%>


