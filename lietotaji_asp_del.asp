<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
conn.execute "DELETE FROM lietotaji_asp where id = " + cstr(id)
response.redirect "lietotaji_asp.asp"
%>


