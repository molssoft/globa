<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn

'saglabâ postçtos datus sesijâ
For Each Item In Request.Form
    fieldName = Item
    fieldValue = Request.Form(Item)
    session("gs_"+fieldName) = fieldValue
	
Next


id=Request.Form("grupa_id")
qry_for_logging = "SELECT * FROM GRUPA where id="+cstr(id)
set rGrupaOld = conn.execute(qry_for_logging)													  
kods=Request.Form("kods")
blocked = getnum(Request.Form("blocked"))
v=Request.Form("v")
veids=Request.Form("veids")
carter_viesn_id=Request.Form("carter_viesn_id")
lidojums_vietas=Request.Form("lidojums_vietas")
lidojums=Request.Form("lidojums")


drukat_vauceri = Request.Form("drukat_vauceri")
if drukat_vauceri = "on" then drukat_vauceri = "1" else drukat_vauceri = "0"
reiss_no=Request.Form("reiss_no")
reiss_uz=Request.Form("reiss_uz")

old=Request.Form("old")
standarta_viesnicas=Request.Form("standarta_viesnicas")
valsts=Request.Form("valsts")
izbr_laiks = Request.Form("izbr_laiks")
iebr_laiks = Request.Form("iebr_laiks")
izbr_vieta = Request.Form("izbr_vieta")
iebr_vieta = Request.Form("iebr_vieta")

sapulces_datums = Request.Form("sapulces_dat")
sapulces_laiks_no = Request.Form("sapulces_laiks_no")
sapulces_laiks_lidz = Request.Form("sapulces_laiks_lidz")

online = Request.Form("online")
if online = "on" then online = "1" else online = "0"

internets_no = Request.Form("internets_no")

nevajag_pases = Request.Form("nevajag_pases")
if nevajag_pases = "on" then nevajag_pases = "1" else nevajag_pases = "0"

pardot_agentiem = Request.Form("pardot_agentiem")
if pardot_agentiem = "on" then pardot_agentiem = "1" else pardot_agentiem = "0"

pardot_agentiem_no = Request.Form("pardot_agentiem_no")

eklase = Request.Form("eklase")
if eklase = "on" then eklase = "1" else eklase = "0"

carter = Request.Form("carter")
if carter = "on" then carter = "1" else carter = "0"

ielid_laiks_uz = Request.Form("ielid_laiks_uz")
ielid_laiks_no = Request.Form("ielid_laiks_no")

if ielid_laiks_uz="" then 
	ielid_laiks_fields = " ielid_laiks_uz = null," 
else 
	ielid_laiks_fields = " ielid_laiks_uz = '"+ielid_laiks_uz+"'," 
end if
if ielid_laiks_no="" then 
	ielid_laiks_fields = ielid_laiks_fields + " ielid_laiks_no = null," 
else
	ielid_laiks_fields = ielid_laiks_fields + " ielid_laiks_no = '"+ielid_laiks_no+"'," 
end if




'-- save kaveetaju mekleetaajs
'-- lauku var saglabaat ari juzeris bez grupas laboshanas tiesiibaam
'-- lai paardoshanas daljaa vinji pashi var sadaliit pienaakumus
'-- 17/10/2006 Nils
kontrolieris = Request.querystring("kontrolieris")
if getnum(kontrolieris)<>0 then
	conn.execute ("UPDATE grupa SET kontrolieris = " + cstr(kontrolieris) + " WHERE id = " + cstr(id))
	session("message") = "<font color=black>Izmaiòas saglabâtas.</font>"
	Response.Redirect "grupa_edit.asp?gid="+cstr(id)
end if
'----------------------------------------------------------------------

