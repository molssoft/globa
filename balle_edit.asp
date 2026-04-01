<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Balles biïetes","y1.jpg"
DefJavaSubmit

num = Request.QueryString("num")
sektors = Mid(num,1,1)
If (Len(num)>1) then
	numurs = Mid(num,2,Len(num)-1)
End if
regions = left(num,1)


If request.form("sektors")<>"" Then
	sektors = request.form("sektors")
	regions = request.form("sektors")
End if

gid = Request.querystring("gid")
pid = Request.QueryString("pid")

parcelt = Request.form("parcelt_s")
iznemt = Request.form("iznemt_s")


nr = Request.Form("nr")
nr_sub = Request.Form("subNumurins")
maxv = Request.Form("maxv")
add = Request.QueryString("add")
vietas = Request.Form("vs" & pid)
parbrivu = Request.Form("bb" & pid)
knum = Request.Form("kn" & pid)
knos = Request.Form("kno" & pid)
datums = Request.Form("b" & pid)
piezimes = Request.Form("pz" & pid)
klients = Request.Form("klients")
piezimes_2 = Request.Form("pz_2")
gnosaukums_save = Request.QueryString("gnosaukums")
gnosaukums = Request.Form("gnosaukums")
gpiezimes = Request.Form("gpiezimes")
bid = request.querystring("bid")


If gnosaukums_save = "1" Then
	conn.execute("UPDATE balle set nosaukums = '"+sqltext(gnosaukums)+"', piezimes = '"+sqltext(gpiezimes)+"' where sektors = '" + sektors + "' And num = " + numurs)
End if

If gid <> "" then
	if gid <> 292 and gid <> 3100 then
		regions = left(num,1)
	else
		regions = "S"
	end if
End if

if parcelt = "1" then
	conn.execute("UPDATE grupa SET balle_sektors = 'S', balle_numurs = null, balle_numurs_sub = null WHERE id = " + gid)
	session("message") = "Grupa pârcelta uz Sports / Individuâlie"
	Response.redirect("balle.asp?reg=s")
elseif iznemt = "1" then	
	
	conn.execute("UPDATE grupa SET balle_sektors = null, balle_numurs = null, balle_numurs_sub = null WHERE id = " + gid)
	session("message") = "Grupa izòemta no Sports / Individuâlie"
	Response.redirect("balle.asp")
end if


