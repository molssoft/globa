<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.asp" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%


dim vu
dim oid
'dim did(200)
dim did
dim gid
dim vid
dim dsk
dim skip_save

pid = request.querystring("pid")
gid = Request.QueryString("gid")
if gid = "" then gid = Request.Form("gid")
did = Request.QueryString("did")
vid = Request.Form("vid_0")
ppiezimes_visiem = request.form("ppiezimes_visiem")
dim conn
openconn


'--------------------------------------
'Atlasam tekosa pieteikuma dalibniekus
'--------------------------------------
isnew = false
if pid=0 and Request.Form("gid") <> 0 and Request.Form("gid") <> 279 and (gid = 0 or gid<>Request.Form("gid")) then
 response.redirect ("pieteikums.asp?pid=" + cstr(pid) & "&did=" & cstr(did) & "&gid=" & Request.Form("gid"))
elseif pid=0 and Request.Form("gid") <> 0 and Request.Form("gid") <> 279 and (gid <> 0 and gid=Request.Form("gid")) then
	if (Request.Form("gid") = 292) then
		if (DatePrint(Request.Form("sakuma_datums"))="") then
			session("message") = "Nav ievadîts sâkuma datums."	
			response.redirect ("pieteikums.asp?pid=" + cstr(pid) + "&did="+cstr(did)+"&gid="+cstr(gid))
		end if
		if (DatePrint(Request.Form("beigu_datums"))="") then
			session("message") = "Nav ievadîts beigu datums."	
			response.redirect ("pieteikums.asp?pid=" + cstr(pid) + "&did="+cstr(did)+"&gid="+cstr(gid))
		end if
	end if
 'saglabâ jauno pieteikumu
 set conn2 = server.createobject("ADODB.Connection")
 
	'' solveigai andreai ir liegti braucieni ârpus baltijas
	if did = 1318 then
		rvalsts = conn.execute("select * from globa.dbo.grupa g " + _
			" join marsruts m on g.[mid] = m.id " + _
			" where g.id = "+cstr(gid) )
		valsts = trim(rvalsts("valsts"))
		if valsts <> "LATVIJA" and valsts <> "LIETUVA" and valsts <> "IGAUNIJA" then
			response.write "Ðis pakalpojums nav pieejams"
			response.end
		end if
	end if

 
	conn2.open "DSN=globa"
	conn2.begintrans

	psql = "SET NOCOUNT ON; insert into pieteikums (gid,izveidoja,did) " + _
		" values ("+cstr(gid)+",'"+Get_User+"',"+cstr(did)+"); SELECT @@IDENTITY AS ID"
	Set p_result = conn2.execute(psql)
	pid = p_result("ID")  
	
	conn2.committrans
	conn2.close
	
	'' ðîs piezîmes uzstâda trigeris pie inserta
	ppiezimes_visiem = conn.execute("select isnull(piezimes_visiem,'') as p from pieteikums where id = " + cstr(pid))("p")
	
	WriteLog 1,pid,"A"
	LogInsertAction "pieteikums",pid
	if vid = "" then vid = "null"
	conn.execute "INSERT INTO piet_saite (pid,did,vietsk,vid) VALUES ("+cstr(pid)+","+cstr(did)+",1," & cstr(vid) & ")"
	isnew = true
end if


'Atlasa dalîbniekus
dquery = "SELECT piet_saite.id as id, dalibn.nosaukums as nosaukums, dalibn.vards as vards, dalibn.uzvards as uzvards, piet_saite.pid as pid,dalibn.id as did, "+_
"piet_saite.cenaLVL as cenaLVL, piet_saite.cenaUSD as cenaUSD, piet_saite.cenaEUR as cenaEUR, piet_saite.cena as cena, piet_saite.papildv as papildv, piet_saite.persona as persona, piet_saite.summa as summa, piet_saite.vietsk as vietsk, piet_saite.piezimes as piezimes, piet_saite.kid as kid, "+_
"piet_saite.vid, piet_saite.vietas_veids as vietas_veids, piet_saite.kvietas_veids as kvietas_veids " + _
"FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did "+_
"WHERE piet_saite.deleted = 0 AND (piet_saite.pid="+Cstr(pid)+") order by piet_saite.id;"




set dalibnieki = server.createobject("ADODB.recordset")

'dalibnieki.CursorLocation = 3 '--- adUseClient
dalibnieki.CursorLocation= 3
dalibnieki.open dquery,conn,3,3

dsk = dalibnieki.RecordCount


set old_saites_arr = GetPietSaitesDict(pid)
Dim old_vals
set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
'--------------------------------------
'Saglabajam izmaiòas par dalibniekiem
'--------------------------------------
'@ 0 Saglabâ izmaiòas, ja pieteikuma grupa nav mainîta
set pieteikums = server.createobject("ADODB.recordset")
pieteikums.CursorLocation= 3
pieteikums.open "select * from pieteikums where id ="+cstr(pid),conn,3,3

'Dabon grupas ierakstu
set rCurGrupa = conn.execute("select * from grupa where id = "+cstr(pieteikums("gid")))

skip_save = false

if isGroupBlocked(gid) then skip_save = true

'Ja sis ir grupas vaditaaja pieteikums, tad to drikst rediget tikai kurators
if pieteikums("grupas_vad") = true and isAccess(T_LIETOT_ADMIN)=false then
		'--- parbauda vai lietotajs ir siis konkretaas grupas kurators
		set rKurators = conn.execute("select * from grupa where id = "+cstr(pieteikums("gid"))+" and kurators="+cstr(GetCurUserID))
		
		if rKurators.eof Then
			skip_save = true
		end if

end if


