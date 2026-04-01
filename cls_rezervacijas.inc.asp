<%
Class cls_rezervacijas
	Private db 'database
	
	'Constructor
	Private Sub Class_Initialize()
		'Set db = new cls_db
	End Sub 

	'Destructor
	Private Sub Class_Terminate()
		Set db = Nothing
	End Sub
	
	Public Function get_reservations(user_id)
		Dim query, whereC

		whereC =  "pp.profile_id=p.profile_id and pp.deleted=0 and pp.tmp = 0 and pp.gid = p.gid and pp.online_rez = p.online_rez and pp.atcelts = 0"

		query="select distinct m.v as celojums,p.gid,p.online_rez,p.atcelts,g.sakuma_dat as datums,g.beigu_dat as beigu_datums,(select count(pp.id) from ["&Application("db_tb_pieteikums")&"] pp where "&whereC&") as personas,(select sum(pp.summa) from ["&Application("db_tb_pieteikums")&"] pp where "&whereC&") as summa,(select sum(pp.iemaksasLVL) from ["&Application("db_tb_pieteikums")&"] pp where "&whereC&") as iemaksas,(select sum(pp.izmaksas) from ["&Application("db_tb_pieteikums")&"] pp where "&whereC&") as izmaksas, p.profile_id, o.parbaude from ["&Application("db_tb_marsruts")&"] m inner join ["&Application("db_tb_grupa")&"] g on m.id=g.mid inner join ["&Application("db_tb_pieteikums")&"] p on g.id=p.gid left outer join [orderis] o on o.pid = p.id and o.deleted = 0 where p.profile_id='"&user_id&"' and p.deleted = 0 and p.tmp = 0 and p.step = 4 and p.online_rez <> 0 and p.atcelts = 0 ORDER BY p.datums;"
		'Response.Write(query)
		'Response.end
		Set get_reservations=db.Conn.Execute(query)
	End Function
	
	Public Function get_current_reservation(pids)
		Dim query, whereC

		whereC = "pp.id in ("&pids&")"

		query="select distinct m.v as celojums,p.datums as reg_datums,p.gid,g.sakuma_dat as datums,g.beigu_dat as beigu_datums, g.izbr_laiks, iv.nosaukums as izbr_vieta, (select count(pp.id) from pieteikums pp where "&whereC&") as personas,(select sum(pp.summa) from pieteikums pp where "&whereC&") as summa,(select sum(pp.iemaksasLVL) from pieteikums pp where "&whereC&") as iemaksas,(select sum(pp.izmaksas) from pieteikums pp where "&whereC&") as izmaksas, p.profile_id, o.parbaude from marsruts m inner join grupa g on m.id=g.mid inner join pieteikums p on g.id=p.gid left outer join [orderis] o on o.pid = p.id and o.deleted = 0 left join grupa_izbr_vieta iv on iv.id = g.izbr_vieta where p.id in ("&pids&") and p.deleted=0 and p.atcelts = 0;"
		'Response.Write("<br>!!!!!!!!!!!!!<br>"&query)
		'response.end
		Set get_current_reservation=Conn.Execute(query)
	End Function
	
	Public Function get_reservations_details(pids)
		
		Dim query, result, param,viesn,kaj
        
        ssql = "select isnull(ps.vid,0) as v_id, isnull(ps.kid,0) as k_id from [pieteikums] p inner join [piet_saite] ps on ps.pid=p.id left join viesnicas v on v.id = ps.vid left join viesnicas_veidi vsv on vsv.id = v.veids where p.id in ("&pids&") and ps.deleted=0 and p.deleted=0 and p.atcelts = 0 "  'and (isnull(ps.vid,0)<>0 or isnull(ps.kid,0)<>0)
		Set result = conn.Execute(ssql)
		
		'Response.Write(ssql&"<br><br>")
		
		'if NOT result.Eof Then
		
			If result("k_id")>0 Then
				param = "ps.kid"
				viesn = "kajites_veidi"
				kaj = "kajite"
			Else
				param = "ps.vid"
				viesn = "viesnicas_veidi"
				kaj = "viesnicas"
			End if
		

			query="select p.id as p_id,p.gid, pp.id as d_id, pp.id as profile_id, pp.eadr, p.iemaksas,pp.vards," +_
			"pp.uzvards,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,isnull(vv.cenaLVL,0) as cenaLVL,isnull(vv.cenaUSD,0) as cenaUSD,isnull(vv.cenaEUR,0) as cenaEUR," +_
			"ps.id as ps_id,ps.vid as v_id,isnull(ps.kid,0) as k_id, vsv.nosaukums as viesnica, vsv.vietas as vietas, " +_ 
			"isnull(ps.kvietas_cena,0) as kvietas_cena, isnull(ps.kvietas_cenaEUR,0) as kvietas_cenaEUR, isnull(ps.kvietas_veids,0) as kvietas_veids, isnull(sum(a.atlaideLVL),0) as atlaideLVL, isnull(sum(a.atlaideEUR),0) as atlaideEUR " +_
			"from pieteikums p " +_
			"inner join piet_saite ps on ps.pid=p.id " +_
			"inner join vietu_veidi vv on vv.id=ps.vietas_veids " +_
			"inner join dalibn pp on pp.id = ps.did " +_
			"left join "&kaj&" v on v.id = "&param&" " +_
			"left join "&viesn&" vsv on vsv.id = v.veids " +_
			"left join piet_atlaides a on a.pid = p.id " +_
			"where p.id in ("&pids&") and ps.deleted=0 and p.deleted=0 and p.atcelts = 0 " +_
			"group by p.id,p.gid, pp.id, pp.id , pp.eadr, p.iemaksas,pp.vards,pp.uzvards,vv.viesnicas_veids ," +_
			"vv.id ,vv.tips ,vv.nosaukums,vv.cenaLVL,vv.cenaUSD,vv.cenaEUR,ps.id, ps.vid ,ps.kid, vsv.nosaukums, vsv.vietas, ps.kvietas_cena, ps.kvietas_cenaEUR, ps.kvietas_veids " +_
			"order by p_id;"
			
			'Response.Write(query&"<br><br>")
			'response.End 
			Set get_reservations_details=Conn.Execute(query)
		
		'--- globas versija. iznjemts, jo query rez neatskiras. online varbuut ir savadak.
		'else
			'---ja nav naktsmitnes tad atgriezh parejo rezervacijas informaciju. 09/08/2010 Nils
			'query="select p.id as p_id,p.gid, pp.id as d_id, pp.id as profile_id, pp.eadr, p.iemaksas,pp.vards,pp.uzvards,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,vv.cenaLVL, ps.id as ps_id,ps.vid as v_id,ps.kid as k_id, '' as viesnica, '' as vietas, 0 as kvietas_cena, a.atlaideLVL as atlaide from pieteikums p inner join piet_saite ps on ps.pid=p.id inner join vietu_veidi vv on vv.id=ps.vietas_veids inner join dalibn pp on pp.id = ps.did left join piet_atlaides a on a.pid = p.id where p.id in ("&pids&") and ps.deleted=0 and p.deleted=0 and p.atcelts = 0 order by p_id;"
			'response.write query&"<br>nav naktsmitnes"
			''Response.end
			'Set get_reservations_details=Conn.Execute(query)

		'end if
		
	End Function
	
	' Added on 03.02.09 by Igors Kresotvs [ not optimizded]

	Public Function save_ligums(ligums, gid)
			Dim query, result
			'query = "select * from ligumi where did = '"&did&"' and gid = '"&gid&"' and deleted = 0"
			'Set result = db.Conn.Execute(query)
			'If result.EOF then
				'ligums = replace(ligums, "Iepazîðanâs ar LÎGUMU", "LÎGUMS")
				'ligums = replace(ligums, "<br><a href=""http://www.adobe.com/products/acrobat/readstep.html"" target=""_blank""><img src=""http://www.adobe.com/images/shared/download_buttons/get_adobe_reader.gif""></a>", "")
				
				ligums = Replace(ligums,"'","''")
				query = "Set Nocount on; Insert into ligumi (ligums, gid, accepted, accepted_date) values ('"&ligums&"', '"&gid&"', 1, getdate()); Select @@IDENTITY as id"
				Set result = Conn.Execute(query)
				save_ligums = result("id")
				
			'End if
	End function
	
	
	public function accept_ligums(rez_id)
		' ieliek atziimi, ka ligumam piekritis + ieraksta liguma id rezervacijas tabulâ.
		
		Dim query, result, l_id
		
		'Response.Write("<br>"&rez_id)
		
		if rez_id = "" then
			accept_ligums = false
			exit function
		end if
		
		query = "SELECT id FROM ligumi WHERE deleted=0 AND rez_id="&rez_id
		Set result = db.Conn.execute(query)	
		
		if result.eof then
			accept_ligums = false
			exit function
		end if

		l_id = result("id")
		
		query= "UPDATE ligumi SET accepted = 1, accepted_date = getdate() WHERE deleted=0 AND id = "&l_id&"; " + _
			   "UPDATE online_rez SET ligums_id = "&l_id&" WHERE id = "&rez_id&";"
		
		'Response.Write("<br>"&query)
		
		db.Conn.execute(query)	
		
		accept_ligums = true
	
	end function

	public function check_ligums_and_orders(rez_id, payment_type)
	
		'--- parbauda vai eksiste rez ligums un orderi, ja nav, tad izveido.
		'--- tie var nebuut, ja cilveks nav normaali atgriezies peec apmaksas uz rezervacijas sistemu.
		'--- payment_type = "ib" swedbanka; "mk" ar kreditkarti; "dnbnord"; "seb";
				

		Dim ssql, r_ligums, r_orders, res, result, r_profils
		Dim ligums, orders, profile_id, email, l_id
		
		ligums = 0
		orders = 0
		profile_id = Session("user_id")
		
		ssql = "SELECT * FROM online_rez WHERE id = '"&rez_id&"'"
		Set r_profils = db.Conn.execute(ssql)
			
		if profile_id = "" then 'kad izpilda payment_status_service.asp sessija ir tuksa
								'izvelk profile_id no baazes
				
			profile_id = r_profils("profile_id")
			
		end if			
		
		
		'Set res = new cls_rezervacijas
		
		'--- check ligums exists
		ssql = "SELECT id FROM ligumi WHERE deleted=0 AND accepted = 1 AND rez_id = '"&rez_id&"'"
		'Response.Write(ssql&"<br>")
		Set r_ligums = db.Conn.execute(ssql)	
		
		if r_ligums.eof then
			
			res = accept_ligums(rez_id)
			ligums = 1
		else
			'---parbauda vai rezervacijai ir liguma numurs
			
			l_id = r_profils("ligums_id")
			
			if isnull(l_id) or l_id=0 then
			
				query= "UPDATE online_rez SET ligums_id = "&r_ligums("id")&" WHERE id = "&rez_id&";"
				db.Conn.execute(query)	
				
			end if
		end if
		
		
		'--- check orders exists
		ssql = "SELECT o.* FROM orderis o INNER JOIN pieteikums p ON p.id = o.pid " +_
				"WHERE o.deleted = 0 AND p.deleted = 0 AND p.step = '4' AND p.online_rez = '"&rez_id&"'"
		
		Set r_orders = db.Conn.execute(ssql)
			
		if r_orders.eof then
			
			res = create_db_orders(rez_id, payment_type)
			orders = 1
		end if
			
		
		'--- send confirmation email
		if (ligums=1 and orders=1) then
		
			ssql = "SELECT * FROM [profili] WHERE [id] = "&profile_id
			Set result = db.Conn.execute(ssql)	
				
			If result("eadr_new") <> "" Then
				eadr = result("eadr_new")
			Else
				eadr = result("eadr")
			End if
 
			'response.redirect(Application("site_base_url")&"send_email.asp?type=confirm&rez_id="&rez_id&"&recipient="&eadr)
			
			if not IsObject(email) then
				Set email = new cls_email
			end if
			
			res = email.ReservationConfirmation(rez_id,0,eadr)	
			
			Response.Write("<br>confirmation email sent to "&eadr)
			
		end if	
		
	end function	

	Public Function get_reservations_details_by_pieteikums(rez_id, p_id,profile_id)
		Dim query, result, param,viesn,kaj
		query = "select ps.vid as v_id,ps.kid as k_id from [pieteikums] p inner join [profili] pp on pp.id = p.profile_id inner join [piet_saite] ps on ps.pid=p.id left join viesnicas v on v.id = ps.vid left join viesnicas_veidi vsv on vsv.id = v.veids where p.online_rez='"&rez_id&"' and p.profile_id='"&profile_id&"' and ps.deleted=0 and p.deleted=0 and p.tmp = 0 and p.atcelts = 0 and ((ps.vid is not null) or (ps.kid is not null) ) "
		Set result = db.Conn.Execute(query)
		
		
		If result.EOF Then '--- labots 09/08/2010 Nils. lai izpilditos grupam bez naktsmitnem
			query="select p.id as p_id, p.did as d_id, pp.id as profile_id,p.iemaksas,d.vards,d.uzvards,d.pk1,d.dzimta,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,vv.cenaLVL, ps.id as ps_id,ps.vid as v_id,ps.kid as k_id, '' as viesnica from ["&Application("db_tb_pieteikums")&"] p inner join ["&Application("db_tb_profili")&"] pp on pp.id = p.profile_id inner join ["&Application("db_tb_piet_saite")&"] ps on ps.pid=p.id inner join["&Application("db_tb_dalibnieki")&"] d on d.id = p.did inner join ["&Application("db_tb_vietu_veidi")&"] vv on vv.id=ps.vietas_veids where p.online_rez="&rez_id&" and p.id="&p_id&" and p.profile_id='"&profile_id&"' and ps.deleted=0 and p.tmp = 0 and p.atcelts = 0 order by p_id, vv.tips;"			
			'Response.Write query
			Set get_reservations_details_by_pieteikums = db.Conn.Execute(query)
			
		else
		
		if result("k_id")>0 Then
			param = "ps.kid"
			viesn = "kajites_veidi"
			kaj = "kajite"
		Else
			param = "ps.vid"
			viesn = "viesnicas_veidi"
			kaj = "viesnicas"
		End if
		query="select p.id as p_id, p.did as d_id, pp.id as profile_id,p.iemaksas,d.vards,d.uzvards,d.pk1,d.dzimta,vv.viesnicas_veids as veids,vv.id as vid,vv.tips as vtips,vv.nosaukums,vv.cenaLVL, ps.id as ps_id,ps.vid as v_id,ps.kid as k_id, vsv.nosaukums as viesnica, vsv.vietas from ["&Application("db_tb_pieteikums")&"] p inner join ["&Application("db_tb_profili")&"] pp on pp.id = p.profile_id inner join ["&Application("db_tb_piet_saite")&"] ps on ps.pid=p.id inner join["&Application("db_tb_dalibnieki")&"] d on d.id = p.did inner join ["&Application("db_tb_vietu_veidi")&"] vv on vv.id=ps.vietas_veids left join "&kaj&" v on v.id = "&param&" left join "&viesn&" vsv on vsv.id = v.veids where p.online_rez="&rez_id&" and p.id="&p_id&" and p.profile_id='"&profile_id&"' and ps.deleted=0 and p.tmp = 0 and p.atcelts = 0 order by p_id, vv.tips;"
		
		'Response.Write(query&"<br><br>")
		'response.End 
		
		Set get_reservations_details_by_pieteikums=db.Conn.Execute(query)
		end if
	End Function
	
	Public Function get_reservations_persons(rez_id)
	
		Dim query

		query="select distinct p.id as p_id, p.did as d_id, d.vards, d.uzvards, d.dzimta " +_
				"from pieteikums p " +_
				"inner join dalibn d on d.id = p.did " +_
				"inner join piet_saite ps on ps.pid = p.id " +_
				"where p.online_rez = "&rez_id&" and ps.deleted=0 and p.deleted=0 and p.tmp = 0 and p.atcelts = 0 " +_
				"order by p_id"
				
				'"and isnull(ps.vid,0)<>0 " +_
				
		'Response.Write(query&"<br><br>")
		 
		Set get_reservations_persons=db.Conn.Execute(query)

	End Function

	'==========================================================
	Public Function confirmPayment(user_id, g_id)

		Dim query, res

		'query="UPDATE pieteikums SET bilance = 0, iemaksas = summa, iemaksasLVL = summaLVL, bilanceLVL = 0 WHERE profile_id = "&user_id&" AND gid = "&g_id&" AND deleted = 0 AND tmp = 0"

		'Set confirmPayment = db.Conn.Execute(query)

		query = "SELECT id FROM pieteikums WHERE gid='"&g_id&"' AND profile_id='"&user_id&"' AND deleted=0 AND tmp=0 and atcelts=0"
		Set res = db.Conn.Execute(query)

		If Not res.eof then
			While Not res.eof
				calculate_sum(res("id"))
				res.movenext
			Wend
			confirmPayment = True
		else		
			confirmPayment = false
		End If
		
	
	End Function

	Private Function getOrdNum()

		Dim r_num
		Set r_num = db.Conn.Execute("EXEC get_order_num")

		If Not r_num.eof Then 
			getOrdNum = r_num(0)
		Else
			getOrdNum = 0
		End If

	End Function


	Function get_pids(user_id,g_id)
	Dim ssql, result, pids
		ssql = "select distinct p.id as pid, pp.vards, pp.uzvards, g.kods, g.sakuma_dat, g.beigu_dat, m.v as nos, d.id as did, d.vards as dal_vards, " +_
				"d.uzvards as dal_uzv, p.summaLVL, g.konts, g.konts_ava " +_
				"from pieteikums p " +_
				"inner join profili pp on pp.id = p.profile_id " +_
				"inner join dalibn d on d.id = p.did " +_
				"inner join grupa g on g.id = p.gid " +_
				"inner join marsruts m on g.mid = m.id " +_
				"where p.deleted=0 and p.tmp=0 and p.atcelts=0 and p.profile_id="&user_id&" and p.gid="&g_id

		Set result = db.Conn.Execute(ssql)

		

		If Not result.eof Then
			pids = result("pid")
			result.movenext()
		End If
		
		While Not result.eof	
			pids = pids&","&result("pid")
			result.movenext()
		wend
		
		'response.write("<br>"&pids&"<br>")
		'response.End

		get_pids = pids
	End function
	
	Function get_rez_pid_count(rez_id)
	Dim ssql, result, cnt
	
		ssql = "select distinct count(id) from pieteikums p where p.online_rez = "&rez_id&" and p.deleted = 0 and p.tmp = 0"

		Set result = db.Conn.Execute(ssql)

		If Not result.eof Then
			cnt = result(0)
		else
			cnt = 0
		End If
		
		
		get_rez_pid_count = cnt
		
	End function

	'------------------------------------------------------------------------------
	Function create_db_orders(rez_id, p_apmaksas_veids)
		
		'eksistee 1 rezervaacija ar vienu vai vairaakiem pieteikumiem.
		'katram pieteikumam tiek izveidots 1 orderis par kopejo pakalpojumu summu.
		'--- p_apmaksas_veids vertibas: 
		'mk = maksajumu karte; 
		'ib = swedbank internetbanka ; 
		'dnbnord = dnbnord internetbanka ; 
		'atshkir, jo katram savs debeta konts.

		Dim res
		Dim r_val, result, ssql, c_cel, r_ord
		Dim o_pid, o_datums, o_num, o_kas, o_pamatojums, o_valuta_id, o_debets, o_pielikums, o_summa, o_summaval, o_sakuma_dat, o_beigu_dat
		Dim o_kredits, o_vesture, o_nosummaLVL, o_summaLVL, o_need_check, o_kas2, o_pielikums2, o_pamatojums2, o_parbaude, o_resurss, o_maks_veids, str_pamatojums, str_ord_ids, o_dalibn

		res = True
		str_ord_ids = ""

		Set c_cel = new cls_celojumi

		Set r_val = db.Conn.Execute("SELECT id, bankas_konts, mkartes_konts FROM valuta WHERE val = 'LVL'")
		
		If Not r_val.eof Then 
			o_valuta_id = r_val("id")
			if p_apmaksas_veids = "mk" then
				o_debets = r_val("mkartes_konts")
			elseif p_apmaksas_veids = "ib" then '--- swedbank
				o_debets = r_val("bankas_konts")			
			elseif p_apmaksas_veids = "dnbnord" then
				o_debets = "2.6.2.2.1"
			elseif p_apmaksas_veids = "seb" then
				o_debets = "2.6.2.6.1" 
			elseif p_apmaksas_veids = "citadele" then
				o_debets = "2.6.2.1.1" 
			end if
			
			'--- 2.6.2.3.1 nordea
			
		Else
			'nav latu valuutas
			create_db_orders = false
			Exit function
		End If

		'--- paarbauda vai orderi shai rezervaacjai jau nav izveidoti
		ssql = "select * from orderis where pid in (select id from pieteikums where deleted = 0 and tmp = 0 and atcelts = 0 and online_rez = "&rez_id&")"
		
		Set result = db.Conn.Execute(ssql)
		
		If Not result.eof Then
			'orderi jau eksistee
			'dzesham aaraa

			ssql = "update orderis set deleted = 1 where pid in (select id from pieteikums where deleted = 0 and tmp = 0 and atcelts = 0 and online_rez = "&rez_id&")"
			Set result = db.Conn.Execute(ssql)

			'create_db_orders = false
			'Exit function
		End If
		

		ssql = "select distinct p.id as pid, pp.vards, pp.uzvards, g.kods, g.sakuma_dat, g.beigu_dat, m.v as nos, d.id as did, d.vards as dal_vards, " +_
				"d.uzvards as dal_uzv, p.summaLVL, g.konts, g.konts_ava " +_
				"from pieteikums p " +_
				"inner join profili pp on pp.id = p.profile_id " +_
				"inner join dalibn d on d.id = p.did " +_
				"inner join grupa g on g.id = p.gid " +_
				"inner join marsruts m on g.mid = m.id " +_
				"where p.deleted=0 and p.tmp=0 and p.atcelts=0 and p.online_rez="&rez_id

		Set result = db.Conn.Execute(ssql)

		'response.write("<br>"+ssql+"<br>")
		'response.End

		While Not result.eof
	
			o_pid = result("pid")
			o_num = getOrdNum()
			o_datums = Now
			o_sakuma_dat = result("sakuma_dat")
			o_kas = result("vards")&" "&result("uzvards")
			o_dalibn = result("did")
			str_pamatojums = result("kods")&" "&o_sakuma_dat&" "&result("nos")&". Dalîbnieks: "&result("dal_vards")&" "&result("dal_uzv")
			o_pamatojums = str_pamatojums
			o_pielikums = "Rezervacija: "&o_pid
			o_summa = result("summaLVL")
			o_summaval = o_summa

			o_beigu_dat = result("beigu_dat")

			'--- kredits
			'--- ja celjojuma beigu datums ir veelaaks par tekosho meenesi, njem avansa kontu
			if year(o_beigu_dat)>year(now) or month(o_beigu_dat)>month(now) then
			   o_kredits = result("konts_ava") 'njem avansa kontu
	  		else
			   o_kredits = result("konts") 'njem ienjemumu kontu
	 		end If
			
			o_vesture = o_kas&" - Izveidoja. "&o_datums
			o_nosummaLVL = o_summa
			o_summaLVL = o_summa

			o_kas2 = o_kas
			o_kas2 = c_cel.encode_old_charset(o_kas2)
			
			o_pamatojums2 = c_cel.encode_old_charset(str_pamatojums)
			o_pielikums2 =  c_cel.encode_old_charset(o_pielikums)

			o_parbaude = 1
			o_resurss = result("kods")
			o_maks_veids = "banka"

			ssql = "Set Nocount on; INSERT INTO orderis(pid,nopid,num,datums,kas,dalib,pamatojums,pielikums,summaval,valuta,summa,kredits,debets,deleted,vesture," +_
					"nosummaLVL,summaLVL,kas2,pamatojums2,pielikums2,parbaude,resurss,maks_veids) " +_
					"VALUES("&o_pid&",0,'"&o_num&"',getdate(),'"&o_kas&"','"&o_dalibn&"','"&o_pamatojums&"','"&o_pielikums&"',"&o_summaval&","&o_valuta_id&","&o_summa&",'"&o_kredits&"','"&o_debets&"',0,'"&o_vesture&"',"&o_nosummaLVL&","&o_summaLVL&",'"&o_kas2&"','"&o_pamatojums2&"','"&o_pielikums2&"',"&o_parbaude&",'"&o_resurss&"','"&o_maks_veids&"'); Select @@IDENTITY as id"
			

			'response.write(ssql)
			'response.end

			Set r_ord = db.Conn.Execute(ssql)

			If Not r_ord.eof Then
				
				If str_ord_ids <> "" then
					str_ord_ids = str_ord_ids & ","
				End If

				str_ord_ids = str_ord_ids & CStr(r_ord("id"))
				
				
			End If
			
			'--- parrekina piet summu
			calculate_sum(o_pid)

		
			result.MoveNext

		Wend
		
		If str_ord_ids <> "" Then
			res = str_ord_ids
		End If
			
		create_db_orders = res
		

	End	Function 
	'------------------------------------------------------------------------------

