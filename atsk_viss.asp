<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<%
dim conn
openconn

if len(Request.form("skatit.x")) <> 0 and (Request.Form("sak_dat1") = "" or Request.Form("beigu_dat1") = "") then
 session("message") = "Jânorâda abi datumi."
end if

docstart "Pilna pieteikumu atskaite","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pilna pieteikumu atskaite</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='RED' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

dim grupa
dim valuta
dim neradit_agentu
dim grupa_no
dim grupa_lidz
dim op_no
dim op_lidz

grupa = getparameter("kompleks")
valuta = Request.Form("valuta")
neradit_agentu = Request.Form("neradit_agentu")
grupa_no = Request.Form("grupa_no")
grupa_lidz = Request.Form("grupa_lidz")
grupa_kods = Request.Form("grupa_kods")
op_no = Request.Form("op_no")
op_lidz = Request.Form("op_lidz")

%>

<form name="forma" action="atsk_viss.asp" method="POST">
<table>
<tr>
	<td align="right" bgcolor="#ffc1cc">Pieteikuma datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="sak_dat1" value="<%=request.form("sak_dat1")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="beigu_dat1" value="<%=request.form("beigu_dat1")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Operâcijas datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="op_no" value="<%=request.form("op_no")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="op_lidz" value="<%=request.form("op_lidz")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Grupas beigu datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="grupa_no" value="<%=request.form("grupa_no")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="grupa_lidz" value="<%=request.form("grupa_lidz")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Grupas kods</td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" name="grupa_kods" value="<%=request.form("grupa_kods")%>"> 
	</td>
</tr>

<tr><td align="right" bgcolor="#ffc1cc">Periods</td><td bgcolor="#fff1cc">
	<select name="periods">
		<option <%if request.form("periods") = "day" then response.write " selected "%> value="day">Diena</option>
		<option <%if request.form("periods") = "month" then response.write " selected "%> value="month">Mçnesis</option>
		<option <%if request.form("periods") = "year" then response.write " selected "%> value="year">Gads</option>
	</select></td>
</tr>
<tr><td align="right" bgcolor="#ffc1cc">Nerâdît aìentu pieteikumus</td><td bgcolor="#fff1cc">
	<input type="checkbox" <% if request.form("neradit_agentu")="on" then rw "checked"%> name="neradit_agentu">
		</td></tr>
<tr>
	<td align=right bgcolor="#ffc1cc">Valûta</td>
	<td>
		<select name=valuta>
		 <option <%if valuta="Kopa" then Response.Write(" selected ")%>value=Kopa>Kopâ</option>
		 <option <%if valuta="EUR" then Response.Write(" selected ")%>value=EUR>EUR</option>
		 <option <%if valuta="USD" then Response.Write(" selected ")%> value=USD>USD</option>
		</select> 
	</td>
</tr>
</table>
<input type="image" src="impro/bildes/skatit.jpg" name="skatit" WIDTH="116" HEIGHT="25">
<p>

<table>
	<tr>
		<td valign=top>
			<%PrintTable("1")%>
		</td>
	</tr>
</table>


</form>
</body>
</html>

<%