'29.08.2018 RT: pârbauda, vai nemçìina saglabât atteiktu pieteikumu vçlreiz ar veco grupu
atteikums_jau_izveidots = false
if (cstr(pieteikums("gid")) = "458" and cstr(Request.Form("gid"))=cstr(nullprint(pieteikums("old_gid"))) ) then

	atteikums_jau_izveidots = true
	skip_save = true

end if

if not skip_save then

'+++ parbauda, ja ir SINGLE piemaksa, vai dalibnieks ir ielikts SINGLE nummuraa

	irSinglePiemaksa = false
	for id = 1 to dsk ' skataas pieteikuma saitees
		if not irSinglePiemaksa then
			for j = 1 to 5 '--- laikam ir ok, jo tie ir combo sublimenji. Nils 22/04/2013
				vvid = request.form("viet_veid"+cstr(id)+"_"+cstr(j))
				if vvid <> "" then
					ssql = "select tips from vietu_veidi where id = " + vvid
					set rPakSinglePiemaksa = conn.execute(ssql)
					
					if not rPakSinglePiemaksa.eof then
							'--- pievienots nosacijums CH1 - Èarteru Single cena, kura satur single piemaksu.
							'--- izmainîts 22/04/2013
							if rPakSinglePiemaksa(0) = "V1" or rPakSinglePiemaksa(0) = "CH1" or rPakSinglePiemaksa(0) = "CH1_NA" then			
								irSinglePiemaksa = true
								exit for
							end if
					end if
				end if
			next
		else
			exit for	
		end if
	next
	
	'meklee vai dalibnieks ir ielikts  SINGLE viesnicas numuraa
	ssql = "select * from piet_saite where deleted = 0 and pid = "+cstr(pid)+" and vid in (select id from viesnicas where gid = "+cstr(gid)+" and veids in (select id from viesnicas_veidi where gid = "+cstr(gid)+" and vietas = 1))"
	set rPakSingleNum = conn.execute(ssql)	
	
	if irSinglePiemaksa then
	'pakalpojumos eksistee single piemaksa, bet dalibnieks nav ievietots SinGle numuraa

		if rPakSingleNum.eof then
			'alert!
			session("message") = "Ja tiek reìistrçta piemaksa par SINGLE numuru vai cena ar iekïautu SINGLE, atbilstoði, vispirms dalîbnieks jâievieto SINGLE nummurâ."	
			response.redirect ("pieteikums.asp?pid=" + cstr(pid))
		end if
	else
	'dalibnieks ir ievietots SinGle numuraa, bet neeksistee single piemaksa
	
		if not rPakSingleNum.eof then
			'alert!
			session("message") = "Ja dalîbnieks ir ievietots SINGLE nummurâ, papildus jâreìistrç arî piemaksa par SINGLE numuru vai jâizvçlâs cena ar iekïautu SINGLE."	
			''response.redirect ("pieteikums.asp?pid=" + cstr(pid))
		end if

	
	end if
	
'++++++


	'Ja kompleksaa grupa tad visiem pakalpojumiem jaabuut aizpildiitiem
	gid = request.form("gid")
	set rTempGrupa = conn.execute("select * from grupa where id = "+cstr(gid))
	if (trim(nullprint(pieteikums("gid"))) = 0) and rTempGrupa("veids") = 1 then

	  set rViesnicas = server.createobject("ADODB.Recordset")
	  rViesnicas.open "Select viesnicas.id as vid, * " + _ 
		 "from viesnicas INNER JOIN viesnicas_veidi ON viesnicas.veids = viesnicas_veidi.id WHERE viesnicas.gid = " + cstr(gid) + " order by veids,viesnicas.id",conn,3,3
		 set rKajites = server.CreateObject("ADODB.Recordset")
		 rKajites.Open "select kajite.id as kid, * " + _
		 "from kajite INNER JOIN kajites_veidi ON kajite.veids = kajites_veidi.id WHERE kajite.gid = " + cstr(gid) + " order by veids,kajite.id",conn,3,3
		 if (not rViesnicas.EOF and trim(nullprint(dalibnieki("vid"))) = "") or (not rKajites.EOF and trim(nullprint(dalibnieki("kid"))) = "") then
		   response.redirect ("pieteikums.asp?pid="+cstr(pid)&"&gid="&cstr(gid))
		Response.Write gid
		Response.End
	  end if
	end if

att_gid = cstr(conn.execute ("select atteikusies from parametri")(0))
if Request.Form("atcelts") = "on" and cstr(gid) <> att_gid then 
 old_gid = gid
 gid = att_gid
 conn.execute "DELETE FROM piet_atlaides where pid = "+cstr(pid)
end if





