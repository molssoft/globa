<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

    <style>

        .popup {
            display: none;
            position: fixed;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);
            border-radius: 5px;
        }
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
    </style>
    <div class="overlay" id="overlay"></div>
    
    <div class="popup" id="popup">
        <p><font color=red><span style="font-size:60pt" id=alerttext>msg</span></font></p>
        <button onclick="closePopup()">Aizvçrt</button>
    </div>
    <script>
        function showPopup(msg) {
			document.getElementById("alerttext").innerText = msg;
            document.getElementById("popup").style.display = "block";
            document.getElementById("overlay").style.display = "block";
        }
        
        function closePopup() {
            document.getElementById("popup").style.display = "none";
            document.getElementById("overlay").style.display = "none";
        }
    </script>	
<%

dim vu		'dalîbnieka vârds uzvârds
dim oid		'ordera ID
dim gid		'grupas id
dim dsk		'dalîbnieku masîva izmçrs (skaits)
'const str_gv = "GRUPAS VADÎTÂJS"
dim p_rez_id 'globas vai online rezervacijas id carter rezervacijas pieteikumam
dim zid		

dim qs_params

'atver konektu pie datubâzes
dim conn
openconn

'----------------------------
'Izveidojam jaunu pieteikumu vai nosakam nummuru
'----------------------------

'nosaka vai bûs jâttçlo viss grupu saraksts vai tikai aktuâlie
if request.querystring("viss") <> "1" then 
	viss = 0
else
	viss = 1
end if

if Request.QueryString("command") = "new" and Request.form("gid") = "" then
  isnew = true
else
  isnew = false
end if

'Response.Write qstring()
'Response.Write(Request.Form("gID"))
'Response.Write isnew
'Response.End

did = Request.QueryString("did")
viesnicas_ir = false



if Request.Form("gid")="balle" then

	Response.redirect("balle_piet.asp?did="+did)
	Response.End

end if



if isnew or Request.form("gid")<>"" then
 pid = 0 
 gid = 0
 
 'Saglabâ pieteikuma numuru
 Session("pid") = pid
 Session("LastPid") = pid

 if Request.Form("gid")<>"" then
  'Pievieno jaunu pieteikumu
	 set conn2 = server.createobject("ADODB.Connection")
	 conn2.open "dsn=globa"
	 conn2.begintrans
	 gid = Request.Form("gid")
	 if gid = "" then gid = "0"
	 conn2.execute "insert into pieteikums (gid,izveidoja) values ("+cstr(gid)+",'"+Get_User+"')"
	 set rPiet2 = conn2.execute ("select max(id) from pieteikums")
	 pid = rPiet2(0)
	 conn2.committrans
	 conn2.close
	 WriteLog 1,pid,"A"
	 LogInsertAction "pieteikums",pid
	 message = "Pievienots jauns pieteikums"
  '----------------------------------
  'Pievienojam izveletos dalîbniekus
  '----------------------------------
  dsk = request.querystring("did").count
  if session("jaunie") <> qstring() then
    for i = 1 to dsk
	  id = request.querystring("did")(i)
	  conn.execute "INSERT INTO piet_saite (pid,did,vietsk) VALUES ("+cstr(pid)+","+cstr(id)+",1)"
    next
  '-- lai nedubultotos, kad piespiez back
  session("jaunie") = qstring()
  end if

  '--------------------------------------
  'Saglabâ pçdçjo pieteikuma nummuru
  '--------------------------------------
  Session("pid") = pid
  Session("LastPid") = pid

  '--------------------------------------
  'Atrod tekoðâ pieteikuma grupas id un veidu
  '--------------------------------------
  set rCurPiet = conn.execute("select isnull(grupas_vad,0) as grupas_vad,id,gid,datums,piezimes,deleted,agents,carter_firma,students,iemaksas,izmaksas,atlaides,bilance,summa,sakuma_datums,beigu_datums,papildvietas,personas,atcelts,atlaidesUSD,atlaidesLVL,atlaidesEUR,summaLVL,summaUSD,summaEUR,sadardzinLVL,sadardzinUSD,sadardzinEUR,iemaksasLVL,iemaksasUSD,iemaksasEUR,izmaksasLVL,izmaksasUSD,izmaksasEUR,bilanceLVL,bilanceUSD,bilanceEUR,norakstitsLVL,norakstitsUSD,norakstitsEUR,krasa from pieteikums where id = " + cstr(pid))
  gid = getnum(rCurPiet("gid"))

  '--------------------------------------
  'Atrod tekoðâ pieteikuma grupas kodu
  '--------------------------------------
  set rCurGrupa = conn.execute("select * from grupa where id = " + cstr(gid))
  if not rCurGrupa.eof then
   gr_veids = rCurGrupa("veids") 
   'pieteikums_recalculate(pid)
  else
   gr_veids = 0
  end if
  kods = nullprint(rCurGrupa("kods"))
  
  
 
  '--------------------------------------
  'Atrod tekoðâ pieteikuma marðruta id
  '--------------------------------------
  session("LastGid") = gid
  marid = getnum(rCurGrupa("mid"))
  
  '--------------------------------------
  'Pârbauda vai tekoðais pieteikums ir USD vai normâls
  '--------------------------------------
  set rCurMar = conn.execute("select * from marsruts where id = " + cstr(marid))
  if getnum(rCurMar("USD")) = -1 then nValuta = "USD" else nValuta = "Ls"
  If rCurGrupa("valuta") = "EUR" Then nValuta = "EUR"

  '--------------------------------------
  'Pârbauda vai jârâda viesnicas
  '--------------------------------------

  set rtest = conn.execute("select id from viesnicas_veidi where gid = "+cstr(gid))
  viesnicas_ir = not rtest.eof
 end If
 
else 'atver esosu pieteikumu



	if request.querystring("pid") = "" then response.write "Nav noradits pieteikuma ID"
	
	pid = getnum(request.querystring("pid"))
	'Saglabâ pieteikuma numuru
	Session("pid") = pid
	Session("LastPid") = pid
	if pid = 0 then
	  gid = Request.QueryString("gid")
	  'mums jâielasa grupas, kas ieksh querystring gid, atbilstoðâs viesnîcas un kajîtes
	else
		set rCurPiet = conn.execute("select isnull(grupas_vad,0) as grupas_vad,id,gid,datums,piezimes,deleted,agents,carter_firma,students,iemaksas,izmaksas,atlaides,bilance,summa,sakuma_datums,beigu_datums,papildvietas,personas,atcelts,atlaidesUSD,atlaidesLVL,atlaidesEUR,summaLVL,summaUSD,summaEUR,sadardzinLVL,sadardzinUSD,sadardzinEUR,iemaksasLVL,iemaksasUSD,iemaksasEUR,izmaksasLVL,izmaksasUSD,izmaksasEUR,bilanceLVL,bilanceUSD,bilanceEUR,norakstitsLVL,norakstitsUSD,norakstitsEUR,krasa,dk_serija,dk_numurs,dk_kods,dk_kam,dk_summa from pieteikums where id = " + cstr(pid))
		gid = getnum(rCurPiet("gid"))
	end if

	'--------------------------------------
	'Ja cartera grupa un nav izveidota rezervacija tad izveido
	'--------------------------------------
	set rCurGrupa = conn.execute("select * from grupa where id = " + cstr(gid))
	sakuma_dat = rCurGrupa("sakuma_dat") 

	If getnum(rCurGrupa("carter"))<>0 Then
		set rPieteikums = conn.execute("select * from pieteikums where id = " + cstr(pid))
		If getnum(rPieteikums("online_rez"))=0 And getnum(rPieteikums("globa_rez"))=0 Then
			conn.execute("insert into globa_rez (deleted) values (0)")
			rezid = LastID("globa_rez")
			LogInsertAction "globa_rez",rezid
			conn.execute("update pieteikums set globa_rez = "+CStr(rezid)+"where id = "+CStr(pid))
		End if
		rPieteikums.Close
	End if
	

	'-------------------------------------------------
	'--- dalibnieka pievienoðana èartera rezervâcijai
	if Request.Form("carter_rez_id")<>"" and Request.Form("carter_did")<>"" then
		
		Session.Contents.Remove("carter_rez_id") '--- dzçð no sessijas
		Session.Contents.Remove("carter_p_id")
		Session.Contents.Remove("carter_g_id")  
		
		'--- skatas vai dalibn ir zidainis
		if Request.Form("carter_zidainis")=1 then
			
			zid = Request.Form("carter_did")
			
			'--- pievieno zidainja id pieteikumam
			
			ssql = "UPDATE pieteikums SET zid = " & zid & " WHERE id = " & pid
			conn.execute(ssql)
			
			'rw ssql
		
		else '--- pieaugushais
		
			'vai grupâ ir brîvas vietas?
			if brivasVietasGrupa(gid)>0 then
		
				'vai dalibnieks jau nav sajaa grupaa?
				if not isDalibnInGroup(Request.Form("carter_did"), gid) then
		
					addRezDal Request.Form("carter_rez_id"), Request.Form("carter_did") '--- redirektee uz jaunaa dalibnieka pieteikumu	
				else
					'--- dalibnieks jau ir registrejies
					message = "Dalibnieks jaur ir registrets saja grupa."
				end if
			else
				'--- nav grupaa vietas
				message = "Grupa vairs nav brivas vietas"
				
			end if
		
		end if
				
	end if
	'---------------------------------------------
	
	
	'Nosaka grupas veidu
	gr_veids = rCurGrupa("veids") 
	kods = nullprint(rCurGrupa("kods"))
	
	'Atrod tekoðâ pieteikuma marðruta id
	session("LastGid") = gid
	marid = getnum(rCurGrupa("mid"))
	
	'Pârbauda vai tekoðais pieteikums ir USD vai normâls
	set rCurMar = conn.execute("select * from marsruts where id = " + cstr(marid))
	if getnum(rCurMar("USD")) = -1 then nValuta = "USD" else nValuta = "Ls"
	If rCurGrupa("valuta") = "EUR" Then nValuta = "EUR"

	'Pârbauda vai jârâda viesnicas
	set rtest = conn.execute("select id from viesnicas_veidi where gid = "+cstr(gid))
	viesnicas_ir = not rtest.eof

end if

'Ielasam tekosa dalibnieka datus
if pid = 0 then 'ja gatava pieteikuma veel nav, ielasam tikai daliibnieka datus
 dquery = "SELECT dalibn.id as did,dalibn.nosaukums as nosaukums, dalibn.vards as vards, dalibn.uzvards as uzvards, null as pid, null as cena, "+_
 "null as vid, null as cenaLVL, null as cenaUSD, null as cenaEUR, null as summa, 0 as papildv, null as vietsk, null as piezimes, 0 as id, null as kid, "+_
 "null as vietas_veids, null as vietas_cena, null as vietas_cenaLVL, null as vietas_cenaUSD, null as vietas_cenaEUR, 0 as kvietas_veids, null as summaLVL, null as summaUSD, null as summaEUR " + _
 "FROM dalibn WHERE (dalibn.id="+Cstr(did)+")"
else 'preteejaa gadiijumaa arii pieteikuma datus
 dquery = "SELECT dalibn.id as did,dalibn.nosaukums as nosaukums, dalibn.vards as vards, dalibn.uzvards as uzvards, piet_saite.pid as pid, piet_saite.cena as cena, "+_
 "piet_saite.vid, piet_saite.cenaLVL as cenaLVL, piet_saite.cenaUSD as cenaUSD, piet_saite.cenaEUR as cenaEUR, piet_saite.summa as summa, piet_saite.papildv as papildv, " + _ 
 " piet_saite.vietsk as vietsk, piet_saite.piezimes as piezimes, piet_saite.id as id, piet_saite.kid as kid, "+_
 "piet_saite.vietas_veids as vietas_veids, piet_saite.vietas_cena, piet_saite.vietas_cenaLVL, piet_saite.vietas_cenaUSD,piet_saite.vietas_cenaEUR," + _ 
 " piet_saite.kvietas_veids as kvietas_veids,piet_saite.summaLVL,piet_saite.summaUSD,piet_saite.summaEUR  " + _
 "FROM piet_saite LEFT JOIN dalibn ON dalibn.ID = piet_saite.did " +_
 "WHERE (piet_saite.pid="+Cstr(pid)+" AND (piet_saite.deleted = 0)) ORDER BY piet_saite.id"
