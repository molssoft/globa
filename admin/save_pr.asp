<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

new_id = request.form("id"+cstr(id))
kompanija = request.form("kompanija"+cstr(id))
valsts = request.form("valsts"+cstr(id))
marsruts = request.form("marsruts"+cstr(id))

conn.execute("update pr_marsruts set id = "+cstr(new_id)+", kompanija = '"+ kompanija +"', valsts = '"+ valsts +"', marsruts='" + marsruts + "' where id = "+cstr(id))
response.redirect "pr.asp"
%>