dim papildus_piet_saite
papildus_piet_saite = ""
if GetComplexGroup = pieteikums("gid") then kompleks = 1
if trim(nullprint(pieteikums("gid"))) = trim(nullprint(gid)) then
	'pârbauda, vai persona jau nav ielikta kâdâ kajîtç
	dim esosa_kajite
	dim esosais_kid
		dim vv
	esosa_kajite = 0
	esosais_kid = 0
	qry = "SELECT * FROM piet_saite where deleted=0 /*and persona=1*/ AND pid="+cstr(pid)+" AND kid<>0 AND isnull(kvietas_veids,0) IN (1,2,4,5)"
	
	'response.write(qry + "<br>")
	set persona_kajite = conn.execute(qry)

	if (not persona_kajite.eof) then
		esosais_kid = persona_kajite("kid")
		esosa_kajite = persona_kajite("id")
	end if
	'response.write("esoðâ kajîte:")
	'response.write(esosa_kajite)
				
	'----- Ja pieteikuma grupa nav mainîta
	for id = 1 to dsk
	
		dalibnieki("vietsk") = getnum(request.form("vietsk"+cstr(id)))	
		if dalibnieki("vietsk") = 0 then dalibnieki("vietsk") = 1
		dalibnieki("cena") = getnum(request.form("cena"+cstr(id)))
		dalibnieki("cenaUSD") = getnum(request.form("cenaUSD"+cstr(id)))
		dalibnieki("cenaLVL") = getnum(request.form("cenaLVL"+cstr(id)))
		dalibnieki("cenaEUR") = getnum(request.form("cenaEUR"+cstr(id)))
		'ja aizpildîts tikai vecais cenas lauks, tad jâskatâs kâda ir grupas valûta
		If dalibnieki("cena")<>0 Then
			If dalibnieki("cenaUSD") = 0 And dalibnieki("cenaLVL") =0 And dalibnieki("cenaEUR") = 0 Then
				If nullprint(rCurGrupa("valuta"))<>"" Then
					dalibnieki("cena"+rCurGrupa("valuta")) = getnum(request.form("cena"+cstr(id)))
				Else
					dalibnieki("cenaLVL") = getnum(request.form("cena"+cstr(id)))
				End if
			End if
		End if

		dalibnieki("piezimes") = request.form("piezimes"+cstr(id))
		dalibnieki("kid") = getnum(request.form("kid"+cstr(id)))
		for j = 1 to 5
			if request.form("viet_veid"+cstr(id)+"_"+cstr(j)) <> "" then
				dalibnieki("vietas_veids") = request.form("viet_veid"+cstr(id)+"_"+cstr(j))
			end if
		next

		if getnum(dalibnieki("kid"))<>0 then
			'pârbauda, vai persona jau nav ielikta kâdâ kajîtç
			qry = "SELECT * FROM piet_saite where deleted=0 /*and persona=1*/ AND pid="+cstr(pid)+" AND kid<>0 AND id<>"+cstr(esosa_kajite)+" AND isnull(kvietas_veids,0) IN (1,2,4,5)"
			set persona_kajite = conn.execute(qry)
			if (not persona_kajite.eof) then
				session("message") = "Persona jau ir ievietota vienâ kajîtç"	
				response.redirect ("pieteikums.asp?pid=" + cstr(pid))
			end if
		
			
			'pârbaude, cik ðajâ kajîtç jau ir dalîbnieki - ja vien tâ jau nav esoðâ kajîte vai papildus brîva vieta
			if (dalibnieki("kid") <> esosais_kid or  (getnum(Request.Form("kvietas_veids"+cstr(id))) = 3 or getnum(Request.Form("kvietas_veids"+cstr(id))) =6 or getnum(Request.Form("kvietas_veids"+cstr(id))) =7)) then	
				dim aiznemtas_vietas
				dim aiznemtas_vietas_p
				aiznemtas_vietas =  0
				aiznemtas_vietas_p = 0
				if (getnum(Request.Form("kvietas_veids"+cstr(id))) = 3) then
					'aiznemtas_vietas = 0.334
				end if
				if (getnum(Request.Form("kvietas_veids"+cstr(id))) = 6) then
					'aiznemtas_vietas = 0.5
				end if

				
				
				
				qry = "SELECT count(id) as skaits FROM piet_saite where kid="+cstr(dalibnieki("kid"))+" and deleted=0 /*and persona=1*/ AND isnull(kvietas_veids,0) IN (1,2,4,5)"
				qry1 = "SELECT * FROM piet_saite where kid="+cstr(dalibnieki("kid"))+" and deleted=0 /*and persona=1*/ AND isnull(kvietas_veids,0) IN (1,2,4,5)"
				'response.write(qry+"<br>")	
				set kajite_personas = conn.execute(qry)
				if (not kajite_personas.eof) then 
					'response.write("Jau ðajâ kajîtç ir:")
					'response.write(kajite_personas("skaits"))
					'response.write("<< dalîbnieki <br>")
					aiznemtas_vietas = aiznemtas_vietas + cint(kajite_personas("skaits"))
					'rw "saizòemtas vietas:"
					'rw aiznemtas_vietas
					'rw "<br>"
					
					aiznemtas_vietas_p = cint(kajite_personas("skaits"))
					if (getnum(Request.Form("kvietas_veids"+cstr(id))) = 6) then
						aiznemtas_vietas = aiznemtas_vietas + cint(kajite_personas("skaits"))/2
					end if
					if (getnum(Request.Form("kvietas_veids"+cstr(id))) = 3) then
						aiznemtas_vietas = aiznemtas_vietas + cint(kajite_personas("skaits"))/3
					end if
					if (getnum(Request.Form("kvietas_veids"+cstr(id))) = 7) then
							
						aiznemtas_vietas = aiznemtas_vietas + 3
					end if
				end if

				'rw "SELECT vietas from kajite where id="+cstr(dalibnieki("kid"))+""
				set kajite_kopa_vietas = conn.execute("SELECT vietas from kajite where id="+cstr(dalibnieki("kid"))+"")				
				dim vietas_kajite
				vietas_kajite = cint((kajite_kopa_vietas(0)))
				
				if (aiznemtas_vietas> vietas_kajite) then 
					session("message") = "Kajîtç vairs nevar pievienot dalîbniekus - maksimums sasniegts ("+cstr(aiznemtas_vietas)+" no "+cstr(vietas_kajite)+")"	
					 response.redirect ("pieteikums.asp?pid=" + cstr(pid))
				else
				end if
				
				aiznemtas_vietas = aiznemtas_vietas_p
				qry = "SELECT count(id) as skaits,kvietas_veids FROM piet_saite where kid="+cstr(dalibnieki("kid"))+" and deleted=0 and kvietas_veids in (3,6,7) group by kvietas_veids"
				'response.write(qry+"<br>")
				
				set kajite_brivas_vietas = conn.execute(qry)
				
				dim aiznemtas_brivas_2
				dim aiznemtas_brivas_3
				dim aiznemtas_brivas_1
				aiznemtas_brivas_2 = 0
				aiznemtas_brivas_3 = 0
				aiznemtas_brivas_1 = 0
				if (not kajite_brivas_vietas.eof) then 
					while not kajite_brivas_vietas.eof
						if (kajite_brivas_vietas("kvietas_veids") = 3) then
							aiznemtas_vietas = aiznemtas_vietas + 1 ' cint(kajite_brivas_vietas("skaits"))/3
							aiznemtas_brivas_3 = kajite_brivas_vietas("skaits")
						end if
						if (kajite_brivas_vietas("kvietas_veids") = 6) then
						rw "6"
							aiznemtas_vietas = aiznemtas_vietas + 2 'cint(kajite_brivas_vietas("skaits"))/2
							aiznemtas_brivas_2 = kajite_brivas_vietas("skaits")
						end if
						if (kajite_brivas_vietas("kvietas_veids") = 7) then
							aiznemtas_vietas = aiznemtas_vietas + 3 'cint(kajite_brivas_vietas("skaits"))-1
							aiznemtas_brivas_1 = kajite_brivas_vietas("skaits")
						end if
						kajite_brivas_vietas.moveNext
					wend
				end if
			
				if (aiznemtas_vietas > vietas_kajite) then 
					session("message") = "Kajîtç vairs nevar pievienot dalîbniekus - maksimums sasniegts"	
					response.redirect ("pieteikums.asp?pid=" + cstr(pid))
				else
					if aiznemtas_vietas = vietas_kajite then
						'pârbauda, vai dalîbnieks ir pats jkau ielikts ðajâ kajîtç, ja ir, tad ïauj noseivot, ja nç, tad neïauj
						qry = "SELECT * FROM piet_saite where kid="+cstr(dalibnieki("kid"))+" and deleted=0 /*and persona=1*/ AND isnull(kvietas_veids,0) IN (1,2,4,5) AND did="+cstr(dalibnieki("did"))
						set r_dalibn_jau_kajite = conn.execute(qry)
						if r_dalibn_jau_kajite.eof then
							session("message") = "Kajîtç vairs nevar pievienot dalîbniekus - maksimums sasniegts"	
							response.redirect ("pieteikums.asp?pid=" + cstr(pid))
									
						end if
					end if
				end if
			end if
			
			if getnum(Request.Form("kvietas_veids"+cstr(id))) = 0 then
				dalibnieki("kvietas_veids") = 0
			else
				dalibnieki("kvietas_veids") = getnum(Request.Form("kvietas_veids"+cstr(id)))
				
			dim kajites_veids
			kajites_veids = cint(dalibnieki("kvietas_veids"))
			if (kajites_veids = 3 or kajites_veids = 6 or kajites_veids = 7) then
				dim papild_q
				if (kajites_veids = 3) then
					papid_q = " papild_cena <> 0"
				end if
				if (kajites_veids = 6) then
					papid_q = " papild2_cena <> 0"
				end if
				if (kajites_veids = 7) then
					papid_q = " papild3_cena <> 0"
				end if
				'pârbauda, vai kajiet.veids atbilst ierakst kajites_veidi, kur papild_cena <>0
			
				set kajites_papild = conn.execute("SELECT * FROM kajites_veidi WHERE id IN (SELECT veids FROM kajite WHERE id="+cstr(dalibnieki("kid"))+") AND "+papid_q)
				if kajites_papild.eof then
				'if (vietas_kajite <> 4) then
					session("message") = "Ðai kajîtei nevar izvçlçties brîvas vietas"	
					response.redirect ("pieteikums.asp?pid=" + cstr(pid))
				else 
					'pârbauda, vai ir saglabâta bâzes cena kajîtei ðim dalîbniekam, 
					qry = "SELECT * FROM piet_saite where deleted=0 /*and persona=1*/ AND kid="+cstr(dalibnieki("kid"))+" AND isnull(kvietas_veids,0) IN (1,2,4,5) AND did="+cstr(dalibnieki("did"))+""
					
					set cena_bazes = conn.execute(qry)
					'ja nav , tad uzreiz arî to izveido un saglabâ
					if cena_bazes.eof then
						'atrod dalîbnieka vecumu
						dim d_yy
						dim d_age
						d_age = 21
						response.write("SELECT beigu_dat FROm grupa where id="+cstr(gid)+"<br>")
						set grupa_dat = conn.execute("SELECT beigu_dat FROm grupa where id="+cstr(gid)+"")
						if not grupa_dat.eof then
							d_age = vecums_new(dalibnieki("did"),grupa_dat(0))
							
							if d_age = "" then d_age = 21
						else
							d_age = GetAge(dalibnieki("did"))
									
						end if
						
						
						
						dim kajites_grupa
						kajites_grupa = 1
						'dabû vecuma intervâlus no db
						qry = "SELECT * FROM kajites_vecums"
						set kajites_vecums = conn.execute(qry)
						if ( not kajites_vecums.eof) then
							'bçrns
							if (d_age <= kajites_vecums("bernu_lidz")) then
								kajites_grupa = 2
							end if
							'pusaudzis
							if (d_age >=kajites_vecums("pusaudzu_no") and d_age<=kajites_vecums("pusaudzu_lidz")) then
								kajites_grupa = 5
							end if
							'standarta
							if (d_age>kajites_vecums("pusaudzu_lidz")) then 
								kajites_grupa = 1
							end if
						end if
						
						
					
						qry = "SELECT id FROM vietu_veidi WHERE gid="+cstr(gid)+" AND nosaukums like '%nav%' AND tips='X'"
						set vietas_veids = conn.execute(qry)
						if not vietas_veids.eof then
							vv = vietas_veids(0)
						else 
							vv=0
						end if
						qry = "INSERT INTO piet_saite (pid,did,vietsk,kvietas_veids,kid,persona,vietas_veids) VALUES "+_
						"("+cstr(dalibnieki("pid"))+","+cstr(dalibnieki("did"))+",1,"+cstr(kajites_grupa)+","+cstr(dalibnieki("kid"))+",0,"+cstr(vv)+")"
						conn.execute(qry)
							
					end if
					
					'saglabâ arî visiem pârçjiem ðajâ kajîtç ðo pakalpojumu uzreiz
					
					
					dim did_kaimina
					qry = "SELECT * FROM piet_saite where deleted=0 /*and persona=1*/ AND kid="+cstr(dalibnieki("kid"))+" AND isnull(kvietas_veids,0) IN (1,2,4,5) AND did<>"+cstr(dalibnieki("did"))+""
					'response.write(qry)
					'response.write("<br><br>")
					
					
					
					'response.end
					set personas_kajite = conn.execute(qry)
					qry = "SELECT count(id) as skaits FROM piet_saite where deleted=0 /*and persona=1*/ AND  kid="+cstr(dalibnieki("kid"))+" AND isnull(kvietas_veids,0) IN (1,2,4,5) AND did<>"+cstr(dalibnieki("did"))+""
					'response.write(qry)
					'response.write("<br><br>")
					set dalibn_skaits = conn.execute(qry)
					if not dalibn_skaits.eof then
						'response.write("atrasti:"+cstr(dalibn_skaits(0))+" dalîbnieki")
					end if
					
					if not personas_kajite.eof then
						
						'response.write("ir kkas")
					
						set vietas_veids = conn.execute("SELECT id FROM vietu_veidi WHERE gid="+cstr(gid)+" AND nosaukums like '%nav%' AND tips='X'")
						if not vietas_veids.eof then
							vv = vietas_veids(0)
						else 
							vv=0
						end if
						while not personas_kajite.eof
							did_kaimina = personas_kajite("did")
							pid_kaimina = personas_kajite("pid")
							'pârbauda, vai jau nav ðis pakalpojums
							qry = "SELECT count(id) as skaits FROM piet_saite WHERE deleted=0 AND persona=0 AND kid="+cstr(dalibnieki("kid"))+" AND kvietas_veids="+cstr(kajites_veids)+" AND did="+cstr(did_kaimina)+" AND pid="+cstr(pid_kaimina)+""
							'response.write(qry)
							
							set did_briva_vieta = conn.execute(qry)
							'ja nav, saglabâ to
							dim piet_skaits
							piet_skaits=0
							
							dim brivas_vietas_tips
							if (kajites_veids = 3) then

								brivas_vietas_tips = 1
							end if
							if (kajites_veids = 6) then
								brivas_vietas_tips = 2
							end if
							if (kajites_veids = 7) then
								brivas_vietas_tips = 3
							end if
							if not did_briva_vieta.eof then
								piet_skaits = did_briva_vieta("skaits")
								aiznemtas_vietas = aiznemtas_vietas + (piet_skaits-brivas_vietas_tips)
							end if
							
							dim k
							k=1
							'if (did_kaimina = did) then
							'	k = k -1
							'end if
							dim j
							'response.write("K:"+cstr(k)+"<br>")
							'response.write("piet_skaits:"+cstr(piet_skaits)+"<br>")
							
							
							if (piet_skaits < k) then
								j = k-piet_skaits
								for i=1 to j
									conn.execute("INSERT INTO piet_saite (pid,did,vietsk,kvietas_veids,kid,persona,vietas_veids) VALUES ("+cstr(pid_kaimina)+","+cstr(did_kaimina)+",1,"+cstr(kajites_veids)+","+cstr(dalibnieki("kid"))+",0,"+cstr(vv)+")")
								next
							end if
							
							personas_kajite.moveNext
						wend
					else
					end if
				end if
			end if
			
				
				
			end if
		else
		 dalibnieki("kvietas_veids") = 0
		end if
		
		if request.form("papildv"+cstr(id)) = "on" then
			dalibnieki("papildv") = 1
			dalibnieki("persona") = 0
		else
			dalibnieki("papildv") = 0
			dalibnieki("persona") = 1
			
		end if	

		if request.form("viet_veid"+cstr(id)+"_1") <> ""then
			set rViet_veid = conn.Execute ("SELECT * FROM vietu_veidi where id = " + request.form("viet_veid"+cstr(id)+"_1")) 
		else
			set rViet_veid = conn.Execute ("SELECT * FROM vietu_veidi where id = 0")
		end if
		
		if not rViet_veid.eof then
			'Uzstâda papildvietu, ja izvçlçts papildvietas pakalpojums (vietas_veids)
			dalibnieki("papildv") = rViet_veid("papildv") 
			dalibnieki("persona") = rViet_veid("persona")
			
			'pârbauda vai pakalpojums sakrît ar viesnicas veidu
			if getnum(rViet_veid("viesnicas_veids"))<>0 and getnum(dalibnieki("vid"))<>0 then
				set rTest=conn.execute("select * from viesnicas where id = "+cstr(dalibnieki("vid"))+" and veids = "+ cstr(rViet_veid("viesnicas_veids")))
				if rTest.eof then
		 		  session("message") = session("message")+ "Pakalpojums neatbilst viesnicas veidam<BR>"
		 		  dalibnieki("vid")=NULL
				end if
			end if
		end if

		if pieteikums("grupas_vad") = true then
			dalibnieki("persona") = 0
		end if		
		dalibnieki.update
		dalibnieki("summa") = dalibnieki("vietsk") * dalibnieki("cena")
		dalibnieki.update
		
		
	
		dalibnieki.movenext
	next
	'response.end
