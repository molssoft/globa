<!-- #include file = "conn2.asp" -->
<%


Const T_PIET_DAT     = 1
Const T_VEC_ORD_DZ   = 2
Const T_LIETOT_ADMIN = 3
Const T_PARSK_REG    = 4
Const T_VEC_ORD_REG  = 5
Const T_ORD_LAB      = 6
Const T_NESTAND_ORD  = 7
Const T_ZAUD_LAB     = 8
Const T_KAJITES      = 9
Const T_V_PAKALPOJUMI = 10
Const T_GRUPU_PAPILD_INFO = 11
Const T_KURATORS = 12
Const T_SK_EMAILI = 13
Const T_SUT_EMAILI = 14
Const T_GR_LAB1 = 15
Const T_GR_LAB2 = 16
Const T_ATCELT = 17
Const T_GLOBAS_PARTNERI = 18
Const T_NORAKSTIT     = 19
Const T_GRAMATVEDIS     = 20
Const T_DROSIBA     = 22
Const T_ANKETAS = 23
Const T_BALLES_ORG = 24
Const T_GRAFIKS_LAB = 25
Const T_PIET_ATL_DAT = 27
Const T_GRAFIKS_SHOF = 28
Const T_PARADS = 29
Const T_TIC_BALLE = 30
Const T_ONLINE_REZ = 31
Const T_VECU_PIET_ATLAIDES = 32
Const T_CELOJUMU_APR = 34
Const T_DENY_KOMPLEKS = 36


Const AGENT_MODE = False

Session.CodePage = 1252
'Session.LCID = 3079 '--datuma pareizai attçloðanai
 Session.LCID = 2064
 


function maksajuma_veids(konts_p)

  if session("mv"+konts_p)<>"" then
	maksajuma_veids = session("mv"+konts_p)
	exit function
  end if
  
  set r = conn.execute("select * from valuta where kases_konts = '"+konts_p+"'")
  if not r.eof then
	maksajuma_veids = "kase"
	session("mv"+konts_p) = "kase"
	exit function
  end if
  set r = conn.execute("select * from valuta where bankas_konts = '"+konts_p+"'")
  if not r.eof then
	session("mv"+konts_p) = "banka"
	maksajuma_veids = "banka"
	exit function
  end if
  
	if Left(konts_p,6) = "2.6.2." then
		maksajuma_veids = "banka"
	end if  
	
end function

