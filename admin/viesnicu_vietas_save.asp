<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn
id = request.Form("id")
nosaukums_lat = request.form("nosaukums_lat"+cstr(id))
nosaukums_eng = request.form("nosaukums_eng"+cstr(id))

conn.execute ("update viesnicu_vietas set nosaukums_lat = '"+SQLText(nosaukums_lat)+"',nosaukums_eng = '"+SQLText(nosaukums_eng)+"' where id = "+cstr(id))
'Response.Write "update viesnicu_vietas set nosaukums_lat = '"+SQLText(nosaukums_lat)+"',nosaukums_eng = '"+SQLText(nosaukums_eng)+"' where id = "+cstr(id)

Response.redirect "viesnicu_vietas.asp"
%>