else
	'@ 0 Saglabâ izmaiòas, ja pieteikuma grupa ir mainîta 
	for id = 1 to dsk
		dalibnieki("vietsk") = getnum(request.form("vietsk"+cstr(id)))
		dalibnieki("cena") = getnum(request.form("cena"+cstr(id)))
		dalibnieki("cenaUSD") = getnum(request.form("cenaUSD"+cstr(id)))
		dalibnieki("cenaLVL") = getnum(request.form("cenaLVL"+cstr(id)))
		dalibnieki("cenaEUR") = getnum(request.form("cenaEUR"+cstr(id)))


		dalibnieki("piezimes") = request.form("piezimes"+cstr(id))
		dalibnieki("kid") = 0
		dalibnieki("vietas_veids") = 0
		dalibnieki("kvietas_veids") = 0
		if request.form("papildv"+cstr(id)) = "on" then
			dalibnieki("papildv") = 1
			dalibnieki("persona") = 0
		else
			dalibnieki("papildv") = 0
			dalibnieki("persona") = 1
		end if		
		
		if pieteikums("grupas_vad") = true then
			dalibnieki("persona") = 0
		end if
		
		dalibnieki.update
		dalibnieki("summa") = dalibnieki("vietsk") * dalibnieki("cena")
		dalibnieki.update
		dalibnieki.movenext
	next
	
