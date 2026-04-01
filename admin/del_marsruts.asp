<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

set r = conn.execute("select * from marsruti where id = "+cstr(id))
mgrupa = r("mgrupa")
conn.execute "DELETE FROM main_marsruti where marsruts = " + cstr(id)
conn.execute "DELETE FROM geo_marsruti where marsruts = " + cstr(id)
conn.execute "DELETE FROM marsruti where id = " +cstr(id)
response.redirect "default.asp"
%>