'--- sapulces datums un laiks
if sapulces_datums<>"" then 

	
	sp_dat = FormatedDate(sapulces_datums,"dmy")
	s_dat =FormatedDate(Request.Form("sakuma_dat"),"dmy")
	
		
	if CompareDates(sp_dat,s_dat) = 0 Then 
	



		Session("message") = "Sapulces datums "&cdate(sqlDate(sapulces_datums))&" ir vçlâks par ceïojuma sâkuma datumu "&cdate(sqlDate(Request.Form("sakuma_dat")))&"<br>"		
	
	
			
	end if

	if (sapulces_laiks_no<>"" and sapulces_laiks_lidz="" or sapulces_laiks_no="" and sapulces_laiks_lidz<>"" or sapulces_laiks_no="" and sapulces_laiks_lidz="") then Session("message") = Session("message") + "Jâievada sapulces sâkuma un beigu laiks<br>"

	if sapulces_laiks_no<>"" then if not isDate(sapulces_laiks_no) then Session("message") = Session("message") + "Sapulces sâkuma laiks ir ievadîts nepareizi (hh:mm)<br>"
	if sapulces_laiks_lidz<>"" then if not isDate(sapulces_laiks_lidz) then Session("message") = Session("message") + "Sapulces beigu laiks ir ievadîts nepareizi (hh:mm)<br>"	
	if sapulces_laiks_no<>"" and sapulces_laiks_lidz<>"" then if DateDiff("n",sapulces_laiks_no,sapulces_laiks_lidz) < 0 then Session("message") =  Session("message") + "Sapulces sâkuma laiks ir vçlâks par beigu laiku <br>"

	

	if Session("message")<>"" then
		Response.Redirect "grupa_edit.asp?gid="+cstr(id)
		response.end
	end if

	'--- parbauda vai neparklajas ar citam grupâm

	ssql =	"select * from grupa where atcelta = 0 and id <> "&cstr(id)&" and sapulces_dat = '"+sqldate(sapulces_datums)+"' " +_
			"and ( (isnull(sapulces_laiks_no,0) > '"+sapulces_laiks_no+"' and isnull(sapulces_laiks_no,0) < '"+sapulces_laiks_lidz+"') " +_
			"or (isnull(sapulces_laiks_lidz,0) > '"+sapulces_laiks_no+"' and isnull(sapulces_laiks_lidz,0) < '"+sapulces_laiks_lidz+"') " +_
			"or isnull(sapulces_laiks_no,0) = '"+sapulces_laiks_no+"' or isnull(sapulces_laiks_lidz,0) = '"+sapulces_laiks_lidz+"') " +_
			"and isnull(sapulces_laiks_dbl, 0) = 0"

	'Response.Write(ssql)
	' Response.End

	set r_grupa = conn.execute(ssql)

	if not r_grupa.eof then

		Session("message") = "Grupas sapulces datums un laiks pârklâjas ar citâm grupâm: <br>"
		while not r_grupa.eof

			Session("message") = Session("message") + r_grupa("kods") + "<br>"
			kodserror = true
			r_grupa.moveNext
		wend
		
		Response.Redirect "grupa_edit.asp?gid="+cstr(id)
		
	end if

else

	if not isDate(sapulces_laiks_no) then sapulces_laiks_no = ""
	if not isDate(sapulces_laiks_lidz) then sapulces_laiks_lidz = ""

end if




'----------------------------------------------------------------------


set rold = conn.execute("select * from grupa where id = "+cstr(id))
'-- Parbaudam sakuma un beigu datumus ( sakums<= beigu datums)
if Request.Form("sakuma_dat") <> "" and Request.Form("beigu_dat") <> "" Then
	if CompareDates(FormatedDate(Request.Form("sakuma_dat"),"dmy"),FormatedDate(Request.Form("beigu_dat"),"dmy")) = 0 Then
		Session("message") = "Beigu datumam jâbut lielâkam vai vienâdam ar sâkuma datumu."
		Response.Redirect "grupa_edit.asp?gid="+cstr(id)
		response.end
	End if
end if

if old = "on" then old = "1" else old = "0"
if standarta_viesnicas = "on" then standarta_viesnicas = "1" else standarta_viesnicas = "0"

atcelta=Request.Form("atcelta")

if atcelta = "on" then 
	atcelta = "1" 
	robots = "1"
else 
	atcelta = "0"
	robots = "0"
end if

if Request.Form("atteikumu_epasts") = "on" then
	att_epasts= "1"
else
	att_epasts= "0"
end if

'Response.Write(att_epasts)
'Response.End 

if Request.Form("sakuma_dat") <> "" then
 sakuma_dat = "'"+SQLTime(FormatedTime(Request.Form("sakuma_dat"),"dmyhns"))+"'"
else
 sakuma_dat = "NULL"
end if
if Request.Form("beigu_dat") <> "" then
 beigu_dat = "'"+SQLTime(FormatedTime(Request.Form("beigu_dat"),"dmyhns"))+"'"
else
 beigu_dat = "NULL"
end if
if Request.Form("sapulces_dat") <> "" then
 sapulces_dat = "'"+SQLTime(FormatedTime(Request.Form("sapulces_dat"),"dmyhns"))+"'"