end if	



'--------------------------------------
'Saglabajam izmaiòas par pieteikuma atlaidçm
'--------------------------------------
function remove_nonumeric(fromwhat)
	if len(fromwhat)=0 then remove_nonumeric=""
	tmpreturnstring=""
	for i=1 to len(fromwhat)
		tmp=mid(fromwhat,i,1)
		if ((isnumeric(tmp)=true) or (tmp=",") or (tmp=".")) then
			if tmp="," then tmp="."
			tmpreturnstring=tmpreturnstring+tmp
		end if
	next
	remove_nonumeric=tmpreturnstring
end function

atl_veids=nullprint(Request.Form("atl_veids"))
sum=remove_nonumeric(Request.Form("txtkopsum"))
valuta = Request.form("atl_valuta")
atlsum=remove_nonumeric(Request.Form("txtatlaidesum"))
proc=remove_nonumeric(Request.Form("txtatlaideproc"))
strpiezimes=Request.Form("txtpiezimes")
valuta = Request.Form("atl_valuta")


       if sum<>"" then
			v1="1"
		else
			v1="0"
		end if

		if atlsum<>"" then
			v2="1"
		else
			v2="0"
		end if
			
		if proc<>"" then
			v3="1"
		else
			v3="0"
		end if
		
			Ko_darit=v1+v2+v3
			select case ko_darit
			    case "000" 'neieraksta bez kïûdas paziòojuma
				case "001" or "100"'ja ir tikai procents vai kopsumma, nesaglabât
				    session("message")="Jauna atlaide nav pievienota, jo uzrâdîts tikai atlaides procents. Vajadzîga arî atlaides summa."
				case "010"'ja ir tikai atlaides apmçrs, saglabât
				    piet_atlaide_add pid, valuta, 0, 0, atlsum, strpiezimes, atl_veids
				case "011"' ir atlaide procentos un atlaides summa-izrçíina kopçjo un saglabâ
					sum=atlsum*100/proc
					piet_atlaide_add pid, valuta, sum,proc,atlsum,strpiezimes,atl_veids
				case "101"' ir kopsumma un procents, izrçíina atlaidi un saglabâ
					atlsum=proc*sum/100
					 piet_atlaide_add pid,valuta, sum,proc,atlsum,strpiezimes,atl_veids
				case "110"'ir kopsummma un atlaide, izrçíina procentu un ieraksta
					proc=atlsum*100/sum
					 piet_atlaide_add pid,valuta, sum,proc,atlsum,strpiezimes,atl_veids
				case "111"'ja ir visi trîs, tad pârrçíina procentu un visus ieraksta
				    proc=atlsum*100/sum
				    piet_atlaide_add  pid,valuta, sum,proc,atlsum,strpiezimes,atl_veids
				case else
			end select