if add = 1 then
 
 if Request.Form("newname") <> "" and Request.Form("newlastname") <> "" then 
	
	'---- 
	
	'pievienojam jaunaa daliibnieka pieteikumu
	dfields = "vards uzvards pases pasenr pk1 pk2 "+ _
		"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"
	dtypes = "text text text text text text text text text text text text text text text text text text text text text num"
	dforms = "vards uzvards pases pasenr pk1 pk2 "+ _
		"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"
	NewRecord conn,"select * from dalibn",dfields,dforms
	session("message") = "Jauns dalîbnieks pievienots veiksmîgi!"
	id = session("newid")
	loginsertaction "dalibn",id
	conn.execute("update dalibn set vards = UPPER('" & Request.Form("newname") & "') where id = " & id)
	conn.execute("update dalibn set uzvards = UPPER('" & Request.Form("newlastname") & "') where id = " & id)
	conn.execute("update dalibn set talrunisMob = '" & Request.Form("newphone") & "' where id = " & id)
	set rD = conn.execute("select max(id) as id from dalibn where vards = '" & Request.Form("newname") & "' AND uzvards = '" & Request.Form("newlastname") & "'")
	'pagaidâm atïaujam vienot dalîbnieku arî ne ar ðodienas datumu
	conn.execute("insert into pieteikums (gid, datums, balle_piezimes, sakuma_datums, balle_vietas) VALUES (" & gid & ", '" &  SQLDate(Date()) & "', 'Pieteikums speciâli ballei', '" &  SQLDate(Date()) & "', 1)")
	'conn.execute("insert into pieteikums (gid, datums, balle_piezimes, sakuma_datums, balle_vietas) VALUES (" & gid & ", '12.09.2006', 'Pieteikums speciâli ballei', '12.09.2006', 1)")
	set rP = conn.execute("select max(id) as id from pieteikums where gid = '" & gid & "' AND balle_piezimes = 'Pieteikums speciâli ballei'")
	conn.execute("insert into piet_saite (did, pid, vietsk, piezimes, deleted, persona) VALUES (" & rD("id") & ", " & rP("id") & ", 0, 'Pieteikums speciâli ballei', 0, 0)")
	if gid = 292 or gid = 3100 then
	 conn.execute ("update pieteikums set balle_knum = " & Right(num,Len(num)-1) & " where id = " & rP("id"))
	end if
	add = 0
 
 else if Request.Form("klients") <> "" then 'individuaalie - izveele no saraksta
 
 		'pievienojam jaunu pieteikumu
 		grupas_nr = Request.Form("grupas_nr")
 		if grupas_nr = "" then
 			grupas_nr = Request.Form("numurins")
 		end if
		
		
		
		'--- izveido pieteikumu -----------------------------------------------
				
				did = Request.Form("klients")
				' set r_grupa = conn.execute("select * from grupa where id = ")
				numurs = grupas_nr
				
				'--- atrod balles grupu	
				ssql = "SELECT g.id FROM grupa g inner join marsruts m on m.id = g.mid " + _
					   "where sakuma_dat between '12/1/" & CStr(CLng(Year(Now))) & "' and '12/31/" & CStr(CLng(Year(Now))) & "' and v like 'Impro balle%'"
					   
			    set r_g = conn.execute(ssql)
			    
			    if not r_g.eof then
					g_id = r_g("id")
			    else
					Response.Write("Nav atrasta balles grupa")
					Response.end
			    end if

				if regions = "S" then
					ifields = ", balle_knum"
					ivalues = "," + numurs
				end if

				ssql = "SET NOCOUNT ON;INSERT INTO pieteikums (did, gid, izveidoja, b_numurs, b_sektors, piezimes" + ifields + ") " + _
					   "VALUES ("+cstr(did)+","+cstr(g_id)+",'"+Get_User+"',"+numurs+",'"+regions+"', 'Balles biïete'" + ivalues + ") " + _
					   "; SELECT @@IDENTITY as ID"
				
				'Response.Write(ssql)
				'Response.end
				set r_pid = conn.execute(ssql)
				
				pid = r_pid.Fields.Item("ID")
				
				if pid <> "" then
				
					conn.execute "INSERT INTO piet_saite (pid,did,vietsk) VALUES ("+cstr(pid)+","+cstr(did)+",1)"
				
					'--- ja tas ir papildus galds, izveido ierakstu tabulaa balle
					if pg = 1 then
						ssql = "INSERT INTO balle(gads,sektors,num,did,pid) VALUES('"+cstr(year(date()))+"','"+regions+"',"+numurs+","+cstr(did)+","+cstr(pid)+")"
						conn.execute(ssql)
					end if
					'-----
					
					session("message") = "Pieteikums ballei izveidots"
					LogInsertAction "pieteikums",pid

				else
					
					session("message") = "Kïûda. Pieteikums ballei nav izveidots"

				end if

				
		'----------------------------------------------------------------------
		
		add = 0
		'session("message") = "Jauns pieteikums izveidots veiksmîgi !"
		klients = ""
			
	end if
 end if
 	
elseif add=1 then
 session("message") = "Dalîbnieks netika pievienots, jo nebija ievadîts vârds vai uzvârds"
end if


If pid<>"" Then
	conn.execute("update pieteikums set balle_brivbiletes = '" & parbrivu & "', balle_vietas = '" & vietas & "', balle_piezimes = '"+piezimes+"' where id = " & pid)
	if SQLDate(datums) = "" then 
		conn.execute("update pieteikums set balle_datums = null where id = " & pid)
	else
		conn.execute("update pieteikums set balle_datums = '" & SQLDate(datums) & "' where id = " & pid)
	end if

	LogUpdateAction "pieteikums",pid
