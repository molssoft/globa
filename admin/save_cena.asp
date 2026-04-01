<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
cena_id = request.form("cena_id")

cena = request.form("cena"+cstr(cena_id))
cena_txt = request.form("cena_txt"+cstr(cena_id))

set r = conn.execute("update cenas set cena = "+cena+", cena_txt = '"+cena_txt+"' where id = "+cstr(cena_id))
response.redirect "marsruts.asp?id="+id
%>
