<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = request.querystring("id")
gid = request.form("gid")

nosaukums = request.form("nosaukums"+cstr(id))
pilns_nosaukums = request.form("pilns_nosaukums"+cstr(id))
if nosaukums = "" then nosaukums = "Bez nosaukuma"
piezimes = request.form("piezimes"+cstr(id))
pieaug_vietas = getnum(request.form("pieaug_vietas"+cstr(id)))
bernu_vietas =  getnum(request.form("bernu_vietas"+cstr(id)))
vietas = getnum(request.form("vietas"+cstr(id)))
var2 = getnum(request.form("var2"+cstr(id)))
if (var2="") then var2 = "0"
cena = request.form("cena"+cstr(id))
if cena="" then cena = "NULL"
cena_child = request.form("cena_child"+cstr(id))
if cena_child="" then cena_child = "NULL"

save  = true
kopa_v = cint(bernu_vietas) + cint(pieaug_vietas) 
if (kopa_v <> 0 and cint(kopa_v) <> cint(vietas)) then
	session("message") = "Pieauguğo un bçrnu vietu skaits nesakrît ar kopçjo vietu skaitu."
	save= false
end if

if (save) then
conn.execute "UPDATE viesnicas_veidi " + _
	"SET nosaukums=N'" + nosaukums+"'" + _
	",pilns_nosaukums=N'" + pilns_nosaukums+"'" + _
	",piezimes=N'" + piezimes+"'" + _
	",pieaug_vietas=" + cstr(pieaug_vietas)+"" + _
	",vietas=" + cstr(vietas) + "" + _
	",var2=" + cstr(var2) + "" + _
	",bernu_vietas=" + cstr(bernu_vietas)+" " + _
	",vietu_veidi_id=" + cstr(cena)+" " + _
	",vietu_veidi_child_id=" + cstr(cena_child)+" " + _
	" WHERE id = " + cstr(id)
	RefreshViesnVeids(id)
end if
'response.end
response.redirect "viesnicas_veidi.asp?gid="+cstr(gid)
%>


