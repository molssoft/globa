<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("add_id")
nosaukums = request.form("add_nosaukums")
gr_nosaukums = request.form("add_gr_nosaukums")
galva = request.form("add_galva")
karte = request.form("add_karte")
sadala = request.form("add_sadala")
npk = request.form("add_npk")
citats = request.form("add_citats")+" "

conn.execute("insert into mgrupas (id,nosaukums,gr_nosaukums,galva,karte,sadala,npk,citats) values ('"+id+"','"+nosaukums+"','"+gr_nosaukums+"','"+galva+"','"+karte+"','"+sadala+"','"+npk+"','"+citats+"')" )

response.redirect "default.asp"
%>