end if

'response.Write(dquery)

set dalibnieki = server.createobject("ADODB.recordset")
dalibnieki.open dquery,conn,3,3

dsk = dalibnieki.RecordCount

if dalibnieki.eof then
	response.write "pieteikums neeksistç, vai ir kïûdains"
	conn.execute("update pieteikums set deleted = 1 where id = "+cstr(pid))
	response.end
end if

if pid <> 0 then 'iemaksas, atlaides buus tikai saglabaatiem pieteikumiem
 did = dalibnieki("did")
 '---- Iemaksu skaits
 'iemquery = "SELECT * FROM orderis WHERE (pid = "+cstr(pid)+" or NoPid = "+cstr(pid)+") AND (deleted = 0 ) ORDER BY datums,id "
 
 iemquery = "select o.*, isnull(t.completed,0) as online from orderis o " +_
			"left join trans_uid t on t.o_id = o.id " +_
			"where (o.pid = "+cstr(pid)+" or o.NoPid = " +cstr(pid)+")  " +_ 
			"ORDER BY o.datums ASC, o.id"
				'rw iemquery
 set iemaksas = server.createobject("ADODB.recordset")
 iemaksas.open iemquery,conn,3,3
 iemsk = iemaksas.recordcount
 '-- atlaiþu skaits
 set ratl = conn.execute("select count(*) from piet_atlaides where pid = "+cstr(pid))
 atlsk = getnum(ratl(0))

	'--- èarteru rezervacijas pieteikums
	if rCurGrupa("carter") then 
		'--- izvada pazinojumu carter pieteikumam kamer nav izveleti pakalpojums un viesnica 
		if not isSetPak(pid) then message = "Izvçlçties naktsmîtni, pakalpojumus un saglabâjiet ar disketi." 'session("message")
		
		
		'--- izvada paziòojumu par pilnu numura cenu, ja adult dalibnieks ir viens dbl/tripl numuraa
		if message="" and not inFullRoom(pid) and ch_whois(dalibnieki("did"), gid)="adult" then message = "Kamçr viesnîcas numurs nav aizpildîts, dalîbniekam tiek aprçíinâta cena par pilnu viesnîcas numuru."
		'if message="" and not inFullRoom(pid) and ch_whois(dalibnieki("did"), gid)="child" then message = "Berna cena netiek piemerota, jo bernam jabut viesnica ar diviem pieaugusajiem".

		'--- dzçð zîdaini no pieteikuma
		del_zid = Request.QueryString("del_zid")
		
		if del_zid<>"" then

			ssql = "UPDATE pieteikums SET zid = null WHERE id = " & pid
			set rz = conn.execute(ssql)

			message = "Zîdainis ir dzçsts no pieteikuma."
			
		end if
		
	end if

 
end if

'--- JAUNA PIETEIKUMA REÌISTRÂCIJA - CEÏOJUMA IZVÇLE
'---- nosaka cik vietas ir aizòemtas

if gid <> 0 then
 
 
	if rCurGrupa("vietsk")>0 then
		'brivo vietu apreíins
		query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
		" and gid = "+cstr(rCurGrupa("id"))+" and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 or agents_izv = 1) " + _ 
		" and piet_saite.deleted = 0 " + _
		" and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3)"
		
		set personas = conn.execute(query)
		query = "SELECT sum(piet_saite.vietsk) as sk " +_
			"FROM grupa,pieteikums,piet_saite " +_
			"WHERE grupa.id = "+cstr(rCurGrupa("id"))+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 or agents_izv = 1));"
		set pap = conn.execute(query)
		
		br_vietas = BrivasVietasGrupa(gid)
		
		if br_vietas = 0 then vmess = "Grupa ir pilna" : alert = 1
		if br_vietas < 0 then vmess = "Grupa ir pârpildîta" : alert = 1
	else
		br_vietas = "nav zinâms"
	end if
	if rCurGrupa("atcelta") = true then vmess = "Grupa ir atcelta.": alert = 1
	'pârbaudam vai nav èarters
	if cstr(gid) = cstr(conn.execute("select charter from parametri")(0)) then
	 carter = 1
	else
	 carter = 0
	end if
end if

		
'Pieteicçja vârds
'if not isnull(dalibnieki("nosaukums")) then 
'	vu = dalibnieki("nosaukums") 
'else
'	vu = nullprint(dalibnieki("vards"))+" "+nullprint(dalibnieki("uzvards"))
'end if

'vu = nullprint(dalibnieki("vards"))+" "+nullprint(dalibnieki("uzvards"))+" "+ucase(nullprint(dalibnieki("nosaukums")))

vu = nullprint(dalibnieki("vards"))

if not isnull(dalibnieki("uzvards")) then 
	vu = vu + " " + nullprint(dalibnieki("uzvards"))
else
	vu = vu + " " + nullprint(dalibnieki("nosaukums"))
end if

if not isnew then 
  if GETNUM(gr_veids) = 6 then kompleks = 1
end if

dim dk
dk=0
 if GETNUM(gr_veids) = 10 then dk = 1



''celojuma (grupas vai kompleksâ) sâkuma datums
dim trip_start
dim trip_end
if kompleks = 1 then
	''trip_start = rCurPiet("sakuma_datums")
	trip_start = now + 1
	trip_end = now + 1
else
	if gid<>0 then
		trip_start = rCurGrupa("sakuma_dat")
		trip_end = rCurGrupa("beigu_dat")
	else	
		trip_start = now
		trip_end = now
	end if
end if

if not isnew then did = dalibnieki("did")

%>
<!--@ 0 HTML start -->
<% docstart "Pieteikums","y1.jpg" %>

<script language="javascript" src="js/date.js"></script>

<font face=Tahoma>

<center><font color="GREEN" size="5" face=Tahoma>Pieteikums:<a href="dalibn.asp?i=<%=did%>"><%=vu%></a></font> <!--font size=2><a href="dalibn.asp?nomainit_pid=<%=pid%>" onclick="return checkBlocked();">[nomainît]</a-->

<% 
'--- ielasa mainigajaa piezimes, lai zinatu vai tas ir Grupas vaditajs
cp_exist = IsObject(rCurPiet)
if cp_exist then 

	gv = rCurPiet("grupas_vad")
else
	gv = false
end if
	 

if pid <> 0 and gv= false then %>

	<br>Kârtas numurs grupâ:
	<%	set rnum = conn.execute("select isnull(count(*),0) from pieteikums " + _ 
					"where datums < '"+sqltime(rCurPiet("datums"))+"' and deleted = 0 and gid = "+cstr(gid)+ _
					" and not id="+cstr(rCurPiet("id"))+" and isnull(piezimes,'') not like 'GRUPAS VAD_T_JS'" )

		if rnum(0)<100 then
			response.write "<b>" + cstr(rnum(0)+1) + "</b>"
		end if
		
end if %>
</font>
<hr>

<% headlinks 
DefJavaSubmit
'Parâda message ja grupa ir pârpildîta
if alert = 1 and not isaccess(35) then '' nerâdît pieteikuma brîdinâjumus
%>
<script language="JScript">
showPopup('<%=vmess%>');
//window.alert ('<%=vmess%>')
</script>
<% end if %>
<center>
<% if pid = 0 then
  Response.Write "<font color=red>Kamçr redzams ðis paziòojums, pieteikums vçl nav saglabâts"
  Response.Write "<br>Lai tas saglabâtos, jâizvçlas ceïojums, viesnîcas numurs un pakalpojums, ja tâdi ir, un jânospieþ uz disketes</font>"
  
  if isGroupBlocked(gid) then
	%>
	<script language="JScript">
		window.alert ('Grupa ir bloíçta. Pievienot dalîbnieku nav iespçjams. Lûdzu griezties pie grupas kuratora.')
	</script>
	<%
  end if
  
end if

checkSingle(pid)


if session("message") = "Pievienots jauns pieteikums" then
  message = session("message")
  session("message") = ""
end if %>
<%if message <> "" then %>
<br><font size="4" color="RED"><%=message%></font><br>
<%end if
'Parâda message no citâm lapâm
if session("message") <> "" then %>
	<br><font size = 4 color="RED"><%=session("message")%></font><br>
	<% session("message") = ""
end if

'---------------------------------
'Atver tekoðo pieteikumu
'----------------------------------
'@ 0 Info par Pieteikumu SQL
if pid = 0 then
 set pieteikums = conn.execute ("select 0 as grupas_vad,NULL as vieta_rezerveta_lidz,"& gid & " as gid,null as summa,null as bilance,'" & SQLDate(now) & "' as datums,0 as students,0 as atcelts,null as piezimes,null as agents,null as carter_firma,null as balle_piezimes, null as balle_vietas, null as balle_datums, null as b_sektors, null as b_numurs, null as ligums_id, null as globa_rez, null as online_rez, null as zid, null as carter_voucer")
else
 set pieteikums = conn.execute ("select isnull(grupas_vad,0) as grupas_vad,vieta_rezerveta_lidz,gid,summa,bilance,datums,students,atcelts,piezimes,agents,carter_firma,balle_vietas,balle_datums,balle_piezimes,dk_norakstita,b_sektors,b_numurs, ligums_id, globa_rez, online_rez, zid, carter_voucer from pieteikums where id = "+cstr(pid))
end if

online_piet = false
if pid<>0 then 'not isnew
	if (getnum(pieteikums("online_rez")) <> 0) then
		online_piet = true
	end if
 if rCurGrupa("carter") or rCurGrupa("drukat_vauceri") then

	if rCurGrupa("carter") then
		'--- skatas globas vai online rezervacija
		if pieteikums("globa_rez")<>"" then
			where_c = "p.globa_rez = "&pieteikums("globa_rez")
			p_rez_id = pieteikums("globa_rez")
		
		elseif pieteikums("online_rez")<>"" then
			
			where_c = "p.online_rez = "&pieteikums("online_rez") '--- japievieno nosac tikai pabeigtaas
			p_rez_id = pieteikums("online_rez")
		else
			where_c = "1=0"  '--- fail results
		end if

		ssql="select distinct p.id, d.vards, d.uzvards from pieteikums p " + _
			"inner join piet_saite ps on ps.pid = p.id " + _
			"inner join dalibn d on d.id = ps.did " + _
			"where "&where_c&" and p.id <> "& pid & " " & _
			"and p.deleted = 0 and ps.deleted = 0"

		'rw ssql	
		set rez_dal = conn.execute (ssql)


		%>
		<form action="dalibn.asp?rez_id=<%=p_rez_id%>&p_id=<%=pid%>" method="POST" name="f_carter">
		<table>
			<tr>
			<td colspan="2" align="center"><span style="color:black;font-weight:bold;">-=== Èartera rezervâcija Nr. <%=p_rez_id%> ===-</span><br />
			<%
			if not rez_dal.eof then
				%>&nbsp;Citi dalîbnieki ðajâ rezervâcijâ:&nbsp;<%
				while not rez_dal.eof
					rw "<a href=""pieteikums.asp?pid="&rez_dal("id")&""" >"&rez_dal("vards")&" "&rez_dal("uzvards")&"</a>&nbsp;"
					rez_dal.moveNext
				wend
				%>
				<br />
			<%end if%>
			
			<input type="submit" name="submit_carter" value="Pievienot rezervâcijai dalîbnieku" />
			&nbsp;
			<%
			zid = pieteikums("zid")
			
			if zid<>"" then
				ssql = "SELECT * FROM dalibn WHERE id = "&zid
				set rz = conn.execute(ssql)
				if not rz.eof then
					rw "<a href=""dalibn.asp?i=" & zid & """>"&rz("vards")&" "&rz("uzvards")&"</a>" '--- zîdaiòa vârds uzvârds
				end if
				%>
				&nbsp;
				<input type="image" name="del_infant" alt="Dzçst zîdaini no pieteikuma" src="impro/bildes/dzest.jpg" onclick="document.f_carter.action='pieteikums.asp?pid=<%=pid%>&del_zid=<%=zid%>'; document.f_carter.submit();" WIDTH="25" HEIGHT="25">
			<%else%>
				<input type="button" name="add_infant" value="Pievienot zîdaini" onclick="document.f_carter.action=document.f_carter.action+'&g_id=<%=gid%>'; document.f_carter.submit();" />
			<%end if%>
			
			</td>  
			</tr>
		</table>
		</form>
			<%
	
	End if

	'--- ieguust viesnicas id
    if getnum(dalibnieki("vid")) > 0 Then

		r_viesn_id = getnum(dalibnieki("vid"))
	else

		ssql = "select isnull(ps.vid, 0) as vid from pieteikums p " + _  
				"inner join piet_saite ps on ps.pid = p.id " + _ 
				"where p.id = "& pid &" and p.deleted = 0 and ps.deleted = 0 " + _ 
				"and isnull(ps.vid,0)<>0"

		'rw ssql
		Set r_viesn = conn.execute(ssql)

		If Not r_viesn.eof then
			r_viesn_id = r_viesn("vid")
		End if
	
	End if
	If r_viesn_id >0 then
		if viesnDalBilanceLVL(r_viesn_id) = 0 Then
			carter_voucer = pieteikums("carter_voucer") '--- vai vauceris ir izdrukaats
			%>
			<form action="carter_voucer.asp" method="POST" name="f_voucer" id="f_voucer" target="_blank">
				<input type="hidden" name="pid" value="<%=pid%>">
				<input type="button" name="print_voucher" value="Izdrukât vauèeri" onclick="document.getElementById('f_voucer').submit();" />
				<%
					If carter_voucer = true Then
						Response.write "&nbsp; (ir izdrukâts)"
					Else
						Response.write "&nbsp; (nav izdrukâts)"
					End if
				%>

			</form>
		<%
		end If
	Else
			carter_voucer = pieteikums("carter_voucer") '--- vai vauceris ir izdrukaats
			%>
			<form action="carter_voucer.asp" method="POST" name="f_voucer" id="f_voucer" target="_blank">
				<input type="hidden" name="pid" value="<%=pid%>">
				<input type="button" name="print_voucher" value="Izdrukât vauèeri" onclick="document.getElementById('f_voucer').submit();" />
				<%
					If carter_voucer = true Then
						Response.write "&nbsp; (ir izdrukâts)"
					Else
						Response.write "&nbsp; (nav izdrukâts)"
					End if
				%>

			</form>
		<%
	End If
	%>
