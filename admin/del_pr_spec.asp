<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
marsruts_id = request.form("marsruts_id")
conn.execute "DELETE FROM pr_spec_pied where id = " +cstr(id)

response.redirect "pr_details.asp?id="+cstr(marsruts_id)

%>