Sub PrintTable (num)
if request.form("skatit.x") <> "" and Request.Form("sak_dat1") <> "" or Request.Form("beigu_dat1") <> "" then
	
	periods = Request.Form("periods")

	'Nosaka sakuma un beigu datumu
	sak_dat = formateddate(Request.Form("sak_dat"+num),"dmy")
	sak_dat_exact = sak_dat
	if periods = "day" then
		beigu_dat = formateddate(Request.Form("beigu_dat"+num),"dmy")
		beigu_dat_exact = beigu_dat
	end if
	if periods = "month" then
		beigu_dat_exact = formateddate(Request.Form("beigu_dat"+num),"dmy")
		beigu_dat = DateSerial(year(beigu_dat_exact),month(beigu_dat)+1,1)-1
	end if
	if periods = "year" then
		beigu_dat_exact = formateddate(Request.Form("beigu_dat"+num),"dmy")
		beigu_dat = DateSerial(year(beigu_dat_exact)+1,1,1)-1
	end if

	if valuta = "EUR" or valuta = "USD" then
	 summa = "Sum(iemaksas"+valuta+"-izmaksas"+valuta+")"
	else
	 kurss = conn.execute("select kurss2 from valutakurss where valuta = 68 and datums = (select max(datums) from valutakurss where valuta = 68)")(0)
	 summa = "Sum(isnull(iemaksasEUR,0)-isnull(izmaksasEUR,0)) + Sum(isnull(iemaksasUSD,0)-isnull(izmaksasUSD,0))/"+cstr(kurss)
	end if
    
	
	if request.form("periods") = "day" then qb = "SELECT str(DatePart(yyyy,p.datums)) + '/' + str(DatePart(mm,p.datums))+'/'+str(DatePart(dd,p.datums)) as dat"	
	if request.form("periods") = "month" then qb = "SELECT str(DatePart(yyyy,p.datums))+'/'+str(DatePart(mm,p.datums)) as dat"
	if request.form("periods") = "year" then qb = "SELECT str(DatePart(yyyy,p.datums)) as dat"

	qb = qb + "	,sum(p.personas) as sk, count(distinct p.id) as skp, count(distinct p.gid) as skg, "+summa+" as sm "
	
	'--- izsledz balles biletes
	'--- grupaam query pievienots   "and atcelta = 0"  // 3. marts 2011
	'-- 25.09.2019 RT: neskaitâm iekðâ grupu vadîtâju pieteikumus!
	pieteikums_cond = " FROM pieteikums p inner join grupa on p.gid = grupa.id  where p.deleted = 0 and (IsNull(p.piezimes,'') <> 'Pieteikums speciâli ballei') and p.atcelts = 0 and grupa.atcelta = 0 AND isnull(p.grupas_vad,0)=0"
	
	'---and grupa.kods not like '__.K.6.5%'
	
	if (neradit_agentu = "on") then
		pieteikums_cond = pieteikums_cond + " AND isnull(agents,0) = 0"
	end if
	
	if (grupa_no <> "") then
		pieteikums_cond = pieteikums_cond  + " AND grupa.beigu_dat >= '"+SQLDate(grupa_no)+"'"
	end if
	
	if (grupa_lidz <> "") then
		pieteikums_cond = pieteikums_cond  + " AND grupa.beigu_dat <= '"+SQLDate(grupa_lidz)+"'"
	end if
	
	if (grupa_kods <> "") then
		pieteikums_cond = pieteikums_cond  + " AND grupa.kods like '"+grupa_kods+"%'"
	end if

	''response.write pieteikums_cond 
	''response.end
	
	
	qe = ""
	if request.form("sak_dat"+num) <> "" then
		pieteikums_cond = pieteikums_cond  + " AND p.datums >= '"+SQLDate(sak_dat_exact) + "' "
	end if
	if request.form("beigu_dat"+num) <> "" then
		pieteikums_cond = pieteikums_cond  + " AND p.datums < '"+SQLDate(beigu_dat_exact+1) + "' "
	end if
	
	qb = qb + pieteikums_cond
	if request.form("periods") = "day" then qe = qe + " GROUP BY str(DatePart(yyyy,p.datums)) + '/' + str(DatePart(mm,p.datums))+'/'+str(DatePart(dd,p.datums)) order by str(DatePart(yyyy,p.datums)) + '/' + str(DatePart(mm,p.datums))+'/'+str(DatePart(dd,p.datums)) "
	if request.form("periods") = "month" then qe = qe + " GROUP BY str(DatePart(yyyy,p.datums))+'/'+str(DatePart(mm,p.datums)) order by str(DatePart(yyyy,p.datums))+'/'+str(DatePart(mm,p.datums)) "
	if request.form("periods") = "year" then qe = qe + " GROUP BY str(DatePart(yyyy,p.datums)) order by str(DatePart(yyyy,p.datums)) "


	q_kompleks = qb + " and gid = " +cstr(conn.execute("select kompleks from parametri")(0)) + qe	
	q_charter = qb + " and gid = " +cstr(conn.execute("select charter from parametri")(0)) + qe
	
	q_vakta = qb + " and veids = 1 " + qe	
	q_vakta_balt = qb + " and (kods like '__.V.4.%' or kods like '__.V.5.%' or kods like '__.V.6.%') " + qe
	q_vakta_lid = qb + " and (kods like '__.V.7.%') " + qe
	q_vakta_1d = qb + " and veids = 1 and grupa.sakuma_dat = grupa.beigu_dat "+ qe
	
	q_pasutijuma = qb + " and kods like '__.P.%' " + qe	
	q_pasutijuma_1d = qb + " and kods like '__.P.%'  and grupa.sakuma_dat = grupa.beigu_dat " + qe	
	q_skolenu = qb + " and kods like '__.S.%' " + qe
	q_skolenu_1d = qb + " and kods like '__.S.%'  and grupa.sakuma_dat = grupa.beigu_dat " + qe
	
	''response.write q_skolenu

	set r_kompleks = conn.execute(q_kompleks)
	set r_charter = conn.execute(q_charter)
	set r_vakta = conn.execute(q_vakta)
	set r_vakta_balt = conn.execute(q_vakta_balt)
	set r_vakta_lid = conn.execute(q_vakta_lid)
	set r_vakta_1d = conn.execute(q_vakta_1d)
	set r_pasutijuma = conn.execute(q_pasutijuma)
	set r_pasutijuma_1d = conn.execute(q_pasutijuma_1d)
	set r_skolenu = conn.execute(q_skolenu)
	set r_skolenu_1d = conn.execute(q_skolenu_1d)

	
	%>
	<center>
	<table >
	<tr bgcolor="#ffc1cc">
	<th >Datums</th>
	<th></th>
	<th >Kompleksie</th>
	<th >Èarteri</th>
	<th >Vâktâs</th>
	<th >V Baltija</th>
	<th >V Lidojumi</th>
	<th >V 1D</th>
	<th >Pasûtîjuma</th>
	<th >Pasûtîjuma 1D</th>
	<th >Skolçnu</th>
	<th >Skolçnu 1D</th>
	</tr>

	<% 


	beigu_dat = formateddate(Request.Form("beigu_dat1"),"dmy")
	
	if periods = "day" then

		tek_dat = sak_dat
		
		
		while (tek_dat<=beigu_dat)
			lidz_dat = dateserial(year(tek_dat),month(tek_dat),day(tek_dat)+1)
			if lidz_dat>beigu_dat then lidz_dat = beigu_dat
			PrintRow tek_dat,lidz_dat,grupa_kods,grupa_kods
			tek_dat = tek_dat+1
		wend
	
	end if

	if periods = "month" then
		tek_dat = sak_dat
		
		while (tek_dat<=beigu_dat)
			lidz_dat = dateserial(year(tek_dat),month(tek_dat)+1,day(tek_dat))
			if lidz_dat>beigu_dat then lidz_dat = beigu_dat
			PrintRow tek_dat,lidz_dat,grupa_kods
			tek_dat = dateserial(year(tek_dat),month(tek_dat)+1,day(tek_dat))
		wend	
	end if

	if periods = "year" then
		'Nosaka sakuma un beigu datumu
		tek_dat = sak_dat
		while (tek_dat<=beigu_dat)
			lidz_dat = dateserial(year(tek_dat)+1,month(tek_dat),day(tek_dat))
			if lidz_dat>beigu_dat then lidz_dat = beigu_dat
			PrintRow tek_dat,lidz_dat,grupa_kods
			tek_dat = dateserial(year(tek_dat)+1,month(tek_dat),day(tek_dat))
		wend	
	end if

	%>

	</table>
	<center>
