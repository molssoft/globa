<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

conn.execute "DELETE FROM viesnicas where vieta = " +cstr(id)
conn.execute "DELETE FROM viesnicu_vietas where id = " +cstr(id)
response.redirect "viesnicu_vietas.asp"
%>