<%
 end if
end if


   if pid <> 0 then %>
 <form action="piet_save.asp?pid=<%=pid%>" method="POST" name="forma">
<% else %>
 <form action="piet_save.asp?pid=<%=pid%>&gid=<%=gid%>&did=<%=did%>" method="POST" name="forma">  
 <input type="hidden" id="submit_form" name="submit_form" value="0"> 
<% end if %>

<!---------------------------------->
<!--Informacijas par pieteikumu - datums, grupa piezimes><!---------------------------------->
<table>
	<tr><td align="right">

<% '-------- Izdrukâ grupu sarakstu ---------------
if gid = 0 or isnull(selected) then gid = 279
if iemsk > 0 or atlsk > 0 then
	q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
	"FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE grupa.id = "+cstr(gid)
	Set grupas_l = conn.execute(q_l)
	%><td width=75% align=center><font size=4><b><%
	response.write nullprint(grupas_l("v"))+ " "+dateprint(grupas_l("sak"))+" "+nullprint(grupas_l("kods"))+"</option>"
	%></b></font><input type=hidden name=gid value=<%=gid%>>
	</td><%
else
	saite = "<A HREF=""pieteikums.asp" & qstring() 'pid=" + cstr(pid)
	if instr(1,saite,"viss")>0 then
	 saite = left(saite,instr(1,saite,"viss")-2)
	end if
	'Links atkarîgs no tâ vai tiek attçlots pilns marðrutu saraksts
	if viss = 0 then 
		saite = saite+"&viss=1"+CHR(34)+">Aktuâlie"
	else
		saite = saite+CHR(34)+">Visi"
	end if
	saite = saite+":</a></td> "
	Response.Write saite
	%><td ><%
	dim grupas_l
	dim q_l
	
	dim deny_kompleks 
	if IsAccess(T_DENY_KOMPLEKS) then
		deny_kompleks = " and grupa.kods <> 'K.PID' and grupa.kods <> 'I.PID' "
	end if
	
	if viss = 1 then
		'--- pilns saraksts
	    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
	    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + deny_kompleks + " WHERE marsruts.old = 0 ORDER BY dbo.fn_order_string(v), grupa.sakuma_dat;"
	else
		'--- tikai aktualo grupu saraksts
	    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
	    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
	    "WHERE ((sakuma_dat >= '" + SQLDate(now-5) + "'  AND beigu_dat >= '" + SQLDate(now-5) + "') OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(gid) + ") and marsruts.old = 0 and grupa.atcelta = 0 " + deny_kompleks + _
	    " ORDER BY dbo.fn_order_string(v), grupa.sakuma_dat;"
	    
	end if
	Set grupas_l = conn.execute(q_l)
	'Response.Write "<input type=text name=fin LANGUAGE=javascript size=7>"
	'Response.Write "<input type=hidden name=fin_last_ch>"
	'Response.Write "<input type=button value=? name=bfind LANGUAGE=javascript onclick='find_group();return false;'>"
	Response.Write "<select name='gID' size='1' value='6'" 
	if pid=0 then Response.Write " onchange='{document.forms[0].submit();}'"
	Response.Write ">"
	do while not grupas_l.eof
	Response.Write "<option "
	
	if gid<>0 and trim(gid)=trim(getnum(grupas_l("ID"))) then 
		response.write "selected "
		grupasNos = grupas_l("v")
	end if
	
	response.write "value='" & grupas_l("ID") & "'>" 
	response.write nullprint(grupas_l("v"))+ " "+dateprint(grupas_l("sak"))+" "+nullprint(grupas_l("kods"))+"</option>"
	grupas_l.MoveNext
	loop
	Response.write " </select></td>" & Chr(10)
end if

Set grupa = conn.execute("select * from grupa where id = "+CStr(gid))


%><td width=5></td><td>
<a href="javascript:void(window.open('grupa_edit.asp?gid=<%=gid%>'))">Uz grupu</a>
</td>
<% if not grupa.eof  then
if ( grupa("VEIDS")=6) then
%>
<td style="padding-left:25px"><a href="c_grupas_dati_nosutiti.php?pid=<%=pid%>" target="_blank"><b>Pieteikuma dati nosûtîti</b></a></td>
<%
end if
end if %></tr>
</table>
<% if not isnew then%>
<table border="0">
<tr>
 <% if pid<>0 then %>
	<td align="right">Datums: </td>
	<td><a href="piet_datums.asp?pid=<%=pid%>"><%=dateprint(pieteikums("datums"))%></a>
		<input type="hidden" size="10" maxlength="20" name="pdatums" value="<%=pieteikums("datums")%>" locked="true">  
	<% else %>
	  <td align="right"></td><td>
	<% end if %>
	<% Response.Write "Brîvas vietas: "+ cstr(br_vietas) %>
	<td align="right">
	<%
	if gr_veids = 1 or gr_veids=2 then 'and gid<>rParametri("atteikusies") and gid<>rParametri("atteikusies2") and gid<>rParametri("atcelts") then
		ligums_id = getnum(pieteikums("ligums_id"))
		
		if ligums_id = 0 and getnum(pieteikums("online_rez"))<>0 then
			ssql = "select * from ligumi where deleted = 0 and accepted=1 and rez_id in (select online_rez from pieteikums where id = "+cstr(pid)+") order by id desc"
			'rw ssql
			set rlig = conn.execute("select * from ligumi where deleted = 0 and rez_id in (select online_rez from pieteikums where id = "+cstr(pid)+") order by id desc")
			if not rlig.eof then
				ligums_id = rlig("id")
			end if
		end if
		
		if ligums_id = 0 then 
		
			'--- parbauda vai nav online_rez un taas liigums
			ssql = "select r.ligums_id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
					"where p.id = "&pid&" and r.deleted = 0 and p.deleted = 0 and isnull(r.ligums_id,0) <> 0" 
					
			set o_rez = conn.execute(ssql)
			if not o_rez.eof then
				ligums_id = o_rez("ligums_id")
			end if
		end if
			
		if ligums_id <>0 Then
			'atrod, vai lîgums ir nosûtîts pa e-pastu parakstîðanai
			set rligums = conn.execute("SELECT isnull(parakstits,0) as parakstits, isnull(nosutits,0) as nosutits FROM ligumi WHERE id="+cstr(ligums_id)+"")
			nosutits = 0
			if not rligums.eof then
				nosutits = rligums("nosutits")
			end if
			if nosutits then
				nosutits_ch = "checked"
				parakstits = rligums("parakstits")
				if (parakstits) then
					parakstits_style = ""
					parakstits_ch = "checked"
				else 
					parakstits_style = "color:red"
					parakstits_ch = ""
					
				end if
			else nosutits_ch = ""
			end if
			%>
			<%radit = true

			
			if online_piet then
		
				if (iemsk<=0) then
					radit = false
				end if
			end if
			 if radit then%>
			<a href="download_pdf.asp?id=<%=ligums_id%>" target="_blank">Ceïojuma lîgums Nr. <%=ligums_id%></a>
			<%
				else
					rw "<small>Lîgums bûs pieejams pçc avansa iemaksas saòemðanas</small>"
					end if %>
			</td>
			<td>
				<input type="checkbox" name="ligums_nosutits" <%=nosutits_ch%>>Lîgums nosûtîts parakstîðanai
			</td>
			<% if nosutits then %>
			<td>
				<input type="checkbox" name="ligums_parakstits" <%=parakstits_ch%>><label style="<%=parakstits_style%>">Lîgums parakstîts</label>
			</td>
			<% end if %>
	<%else%>
			<a href="pieteikumi_grupaa.asp?gid=<%=pieteikums("gid")%>&mode=ligums">Lîgums vairâkiem</a> | 
			</td><td align="left"><a href="#" onclick="fligums.submit();return false;">Lîgums vienam</a>
			</td>
		<%end if
		
	 
	end if
	%>
</tr>

	<% if instr(nullprint(grupas_l("v")),"!Dâvanu karte")>0 and pid<>0 then%>
	<tr>
		<td align="right" colspan="3">
			D.K. norakstîta&nbsp;<input type = checkbox name = "DKnorakstita" <% if pieteikums("dk_norakstita") = true then response.write "checked"%>>
		</td>
	</tr>
	<% end if%>
<tr>
	<td></td>
	<td><label id="grupas_vad_label">
			<input type="checkbox" name="grupas_vad"  onclick="changePiezimes(this)" id="grupas_vad" <% if (pieteikums("grupas_vad") = true) then rw "checked" end if%>>Grupas vadîtâjs
		</label>
	</td>
	<td>
	Online maksâjuma summa:
	</td>
	<td>
	<input type=text id=online_payment_amount size=10><input type=button value="Kopçt saiti" onclick="
		copyToClipboard('https://www.impro.lv/online/c_payment.php?d=P_<%=kods%>_<%=pid%>&a='+$('#online_payment_amount').val());
		alert('Saite nokopçta');
		">
	</td>
</tr>

<script>
async function copyToClipboard(textToCopy) {
    // Navigator clipboard api needs a secure context (https)
    if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(textToCopy);
    } else {
        // Use the 'out of viewport hidden text area' trick
        const textArea = document.createElement("textarea");
        textArea.value = textToCopy;
            
        // Move textarea out of the viewport so it's not visible
        textArea.style.position = "absolute";
        textArea.style.left = "-999999px";
            
        document.body.prepend(textArea);
        textArea.select();

        try {
            document.execCommand('copy');
        } catch (error) {
            console.error(error);
        } finally {
            textArea.remove();
        }
    }
}
</script>

<tr>
	<td align=right>Piezîmes ðim ceïojumam:</td>
	<td><input type="text" size="50" name="ppiezimes" id="ppiezimes" value="<%=quotes(pieteikums("piezimes"))%>">
	<td><% if pid<>0 then 
		set rDocCount = conn.execute("select isnull(count(*),0) as c from dokumenti where pid = "+cstr(pid))
		%>
		<a href="dokuments.php?pid=<%=pid%>">Dokumenti (<%=rDocCount("c")%>)</a>
		<% 
		end if 
	%></td>
