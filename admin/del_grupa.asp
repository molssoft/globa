<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
grupa_id = request.form("grupa_id")

conn.execute "DELETE FROM grupas where id = " +cstr(grupa_id)
response.redirect "grupas.asp?cena_id="+id
%>