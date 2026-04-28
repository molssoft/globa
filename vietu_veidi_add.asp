<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

for kk = 1 to 5
	Response.Write kk
	pkv = request.form("pk_veids"+cstr(kk))
	if pkv <> "" then pkv = pkv + " "
	nosaukums = pkv + request.form("nosaukums"+cstr(kk))
	
	if nosaukums <> "" then
	
		cena = getnum(request.form("cena"+cstr(kk)))
		if cena = "" then cena = 0
		cenaLVL = getnum(request.form("cenaLVL"+cstr(kk)))
		if cenaLVL = "" then cenaLVL = 0
		cenaUSD = getnum(request.form("cenaUSD"+cstr(kk)))
		if cenaUSD = "" then cenaUSD = 0
		cenaEUR = getnum(request.form("cenaEUR"+cstr(kk)))
		if cenaEUR = "" then cenaEUR = 0
	
		carter_berns_num = getnum(request.form("carter_berns_"+cstr(kk)))
		if carter_berns_num = 0 then carter_berns_num = "NULL"
	
		if Request.Form("ekskursija_"+cstr(kk)) = "on" then 
			ekskursija = "1" 
			'--- ja atzimeta ekskursija, berna numurs cenai nedarbojas. abi reizee nav paredzeti.
			carter_berns_num = "NULL"
		else 
			ekskursija = "NULL"
		end if
	
		tips = request.Form("tips"+cstr(kk))
		viesnicas_veids = request.Form("viesnicas_veids"+cstr(kk))
		if viesnicas_veids = "" then viesnicas_veids = "NULL"
		persona = "0"
		papildv = "0"

		if tips = "C" or tips = "Z1" or tips = "CH1" Or tips = "C_NA" Or tips = "CH1_NA" then
			persona = "1"
		elseif tips = "P" then
			papildv = "1"	
		end if
		
		

		gid = request.querystring("gid")
		vid = request.querystring("vid")
		limits = request.form("limits"+cstr(kk))
		if limits = "" then limits = "NULL" 
		if limits = "" then limits = "-1"
		limita_grupa = request.form("limita_grupa"+cstr(kk))
		
		max_vecums = request.Form("max_vec_"+cstr(kk))
		if max_vecums = "" then 
			max_vecums = "NULL"
			'--- ja nav ievadits berna vecums, berna numurs cenai nedarbojas.
			carter_berns_num = "NULL"
		end if
	
		min_vecums = request.Form("min_vec_"+cstr(kk))
		if min_vecums = "" then min_vecums = "NULL"

		'nosaka limeni
		set r = conn.execute("select limenis,gid from vietu_veidi where id = " + cstr(vid))
		if r.eof then
		 limenis = 1
		else
		 limenis = r("limenis")+1
		 gid = r("gid")
		end if

		'ja norâdîta limita grupa tad
		'pievienojam ierakstu no kâdas citas grupas, ja eksistç
		set rgrupa = conn.execute("select * from vietu_veidi where limita_grupa = '"+cstr(limita_grupa)+"' and '"+cstr(limita_grupa)+"' <> ''")
		if not rgrupa.eof then
		 conn.execute "INSERT INTO vietu_veidi (gid,nosaukums,cena,cenaLVL,cenaUSD,cenaEUR,persona,papildv,limenis,limits,limita_grupa,virsnieks,tips,viesnicas_veids,max_vecums,min_vecums) " + _
		 " select top 1 "+cstr(gid)+",nosaukums,cena,cenaLVL,cenaUSD,cenaEUR,persona,papildv,limenis,limits,limita_grupa,"+cstr(vid)+",tips,viesnicas_veids,max_vecums,min_vecums from vietu_veidi  " + _
		 " where limita_Grupa = '"+limita_grupa+"' " 
		else
		 'galvenais inserts
		 ' "INSERT INTO vietu_veidi (gid,nosaukums,cena,cenaLVL,cenaUSD,cenaEUR,persona,papildv,virsnieks,limenis,limits,limita_grupa,tips,viesnicas_veids,max_vecums,min_vecums) VALUES (" + cstr(gid) + ",'" + nosaukums+"'," + cstr(cena) + "," + cstr(cenaLVL) + "," + cstr(cenaUSD) + ","+cstr(cenaEUR)+"," + persona + "," + papildv + "," + vid + ","+cstr(limenis)+","+limits+",'"+limita_grupa+"','"+tips+"',"+viesnicas_veids+", "+max_vecums+", "+min_vecums+")"
		 'Response.end
		 ssql = "INSERT INTO vietu_veidi (gid,nosaukums,cena,cenaLVL,cenaUSD,cenaEUR,persona,papildv,virsnieks,limenis,limits,limita_grupa,tips,viesnicas_veids,max_vecums,min_vecums,ekskursija,carter_berns_num) VALUES (" + _
		 cstr(gid) + ",'" + sqltext(nosaukums)+"'," + cstr(cena) + "," + cstr(cenaLVL) + "," + cstr(cenaUSD) + ","+cstr(cenaEUR)+"," + persona + "," + papildv + "," + vid + ","+cstr(limenis)+","+limits+",'"+limita_grupa+"','"+tips+"',"+viesnicas_veids+", "+max_vecums+", "+min_vecums+", "&ekskursija&", "&carter_berns_num&")"
		 'Response.Write ssql
		 conn.execute ssql
		end if


		set rID = conn.execute("select max(id) from vietu_veidi where gid = " + cstr(gid))
		LogInsertAction "vietu_veidi",rID(0)
	end if
	
next

if getnum(vid) <>0 then
 Response.Redirect "vietu_veidi.asp?vid="+cstr(vid)
end if

if session("lastgid") <> "" then
	if session("require_add_pakalpojumi") = 1 then
		
		session("require_add_pakalpojumi") = 0
		response.redirect "grupa_edit.asp?gid="+session("lastgid")

	else
		response.redirect "vietu_veidi.asp?gid="+session("lastgid")
	end if
else
	response.redirect "vietu_veidi.asp?vid="+cstr(vid)
end if
%>