</tr>
<tr>
	<td align=right>Piezîmes visiem ceïojumiem:</td>
	<td><input type="text" size="50" name="ppiezimes_visiem" id="ppiezimes_visiem" value="<%=quotes(conn.execute("select piezimes_visiem from pieteikums where id = "+cstr(pid))(0))%>">

<%	if gr_veids = 1 then 
			style = ""
		if pieteikums("vieta_rezerveta_lidz") <> "" then
			
			if  pieteikums("vieta_rezerveta_lidz") < date() and  pieteikums("vieta_rezerveta_lidz")<> cdate("1900-01-01") then
				style="color:red"
			end if
		end if%>
		
	<td align=right>Vieta rezervçta lîdz:</td>
	<td><input type="text" style="<%=style%>"size="10" placeholder="dd.mm.GGGG" name="vieta_rezerveta_lidz" value="<%=dateprint(pieteikums("vieta_rezerveta_lidz"))%>">	
		</td>
		<% end if %>
</tr>
<%
'---------------PAGAIDAAM ATSLEEGTS, STRAADAAJAM TIKAI AR VAAKTAJAAM GRUPAAM
'-------------- izdrukâ kodu ja kompleksais vai lidojums
'------------------------------


 if kompleks=1 then '%>
   <tr>
   <td align=right>No:
   <td><input type=text name="sakuma_datums" size=9 value="<%if pid<>0 then Response.write(DatePrint(rCurPiet("sakuma_datums")))%>">&nbsp;
   Lîdz:
   <input type=text name="beigu_datums" size=9 value="<%if pid<>0 then Response.write(DatePrint(rCurPiet("beigu_datums")))%>">
   <td align=right>Kompl. Nr.</td>
   <td><%=cstr(pid)%>
   </tr>
 <% end if 
 
 'izdrukâjam dâvanu kartei derîgumu un numuru
 if dk=1 then %>
   <tr>

 
   <td align=right>No:
   <td><input type=text name="sakuma_datums" size=9 value="<%if pid<>0 then Response.write(DatePrint(rCurPiet("sakuma_datums")))%>">&nbsp;
   Lîdz:
   <input type=text name="beigu_datums" size=9 value="<%if pid<>0 then Response.write(DatePrint(rCurPiet("beigu_datums")))%>">
    <% if iemsk>0 then%>
   <td align=right>D.k. Nr.:</td>
   
   <td><% if rCurPiet("dk_serija") <> "" then response.write(rCurPiet("dk_serija")+"-") end if %><%=cstr(rCurPiet("dk_numurs"))%></td>
   <td> &nbsp</td>
    <td align=right> D.k. kods:</td>
   <td> <%=cstr(rCurPiet("dk_kods"))%></td>
   <td>&nbsp</td>
   <td align=right> D.k. summa:</td>
   <td> <%=Currprint(rCurPiet("dk_summa"))%> EUR</td>
   <td><a href="https://impro.lv/online/c_reservation.php?f=PrintDk&num=<%=cstr(rCurPiet("dk_numurs"))%>&k=<%=cstr(rCurPiet("dk_kods"))%>" target="_blank">Atvçrt</a></td>
  
   <% 
   else
	%>
	<td colspan="9">Dâvanu karte bûs pieejama pçc iemaksas saòemðanas</td>
	<%
   end if
%>
 </tr>
<% 
 end if 
'---------------ATSLEEGTAAS DALJAS BEIGAS 


%>

<% set rParametri = conn.execute ("select * from parametri")
if gid<>rParametri("atteikusies") and gid<>rParametri("atteikusies2") and gid<>rParametri("atcelts") then %>
 <% if pid <> 0 and sakuma_dat > now() then %>
	<tr>
		<td align=right>Atteikums:</td>
		<td align="left" colspan="2">
			<select name=att_veids onchange="if (checkBlocked()&&confirm('Vai klients atsakâs no ceïojuma?')) {forma.action=att_veids.value;forma.submit()} else {att_veids.value=0}">
				<option value=0>-Izvçlieties atteikuma veidu-</option>
				<% if rCurGrupa("atcelta") = false then%>
				<option value=att_veids1.asp?pid=<%=pid%>>Atsakâs un izòem naudu</option>
				<option value=att_veids3.asp?pid=<%=pid%>>Atsakâs un atstâj avansâ</option>
				<option value=att_veids2.asp?pid=<%=pid%>>Atsakâs un izvçlas citu ceïojumu</option>
				<% else %>
				<option value=att_veids1.asp?pid=<%=pid%>&tips=atcelts>Atcelta grupa - izòem naudu</option>
				<option value=att_veids3.asp?pid=<%=pid%>&tips=atcelts>Atcelta grupa - atstâj avansâ</option>
				<option value=att_veids2.asp?pid=<%=pid%>&tips=atcelts>Atcelta grupa - izvçlas citu ceïojumu</option>
				<% end if %>
			</select>
		</td>
	</tr>
	<% end if %>
<%
end if
%>
</table>

	
	<%
		'--- balles sektors
		bs = nullprint(Pieteikums("b_sektors"))
		bn = CStr(nullprint(Pieteikums("b_numurs")))
		sektors = bs+bn
		If bs = "" then
			'--- izvelk info no grupas tabulas tiem kas vçl nav pieteikuðies
			set r_balles_gr = conn.execute ("select balle_sektors, balle_numurs from grupa where id = " + cstr(gid))
			if not r_balles_gr.eof then 
				bs = nullprint(r_balles_gr("balle_sektors"))
				sektors = bs+cstr(getnum(r_balles_gr("balle_numurs")))
				If bs<>"" then
					Response.Write("<a href=balle_edit.asp?gid="+CStr(gid)+"&num="+sektors+"&did="+CStr(did)+">Balles sektors:" + sektors +"</a><BR>")
				End if
			end If
		Else
			Set rbp = conn.execute("select * from balles_pieteikumi where pid = "+pid)
			If Not rbp.eof Then
				gid = rbp("gid")
				Response.Write("<a href=balle_edit.asp?gid="+CStr(gid)+"&num="+sektors+"&did="+CStr(did)+">Balles sektors:" + sektors +"</a><BR>")
			else
				Response.Write("<a href=balle_edit.asp?num="+sektors+"&did="+CStr(did)+">Balles sektors:" + sektors +"</a><BR>")
			End if
		End if
			
	%>


<%

'--- kompleksajam un vaktajama grupam parbauda vai noraditi pakalpojumi
'paarbauda tikai tajaa gadiijumaa, ja tas nav pavisam svaigs pieteikums ar veel neizveeleetu grupu

'--- 26/6/2006 Nils. paarbaude uz pakalpojumiem pievienota ari pasuutijuma grupaam.
'--- lai noveerstu situaciju, kad cena var buut ievadiita nulle, bet veiktas iemaksas, kaa redzultaataa atskaitees nesakriit bilance.

if (gr_veids = 6 or gr_veids = 1 or gr_veids = 2) then 
	%>
 <input type="image" name="saglabat" src="impro/bildes/saglabat.jpg" alt="Tiek saglabâtas izmaiòas, kas izdarîtas pieteikuma teksta laukos un tiek pârrçíinâtas summas un bilance." onclick="return (<%if((gr_veids = 1) and (pid = 0))then Response.Write("checkDalibnInGroup() && checkBlocked() && ")%>CheckKaj() && CheckPakalp() && checkPiezimes() && checkSubmit() );">
<% else %>
 <input type="image" name="saglabat" src="impro/bildes/saglabat.jpg" alt="Tiek saglabâtas izmaiòas, kas izdarîtas pieteikuma teksta laukos un tiek pârrçíinâtas summas un bilance." onclick="return(checkSubmit());">
<% end if %>
<% if pid<>0 then%>
<a target = none href = "piet_vesture.asp?pid=<%=pid%>"><img border = 0 style="border:none" src="impro/bildes/clock.bmp" alt="Apskatît ðî pieteikuma vçsturi."></a>
<a href = "piet_del.asp?pid=<%=pid%>&did=<%=did%>"><img border = 0 style="border:none" src="impro/bildes/dzest.jpg" alt="Dzçst ðo pieteikumu." 
	></a>
<% end if %>
<br>

<!-- Dalîbnieku tabula -->
<% if true then 'dsk>0 then %>
<br><b>Pakalpojumi<br>
<table border=0 >
<!--@ 1 Headings -->
<tr bgcolor=#ffc1cc>
<% if isnew then %>
 <th>P.V.</th>
 <th>Cena</th>
 <th>Sk.</th>
 <th>=<%=nValuta%></th>
 <% colspan=4 %>
<% elseif nullprint(rCurGrupa("valuta")) = "XXX" then %>
 <th>EUR</th>
 <th>USD</th>
 <!--th>LVL</th-->
 <th>Sk.</th>
<% colspan=3
else %>
 <th>P.V.</th>
 <th>Cena</th>
 <th>Sk.</th>
 <th><%=nValuta%></th>
 <th>Piezimes</th>
<% colspan=4
end if %>

<% 

if not isnew then
 '------- atver kajîðu tabulu ðai grupai
 set rKaj = server.createobject("ADODB.Recordset")
 set rKajD = server.createobject("ADODB.Recordset")
 
 rKaj.open "Select KAJITE.*, KAJITES_VEIDI.NOSAUKUMS from kajite INNER JOIN KAJITES_VEIDI ON KAJITE.VEIDS = KAJITES_VEIDI.ID where (deleted = 0) and KAJITE.gid in (" + cstr(gid)+","+cstr(getnum(rCurGrupa("kajites_gid")))+") order by KAJITES_VEIDI.NOSAUKUMS,kajite.id",conn,3,3
dim ssql
ssql  ="select isnull(ps.kvietas_veids,0) as kvietas_veids,ps.persona,kv.nosaukums,did,vards,uzvards,d.nosaukums,kv.vietas,kid from piet_saite ps,kajites_veidi kv,dalibn d, kajite k where kid in (select id from kajite where gid in (" + cstr(gid)+","+cstr(getnum(rCurGrupa("kajites_gid")))+")) and ps.deleted = 0 and veids = kv.id and did=d.id and ps.kid=k.id order by kv.nosaukums,k.id"
 'response.write(ssql)
 rKajD.open ssql,conn,3,3
 if rKaj.recordcount > 0 then %>

 <th colspan = 3>Kajîte</th>

 <% end if %>


 <%
 '------- atver vietu veidu tabulu ðai grupai
 set rVietVeid = server.createobject("ADODB.Recordset")
 rVietVeid.open "Select * from vietu_veidi where gid = " + cstr(gid) + " and virsnieks = 0 ORDER BY nosaukums",conn,3,3
 if viesnicas_ir then
  %><th>Viesnîcu numuri</th><%
 end if
 'if rVietVeid.recordcount > 0 then %>
  <th colspan = 2>Pakalpojums</th>
 <% 'else %>
 <% 'end if %>
<% end if %>


<%if pid<>0 then%>
<th>.</th>
<th>.</th>
<% end if %>