'------------------------------------------------------------------------------

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - 
	'==Returns -
	'==Comment -
	'==========================================================
	Public Function get_dalibnieks(d_id)
		Dim query

		query = "SELECT n.nosaukums as novads_nos, d.* FROM dalibn d LEFT JOIN novads n ON n.id = d.novads WHERE d.[id] = '"&d_id&"' order by uzvards collate Latvian_CI_AS"
		'query = "SELECT vards COLLATE Latvian_CI_AS AS vards, uzvards COLLATE SQL_Latvian_Cp1257_CI_AS AS uzvards  FROM ["&Application("db_tb_dalibnieki")&"] WHERE [id] = '"&d_id&"'"
		'response.write(query)
		
		Set get_dalibnieks = Conn.Execute(query)

	End Function 

	Public Function get_user(u_id)
		Dim query

		query = "SELECT * FROM ["&Application("db_tb_profili")&"] WHERE [id] = '"&u_id&"'"
		'query = "SELECT vards COLLATE Latvian_CI_AS AS vards, uzvards COLLATE SQL_Latvian_Cp1257_CI_AS AS uzvards  FROM ["&Application("db_tb_dalibnieki")&"] WHERE [id] = '"&d_id&"'"
		
		'response.write(query)
		Set get_user = db.Conn.Execute(query)
	End Function 
	'==========================================================
	
	Public Function get_without_links(user_id)
	Dim query
		query="select d.vards,d.uzvards,p.id as p_id from ["&Application("db_tb_pieteikums")&"] p inner join ["&Application("db_tb_dalibnieki")&"] d on d.id=p.did where p.id not in (select ps.pid from ["&Application("db_tb_piet_saite")&"] ps where ps.pid=p.id ) and  p.profile_id='"&user_id&"' and p.tmp = 0 and p.deleted = 0;"
		'Response.Write(query)
		''response.End 
		Set get_without_links=db.Conn.Execute(query)
	End Function
	
	Public sub delete_pieteikums(pid)
		Dim query,ret, p_user, user_name
		
		SET p_user = get_user(Session("user_id"))
		user_name = p_user("vards")+" "+ p_user("uzvards")
		
		SET ret=db.Conn.Execute("select isnull(iemaksas,0) as iemaksas FROM "&Application("db_tb_pieteikums")&" where id="&pid&" and profile_id="&p_user("id"))
		if ret.EOF OR ret("iemaksas")>0 Then exit sub
		'query="delete from ["&Application("db_tb_piet_saite")&"] where pid='"&pid&"';delete from ["&Application("db_tb_pieteikums")&"] where id='"&pid&"';"
		query="update ["&Application("db_tb_piet_saite")&"] set deleted=1 where pid='"&pid&"'; update ["&Application("db_tb_pieteikums")&"] set deleted=1, vesture = CAST(vesture AS varchar(1024)) + '; "&user_name&" - Izdzçsa '+cast(getdate() as varchar(32)) where id='"&pid&"';"
		'Response.Write(query)
		'Response.end
		db.Conn.Execute(query)
	End sub
	
	Public sub delete_rezervacija(rez_id,profile_id)
		Dim query,ret, user_name
		SET ret=get_reservations_details(cint(rez_id),0,profile_id)
		'response.write(ret("p_id"))
		'response.end
		
		user_name = ret("vards")+" "+ ret("uzvards")
		
		query=""
		while NOT ret.EOF
			if ret("iemaksas")>0 Then exit sub
			query=query&"update ["&Application("db_tb_piet_saite")&"] set deleted=1 where pid='"&ret("p_id")&"';update  ["&Application("db_tb_pieteikums")&"] set deleted=1, vesture = CAST(vesture AS varchar(1024)) + '; "&user_name&" - Izdzçsa '+cast(getdate() as varchar(32)) where id='"&ret("p_id")&"';"
			ret.MoveNext
		Wend
		if query<>"" Then
			query = "SET NOCOUNT ON;"&query
			db.Conn.Execute(query)
			
			'labots 5. maija 2011 Nils. kluuda query. query dzeesa visus ierakstsus bankas_pieprasijumi ja rez_id bija tukss. 
			'papildus: lietotajs var dzest tikai neapmaksatu rezervaciju. tapec banku tabulaas apmaksatu ierakstu veel nav. var tikt dzeestas tikai neveiksmiigaas atbildes un pieprasijumi
			
			'query="update [merchant_log] set deleted=1 where rez_id='"&rez_id&"';update [bankas_pieprasijumi] set deleted=1 where VK_MSG  like '%(rez_id="&Session(rez_id&"_rez_id")&")';"
			'db.Conn.Execute(query)	
		End if
	End sub
	
	Public Function delete_link(ps_id)
	  Dim ret
	  Set ret=db.Conn.Execute("select "&Application("db_tb_piet_saite")&".pid from ["&Application("db_tb_piet_saite")&"],["&Application("db_tb_vietu_veidi")&"] where "&Application("db_tb_vietu_veidi")&".tips<>'C' AND "&Application("db_tb_vietu_veidi")&".id="&Application("db_tb_piet_saite")&".vietas_veids AND "&Application("db_tb_piet_saite")&".id='"&ps_id&"';")
	  delete_link=0
	  'response.write "select "&Application("db_tb_piet_saite")&".pid from ["&Application("db_tb_piet_saite")&"],["&Application("db_tb_vietu_veidi")&"] where "&Application("db_tb_vietu_veidi")&".tips<>'C' AND "&Application("db_tb_vietu_veidi")&".id="&Application("db_tb_piet_saite")&".vietas_veids AND id='"&ps_id&"';"
	  'response.end
	  if not ret.EOF then
	  	delete_link=ret("pid")
			'response.write "delete from ["&Application("db_tb_piet_saite")&"] where id='"&ps_id&"';"
			db.Conn.Execute("delete from ["&Application("db_tb_piet_saite")&"] where [id]='"&ps_id&"';")
		end if
	End function
	
	Public sub calculate_sum(pid)

		db.Conn.execute("exec pieteikums_calculate "+cstr(pid))

	    '--- updeito pieteikuma lauku papildvieta
	    update_piet_papildv(pid)


		'db.Conn.Execute("update ["&Application("db_tb_pieteikums")&"] set summaLVL=(select sum(vv.cena) as summa from ["&Application("db_tb_pieteikums")&"] p inner join ["&Application("db_tb_piet_saite")&"] ps on ps.pid=p.id inner join ["&Application("db_tb_vietu_veidi")&"] vv on vv.id=ps.vietas_veids where p.id='"&pid&"') where id='"&pid&"';")
	End Sub
	
	Public Sub update_piet_papildv(p_id)	
			
			'--- updeito pieteikuma lauku papildvieta

			query = "SELECT * FROM ["&Application("db_tb_piet_saite")&"] WHERE deleted=0 AND pid="&p_id&" AND papildv=1"
			SET result = db.Conn.Execute(query)
			If Not result.eof Then
				q1 = "UPDATE ["&Application("db_tb_pieteikums")&"] SET papildvietas=1 WHERE id = "&p_id&" AND deleted=0"			
			Else
				q1 = "UPDATE ["&Application("db_tb_pieteikums")&"] SET papildvietas=0 WHERE id = "&p_id&" AND deleted=0"				
			End If
			db.Conn.Execute(q1)
	
			'response.write(q1)
			'response.end
	
	End Sub
	
	Public Function calculate_iemaksa(pid_arr)
		if pid_arr.count>0 then
				Dim query
				for each p_id in pid_arr
					query="update ["&Application("db_tb_pieteikums")&"] set iemaksas=(case when (select iemaksas from ["&Application("db_tb_pieteikums")&"] where id='"&p_id&"') is null then 0 else (select iemaksas from ["&Application("db_tb_pieteikums")&"] where id='"&p_id&"') end)+"&pid_arr(p_id)&" where id='"&p_id&"';"
					'response.write(query)
					'db.Conn.Execute(query)
				next
		end if
	End Function


End Class
%>