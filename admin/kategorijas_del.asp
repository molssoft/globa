<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

conn.execute "DELETE FROM kat_marsruti where kategorija = '" +cstr(id) + "'"
conn.execute "DELETE FROM kategorijas where id = '" +cstr(id) + "'"
response.redirect "kategorijas.asp"
%>