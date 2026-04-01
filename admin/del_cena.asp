<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
cena_id = request.form("cena_id")

conn.execute "DELETE FROM cenas where id = " +cstr(cena_id)
response.redirect "marsruts.asp?id="+id
%>