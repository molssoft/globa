<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

conn.execute "DELETE FROM temas_marsruti where tema = '" +cstr(id) + "'"
conn.execute "DELETE FROM temas where id = '" +cstr(id) + "'"
response.redirect "intereses.asp"
%>