<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
nosaukums = request.form("nosaukums")
gid=request.querystring("gid")

if nosaukums = "" then nosaukums = "Bez nosaukuma"
pilns_nosaukums = request.form("pilns_nosaukums")
piezimes = request.form("piezimes")
pieaug_vietas = getnum(request.form("pieaug_vietas"))
bernu_vietas = getnum(request.form("bernu_vietas"))
vietas = getnum(request.form("vietas"))
gid = getnum(request.form("gid"))

if pilns_nosaukums="" then
	''default translations
	if instr(nosaukums,"DOUBLE")<>0 then
		pilns_nosaukums = replace(nosaukums,"DOUBLE","Divvietîgs kopîga gulta")
	end if 

	if instr(nosaukums,"TWIN")<>0 then
		pilns_nosaukums = replace(nosaukums,"TWIN","Divvietîgs atseviðía gulta")
	end if 
	
	if instr(nosaukums,"SINGLE")<>0 then
		pilns_nosaukums = replace(nosaukums,"SINGLE","Vienvietîgs")
	end if 
	
	if instr(nosaukums,"TRIPLE")<>0 then
		pilns_nosaukums = replace(nosaukums,"TRIPLE","Trîsvietîgs")
	end if 
end if

save  = true
kopa_v = cint(bernu_vietas) + cint(pieaug_vietas) 
if (kopa_v <> 0  and cint(kopa_v) <> cint(vietas)) then
	session("message") = "Pieauguðo un bçrnu vietu skaits nesakrît ar kopçjo vietu skaitu."
	save= false
end if

if save then
	if pilns_nosaukums="" then pilns_nosaukums = nosaukums

	conn.execute "INSERT INTO viesnicas_veidi (gid,pilns_nosaukums,nosaukums,piezimes,pieaug_vietas,vietas) " + _
		" VALUES (" + cstr(gid) + ",N'" + pilns_nosaukums+"',N'" + nosaukums+"',N'" + piezimes+"'," + cstr(pieaug_vietas) +"," + cstr(vietas) +")"
	id = LastID("viesnicas_veidi")	
	RefreshViesnVeids(id)
	'response.end
end if
response.redirect "viesnicas_veidi.asp?gid="+cstr(gid)







%>