End if

if pid<>"" And gid<>"" then
 if cstr(vietas)<>"0" or cstr(parbrivu)<>"0" then
  dim rGrupaBalle
  set rGrupaBalle = conn.execute("select IsNull(balle_numurs,0) as balle_numurs, valsts from grupa inner join marsruts on mid = marsruts.id where grupa.id = " & gid)
  if rGrupaBalle("balle_numurs") = 0 then
   if gid = 292 or gid = 3100 then
    set rMaxNum = conn.execute("select (60 + count(id)) as maxnum from grupa where id in (292, 3100) and not balle_numurs is null")
   else
	'rw "-> " & "select IsNull(balle_numurs,0) as balle_numurs, valsts from grupa inner join marsruts on mid = marsruts.id where grupa.id = " & gid
    set rMaxNum = conn.execute("select IsNull(max(balle_numurs),0) as maxnum from grupa inner join marsruts on mid = marsruts.id where year(sakuma_dat) between '12/10/2004' and '12/10/2005' and valsts in (" & CountriesByRegion(RegionForCountry(RTrim(rGrupaBalle("valsts")))) & ")")
   end if
   conn.execute("update grupa set balle_numurs = " & rMaxNum("maxnum") + 1 & "where id = " & gid)
   num = left(num,1) + cstr(rMaxNum("maxnum") + 1)
  end if
 end if 

 if knum = "" then
  conn.execute("update pieteikums set balle_knum = null where id = " & pid)
 else
  
  'set rTaken = conn.execute ("select * from pieteikums where balle_knum = " & knum & " and gid <> " & gid)
  set rTaken = conn.execute ("select * from pieteikums where balle_knum = " & knum & " and gid <> " & gid & " " + _
		"and sakuma_datums between '12/10/" & CStr(CLng(Year(Now)) - 1) & "' and '12/31/" & CStr(CLng(Year(Now))) & "' and deleted = 0")
  
   
  'rw "select * from pieteikums where balle_knum = " & knum & " and gid <> " & gid & " " + _
		'"and sakuma_datums between '12/10/" & CStr(CLng(Year(Now)) - 1) & "' and '12/31/" & CStr(CLng(Year(Now))) & "' and deleted = 0"
  'Response.End
  
  If not rTaken.eof then
 
   session("message") = "Dalîbnieks netika pârvietots pie izvçlçtâ galda, jo pie tâ atrodas cita grupa"
 
  else
   conn.execute("update pieteikums set balle_knum = " & knum & " where id = " & pid)
  end if
  
 end if
 
 
 if knos = "" then
	
  conn.execute("update pieteikums set balle_knos = '' where id = " & pid)
  
 else

  conn.execute("update pieteikums set balle_knos = '" & knos & "' where id = " & pid)
 end if
 
 if piezimes = "" then
  conn.execute("update pieteikums set balle_piezimes = null where id = " & pid)
 else
  conn.execute("update pieteikums set balle_piezimes = '" & piezimes & "' where id = " & pid)
 end if
 
 
end if

