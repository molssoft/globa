<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
conn.execute "DELETE FROM lidm_bil where id = " +cstr(id)

response.redirect "avio.asp"

%>
