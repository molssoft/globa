<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.querystring("id")
bilde = request.querystring("bilde")

conn.execute ("update majas set bilde = "+cstr(bilde)+" where id = "+cstr(id))
set r=conn.execute("select cena from majas where id="+cstr(id))
response.redirect "majas.asp?id="+cstr(r("cena"))
%>