sub dk_iznjemums_2012(byref k_konts_p, datums_p)

	'--- maina D/K kredita kontu, saistibaa ar pvn mainju no 22% uz 21% no 1.jûlija 2012
	'--- D/K skaidrâ naudâ 2012, D/K ar pârskaitîjumu 2012,  D/K barters 2012
	
   if DateDiff("d",#07/01/12#,datums_p)>=0 then
		
		Select Case k_konts_p
			Case "5.2.2.1"
				k_konts_p = "5.2.2.9.1"
			Case "5.2.2.2"
				k_konts_p = "5.2.2.9.2"
			Case "5.2.2.3"
				k_konts_p = "5.2.2.9.3"
		End Select 
   end if

end sub

sub pieteikuma_rekviziti(pid_p,byref konts_p ,byref resurss_p )
 dim rl
 dim dat_l
 'visa nepiecieðamâ informâcja ar vienu selektu
 set rl = conn.execute("select pieteikums.datums,beigu_dat,beigu_datums,piet_saite.did,kods,old_gid,konts,konts_ava from pieteikums,piet_saite,grupa,dalibn where pieteikums.gid = grupa.id and pieteikums.id = piet_saite.pid and dalibn.id = piet_saite.did and piet_saite.deleted = 0 and pieteikums.id = "+cstr(pid_p))

 'ja pieteikums atcelts òemam veco grupu
 if getnum(rl("old_gid"))<>0 Then
	set rl = conn.execute("select pieteikums.datums,beigu_dat,beigu_datums,piet_saite.did,kods,old_gid,konts,konts_ava from pieteikums,piet_saite,grupa,dalibn where pieteikums.old_gid = grupa.id and pieteikums.id = piet_saite.pid and dalibn.id = piet_saite.did and piet_saite.deleted = 0 and pieteikums.id = "+cstr(pid_p))
 End if
 
 if rl.eof then exit sub
 'nosakam kuru beigu datumu lietot (grupas vai pieteikuma)
 if not isnull(rl("beigu_datums")) then
  dat_l = rl("beigu_datums")
 elseif not isnull(rl("beigu_dat")) then
  dat_l = rl("beigu_dat")
 else
  dat_l = now
 end if
 
    
  if year(dat_l)=year(now) and month(dat_l)=month(now) then
   
   'lietojam ieòemumu kontu
   konts_p = nullprint(rl("konts"))
   
   '--- maina D/K kredita kontu, saistibaa ar pvn mainju no 22% uz 21% no 1.jûlija 2012
	'--dk_iznjemums_2012 konts_p, rl("datums")  'skatas pec pieteikuma registracijas datuma
	
  else
   'lietojam avansa kontu
   konts_p = nullprint(rl("konts_ava"))
  end if
  
  '----------------------------------------------------------------------------
 
  konts_p = replace(konts_p,"PID",cstr(pid_p))
  konts_p = replace(konts_p,"DID",cstr(rl("did")))
 
 
  'lietojam grupas resursu
  resurss_p = nullprint(rl("kods"))
  resurss_p = replace(resurss_p,"PID",cstr(pid_p))
  resurss_p = replace(resurss_p,"DID",cstr(rl("did")))

end sub

Function Grupas_konts(gid_p)
 set r_l = conn.execute("select kods,konts,beigu_dat from grupa where id = "+cstr(gid_p))
 if nullprint(r_l("konts")) = "" then
  if nullprint(r_l("kods")) = "" then
   Grupas_konts = ""
  else
   if not isnull(r_l("beigu_dat")) then
    if year(r_l("beigu_dat")) > year(now) then
     Grupas_konts =  "5"+r_l("kods")
    else
     Grupas_konts =  "6"+r_l("kods")
    End if
   Else
    Grupas_konts =  "6"+r_l("kods")
   End if
  end if
 else
  Grupas_konts = r_l("konts")
 end if
End function


'-------------------
'grupas_veids
'------------------
Function Grupas_veids(gid_p)
 set r_l = conn.execute("select veids from grupa where id = "+cstr(gid_p))
 grupas_veids = getnum(r_l("veids"))
End function

'-------------------
'Del_Kajite
'------------------
sub Del_Kajite(id_l)
set r = Conn.Execute("SELECT DISTINCT id FROM piet_saite WHERE kid = " + cstr(id_l))
'Dzçð visus ðîs kajîtes dalîbniekus
while not r.eof
	del_piet_saite r("id")
	r.movenext
wend
conn.execute ("DELETE FROM kajite WHERE id = " + cstr(id_l))
end sub

'-------------------
'Del_Viesnica
'------------------
sub Del_Viesnica(id_l)

set r = Conn.Execute("SELECT DISTINCT id FROM piet_saite WHERE vid = " + cstr(id_l))
'Dzçð visus ðîs kajîtes dalîbniekus
while not r.eof
	del_piet_saite r("id")
	r.movenext
wend
conn.execute ("DELETE FROM viesnicas WHERE id = " + cstr(id_l))
end sub

'----- Pârbauda kurâ ofisâ atrodas lietotâjs (pçc IP)
sub check_office(return_url)
	if nullprint(session("office")) <> "" then exit sub
	set r = server.createobject("ADODB.Recordset")
	my_ip = request.Servervariables(33)
	r.open "SELECT * FROM IP WHERE ip = '" + my_ip + "'",conn,3,3
	if r.recordcount = 0 then response.redirect "Choose_office.asp?return_url=" + return_url
	session("office") = r("office")
end sub

'----- Copy_Kajites_Veidi (no gid2 uz gid1)
Sub Copy_Kajites_veidi(gid1,gid2)
if gid1 = gid2 then exit sub
conn.execute "INSERT INTO kajites_veidi (gid,nosaukums,vietas,standart_cena,bernu_cena,pusaudzu_cena,papild_cena,papild2_cena,senioru_cena) " + _
	" SELECT "+cstr(gid1)+",nosaukums,vietas,standart_cena,bernu_cena,pusaudzu_cena,papild_cena,papild2_cena,senioru_cena FROM kajites_veidi WHERE gid = " + cstr(gid2) + ""
End sub

'----- Copy_Kajites (no gid2 uz gid1)
Sub Copy_Kajites(gid1,gid2)
if gid1 = gid2 then exit sub
'---- Kopç kajîtes katram kajîtes veidam atseviðíi
set rKajVeid = conn.execute("SELECT DISTINCT veids FROM kajite WHERE gid = " +cstr(gid2))
While not rKajVeid.EOF
	'--- nokopç kajîtes veidu
	conn.execute "INSERT INTO kajites_veidi (gid,nosaukums,vietas,standart_cena,bernu_cena,pusaudzu_cena,papild_cena,papild2_cena,senioru_cena) " + _
		" SELECT "+cstr(gid1)+",nosaukums,vietas,standart_cena,bernu_cena,pusaudzu_cena,papild_cena,papild2_cena,senioru_cena FROM kajites_veidi WHERE id = " + cstr(RKajVeid("veids")) + ""
	'--- dabon nokopçtâ kajîtes veida ID
	id_l = LastID("kajites_veidi")
	'--- pârkopç ðî veida kajîtes
	conn.execute "INSERT INTO kajite (gid,vietas,veids) " + _
		" SELECT "+cstr(gid1)+",vietas,"+cstr(id_l)+ " FROM kajite WHERE veids = " + cstr(rKajVeid("veids"))
	rKajVeid.Movenext
wend
End sub

Function LastID (Table_l)
	set r = Server.CreateObject("ADODB.Recordset")
	r.open "Select id FROM " + cstr(table_l) + " ORDER BY id",conn,3,3
	r.movelast
	LastID = r("id")
end Function

Function checkLogin()
	if session("user_name")="" then
		Response.Redirect "login.asp"
	end if
End Function

'----------------------------------------------------------

'--------------------------
'-------- atgrieþ tekstu kurð satur informâciju par dalîbniekiem
'-------- tai skaitâ marðruta nosaukumu, pieteikuma datumu, dalîbnieku vârdus
function piet_info(pid_p)
dim r, ret, id
set r = server.createobject("ADODB.Recordset")
if isnull(pid_p) then
	piet_info = ""
	exit function
end if
if pid_p = "" then
	piet_info = ""
	exit function
end if
if clng(pid_p) = 0 then
	piet_info = ""
	exit function
end if
r.open "select * from pieteikums where id = "+cstr(pid_p),conn,3,3
if r.recordcount = 0 then 
	piet_info = "Pieteikums neeksistç"
	exit function
end if
if not isnull(r("datums")) then ret = TIMEPRINT(r("datums"))+" "
ret = ret + id_field("marsruts",id_field("grupa",r("gid"),"mid"),"v") + " "
r.close
r.open "SELECT * FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did WHERE piet_saite.deleted <> 1 and pid = "+cstr(pid_p),conn,3,3
if r.recordcount = 0 then 
	ret = ret + "Pieteikums nesatur dalîbniekus! "
else
	ret = ret + "<br>Dalîbnieki: "
	while not r.eof
		ret = ret + "<br>"+nullprint(r("vards")) + " "+nullprint(r("uzvards")) + " "+nullprint(r("nosaukums"))
		r.movenext
	wend
end if
if ret = "" then ret = "???"
piet_info = ret
end function


'@ 0 grupas_atlaides
function grupas_atlaides(gid_p)
set r = conn.execute("select * from pieteikums where (deleted = 0 ) and gid ="+cstr(gid_p))
while not r.eof
	grupas_atlaides = grupas_atlaides + piet_atlaides(r("id"))
	r.movenext
wend
end function


'---------------------
'@ 0 Kajites_dalibnieki
function Kajites_dalibnieki(kid_p,stils_p)
'stils_p 0 - rinda; 1 - stabiòð
dim ret
dim r_p
set r_p = CONN.EXECUTE (" SELECT piet_saite.kid, dalibn.vards, dalibn.uzvards, dalibn.nosaukums, piet_saite.pid " + _
" FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
" WHERE (NOT PIET_SAITE.DELETED = 1) AND piet_saite.kid= " +cstr(kid_p))

if NOT r_p.EOF then
	while not r_p.eof
		if stils_p = 0 then ret = ret +  nullprint(r_p("uzvards")) + " " + nullprint(r_p("nosaukums"))+ "/ " 
		if stils_p = 1 then ret = ret + "<a href = 'pieteikums.asp?pid=" + cstr(r_p("pid")) + "'>" +nullprint(r_p("vards")) + " " + nullprint(r_p("uzvards")) + " " + nullprint(r_p("nosaukums"))+ "</a><br>"
	r_p.movenext
	wend
	if stils_p = 0 then ret = mid(ret,1,len(ret)-2)
	if stils_p = 1 then ret = mid(ret,1,len(ret)-4)
else
	ret = "-"
end if
kajites_dalibnieki = ret
end function

'@ 0 Kajites_skaits
function Kajites_skaits(kid_p)
dim r_p
set r_p = server.createobject("ADODB.Recordset")
r_p.open "select count(*) as sk from piet_saite where (deleted = 0) AND kid = " + cstr(kid_p),conn,3,3
kajites_skaits = r_p("sk")
end function




'@ 0 ord_summa
function ord_summa(oid_p,pid_p)
dim sum
if piet_nVal(pid_p) = "Ls" then
	ord_summa = getnum(id_field("orderis",oid_p,"summa"))
else
	set r = conn.execute("select * from orderis where id ="+cstr(oid_p))
	set valUSD = server.createobject("ADODB.Recordset")
	valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
	kurss = 0
	if not valUSD.eof then 
		kurss = valUSD("kurss2")
		ord_summa = round100((getnum(id_field("orderis",oid_p,"summa"))*kurss))
	end if
	valUSD.close
end if
end function


'---------------------
function piet_vietas(pid_p)
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (deleted = 0 ) and pid ="+cstr(pid_p))
piet_vietas = r("sk")
end function

'---------------------
' ---- pieteikuma vietu skaits neskaitot papildvietas
function piet_vietas_tikai(pid_p)
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (deleted = 0 ) and pid = " + cstr(pid_p) + " and papildv = 0 ")
if r.recordcount = 0 then
    piet_vietas_tikai = 0
else
    piet_vietas_tikai = r("sk")
end if
end function

'---------------------
'----- pieteikuma personu skaits
function piet_personas(pid_p)
'----- vajadzçs updeitot, kad pâries uz jauno sistçmu
'----- tas bûs tad, kad personas laukâ nebûs Nulles.
set r = conn.execute("select sum(vietsk) as sk from piet_saite where ( DELETED = 0) and (persona = 1 or isnull(kid,0)<>0) and ((kvietas_veids <> 6 and kvietas_veids <> 3 and kvietas_veids <> 7) or isnull(kvietas_veids,0) = 0) and pid ="+cstr(pid_p))
piet_personas = getnum(r("sk"))
if piet_personas = 0 then piet_personas = 1
end function

'---------------------
'----- pieteikuma personu skaits
function piet_papildvietas(pid_p)
'----- vajadzçs updeitot, kad pâries uz jauno sistçmu
'----- tas bûs tad, kad personas laukâ nebûs Nulles.
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (NOT DELETED = 1) and (papildv = 1) and pid ="+cstr(pid_p))
piet_papildvietas = r("sk")
end function


'---------------------
'@ 0 piet_kopsumma
function piet_kopsumma(pid_p)
set r = conn.execute("select sum(summa) as sm from piet_saite where (not deleted = 1) and pid ="+cstr(pid_p))
piet_kopsumma = r("sm")
end function

'@ 0 piet_atlaides
function piet_atlaides(pid_p)
set r = conn.execute("select * from orderis where (not deleted=1) and pid ="+cstr(pid_p))
set rAtl = conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums=0 and pid = " + cstr(pid_p))
set rPiem = conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums=1 and pid = " + cstr(pid_p))
dim summa
summa = 0
if piet_nVal(pid_p) = "Ls" then
	while not r.eof
	summa = summa + (getnum(r("atlaide"))/100) * getnum(r("summa"))
	r.movenext
	wend
else
	set valUSD = server.createobject("ADODB.Recordset")
	summa = 0
	while not r.eof
		valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
		if not valusd.eof then
			summa = summa + (getnum(r("summa"))*getnum(valUSD("kurss2"))) * (getnum(r("atlaide"))/100)
		end if
		valUSD.close
		r.movenext
	wend
end if
summa = summa + getnum(rAtl("x"))-getnum(rPiem("x"))
piet_atlaides = round(summa*100)/100
end function



'---------------------
'@ 0 piet_iemaksas
function piet_iemaksas(pid_p)
dim sum
if piet_nVal(pid_p) = "Ls" then
	set r = conn.execute("select sum(summa) as sm from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
	piet_iemaksas = getnum(r("sm"))
else
	set r = conn.execute("select * from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
	set valUSD = server.createobject("ADODB.Recordset")
	sum = 0
	while not r.eof
		valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
		if not valUSD.eof then
			sum = sum + round(getnum(r("summa")) * getnum(valUSD("kurss2"))/100)*100
		end if
		valUSD.close
		r.movenext
	wend
	piet_iemaksas = getnum(round(sum*100)/100)
end if
end function

'------------------------------------------------------------------------------------
'piet_iemaksas2 - atgriez pieteikuma iemaksu summu latos.
'--- pirmais parametrs - pieteikuma id;
'--- otrais parametrs  - parbaude:
'--- aptiprinaataas (=0), neapstiprinaataas (=1), visas iemaksas (=citas vertibas)
'------------------------------------------------------------------------------------

function piet_iemaksas3(pid_p, parbaude, valuta)
	dim whereC
	
	select case parbaude
		case 0 
			whereC = "and parbaude = 0"
		case 1 
			whereC = "and parbaude = 1"
		case else 
			whereC = ""
	end select


	set r = conn.execute("select sum(summa"+valuta+") from orderis where (deleted = 0) "+whereC+" and pid ="+cstr(pid_p))
	piet_iemaksas3 = getnum(r(0))

end function

function piet_izmaksas3(pid_p, parbaude, valuta)
	dim whereC
	
	select case parbaude
		case 0 
			whereC = "and parbaude = 0"
		case 1 
			whereC = "and parbaude = 1"
		case else 
			whereC = ""
	end select


	set r = conn.execute("select * from orderis where (deleted = 0) "+whereC+" and nopid ="+cstr(pid_p))
	sum = 0
	while not r.eof
		if getnum(r("pid")) = getnum(r("nopid")) then
			sum = sum + getnum(r("nosumma"+valuta))
		else
			sum = sum + getnum(r("summa"+valuta))
		end if
		r.movenext
	wend

	'set r = conn.execute("select sum(summa"+valuta+") from orderis where (deleted = 0) "+whereC+" and nopid ="+cstr(pid_p))
	
	piet_izmaksas3 = sum

end function


function piet_iemaksas2(pid_p, parbaude, atlaides)
	
	dim sum
	dim whereC
	
	select case parbaude
		case 0 
			whereC = "and parbaude = 0"
		case 1 
			whereC = "and parbaude = 1"
		case else 
			whereC = ""
	end select


	set r = conn.execute("select * from orderis where (deleted = 0) "+whereC+" and pid ="+cstr(pid_p))
	set valkurss = server.createobject("ADODB.Recordset")
	sum = 0
	while not r.eof

		'--- komentçts 23. aug 2010 Nils
		'--- atkomentçts 8.dec 2010 Nils
		
		
		if r("valuta")=68 or r("valuta")=49 then
			valkurss.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = " + cstr(r("valuta")),conn,3,3
			if not valkurss.eof then
				sum = sum + round(getnum(r("summa")) * getnum(valkurss("kurss2")) )
				'sum = sum + round(getnum(r("summa")) / getnum(valkurss("kurss"))/100)*100
			end if
			valkurss.close
		else
		
			sum = sum + getnum(r("summa"))	'--- summa latos
		
		end if
		
	r.movenext
	wend
	
	
	if 0 = 1 then 
	'--- pieskaita atlaides -------------------

	'--- iznemts ara 18. Jan 2010 Nils. 
	'--- Atsakoties no celojuma atlaides iemaksam klaat nav jaskaita (izmaksajot naudu skaidra, parskaitot uz avansu vai parskaitot uz citu celojumu).
	'if atlaides = 1 then

	set r = conn.execute("select * from piet_atlaides where veids <> 7 and pid ="+cstr(pid_p)) '--- veids=7 ir piemaksa nevis atlaide, to klat iemaksam neskaita. 29/12/2009 Nils
	while not r.eof
		
		if getnum(r("atlaideLVL"))<>0 then

			sum = sum + getnum(r("atlaideLVL"))

		else if	getnum(r("atlaideUSD"))<>0 then
		
				valkurss.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
				if not valkurss.eof then
					sum = sum + round(getnum(r("atlaideUSD")) * getnum(valkurss("kurss2"))/100)*100
				end if
				valkurss.close
				
			else if	getnum(r("atlaideEUR"))<>0 then
		
				valkurss.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 49",conn,3,3
				if not valkurss.eof then
					sum = sum + round(getnum(r("atlaideEUR")) * getnum(valkurss("kurss2"))/100)*100
				end if
				valkurss.close
					
				end if			
			end if
		end if
		
	r.movenext
	wend
	'-------------------------------------------
	
	end if
	
	piet_iemaksas2 = getnum(round(sum*100)/100)

end function

'------------------------------------------------------------------------------------

'@ 0 piet_izmaksas
function piet_izmaksas(pid_p)
dim sum

	if piet_nVal(pid_p) = "Ls" then
		set r = conn.execute("select sum(summa) as sm from orderis where (deleted = 0 ) and NoPid ="+cstr(pid_p))
		piet_izmaksas = getnum(r("sm"))
	else
		set r = conn.execute("select * from orderis where (deleted = 0 ) and Nopid ="+cstr(pid_p))
		set valUSD = server.createobject("ADODB.Recordset")
		while not r.eof
			valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND (valuta = 68 or valuta = 49)" ,conn,3,3
			IF NOT VALUSD.EOF THEN
				sum = sum + round(r("summa")*valUSD("kurss2")*100)/100
			ELSE
				RESPONSE.WRITE "NAV NORÂDÎTS VALÛTAS KURSS. DATUMS:" + dateprint(r("datums"))
				'response.write "select kurss from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68"
			END IF
			valUSD.close
			r.movenext
		wend
		piet_izmaksas = int(sum*100)/100
	end if


end function

'---------------------
'@ 0 piet_iem_sk
function piet_iem_sk(pid_p)
set r = conn.execute("select count(*) as sm from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
piet_iemaksas = r("sm")
end function

'---------------------
'piet_bilance
function piet_bilance(pid_p)
set r = conn.execute("SELECT iemaksas,summa,izmaksas,atlaides FROM Pieteikums WHERE id = " + cstr(pid_p))
IF R.EOF THEN EXIT FUNCTION
piet_bilance = getnum(r("iemaksas")) - getnum(r("summa")) - getnum(r("izmaksas")) + getnum(r("atlaides"))
end function
'---------------------
'@ 0 piet_saite_id
'Agrieþ pirmo piet_saiti pieteikumâ
function piet_saite_id(pid_p,s_p)
set r = conn.execute("select count(*) as sk from piet_saite where (deleted = 0 ) and pid ="+cstr(pid_p))
set s = conn.execute("select * from piet_saite where (deleted = 0 ) and pid ="+cstr(pid_p))
piet_vietas = r("sk")
if piet_vietas = 0 then 
	piet_saite_id = 0
	exit function
end if
s.movefirst
for i_l = 1 to r("sk")
	if i_l = s_p then
		piet_saite_id = s("id")
		exit function
	end if
	if s.eof then 
		piet_saite_id = 0
		exit function
	end if
next
end function

'-------------------------------
'---- Grupa_recalculate ---
'-------------------------------
'Pârçíina visus pieteikumus grupâ
Sub Grupa_recalculate(gid_p)
set r_l = conn.execute ("SELECT id FROM pieteikums WHERE gid = " + cstr(gid_p) + " AND (deleted = 0 )" )
while not r_l.eof
	pieteikums_recalculate(r_l("id"))
	r_l.movenext
wend
End Sub


'-------------------------------
'---- KAJITES_VEIDS_recalculate ---
'-------------------------------
'Pârçíina visus pieteikumus grupâ
Sub KAJITES_VEIDS_recalculate(Kv_p)
set r_l = conn.execute("SELECT distinct piet_saite.pid FROM piet_saite INNER JOIN kajite ON piet_saite.kid = kajite.id WHERE veids = " + cstr(kv_p) )
while not r_l.eof
	pieteikums_recalculate(r_l("pid"))
	r_l.movenext
wend
End Sub


'------------------------------------------------------------------------------------------------
'---- Pieteikums_recalculate ---
'------------------------------------------------------------------------------------------------
'Pârçíina visas piet_saites pakalpojumâ

Sub Pieteikums_recalculate(pid_p)
	'RT: no 06.06.2019 pârejam uz storetâs SQL procedûras izmantoðanu:
	'rw "exec pieteikums_calculate_new2 "+cstr(pid_p)



	if (cstr(pid_p)<>"0") then
	 conn.execute("exec pieteikums_calculate_new2 "+cstr(pid_p))
	end if 
	'-- set r_l = conn.execute ("SELECT id FROM piet_saite WHERE pid = " + cstr(pid_p) + " AND (not deleted=1)")
	 '-- while not r_l.eof
	 '--  piet_saite_recalculate(r_l("id"))
	 '--  r_l.movenext
	 '-- wend
	 '-- personas_l = getnum(piet_personas(pid_p))
	 '-- papildvietas_l = getnum(piet_papildvietas(pid_p))
	
	 '-- conn.execute "UPDATE Pieteikums SET personas = "+cstr(personas_l)+",papildvietas="+cstr(papildvietas_l)+" WHERE id = " + cstr(pid_p)
	'rw "UPDATE Pieteikums SET personas = "+cstr(personas_l)+",papildvietas="+cstr(papildvietas_l)+" WHERE id = " + cstr(pid_p)
	
	'response.write "UPDATE Pieteikums SET personas = "+cstr(personas_l)+",papildvietas="+cstr(papildvietas_l)+", atlaides = "+cstr(atlaides_l)+",iemaksas = "+cstr(iemaksas_l)+",izmaksas = "+cstr(izmaksas_l)+",summa = "+cstr(summa_l) + " WHERE id = " + cstr(pid_p)

	'--  info_l = piet_info(pid_p)
	'--  conn.execute "UPDATE Pieteikums SET info = N'"+info_l+"' where id = " + cstr(pid_p)
	'-- pieteikums_recalculate2 pid_p


End Sub

'------------------------------------------------------------------------------------------------
Sub Pieteikums_recalculate2(pid_p)

if clng(getnum(pid_p)) = 0 then 
	exit sub
end if

'-- vecajiem pieteikumiem visi valutas summas lauki ir 0
dim vecais 
vecais = false

set r_l = conn.execute("select * from orderis where  nopid = " +cstr(pid_p))
while not r_l.eof
	if getnum(r_l("deleted"))=0 then
		if getnum(r_l("summaLVL")) = 0 and getnum(r_l("summaEUR")) = 0 and getnum(r_l("summaUSD")) = 0 then
			vecais = true
		end if
	end if
	r_l.movenext
wend

set r_l = conn.execute("select * from orderis where  pid = "+cstr(pid_p))
while not r_l.eof
	if getnum(r_l("deleted"))=0 then
		if getnum(r_l("summaLVL")) = 0 and getnum(r_l("summaEUR")) = 0 and getnum(r_l("summaUSD")) = 0 then
			vecais = true
		end if
	end if
	r_l.movenext
wend
'-- ði te izteiksme baigi bremzçja
'--set r_l = conn.execute("select * from orderis where deleted =0 and isnull(summaLVL,0)=0 and isnull(summaUSD,0)=0 and isnull(summaEUR,0)=0 and (kredits not like '%.%' or isnull(kredits,'')='') and (debets not like '%.%' or isnull(debets,'')='') and (pid = "+cstr(pid_p) + " or (nopid = " +cstr(pid_p)+"))")

'--- paarreekina iekljaujot veco pieteikumu logiku (atpakalj savietojamiibai)
if vecais then 
	
	
 dim summaLVL
 dim summaUSD
 dim iemaksasLVL
 dim iemaksasUSD
 dim izmaksasLVL
 dim izmaksasUSD
 dim atlaidesLVL 
 dim atlaidesUSD 
 dim sadardzinLVL 
 dim sadardzinUSD 

 set rGrupa_l = conn.execute("select * from grupa where id = (select gid from pieteikums where id = "+cstr(pid_p)+")")
 if rGrupa_l.eof then exit sub
 set rMarsruts_l = conn.execute("select * from marsruts where id = (select mid from grupa where id = "+cstr(rGrupa_l("id"))+")")
 if rMarsruts_l.eof then exit sub
 '-------- atlaides un sadardzinajumi
 atlaidesLVL = 0
 atlaidesUSD = 0
 atlaidesEUR = 0
 atlaidesBIL = 0
 sadardzinLVL = 0
 sadardzinUSD = 0
 sadardzinEUR = 0
 sadardzinBIL = 0
 set r_l = conn.execute("select uzcenojums,isnull(atlaide,0) as old,isnull(atlaidelvl,0) as lvl,isnull(atlaideusd,0) as usd,isnull(atlaideEUR,0) as eur,isnull(atlaidebil,0) as bil from piet_atlaides where pid = "+cstr(pid_p))
  while not r_l.eof
   if getnum(r_l("LVL")) = 0 and getnum(r_l("USD")) = 0 and getnum(r_l("EUR")) = 0 then
    if nullprint(rGrupa_l("valuta")) <> "XXX" and not rMarsruts_l("usd") then
		   if r_l("uzcenojums") = 0 then
		    atlaidesLVL = atlaidesLVL + r_l("old")
		   else
		    sadardzinLVL = sadardzinLVL + r_l("old")
		   end if
	   else
		   if r_l("uzcenojums") = 0 then
		    atlaidesUSD = atlaidesUSD + r_l("old")
		   else
		    sadardzinUSD = sadardzinUSD + r_l("old")
		   end if
	   end if
   else
    if r_l("uzcenojums") = 0 then
     atlaidesLVL = atlaidesLVL + r_l("LVL")
     atlaidesUSD = atlaidesUSD + r_l("USD")
     atlaidesEUR = atlaidesEUR + r_l("EUR")
     atlaidesBIL = atlaidesBIL + r_l("BIL")
    else
     sadardzinLVL = sadardzinLVL + r_l("LVL")
     sadardzinUSD = sadardzinUSD + r_l("USD")
     sadardzinEUR = sadardzinEUR + r_l("EUR")
     sadardzinBIL = sadardzinBIL + r_l("BIL")
    end if
   end if
   r_l.MoveNext
  wend

 'iemaksas un izmaksas
 iemaksasLVL = 0
 iemaksasUSD = 0
 iemaksasEUR = 0
 izmaksasLVL = 0
 izmaksasUSD = 0
 izmaksasEUR = 0
 set r_l = conn.execute("select id,pid,nopid,summa,summaval,valuta,datums,summaUSD,summaLVL,summaEUR,nosummaUSD,nosummaLVL,nosummaEUR from orderis where deleted = 0 and (pid = "+cstr(pid_p) + " or (nopid = " +cstr(pid_p)+"))")
  while not r_l.eof
   if getnum(r_l("summaLVL")) = 0 and getnum(r_l("summaUSD")) = 0 and getnum(r_l("summaEUR")) = 0 then
    'lati
		  if cstr(getnum(r_l("pid"))) = cstr(pid_p) then
		   'ieòçmums
		   iemaksasLVL = iemaksasLVL + r_l("summa")
		   'janu parskaitijums uz to pashu
		   if cstr(getnum(r_l("nopid"))) = cstr(pid_p) then
		    izmaksasLVL = izmaksasLVL + r_l("summa")
		   end if
		  else
		   izmaksasLVL = izmaksasLVL + r_l("summa")
		  end if
   else
    'te tikai sakas jaunas stils
	   if cstr(getnum(r_l("pid"))) = cstr(pid_p) then
	    'ieòçmums
	    iemaksasLVL = iemaksasLVL + getnum(r_l("summaLVL"))
	    iemaksasUSD = iemaksasUSD + getnum(r_l("summaUSD"))
	    iemaksasEUR = iemaksasEUR + getnum(r_l("summaEUR"))
	    'janu parskaitijums uz to pashu
	    if cstr(getnum(r_l("nopid"))) = cstr(pid_p) then
	     izmaksasLVL = izmaksasLVL + getnum(r_l("nosummaLVL"))
	     izmaksasUSD = izmaksasUSD + getnum(r_l("nosummaUSD"))
	     izmaksasEUR = izmaksasEUR + getnum(r_l("nosummaEUR"))
	    end if
	   else
	    'izdevums
	    izmaksasUSD = izmaksasUSD + getnum(r_l("nosummaUSD"))
	    izmaksasLVL = izmaksasLVL + getnum(r_l("nosummaLVL"))
	    izmaksasEUR = izmaksasEUR + getnum(r_l("nosummaEUR"))
	   end if
   end if
   r_l.MoveNext
  wend
 
 'summa
 summaLVL = 0
 summaUSD = 0
 summaEUR = 0
 set r_l = conn.execute("select * from piet_saite where deleted = 0 and pid = "+cstr(pid_p))
  while not r_l.eof
   if getnum(r_l("summaLVL")) = 0 and getnum(r_l("summaUSD")) = 0 and getnum(r_l("summaEUR")) = 0 then
    if ucase(rGrupa_l("valuta")) = "XXX" then
   conn.execute ("insert into test (num) values ("+cstr(getnum(r_l("summaLVL")))+")")
      summaUSD = summaUSD + getnum(r_l("cenaUSD"))
      summaLVL = summaLVL + getnum(r_l("cenaLVL"))
      summaEUR = summaEUR + getnum(r_l("cenaEUR"))
    else
     if not rMarsruts_l("usd") then
      summaLVL = summaLVL + getnum(r_l("summa"))
	    else
         summaUSD = summaUSD + getnum(r_l("summa"))
	    end if
	   end if
   else
    summaLVL = summaLVL + r_l("summaLVL")
   	summaUSD = summaUSD + r_l("summaUSD")
   	summaEUR = summaEUR + r_l("summaEUR")
   end if
   r_l.MoveNext
  wend
 
 'bilance
 bilanceLVL = -summaLVL+iemaksasLVL-izmaksasLVL+atlaidesLVL-sadardzinLVL
 bilanceUSD = -summaUSD+iemaksasUSD-izmaksasUSD+atlaidesUSD-sadardzinUSD
 bilanceEUR = -summaEUR+iemaksasEUR-izmaksasEUR+atlaidesEUR-sadardzinEUR

 'saglabâ vçrtîbas
 conn.execute "update pieteikums set atlaidesLVL="+cstr(atlaidesLVL)+",atlaidesUSD="+cstr(atlaidesUSD)+",atlaidesEUR="+cstr(atlaidesEUR)+",atlaidesBIL="+cstr(atlaidesBIL)+",sadardzinLVL="+cstr(sadardzinLVL)+",sadardzinUSD="+cstr(sadardzinUSD)+",sadardzinEUR="+cstr(sadardzinEUR)+",sadardzinBIL="+cstr(sadardzinBIL)+ _ 
 " ,iemaksasLVL="+cstr(iemaksasLVL)+",iemaksasUSD="+cstr(iemaksasUSD)+",iemaksasEUR="+cstr(iemaksasEUR)+",izmaksasLVL="+cstr(izmaksasLVL)+",izmaksasUSD="+cstr(izmaksasUSD)+",izmaksasEUR="+cstr(izmaksasEUR)+ _ 
 " ,summaLVL="+cstr(summaLVL)+",summaUSD="+cstr(summaUSD)+",summaEUR="+cstr(summaEUR)+ _ 
 " ,bilanceLVL=round("+cstr(bilanceLVL)+",2),bilanceUSD=round("+cstr(bilanceUSD)+",2),bilanceEUR=round("+cstr(bilanceEUR)+",2)" + _ 
 " where id = "+cstr(pid_p)


else
	'rw "izsauc proceduru"
	'--- jauno pieteikumu parrekins
	'--- storeta procedura

	conn.execute("exec pieteikums_calculate "+cstr(pid_p))


		
end if

End Sub


'-------------------------------
'---- Pieteikums_recalculate_short ---
'-------------------------------
'Pârçíina tikai pashu pieteikumu nepaarekinot saites
Sub Pieteikums_recalculate_short(pid_p)
conn.execute "UPDATE Pieteikums SET Info = '"+Piet_info(pid_p)+"' WHERE id = " + cstr(pid_p)
pieteikums_recalculate2 pid_p
End Sub



'-------------------------------
'---- Piet_saite_recalculate ---
'-------------------------------
'Pârçíina pakalpojuma vai vietas cenu un citas lietas
Sub Piet_saite_recalculate(psid_p)
  '---- sakalkuleetaa summa
  dim sum_l
  sum_l = 0
  is_online = false
  
  '---- dabon ðo saiti no datubâzes
  set r_l = conn.execute ("select * from piet_saite where id = " + cstr(psid_p))

  '---- dabon grupu
  set rGrupa = conn.execute ("select * from grupa where id in (select gid from pieteikums where id = "+cstr(getnum(r_l("pid")))+")")

  '--- nosakam grupas valutu
 ' rw "select * from marsruts where id = " + cstr(getNum(rGrupa("mid")))
   set rCurMar = conn.execute("select * from marsruts where id = " + cstr(getNum(rGrupa("mid"))))
	if getnum(rCurMar("USD")) = -1 then valuta = "USD" else valuta = "LVL"
	
  if nullprint(rGrupa("valuta"))<>"" then
	valuta = rGrupa("valuta")
  end if
  
 ' valuta = "EUR" 
  'if nullprint(rGrupa("valuta"))<>"" then
	'valuta = rGrupa("valuta")
 ' end if

  '--- parbauda vai ta ir online rezervacija un ja ir cenaLVL ieliek nulle
  ssql = "select isnull(online_rez,0) as online_rez from pieteikums where id = "+cstr(getnum(r_l("pid")))
  
  set r_online = conn.execute (ssql)
  
  if r_online.eof then exit sub
  
  if r_online("online_rez")<>0 then is_online = true

  '---- pârbauda vai ir pieðíirta kâda vieta
  if getnum(r_l("vietas_veids")) <> 0 then
	
	if is_online then 
		whereC = ", cenaLVL = 0, cenaEUR = 0, cenaUSD = 0 "
	else
		whereC = ""
	end if
			
	'----- Atrod ðîs vietas cenu
	'rw "select * from vietu_veidi where id = " + cstr(r_l("vietas_veids"))
	set r_cena_l = conn.execute ("select * from vietu_veidi where id = " + cstr(r_l("vietas_veids")))

	  '----- Pârbauda vai ðâds vietas veids eksistç
	  if not r_cena_l.eof then
		  '----- saglabâ ðîs vietas cenu, papildv un personas pazimi
		  if r_cena_l("papildv") then papildv_l = "1" else papildv_l="0"
		  if r_cena_l("persona") then persona_l = "1" else persona_l="0"
		  '---kvietas_veids = 6 ja ir rezervçta tukða vieta kajîtç
		  if getnum(r_l("kid"))<>0 and getnum(r_l("kvietas_veids"))<>6 and getnum(r_l("kvietas_veids"))<>3 and getnum(r_l("kvietas_veids"))<>7 then persona_l = "1"
		  	
		ssql = "UPDATE piet_saite set vietas_cena = " + cstr(getnum(r_cena_l("cena"))) + _
		  ", vietas_cenaLVL = " + cstr(getnum(r_cena_l("cenaLVL"))) +", vietas_cenaEUR = '" + cstr(getnum(r_cena_l("cenaEUR"))) +"',vietas_cenaUSD = " + cstr(getnum(r_cena_l("cenaUSD"))) + ", papildv = "+papildv_l+", persona = " + persona_l + whereC + " WHERE id = " + cstr(psid_p)
		  'rw ssql
		  conn.execute ssql
	  else
		  '----- saglabâ ðîs vietas cenu ka tâ ir 0
		  conn.execute "UPDATE piet_saite set vietas_cena = 0,vietas_cenaLVL = 0, vietas_cenaUSD = 0, vietas_cenaEUR = 0" + whereC + _
		   " WHERE id = " + cstr(psid_p)
	  end if
  else
   '----- saglabâ ðîs vietas cenu ka tâ ir 0
	   '---25/02/2010 Nils. pievienoti lauki:  "cenaLVL = 0, cenaEUR = 0, cenaUSD = 0 " + _   
	   '---online rezervacijam cena nav nulle un atteiktaa pieteikumaa pec parrekina paliek sii piet_saites summa 

   conn.execute "UPDATE piet_saite set vietas_cena = 0,vietas_cenaLVL = 0, vietas_cenaUSD = 0, vietas_cenaEUR = 0, " + _
	   "cenaLVL = 0, cenaEUR = 0, cenaUSD = 0 " + _
	   "WHERE id = " + cstr(psid_p)
	   
  end if

  '---- pârbauda vai ir pieðíirta kâda kajîte
  if getnum(r_l("kid")) <> 0 then
	conn.execute "UPDATE piet_saite set kvietas_cena = 0, kvietas_cenaLVL = 0, kvietas_cenaEUR = 0, kvietas_cenaUSD = 0 " + _
		  " WHERE id = " + cstr(psid_p)
	'----- Atrod ða kajîti
	set r_kajite_l = conn.execute ("select * from kajite " + _ 
	"where kajite.id = " + cstr(r_l("kid")))
	'----- saglabâ ðîs vietas cenu
	kc = cstr(Kajites_Veida_Cena(getnum(r_kajite_l("veids")),getnum(r_l("kvietas_veids"))))
	conn.execute "UPDATE piet_saite set kvietas_cena = " + kc + _
		   ", kvietas_cena"+valuta+" = "+kc+" WHERE id = " + cstr(psid_p)
  else
	'----- saglabâ ðîs vietas cenu ka tâ ir 0
	conn.execute "UPDATE piet_saite set kvietas_cena = 0, kvietas_cenaLVL = 0, kvietas_cenaEUR = 0, kvietas_cenaUSD = 0 " + _
		  " WHERE id = " + cstr(psid_p)
  end if


  '--- vçlreiz atver pieteikuma saiti lai sakalkulçtu cenas
  set r_l = conn.execute ("select * from piet_saite where id = " + cstr(psid_p))
  
  if getnum(r_l("vietas_cenaLVL"))=0 and getnum(r_l("vietas_cenaUSD"))=0 and getnum(r_l("vietas_cenaEUR"))=0 then
   sumLVL_l = (getnum(r_L("cenaLVL"))+getnum(r_L("kvietas_cenaLVL")))*getnum(r_l("vietsk"))
   sumUSD_l = (getnum(r_L("cenaUSD"))+getnum(r_L("kvietas_cenaUSD")))*getnum(r_l("vietsk"))
   sumEUR_l = (getnum(r_L("cenaEUR"))+getnum(r_L("kvietas_cenaEUR")))*getnum(r_l("vietsk"))
	  '----- Pieskaita vietas cenu
	  sum_l = sum_l + getnum(r_l("vietas_cena"))
	  '----- Pieskaita kajîtes cenu
	  sum_l = sum_l + getnum(r_l("kvietas_cena"))
	  '--- pieskaita cenas korekciju korekciju
	  sum_l = (sum_l + getnum(r_l("cena"))) * getnum(r_l("vietsk"))
	  '--- saglabâ sakalkulçto summu tai paðâ ierakstâ
   if sumLVL_l = 0 and sumUSD_l = 0 and sumEUR_l = 0 then
	if valuta="LVL" then
		sumLVL_l = getnum(r_L("cena"))
	else
		sumEUR_l = getnum(r_L("cena"))
	end if
   end if
   
   conn.execute "UPDATE piet_saite set summa = " + sqlnum(getnum(sum_l)) + ", summaLVL = "+sqlnum(sumLVL_l)+", summaEUR = "+sqlnum(sumEUR_l)+",summaUSD = "+sqlnum(sumUSD_l)+" " + _
		  " WHERE id = " + cstr(psid_p)
  else
   sumUSD_l = 0
   sumLVL_l = 0
   sumEUR_l = 0
	  '----- Pieskaita vietas cenu
	  sumLVL_l = sumLVL_l + getnum(r_l("vietas_cenaLVL"))
	  sumUSD_l = sumUSD_l + getnum(r_l("vietas_cenaUSD"))
	  sumEUR_l = sumEUR_l + getnum(r_l("vietas_cenaEUR"))
	  '----- Pieskaita kajîtes cenu
	  sumLVL_l = sumLVL_l + getnum(r_l("kvietas_cenaLVL"))
	  sumEUR_l = sumEUR_l + getnum(r_l("kvietas_cenaEUR"))
	  sumUSD_l = sumUSD_l + getnum(r_l("kvietas_cenaUSD"))
	  '--- pieskaita cenas korekciju 
	  sumLVL_l = (sumLVL_l + getnum(r_l("cenaLVL"))) * getnum(r_l("vietsk"))
	  sumUSD_l = (sumUSD_l + getnum(r_l("cenaUSD"))) * getnum(r_l("vietsk"))
	  sumEUR_l = (sumEUR_l + getnum(r_l("cenaEUR"))) * getnum(r_l("vietsk"))
	  '--- saglabâ sakalkulçto summu tai paðâ ierakstâ
	  conn.execute "UPDATE piet_saite set summaLVL = " + cstr(getnum(sumLVL_l)) + ", summaUSD = " + cstr(sumUSD_l) + ", summaEUR = " + cstr(sumEUR_l) + _
		 " WHERE id = " + cstr(psid_p)
  end if
End Sub

'-------------------------------------
'kv_p - kajîtes veids (kajites_veidi.id)
'kvv_p - kajîtes vietas veids (piet_saite.kvietas_veids)

Function Kajites_veida_cena (kv_p,kvv_p)
set r_l = conn.execute("SELECT * FROM kajites_veidi WHERE id = " + cstr(getnum(kv_p)))
Kajites_veida_cena = 0
if not r_l.eof then
	if kvv_p = 1 then Kajites_veida_cena = getnum(r_l("standart_cena"))
	if kvv_p = 2 then Kajites_veida_cena = getnum(r_l("bernu_cena"))
	if kvv_p = 3 then Kajites_veida_cena = getnum(r_l("papild_cena"))
	if kvv_p = 6 then Kajites_veida_cena = getnum(r_l("papild2_cena"))
	if kvv_p = 7 then Kajites_veida_cena = getnum(r_l("papild3_cena"))
	if kvv_p = 4 then Kajites_veida_cena = getnum(r_l("senioru_cena"))
	if kvv_p = 5 then Kajites_veida_cena = getnum(r_l("pusaudzu_cena"))
else
	Kajites_veida_cena = 0
end if
end function


'-----------------------------------
'@ 0 Del_Piet
sub Del_Piet(id_l)
conn.execute ("UPDATE  orderis SET deleted = 1 WHERE pid = "+cstr(id_l))
conn.execute ("UPDATE  piet_saite SET deleted = 1 WHERE pid = "+cstr(id_l))
conn.execute ("UPDATE  pieteikums SET deleted = 1 WHERE id = "+cstr(id_l))
'atrod online rezervâciju, ja ir un nodzçð arî to
set rOnline = conn.execute("select isnull(online_rez,0) from pieteikums where id = " + cstr(pid))
set online_rez = rOnline(0)
if online_rez<>0 then
	conn.execute("Update online_rez set deleted = 1 WHERE id="+cstr(online_rez))
end if
LogDeleteAction "pieteikums",id_l
WriteLog 1,id_l,"D"
end sub



'-----------------------------------
'@ 0 del_piet_saite
'--- arguments piet_saite.id
sub del_piet_saite(id_l)

	set old_saites_vals = CreateDict("select * from piet_saite where id = " + cstr(id_l))

	dzesam = false
 '--- Atceras pieteikumu, kurâ tiks dzçsta pieteikumu saite
 
 pid_l = conn.execute("select pid from piet_saite where id = " + cstr(id_l))(0)

 set r = conn.execute ("select * from pieteikums where id = " + cstr(pid_l))
 if r.eof then
	conn.execute ("update piet_saite set deleted = 1 where id = " + cstr(id_l))
	exit sub
 end if
 
	set old_vals = CreateDict("select * from pieteikums where id = " + cstr(pid_l))


 'nosaka cik saiðu ir ðim pieteikumam
 sk = getnum(conn.execute("select count(*) from piet_saite where deleted = 0 and pid = "+cstr(pid_l))(0))
 if sk = 1 then
  'parbaudam vai ir orderi
  sk_o = getnum(conn.execute("select count(id) from orderis where (pid = "+cstr(pid_l)+" or nopid = "+cstr(pid_l)+") and deleted = 0 " )(0))
  'dzçð tikai tad ja orderu nav
  if sk_o = 0 then
  dzesam = true
   conn.execute("update piet_saite set deleted = 1 where id = " + cstr(id_l))
   conn.execute("update pieteikums set deleted = 1 where id = " + cstr(pid_l))
  end if
 else
  'dzçðam
  dzesam = true
  conn.execute("update piet_saite set deleted = 1 where id = " + cstr(id_l))
 end if
 
 if dzesam then
	 FieldsToSave = GetPietSaiteEditFields()
	 set	new_saites_vals0  = Server.CreateObject("Scripting.Dictionary")
	set old_saites_vals0  = Server.CreateObject("Scripting.Dictionary")
	history = "** Dzçsts pakalpojums :: "
	 For each item in FieldsToSave
		if (nullprint(old_saites_vals(item)) <> "" and nullprint(old_saites_vals(item)) <> "0") then
			history = history + GetFieldTitle(item,"piet_saite") + ": "+GetValStr(item,nullprint(old_saites_vals(item)))+ ", "
		
			'old_saites_vals0.add item,old_vals(item)
			'new_saites_vals0.add item,""
		end if
	 Next
	 
	 'response.end
	  If Right(history, 2) = ", " Then 
		history = Left(history, Len(history) - 2) 
	  end if
		history = history + " => <br>"
			pieteikums_recalculate pid_l
	 set new_vals = CreateDict("select * from pieteikums where id = " + cstr(pid_l))
	 UpdateActionDetails old_vals,new_vals,"pieteikums",pid_l,history
	' LogUpdateActionNew "pieteikums",pid_l,history

 end if
End sub


'----- Daþâdi darbi saistîti ar pieteikumu uzturçðanu kârtîbâ
Sub Refresh_Pieteikums(id_l)
'----- Pârbauda vai pieteikumâ ir kaut viena saite, ja nç tad izdzçð pieteikumu
set r = Server.CreateObject ("ADODB.Recordset")	
r.open "SELECT * FROM Piet_saite WHERE pid = " + cstr(id_l),conn,3,3
if r.recordcount = 0 then
	conn.execute "UPDATE Pieteikums SET Deleted = 1 where id = " + cstr(id_l)
end if
end sub

sub Del_dal(id_l)
	conn.execute ("UPDATE  dalibn SET deleted = 1 WHERE id = "+cstr(id_l))
	'jâizdzçð arî atbilsoðais profils
	'rw "SELECT pk1,pk2 FROM dalibn WHERE  id = "+cstr(id_l)
	set rdal = conn.execute("SELECT pk1,pk2 FROM dalibn WHERE  id = "+cstr(id_l))
	if not rdal.eof then
		pk1 = rdal("pk1")
		pk2 = rdal("pk2")
		if (pk1 <> "" and pk2 <> "") then
			'rw "select id from profili where pk1 = '"+cstr(pk1)+"' and pk2 = '"+cstr(pk2)+"'"
			Set profils = conn.execute("select id from profili where pk1 = '"+cstr(pk1)+"' and pk2 = '"+cstr(pk2)+"'")



			
			If Not profils.eof Then
				conn.execute("DELETE FROM profili WHERE id="+cstr(profils("id"))+"")
				
			End if
		end if
	end if

	'response.end

	LogDeleteAction "dalibn",id_l
end sub


'------------------------------------------------------------
sub DelOrderis(id_l)
conn.execute ("UPDATE orderis SET deleted = 1,need_check=1 WHERE id = " + cstr(id_l))
LogDeleteAction "orderis",id_l
end sub
'------------------------------------------------------------

Sub LogEditAction(table_p,id_l)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
ves = r_l("vesture")
if isnull(ves) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Laboja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - Laboja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogEditActionOptionalInfo(table_p,id_l,info)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
ves = r_l("vesture")
if info <> "" Then info = " (" + info + ")"
if isnull(ves) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Laboja"+info+". "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - Laboja "+info+". "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogUpdateAction(table_p,id_l)
	set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
	'response.write("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
	if not r_l.eof then
		ves = r_l("vesture")
		if isnull(ves) then
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Laboja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
		else
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - Laboja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
		end if
	end if
End Sub

'izveido dictitonary obkektu no vaicâjuma
Function CreateDict(query)

	'rw query
	'dim conn
	'OpenConn
	set r= conn.execute(query)
	'Dim vals
	Set vals=Server.CreateObject("Scripting.Dictionary")
		For intLoop = 0 To (r.Fields.Count - 1)  
			field_name = r.Fields.Item(intLoop).Name 
			field_value = r(field_name)
			if vals.Exists(field_name) then
				vals.Remove(field_name)
			end if
			vals.Add field_name,field_value
			
		Next
	set CreateDict = vals
end Function

'izveido dictionary objektu no vaicâjuma atgrieztâ recordseta
Function CreateDictR(r)
	Dim vals
	Set vals=Server.CreateObject("Scripting.Dictionary")
		For intLoop = 0 To (r.Fields.Count - 1)  
			field_name = r.Fields.Item(intLoop).Name 
			field_value = r(field_name)
			
			if vals.Exists(field_name) then
				vals.Remove(field_name)
			end if
			vals.Add field_name,field_value 
			
		Next
	set CreateDictR = vals
end Function


'saglabâ vçtures informâciju ar izmaiòu detaïâm
Sub LogUpdateActionNew(table_p,id_l,history)
	history =  replace(history,"'","''")
	'response.write("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
	set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
	
	

	
	if not r_l.eof then
	
		ves = r_l("vesture")
		'rw ves
		if (not isnull(ves) ) then
 
			ves =  replace(ves,"'","''")
		end if
		if isnull(ves) then
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Laboja. "+TimePrint(now)+"<br>"+history+"' WHERE id = " + cstr(id_l))
		else
			'rw history
			'rw "UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - laboja || "+TimePrint(now)+"<br>"+cstr(history)+"' WHERE id = " + cstr(id_l)
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - laboja || "+TimePrint(now)+"<br>"+cstr(history)+"' WHERE id = " + cstr(id_l))
		end if
	end if
End Sub
'
'atgrieþ detalizçtu vçsturi
Function GetUpdateActionDetails(old_dict,new_dict,table_p,id_l)
	'salîdzina, kuri lauki ir mainîjuðies

	
	history = ""

	Dim key 
   
    For Each key In old_dict.Keys
		field_name = key
		field_value = old_dict(key)
		
		'rw "<br>"
		'rw "<b>"+field_name+": </b>"
		'rw field_value
		'rw "<br>"
		if (field_name <> "vesture" and field_name <> "vards2" and field_name <> "adrese2" and field_name <> "pilseta2" and field_name <> "uzvards2" and field_name <> "nosaukums2" and field_name <> "info" and field_name <> "kvietas_cena" and field_name <> "kvietas_cenaEUR" and field_name <> "vietas_cenaEUR" and field_name <> "summa" and field_name <> "cena" and not(table_p="pieteikums" and field_name = "persona") and field_name<>"papildv" and field_name<> "bilanceEUR" and field_name <> "bilance" and field_name <> "vieta_rezerveta_lidz") then
			
			old_val = nullprint(old_dict(field_name))
			new_val = nullprint(new_dict(field_name))
			'rw "vecâ vçrtîba:"
			'	rw UCase((old_val))
				'rw "<< <br>Jaunâ vçrtîba:"
				'rw UCase((new_val))
				'rw "<< <br>"
				
			if (not ((old_val="" and new_val="0") or( old_val="" and new_val="") or (old_val="0" and new_val="")) and not (field_name="viesnicas_veids" and (old_val="" or new_val=""))) then ' and dateprint(new_val)<> "01.01.1900") then
				
				if UCase((old_val)) <> UCase((new_val)) then
					'rw "!!nesakrît"	
					

					old_val = GetValStr(field_name,old_val)
					new_val = GetValStr(field_name,new_val)
					
					
					if (table_p="grupa") then
						if (field_name = "izbr_vieta" or field_name = "iebr_vieta" ) then
							'meklç izbraukðanas/iebraukðanas vietas tekstuâlo nosaukumu
							 old_val = GetNosaukumsID("grupa_izbr_vieta",old_val)						
							 new_val = GetNosaukumsID("grupa_izbr_vieta",new_val)							 
						end if
						if (field_name = "autobuss_id") then
							old_val = GetAutobussID(old_val)						
							 new_val = GetAutobussID(new_val)	
						end if
						if (field_name= "vaditajs" or field_name="vaditajs2")then
							old_val = GetVaditajsVardsUzv(old_val)
							new_val = GetVaditajsVardsUzv(new_val)
						end if
						if (field_name="kontrolieris" or field_name="kurators") then
							old_val = GetLietotajsVardsUzv(old_val)
							new_val = GetLietotajsVardsUzv(new_val)
						end if
						if (field_name = "izbr_laiks" or field_name = "iebr_laiks" or field_name = "sapulces_laiks_no" or field_name = "sapulces_laiks_lidz") then		
							old_val = GetTime(old_val)
							new_val = GetTime(new_val)
						end if
						if (field_name = "VEIDS") then
							old_val = GetGrVeidsID(old_val)
							new_val = GetGrVeidsID(new_val)
						end if
						if (field_name = "carter_viesn_id") then
							old_val =GetCarterViesnID(old_val)
							new_val =GetCarterViesnID(new_val)
						end if
						
					end if
					history = history + "** " + cstr(GetFieldTitle(field_name,table_p)) + " :: "+ old_val +" => " + new_val +"<br>" 
					'rw history
					'rw field_value
				end if				
			end if
		end if
		'rw "<br>"
    Next 
	
	GetUpdateActionDetails = history

End Function
'
'atgrieþ detalizçtu vçsturi
Function GetUpdateActionDetails_old2106(old_dict,new_dict,table_p,id_l)
	'salîdzina, kuri lauki ir mainîjuðies

	
	history = ""

	Dim key 
   
    For Each key In old_dict.Keys
		field_name = key
		field_value = old_dict(key)
		'rw field_value
		'rw "<b>"+field_name+"</b>"
		'rw "<br>"
		if (field_name <> "vesture" and field_name <> "vards2" and field_name <> "adrese2" and field_name <> "pilseta2" and field_name <> "uzvards2" and field_name <> "nosaukums2" and field_name <> "info" and field_name <> "kvietas_cena" and field_name <> "kvietas_cenaEUR" and field_name <> "vietas_cenaEUR" and field_name <> "summa" and field_name <> "cena" and not(table_p="pieteikums" and field_name = "persona") and field_name<>"papildv" and field_name<> "bilanceEUR" and field_name <> "bilance" and field_name <> "vieta_rezerveta_lidz") then
			
			old_val = nullprint(old_dict(field_name))
			new_val = nullprint(new_dict(field_name))
			
			if (not ((old_val="" and new_val="0") or( old_val="" and new_val="") or (old_val="0" and new_val="")) and not (field_name="viesnicas_veids" and (old_val="" or new_val=""))) then ' and dateprint(new_val)<> "01.01.1900") then
				'rw "vecâ vçrtîba:"
				'rw old_val
				'rw "<< <br>Jaunâ vçrtîba:"
				'rw new_val
				'rw "<< <br>"
				if UCase((old_val)) <> UCase((new_val)) then
					'rw "nesakrît"	
					

					old_val = GetValStr(field_name,old_val)
					new_val = GetValStr(field_name,new_val)
				
					history = history + "** " + cstr(GetFieldTitle(field_name,table_p)) + " :: "+ old_val +" => " + new_val +"<br>" 
					'rw history
					'rw field_value
				end if



			
				
			end if
			
			
		end if
		'rw "<br>"
    Next 

	
	'rw history
	'LogUpdateActionNew table_p,id_l,history
	'response.end
	GetUpdateActionDetails_old2106 = history

End Function
'
Sub UpdateActionDetails1(old_dict,new_dict,table_p,id_l,history)
	
	history = history + GetUpdateActionDetails1(old_dict,new_dict,table_p,id_l)
	rw GetUpdateActionDetails1(old_dict,new_dict,table_p,id_l)
	'rw "^^"
   
	rw history
	LogUpdateActionNew table_p,id_l,history
	'response.end

End Sub
'
Sub UpdateActionDetails(old_dict,new_dict,table_p,id_l,history)
	history = history + GetUpdateActionDetails(old_dict,new_dict,table_p,id_l)
   
	'rw history
	LogUpdateActionNew table_p,id_l,history
	'response.end

End Sub


'atgrieþ laukam nosaukumu lasâmâ formâ
Function GetValStr(field_name,val)
	GetValStr = val
	if (field_name="rajons" or field_name="novads") then
		GetValStr = GetNosaukumsID(field_name,val)
		
	end if
	if (field_name="agents") then
		GetValStr = GetAgentsID(val)
		
	end if
	if field_name = "gid" or field_name="old_gid" then
		if (val <> "") then GetValStr = grupas_nosaukums(val,NULL) end if
		
	end if
	if (field_name="vietas_veids") then
		GetValStr = GetNosaukumsID("vietu_veidi",val)
		
	end if
	if (field_name="kid") then
		GetValStr = GetKajiteID(val)
		
	end if
	if (field_name="kvietas_veids") then
		GetValStr = GetKajVeids(val)
		
	end if
	if (field_name="vid") then
		GetValStr = GetViesnicaID(val)
		
	end if
	if (val="True" or val="False") then
		GetValStr = BoolLV(val)
		
	end if
	' vietu veidu tipiem vçrttîbas saglabâjam tekstuâli					
	if field_name="tips" then
		GetValStr = GetNosaukumsKods("vietu_veidi_tipi",val)
	end if
		
end function

'atgrieþ piet_saites laukus, kuru izmai''nas ir jâglabâ vçsturç
Function GetPietSaiteEditFields()
 FieldsToSave = Array("vietsk","vietas_veids","vid","kid","kvietas_veids","summaEUR","summa")
 GetPietSaiteEditFields = FieldsToSave
End Function

'salîdzina piet_saites pieteikumam
Sub SavePietHistory(old_saites_arr,new_saites_arr,pid,old_vals,new_vals)
	history = ""
	Dim saites_id
    For Each saites_id In old_saites_arr.Keys
		'rw "<br>key:"
		'rw saites_id
		'rw "<br>"
		set old_piet_vals = old_saites_arr(saites_id)
		set new_piet_vals = new_saites_arr(saites_id)
		history = history + GetUpdateActionDetails(old_piet_vals,new_piet_vals,"piet_saite",pid)
		'UpdateActionDetails old_piet_vals,new_piet_vals,"pieteikums",pid,""
		new_saites_arr.Remove(saites_id)
	next
	set	new_saites_vals0  = Server.CreateObject("Scripting.Dictionary")
	set old_saites_vals0  = Server.CreateObject("Scripting.Dictionary")

	 FieldsToSave = GetPietSaiteEditFields()
	 'paskatâs, vai jaunajâ piet. saiðu masîvâ nav kâdas saites, kas nav vecajâ
	 For Each saites_id In new_saites_arr.Keys
		'rw "<br>jaunâ pieteikuma id:"
		history = history + "** Pievienots jauns pakalpojums :: =>"
		'pârkopçç vâsrtîbas, kuras jâglabâ
		'set old_piet_vals = old_saites_arr(saites_id)
		set new_piet_vals = new_saites_arr(saites_id)
		'rw "items"
		
		 For each item in FieldsToSave
			'rw item
			'rw ">>"
			'rw nullprint(new_piet_vals(item))
			'rw "<<<br>"
			if (nullprint(new_piet_vals(item)) <> "" and not(item="kvietas_veids" and nullprint(new_piet_vals(item))="0")) then
					history = history + GetFieldTitle(item,"piet_saite") + ": "+GetValStr(item,nullprint(new_piet_vals(item)))+ ", "
			
				'new_saites_vals0.add item,new_piet_vals(item)
				'old_saites_vals0.add item,""
			end if
		 Next
		
		
		 If Right(history, 2) = ", " Then 
			history = Left(history, Len(history) - 2) 
		  end if
		history = history + " <br>"
		'rw history		
		'rw saites_id
		'rw "<br>"
	 next
	 UpdateActionDetails old_vals,new_vals,"pieteikums",pid,history
	 'LogUpdateActionNew "pieteikums",pid,history
	 
End sub

'atlasa piet_saiti un saglabâ dictionary tipa objektâ
Function GetPietSaiteDict(id)
	qry = "SELECT * FROM piet_saite WHERE id="+Cstr(id)+" AND deleted=0"
	set GetPietSaiteDict = GetPSDict(qry)
End Function
'atlasa piet_saites un saglabâ dictionary tipa objektâ
Function GetPietSaitesDict(pid)
	
	qry = "SELECT * FROM piet_saite WHERE pid="+Cstr(pid)+" AND deleted=0"
	'rw query
	set GetPietSaitesDict = GetPSDict(qry)
	
end function

Function GetPSDict(qry)
	set new_saites = conn.execute(qry)
	set new_saites_arr = Server.CreateObject("Scripting.Dictionary")

	
	while not new_saites.eof
		'rw "<br>new_Siates id:"
		'rw new_saites("id")
		'rw "<-----<br>"
		new_saites_arr.add cstr(new_saites("id")),CreateDict("SELECT ps.*,vv.nosaukums as viesnicas_veids FROM piet_saite as ps LEFT JOIN viesnicas v  ON ps.vid=v.id LEFT JOIN viesnicas_veidi vv ON v.veids=vv.id WHERE ps.id="+Cstr(new_saites("id")))		
		new_saites.moveNext
	wend
	
	set GetPSDict = new_saites_arr
End function


'latvisko boolean tipa vçtîbas
Function BoolLV(val)
	if (val) then BoolLV = "ir" else BoolLV="nav" end if
end function
Function GetKajVeids(cip)
	'rw cip
	Dim Veidi(7)
	Veidi(0)=""
	Veidi(1) = "Standarta"
	Veidi(2) = "Bçrnu"
	Veidi(3) = "Brîva v.(3 pers)"
	Veidi(4) = "Senioru"
	Veidi(5) = "Pusaudþu"
	Veidi(6) = "Brîva v.(2 pers)"
	
	GetKajVeids = Veidi(Getnum(cip))
end function
'atgrieþ viesnîcu pçc ID#
Function GetViesnicaID(id)
	if (getnum(id)=0 or id="") then
		GetViesnicaID=""
	else
		GetViesnicaID = id
		
		set r = conn.execute("SELECT veids FROM viesnicas WHERE id="+cstr(id))
		if (not r.eof) then
			'rw r("veids")
		
			GetViesnicaID = GetNosaukumsID("viesnicas_veidi",r("veids")) ' +" istaba Nr."+ GetViesnicaID
		end if
	end if
end function

'atgrieþ kajîti pçc ID#
Function GetKajiteID(id)
	if (getnum(id)=0 or id="") then
		GetKajiteID=""
	else
		GeKajiteID = id
		
		set r = conn.execute("SELECT veids FROM kajite WHERE id="+cstr(id))
		if (not r.eof) then
			'rw r("veids")
		
			GetKajiteID = GetNosaukumsID("kajites_veidi",r("veids"))
		end if
	end if
end function

'atgrieþ aìentu pçc ID#
Function GetAgentsID(id)
	if (id=0) then
		GetAgentsID=""
	else
		GetAgentsID = id
		
		set r = conn.execute("SELECT vards,pilseta FROM agenti WHERE id="+cstr(id))
		if (not r.eof) then
			GetAgentsID = decode(r("pilseta"))+">"+decode(r("vards"))
		end if
	end if
end function

Function GetNosaukumsID(table,id)

	if (id="0" or id="") then
		GetNosaukumsID=""
	else

		GetNosaukumsID = id
		'rw "SELECT nosaukums FROM "+cstr(table)+" WHERE id="+cstr(id)
		set raj = conn.execute("SELECT nosaukums FROM "+cstr(table)+" WHERE id="+cstr(id))
		if (not raj.eof) then
			GetNosaukumsID = raj("nosaukums")
		end if
	end if
end function

Function GetNosaukumsKods(table,kods)
	if (kods="0" or kods="") then
		GetNosaukumsKods=""
	else

		GetNosaukumsKods = kods
		
		set r = conn.execute("SELECT nosaukums FROM "+cstr(table)+" WHERE kods='"+cstr(kods)+"'")
		if (not r.eof) then
			GetNosaukumsKods = r("nosaukums")
		end if
	end if
end function

Function GetFieldTitle(field,table)
	'vards,uzvards,pk1,pk2,paseS,paseNR,paseIZD,paseIZDdat,paseDERdat,nosaukums,reg,nmkods,vaditajs,kontaktieris,adrese,pilseta,indekss,
		'talrunisMvalsts,talrunisM,fax,talrunisDValsts,talrunisD,talrunisMobValsts,talrunisMob,eadr,eadr_paz,piezimes,fizjur,deleted,rajons,
		'novads,dzimta,aizsutits,jaunumi,aid,idS,idNR,idDerDat,internets,dzimsanas_datums
	title = field
	
	if (field = "vards") then
		title = "vârds"		
	end if
	if (field = "uzvards") then
		title = "uzvârds"		
	end if
	if (field = "pk1" or field = "pk2" ) then
		title = "personas kods"		
	end if
	if (field = "paseS") then
		title = "pases sçrija"		
	end if
	if (field = "paseNR") then
		title = "pases numurs"		
	end if
	if (field = "paseIZD") then
		title = "pases izdevçjs"		
	end if
	if (field = "paseDERdat") then
		title = "pases derîguma termiòð"		
	end if
	if (field = "reg") then
		title = "reì. nr."		
	end if
	if (field = "nmkods") then
		title = "nod. maks. kods"		
	end if
	if (field = "vaditajs") then
		title = "vadîtâjs"		
	end if
	if (field = "kontaktieris") then
		title = "kontaktp."		
	end if
	if (field = "pilseta") then
		title = "pilsçta/pagasts"		
	end if
	if (field = "talrunisMvalsts") then
		title = "mâjas tâlr. valsts kods"		
	end if
	if (field = "talrunisDvalsts") then
		title = "darba tâlr. valsts kods"		
	end if
	if (field = "talrunisMobvalsts") then
		title = "mob. tâlr. valsts kods"		
	end if
	if (field = "talrunisM") then
		title = "mâjas tâlr."		
	end if
	if (field = "talrunisD") then
		title = "darba tâlr."		
	end if
	if (field = "talrunisMob") then
		title = "mob. tâlr."		
	end if
	if (field = "fax") then
		title = "fakss"		
	end if
	if (field = "eadr") then
		title = "e-adrese"		
	end if
	if (field = "piezimes") then
		title = "piezîmes"		
	end if
	if (field = "fizjur") then
		title = "juridiska persona"		
	end if
	if (field = "dzimta") then
		title = "dzimums"		
	end if
	if (field = "idS") then
		title = "ID kartes sçrija"		
	end if
	if (field = "idNR") then
		title = "ID kartes numurs"		
	end if
	if (field = "idDerDat") then
		title = "ID kartes derîguma termiòð"		
	end if
	if (field = "dzimsanas_datums") then
		title = "dzimðanas datums"		
	end if
	if (field = "agents") then
		title = "aìents"		
	end if
	if (field = "gid") then
		title = "grupa"		
	end if
	if (field = "old_gid") then
		title = "iepriekðçjâ grupa"		
	end if
	if (field = "dat_atcelts") then
		title = "atteikuma datums"		
	end if
	if (field = "vieta_rezerveta_lidz") then
		title = "vieta rezervçta lîdz"		
	end if
	if (field = "vietas_veids") then
		title = "vietas veids"		
	end if
	if (field = "kid") then
		title = "kajîte"		
	end if
	if (field = "kvietas_veids") then
		title = "kajîtes veids"		
	end if
	if (field = "summaEUR") then
	
		title = "summa EUR"	
		if (table="piet_saite") then
			title = "pakalpojuma "+title 
		else 
			if table="pieteikums" then title= "pieteikuma "+title end if
		end if
	end if
	if (field = "summa") then
		title = "summa valûtâ"
		if (table="piet_saite") then
			title = "pakalpojuma "+title 
		else 
			if table="pieteikums" then title= "pieteikuma "+title end if
		end if		
	end if
	if (field = "vietsk") then
		title = "vietu skaits"		
	end if
	if (field = "vid") then
		title = "viesnîcas numurs"		
	end if
	if (field = "viesnicas_veids") then
		title = "viesnîcas numura veids"		
	end if
	if (field = "bilanceEUR") then
		title = "bilance EUR"		
	end if
	if (field = "tmp") then
		title = "apstiprinâta rezervâcija"		
	end if
	if (field = "ligums_id") then
		title = "lîguma ID#"		
	end if
	if (field = "carter_voucer") then
		title = "vouèeris izdrukâts"		
	end if
	if (field="carter_viesn_id") then
		title = "èartera viesnîca"
	end if
	if (field="carter") then
		title = "èarteris"
	end if
	if (field="vaditajs2") then
		title = "2.vadîtâjs"
	end if
	if (field="sakuma_dat") then
		title = "sâkuma datums"
	end if
	if (field="beigu_dat") then
		title = "beigu datums"
	end if
	if (field="vietsk" and table="grupa") then
		title = "vietas autobusâ"
	end if
	if (field="vietsk_nakts") then
		title = "vietas naktsmîtnçs"
	end if
	if (field="avio_vietas") then
		title = "avio vietas"
	end if
	if (field="i_cena_eur") then
		title = "cena EUR"
	end if
	if (field="autobuss_id") then
		title = "autobuss"
	end if
	GetFieldTitle = title
End Function


Sub LogDeleteAction(table_p,id_l)

set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
ves = r_l("vesture")
if isnull(ves) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Izdzçsa. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " +  table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - Izdzçsa. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogInsertAction(table_p,id_l)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
ves = r_l("vesture")
if isnull(ves) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Izveidoja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - Izveidoja. "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogAction(table_p,id_l,action_p)
	if (id_l <> "") then
		set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
		ves = r_l("vesture")
		if isnull(ves) then
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - "+action_p+". "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
		else
			conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+sqltext(nullprint(ves))+Get_User+" - "+action_p+". "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
		end if
	end if
End Sub

Sub LogActionNew(table_p,id_l,action_p)
if (id_l <> "") then
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
ves = r_l("vesture")
if (not isnull(ves) ) then
 
	ves =  replace(ves,"'","''")
end if

if isnull(ves) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - "+action_p+" || "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+nullprint(ves)+Get_User+" - "+action_p+" || "+TimePrint(now)+"<br>' WHERE id = " + cstr(id_l))
end if
end if
End Sub

function Get_User()
if Session("user_name") <> "" then 
	Get_User = Session("user_name")
	exit function
end if

Get_User = request.ServerVariables("LOGON_USER")
for i = 1 to len(Get_User)
	if mid(Get_User,i,1) = "\" then
		Get_User = mid(Get_User,i+1,len(Get_User)-i)
		exit function
	end if
next
if get_user = "" then get_user = "unknown"
end function

function Get_Colleague()
 set r_liet = conn.execute("select IsNull(K.Lietotajs,'') as kolegis from lietotaji L left outer join lietotaji K on L.kolegis = K.id where LOWER(L.lietotajs) = LOWER('" & Get_User & "')")
 If r_liet("kolegis") <> "" then
  Get_Colleague = r_liet("kolegis")
 else
  Get_Colleague = "unknown"
 end if
end function

function Piet_nVal(pid)
gid = id_field("pieteikums",pid,"gid")
marid = id_field("grupa",gid,"mid")
if id_field("marsruts",marid,"USD") = -1 then Piet_nVal = "USD" else Piet_nVal = "Ls"
end function

function Grupa_nVal(gid)
marid = id_field("grupa",gid,"mid")
if id_field("marsruts",marid,"USD") = -1 then Grupa_nVal = "USD" else Grupa_nVal = "Ls"
end function


function USDKurss()
   Set rKurss_l = Conn.Execute("select kurss2 from valutakurss where valuta = 68 and datums = '" + SQLDate(now) + "'")
   If Not rKurss_l.EOF Then
    USDKurss = round100(valatlaideUSD / rKurss_l("kurss2"))
   Else
    USDKurss = 0
   End If
end function

function piet_atlaide_del(aid)'no atlaiþu tabulas izmet konkrçto atlaidi
	conn.execute "update piet_atlaides set dzesa_kas='"+get_user+"', dzesa_dat=GETDATE() WHERE id="+cstr(aid)
    conn.execute "Delete from piet_atlaides where id="+cstr(aid)
end function

'atlaižu tabulai pievieno jaunu atlaidi
function piet_atlaide_add(valpid, valuta, valsumma, valprocents, valatlaide, strpiezimes,veids)
 uzcenojums = conn.execute("select piemaksa from piet_atlaides_veidi where id = "+cstr(veids))(0)
 valsumma=round100(valsumma)
 valprocents=round100(valprocents)
 if valuta = "LVL" then
   valatlaideLVL=round100(valatlaide)
   valatlaideEUR="0"
   valatlaideUSD="0"
   valatlaide="0"
   valatlaideBIL=valatlaideLVL
 elseif valuta = "USD" then
   valatlaideLVL="0"
   valatlaideEUR="0"
   valatlaideUSD=round100(valatlaide)
   valatlaide="0"
   Set rKurss_l = Conn.Execute("select kurss2 from valutakurss where valuta = 68 and datums = '" + SQLDate(now) + "'")
   If Not rKurss_l.EOF Then
    valatlaideBIL = round100(valatlaideUSD / rKurss_l("kurss2"))
   Else
    session("message") = "Nav USD kursa. Atlaide nav pievienota."
    exit function
   End If
 elseif valuta = "EUR" then
   valatlaideLVL="0"
   valatlaideUSD="0"
   valatlaideEUR=round100(valatlaide)
   valatlaide="0"
   valatlaideBIL = valatlaideEUR
 else
   valatlaideLVL="0"
   valatlaideUSD="0"
   valatlaideEUR="0"
   valatlaide=round100(valatlaide)
 end if
 if strpiezimes="" then strpiezimes=" "
 if uzcenojums then 
  uzcenojums = "1"
 else
  uzcenojums = "0"
 end if
 conn.execute "INSERT into piet_atlaides (pid,datums,summa,procents,atlaide,atlaideLVL,atlaideUSD,atlaideEUR,atlaideBIL,piezimes,kas,uzcenojums,veids,pievienoja_dat) values ("+cstr(valpid)+",'"+SQLDate(now)+"',"+cstr(valsumma)+","+cstr( valprocents)+","+cstr(valatlaide)+","+cstr(valatlaideLVL)+","+cstr(valatlaideUSD)+","+cstr(valatlaideEUR)+","+cstr(valatlaideBIL)+",'"+ strpiezimes+"','"+get_user+"',"+uzcenojums+","+veids+", GETDATE());"
end function	

'-----------------------
'Atgrieþ, vai tekoðais jûzeris ir pilnvarots, òemot vçrâ usera tiesîbas (string*10)
'Ja tâda usera nav tad tas tiek piereìistrçts ar funkciju GetCurUserID
'----------------------
function IsAccess(tiesibas)
	' skatamies vispirms sesijaa
	''if session("tiesibas_"+cstr(tiesibas)) = "true" then
	''	IsAccess = true
	''	exit function
	''end if
	''if session("tiesibas_"+cstr(tiesibas)) = "false" then
	''	IsAccess = false
	''	exit function
	''end if
	
	set rAccess = conn.execute ("SELECT * FROM TiesibuSaites WHERE LietotajsID = " + cstr(GetCurUserID) + " AND TiesibasID = " + cstr(tiesibas))
	if not rAccess.eof then
		isAccess=true
		session("tiesibas_"+cstr(tiesibas)) = "true"
	else
		isAccess=false
		session("tiesibas_"+cstr(tiesibas)) = "false"
	end if
end function


'-----------------------
'Atgrieþ, vai tekoðais jûzeris ir pilnvarots, òemot vçrâ usera vârdu (string*20) un tiesîbas (string*10)
'Ja tâda usera nav tad atgrieþ false
'----------------------
function IsUserAccess(lietotajs,tiesibas)
	set rAccess = conn.execute ("SELECT * FROM TiesibuSaites WHERE LietotajsID = " + cstr(lietotajs) + " AND TiesibasID = " + cstr(tiesibas))
	if not rAccess.eof then
		isUserAccess=true
	else
		isUserAccess=false
	end if
end function

'-----------------------------------------------------
'20.12.2019 RT
'Pârbauda, vai lietotâjam nav nobloíçta pieeja Globai
'------------------------------------------------------
sub CheckGlobaAccess
	set rAccess = conn.execute ("SELECT isnull(bloket_globu,0) as bloket_globu FROM lietotaji WHERE id = " + cstr(GetCurUserID) )
	if not rAccess.eof then
	
		if rAccess(0) then 
		   rw "<center><font color='red'><b>Pieeja Globai ir aizliegta</b></font>"
			response.end 
	    end if

	end if
end sub

'------------------------------
'GetUserId - atgrieþ jûzera Id pçc vârda (str*20)
'-----------------------------
function GetUserId(vards)
if vards = "unknown" THEN
	response.write "unknown"
	response.end
end if


	if vards="" then
		GetUserId=0
		exit function
	end if
	set rUname=conn.execute ("SELECT lietotaji.id from Lietotaji where UPPER(Lietotajs)='"+cstr(ucase(vards))+"';")
	if rUname.eof then
 		dim ID
		ID = AddUser(vards,"unknown")
		GetUserId=ID
	else
		'rUname.movefirst
		GetUserId=rUname("id")
	end if
end function

'------------------------------
'ReturnUserId - atgrieþ jûzera Id pçc vârda (str*20)
'-----------------------------
function ReturnUserId(vards)
	if vards="" then
		Return=0
		exit function
	end if
	set rUname=conn.execute ("SELECT lietotaji.id from Lietotaji where UPPER(Lietotajs)='"+cstr(ucase(vards))+"';")
	if rUname.eof then
		ReturnUserId = 0
	else
		'rUname.movefirst
		ReturnUserID=rUname("id")
	end if
end function


'------------------------------
'IsUser - atgrieþ true ja Lietotâjs eksistç
'-----------------------------
function IsUser(vards)
	if vards="" then
		IsUser=false
		exit function
	end if
	set rUname=conn.execute ("SELECT lietotaji.id from Lietotaji where UPPER(Lietotajs)='"+cstr((vards))+"';")
	if rUname.eof then
		IsUser = False
	else
		IsUser = True
	end if
end function

'------------------------------
'GetCurUserId - atgrieþ tejkoðâ jûzera Id
'-----------------------------
function GetCurUserID()
	''If Get_User() = Session("CurUser") and not isnull(Session("CurUserID")) then
	''	GetCurUserID = Session("CurUserID")
	''else
		Session("CurUser")   =  Get_User()
		
		Session("CurUserID") =  GetUserID(Get_User())
		GetCurUserID = Session("CurUserID")
	''end if
end function

'------------------------------
'GetCurAID - atgrieþ tejkoðâ Aìenta Id
'-----------------------------
function GetCurAID()
 lid = GetCurUserID
 set r_p = conn.execute("select aid from lietotaji where id = "+cstr(lid))
 if not r_p.eof then
  GetCurAID = getnum(r_p("aid"))
 else
  GetCurAID = 0
 end if
end function

'----------------------------
'DeleteUser(id)-izmet jûzeri no lietotâju tabulas
'un attiecîgos Id no TiesibuSaites tabulas
'----------------------------
Sub DeleteUser(id)
	qstrDelete="DELETE from Lietotaji WHERE id="+id+";"
	conn.execute qstrDelete
	qstrDelSaiti="DELETE from TiesibuSaites WHERE LietotajsId="+id+";"
	conn.execute qstrDelSaiti
end sub

'-----------------------------
'UpdateUser - saglabâ izmaiòas par lietotâju pçc ID
'----------------------------
sub UpdateUser(id, vards, info)
	vards=trim(vards)
	if len(vards)=0 then exit sub
	if len(vards)>20 then vards=left(vards,20)'ja vârds pârâk garð, tad saîsina
	info=trim(info)
	if len(info)=0 then info=" "
	qstrUpdate="UPDATE lietotaji SET lietotajs='"+vards+"', info='"+info+"' WHERE id="+id+";"
end sub

'------------------------
'GrantAccess -TiesibuSaites tabulâ ieliek jaunu rindiòu ar lietotâja kodu un tiesîbu kodu
'------------------------
function GrantAccess(UserID, TiesibasID)
	qstrGrantAccess="INSERT into TiesibuSaites (LietotajsID,TiesibasID) VALUES ("+cstr(UserId)+","+cstr(TiesibasID)+");"
	conn.execute qstrGrantAccess
end function

'--------------------------
'DenyAccess - izmet rindiòas ar userid un tiesîbâm no TiesibuSaites tabulas
'--------------------------
function DenyAccess(UserId, TiesibasId)
	qstrDenyAccess="DELETE from TiesibuSaites WHERE LietotajsId="+cstr(UserId)+" AND TiesibasID="+cstr(TiesibasId)+";"
	conn.execute qstrDenyAccess
end function

'----------------------------
'GetComplexGroup-atgrieþ kompleksâs grupas ID
'----------------------------
function GetComplexGroup
	set rstparameter=server.createobject("adodb.recordset")
	rstparameter.open "select *from parametri;",conn,3,3
	GetComplexGroup=rstparameter("kompleks")
end function

'----------------------------
'GetParameter-atgrieþ kompleksâs grupas ID
'----------------------------
function GetParameter(s)
	set rstparameter=server.createobject("adodb.recordset")
	rstparameter.open "select *from parametri;",conn,3,3
	GetParameter=rstparameter(s)
end function


'----------------------------
'GetLostMoneyGroup-atgrieþ zaudçtâs naudas grupas ID
'----------------------------
function GetLostMoneyGroup
	set rstparameter=server.createobject("adodb.recordset")
	rstparameter.open "select * from parametri;",conn,3,3
	GetLostMoneyGroup=rstparameter("lostmoney")
end function


'----------------------------
'WriteLog - pievieno ierakstu LietotajiLog tabulâ par tekoðo Useri, norâdîto tabulu ierakstu un darbîbu
'----------------------------
Sub WriteLog(Tabula,Ieraksts,Darbiba)
	Conn.Execute "INSERT INTO LietotajuLog (Tabula,Ieraksts,Lietotajs,Darbiba) VALUES " + _
		"("+Cstr(Tabula)+","+Cstr(Ieraksts)+","+Cstr(GetCurUserID)+",'"+Darbiba+"')"
end Sub


'--------------------------------------
'headlinks
'--------------------------------------
sub headlinks()

%>
<center><font size=2 face=Arial>
 <nobr>[ <a href="default.asp">Mâjas</a> ]</nobr>
 <nobr>[ <a href="dalibn.asp">Dalîbnieki</a> ]</nobr>  
 <nobr>[ <a href="grupas2.asp">Labot grupas</a> ]</nobr> 
 <nobr>[ <a href="out_grupa.asp">Ceïojumu Grupas</a> ]</nobr> 
<% if IsAccess(T_GRUPU_PAPILD_INFO) then %>
 <nobr>[ <a href="out_grupa2.asp">Grupu info</a> ]</nobr>
<% end if %>
 <nobr>[ <a href="terms.asp">Iemaksu termiòi</a> ]</nobr> 
 <nobr>[ <a href="kavetaji_param.asp">Kavçtâju saraksts</a> ]</nobr> 
<% if not isaccess(T_DROSIBA) then %>
 <nobr>[ <a href="ord_list.asp">Operâciju pârskats</a> ]</nobr> 
<% end if %>
 <nobr>[ <a href="valuta.asp">Valûtas kursi</a> ]</nobr> 
<% if not isaccess(T_DROSIBA) then %>
 <nobr>[ <a href="agenti.asp">Aìenti</a> ]</nobr> 
<% end if %>
 <nobr>[ <a href="agenti_stat.asp">Aìentu statistika</a> ]</nobr> 
 <nobr>[ <a href="piet_meklesana.asp">Pieteikumu pârskats</a> ]</nobr> 
 <nobr>[ <a href="grafiks_sais.asp">Darba grafiks</a> ]</nobr>
 <% if false then %>
  <nobr>[ <a href="balle.asp">Balles biïetes</a> ]</nobr>  
 <% end if %>
</font></center>
<%
end sub

sub viesnicas_combo(select_name_p,gid_p,viesnica_id_p)
 set rViesn = conn.execute ("Select Viesnicas.*, viesnicas_VEIDI.NOSAUKUMS from viesnicas INNER JOIN viesnicas_VEIDI ON viesnicas.VEIDS = viesnicas_VEIDI.ID where viesnicas.gid = " + cstr(gid_p) + " order by viesnicas_VEIDI.NOSAUKUMS,viesnicas.id")
 set rViesnD = conn.execute ("select vv.nosaukums,did,vards,uzvards,d.nosaukums,vv.vietas,vid from piet_saite ps,viesnicas_veidi vv,dalibn d, viesnicas v where vid in (select id from viesnicas where gid = "+cstr(gid_p)+") and ps.deleted = 0 and veids = vv.id and did=d.id and ps.vid=v.id order by vv.nosaukums,v.id")

		response.write ("<select name = '"+select_name_p+"' size = 1>")
		'ja ðai piet_saitei nav kajîtes tad selektç pirmo rindiòu
		if getnum(viesnica_id_p) = 0 then 
		 response.write "<option selected value = '00'>Nav</option>"
		else
	 	response.write "<option value = '00'>Nav</option>"
		end if
		while not rViesn.eof
			response.write "<option value = " + cstr(rViesn("id")) + " "
			if rViesn("id") = viesnica_id_p  then 
				response.write " selected "
			end if
			'viesnicas numura aizpildijuma info
			viesn_aizp = ""
			viesn_aizp_sk = 0
			if not rViesnD.eof then
			 while getnum(rViesnD("vid"))=rViesn("id")
			  viesn_aizp_sk = viesn_aizp_sk + 1
			  if viesn_aizp <> "" then viesn_aizp = viesn_aizp + ","
			  viesn_aizp = viesn_aizp + rViesnD("uzvards")
			  rViesnD.MoveNext
			 wend
			 viesn_aizp = cstr(viesn_aizp_sk)+")" + viesn_aizp
			else
			 viesn_aizp = "0)"
			end if
			response.write ">"+rViesn("NOSAUKUMS")+"(" + cstr(rViesn("vietas")) + "," + viesn_aizp + "</option>"
			rViesn.movenext
		wend
		response.write ("</select>")
end Sub

Function FieldList(table)
	Set rfl = conn.execute("SELECT syscolumns.name FROM syscolumns inner join sysobjects on syscolumns.id = sysobjects.id where sysobjects.name = '"+table+"'")
	output = ""
	While Not rfl.eof
		If rfl("name")<>"id" Then
			If output <> "" Then output = output + ","
			output = output + rfl("name")
		End if
		rfl.movenext
	Wend
	FieldList = output
End function

'atjauno viesnîcas veida laukus - automâtiski izrçíina bçrnu,pieauguso un pieejams_online laukus
sub RefreshViesnVeids(id)
	UpdateViesnVeidaVietas(id)
	UpdateViesnVeidsPieejamsOnline(id)
end sub

'atjauno viesnîcas veida bçrnu un pieauguðo vietu skaitu, balsoties uz kopejo vietu skaitu un nosaukumu;
sub UpdateViesnVeidaVietas(id)
	set viesn_veidi = conn.execute("SELECT * from viesnicas_veidi WHERE id="+cstr(id)+"")
   if not viesn_veidi.eof then
		nosaukums = viesn_veidi("nosaukums")
		vietas = viesn_veidi("vietas")
		p_v = viesn_veidi("pieaug_vietas")
		b_v = viesn_veidi("bernu_vietas")
		if (p_v = 0 and b_v = 0) then
			
			b_v = GetBernuVietasFromNos(nosaukums)
			
			if (b_v <> 0 ) then	
				p_v = vietas - b_v
			else 
				p_v = vietas
			end if 
			if p_v < 0 then p_v = 0	
			
		else 
			if (p_v <> 0 and b_v = 0) then
				b_v = vietas - p_v
			end if
			
		end if 
		
		conn.execute("UPDATE viesnicas_veidi SET pieaug_vietas=" + cstr(p_v)+",bernu_vietas=" + cstr(b_v)+" WHERE id = " + cstr(id))
		
	end if
	
end sub

'atjauno viesnîcas veida pieejamîbu online, balstoties uz tâ nosaukumu
sub UpdateViesnVeidsPieejamsOnline(id)
	set viesn_veidi = conn.execute("SELECT * from viesnicas_veidi WHERE id="+cstr(id)+"")
   if not viesn_veidi.eof then
		nosaukums = viesn_veidi("nosaukums")
		pieejams_online = ViesnVeidsPieejamsOnline(nosaukums)
		conn.execute("UPDATE viesnicas_veidi SET pieejams_online=" + cstr(pieejams_online)+" WHERE id = " + cstr(id))			 
	end if
end sub



'pârbauda, vai viesnîcas veidu drîkst pârdot online, atgrieþ 1 vai 0
function ViesnVeidsPieejamsOnline(nosaukums)
	vNos = UCase(Trim(nosaukums))

	ViesnVeidsPieejamsOnline = 0
	set rV = conn.execute("SELECT * FROM viesnicas_veidi_online")
	while not rV.eof
		if (vNos = rv("nosaukums")) then
	
			ViesnVeidsPieejamsOnline = 1
		else
			if instr(vNos ,"+")<>0 then
				bstr = Split(vNos ,"+") 
				if UBound(bstr) = 1 then		   
					nos = getnum(bstr(0))
					b_vietas = getnum(bstr(1)) 
					
					if (nos = rv("nosaukums") and b_vietas > 0) then
						ViesnVeidsPieejamsOnline = 1	
					end if
				end if		  
			end if
		end if
		rV.movenext
	wend
	

End function

'atgrieþ bçrnu vietu skaitu viesnîcas veidam pçc tâ nosaukuma (piem.: TWIN+1 => 1)
function GetBernuVietasFromNos(nosaukums)
 GetBernuVietasFromNos = 0
 if instr(nosaukums,"+")<>0 then
   bstr = Split(nosaukums,"+") 
   if UBound(bstr) = 1 then
	bernu_vietas = getnum(bstr(1)) 
   end if

  GetBernuVietasFromNos =  bernu_vietas
  end if
end function

'atgrieþ lietotâja vârdu un uzvârdu
function GetLietotajsVardsUzv(id)
	GetLietotajsVardsUzv = ""
	qry = "SELECT vards+' '+uzvards FROM lietotaji WHERE id="+cstr(id)
	set rLiet = conn.execute(qry)
	if not rLiet.eof then
		GetLietotajsVardsUzv = rLiet(0)
	 end if
end function

'atgrieþ grupu vadîtâja vârdu un uzvârdu
function GetVaditajsVardsUzv(id)
	GetVaditajsVardsUzv = ""
	qry = "SELECT vards+' '+uzvards FROM grupu_vaditaji WHERE idnum="+cstr(id)
	set rLiet = conn.execute(qry)
	if not rLiet.eof then
		GetVaditajsVardsUzv = rLiet(0)
	end if
end function

'atgrieþ autobusa nosaukumu
function GetAutobussID(id)				
	new_val = GetNosaukumsID("Autobusi",id)
	new_val = decode(new_val)
	GetAutobussID = new_val							 
end function

'atgrieþ grupas veida nosaukumu
function GetGrVeidsID(id)
	GetGrVeidsID = ""
	qry = "SELECT vards FROM grveidi WHERE id="+cstr(id)
	set rLiet = conn.execute(qry)
	if not rLiet.eof then
		GetGrVeidsID = rLiet(0)
	end if
end function

'atgrieþ èarter viesnîcas nosaukumu
function GetCarterViesnID(id)
	GetCarterViesnID = ""
	qry = "SELECT '['+valsts+'] '+nosaukums FROM carter_viesnicas WHERE id="+cstr(id)
	set r = conn.execute(qry)
	if not r.eof then
		GetCarterViesnID = r(0)
	end if
end function

%>
