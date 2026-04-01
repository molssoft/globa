<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
conn.execute "DELETE FROM cl_marsruts where id = " +cstr(id)

response.redirect "cl.asp"

%>