'--------------------------------------
'Saglabajam izmaiòas par pieteikumu
'--------------------------------------
piet_upd_sql = " gid = " + cstr(gid)

''pieteikums("gid") = gid
if getnum(old_gid) <> 0 then
	'pieteikums("old_gid") = getnum(old_gid)
	piet_upd_sql = piet_upd_sql + ", old_gid = "+cstr(getnum(old_gid))
end if

'26.04.2019 RT: saglabâ ir vai nav grupas vadîtâjs
if request.form("grupas_vad") = "on" then 
	grupas_vad = 1
else
	grupas_vad = 0
end if
piet_upd_sql = piet_upd_sql + ", grupas_vad = "+cstr(grupas_vad)

'--- izòçmums, lai kurators, kuram ir atïauts saglabât grupas vaditaja pieteikumu
'--- nenojauktu vienigo atskiribas paziimi, tapec piezimes nesaglabaa
'- no 26.04.2019 pka pazime grupas vaditajam kalpo lauks grupaas_vad, tpc jebkura gad var saglabat

piet_upd_sql = piet_upd_sql + ", piezimes = '"+request.form("ppiezimes")+"'"
piet_upd_sql = piet_upd_sql + ", piezimes_visiem = '"+ppiezimes_visiem+"'"
piet_upd_sql = piet_upd_sql + ", vieta_rezerveta_lidz = "+SQLDateQ(request.form("vieta_rezerveta_lidz"))





