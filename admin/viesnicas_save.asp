<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn
id = request.Form("id")
nosaukums = request.form("nosaukums"+cstr(id))
vieta = request.form("vieta"+cstr(id))

conn.execute ("update viesnicas set vieta="+cstr(vieta)+",nosaukums = '"+SQLText(nosaukums)+"' where id = "+cstr(id))

Response.redirect "viesnicas.asp"
%>