</tr>
<tr>
<% if not isnew then
'-----------------------------------------
'Izvada tabulu ar pieteikuma dalibniekiem
'-----------------------------------------
'@ 1 Cells
dalibnieki.movefirst
i = 1
for i = 1 to dsk
	if nullprint(rCurGrupa("valuta")) <> "XXX" then
	 if dalibnieki("papildv") = -1 then chval = "checked" else chval = ""
	 response.write("<td align = 'right'><input type='checkbox' name='papildv"+cstr(i)+"'  "+chval+"></td>")
	 if gr_veids <> 1 then
		  response.write("<td align = 'right'><input type='text' size='6' maxlength='20' name='cena"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cena")))+"'></td>")
	 else
	  response.write("<td align = 'right'><input type='hidden' name='cena"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cena")))+"'>")
	  response.write(cstr(getnum(dalibnieki("cena")))+"</td>")	
	 end if
	 response.write("<td align = 'right'><input type=text size=1 name='vietsk"+cstr(i)+"' value = '"+nullprint(dalibnieki("vietsk"))+"'></td>")
	 response.write("<td align = 'right'>"+curr3print2(getnum(dalibnieki("summaLVL")),dalibnieki("summaUSD"),dalibnieki("summaEUR"))+" </td>")
	else
	 if gr_veids <> 1 then
	  response.write("<td align = 'right'><input type='text' size='6' maxlength='20' name='cenaEUR"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cenaEUR")))+"'></td>")
	  response.write("<td align = 'right'><input type='text' size='6' maxlength='20' name='cenaUSD"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cenaUSD")))+"'></td>")
	 else
	  response.write("<td align = 'right'><input type='text' size='6' maxlength='20' name='cenaEUR"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cenaEUR")))+"'></td>")
	  response.write("<td align = 'right'><input type='text' size='6' maxlength='20' name='cenaUSD"+cstr(i)+"' value = '"+cstr(getnum(dalibnieki("cenaUSD")))+"'></td>")
	 end if
	  response.write("<td align = 'right'><input type=text size=1 name='vietsk"+cstr(i)+"' value = '"+nullprint(dalibnieki("vietsk"))+"'></td>")
	  cenaUSD = cenaUSD + getnum(dalibnieki("cenaUSD"))
	  cenaLVL = cenaLVL + getnum(dalibnieki("cenaLVL"))
	  cenaEUR = cenaEUR + getnum(dalibnieki("cenaEUR"))
	end if
	response.write("<td align = 'left'><input type='text' size='25' name='piezimes"+cstr(i)+"' value = '"+nullprint(dalibnieki("piezimes"))+"'></td>")
	' Kajîtes
	if not isnew and rKaj.RecordCount > 0 then
		'-- kajiites ir
		kajite_sk = rKaj.Recordcount
		'sâkas kajîðu kombo
		response.write "<td align = 'left'>"
		response.write ("<select name = 'kid"+cstr(i)+"' size = 1>")
		'ja ðai piet_saitei nav kajîtes tad selektç pirmo rindiòu
		if getnum(dalibnieki("kid")) = 0 then response.write "<option selected value = '00'>Nav</option>"
		if getnum(dalibnieki("kid")) <> 0 then response.write "<option value = '00'>Nav</option>"
		rkaj.MoveFirst
		if rKajD.RecordCount<>0 then rKajD.MoveFirst
		kajites_cena = 0
		while not rkaj.eof
			response.write "<option value = " + cstr(rKaj("id")) + " "
			if rKaj("id") = dalibnieki("kid")  then 
			 kajites_cena = kajites_veida_cena(rkaj("veids"),dalibnieki("kvietas_veids"))
				response.write " selected "
			end if
			'kajites aizpildijuma info
			kaj_aizp = ""
			kaj_aizp_sk = 0
			dim brivas_vietas_pieskaititas 
			brivas_vietas_pieskaititas = false
			if not rKajD.eof then
			 while getnum(rKajD("kid"))=rKaj("id")
				' response.write("kajiites persona:")
				 'response.write(rKajD("persona"))
				 'response.write("<br>")
				 response.write(rKajD("kvietas_veids"))

				
				 if (rKajD("persona") or (rKajD("kvietas_veids")<>3 and rKajD("kvietas_veids")<>6 and rKajD("kvietas_veids")<>7)) then
					' response.write("persona")
					 kaj_aizp_sk = kaj_aizp_sk + 1
					  if kaj_aizp <> "" then kaj_aizp = kaj_aizp + "," end if
					  kaj_aizp = kaj_aizp + Left (rKajD("vards"), 1) + "." + rKajD("uzvards")

					  
				 else
				 response.write("brîva vieta")
				 response.write(brivas_vietas_pieskaititas)
				response.write(rKajD("kvietas_veids"))
					if (rKajD("kvietas_veids") = 3 and not(brivas_vietas_pieskaititas)) then
						 kaj_aizp_sk = kaj_aizp_sk + 1
						 if kaj_aizp <> "" then kaj_aizp = kaj_aizp + "," end if
						  kaj_aizp = kaj_aizp + "Aizòemts"
						 brivas_vietas_pieskaititas = true
					end if
					if (rKajD("kvietas_veids") = 6 and not(brivas_vietas_pieskaititas)) then
						 kaj_aizp_sk = kaj_aizp_sk + 2
						 if kaj_aizp <> "" then kaj_aizp = kaj_aizp + "," end if
						 kaj_aizp = kaj_aizp + "Aizòemts,Aizòemts"
						 brivas_vietas_pieskaititas = true
					end if
					if (rKajD("kvietas_veids") = 7 and not(brivas_vietas_pieskaititas)) then
						 kaj_aizp_sk = kaj_aizp_sk + 3
						 if kaj_aizp <> "" then kaj_aizp = kaj_aizp + "," end if
						 kaj_aizp = kaj_aizp + "Aizòemts,Aizòemts,Aizòemts"
						 brivas_vietas_pieskaititas = true
					end if
						
				 end if
				  
					
				

				  rKajD.MoveNext
			 wend
			 kaj_aizp = cstr(kaj_aizp_sk)+")" + kaj_aizp
			else
			 kaj_aizp = "0)"
			end if
			response.write ">"+RKAJ("NOSAUKUMS")+"(" + cstr(rKaj("vietas")) + "," + kaj_aizp + "</option>"
			rKaj.movenext
		wend
		response.write ("</select>")
		response.write "</td>"
		%>
		<td align = 'left'>
		<select name = "kvietas_veids<%=cstr(i)%>">
			<%
			
			 x = Getnum(dalibnieki("kvietas_veids"))
			 set KajCenas = conn.execute ("select sum(standart_cena) as standart," + _
     " sum(bernu_cena) as bernu,sum(pusaudzu_cena) as pusaudzu,sum(senioru_cena) as senioru, " + _
     " sum(papild_cena) as papild, sum(papild2_cena) as papild2, sum(papild3_cena) as papild3" + _
     " from kajites_veidi where gid = "+cstr(gid))
					'dabû vecuma intervâlus no db
						qry = "SELECT * FROM kajites_vecums"
						set kajites_vecums = conn.execute(qry)
						

						
			%>
			<option value = "00" <% if x = 0 then Response.Write "selected" %>>Nav</option>
			
			<% if getnum(KajCenas("standart"))>0 then %>
			 <option value = "1" <% if x = 1 then Response.Write "selected" %>>Standarta</option>
			<% end if %>
			
			<% if getnum(KajCenas("bernu"))>0 then %>
			<option value = "2" <% if x = 2 then Response.Write "selected" %>>Bçrnu 0g. - <%=kajites_vecums("bernu_lidz")%>g. (iesk.)</option>
			<% end if %>
			
			<% if getnum(KajCenas("pusaudzu"))>0 then %>
			<option value = "5" <% if x = 5 then Response.Write "selected" %>>Pusaudþu  <%=kajites_vecums("pusaudzu_no")%>g. - <%=kajites_vecums("pusaudzu_lidz")%>g. (iesk.)</option>
			<% end if %>
			
			<% if getnum(KajCenas("papild"))>0 then %>
			<option value = "3" <% if x = 3 then Response.Write "selected" %>>Brîva v.(3 pers)</option>
			<% end if %>
			
			<% if getnum(KajCenas("papild2"))>0 then %>
			<option value = "6" <% if x = 6 then Response.Write "selected" %>>Brîva v.(2 pers)</option>
			<% end if %>
			
			<% if getnum(KajCenas("papild3"))>0 then %>
			<option value = "7" <% if x = 7 then Response.Write "selected" %>>Brîva v.(1 pers)</option>
			<% end if %>
			
			<% if getnum(KajCenas("senioru"))>0 then %>
			<option value = "4" <% if x = 4 then Response.Write "selected" %>>Senioru</option>
			<% end if %>
			
		</select>
		</td>
		<td>
			<%=cstr(kajites_cena)%>
		</td>
		<%
	end if

	'Viesnicu numuri
	'pârbaudam vai viesnicas vispâr ir
	if viesnicas_ir then
	 %><td><%
	   
	   if rCurGrupa("carter") then 
			qs_params = "&rez_id="&p_rez_id
	   else
			qs_params = ""
	   end if
  if getnum(dalibnieki("vid"))<>0 then
	   set rV = conn.execute("select isnull(nosaukums,'')+isnull(viesnicas_veidi.piezimes,'') as nosaukums from viesnicas " + _
	    " inner join viesnicas_veidi on viesnicas.veids = viesnicas_veidi.id " + _
	    " inner join piet_saite on piet_saite.vid = viesnicas.id where piet_saite.id = "+cstr(dalibnieki("id")))
	   v = nullprint(rv("nosaukums"))
	   if v = "" then v = "???" 
	   %><div id=vid_psid_<%=nullprint(dalibnieki("id"))%>><a href="#" onclick="window.open('vid_select.asp?psid=<%=cstr(dalibnieki("id"))%>');"><%=v%></a></div><%
	 else
	
	  %><div id=vid_psid_<%=cstr(dalibnieki("id"))%>><a href="#" onclick="window.open('<%if rCurGrupa("carter") then%>vid_select<%else%>vid_select<%end if%>.asp?psid=<%=dalibnieki("id")%>&gid=<%=gid%>&did=<%=did%><%=qs_params%>');">Izvçlçties</a></div>
	  
	  <div id=vid_div_<%=cstr(dalibnieki("id"))%>><input type=hidden name=vid_<%=cstr(dalibnieki("id"))%> value=0></input></div><%
	 end if
	 %></td><%
	end if
	
	'Vietu veidi
	if not isnew then
	
	 response.write "<td align = 'left'>"
	 vid = dalibnieki("vietas_veids")


	if gv = true then 'parbaude esosham pieteikumam. grupas vaditajam tikai viens pak - grupas nauda
	 
		output = VietuVeidiComboGV(gid,vid)
		response.write output + "</td>"
		
	else	 
		output = VietuVeidiCombo(gid,vid,i,virsn,lim)
		'jaunajiem pieteikumiem radam vecumam atbilstošus pakalpojumus
		'vecos pieteikumus nejaucam
		if (pid=0 or pid>=794101) then
			output = VietuVeidiComboVecums(gid,vid,i,virsn,lim,did)
		else
			output = VietuVeidiCombo(gid,vid,i,virsn,lim)
		end if
		if vid <> 0 then
 			output = output + VietuVeidiSubCombo(vid,i,lim)
			 lim = lim + 2
		else
 			lim = lim + 1
 		end if
 		while lim<5
			 output = output + "<span id = ""vieta" + cstr(i) + "_" + cstr(lim) + """></span>"
			 lim = lim + 1
		wend
		while virsn<>0
 			vid = virsn
			output = VietuVeidiCombo(gid,vid,i,virsn,lim) + output
			 'output = VietuVeidiComboVecums(gid,vid,i,virsn,lim,did) + output
		wend
		response.write output
		GenerateComplexLevels gid,i
	 
	 end if '--- grupas vaditajs pakalpojums
	 
	 if getnum(dalibnieki("vietas_cenaUSD"))=0 and getnum(dalibnieki("vietas_cenaLVL"))=0 and getnum(dalibnieki("vietas_cenaEUR"))=0  then
		Response.Write "<td>" + cstr(getnum(dalibnieki("vietas_cena"))) + "</td>"
	 else
 		Response.Write "<td><font size=2>" + Curr3Print2(getnum(dalibnieki("vietas_cenaLVL")),getnum(dalibnieki("vietas_cenaUSD")),getnum(dalibnieki("vietas_cenaEUR"))) + "</td>"
 	 end if
 	 
 	end if
 	
	if pid<>0 then%>
		<td align="left"><input type="image" name="dzest" alt="Dalîbnieks tiek izslçgts no pieteikuma. Dalîbnieks netiek izslçgts no dalîbnieku tabulas. Ja ðis dalîbnieks ir pçdçjais, tad tiks dzçsts arî viss pieteikums ar visâm izdarîtâjâm iemaksâm un izmaksâm" src="impro/bildes/dzest.jpg" onclick="javascript: if ((<%=i%>==1)&&(!checkBlocked())){return false;} TopSubmit('piet_saite_del.asp?psid=<%=dalibnieki("id")%>');" WIDTH="25" HEIGHT="25"></td>
	<%
		if dalibnieki("papildv") <> -1 then
	%>
		<td align="left"><input type="image" name="papildvieta" alt="Pieteikumam tiek pievienota papildvieta uz dotâ dalîbnieka vârdu." src="impro/bildes/papildvieta.jpg" onclick="javascript: forma.action='piet_papildv.asp?psid=<%=dalibnieki("id")%>';"></td>
	<%
		else 
			response.write "<td></td>" 
		end if
	end if

	Response.Write "</tr>"
	dalibnieki.movenext
	next
end if

else %>
	<font size="4">Pieteikumâ nav dalîbnieku</font><p>
<% end if 
%>
<!-- @ 0 Summas -->
<% if pid<>0 then %>
<tr >
 <td colspan=<%=colspan%> align=right bgcolor=#ffc1ac>Bilance:<b><%=Curr3Print2(getnum(rCurPiet("bilanceLVL")),rCurPiet("bilanceUSD"),rCurPiet("bilanceEUR"))%></td>
 <td colspan=3 align="right"><input type = text name = "piet_vietas_sk" size = 3></td><td><input type = image name = "piet_vietas" src="impro/bildes/pievienot.jpg" alt="Pievienot rindas pakalpojumu sarakstam." onclick="javascript: forma.action='piet_piev_vietas.asp?pid=<%=pid%>';"></td><td>.</td>
</tr>
<% end if %>

</table>

<!--tabula ar pieteikuma atlaidçm-->
<% 

if pid <> 0 then %>
<center>
<br><font><b>Atlaides un piemaksas</b></font>
<table border=0 >
<tr bgcolor=#ffc1cc>
	<th>Veids</th>
	<th>Datums</th>
	<th>Valûta</th>
	<th>Summa</th>
	<th>Izmaiòa</th>
	<th>%</th>
	<th>Piezîmes</th>
	<th>Pievienoja</th>
	<th></th>
</tr>

<!-- ja pie atlaidçm ir kâdi ieraksti, tad tie tiek izdrukâti ðeit-->
<%
set atlaides=server.CreateObject("Adodb.recordset")
	selectstring="select * from piet_atlaides where pid="+cstr(pid)+" order by id"
	atlaides.Open selectstring,conn,3,3
	if atlaides.RecordCount>0 then
		atlaides.MoveFirst
		while not atlaides.eof
		    %>
		    <tr >
		    <td align = left>
				<% 
				if getnum(atlaides("veids")) = 0 then
					if atlaides("uzcenojums") then 
					 response.write "Piemaksa" 
					else 
					 response.write "Atlaide" 
					end if
				else
					Response.Write conn.execute("select nosaukums from piet_atlaides_veidi where id = "+cstr(atlaides("veids")))(0)
				end if
				%></td>
		    <td align = right>
				<a href="piet_atl_datums.asp?id=<%=atlaides("id")%>&pid=<%=pid%>&date=<%=DatePrint(atlaides("datums"))%>"><%=DatePrint(atlaides("datums"))%></a>
		    </td>
		    <td>
		      <% 
			  if getnum(atlaides("atlaideLVL")) <> 0 then 
		        Response.Write "LVL" 
		      elseif getnum(atlaides("atlaideEUR")) <> 0 then 
		        Response.Write "EUR"
		      elseif getnum(atlaides("atlaideUSD")) <> 0 then 
		        Response.Write "USD"
		      else
		        Response.Write "."
		      end if %>
		    </td>
		    <td align = right><%=CurrPrint(getnum(atlaides("summa")))%></td>
		    <td align = right><%=CurrPrint(getnum(atlaides("atlaide"))+getnum(atlaides("atlaideLVL"))+getnum(atlaides("atlaideUSD"))+getnum(atlaides("atlaideEUR")))%></td>
		    <td align = right><%=cstr(getnum(atlaides("procents")))%>%</td>
		    <td><%=nullprint(atlaides("piezimes"))%></td>
		    <td><%=nullprint(atlaides("kas"))+" "+dateprint(atlaides("pievienoja_dat"))%></td>
		    <%
			
			
			if trip_end > now or isaccess(T_VECU_PIET_ATLAIDES) then
				response.write "<td>"+"<input type="+chr(34)+"image"+chr(34)+" name="+chr(34)+"dzest_atlaidi"+chr(34)+ _
				" alt="+chr(34)+"Atlaide no pieteikuma tiek dzçsta"+chr(34)+" src="+chr(34)+"impro/bildes/dzest.jpg"+chr(34) + _
				 "onclick="+chr(34)+"TopSubmit('piet_atlaides_del.asp?"
				Response.Write "id="+cstr(atlaides("id"))+"');"+chr(34)+"></td>"
			end if
			response.write "</tr>"
			atlaides.MoveNext
		wend 
		%>
		<% 
		if pid<>0 then %>
		 <tr bgcolor=#ffc1ac>
			 <td colspan=5 align=right >Kopâ:<%=Curr3Print2(-rCurPiet("atlaidesLVL")+rCurPiet("sadardzinLVL"),-rCurPiet("atlaidesUSD")+rCurPiet("sadardzinUSD"),-rCurPiet("atlaidesEUR")+rCurPiet("sadardzinEUR"))%></td>
			 <td>.</td>
			 <td>.</td>
			 <td>.</td>
			 <td>.</td>
		 </tr>
		<% end if %>
		<%
	end if
end If

'' râdît tikai saglabâtiem pieteikumiem
'' ja pieteikums nav vecs
'' vai ja lietotâjam ir tiesîbas
if pid<>0 and (trip_start > now or isaccess(T_VECU_PIET_ATLAIDES)) then %>
<!------------Sâkas atlaiþu kalkulators ---->
<SCRIPT LANGUAGE="VBScript">	
	function remove_nonnumeric(str_noka)
		tmpstring=""
			for i=1 to len(str_noka)'iet un pârbauda katru zîmi
				zime=mid(str_noka, i,1)
				if (isnumeric(zime) or zime="," or zime=".") then
					tmpstring=tmpstring+zime
				end if
			next
			remove_nonnumeric=tmpstring
	end function
	  
	sub calc_atlaides' rçíina atlaides
			set sum=document.forma.txtkopsum
			set atlsum=document.forma.txtatlaidesum
			set proc=document.forma.txtatlaideproc
			'set rezult=document.forma.atlaideir
			sksum=remove_nonnumeric(cstr(sum.value))
			skatlsum=remove_nonnumeric(cstr(atlsum.value))
			skproc=remove_nonnumeric(cstr(proc.value))
			
			'ieraksta koriìçtâs vçrtîbas atpakaï lodziòos
			sum.value=sksum
			atlsum.value=skatlsum
			proc.value=skproc
			
			'saliek nulles, ja nav nekâ ierakstîta lodziòâ
			'mainîgie ar V* domâti çrtâkai case izvçlei
			if sksum<>"" then
				v1="1"
			else
				v1="0"
			end if
			
			if skproc<>"" then
				v2="1"
			else
				v2="0"
			end if
			
			if skatlsum<>"" then
				v3="1"
			else
				v3="0"
			end if
			
			Ko_darit=v1+v2+v3
			
			select case ko_darit
				case "001"
				case "010" or "100" or "011"' neko nedarît
				case "011"' ir atlaide procentos un atlaides summa
					sum.value=skatlsum*100/skproc
				case "101"' ir kopsumma un atlaides summa
					proc.value=skatlsum*100/sksum
				case "110"'ir kopsummma un procents
					atlsum.value=skproc*sksum/100
				case "111"'ja ir visi trîs, tad rçíina procentus
					proc.value=skatlsum*100/sksum
				case else
			end select
	end  sub
</SCRIPT>

	<tr >
	    <td><select name="atl_veids">
			<% set rAtl = conn.execute("select * from piet_atlaides_veidi order by piemaksa, procents, nosaukums ") 
			while not rAtl.eof 
			%>
                 <option value=<%=rAtl("id")%>><%=rAtl("nosaukums")%></option>
            <% rAtl.movenext
            wend %>
                </select>
            </td>
        
        <td>
			
        </td>
        
	    <td><select name="atl_valuta">
                 <option value=EUR>EUR</option>
                 <option value=USD>USD</option>
                 <option value=LVL>LVL</option>
                </select>
            </td>
	    <td><input name="txtkopsum" language="vbscript" style="width:50px" id="sum"></td>
		<td><INPUT name="txtatlaidesum" language="vbscript" style="width:50px" id="atlsum"></td>
		<td><INPUT name="txtatlaideproc" language="vbscript" style="width:50px"  id="proc"></td>
		<td><input name="txtpiezimes" style="width:150px" id="piez"></td>
		<td halign="center"><center><input type="button" name="btnatlaides" language="vbscript" onclick="calc_atlaides" value="Rçíinât"></center></td></tr>
<% end if %>
	</table><p>
	<!------------beidzas atlaiþu kalkulators---->
<!-- beidzas tabula ar pieteikuma atlaidçm-->
</table>

<!-- dzçstâs atlaides un piemaksas -->
<%
set atlaides_del=server.CreateObject("Adodb.recordset")
	selectstring="select * from piet_atlaides_del where pid="+cstr(pid)+" order by id"
	atlaides_del.Open selectstring,conn,3,3
	if atlaides_del.RecordCount>0 then
		%>
		<center>
		<a href="#" onclick="$('#dzestas_atlaides').show();$(this).hide();return false;">Râdît dzçstâs atlaides un piemaksas</a>
		<div id="dzestas_atlaides" style="display:none">
		<br><font><b>Dzçstâs atlaides un piemaksas</b></font>
		<table border=0  >
		<tr bgcolor=#ffc1cc>
			<th>Veids</th>
			<th>Datums</th>
			<th>Valûta</th>
			<th>Summa</th>
			<th>Izmaiòa</th>
			<th>%</th>
			<th>Piezîmes</th>
			<th>Pievienoja</th>
			<th>Dzçsa</th>
			<th></th>
		</tr>
		<% 
		atlaides_del.MoveFirst
		while not atlaides_del.eof
		%>
		    <tr style="color:#CCCCCC">
		    <td align = left>
				<% 
				if getnum(atlaides_del("veids")) = 0 then
					if atlaides_del("uzcenojums") then 
					 response.write "Piemaksa" 
					else 
					 response.write "Atlaide" 
					end if
				else
					Response.Write conn.execute("select nosaukums from piet_atlaides_veidi where id = "+cstr(atlaides_del("veids")))(0)
				end if
				%></td>
		    <td align = right>
				<%=DatePrint(atlaides_del("datums"))%>
		    </td>
		    <td>
		      <% 
			  if getnum(atlaides_del("atlaideLVL")) <> 0 then 
		        Response.Write "LVL" 
		      elseif getnum(atlaides_del("atlaideEUR")) <> 0 then 
		        Response.Write "EUR"
		      elseif getnum(atlaides_del("atlaideUSD")) <> 0 then 
		        Response.Write "USD"
		      else
		        Response.Write "."
		      end if %>
		    </td>
		    <td align = right><%=CurrPrint(getnum(atlaides_del("summa")))%></td>
		    <td align = right><%=CurrPrint(getnum(atlaides_del("atlaide"))+getnum(atlaides_del("atlaideLVL"))+getnum(atlaides_del("atlaideUSD"))+getnum(atlaides_del("atlaideEUR")))%></td>
		    <td align = right><%=cstr(getnum(atlaides_del("procents")))%>%</td>
		    <td><%=nullprint(atlaides_del("piezimes"))%></td>
		    <td><%=nullprint(atlaides_del("kas"))+" "+dateprint(atlaides_del("pievienoja_dat"))%></td>
			<td><%=nullprint(atlaides_del("dzesa_kas"))+" "+dateprint(atlaides_del("dzesa_dat"))%></td>
		    <%
			
			
			
			response.write "</tr>"
			atlaides_del.MoveNext
		wend 
		%>
		</table>
		</div>
		<br><br>
		
		<%
		end if
		%>

<% 
kom = getnum(conn.execute("select count(*) from piet_starpnieciba where pid = "+cstr(pid))(0)) 

if pid = 0 then
 set pieteikums = conn.execute ("select 0 as grupas_vad,NULL as vieta_rezerveta_lidz,"& gid & " as gid,null as summa,null as bilance,'" & SQLDate(now) & "' as datums,0 as students,0 as atcelts,null as piezimes,null as agents,null as carter_firma,null as balle_piezimes, null as balle_vietas, null as balle_datums, null as b_sektors, null as b_numurs, null as ligums_id, null as globa_rez, null as online_rez, null as zid, null as carter_voucer")
else
 set pieteikums = conn.execute ("select isnull(grupas_vad,0) as grupas_vad,vieta_rezerveta_lidz,gid,summa,bilance,datums,students,atcelts,piezimes,agents,carter_firma,balle_vietas,balle_datums,balle_piezimes,dk_norakstita,b_sektors,b_numurs, ligums_id, globa_rez, online_rez, zid, carter_voucer from pieteikums where id = "+cstr(pid))
end if


if kom = 0 or getnum(Pieteikums("Agents")) = 0 then
 %><a href = "agenti.asp">Aìenti</a> 
	<%
		set rag = conn.execute("select id,vards,pilseta from agenti where aktivs = 1 order by pilseta,vards")
		%><select name=agents><option value="0">-</option><%
		
		while not rag.eof
			if Pieteikums("agents") = rag("id") then selected = " selected " else selected = ""
			%><option value=<%=rag("id")%> <%=selected%>><%=decode(rag("pilseta"))%>><%=decode(rag("vards"))%> </option><%
			rag.movenext
		wend
		%></select><%
		''DbComboPlus "Agenti","vards","id","Agents",Pieteikums("Agents")
	%><%
else
 %><a href = "agenti.asp">Aìenti</a> <input type=hidden value=<%=getnum(Pieteikums("Agents"))%> name=agents><%
 if getnum(Pieteikums("Agents"))<>0 then
  Response.Write decode(conn.execute("select vards from agenti where id = "+cstr(pieteikums("agents")))(0))
 end if
end if
%>
<% if getnum(Pieteikums("Agents"))<>0 or kom>0 then %>
 <a href=agentu_komisija.asp?pid=<%=pid%> target=komisija>Komisija (<%=kom%>)</a><br>
<% end if %>
<% if carter = 1 then %>
<a href = "carter_firmas.asp">Èartera firma</a> <%DbComboPlus "Carter_firmas","nosaukums","id","carter_firma",Pieteikums("carter_firma")%><br>
<% end if %>

<td align="center" colspan = 2>
<input type="hidden" name="did" value="<%=id%>"></td>
<input type="hidden" name="oid" value="<%=oid%>"></td>
<input type="hidden" name="vu" value="<%=vu%>"></td>


<% if isnew then %>
    <SCRIPT Lang="JScript">
    function CheckPakalp(){return true;}
    </SCRIPT>
<% elseif rVietVeid.recordcount <> 0 or gr_veids = 2 then %>
	<SCRIPT Lang="JScript">
	  $(function() {
	  
		 window.globalIrIevietots = "";
		
	  })

	  function UpdateCheckPakalp(status){
		
		 //alert(status);
		 if (status == 'ievietots'){
		  window.globalIrIevietots = "1";
		  }
		  if (status== 'iznemts'){
			window.globalIrIevietots = "0";
		  }
	  }
	  function CheckPakalp(izlaist_viesn_parb) {  
  
		 <% if gv = false then %>
			
			var coll = document.forms[0].elements;
			<% if getnum(kompleks) = 1 then %>
				var error_msg = "";
			  if (coll.sakuma_datums.value == '') {
				error_msg += 'Kompleksajam pasûtîjumam jânorâda sâkuma datumu.\n';
				//	alert('Kompleksajam pasûtîjumam jânorâda sâkuma datumu.');
				//return false;
			  }
			  if (coll.beigu_datums.value == '') {
				 error_msg += 'Kompleksajam pasûtîjumam jânorâda beigu datumu.';
				 //alert('Kompleksajam pasûtîjumam jânorâda beigu datumu.');
				 //return false;
			  }
			  if (error_msg != ""){
				alert(error_msg);
				return false;
			  }
			  
			  if ((compareDates(coll.sakuma_datums.value,'d/M/y',coll.beigu_datums.value,'d/M/y')!=0) && (compareDates(coll.sakuma_datums.value,'d.M.y',coll.beigu_datums.value,'d.M.y')!=0)){
				 alert('Nepareizi norâdîti datumi!');
				 return false;
			  }
			<% end if %>

			var ir_viesnica=0;
			var ir_ievietots = 0;
			if (coll!=null) {
			   for (i=0; i<coll.length; i++) 
				{

					//console.log(coll.item(i).name);
					if (coll.item(i).name.substring(0,9) == 'viet_veid')
					{
						 if (coll.item(i).value == '0')
						 {
							 alert('Nav pilnîgi norâdîti visi pakalpojumi.');
							 return false;
						 }
					} 
					else if (coll.item(i).name.substring(0,3) == 'vid')
					{
						ir_viesnica = 1
					
						 <% if pid=0 then %>
						 if (coll.item(i).value == '0')
						 {
						  
							alert('Persona nav ievietota viesnîcas numurâ');
							//return false;
							return true; // TODO: jâsalabo!! jâbût false. 
						 }
						 <%
						 else
							
							set numurins = conn.execute("SELECT isnull(vid,0) as vid FROM piet_saite WHERE pid="+cstr(pid)+" AND deleted=0")
										
							if not numurins.eof then
								while not numurins.eof
									%>
									//alert("<%=numurins("vid")%>")
									<%
									if cstr(numurins("vid")) <> "0" then
										%>
										ir_ievietots = 1
										<%									
									end if
									numurins.moveNext
								wend 
							end if						
						end if
						%>
					}
				}
				//alert("global_irieveitots:"+window.globalIrIevietots);
				//alert("pid:" + "<%=cstr(pid)%>")
				//alert("ir viesniica:"+ir_viesnica)
				//alert("ir_ievietots:"+ir_ievietots)

				if ( window.globalIrIevietots == "1"){
					//alert("Îr ieveietots");
				}
				else{
					if (<%=cstr(pid)%> != 0 && ((ir_viesnica == 1 && ir_ievietots == 0) || window.globalIrIevietots == "0"))
					{					
						alert('Persona nav ievietota viesnîcas numurâ');
						return false;						
					}
				}
			}
		<% end if %>
		<% if carter = 1 then %>
			if (coll.item('carter_firma').value=='0')
			{
				alert('Norâdiet èartera firmu.');
				return false;
			}
		<% end if %>
		return true;
	  }
  </SCRIPT>
<% else %>
  <SCRIPT Lang="JScript">
	function CheckPakalp(){return true;}
  </SCRIPT>
<% end If

if kajite_sk > 1 then 

	set rPieteikums = conn.execute ("select id from vietu_veidi where gid = "&gid&" /*and tips = 'P'*/")

%>
  <SCRIPT Lang="JScript">
  function CheckKaj_OLD() {
  var coll = document.forms[0].elements;
  console.log(coll);
  if (coll!=null) 
  {
    for (i=0; i<coll.length; i++) {
	console.log(coll.item(i).name.substring(0,13));
	console.log(coll.item(i).value);
    
	 <% if not rPieteikums.eof then %>
	 //papildus paarbaudei, ka jaanoraada kajiites, nosaciijums to nenemt veera, ja tiek noraadiita autobusa papildvieta
     if ((coll.item(i).name.substring(0,13) == 'kvietas_veids')&&(coll.item(i+1).value != '<%=rPieteikums("id")%>'))
  			{
  			if (coll.item(i).value == '00')
  				{
  				alert('Nav pilnîbâ norâdîta informâcija par kajîtçm.');
  				return false;
  				}
  			}
	<% end if %>
    }

  }
  return true;
  }
  
   function CheckKaj() {
    <% 'grupas vadîtâjam nevaic pârbaudi
 if gv = false then %>
  var coll = document.forms[0].elements;
  console.log(coll);
  if (coll!=null) 
  {

    for (i=0; i<coll.length; i++) {
	//console.log(coll.item(i).name.substring(0,13));
	//console.log(coll.item(i).value);
    
	 <% if not rPieteikums.eof then %>
	 //papildus paarbaudei, ka jaanoraada kajiites, nosaciijums 
     if (coll.item(i).name.substring(0,13) == 'kvietas_veids')
  			{
  			if (coll.item(i).value != '00')
  				{
  				return true;
  				}
  			}
	<% end if %>
    }

  }
	alert('Nav pilnîbâ norâdîta informâcija par kajîtçm.');
  	return false;
	<% else%>
	return true;
	<% end if %>
  }
  </SCRIPT>
<% else %>
  <SCRIPT Lang="JScript">
  function CheckKaj() {return true;}
  </SCRIPT>
<% end if %>

<center><br>
<% 

if pid <> 0 then
	if iemsk = 0 then 
		response.write "Operâcijas nav veiktas"
	else
		response.write "Naudas operâcijas"
	end if %>

<br>

<!--@ 0 Iemaksu tabula -->
<% 

if iemsk > 0 then 

%>
<table border=0 >
<tr bgcolor=#ffc1cc>
<td>.</td>
<td align="left">Maksâtâjs</td>
<td align="left">Datums</td>
<td align="right">Summa</td>
<td align="right">Val</td>
<% if nullprint(rCurGrupa("valuta")) = "XXX" then %>
 <td align="right">Par LVL</td>
 <td align="right">Par USD</td>
 <td align="right">Par EUR</td>
<% else %>
 <td align="right">Bilance</th>
<% end if %>
<%
'avansa grupâm kolonna ar summâm //RT 04.03.2019
if InStr(1, nullprint(grupas_l("v")), "!Avanss", 1) = 1 then
	avansa_grupa = true
else	
	avansa_grupa = false
end if
if avansa_grupa then
%>
	<td>Summa</td>
<% end if %>
<td align="right">.</td>

<%if isaccess(T_PARADS) then %>
	<!--td align="right" width="150">Uz parâdu</td-->
<%end if%>

</tr>
<%
orderu_atlaides = 0
summaLVL = 0
summaUSD = 0
summaEUR = 0
k_summa = 0
ir_izmaksa = false
while not iemaksas.EOF
 if iemaksas("parbaude") = true then 
  rowcolor = "RED"
 elseif iemaksas("online")=true then
  rowcolor = "GREEN"
 else
  rowcolor = "BLACK"
 end If
 
 If iemaksas("deleted") = 1 Then
	rowcolor = "#CCCCCC"
 End if
    if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) and iemaksas("zils") then
		response.write "<tr bgcolor=lightblue>"
	else
		response.write "<tr>"
	end if
	if not isaccess(T_DROSIBA) then
	response.write("<td><a href = 'ordedit.asp?oid="+cstr(iemaksas("id"))+"&valuta="+nullprint(rCurGrupa("valuta"))+"'><img src='impro/bildes/k_zals.gif'></a></td>")
	else
	response.write("<td><img src='impro/bildes/k_zals.gif'></td>")
	end If
	
	If iemaksas("deleted") = 1 Then
		response.write "<td><font color="+rowcolor+">dzçsts</td>"
	Else
		response.write "<td><font color="+rowcolor+">"+nullprint(iemaksas("kas"))+"</td>"
	End if
	response.write "<td><font color="+rowcolor+">"+dateprint(iemaksas("datums"))+"</td>"

	'attelot zîmi pie latiem, ja notikusi euro konvertâcija
	zime = ""
	If nullprint(iemaksas("kas")) = "KONVERTACIJA" Then
		zime = "-"
	End If
	
	if nullprint(iemaksas("pid")) = nullprint(pid) then 
		ir_izmaksa = false
		response.write "<td align = 'right'><font color="+rowcolor+">"+zime+currprint(getnum(iemaksas("summaval")))+"</td>"
	else
		ir_izmaksa = true
		response.write "<td align = 'right'>-<font color="+rowcolor+">"+zime+CurrPrint(getnum(iemaksas("summaval")))+"</td>"
	end if 
	response.write "<td align = 'right'><font color="+rowcolor+">"
	valuta = ""
	if not isnull(iemaksas("valuta")) then valuta = id_field("valuta",iemaksas("valuta"),"val")
	response.write valuta
	response.write "</td>"
	if nullprint(rCurGrupa("valuta"))<>"XXX" THEN
	 if nValuta = "USD" then
	  if iemaksas("valuta") = 68 then
	   summa = iemaksas("summaval")
	  else
	   rRate = conn.execute("select kurss2 from valutakurss where valuta = 68 and datums = '"+sqldate(iemaksas("datums"))+"'" )
	   summa = round(iemaksas("summa")*rRate("kurss2")*100)/100
	  end if
	 else
	  summa = iemaksas("summa")
	 end if
	 if nullprint(iemaksas("pid")) = nullprint(pid) then 
		response.write "<td align = 'right'><font color="+rowcolor+">"
	 if (getnum(iemaksas("summaLVL"))=0 and getnum(iemaksas("summaUSD"))=0 and getnum(iemaksas("summaEUR"))=0)then 
	    response.write currprint(iemaksas("summaval"))
	 else 
	   response.write curr3print2(iemaksas("summaLVL"),iemaksas("summaUSD"),iemaksas("summaEUR"))
	 end if
	  response.write +"</td>"
 	elseif nullprint(iemaksas("nopid")) = nullprint(pid) and nullprint(iemaksas("nopid")) <> 0 then
		 response.write "<td align = 'right'>-<font color="+rowcolor+">"+CurrPrint(getnum(iemaksas("summaval")))+" "+id_field("valuta",iemaksas("valuta"),"val")+"</td>"
	 else
	  response.write "<td align = 'right'><font color="+rowcolor+">"+curr3print2(-iemaksas("summaLVL"),-iemaksas("summaUSD"),-iemaksas("summaEUR"))+"</td>"
	 end if	
	else
	 '-- par LVL
	 iemaksasLVL = 0
	 If iemaksas("deleted") <> 1 then
		 if nullprint(iemaksas("pid")) = nullprint(pid) then 
		  iemaksasLVL = getnum(iemaksas("summaLVL"))
		 end if
		 if nullprint(iemaksas("nopid")) = nullprint(pid) then 
		  iemaksasLVL = - getnum(iemaksas("nosummaLVL"))
		 end if	
		 summaLVL = summaLVL + iemaksasLVL
     End if
	 response.write "<td align = 'right'><font color="+rowcolor+">"+currprint(iemaksasLVL)+"</td>"
	 '-- par USD
	 If iemaksas("deleted") <> 1 then
		 if nullprint(iemaksas("pid")) = nullprint(pid) then 
		  iemaksasUSD = getnum(iemaksas("summaUSD"))
		 end if
		 if nullprint(iemaksas("nopid")) = nullprint(pid) then 
		  iemaksasUSD = - getnum(iemaksas("nosummaUSD"))
		 end if	
		 summaUSD = summaUSD + iemaksasUSD
     End if
	 response.write "<td align = 'right'><font color="+rowcolor+">"+currprint(iemaksasUSD)+"</td>"
	 '-- par EUR
	 If iemaksas("deleted") <> 1 then
		 if nullprint(iemaksas("pid")) = nullprint(pid) then 
		  iemaksasEUR = getnum(iemaksas("summaEUR"))
		 end if
		 if nullprint(iemaksas("nopid")) = nullprint(pid) then 
		  iemaksasEUR = - getnum(iemaksas("nosummaEUR"))
		 end if	
		 summaEUR = summaEUR + iemaksasEUR
	 End if
	 response.write "<td align = 'right'><font color="+rowcolor+">"+currprint(iemaksasEUR)+"</td>"
	end if
	if (avansa_grupa) then
	 If iemaksas("deleted") <> 1 Then 
		if (ir_izmaksa) then 
			k_summa = k_summa - getnum(iemaksas("summaval"))
		else
			k_summa = k_summa + getnum(iemaksas("summaval"))
		end if	
		k_summa_str = currprint(k_summa)
	else
		k_summa_str = ""
	 end if
		
		%>
		<td align="right">
			<%=k_summa_str%>
		</td>
	<% end if %>
	<td align="right">
		<% If iemaksas("deleted") = 0 Then %>
		<input type="image" alt="Operâcija tiek dzçsta no datu bâzes." name="dzest" src="impro/bildes/dzest.jpg" onclick="TopSubmit(&quot;ord_del.asp?oid=<%=cstr(iemaksas("id"))%>&quot;)" >
		<% End If %>
		</td><%
	if false and (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) then
     %><td align="right"><input type=checkbox name="" <%if iemaksas("zils") = "1" then Response.Write " checked "%>></td><%
	end if
	
	if isaccess(T_PARADS) then
		%>	<td align="right" width="100">
				<input type="hidden" name="parads_<%=cstr(iemaksas("id"))%>" value="0" />
				<input type="button" name="parads" value="Parâds" onclick="javascript:form.parads_<%=cstr(iemaksas("id"))%>.value = 1;TopSubmit('parads.asp?oid=<%=cstr(iemaksas("id"))%>&pid=<%=pid%>')" />
			</td>
		<%
	end if

	response.write "</tr>"
	iemaksas.movenext
wend
%>
<tr bgcolor=#ffc1ac>
<% 
if avansa_grupa then
 colspan = "6"
 else 
 colspan = "5"
 end if%>
<td colspan="<%=colspan%>" align="right">Kopâ:</td>
<% if nullprint(rCurGrupa("valuta"))<>"XXX" THEN %>
 <td align="right"><%=Curr3Print2(rCurPiet("iemaksasLVL")-rCurPiet("izmaksasLVL"),rCurPiet("iemaksasUSD")-rCurPiet("izmaksasUSD"),rCurPiet("iemaksasEUR")-rCurPiet("izmaksasEUR"))%></td>
<% else %>
 <td align="right"><%=currprint(summaLVL)%></td>
 <td align="right"><%=currprint(summaUSD)%></td>
 <td align="right"><%=currprint(summaEUR)%></td>
<% end if %>
<td></td>
</tr>
<%
end if
%>
</table>

<% 
if not isaccess(T_DROSIBA) then %>
<br><center>
<a href=orderis.asp?pid=<%=pid%>><img style="border:none" src="impro/bildes/iemaksa.jpg" border=0 alt="Tiek atvçrts logs, kurâ jus varat reìistrçt jaunu iemaksas orderi." WIDTH="116" HEIGHT="25"></a>
<input type="image" name="izmaksa" src="impro/bildes/izmaksa.jpg" alt="Tiek atvçrts logs, kurâ jus varat reìistrçt jaunu izmaksas orderi." WIDTH="116" HEIGHT="25">
<input type="image" name="parskaitituz" src="impro/bildes/parskaitituz.jpg" onclick="TopSubmit('piet_parsk.asp?op=uz&did=<%=did%>')" alt="Pârskaitît no ði pieteikuma kâdu naudas summu uz citu pieteikumu. Tiks atvçrts logs, kurâ jums jâatrod dalîbnieks ar attiecîgo pieteikumu uz kuru jûs gribat pârskaitît. Pçc tam, kad dalîbnieks atrasts nospiediet pogu PÂRSKAITÎT pretî attiecîgajam pieteikumam." WIDTH="116" HEIGHT="25">
<input type="image" name="parskaititno" src="impro/bildes/parskaititno.jpg" onclick="TopSubmit('piet_parsk.asp?op=no&did=<%=did%>')" alt="Pârskaitît naudas summu no cita pieteikuma uz ðo pieteikumu. Tiks atvçrts logs, kurâ jums jâatrod dalîbnieks ar attiecîgo pieteikumu no kura jûs gribat pârskaitît. Pçc tam, kad dalîbnieks atrasts nospiediet pogu PÂRSKAITÎT pretî attiecîgajam pieteikumam." WIDTH="116" HEIGHT="25">
<br>
 <a href=c_davanu_kartes.php?pid=<%=pid%>>[Pârskaitît no DK]</a>
<% if isaccess(T_NORAKSTIT) and pid<>0 then %>

 <a href=piet_norakstit.asp?pid=<%=pid%> target=_norakstit>[Norakstîðana] <%=Curr3Print2(rCurPiet("norakstitsLVL"),rCurPiet("norakstitsUSD"),rCurPiet("norakstitsEUR"))%></a>

 <a href=recalculate.asp?pid=<%=pid%>>[Konvertet uz EUR]</a>


<% end if 'T_NORAKSTIT%>
<% end if 'T_DROSIBA%>
<% end if 'pid <> 0 iemaksu saakumaa %>
<% end if 'isnew kas saakas pie datuma%>
<br><br>


 <a HREF="#" onclick = "openModalTermini();return false;">Maksâjumu termiòi</a>
</form>
<script>
function PopupCenter(url, title, w, h) {
      // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var systemZoom = width / window.screen.availWidth;
	var left = (width - w) / 2 / systemZoom + dualScreenLeft
	var top = (height - h) / 2 / systemZoom + dualScreenTop
    var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w / systemZoom + ', height=' + h / systemZoom + ', top=' + top + ', left=' + left);

    // Puts focus on the newWindow
    if (window.focus) newWindow.focus();
}
 function openModalTermini(){
	PopupCenter('c_maks_termini.php?pid=<%=pid%>','_',500,200);
  

 }
</script>

<!-- forma viena lîguma izveidoðanai -->
<form name=fligums method=POST action=ligums.asp>
	<input type=hidden name=ligums value=<%=pid%>>
</form>

<%
checkGroupBlocked(gid)
checkDalibnInGroup did,gid
%>
<script type="text/javascript"> 

function checkSubmit(){
	
	//alert(document.getElementById("submit_form").value);
	//console.log(document.getElementById("submit_form"));
	if(document.getElementById("submit_form") != null){
		if ( document.getElementById("submit_form").value==1)
			return false;
		else
		{
			document.getElementById("submit_form").value = 1;
			return true;
		}
	}
}
</script>

<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>
<!--


function find_group() 
{
	var s;
	var s2;
	var direction = '';
	var f = 1;
	s = forma.fin.value;
	s = s.toLowerCase();
	s = ConvertAlpha(s);
	var search = 0;
	for (i=forma.gID.selectedIndex;i<=forma.gID.length-1;i++)
	{
		forma.gID.selectedIndex = i;
		s2 = forma.gID.options(forma.gID.selectedIndex).text;
		s2 = s2.toLowerCase();
		s2 = ConvertAlpha(s2);
		if (s2.indexOf(s)>=0 && search==1)
		 break;
		search = 1;
	}
	forma.gID.onchange();
}

function ConvertAlpha(s)
{
	var ret;
	ret = '';
	var i;
	for (i=0;i<s.length;i++)
	{
		if (s.substr(i,1)=='â')
			ret = ret + 'a';
		else if (s.substr(i,1)=='è')
			ret = ret + 'c';
		else if (s.substr(i,1)=='ç')
			ret = ret + 'e';
		else if (s.substr(i,1)=='ì')
			ret = ret + 'g';
		else if (s.substr(i,1)=='î')
			ret = ret + 'i';
		else if (s.substr(i,1)=='í')
			ret = ret + 'k';
		else if (s.substr(i,1)=='ï')
			ret = ret + 'l';
		else if (s.substr(i,1)=='ò')
			ret = ret + 'n';
		else if (s.substr(i,1)=='ð')
			ret = ret + 's';
		else if (s.substr(i,1)=='û')
			ret = ret + 'u';
		else if (s.substr(i,1)=='þ')
			ret = ret + 'z';
		else
			ret = ret + s.substr(i,1);
	};
	return ret;
}

//-->
</SCRIPT>

<script  Lang="JScript"> 
function checkPiezimes(){
	$("#grupas_vad_label").css("color","black");
		if ($("#ppiezimes").val()==="GRUPAS VADÎTÂJS" ||$("#ppiezimes").val()==="GRUPAS VADÎTÂJA" ){
		
			if($("#grupas_vad").is(":checked")==false){
				
				alert("Ja ðîs ir GRUPAS VADÎTÂJA pieteikums, lûdzu, ielieciet íeksi pie 'Grupas vadîtâjs'!");
				$("#grupas_vad_label").css("color","red");
				return false;
			}
			else{
			
			
			}
		}
		return true;
}
$(function(){

	$("#ppiezimes").on('change',function(){
	
		checkPiezimes();
	})
})
function changePiezimes(obj){
	/*console.log(obj.checked);
	var grupas_vad = obj.checked;
	if (grupas_vad){
		$readonly = true;
		$piezimes="GRUPAS VADÎTÂJS";
	}
	else {
		$readonly  = false;
		$piezimes = "<%=nullprint(pieteikums("piezimes"))%>"
	}
	 document.getElementById("ppiezimes").value=$piezimes;
	 $('#ppiezimes').prop('readonly', $readonly);*/
	
}
</script>	

</body>
</html>