'--- nomaina sektora numuru ---

	'--- atrod balles grupu	
	ssql = "SELECT g.id FROM grupa g inner join marsruts m on m.id = g.mid " + _
			   "where sakuma_dat between '12/10/" & CStr(CLng(Year(Now)) - 1) & "' and '12/31/" & CStr(CLng(Year(Now))) & "' and v like '%balle%'"
			   
	set r_g = conn.execute(ssql)

	if nr <> "" and nr <> "0" then
	
		'pârbaudam vai tâds numurs eksistç balles galdu tabulâ
		Set rgalds = conn.execute("select * from balle where sektors = '"+sektors+"' and num = "+CStr(nr))
		If rgalds.eof Then
			conn.execute("insert into balle (sektors,num,galds) values ('"+sektors+"',"+CStr(nr)+",0)")
		End if

		conn.execute("update grupa set balle_numurs = " & nr & ", balle_sektors = '"&sektors&"' where id = " & gid)
		conn.execute("update grupa set balle_numurs_sub = '" & nr_sub & "' where id = " & gid)

	
		'--- updeito neatkariigo no grupas pieteikumu balles numuru 
		if not r_g.eof then
			b_gid = r_g("id")
			ssql = "update pieteikums set b_numurs = " & nr & " where deleted = 0 and b_sektors='"&regions&"' and gid=" & b_gid & " and b_numurs='"&Right(num,Len(num)-1)&"' and id in (select pid from balles_pieteikumi where gid = "+gid+")"
			conn.execute(ssql)
		end if
	
		num = Left(num,1) + nr
	

	elseif nr="0" then

		'' nelaut nonemt grupas numuru ja tur ir cilveki
		Set rtest = conn.execute("select * from balles_pieteikumi where gid = "+CStr(gid))
		If Not rtest.eof Then	
			Response.write "Nevar nonemt numuru grupai kuraa ir cilveki"
			Response.end
		End if
		
		conn.execute("update grupa set balle_numurs = null, balle_sektors = '"+sektors+"' where id = " & gid)
		
		'--- updeito neatkariigo no grupas pieteikumu balles numuru 
		''if not r_g.eof then
		''	b_gid = r_g("id")
		''	ssql = "update pieteikums set b_numurs = " & nr & " where deleted = 0 and b_sektors='"&regions&"' and gid=" & b_gid & " and ''b_numurs='"&Right(num,Len(num)-1)&"'"
		''	conn.execute(ssql)
		''end if
		
		num = Left(num,1) + "0"

	else
		nr="0"
	end if

'--------
if maxv <> "" and maxv <> "0" then
 conn.execute("update grupa set balle_maxvietas = " & maxv & " where id = " & gid)
elseif maxv="0" then
 conn.execute("update grupa set balle_maxvietas = null where id = " & gid)
end if


if piezimes_2 = "1" then
	ssql = "update grupa set piezimes_2 = '" & Request.Form("piezimes_2") & "' where id = " & gid
	conn.execute(ssql)
end if


%>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Balles biïetes grupai</b></font><hr>

<%
' standarta saites

headlinks

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

If gid<>"" then
	set rGrupa = conn.execute("select balle_sektors,sakuma_dat, v, veids, IsNull(vards,'') as vards, IsNull(uzvards,'') as uzvards, IsNull(balle_maxvietas,0) as balle_maxvietas, balle_numurs_sub, piezimes_2 from grupa inner join marsruts on mid = marsruts.id left outer join grupu_vaditaji on vaditajs = grupu_vaditaji.idnum where grupa.id = " & gid)
End if

If gid<>"" then
	if gid = 292 then code = 30 else code = 31
End if

%>

<br>
<form name=forma action="balle_edit.asp?gid=<%=gid%>" method="POST">
<font color="BLACK" size="3"><br><b>Izvçlçties ceïojumu reìionu
<table>
<tr><td bgcolor = #ffc1cc>Reìions: </td><td bgcolor = #fff1cc><select name="regions">
<option value="R" <%if regions = "R" then Response.Write "selected"%>>Rietumeiropa</option>
<option value="Z" <%if regions = "Z" then Response.Write "selected"%>>Ziemeïeiropa</option>
<option value="C" <%if regions = "C" then response.write "selected"%>>Centrâleiropa</option>
<option value="E" <%if regions = "E" then Response.Write "selected"%>>Eksotiskâs valstis</option>
<option value="S" <%if regions = "S" then Response.Write "selected"%>>Sports / Individuâlie</option>
</select></td>
<td><input type="submit" name = "poga" value = "Izvçlçties" onclick="TopSubmit(&quot;balle.asp&quot;)"></td></tr>
</table>
<% if gid<>"" then %>
<font color="BLACK" size="3"><br><b><%=ucase(rGrupa("v"))%>&nbsp;-&nbsp;<%=DatePrint(rGrupa("sakuma_dat"))%>,&nbsp;Vadîtâjs(-a):&nbsp;<%=rGrupa("vards")%>&nbsp;<%=rGrupa("uzvards")%><br><br>
Grupas numurs: <%'=Left(num,1)%>
<select name=sektors>
	<option value="" >-</option>
	<option value="R" <%if sektors = "R" then Response.Write "selected"%>>R</option>
	<option value="Z" <%if sektors = "Z" then Response.Write "selected"%>>Z</option>
	<option value="C" <%if sektors = "C" then response.write "selected"%>>C</option>
	<option value="E" <%if sektors = "E" then Response.Write "selected"%>>E</option>
	<option value="S" <%if sektors = "S" then Response.Write "selected"%>>S</option>
