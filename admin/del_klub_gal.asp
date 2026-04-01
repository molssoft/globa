<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("klub_gal_id")

conn.execute "DELETE FROM klub_gal where id = " +cstr(id)
response.redirect "klub_gal.asp?id="+cstr(id)
%>