<%
end if 

End Sub

Function PrintRow(tek_dat,lidz_dat,grupa_kods)


	'Datums
	%>
	<tr bgcolor="#fff1cc">
	<td align="right" valign="center"><%=dateprint(tek_dat)%></td>
	<td>
		Grupas<BR>
		Pieteikumu skaits<BR>
		Orderu skaits<BR>
		Iemaksas<BR>
		Pârskaitîjumi<BR>
		Pieteikumu summa
	</td>
	<%
	pid0 = "select p.id from pieteikums p join grupa g on p.gid = g.id where isnull(p.deleted,0)=0 and isnull(grupas_vad,0) = 0 "
	ord0 = "select id from orderis o where isnull(o.deleted,0)=0 "
	
	if grupa_kods<>"" then
		pid0 = pid0 + " and g.kods like '"+grupa_kods+"%' "
	end if

	if neradit_agentu<>"" then
		pid0 = pid0 + " and isnull(agents,0) = 0 "
		ord0 = ord0 + " and isnull(aid,0) = 0 "
	end if
	
	if tek_dat<>"" then
		pid0 = pid0 + " and p.time_stamp >= '"+sqldate(tek_dat)+"'"
		''ord0 = ord0 + " and o.datums >= '"+sqldate(tek_dat)+"'"
	end if
	if lidz_dat<>"" then
		pid0 = pid0 + " and p.time_stamp <= '"+sqldate(lidz_dat)+" 23:59'"
		''ord0 = ord0 + " and o.datums <= '"+sqldate(lidz_dat)+" 23:59'"
	end if

	'--------------------------
	'kompleksie
	'--------------------------
	pid = pid0 + " and p.gid in (" +cstr(conn.execute("select kompleks from parametri")(0))+") "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (" +cstr(conn.execute("select kompleks from parametri")(0))+") "
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	

