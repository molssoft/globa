<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("new_id")
nosaukums = request.form("new_nosaukums")

conn.execute("insert into temas (id,nosaukums,aktivs) values ('"+id+"','"+SQLText(nosaukums)+"',0)" )

response.redirect "intereses.asp"
%>
