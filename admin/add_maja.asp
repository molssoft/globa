<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

apraksts = request.form("add_apraksts")

conn.execute("insert into majas (cena,bilde,apraksts) values ("+cstr(id)+",1,'"+apraksts+"')" )

response.redirect "majas.asp?id="+id
%>
