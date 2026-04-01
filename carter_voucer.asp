<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "inc\site.asp" -->
<!-- #include file = "inc\functions_a.asp" -->
<!-- #include file = "inc\connect_a.asp" -->
<!-- #include file = "inc\secure_a.asp" -->




<%

''---------------------------------------------------------------------------
''------------------------------ Ðis fails ir vienâds globâ un aìentu sistçmâ
''------------------------------ Veicot izmaiòas vajag nokopçt uz otru sistçmu
''---------------------------------------------------------------------------

Set db = new cls_db


dim rez_id, ligums_id, pid, r, ssql, celojuma_nos, pak
dim izbr_dat, izbr_laiks, iebr_datums, iebr_laiks, viesnicas_nos, istabas_veids
dim d_vards, d_uzvards, ielid_laiks_uz, ielid_laiks_no

SET sGet = secured.s_Get()
pid = sGet("pid")


If pid = "" Then
	SET sPost = secured.s_Post()
	pid = sPost("pid")
End if

'pârbauda, vai nav jau uzìenerçts pdf dokuments
dim filename
set voucer =  db.conn.execute("select isnull(carter_voucer_file_name,'') as filename, isnull(carter_voucer,0) from pieteikums where id = "+CStr(pid))
filename = voucer(0)
izdrukats = voucer(1)

'response.write(cstr(izdrukats))
'if filename <> "" and izdrukats <> "0" then
if izdrukats = true and false then
	'vauceris jau ir uzìenerçts, tikai jâattçlo
	response.write("exists")
	'response.end
	
	%>
	<form name="hbpost" action="https://www.impro.lv/mpdf/carter_voucer.php" method="post">
		<input type="hidden" name="filename" value="<%=filename%>"	>
		<input type="hidden" name="pid" value="<%=pid%>"	>
		
	</form>
	<script>
		document.hbpost.submit();
	</script>
	<%

	Response.End
	
