<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
conn.execute "DELETE FROM pr_marsruts where id = " +cstr(id)

response.redirect "pr.asp"

%>
