<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
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
dim conn
openconn

'--------------------------------------
'Atlasam tekosa pieteikuma dalibniekus
'--------------------------------------
isnew = false
if pid=0 and Request.Form("gid") <> 0 and Request.Form("gid") <> 279 and (gid = 0 or gid<>Request.Form("gid")) then
 response.redirect ("pieteikums.asp?pid=" + cstr(pid) & "&did=" & cstr(did) & "&gid=" & Request.Form("gid"))
elseif pid=0 and Request.Form("gid") <> 0 and Request.Form("gid") <> 279 and (gid <> 0 and gid=Request.Form("gid")) then
 'saglabâ jauno pieteikumu
 set conn2 = server.createobject("ADODB.Connection")
	conn2.open conn.connectionstring
	conn2.begintrans
	
	Set p_result = conn2.execute("SET NOCOUNT ON; insert into pieteikums (gid,izveidoja) values ("+cstr(gid)+",'"+Get_User+"'); SELECT @@IDENTITY AS ID")
	'set rPiet2 = conn2.execute ("select max(id) from pieteikums")
	pid = p_result("ID")  'rPiet2(0) 
	
	conn2.committrans
	conn2.close
	WriteLog 1,pid,"A"
	LogInsertAction "pieteikums",pid
	if vid = "" then vid = "null"
	conn.execute "INSERT INTO piet_saite (pid,did,vietsk,vid) VALUES ("+cstr(pid)+","+cstr(did)+",1," & cstr(vid) & ")"
	isnew = true
end if




'Atlasa dalîbniekus
dquery = "SELECT piet_saite.id as id, dalibn.nosaukums as nosaukums, dalibn.vards as vards, dalibn.uzvards as uzvards, piet_saite.pid as pid, "+_
"piet_saite.cenaLVL as cenaLVL, piet_saite.cenaUSD as cenaUSD, piet_saite.cenaEUR as cenaEUR, piet_saite.cena as cena, piet_saite.papildv as papildv, piet_saite.persona as persona, piet_saite.summa as summa, piet_saite.vietsk as vietsk, piet_saite.piezimes as piezimes, piet_saite.kid as kid, "+_
"piet_saite.vid, piet_saite.vietas_veids as vietas_veids, piet_saite.kvietas_veids as kvietas_veids " + _
"FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did "+_
"WHERE piet_saite.deleted = 0 AND (piet_saite.pid="+Cstr(pid)+");"

set dalibnieki = server.createobject("ADODB.recordset")

'dalibnieki.CursorLocation = 3 '--- adUseClient
dalibnieki.CursorLocation= 3
dalibnieki.open dquery,conn,3,3

dsk = dalibnieki.RecordCount

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

'Ja sis ir grupas vaditaaja pieteikums, tad to drikst rediget tikai kurators
if nullprint(pieteikums("piezimes")) = "GRUPAS VADÎTÂJS" and isAccess(T_LIETOT_ADMIN)=false then

		'--- parbauda vai lietotajs ir siis konkretaas grupas kurators
		set rKurators = conn.execute("select * from grupa where id = "+cstr(pieteikums("gid"))+" and kurators="+cstr(GetCurUserID))
		
		if rKurators.eof Then
			skip_save = true
		end if

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
			response.redirect ("pieteikums.asp?pid=" + cstr(pid))
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
if GetComplexGroup = pieteikums("gid") then kompleks = 1

if trim(nullprint(pieteikums("gid"))) = trim(nullprint(gid)) then
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
		 if getnum(Request.Form("kvietas_veids"+cstr(id))) = 0 then
		  dalibnieki("kvietas_veids") = 1
		 else
		  dalibnieki("kvietas_veids") = getnum(Request.Form("kvietas_veids"+cstr(id)))
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
		
		if Request.Form("kvietas_veids"+cstr(id))<>""  and request.form("kid"+cstr(id))<>"" then
 		 'session("message") = "update kajite set veids = "+Request.Form("kvietas_veids"+cstr(id))+" where id = "+request.form("kid"+cstr(id))
		 'conn.execute("update kajite set veids = "+Request.Form("kvietas_veids"+cstr(id))+" where id = "+request.form("kid"+cstr(id)))
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

		if nullprint(pieteikums("piezimes")) = "GRUPAS VADÎTÂJS" then
			dalibnieki("persona") = 0
		end if		
				
		dalibnieki.update
		dalibnieki("summa") = dalibnieki("vietsk") * dalibnieki("cena")
		dalibnieki.update
		dalibnieki.movenext
	next

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
		
		if nullprint(pieteikums("piezimes")) = "GRUPAS VADÎTÂJS" then
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
'if pieteikums("gid") = 0 then
'  
'end if
pieteikums("gid") = gid
if getnum(old_gid) <> 0 then
 pieteikums("old_gid") = getnum(old_gid)
