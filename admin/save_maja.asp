<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
maja_id = request.form("maja_id")

apraksts = request.form("apraksts"+cstr(maja_id))

conn.execute("update majas set apraksts = '"+apraksts+"' where id = "+cstr(maja_id))

response.redirect "majas.asp?id="+id
%>