</select>

<select name=numurins>
<%i = 0
  Response.Write num
  Do While i < 150
   Response.Write "<option value=" & i
   If cstr(i) = Right(num,Len(num)-1) then Response.Write " selected"
   Response.Write ">"
   if i = 0 then
    Response.Write "nav"
   else
    Response.Write i
   end if
   Response.Write "</option>"
   i = i + 1
  Loop
%></select>

<%
if regions = "E" then
	nr_sub = rGrupa("balle_numurs_sub")
%>
	<select name="subNumurins">
	<option value="" <%if nr_sub = "" then Response.Write "selected"%>></option>
	<option value="A" <%if nr_sub = "A" then Response.Write "selected"%>>A</option>
	<option value="B" <%if nr_sub = "B" then Response.Write "selected"%>>B</option>
	<option value="C" <%if nr_sub = "C" then response.write "selected"%>>C</option>
	<option value="D" <%if nr_sub = "D" then Response.Write "selected"%>>D</option>
	<option value="E" <%if nr_sub = "E" then Response.Write "selected"%>>E</option>
	</select>
<%end if%>

<input type=hidden name=nr value="">

<% if rGrupa("veids") <> 6 then %>
<input type=button value='Nomainît' onclick="form.nr.value = form.numurins.value;TopSubmit(&quot;balle_edit.asp?gid=<%=gid%>&sektors=<%=sektors%>&num=<%=num%>&quot;)">
<% end if %>

<% if IsAccess(T_BALLES_ORG) then %>
 <br>Maksimâlais vietu skaits:
 <input type=hidden name=maxv value="">
 <input type=text size=2 name=maxvietas value=<%=rGrupa("balle_maxvietas")%>>
 <input type=button value='Saglabât' src="impro/bildes/saglabat.jpg" alt="Tiek saglabâts maksimâlais vietu skaits." onclick="form.maxv.value = form.maxvietas.value;TopSubmit(&quot;balle_edit.asp?gid=<%=gid%>&num=<%=Request.QueryString("num")%>&quot;)">

<br>

<% end if %>

<br>Piezîmes: 
<input type="hidden" name="pz_2" value="">
<input type="text" size="100" name="piezimes_2" value="<%=rGrupa("piezimes_2")%>">
<input type="button" value="Saglabât" src="impro/bildes/saglabat.jpg" alt="Tiek saglabâtas piezîmes." onclick="form.pz_2.value = 1;TopSubmit(&quot;balle_edit.asp?gid=<%=gid%>&num=<%=Request.QueryString("num")%>&quot;)" id="button2" name="button2">
<BR><BR>
<% end if %>
<table width=100%>
<tr bgcolor = #ffC1cc>
<th>Nr.</th>
<th>Piet</th>
<th>Vârds</th>
<th>Uzvârds</th>
<%'<th>P.K.</th>%>
<th>Vietu skaits</th>
<th>Bez- maksas</th>
<%
If gid<>"" then
	if rGrupa("veids") = 6 then%>
		<th>Galda nr.</th>
		<th>Galda nos.</th>
	<%end If
End if%>