end if

'--- izòçmums, lai kurators, kuram ir atïauts saglabât grupas vaditaja pieteikumu
'--- nenojauktu vienigo atskiribas paziimi, tapec piezimes nesaglabaa
if nullprint(pieteikums("piezimes")) <> "GRUPAS VADÎTÂJS"  Then
	pieteikums("piezimes") = request.form("ppiezimes")
end if

if Request.Form("agents") <> "" and pieteikums("agents")<>"" Then
	if cint(pieteikums("agents"))<>cint(Request.Form("agents")) Then tic_changed = true else tic_changed=false
Else
	tic_changed = false
end if

pieteikums("agents") = Request.Form("agents")
pieteikums("carter_firma") = Request.Form("carter_firma")
	
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
	pieteikums("balle_knum") = bnum
 
 end if
 
 '---vietas
 if Request.Form("balle_vietas") = "" then 
	pieteikums("balle_vietas") = 0 
 else
	pieteikums("balle_vietas") = Request.Form("balle_vietas")
 end if
 
 '--- datums
 if Request.Form("balle_datums") = "" then 
	pieteikums("balle_datums") = null
 else
	pieteikums("balle_datums") = cdate(normaldate(request.form("balle_datums")))
 end if
 
 '--- piezimes
 if Request.Form("balle_piezimes") = "" then 
	pieteikums("balle_piezimes") = null
 else
	pieteikums("balle_piezimes") = request.form("balle_piezimes")
 end if
 
end if
'-------------------------------------------------------------

if request.form("students") = "on" then	pieteikums("students") = 1 else pieteikums("students") = 0
if isaccess(T_GRAMATVEDIS) then
 if request.form("krasa") = "on" then	pieteikums("krasa") = "B" else pieteikums("krasa") = NULL
end if
'-- ja vajag atcelt pieteikumu
if request.form("atcelts") = "on" then	
 pieteikums("atcelts") = 1 
else 
 pieteikums("atcelts") = 0
 pieteikums("deleted") = 0
end if


if request.form("sakuma_datums") <> "" then
 pieteikums("sakuma_datums") = normaldate2(request.form("sakuma_datums")) 'cdate(normaldate(request.form("sakuma_datums")))
else
 pieteikums("sakuma_datums") = null
end if
if request.form("beigu_datums") <> "" then
 pieteikums("beigu_datums") = normaldate2(request.form("beigu_datums")) 'cdate(normaldate(request.form("beigu_datums")))
else
 pieteikums("beigu_datums") = null
end if

if request.form("DKnorakstita") = "on" then	pieteikums("dk_norakstita") = 1 else pieteikums("dk_norakstita") = 0

pieteikums.update

pieteikums_recalculate pid


if not isnew then

 if tic_changed then
	optionalinfo = "Izmainîts TIC"
 else
	optionalinfo = ""
 end if
 LogEditActionOptionalInfo "pieteikums",pid,optionalinfo

else
 session("message") = "Pievienots jauns pieteikums"
end if

if request.form("saglabat.x") <> "" then
	response.redirect ("pieteikums.asp?pid="+cstr(pid))
end if

'--- ja grupa nav blokeeta, driikst veikt izmainjas
'if isGroupBlocked(gid) then

'end if '--- ja grupa nav blokeeta beigas. Taalaak ïauj izdariit iemaksas/izmaksas

else '--- skip_save grupas vaditaja pieteikumu, ja tas nav grupas kurators. atljauj tikai iemaksas/izmaksas
	
	if request.form("iemaksa.x") = "" and request.form("izmaksa.x") = "" then
		session("message") = "Nav tiesîbu labot grupas vadîtâja pieteikumu."	
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