else
 sapulces_dat = "NULL"
end if
if Request.Form("polijas_dat") <> "" then
 polijas_dat = "'"+SQLTime(FormatedTime(Request.Form("polijas_dat"),"dmyhns"))+"'"
else
 polijas_dat = "NULL"
end if
if Request.Form("vac_dat") <> "" then
 vac_dat = "'"+SQLTime(FormatedTime(Request.Form("vac_dat"),"dmyhns"))+"'"
else
 vac_dat = "NULL"
end If









if Request.Form("lidojums") <> "" then
 lidojums = "'"+SQLTime(FormatedTime(Request.Form("lidojums"),"dmyhns"))+"'"
else
 lidojums = "NULL"
end if



if Request.Form("term1_dat") <> "" then
 term1_dat = "'"+SQLTime(FormatedDate(Request.Form("term1_dat"),"dmy"))+"'"
else
 term1_dat = "NULL"
end if
if Request.Form("term2_dat") <> "" then
 term2_dat = "'"+SQLTime(FormatedDate(Request.Form("term2_dat"),"dmy"))+"'"
else
 term2_dat = "NULL"
end if
if Request.Form("term1_summa") <> "" then
 term1_summa = SQLTime(FormatedDate(Request.Form("term1_summa"),"dmy"))
else
 term1_summa = "NULL"
end if
if Request.Form("term2_summa") <> "" then
 term2_summa = SQLTime(FormatedDate(Request.Form("term2_summa"),"dmy"))
else
 term2_summa = "NULL"
end if
if Request.Form("term3_dat") <> "" then
 term3_dat = "'"+SQLTime(FormatedDate(Request.Form("term3_dat"),"dmy"))+"'"
else
 term3_dat = "NULL"
end if


'pardot_agentiem pazîme userim nav redzama
'ja 'no' datums nav ievadîts tad ceïojumu var pârdot
'ja 'no' datums ir pagâjis tad var pârdot
'ja 'no' nav pienâcis tad nevar pârdot
'tâpat katru stundu izpildâs procedûra kas pârbauda vai datums jau nav pienâcis
if Request.Form("pardot_agentiem_no") <> "" then
 pardot_agentiem_no = "'"+SQLTime(FormatedDate(Request.Form("pardot_agentiem_no"),"dmy"))+"'"
 if FormatedDate(Request.Form("pardot_agentiem_no"),"dmy")>now() then
	pardot_agentiem = "0"
 else
	pardot_agentiem = "1"
 end if
else
 pardot_agentiem_no = "NULL"
 pardot_agentiem = "1"
end if
'pardot_agentiem_no = "'"+SQLTime(FormatedDate("12.12.2016","dmy"))+"'"

if Request.Form("internets_no") <> "" then
 internets_no = "'"+SQLTime(FormatedDate(Request.Form("internets_no"),"dmy"))+"'"
else
 internets_no = "NULL"
  
end if
'internets_no = "'"+SQLTime(FormatedDate("12.12.2016","dmy"))+"'"

term1_zaud_summa = Request.Form("term1_zaud_summa")
term2_zaud_summa = Request.Form("term2_zaud_summa")
if term1_zaud_summa = "" then term1_zaud_summa = "NULL"
if term2_zaud_summa = "" then term2_zaud_summa = "NULL"

vietsk = getnum(Request.Form("vietsk"))
vietsk_nakts = getnum(Request.Form("vietsk_nakts"))
avio_vietas = getnum(Request.Form("avio_vietas"))
konts = Request.Form("konts")
konts_ava = Request.Form("konts_ava")
i_cena = getnum(Request.Form("i_cena"))
i_cena_usd = getnum(Request.Form("i_cena_usd"))
i_cena_eur = getnum(Request.Form("i_cena_eur"))
pm_cena = Request.Form("pm_cena")
if (pm_cena) = "" then pm_cena = "NULL" end if
ped_vietas_dzimums=Request.Form("ped_vietas_dzimums")
if ped_vietas_dzimums = "" then ped_vietas_dzimums = "NULL"
valuta=Request.Form("valuta")
vad=Request.Form("vad")
klients=Request.Form("klients")
if klients="" then klients="NULL"
if veids = "2" then
	 if klients <> "NULL" then
	  set rKlients = conn.execute("select IsNull(vards2,'') as vards2, IsNull(uzvards2,'') as uzvards2, IsNull(pk1,'') as pk1, IsNull(pk2,'') as pk2, IsNull(adrese2,'') as adrese2, IsNull(pilseta2,'') as pilseta2, IsNull(indekss,'') as indekss, IsNull(talrunisM,IsNull(talrunisD,IsNull(talrunisMob,''))) as talrunis from dalibn where id = " & klients)
	  if not rKlients.eof then
	   If rKlients("vards2") = "" or rKlients("uzvards2") = "" or rKlients("adrese2") = "" or rKlients("pilseta2") = "" or rKlients("indekss") = "" or rKlients("talrunis") = "" then
 	   session("message") = "Klientam dalîbnieka lapâ obligâti jâbût ievadîtiem vârdam, uzvârdam, adresei, pilsçtai, indeksam un vienam no tâlruòiem"
	   end if
	  end if
	 end if
	end if
	
