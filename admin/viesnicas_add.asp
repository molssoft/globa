<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

nosaukums = request.form("new_nosaukums")
vieta = request.form("new_vieta")

conn.execute("insert into viesnicas (nosaukums,vieta) values ('"+SQLText(nosaukums)+"',"+cstr(vieta)+")")

response.redirect "viesnicas.asp"
%>