'atrod lîgumu
ligums_id=0
'rw "SELECT ligums_id from pieteikums where id = "+cstr(pid)

set rligums = conn.execute("SELECT isnull(ligums_id,0) as ligums_id from pieteikums where id = "+cstr(pid))

if not rligums.eof then	
	ligums_id = rligums("ligums_id")
end if
'rw "<br>"
'rw ligums_id
'rw "<br>"
if ligums_id = 0 then
			set rlig = conn.execute("select * from ligumi where deleted = 0 and rez_id in (select online_rez from pieteikums where id = "+cstr(pid)+") order by id desc")
			if not rlig.eof then
				ligums_id = rlig("id")
			end if
		end if
if ligums_id = 0 then 
		
			'--- parbauda vai nav online_rez un taas liigums
			ssql = "select r.ligums_id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
					"where p.id = "&pid&" and r.deleted = 0 and p.deleted = 0 and isnull(r.ligums_id,0) <> 0" 
				'rw ssql	
			set o_rez = conn.execute(ssql)
			if not o_rez.eof then
				ligums_id = o_rez("ligums_id")
			end if
		
end if
rw "<br>"
rw ligums_id

	if ligums_id <> 0 then
	rw request.form("ligums_nosutits")
		parakstits=0
		if request.form("ligums_nosutits") = "on" then
			if request.form("ligums_parakstits") = "on" then
				parakstits=1
			end if
			nosutits=1
		else nosutits=0		
		end if
		
		'rw "Update ligums set nosutits="+cstr(nosutits)+",nosutits_date = getdate(),parakstits="+cstr(parakstits)+",parakstits_date=getdate() WHERE id="+cstr(ligums_id)+""
		conn.execute("Update ligumi set nosutits="+cstr(nosutits)+",nosutits_date = getdate(),parakstits="+cstr(parakstits)+",parakstits_date=getdate()  WHERE id="+cstr(ligums_id)+"")
		'response.end	
	end if
	if Request.Form("agents") <> "" and pieteikums("agents")<>"" Then
		if cint(pieteikums("agents"))<>cint(Request.Form("agents")) Then 
			tic_changed = true 
		else 
			tic_changed=false
		end if
	Else
		tic_changed = false
	end if

	''pieteikums("agents") = Request.Form("agents")
	piet_upd_sql = piet_upd_sql + ", agents = "+request.form("agents")
	''pieteikums("carter_firma") = Request.Form("carter_firma")
	piet_upd_sql = piet_upd_sql + ", carter_firma = '"+request.form("carter_firma")+"'"

	if clng(pid)<>0 then

	 '--- balles info ------------------------------------------ 
	 
	 
	 
	 if Request.Form("balle_vietas") <> "" and Request.Form("balle_vietas") <> "0" then
		
		'---- pieskaia grupas max skaitlim +1
		dim rGrupaBalle: set rGrupaBalle = conn.execute("select IsNull(balle_numurs,0) as balle_numurs, valsts, veids from grupa inner join marsruts on mid = marsruts.id where grupa.id = " & gid)
	  
		if rGrupaBalle("balle_numurs") = 0 and rGrupaBalle("veids")<>7 then ' veids 7 = grupas tips CITA, izsleedz balles grupu
		
				if gid = 292 or gid = 3100 then
					set rMaxNum = conn.execute("select (60 + count(id)) as maxnum from grupa where id in (292, 3100) and not balle_numurs is null")
				else  
					set rMaxNum = conn.execute("select IsNull(max(balle_numurs),0) as maxnum from grupa inner join marsruts on mid = marsruts.id where year(sakuma_dat) = 2004 and valsts in (" & CountriesByRegion(RegionForCountry(RTrim(rGrupaBalle("valsts")))) & ")")
				end if
				conn.execute("update grupa set balle_numurs = " & rMaxNum("maxnum") + 1 & "where id = " & gid)
		end if
	  
	 end if
	 
	 '--- balles galda numurs kompleksajiem un charteriem
	 if gid = 292 or gid = 3100 then
	 
		if gid = 292 then bnum = 30 else bnum = 31
		''pieteikums("balle_knum") = bnum
		piet_upd_sql = piet_upd_sql + ", balle_knum = "+cstr(bnum)

	 end if
	 
	 '---vietas
	 if Request.Form("balle_vietas") = "" then 
		''pieteikums("balle_vietas") = 0 
		piet_upd_sql = piet_upd_sql + ", balle_vietas = 0"
	 else
		''pieteikums("balle_vietas") = Request.Form("balle_vietas")
		piet_upd_sql = piet_upd_sql + ", balle_vietas = " + Request.Form("balle_vietas")
	 end if
	 
	 '--- datums
	 if Request.Form("balle_datums") = "" then 
		''pieteikums("balle_datums") = null
		piet_upd_sql = piet_upd_sql + ", balle_datums = null"
	  else
		''pieteikums("balle_datums") = 
		piet_upd_sql = piet_upd_sql + ", balle_datums = '" + sqldate(normaldate(request.form("balle_datums"))) + "'"
	 end if
	 
	 '--- piezimes
	 if Request.Form("balle_piezimes") = "" then 
		piet_upd_sql = piet_upd_sql + ", balle_piezimes = null"
	 else
		piet_upd_sql = piet_upd_sql + ", balle_piezimes = '" + sqltext(request.form("balle_piezimes")) + "'"
	 end if
	 
	end if
	'-------------------------------------------------------------

	if request.form("students") = "on" then	
		''pieteikums("students") = 1 
		piet_upd_sql = piet_upd_sql + ", students = 1"
	else 
		''pieteikums("students") = 0
		piet_upd_sql = piet_upd_sql + ", students = 0"
	end if

	if isaccess(T_GRAMATVEDIS) then
		if request.form("krasa") = "on" then	
			''pieteikums("krasa") = "B" 
			piet_upd_sql = piet_upd_sql + ", krasa = 'B'"
		else 
			''pieteikums("krasa") = NULL
			piet_upd_sql = piet_upd_sql + ", krasa = NULL "
		end if
	end if

	'-- ja vajag atcelt pieteikumu
	if request.form("atcelts") = "on" then	
		''pieteikums("atcelts") = 1 
		piet_upd_sql = piet_upd_sql + ", atcelts = 1"
	else 
		''pieteikums("atcelts") = 0
		''pieteikums("deleted") = 0
		piet_upd_sql = piet_upd_sql + ", atcelts = 0, deleted = 0 "
	end if	


	if request.form("sakuma_datums") <> "" then
		''pieteikums("sakuma_datums") = normaldate2(request.form("sakuma_datums")) 'cdate(normaldate(request.form("sakuma_datums")))
		piet_upd_sql = piet_upd_sql + ", sakuma_datums = '"+sqldate(request.form("sakuma_datums"))+"' "
	else
		''pieteikums("sakuma_datums") = null
		piet_upd_sql = piet_upd_sql + ", sakuma_datums = NULL "
	end if

	if request.form("beigu_datums") <> "" then
		''pieteikums("beigu_datums") = normaldate2(request.form("beigu_datums")) 'cdate(normaldate(request.form("beigu_datums")))
		piet_upd_sql = piet_upd_sql + ", beigu_datums = '"+sqldate(request.form("beigu_datums"))+"' "
	else
		''pieteikums("beigu_datums") = null
		piet_upd_sql = piet_upd_sql + ", beigu_datums = NULL "
	end if

	if request.form("DKnorakstita") = "on" then	
		''pieteikums("dk_norakstita") = 1 
		piet_upd_sql = piet_upd_sql + ", dk_norakstita = 1 "
	else 
		''pieteikums("dk_norakstita") = 0
		piet_upd_sql = piet_upd_sql + ", dk_norakstita = 0 "
	end if

	piet_upd_sql = piet_upd_sql + ", did = (select top 1 did from piet_saite ps where pid = "+cstr(pid)+" and deleted = 0) "

	conn.execute ("update pieteikums set "+piet_upd_sql+" where id = "+ cstr(pid))

	did = conn.execute("select top 1 did from piet_saite ps where pid = "+cstr(pid)+" and deleted = 0")(0)

	''varbût nevajag citus pieteikumus mainît
	''conn.execute ("update pieteikums set piezimes_visiem = '"+request.form("ppiezimes_visiem")+"' where did = " + cstr(did) + " and deleted = 0 ")

	pieteikums_recalculate pid

	if not isnew then

	 if tic_changed then
		optionalinfo = "Izmainîts TIC"
	 else
		optionalinfo = ""
	 end if
	 
	 
	 'saglabâ informâciju par piet_saiðu un pieteikuma izmaiòu saturu un autoru
		dim new_saites_arr
		set new_saites_arr = GetPietSaitesDict(pid)
		Dim new_vals
		set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
		
		SavePietHistory old_saites_arr,new_saites_arr,pid,old_vals,new_vals
		
		
		'UpdateActionDetails old_vals,new_vals,"pieteikums",pid,""

		
	'LogEditActionOptionalInfo "pieteikums",pid,optionalinfo

	else
	 session("message") = "Pievienots jauns pieteikums"
	end if

	if request.form("saglabat.x") <> "" then
		response.redirect ("pieteikums.asp?pid="+cstr(pid))
	end if

