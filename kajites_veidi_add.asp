<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
gid = Request.Form("mygid")

nosaukums = request.form("nosaukums")
if nosaukums = "" then nosaukums = "Bez nosaukuma"
vietas = getnum(request.form("vietas"))
standart_cena = getnum(request.form("standart_cena"))
bernu_cena = getnum(request.form("bernu_cena"))
pusaudzu_cena = getnum(request.form("pusaudzu_cena"))
papild_cena = getnum(request.form("papild_cena"))
papild2_cena = getnum(request.form("papild2_cena"))
senioru_cena = getnum(request.form("senioru_cena"))
conn.execute "INSERT INTO kajites_veidi (gid,nosaukums,vietas,standart_cena,bernu_cena,pusaudzu_cena,papild_cena,papild2_cena,senioru_cena) " + _
	" VALUES (" + cstr(gid) + ",N'" + nosaukums+"'," + cstr(vietas) + "," + cstr(standart_cena) + "," + cstr(bernu_cena) + "," + cstr(pusaudzu_cena) + "," + cstr(papild_cena) + ","+cstr(papild2_cena)+"," + cstr(senioru_cena) + ")"
response.redirect "kajites_veidi.asp?gid="+cstr(gid)
%>