else
	
	'response.end
	'dabonam grupas id
	Dim gid
	gid = db.conn.execute("select gid from pieteikums where id = "+CStr(pid))(0)

	'dabonam voucer informâciju
	Dim lidojums1
	Dim lidojums2
	Dim lidojums_info
	Dim beigu_teksts
	Dim n_lidojums
	Dim n_viesnica
	Dim n_ekskursija

	Dim rvoucer
	Set rvoucer = server.createobject("ADODB.Recordset")
	rvoucer.open "select * from voucer where gid = "+CStr(gid),db.conn,3,3
	If Not rvoucer.eof Then
		lidojums1 = decode(rvoucer("lidojums1"))
		lidojums2 = decode(rvoucer("lidojums2"))
		lidojums_info = decode(rvoucer("lidojums_info"))
		beigu_teksts = decode(rvoucer("beigu_teksts"))
		n_lidojums = rvoucer("n_lidojums")
		n_viesnica = rvoucer("n_viesnica")
		n_ekskursija = rvoucer("n_ekskursija")
	End if


	ssql = "select reiss_no, reiss_uz, ligums_id, ps.vid, isnull(cv.nosaukums,'') as viesnica, d.vards, d.uzvards, isnull(vv.nosaukums,'')+isnull(vv.piezimes,'') as istaba,g.sakuma_dat, g.beigu_dat, g.izbr_laiks, g.iebr_laiks, isnull(g.ielid_laiks_uz,'') as ielid_laiks_uz, isnull(g.ielid_laiks_no,'') as ielid_laiks_no, p.globa_rez, d2.vards as z_vards, d2.uzvards as z_uzvards, isnull(p.carter_voucer, 0) as carter_voucer " + _
			"from pieteikums p " + _
			"inner join grupa g on g.id = p.gid " + _
			"inner join piet_saite ps on ps.pid = p.id " + _
			"left join viesnicas v on v.id = ps.vid " + _
			"left join viesnicas_veidi vv on vv.id = v.veids " + _
			"inner join dalibn d on d.id = ps.did " + _
			"inner join carter_viesnicas cv on cv.id = g.carter_viesn_id " + _
			"left join dalibn d2 on d2.id = p.zid " + _
			"where p.id = "& pid &" and p.deleted = 0 and ps.deleted = 0 "
	'Response.Write(ssql)

	set r = db.conn.execute(ssql)

	while not r.eof
		if r("viesnica")<>"" then viesnicas_nos=r("viesnica")
		if r("istaba")<>"" then istabas_veids=r("istaba")

		r.movenext
	wend
	set r = db.conn.execute(ssql)
	''response.write ssql
	if r.eof then
		Response.Write "Kluda. Pieteikums nav atrasts.<br><br>"	
		Response.Write "<a href=""#"" onclick=""self.close()"">Aizvert logu</a>"
		Response.end
	end if

	rez_id=getnum(r("globa_rez"))
	ligums_id=getnum(r("ligums_id"))


	'--- parbauda vai rezervacija ir pilnibaa apmaksata (visi pieteikumi)
	'rw "-> "& rezBilanceLVL(rez_id)
	if 1=0 and rezBilanceLVL(rez_id) < 0 then
		rw "Izdrukât vauèeri var tikai pilnîbâ apmaksâtai èartera rezervâcijai."
		Response.end
	end If


	'--- ieraksta pieteikumam, ka vacueris ir izdrukats un to vairs nevar mainit.
	If r("carter_voucer") = 0 Or r("carter_voucer") = false Then
	
		query = "SELECT * FROM pieteikums WHERE id=" + cstr(pid) 
		'response.write query
		
		 'set old_vals_c = CreateDict(query) 
		
		ssql = "UPDATE pieteikums SET carter_voucer = 1 WHERE id = "& pid
		db.conn.execute(ssql)	
		
		'set new_vals_c = CreateDict(query) 
		'UpdateActionDetails old_vals_c,new_vals_c,"pieteikums",cstr(pid),""
	End if

	v_id = r("vid")
	izbr_dat=r("sakuma_dat")
	izbr_laiks=r("izbr_laiks")
	iebr_dat=r("beigu_dat")
	iebr_laiks=r("iebr_laiks")
	''viesnicas_nos=r("viesnica")
	''istabas_veids=r("istaba")
	d_vards=r("vards")
	d_uzvards=r("uzvards")
	reiss_uz=nullString(r("reiss_uz"))
	reiss_no=nullString(r("reiss_no"))

	if reiss_uz = "" then
		If datePrint(izbr_dat) = "15.09.2014" Then
			reiss_uz = "FHY 638"
		Else
			reiss_uz = "FHY 634"
		End if
	end if

	if reiss_no = "" then
		reiss_no="FHY 633"
	end if


	'--- zidainis
	z_vards = r("z_vards")
	z_uzvards = r("z_uzvards")

	'ielid_laiks_uz = r("ielid_laiks_uz") '--- ielidosnas laiks uz merkji
	'ielid_laiks_no = r("ielid_laiks_no") '--- izlidosanas laiks no merkja

	if r("ielid_laiks_uz") = "01.01.1900" then 	ielid_laiks_uz = "" else ielid_laiks_uz = timeprint2(r("ielid_laiks_uz"))
	if r("ielid_laiks_no") = "01.01.1900" then 	ielid_laiks_no = "" else ielid_laiks_no = timeprint2(r("ielid_laiks_no"))


	''celojuma_nos = "Atpûta Afrodîtes ðûpulî Kipras salâ"

	'--- ja globas rez_id=0, parejos dalibniekus meklee peec viesnicas numura
	'--- atpakalsavietojamibai - globas pieteikumiem pirms carter rezervaacijas izmainjaam.
	If rez_id=0 and ligums_id=0 Then

		globas_rez_c = "and p.id = "&pid

	Else 

		globas_rez_c = "and (p.globa_rez = " & rez_id & " or (ligums_id = " & cstr(ligums_id) & " and ligums_id <> 0)) "
		
	End if

	'--- parejo rezervacijas dalibnieku vaardi
	ssql = "select distinct d.vards, d.uzvards, d.pk1, d.pk2, d2.vards as z_vards, d2.uzvards as z_uzvards from dalibn d " + _
			"inner join piet_saite ps on ps.did = d.id " + _
			"inner join pieteikums p on p.id = ps.pid " + _
			"left join dalibn d2 on d2.id = p.zid " + _
			"where ps.deleted = 0 and p.deleted = 0 and p.gid<>458 "&globas_rez_c&" and p.id <> "&pid&" " 

	set d = db.conn.execute(ssql)

	''response.write ssql
	''response.end

	ssql = "select vv.*, isnull(vv.ekskursija,0) as eksk from vietu_veidi vv " + _ 
		"inner join piet_saite ps on ps.vietas_veids = vv.id " + _
		"where ps.deleted = 0 and ps.pid = "& pid &" and (vv.tips='P' or vv.tips='X' or vv.tips='ED' or vv.tips='EX')"

	set pak = db.conn.execute(ssql)

	if not pak.eof then
		pak_ir = true
	else
		pak_ir = false
	end if


	'---- voucer html

	html = "<html>"
	html = html + "<head>"
	html = html + "<meta content=""text/html; charset=windows-1257"" http-equiv=""Content-Type"">"
	''html = html + "<meta content=""text/html; charset=utf-8"" http-equiv=""Content-Type"">"
	html = html + "<title>Impro ceïojumi - vauèers</title>"

	html = html + "<style>"
	html = html + "body { font-family:""Times New Roman"", Times, serif; font-size:12px;}"
	html = html + "table {width:708px;border:none;}"
	html = html + "table tr td {"
	html = html + "	text-align:left;"
	html = html + "	border:1px solid grey;"
	html = html + "	border-spacing:0;"
	html = html + "	border-collapse:collapse;"
	html = html + "	padding: 5;"
	html = html + "}"
	html = html + "</style>"

	html = html + "</head>"
	html = html + "<body>"
	html = html + "<table class='voucer'>"
	html = html + "<tr>"
	html = html + "<td colspan=""3"">" 
	html = html + "<p>Paldies par izvçli ceïot ar IMPRO! Lûdzu, izdrukâjiet vauèeru un paòemiet to lîdzi ceïojumâ, lai uzrâdîtu pakalpojumu sniedzçjiem – pie aviokompânijas reìistrâcijas lodziòa, transfçra autobusa vadîtâjam, viesnîcâ un, dodoties ekskursijâs. Patîkamu ceïojumu!</p>"
	html = html + "</td>"
	html = html + "</tr>"
	html = html + "<tr>"
	html = html + "<td>"
	html = html + "<img src=""../img/logo.jpg"" width=""170"" height=""108"" /></span>"
	html = html + "	</td>"
	html = html + "	<td>"			
	html = html + "		<p>IMPRO CEÏOJUMI<br />"
	html = html + "			Reì.Nr.000323562<br />"
	html = html + "			RLB namâ Meríeïa ielâ 13 – 122</p>"
	html = html + "	</td>"
	html = html + "	<td>"
	html = html + "			<p>tâlrunis: +371 67221312 <br />"
	html = html + "				e-pasts: impro@impro.lv<br />"
	html = html + "				www.impro.lv</p>"
	html = html + "	</td>"
	html = html + "</tr>	"
	html = html + "<tr>	"
	html = html + "	<td colspan=""3""><b>Booking reference / Rezervâcijas Nr. "& pid &"</b></td>"
	html = html + "</tr>"
	html = html + "</table>	"
	html = html + "<table>"
	html = html + "<tr>"
	html = html + "	<td><b>Clients/ Ceïotâji:</b><br />"
	html = html + d_vards&" "&d_uzvards&"&nbsp;"

	if z_vards<>"" and z_uzvards<>"" then html = html + "+INF: "&z_vards&" "&z_uzvards 
			
	html = html + "</td>"
	html = html + "	<td><b>Booking shared with / ðajâ paðâ rezervâcijâ:</b><br />"

			while not d.eof
				html = html + d("vards")&" "&d("uzvards")
				if d("z_vards")<>"" and d("z_uzvards")<>"" then html = html + " +INF: "&d("z_vards")&" "&d("z_uzvards")
				html = html + "<br />"
				d.movenext
			wend
			response.write html


	html = html + "	</td>"
	html = html + "</tr>"
	html = html + "<tr>	"
	html = html + "<td width=""50%"">"

	If lidojums1 = "" then
		html = html + "	<p><b>Services/ Pakalpojumi</b></p>  "
		html = html + "	Fligh/ Lidojums<br />"
		html = html + "	<b>"&datePrint(izbr_dat)&"&nbsp;&nbsp;&nbsp;"& timeprint2(izbr_laiks) &" - "& ielid_laiks_uz & "</b> (vietçjie laiki)<br />"
		html = html + "	Lidosta Rîga – Antâlija – Erdþana (RIX–AYT–ECN)<br />"
		html = html + "	Flight Nr: "+reiss_uz+"<br />"
	Else
		html = html + lidojums1
	End If

	html = html + "	</td>"
	html = html + "	<td width=""50%"">"

	If lidojums2 = "" then
		html = html + "	<p>&nbsp;</p>"
		html = html + "	Flight / Lidojums<br />"
		html = html + "	<b>"& datePrint(iebr_dat) &"&nbsp;&nbsp;&nbsp;"& ielid_laiks_no &" - "& timeprint2(iebr_laiks) &"</b> (vietçjie laiki)<br />"
		html = html + "	Erdþana – Antâlija – Lidosta Rîga (ECN–AYT–RIX)<br />"
		html = html + "	Flight Nr: "+reiss_no+"<br />"
	Else
		html = html + lidojums2
	End If

	html = html + "	</td>"
	html = html + "</tr>"	

	If n_lidojums = 0 then

		html = html + "<tr>"
		html = html + "<td colspan=""2"">"

		If lidojums_info = "" then
			html = html + "	<b>! Reìistrâcijas lodziòð Rîgas lidostâ râdîs galamçríis: “ANTÂLIJA”</b>, reìistrçðana notiek lîdz galamçríim Erdþana (Kipra)! Îsa nosçðanâs Antâlijâ ir formalitâðu kârtoðanai, klienti uzturas lidmaðînâ! <br/><b>Registration screens in airport will show destination: ANTALYA</b>, check-in will be performed til destination Ercan (Cyprus). Short stop-over in Antalya is due to technical reasons, clients do not leave the airplane. "
		Else
			html = html + lidojums_info
		End if
		html = html + "	</td>"
		html = html + "</tr>"
	End If

	If n_viesnica = 0 then
		html = html + "<tr><td colspan=""2"">"
		html = html + "		<b>Hotel / Viesnîca</b>"
		html = html + "		<br />"
		html = html + celojuma_nos &"&nbsp;"&viesnicas_nos&"&nbsp;<br />"& istabas_veids &" room – istabas veids<br />"
		html = html + "		<b>Extra services/ papildus pakalpojumi</b><br />"

		if pak_ir then
			html = html + "		<ul>"

			while not pak.eof
				if pak("tips")<>"EX" then html = html + "<li>"&pak("nosaukums")&"</li>"
				pak.movenext			
			wend
			html = html + " 	</ul> "
		else
			html = html + "			<p>-</p>"
		end If

		html = html + "	</td>"
		html = html + "</tr>"
	End if

	If n_ekskursija = 0 then
		html = html + "<tr><td colspan=""2"">"
		html = html + "		<b>Excursions/ ekskursijas</b><br />"

				if pak_ir then
					html = html + "		<ol>"
					
					pak.movefirst
					while not pak.eof
						if pak("tips")="EX" then html = html + "<li>"&pak("nosaukums")&"</li>"
						pak.movenext			
					wend
				
					html = html + "		</ol>" 
				else 
					html = html + "<p>-</p>"
				end if 

		html = html + "	</td>"
		html = html + "</tr>"
	End if


	if 1=0 then '--- pagaidâm izòemts, varbût bûs vajadzîgs vçlâk%>
	<tr><td colspan="2">
			Impro pârstâvis Kiprâ: Ms KRISTÎNE PAEGLE <!--+XXX XXXXXXX (TELEFONS) -->
		</td>
	</tr>

	<tr><td colspan="2">
			Dokuments ir sagatavots elektroniski un ir derîgs bez paraksta. 
		</td>
	</tr>
	<%end if

	html = html + "<tr><td colspan=""2"">"

	If beigu_teksts="" and lidojums_info="" then
		html = html + "<font size=""2""><p>"
		html = html + "<b>Svarîgâ informâcija Jûsu lidojuma droðîbai!</b><br />"

		html = html + "Reìistrâcija lidojumiem sâkas 2 stundas pirms un beidzas 40 minûtes pirms lidmaðînas izlidoðanas. Pirms katra brauciena iesakâm precizçt izlidoðanas laiku. Esiet uzmanîgi, bagâþâ ir aizliegts pârvadât bîstamus priekðmetus: saspiestas gâzes, kodîgas un uzliesmojoðas vielas, indes, kâ arî citus bîstamus priekðmetus. Aizliegts paturçt pie sevis: - naþus, rotaïlietas, kas imitç reâlus ieroèus un citus priekðmetus, kuri var apdraudçt pasaþieru un apkalpes locekïu droðîbu. Lidojuma droðîbas nolûkos aviokompânija aicina pasaþierus bagâþu iepakot personîgi. Visos aviokompânijas reisos lidojuma laikâ ir aizliegts smçíçt un lietot lîdzòemtos alkoholiskos dzçrienus. Katram pasaþierim, kas ir vecâks par 2 gadiem, atïauts bez maksas pârvadât ne vairâk kâ 20 kg reìistrçtas bagâþas, kâ arî 8 kg nereìistrçtas bagâþas ar noteikumu, ka tâs izmçri nepârsniedz 50/40/20 cm. Visas pasaþiera un pârvadâtâja savstarpçjâs attiecîbas regulç aviokompânijas noteikumi un starptautiskie normatîvie akti. Jebkura cita nepiecieðamâ informâcija tiks sniegta pçc Jûsu pieprasîjuma.</p><br />"
		html = html + "<p>"
		html = html + "<b>Important information for your flight safety!</b><br />"

		html = html + "Check-in for the airline's flight starts 2 hours before the departure and ends 40 minutes before the departure. Attention! On the airline's flights it is forbidden to hold and transport in baggage such dangerous subjects as: - compressed gas, acrid substances, inflammable substances, toxic substances and other dangerous goods. It is forbidden to hold: - knives, toys, imitating the real weapon and other subjects, which may threaten passengers' and crew members' safety. With a view of flight safety airline strongly recommends you to pack up your luggage personally. On the all airline's flights, during all the flight, it is forbidden to smoke and drink the alcoholic drinks, brought with you. Each passenger is allowed to transport 20 kg of the registered baggage and one place - 8 kg of unregistered baggage, under the circumstance that it's sizes do not exceed 50/40/20 cm. This rule does not apply to the children till 2 years old. All the interrelations between the passenger and carrier are regulated by the rules of the airline and the international documents. In case of necessity any other information will be provided on your request."
		html = html + "<br><br>"
		html = html + "<b>Lûdzu pârliecinieties, ka Jums ir LR pilsoòa vai LR nepilsoòa pase, kas izdota pçc 2002.gada 30.jûnija un ir derîga vismaz 6 mçneðus pçc atgrieðanâs datuma.</b>"
		html = html + "</p>"
		html = html + "</font>"
	Else
		html = html + beigu_teksts
	End if

	html = html + "</td>"
	html = html + "</tr>"
	html = html + "</table>"
	html = html + "</body>"
	html = html + "</html>"

	'--------------------
	

%>
<form name="hbpost" action="https://www.impro.lv/mpdf/carter_voucer.php" method="post">
	<input type="hidden" name="html_str" value="<%=replace(html,"""","#dblq#")%>"	>
	<input type="hidden" name="pid" value="<%=pid%>">
	
</form>
<script>
	document.hbpost.submit();
</script>
<%

Response.End


end if
%>