vaditajs=Request.Form("vaditajs")
vaditajs2=Request.Form("vaditajs2")

kurators=Request.Form("kurators")
kontrolieris=Request.Form("kontrolieris")
if kontrolieris = "" then kontrolieris = "NULL"
starpnieks=Request.Form("starpnieks")
if starpnieks = "" then starpnieks = "NULL" 
autobuss=Request.Form("autobuss")
autobuss_id=Request.Form("autobuss_id")
autobusa_cena=getnum(Request.Form("autobusa_cena"))
kede=Request.Form("kede")
piezimes=Request.Form("piezimes")
dokumenti=Request.Form("dokumenti")
pazimes=Request.Form("pazimes")
term1_summa=Request.Form("term1_summa")
if term1_summa = "" then term1_summa = "NULL"
term2_summa=Request.Form("term2_summa")
if term2_summa = "" then term2_summa = "NULL"

'standarta viesnicas
if cstr(standarta_viesnicas) = "1" then
'--- viesniicu sadaliijums procentos
	proc_twin = 65
	proc_double = 50
	proc_single = 5

 'pârbaudam vai ir standarta viesnicas
 'TWIN
 set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'TWIN'")
 if r.eof then
  conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'TWIN','Divvietîgs atseviðía gulta',2)")
  'pievieno viesnicu nummurus
  set r = conn.execute("select id from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'TWIN'")
 end if
 
 nummuri = Int(Round(vietsk_nakts*proc_twin/100)/2)
 for viesn_counter = 1 to nummuri
	conn.execute("insert into viesnicas (gid,vietas,veids) values ("+cstr(id)+",2,"+cstr(r("id"))+")")
	'05.08.2019 RT  - logojam vesturi detalizetaku
	set rID = conn.execute("select max(id) from viesnicas where gid = " + cstr(id))
	LogInsertAction "viesnicas",rID(0)
	'---'
 next


'Response.End 
 
 'DOUBLE
 set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'DOUBLE'")
 if r.eof then
  r.close
  conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'DOUBLE','Divvietîgs kopîga gulta',2)")
  'pievieno viesnicu nummurus
  set r = conn.execute("select id from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'DOUBLE'")
