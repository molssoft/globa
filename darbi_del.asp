<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

conn.execute "DELETE FROM darbi where id = " + cstr(id)
response.redirect "darbi.asp"

%>


