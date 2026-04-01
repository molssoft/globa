<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

nosaukums_lat = request.form("new_nosaukums_lat")
nosaukums_eng = request.form("new_nosaukums_eng")

conn.execute("insert into viesnicu_vietas (nosaukums_lat,nosaukums_eng) values ('"+SQLText(nosaukums_lat)+"','"+SQLText(nosaukums_eng)+"')")

response.redirect "viesnicu_vietas.asp"
%>
