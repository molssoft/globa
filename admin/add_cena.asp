<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

'marsruta id
id = request.form("id")
cena = request.form("cena")
cena_txt = request.form("cena_txt")

if cena = "" then cena="0"

conn.execute "INSERT INTO cenas (marsruts,cena,cena_txt) VALUES ("+id+","+cena+",'"+cena_txt+"')" 
response.redirect "marsruts.asp?id="+id

%>