end if

  nummuri = Int(Round(vietsk_nakts*proc_double/100)/2)
  for viesn_counter = 1 to nummuri
   conn.execute("insert into viesnicas (gid,vietas,veids) values ("+cstr(id)+",2,"+cstr(r("id"))+")")
   '05.08.2019 RT  - logojam vesturi detalizetaku
	set rID = conn.execute("select max(id) from viesnicas where gid = " + cstr(id))
	LogInsertAction "viesnicas",rID(0)
	'---'
  next
 
	'pârbauda, vai ir pievienota piemaksa par SINGLE, ja nav, tad neìenerç SINGLE numuriòus - 23.05.2018
	' ìenerç priekð èarteriem - Èarteriem single piemaksa neeksistç kâ tâda - 28.08.2018
	set r_single_pak = conn.execute("SELECT * FROM vietu_veidi WHERE gid = "+cstr(id)+" AND tips='V1'")
	'rw "SELECT * FROM vietu_veidi WHERE gid = "+cstr(id)+" AND tips='V1'"
	'response.end
	if not r_single_pak.eof or carter="1" then
	
		'SINGLE
		set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'SINGLE'")
		if r.eof then
			r.close
			conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'SINGLE','Vienvietîgs',1)")
			'pievieno viesnicu nummurus
			set r = conn.execute("select id from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'SINGLE'")
		end if
		nummuri = Int(Round(vietsk_nakts*proc_single/100))
		for viesn_counter = 1 to nummuri
			conn.execute("insert into viesnicas (gid,vietas,veids) values ("+cstr(id)+",1,"+cstr(r("id"))+")")
			'05.08.2019 RT  - logojam vesturi detalizetaku
			set rID = conn.execute("select max(id) from viesnicas where gid = " + cstr(id))
			LogInsertAction "viesnicas",rID(0)
			'---'
		next
		
	else 'tikai SINGLE veids bez numuriòiem (MB 26.06.2018.)
	
		set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'SINGLE'")
		if r.eof then
			r.close
			conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'SINGLE','Vienvietîgs',1)")
		end if
		
	end if
	
 'TRIPLE
 set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'TRIPLE'")
 if r.eof then
  r.close
  conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'TRIPLE','Trîsvietîgs',3)")
 end if
 
 '---------------- 
 'DOUBLE+1
 set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'DOUBLE+1'")
 if r.eof then
  r.close
  conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'DOUBLE+1','Divvietîgs kopîga gulta+1',3)")
 end if
 
 'TWIN+1
 set r = conn.execute("select * from viesnicas_veidi where gid = "+cstr(id)+" and nosaukums = 'TWIN+1'")
 if r.eof then
  r.close
  conn.execute("insert into viesnicas_veidi (gid,nosaukums,pilns_nosaukums,vietas) values ("+cstr(id)+",'TWIN+1','Divvietîgs atseviðía gulta+1',3)")
 end if
 
end if


'îpaðie lauki grâmatveþiem
vad_id = Request.Form("vad_id")
ln = Request.Form("ln")
'gïuka labojums
	if len(ln) > 1 then ln = mid(ln,1,1)
	if ln = "," then ln = ""
piezimes2 = Request.Form("piezimes2")


if session("message") = "" then
 if v="" then session("message") = "Marðruta nosaukums nevar bût tukðs."
end if

if veids="1" then
	if session("message") = "" then
	 if (izbr_laiks="" and izbr_vieta<>1)or(izbr_laiks<>"" and izbr_vieta<1) then session("message") = "Jâaizpilda obligâtie lauki: 'Izbraukðanas laiks un vieta'."
	end if
end if

if veids="1" then
	if session("message") = "" then
	 if (getnum(iebr_vieta)<1) then session("message") = "Jâaizpilda obligâtais lauks: 'Iebraukðanas vieta'."
	end if
end if

if session("message") = "" then
 if (carter="1" and carter_viesn_id="0") then session("message") = "Jâizvçlas èartera viesnîca."
end if

if session("message") = "" then
 if kods <> "" and Request.Form("beigu_dat") <> "" then
  y = year(FormatedDate(Request.Form("beigu_dat"),"dmyhns"))
  set r = conn.execute("select * from grupa where kods = '"+kods+"' and beigu_dat<='1/1/"+cstr(y+1)+"' and beigu_dat>='1/1/"+cstr(y)+"' and id<>"+cstr(id))
  
  if not r.eof then
   session("message") = "Grupa ar ðâdu kodu ðajâ gadâ jau eksistç."
  end if
 end if
end if



changes = ""
if cstr(getnum(rold("i_cena"))) <> cstr(i_cena) then
	changes = changes + "mainîta LVL kuratora cena; " 
end if
if cstr(getnum(rold("i_cena_usd"))) <> cstr(i_cena_usd) then
	changes = changes + "mainîta USD kuratora cena; "
end if


if "'"+SQLTime(FormatedTime(rold("sakuma_dat"),"dmyhns"))+"'" <> sakuma_dat then
	changes = changes + "mainîts sâkuma datums; "
end if
if "'"+SQLTime(FormatedTime(rold("beigu_dat"),"dmyhns"))+"'" <> beigu_dat then
	changes = changes + "mainîts beigu datums; "
end if
if cstr(getnum(rold("i_cena_eur"))) <> i_cena_eur then
	changes = changes + "mainîta cena; "
end if
if cstr(getnum(rold("vietsk"))) <> vietsk then
	changes = changes + "mainîts vietu skaits autobusâ; "
end if
if cstr(getnum(rold("vietsk_nakts"))) <> vietsk_nakts then
	changes = changes + "mainîts vietu skaits naktsmîtnçs; "
end if
if cstr(getnum(rold("avio_vietas"))) <> avio_vietas then
	changes = changes + "mainîts avio vietu skaits; "