'rw pid
'response.end
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%
	
	'--------------------------
	'èarteri
	'--------------------------
	pid = pid0 + " and p.gid in (" +cstr(conn.execute("select charter from parametri")(0))+") "
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%

	'--------------------------
	'vâktâs
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.V.%' "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.V.%') "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if



	'rw pid
	''rw ord
	'rw "<br><br>"
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	'rw "select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)"
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	'rw "select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)"
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)


	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%

	'--------------------------
	'vâktâs baltija
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where (kods like '__.V.4.%' or kods like '__.V.5.%' or kods like '__.V.6.%') "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where (kods like '__.V.4.%' or kods like '__.V.5.%' or kods like '__.V.6.%')) "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%


	'--------------------------
	'vâktâs lidojumi
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.V.7.%' "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.V.7.%') "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	
	
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%

	'--------------------------
	'vâktâs 1 diena
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.V.%' and sakuma_dat = beigu_dat "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.V.%' and sakuma_dat = beigu_dat) "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%
	
	'--------------------------
	'pasûtîjuma
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.P.%' "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.P.%') "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%	
	
	
	'--------------------------
	'pasûtîjuma 1 diena
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.P.%' and sakuma_dat = beigu_dat "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.P.%' and sakuma_dat = beigu_dat) "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)

	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%

	'--------------------------
	'skolçnu
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.S.%' "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.S.%') "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%	
	
	
	'--------------------------
	'skolçnu 1 diena
	'--------------------------
	pid = pid0 + " and p.gid in (select id from grupa where kods like '__.S.%' and sakuma_dat = beigu_dat "
	pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.S.%' and sakuma_dat = beigu_dat) "
	ord = ord0 + " and (o.pid in (" + pid_all + ") or o.nopid in (" + pid_all + "))"
	
	
	if grupa_no<>"" then
		pid = pid + " and beigu_dat >= '"+sqldate(grupa_no)+"'"
	end if
	if grupa_lidz<>"" then
		pid = pid + " and beigu_dat <= '"+sqldate(grupa_lidz)+" 23:59'"
	end if
	if grupa_kods<>"" then
		pid = pid + " and kods like '"+grupa_kods+"%'"
	end if
	pid = pid + ")"
	
	ord = ord0 + " and (o.pid in (" + pid + ") or o.nopid in (" + pid + "))"
	
	if op_no<>"" then
		ord = ord + " and  datums >= '"+sqldate(op_no)+"'"
	end if
	if op_lidz<>"" then
		ord = ord + " and datums <= '"+sqldate(op_lidz)+" 23:59'"
	end if
	
	conn.execute("delete from pid_tmp")
	conn.execute("insert into pid_tmp (pid) "+pid)	
	conn.execute("delete from ord_tmp")
	conn.execute("insert into ord_tmp (oid) "+ord)
	
	gsk = conn.execute("select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psk = conn.execute("select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	psm = conn.execute("select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)")(0)
	osk = conn.execute("select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)")(0)
	osm_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid = 0 and o0.id in (select oid from ord_tmp)")(0)
	osm_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid = 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_plus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and nopid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	parsk_minus = conn.execute("select isnull(sum(o0.summaEUR),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and pid <> 0 and o0.id in (select oid from ord_tmp)")(0)
	
	%><td align=center><%
	response.write gsk
	%><BR><%
	response.write psk
	%><BR><%
	response.write osk
	%><BR><%
	response.write currprint(osm_plus - osm_minus)
	%><BR><%
	response.write currprint(parsk_plus - parsk_minus)
	%><BR><%
	response.write currprint(psm)
	%><BR><%
	%></td><%	
	%></tr><%


			
End FUnction
%>
<style>
 .border-right{ 
	border-right: 1px solid black;
 }