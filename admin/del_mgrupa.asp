<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

mgrupa_id = request.form("mgrupa_id")
conn.execute "DELETE FROM mgrupas where id = '" +cstr(mgrupa_id)+"'"

response.redirect "default.asp"

%>