<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
if id = "all" then
	gid = Request.QueryString("gid")
	set rall = conn.execute("select id from vietu_veidi where gid = "+cstr(gid))
	while not rall.eof
		save(rall("id"))
		rall.movenext
	wend
else
	save(id)
end if


'--- temp
'set r = conn.execute("select * from vietu_veidi where gid is null")
'while not r.eof
' conn.execute "update vietu_veidi set gid = "+cstr(getnum(conn.execute("select gid from vietu_veidi where id = "+cstr(r("virsnieks")) )(0))) + " where id = "+cstr(r("id"))
' r.movenext
'wend
'--- /temp




if session("lastvid") <> "" then
	response.redirect "vietu_veidi.asp?vid="+cstr(session("Lastvid"))
else
	response.redirect "vietu_veidi.asp?gid="+cstr(session("lastgid"))
end if

Function Save(id)

	'Response.Write("save = "&id)

	nosaukums = request.form("nosaukums"+cstr(id))
	viesnicas_veids = request.form("viesnicas_veids"+cstr(id))
	
	if viesnicas_veids = "" then viesnicas_veids = "NULL"
	cena = getnum(request.form("cena"+cstr(id)))
	if cena = "" then cena = 0
	cenaLVL = getnum(request.form("cenaLVL"+cstr(id)))
	if cenaLVL = "" then cenaLVL = 0
	cenaUSD = getnum(request.form("cenaUSD"+cstr(id)))
	if cenaEUR = "" then cenaEUR = 0
	cenaEUR = getnum(request.form("cenaEUR"+cstr(id)))
	if cenaUSD = "" then cenaUSD = 0
	limits = request.form("limits"+cstr(id))
	if limits = "" then limits = "NULL"
	if limits = "0" then limits = "-1"
	limita_grupa = request.form("limita_grupa"+cstr(id))
	if limita_grupa = "" then 
	 limita_grupa = "NULL"
	else
	 limita_grupa = "'" + limita_grupa + "'"
	end if
	carter_berns_num = getnum(request.form("carter_berns_"+cstr(id)))
	if carter_berns_num = 0 then carter_berns_num = "NULL"
	cenaEUR = getnum(request.form("cenaEUR"+cstr(id)))
	if cenaUSD = "" then cenaUSD = 0
	if Request.Form("persona"+cstr(id)) = "on" then persona = "1" else persona = "0"
	if Request.Form("papildv"+cstr(id)) = "on" then papildv = "1" else papildv = "0"
	if Request.Form("no_online"+cstr(id)) = "on" then no_online = "1" else no_online = "0"
	if Request.Form("visa_istaba"+cstr(id)) = "on" then visa_istaba = "1" else visa_istaba = "0"
	if Request.Form("klienta_cena"+cstr(id)) = "on" then klienta_cena = "1" else klienta_cena = "0"
	
	if Request.Form("ekskursija_"+cstr(id)) = "on" then 
		ekskursija = "1" 
		'--- ja atzimeta ekskursija, berna numurs cenai nedarbojas. abi reizee nav paredzeti.
		carter_berns_num = "NULL"
	else 
		ekskursija = "NULL"
	end if
	
	tips = request.Form("tips"+cstr(id))
	if tips = "C" or tips = "Z1" or tips = "CH1" Or tips = "C_NA" Or tips = "CH1_NA" then
	 papildv = "0"
	 persona = "1"
	end if
	if tips = "P" then 
	 papildv = "1"
	 persona = "0"
	end if 
	if tips = "X" then
	 papildv = "0"
	 persona = "0"
	end if
	
	if tips = "G" then
	 papildv = "0"
	 persona = "0"
	end if
		
	max_vecums = request.Form("max_vec_"+cstr(id))
	if max_vecums = "" then 
		max_vecums = "NULL"
		'--- ja nav ievadits berna vecums, berna numurs cenai nedarbojas.
		carter_berns_num = "NULL"
	end if
	
	min_vecums = request.Form("min_vec_"+cstr(id))
	if min_vecums = "" then min_vecums = "NULL"
	'16.01.2019 RT : Jāsaglabā detalizētāk pakalpojumu vēsture
	id_query = "select * from vietu_veidi where id = " + CStr(id)
	Dim old_vals
	set old_vals = CreateDict(id_query) 
	
	conn.execute "UPDATE vietu_veidi SET nosaukums = N'"+cstr(nosaukums)+"', cena = "+cstr(cena)+",cenaLVL = "+cstr(cenaLVL)+",cenaUSD = "+cstr(cenaUSD)+",cenaEUR = '"+cstr(cenaEUR)+"', persona = "+cstr(persona)+", papildv = "+cstr(papildv)+", no_online = "+cstr(no_online)+", visa_istaba = "+cstr(visa_istaba)+", klienta_cena = "+cstr(klienta_cena)+", 	limits = "+limits+", limita_grupa = "+limita_grupa+",tips='"+tips+"',viesnicas_veids = "+viesnicas_veids+", max_vecums="+max_vecums+", min_vecums="+min_vecums+", carter_berns_num="& carter_berns_num &", ekskursija = "&ekskursija&" where id = " + cstr(id)

	
	Dim new_vals
	set new_vals = CreateDict(id_query) 
	UpdateActionDetails old_vals,new_vals,"vietu_veidi",id,""
	'LogUpdateAction "vietu_veidi",cstr(id)
	
	set rc = conn.execute ("select count(id) from pieteikums where deleted = 0 and gid in (select gid from vietu_veidi where id = " +cstr(id)+")")

	'--- parrekina visus pieteikumus, kur ir sis vietas veids
	recalculatePieteikumiOnVietuVeidiChange id,persona,papildv


end function
%>