<th>Telefons</th>
<th>Iegâdes dat.</th>
<th>Piezîmes</th>
<th>.</th>
</tr>
<%
If gid<>"" then
	if rGrupa("veids") = 1 or rGrupa("veids") = 2 or rGrupa("veids") = 6 then
	 Response.Write "<tr bgcolor = #fff1cc><td></td>"
	 Response.Write "<td></td>"
	 'if rGrupa("veids") = 6 then 
	 
		Response.Write "<td colspan = 2>"

			set rKli = conn.execute("select vards, uzvards from dalibn where id = '" & klients & "'")
			%>
			<div id=klients><%
				If not rKli.eof then %>
					<a target="_blank" href="dalibn.asp?i=<%=Request.Form("klients")%>"><%Response.Write rKli("vards") & " " & rKli("uzvards")%></a>
				<%end if%>
			</div>
			<%
			
		Response.Write "<input type=hidden name=klients value=" + klients + "></td>"
		'Response.Write "<input type=hidden name=klients value=" + Request.Form("klients") + "></td>"
		
		
	 'else
		'Response.Write "<td><input type=text name=newname size=15></td>"
		'Response.Write "<td><input type=text name=newlastname size=15></td>"
	 'end if
	 

	 if rGrupa("veids") = 6 then 
		Response.Write "<td><input type=number name=vietu_sk size=2 value=1></td>"
		Response.Write "<td><input type=number name=vietu_sk_bezm size=2 value=0></td>"
		Response.Write "<td>S<input type=number name=grupas_nr size=2 value="+nullprint(Right(num,Len(num)-1))+"></td>"
		Response.Write "<td><input type=text name=galda_nos size=20></td>"	
		Response.Write "<td></td>"
		Response.Write "<td><input type=text name=iegades_datums size=10 value="+cstr(dateprint(date()))+"></td>"
		Response.Write "<td><input type=text name=piezimes_i size=12 value='Pieteikums speciâli ballei'></td>"
	 else
		Response.Write "<td></td>"
		Response.Write "<td></td>"
		'Response.Write "<td><input type=number name=newphone size=10></td>"
		Response.Write "<td></td>"
		Response.Write "<td></td>"
		Response.Write "<td></td>"
	 end if %>
 
 <td>
	<%'if rGrupa("veids") = 6 then %>
		<input type=button value=Meklçt onclick="window.open('dalibn_izvele.asp?return_id=forma.klients&return_name=klients')" id=button1 name=button1> 
		<input type="image" name="pievienot" src="impro/bildes/pievienot.jpg" alt="Tiek pievienota persona." onclick="if(form.klients.value!=''){TopSubmit(&quot;balle_edit.asp?add=1&gid=<%=gid%>&num=<%=num%>&quot;)}else{alert('Nav norâdîts dalîbnieka Vârds, Uzvârds!');return false;}">
	<%'else%>
		<!--input type="image" name="pievienot" src="impro/bildes/pievienot.jpg" alt="Tiek pievienota persona." onclick="TopSubmit(&quot;balle_edit.asp?add=1&gid=<%=gid%>&num=<%=num%>&quot;)"-->
	<%'end if%>
 </td>
</tr>
 <%
end If
End if


If gid="" Then
	Set rgalds = conn.execute("select * from balle where sektors = '"+sektors+"' and num = "+CStr(numurs))
	%><BR>Galds:<%=sektors%><%=numurs%><BR>
	Nosaukums:<input type=text size=30 name=gnosaukums value="<%=rgalds("nosaukums")%>"><BR>
	Piezîmes:<input type=text size=30 name=gpiezimes value="<%=rgalds("piezimes")%>"><BR>
	<input type=button value="Saglabât" onclick="TopSubmit(&quot;balle_edit.asp?gnosaukums=1&gid=<%=gid%>&num=<%=num%>&quot;)">
	<BR><BR><%
End if


set r = server.createobject("ADODB.Recordset")


'--- atrod jaunâko balles grupu	
ssql = "SELECT max(g.id) as id FROM grupa g inner join marsruts m on m.id = g.mid " + _
	   "where v like '%balle%'"
set r_g = conn.execute(ssql)
balles_grupa = r_g("id")