end if
if nullprint((rold("piezimes"))) <> piezimes then
	changes = changes + "mainîtas piezîmes; "
end if
if nullprint((rold("dokumenti"))) <> dokumenti then 
	changes = changes + "mainîti dokumenti; "
end if

'if (changes <> "") then

	'LogAction "grupa",id,changes
														 
			  
								   
	
'else
									  
													 
	
	'logeditaction "grupa",id
'end if
'action_logged = true 

'--- paarbauda vai grupas vadiitaaji nav aiznjemti citaa celjojumaa tajaa pashaa laikaa. 17/Jan/2007 nils
if session("message") = "" and vaditajs<>"" and vaditajs<>"0" and sakuma_dat<>"NULL" and beigu_dat<>"NULL" then
	'session("message") = gidsIrAiznemts(vaditajs,kods,sakuma_dat,beigu_dat)
	if gidsIrAiznemts(vaditajs,kods,sakuma_dat,beigu_dat) = true then
		session("message") = "Grupas Vadîtâjs ir aizòemts citâ ceïojumâ. " + session("aiznemts_celojums")
	end if
end if
if session("message") = "" and vaditajs2<>"" and vaditajs2<>"0" and sakuma_dat<>"NULL" and beigu_dat<>"NULL" then
	if gidsIrAiznemts(vaditajs2,kods,sakuma_dat,beigu_dat) = true then
		session("message") = "Grupas Vadîtâjs 2 ir aizòemts citâ ceïojumâ." + session("aiznemts_celojums")
	end if
end if

session("error") = 1

if session("message") = "" then
 session("error") = 0


 conn.execute  "UPDATE grupa SET kods = '"+kods+"'," + _
	" blocked = "+cstr(blocked)+"," + _
	" konts = '"+konts+"'," + _
	" konts_ava = '"+konts_ava+"'," + _
	" veids = "+cstr(veids)+"," + _
	" i_cena = "+cstr(i_cena)+"," + _
	" i_cena_usd = "+cstr(i_cena_usd)+"," + _
	" i_cena_eur = "+cstr(i_cena_eur)+"," + _
	" pm_cena = "+cstr(pm_cena)+"," + _
	" atcelta = "+cstr(atcelta)+"," + _
	" robots = "+cstr(robots)+"," + _	
	" atteikumu_epasts = "+cstr(att_epasts)+"," + _
	" valuta = 'EUR'," + _
	" vad = '"+vad+"'," + _
	" autobuss = '"+autobuss+"'," + _
	" autobuss_id = "+autobuss_id+"," + _
	" autobusa_cena = "+cstr(autobusa_cena)+"," + _
	" kede = '"+kede+"'," + _
	" piezimes = '"+piezimes+"'," + _
	" dokumenti = '"+dokumenti+"'," + _
	" sakuma_dat = "+sakuma_dat+"," + _
	" beigu_dat="+beigu_dat+"," + _
	" izbr_laiks = '"+izbr_laiks+"'," + _
	" iebr_laiks= '"+iebr_laiks+"'," + _
	ielid_laiks_fields + _
	" izbr_vieta = "+izbr_vieta+"," + _
	" iebr_vieta= "+iebr_vieta+"," + _
	" sapulces_dat = "+sapulces_dat+"," + _
	" sapulces_laiks_no = '"+sapulces_laiks_no+"'," + _
	" sapulces_laiks_lidz = '"+sapulces_laiks_lidz+"'," + _	
	" polijas_dat = "+polijas_dat+"," + _
	" vac_dat = "+vac_dat+"," + _
	" lidojums = "+lidojums+"," + _
	" drukat_vauceri = "+drukat_vauceri+"," + _
	" reiss_no = '"+reiss_no+"'," + _
	" reiss_uz = '"+reiss_uz+"'," + _
	" term1_dat = "+term1_dat+"," + _
	" term2_dat = "+term2_dat+"," + _
	" term3_dat = "+term3_dat+"," + _
	" term1_summa = "+term1_summa+"," + _
	" term2_summa = "+term2_summa+"," + _
	" term1_zaud_summa = "+term1_zaud_summa+"," + _
	" term2_zaud_summa = "+term2_zaud_summa+"," + _	
	" vietsk="+cstr(vietsk)+"," + _
	" pasutitajs="+klients+"," + _
	" vaditajs="+cstr(vaditajs)+"," + _
	" vaditajs2="+cstr(vaditajs2)+"," + _
	" kurators="+cstr(kurators)+"," + _
	" kontrolieris="+cstr(kontrolieris)+"," + _
	" starpnieks="+cstr(starpnieks)+"," + _
	" vietsk_nakts="+cstr(vietsk_nakts)+ "," + _
	" avio_vietas="+cstr(avio_vietas)+ "," + _
	" pazimes='"+cstr(pazimes)+ "'," + _
	" internets= "+cstr(online)+ "," + _
	" internets_no = "+internets_no+ "," + _
	" nevajag_pases= "+cstr(nevajag_pases)+ "," + _
	" pardot_agentiem= "+cstr(pardot_agentiem)+ "," + _
	" pardot_agentiem_no = "+pardot_agentiem_no+ "," + _
	" eklase= "+cstr(eklase)+ "," + _
	" carter= "+cstr(carter)+ "," + _
	" carter_viesn_id = "+carter_viesn_id+"," + _
	" standarta_viesnicas = " + standarta_viesnicas +"," + _
	" ped_vietas_dzimums = '"+cstr(ped_vietas_dzimums)+"'"+ _
	" WHERE id = "+cstr(id)
	
 conn.execute  "UPDATE grupa SET standarta_viesnicas = 0 where id = " + cstr(id)

 if IsAccess(T_GRUPU_PAPILD_INFO) then
  conn.execute "UPDATE grupa SET " + _
	" vad_id = '"+cstr(vad_id)+"'," + _
	" ln = '"+ln+"'," + _
	" piezimes2 = '"+piezimes2+"'" + _
	" WHERE id = "+cstr(id)
 end If

 
 ''ja vajadzgs izveidojam lidojumu un izmainam lidojuma vietas
 If carter="1" And lidojums_vietas<>"" Then

	Set rlid = conn.execute("select * from lidojums_vietas where lidojums = "+lidojums+"")
	If rlid.eof Then
		conn.execute("insert into lidojums_vietas (lidojums) values ("+lidojums+")")
	End If
	If lidojums_vietas <> "" then
		conn.execute("update lidojums_vietas set vietas = "+lidojums_vietas +" where lidojums = "+lidojums+"")
	End if
 End if


 conn.execute "UPDATE marsruts SET old = "+SQLText(old)+",v='"+SQLText(v)+"' where id = (select mid from grupa where id = "+cstr(id)+")"
 
 
 'mainam resursu nosaukumus grâmatvedîbâ
 if Request.Form("beigu_dat")<>"" and Request.Form("kods")<>"" then
	conn.execute ("update grupa set need_check = 1 where id = "+cstr(id))
 end if
 