'--- ja grupa nav blokeeta, driikst veikt izmainjas
'if isGroupBlocked(gid) then

'end if '--- ja grupa nav blokeeta beigas. Taalaak ïauj izdariit iemaksas/izmaksas

else '--- skip_save grupas vaditaja pieteikumu, ja tas nav grupas kurators. atljauj tikai iemaksas/izmaksas VAI ja atteikums jau izveidots bet vel meìina ar veco gid noseivot
	if (atteikums_jau_izveidots) then
	
		session("message") = "Pieteikums jau ir saglabâts kâ atteikts, nevar saglabât ar iepriekðçjo grupas ID#"	
		response.redirect ("pieteikums_new.asp?pid=" + cstr(pid))
	end if
	
	if request.form("iemaksa.x") = "" and request.form("izmaksa.x") = "" then
		session("message") = "Nevar labot pieteikumu (grupa bloíçta, vadîtâja pieteikums vai reìistrçts atteikums."	
		response.redirect ("pieteikums.asp?pid=" + cstr(pid))
	end if
	
end if

if request.form("iemaksa.x") <> "" then
	session("izm") = 0
	response.redirect("orderis.asp?pid="+cstr(pid)+"&valuta="+nullprint(rCurGrupa("valuta")))
end if
if request.form("izmaksa.x") <> "" then
	session("izm") = 1
	response.redirect("orderis_izm.asp?pid="+cstr(pid)+"&valuta="+nullprint(rCurGrupa("valuta")))
end if


'@ 0 Pievienot citu dalîbnieku
if request.form("pievienot.x") <> "" then
	session("pievienot") = "1"
	response.redirect("dalibn.asp")
end if

response.redirect ("pieteikums.asp?pid="+cstr(pid))
%>