q = "select dalibn.id as id, b_sektors, b_numurs, pieteikums.id as pid, vards, IsNull(uzvards,nosaukums) as uzvards, (IsNull(talrunisMob,talrunisM)) as talrunis, IsNull(balle_vietas,0) as balle_vietas, balle_datums, IsNull(balle_brivbiletes,0) as balle_brivbiletes, pieteikums.balle_piezimes from grupa inner join pieteikums on gid = grupa.id inner join dalibn on dalibn.id = pieteikums.did " & _
" where pieteikums.deleted = 0 and grupa.id = "+CStr(balles_grupa)+"  and  b_sektors = '" & CStr(sektors) & "' and b_numurs = " + CStr(numurs) + " "

If gid<>"" And gid<>"0" then
	q = q + " and pieteikums.id in (select pid from balles_pieteikumi where gid = "+gid+") "
End If

q = q + " order by balle_datums desc, balle_vietas desc, balle_brivbiletes desc, uzvards, vards asc"

 ''Response.write q
 r.open q,conn,3,3


i = 1
ids = "0"
while not r.eof
	ids = ids + "," + CStr(r("id"))

	If request.querystring("did") = CStr(r("id")) then
		Response.Write "<tr bgcolor = #FF8888>" 
	Else
		Response.Write "<tr bgcolor = #fff1cc>" 
	End if

	%>
	<td><%=i%></td>
	<td><a href = 'pieteikums.asp?pid=<%=cstr(r("pid"))%>'><img src='impro/bildes/k_zals.gif' style="border:none" ></a></td>
	<td>
	<%
	Response.Write "<a href=""dalibn.asp?i=" & r("id") & """>" & r("vards") & "</a></td><td>" 
	Response.Write "<a href=""dalibn.asp?i=" & r("id") & """>" & r("uzvards") & "</a></td><td>" 
	Response.Write "<input size=2 type=text name=vs" & r("pid") & " value=" & r("balle_vietas") & "></td><td>"
	Response.Write "<input size=2 type=text name=bb" & r("pid") & " value=" & r("balle_brivbiletes") & "></td><td>"
	If gid<>"" then
		if rGrupa("veids") = 6 then
		Response.Write "S<input size=2 type=text name=kn" & r("pid") & " value=" & r("balle_knum") & "></td><td>"
		Response.Write "<input size=20 maxlength=30 type=text name=kno" & r("pid") & " value=""" & r("balle_knos") & """></td><td>"
		end If
	End if
	Response.Write r("talrunis") & "</td>" 
	%><td><input type=text size=9 name=b<%=r("pid")%> value='<%=DatePrint(r("balle_datums"))%>'></td><td><%
	Response.Write "<input type=text size=30 name=pz" & r("pid") & " value=""" & r("balle_piezimes") & """></td>"
	%>
	
	<td>
		<input type="image" name="saglabat" src="impro/bildes/saglabat.jpg" style="border:none"  alt="Tiek saglabâtas izmaiòas, kas izdarîtas dotajai personai." onclick="TopSubmit(&quot;balle_edit.asp?gid=<%=gid%>&pid=<%=r("pid")%>&num=<%=Request.QueryString("num")%>&quot;)">
		<a target="none" href="piet_vesture.asp?pid=<%=r("pid")%>">
			<img style="border:none"  src="impro/bildes/clock.bmp" alt="Apskatît ðî pieteikuma vçsturi.">
		</a>

	<%if not grey then%>
		<a href=orderis.asp?pid=<%=r("pid")%>&balles_biletes=<%=r("balle_vietas")%>&sektors=<%=r("b_sektors")%><%=r("b_numurs")%>&gid=<%=gid%>&num=<%=num%>><img style="border:none" src="impro/bildes/drukat.jpg" alt="Tiek izdrukâts orderis par biïetçm" ></a>
	<% end if %>

	</td></font></tr>
	<%
r.movenext
i = i + 1
Wend


If gid<>"" then
	set r = server.createobject("ADODB.Recordset")



	q = "select dalibn.id as id, pieteikums.id as pid, vards, IsNull(uzvards,nosaukums) as uzvards, (IsNull(talrunisMob,talrunisM)) as talrunis, IsNull(balle_vietas,0) as balle_vietas, balle_datums, IsNull(balle_brivbiletes,0) as balle_brivbiletes, pieteikums.balle_piezimes from grupa inner join pieteikums on gid = grupa.id inner join dalibn on dalibn.id = pieteikums.did " & _
	" where pieteikums.deleted = 0 and grupa.id = " & CStr(gid) & _ 
	" order by balle_datums desc, balle_vietas desc, balle_brivbiletes desc, uzvards, vards asc"


	 q = "select distinct dalibn.id as id, pieteikums.id as pid, vards, IsNull(uzvards,nosaukums) as uzvards, (IsNull(talrunisMob,talrunisM)) as talrunis, IsNull(balle_vietas,0) as balle_vietas, balle_datums, IsNull(balle_brivbiletes,0) as balle_brivbiletes, pid, balle_knum, balle_knos, pieteikums.balle_piezimes from grupa inner join pieteikums on gid = grupa.id inner join piet_saite on pid = pieteikums.id " & _
	 "inner join dalibn on piet_saite.did = dalibn.id " & _
	 "where not dalibn.id in ("+ids+") and grupa.id = " & gid & " and (not gid in (292,3100) or isnull(balle_knum," & code & ") = " & Right(num,Len(num)-1) & ") and (kvietas_veids in (1,2,4,5) or persona = 1  or balle_vietas>0) and (not isnull(kvietas_veids,0)=3) and piet_saite.deleted = 0 and pieteikums.deleted = 0 and (gid not in (292,3100) or sakuma_datums >= '12/7/" + CStr(CLng(Year(now)) - 1) + "' and sakuma_datums <='12/31/" + CStr(CLng(Year(now))) + "') " & _
	 "order by balle_datums desc, balle_vietas desc, balle_brivbiletes desc, uzvards, vards asc"


	'Response.write q
	r.open q,conn,3,3


	while not r.eof
		If request.querystring("did") = CStr(r("id")) then
			Response.Write "<tr bgcolor = #FF8888>" 
		Else
			Response.Write "<tr bgcolor = #e3d9c4>" 
		End if
		
		%>
		<td><%=i%></td>
		<td><a href = 'pieteikums.asp?pid=<%=cstr(r("pid"))%>'><img src='impro/bildes/k_zals.gif'></a></td>
		<td>
		<%
		Response.Write "<a href=""dalibn.asp?i=" & r("id") & """>" & r("vards") & "</a></td>" 
		Response.Write "<td><a href=""dalibn.asp?i=" & r("id") & """>" & r("uzvards") & "</a></td>" 
		Response.Write "<td></td>"
		Response.Write "<td></td>"
		if rGrupa("veids") = 6 then
		Response.Write "<td>S<input size=2 type=number name=kn" & r("pid") & " value=" & r("balle_knum") & "></td>"
		Response.Write "<td><input size=20 maxlength=30 type=number name=kno" & r("pid") & " value=""" & r("balle_knos") & """></td>"
		end if
		Response.Write "<td>" + nullprint(r("talrunis")) & "</td>" 
		Response.Write "<td></td>"
		Response.Write "<td></td>"
		numurs = Right(num,Len(num)-1)
		%>
		
		<td>
			<a href="balle_add.asp?gid=<%=gid%>&sektors=<%=regions%>&did=<%=r("id")%>&numurs=<%=numurs%>"><img src="impro/bildes/pievienot.jpg" alt="Izveidot balles pieteikumu.">
			<a target="none" href="piet_vesture.asp?pid=<%=r("pid")%>">
				<img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît ðî pieteikuma vçsturi.">
			</a>


		</td></font></tr>
		<%
	r.movenext
	i = i + 1
	Wend
End if

%>
</table>
</form>
</body>
</html>