'RT: Izmaiòu logoðana detalizçti no 21.06.2019 
Dim old_vals
set old_vals = CreateDictR(rGrupaOld) 

Dim new_vals
set new_vals = CreateDict(qry_for_logging) 
UpdateActionDetails old_vals,new_vals,"grupa",id,""
action_logged = true
'rw "updated"
'response.end 
'--- Grupas vadiitaaja pieteikuma pievienosana (Vaktajam grupaam) 09/06/2009 Nils
'--- pievienotas ari pasutijuma grupas 13/06/2009
'--- pievienotas ari skolenu grupas 3/11/2010




if veids = "1" or veids = "2" or veids = "3" then



	
 '--- parbauda vai ir noradits grupas vaditajs
 if vaditajs<>"" and vaditajs<>"0" then

 
	'--- ja grupas vaditajs nav dalibnieku tabulaa, to tur ievieto
	Set rGV = conn.execute("select vards,uzvards,did from grupu_vaditaji where idnum = '"+cstr(vaditajs)+"'")
	if isnull(rGV("did")) Then
		conn.execute("insert into dalibn (vards,uzvards,piezimes) VALUES('"+rGV("vards")+"','"+rGV("uzvards")+"','GRUPU VADÎTÂJS')")
		Set rDID = conn.execute("select IDENT_CURRENT( 'dalibn' ) as did")
		did = rDID("did")
		conn.execute("UPDATE grupu_vaditaji SET did = '"+cstr(rDID("did"))+"' WHERE idnum='"+cstr(vaditajs)+"'")
	else
		'meklkç vispirms, vai nav izdzçsts tâds vadîtâjs
		set vaditajs_d = conn.execute("SELECT * FROM dalibn WHERE id="+cstr(rGV("did")))
		if (vaditajs_d.eof) then
			Session("message") = "Grupas vadîtâjam ir piesaistîts neeksistçjoðs dalîbnieka profils ar ID#"+cstr(rGV("did"))+"<br>"
			Response.Redirect "grupa_edit.asp?gid="+cstr(id)
			response.end
		end if
		did = rGV("did")
	end if
	



	
	'--- izveido grupas pakalpojumu "Grupas nauda"

	set gv_vv = conn.execute("select * from vietu_veidi where gid = '" & id & "' and tips = 'G'")
	
	if gv_vv.eof then
		set gv_vv = conn.execute("SET NOCOUNT ON; insert into vietu_veidi(gid,nosaukums,cena,persona,papildv,virsnieks,limenis,vesture," + _
					"cenaLVL,cenaUSD,cenaEUR,limita_grupa,tips) values('" & id & "','Grupas nauda',0,0,0,0,1," + _
					"'Auto - izveidots. '+cast(getdate() as varchar),0,0,0,'','G'); SELECT @@IDENTITY AS ID")
		vv_id = gv_vv("ID")
	else
		vv_id = gv_vv("id")
	end if
	


	'--- izveido grupas vaditajam pieteikumu
	Set rP = conn.execute("SELECT id,did FROM pieteikums WHERE deleted = 0 AND gid ='"+cstr(id)+"' AND did = "&did&" AND grupas_vad = 1 /*piezimes = 'GRUPAS VADÎTÂJS'*/")
	if rP.EOF Then

		set rP = conn.execute("SET NOCOUNT ON; insert into pieteikums (gid,did,datums,deleted,piezimes,grupas_vad,personas) values ("+cstr(id)+","& did &",'"+sqldate(now)+"',0,'GRUPAS VADÎTÂJS',1,0); SELECT @@IDENTITY AS ID")
 		pid = rP("ID") 
		conn.execute("insert into piet_saite (pid,did,cena,vietsk,summa,deleted,papildv,persona,vietas_veids) values ("+cstr(pid)+","& did &",0,0,0,0,0,0,"&vv_id&")")


	end if
	

 end if	
