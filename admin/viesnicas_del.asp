<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

conn.execute "DELETE FROM viesnicas where id = " +cstr(id)
response.redirect "viesnicas.asp"
%>