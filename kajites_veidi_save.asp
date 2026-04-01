<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

dim conn
openconn
id = request.querystring("id")

gid = conn.execute("select gid from kajites_veidi where id = "+cstr(id))(0)

nosaukums = request.form("nosaukums"+cstr(id))
if nosaukums = "" then nosaukums = "Bez nosaukuma"
vietas = getnum(request.form("vietas"+cstr(id)))
standart_cena = getnum(request.form("standart_cena"+cstr(id)))
bernu_cena = getnum(request.form("bernu_cena"+cstr(id)))
pusaudzu_cena = getnum(request.form("pusaudzu_cena"+cstr(id)))
papild_cena = getnum(request.form("papild_cena"+cstr(id)))
papild2_cena = getnum(request.form("papild2_cena"+cstr(id)))
papild3_cena = getnum(request.form("papild3_cena"+cstr(id)))
senioru_cena = getnum(request.form("senioru_cena"+cstr(id)))
conn.execute "UPDATE kajites_veidi " + _
	"SET nosaukums=N'" + nosaukums+"',vietas=" + cstr(vietas) + ",standart_cena=" + cstr(standart_cena) + ",bernu_cena=" + cstr(bernu_cena) + ",pusaudzu_cena=" + cstr(pusaudzu_cena) + ",papild_cena=" + cstr(papild_cena) + ",papild2_cena=" + cstr(papild2_cena) +  ",papild3_cena=" + cstr(papild3_cena) +",senioru_cena=" + cstr(senioru_cena) + _
	" WHERE id = " + cstr(id)
kajites_veids_recalculate(id)
response.redirect "kajites_veidi.asp?gid="+cstr(gid)
%>