end if
'-- G V beigas

	
 if valsts<>"X" then
  conn.execute "UPDATE marsruts SET valsts = '"+valsts+"' where id = (select mid from grupa where id = "+cstr(id)+")"

  end if
 
 'maina cenu pieteikumâ ja tâ ir mainîjusies un ja ir tikai viens pieteikums ar vienu piet_saiti
	piet_saite_sk = conn.execute("select count(*) from piet_saite where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and gid = "+id+")")(0)
	if piet_saite_sk = 1 and (ucase(mid(kods,4,1))="P" or ucase(mid(kods,4,1))="S") then
	 set r = conn.execute("select id,pid,cenaLVL,cenaUSD,cenaEUR from piet_saite where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and gid = "+id+")")
	 if getnum(r("cenaLVL"))<>i_cena or getnum(r("cenaUSD"))<>i_cena_usd or getnum(r("cenaEUR"))<>i_cena_eur then
	  conn.execute("update piet_saite set cena = " +cstr(i_cena)+ ", summa = "+cstr(i_cena)+",cenaLVL = "+cstr(i_cena)+",summaLVL = "+cstr(i_cena)+",cenaUSD = "+cstr(i_cena_usd)+",summaUSD = "+cstr(i_cena_usd)+",cenaEUR = "+cstr(i_cena_eur)+",summaEUR = "+cstr(i_cena_eur)+" where id =  "+cstr(r("id")))
	  '(update) "vietsk = 1," (06.08.2008 Nils)
	  pieteikums_recalculate2 r("pid")
	 end if
	end if
 
 conn.execute ("delete from vietas where gid = "+cstr(id))
 conn.execute ("insert into vietas (gid,vietas,viesn_online_pieaug,viesn_online_bernu) values ("+cstr(id)+",isnull(dbo.fn_brivas_vietas("+cstr(id)+"),0),dbo.fn_get_brivas_pieaug_vietas("+cstr(id)+"),dbo.fn_get_brivas_bernu_vietas("+cstr(id)+"))")
 
 session("message") = "<font color=black>Izmaiòas saglabâtas</font>"
 if not action_logged then
	logeditaction "grupa",id
	end if
end if
'Response.write("Atgriezties:grupa_edit.asp?gid="+cstr(id))
Response.Redirect "grupa_edit.asp?gid="+cstr(id)
%>
