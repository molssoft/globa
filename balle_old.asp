<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Balles biïetes","y1.jpg"
DefJavaSubmit

if request.form("regions") <> "" then
	
	regions = Request.Form("regions")
	
elseif Request.QueryString("reg")="s" then
	
	regions = "K"
	
else
	
	regions = ""
end if


'--- pievieno sektoram jaunu galdu
galda_num = Request.Form("galda_num")
if galda_num <> "" then
		
	igads = cstr(year(date()))
	'--- parbauda vai tads jau eksistç
	ssql = "SELECT * FROM balle WHERE gads = '"+igads+"' AND sektors='"+regions+"' AND galds=1 AND num="+cstr(galda_num)
	set r = conn.execute(ssql)
	if r.EOF then
		conn.execute("INSERT INTO balle(gads,sektors,num,galds,max_vietas) VALUES('"+igads+"','"+regions+"',"+cstr(galda_num)+",1,0)")
		session("message") = "Galds "+regions+cstr(galda_num)+" pievienots<br>"
	else
		session("message") = "Galds "+regions+cstr(galda_num)+" jau eksistç<br>"
	end if

end if

 

%>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Balles biïetes</b></font><hr>

<%
' standarta saites

headlinks

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

'@ 0 Atver valûtu tabulu
if regions <> "" then
 
 valstis = CountriesByRegion(regions)
 
 set r = server.createobject("ADODB.Recordset")
 set rs = server.createobject("ADODB.Recordset")
 set rNext = server.createobject("ADODB.Recordset")
 set r_cnt = server.createobject("ADODB.Recordset")
 
 if regions <> "K" then
 
  q1 = "select IsNull(balle_numurs,0) as balle_numurs, piezimes_2, balle_numurs_sub, IsNull(sum(balle_vietas),0) as personas, IsNull(balle_maxvietas,0) as balle_maxvietas, IsNull(sum(balle_brivbiletes), 0) as brivas, v, IsNull(sakuma_dat,'') as sakuma_dat, grveidi.burts, grupa.id from pieteikums " & _
  "inner join grupa on gid = grupa.id " & _
  "inner join marsruts on mid = marsruts.id " & _
  "inner join grveidi on veids = grveidi.id " & _
  "where (((sakuma_dat >= '12/31/2013' and sakuma_dat <'12/31/2014') and atcelta <> 1 and veids in (1,2))" & _
  "and valsts in (" & cstr(valstis) & ") and pieteikums.deleted <> 1 and isnull(balle_sektors,'')<>'K')" & _
  "group by IsNull(balle_numurs,0), IsNull(balle_numurs,999999999), v, sakuma_dat, grveidi.burts, grupa.id, balle_maxvietas, balle_numurs_sub, piezimes_2 " & _
  "order by IsNull(balle_numurs,999999999), v, sakuma_dat"
  '"having not sum(balle_vietas) is null"
  
  q2 = "select IsNull(balle_numurs,0) as balle_numurs, IsNull(sum(balle_vietas),0) as personas, v, IsNull(sakuma_dat,'') as sakuma_dat, grveidi.burts, grupa.id from grupa " & _
  "left outer join pieteikums on gid = grupa.id and IsNull(balle_datums,'') <> '' and pieteikums.deleted <> 1 " & _
  "left outer join marsruts on mid = marsruts.id " & _
  "left outer join grveidi on veids = grveidi.id " & _
  "where (((sakuma_dat >= '12/31/2013' and sakuma_dat <'12/31/2014') and atcelta <> 1 and veids in (1,2)) " & _
  "and valsts in (" & cstr(valstis) & ") and isnull(balle_sektors,'')<>'K' ) " & _
  "group by IsNull(balle_numurs,0), IsNull(balle_numurs,999999999), v, sakuma_dat, grveidi.burts, grupa.id " & _
  "order by IsNull(balle_numurs,999999999), v, sakuma_dat"
  
  q3 = "select IsNull(balle_numurs,0) as balle_numurs, IsNull(sum(balle_vietas),0) as personas, IsNull(balle_maxvietas,0) as balle_maxvietas, IsNull(sum(balle_brivbiletes), 0) as brivas, v, IsNull(sakuma_dat,'') as sakuma_dat, grveidi.burts, grupa.id, gv.vards, gv.uzvards from pieteikums " & _
  "inner join grupa on gid = grupa.id " & _
  "inner join marsruts on mid = marsruts.id " & _
  "inner join grveidi on veids = grveidi.id " & _
  "left join grupu_vaditaji gv on gv.idnum = grupa.vaditajs " & _
  "where (((sakuma_dat >= '12/31/2013' and sakuma_dat <'12/31/2014') and atcelta <> 1 and veids in (1,2))" & _
  "and valsts in (" & cstr(valstis) & ") and pieteikums.deleted <> 1 and isnull(balle_sektors,'')<>'K' )" & _
  "group by IsNull(balle_numurs,0), IsNull(balle_numurs,999999999), v, sakuma_dat, grveidi.burts, grupa.id, balle_maxvietas, gv.vards, gv.uzvards " & _
  "order by IsNull(balle_numurs,999999999), v, sakuma_dat"
  '"having not sum(balle_vietas) is null"

	'---bileshu skaits ------

	ssql = "SELECT IsNull(balle_numurs,b_numurs) as balle_numurs, IsNull(sum(balle_vietas),0) as biletes, " + _  
			"IsNull(sum(balle_brivbiletes),0) as brivbiletes, IsNull(balle_datums,0) as izpirkts, IsNull(balle_maxvietas,0) as balle_maxvietas " + _
			"FROM pieteikums " + _
			"inner join grupa on gid = grupa.id " + _ 
			"inner join marsruts on mid = marsruts.id " + _ 
			"inner join grveidi on veids = grveidi.id " + _ 
			"WHERE (veids in (1,2) and valsts in (" & cstr(valstis) & ") " + _
			"and  isnull(balle_sektors,'')<>'K' " + _
			"or (b_sektors='"+regions+"' and isnull(b_numurs,0)<>0) ) " + _
			"and pieteikums.deleted <> 1 and atcelta <> 1 and sakuma_dat between '12/31/2013' and '12/31/2014' " + _
			"and (isnull(balle_vietas,0)<>0 or isnull(balle_brivbiletes,0)<>0) " + _
			"GROUP BY IsNull(balle_numurs,b_numurs), balle_datums, balle_maxvietas " + _
			"ORDER BY balle_numurs"
 
	'-------------------------
   

 else
  
  q1 = "select IsNull(balle_knum,IsNull(balle_numurs,0)) as balle_numurs, piezimes_2, balle_numurs_sub,Min(IsNull(balle_knos,'')) as balle_knos, sum(balle_vietas) as personas, IsNull(balle_maxvietas,0) as balle_maxvietas, IsNull(sum(balle_brivbiletes), 0) as brivas, sakuma_dat, v, grveidi.burts, grupa.id from pieteikums " & _
  "inner join grupa on gid = grupa.id " & _
  "inner join marsruts on mid = marsruts.id " & _
  "inner join grveidi on veids = grveidi.id " & _
  "where gid not in (292,3100) and " & _
  "(balle_sektors='K' and sakuma_dat between '12/31/2013' and '12/31/2014') and pieteikums.deleted = 0 " & _
  "group by IsNull(balle_knum,IsNull(balle_numurs,0)), IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, grveidi.burts, grupa.id, balle_maxvietas, balle_numurs_sub, piezimes_2, sakuma_dat " & _
  "order by IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, sakuma_dat"
  
  q2 = "select IsNull(balle_knum,IsNull(balle_numurs,0)) as balle_numurs, sum(balle_vietas) as personas, IsNull(sum(balle_brivbiletes), 0) as brivas, '01/01/1900' as sakuma_dat, v, grveidi.burts, grupa.id from " & _
  "(select piet.id, gid, dbo.IFDNULL(balle_datums,0,balle_vietas) as balle_vietas, balle_datums, balle_knum, sakuma_datums, balle_brivbiletes, piet.deleted from pieteikums piet inner join grupa gr on gr.id = piet.gid where (gid in (292,3100) and sakuma_datums between '12/31/2013' and '12/10/" & CStr(CLng(2009)) & "') OR (balle_sektors='K' and sakuma_dat between '12/31/2013' and '12/31/2014') ) as pieteikums " & _
  "inner join grupa on gid = grupa.id " & _
  "inner join marsruts on mid = marsruts.id " & _
  "inner join grveidi on veids = grveidi.id " & _
  "where (IsNull(valsts,'CITA') in ('CITA') OR (balle_sektors='K' and sakuma_dat between '12/31/2013' and '12/31/2014') ) and pieteikums.deleted <> 1 " & _
  "group by IsNull(balle_knum,IsNull(balle_numurs,0)), IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, grveidi.burts, grupa.id " & _
  "order by IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, sakuma_dat"
  
  q3 = "select IsNull(balle_knum,IsNull(balle_numurs,0)) as balle_numurs, Min(IsNull(balle_knos,'')) as balle_knos, sum(balle_vietas) as personas, IsNull(balle_maxvietas,0) as balle_maxvietas, IsNull(sum(balle_brivbiletes), 0) as brivas, sakuma_dat, v, grveidi.burts, grupa.id, gv.vards, gv.uzvards from pieteikums " & _
  "inner join grupa on gid = grupa.id " & _
  "inner join marsruts on mid = marsruts.id " & _
  "inner join grveidi on veids = grveidi.id " & _
  "left join grupu_vaditaji gv on gv.idnum = grupa.vaditajs " & _  
  "where gid not in (292,3100) and " & _
  "(balle_sektors='K' and sakuma_dat between '12/31/2013' and '12/31/2014') and pieteikums.deleted <> 1 " + _
  "group by IsNull(balle_knum,IsNull(balle_numurs,0)), IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, grveidi.burts, grupa.id, balle_maxvietas, sakuma_dat, gv.vards, gv.uzvards " & _
  "order by IsNull(balle_knum,IsNull(balle_numurs,999999999)), v, sakuma_dat"
 '(kods like '%K.PID%' and IsNull(valsts,'CITA') in (" & cstr(valstis) & "))
 
 '---bileshu skaits ------

	ssql = "SELECT IsNull(balle_numurs,IsNull(b_numurs,0)) as balle_numurs, IsNull(sum(balle_vietas),0) as biletes, " + _  
			"IsNull(sum(balle_brivbiletes),0) as brivbiletes, IsNull(balle_datums,0) as izpirkts, IsNull(balle_maxvietas,0) as balle_maxvietas " + _
			"FROM pieteikums " + _
			"inner join grupa on gid = grupa.id " + _ 
			"inner join marsruts on mid = marsruts.id " + _ 
			"inner join grveidi on veids = grveidi.id " + _ 
			"where gid not in (292,3100) and " & _
			"((balle_sektors='K' or b_sektors='K') and sakuma_dat between '12/31/2013' and '12/31/2014') and pieteikums.deleted = 0 " & _
			"GROUP BY IsNull(balle_numurs,IsNull(b_numurs,0)), balle_datums, balle_maxvietas " + _
			"ORDER BY balle_numurs"
 
	'-------------------------
   
 
 end if

'Response.Write(q1+"<BR><BR>")
'Response.Write(q2+"<BR><BR>")
'Response.Write(q3+"<BR>")
'Response.Write(ssql+"<BR>")
'Response.end

 r.open q1,conn,3,3
 rs.Open q2,conn,3,3
 rNext.open q3,conn,3,3
 r_cnt.Open ssql,conn,3,3
 
end if




'--- ieraksti no tabulas balle.
'--- paredz iespçju izveidot papildus galdus jebkurâ no reìioniem. (iepriekð tas tika piesaistîts grupâm)

ssql = "SELECT * FROM balle WHERE datepart(yyyy,gads)=year(getdate()) AND sektors='"+regions+"' AND galds=1 ORDER BY num"
set r_pg = conn.execute(ssql)
''rw ssql

ssql = "select p.b_numurs, isnull(sum(case when isnull(p.balle_datums,'') <> '' then p.balle_vietas " + _
		"else 0 end), 0) AS datums, sum(isnull(p.balle_vietas,0)) as vietas, sum(isnull(p.balle_brivbiletes,0)) as brivbiletes " + _
		"from balle b inner join pieteikums p on b.pid = p.id " + _
		"where datepart(yyyy,gads)=year(getdate()) AND sektors='"+regions+"' AND galds=0 " + _
		"group by p.b_numurs"
		
set r_pg_skaits = conn.execute(ssql)
'rw ssql

'------------------------------

%>

<form name="forma" method = "POST">
<font color="BLACK" size="3"><br><b>Izvçlçties ceïojumu reìionu
<table>
<tr><td bgcolor = #ffc1cc>Reìions: </td><td bgcolor = #fff1cc><select name="regions">
<option value="R" <%if regions = "R" then Response.Write "selected"%>>Rietumeiropa</option>
<option value="Z" <%if regions = "Z" then Response.Write "selected"%>>Ziemeïeiropa</option>
<option value="C" <%if regions = "C" then response.write "selected"%>>Centrâleiropa</option>
<option value="E" <%if regions = "E" then Response.Write "selected"%>>Eksotiskâs valstis</option>
<option value="K" <%if regions = "K" then Response.Write "selected"%>>Sports / Individuâlie</option>
</select></td>
<td><input type="submit" name = "poga" value = "Izvçlçties"></td></tr>

<%if Request.Form("regions") <> "" then ' and Request.Form("regions") <> "K" then 
	if regions = "K" then regions = "S"%>
<tr>
	<td align="right"><%=regions%></td>
	<td><input type="text" name="galda_num" /></td>
	<td><input type="button" name="poga_izv_galdu" value="Pievienot galdu" onclick="TopSubmit('balle.asp')"></td>
</tr>
<%end if%>

</table>

<!--@ 0 Attçlo tabulu -->

<%
if Request.Form("regions") <> "" then %>
<br>
<table width="100%">
<tr bgcolor = #ffC1cc>
<th>Nr.</th>
<th>Tips</th>
<th <% 'if Request.Form("regions") = "K" then Response.Write "nowrap width='8%'"%>>Ceïojums</th>
<%if request.form("regions") = "K" then %>
 <th nowrap width='15%'>Galda nos</th>
<%end if%>
<th>Datums</th>
<th>Grupas vad.</th>
<th>piet./izp.(max)</th>
<th>Piezîmes</th>
</tr>
<%
if regions = "K" then regions = "S"

rNext.MoveNext
i = 0
done = false
ps1 = 0
ps2 = 0



while not r.eof

 piezimes_2 = r("piezimes_2")

 If r("balle_numurs") = 0 and not done then
  done = true
  
  '--- papildus galdi -----------
  
	pg_sum_piet = 0
	pg_sum_izp = 0

	while not r_pg.eof
		g_id = r_pg("id")
		g_num = r_pg("num")
		g_reg = r_pg("sektors")
		g_nos = r_pg("nosaukums")
		g_piezimes = r_pg("piezimes")
		g_max = r_pg("max_vietas")
		g_piet = 0
		g_izp = 0
		
		do while not r_pg_skaits.eof
			
			if(r_pg_skaits("b_numurs")=g_num) then
			
				g_piet = r_pg_skaits("vietas")+r_pg_skaits("brivbiletes")
				g_izp = r_pg_skaits("datums")
				
				pg_sum_piet = pg_sum_piet + g_piet
				pg_sum_izp = pg_sum_izp + g_izp
				
				
				r_pg_skaits.movenext
				
				if r_pg_skaits.EOF then exit do
				
			else
				exit do
			end if
			
		loop

		
		%>
	
		<tr bgcolor="#fff1cc">
			<td><%=regions%><%=g_num%></td>
			<td>V1</td>
			<td <% If Request.Form("regions") = "K" then %>colspan="2"<% end if%>><%=g_nos%></td>
			
			<td width="15%"><a href="balle_edit_pg.asp?reg=<%=g_reg%>&num=<%=g_num%>">nav</a></td>
			<td></td>
			<td>
				<%if(g_piet<>"0")then%>
					<%=g_piet%>/<%=g_izp%><font color='blue'>(<%=g_max%>)</font>
				<%end if%>
			</td>			
			<td width="200"><%=g_piezimes%></td>
		</tr>
  
		<%
		r_pg.movenext
	wend
 
  '------------------------------

  ps1 = ps1 + pg_sum_piet
  ps2 = ps2 + pg_sum_izp
  
  Response.Write "<tr><td><strong><u>" & regions & "</td><td colspan="
  If Request.Form("regions") = "K" then Response.Write 5 else Response.Write 4
  Response.Write "><strong><u>Kopâ</td><td><strong><u>" & ps1 & "/" & ps2 & "</td></tr>"
 
 end if
 
 If r("balle_numurs") = 0 then Response.Write "<tr bgcolor = #e3d9c4>" else Response.Write "<tr bgcolor = #fff1cc>"
	Response.Write "<td>" 
	If r("balle_numurs") = 0 then Response.Write "<font color = gray>" else Response.Write "<font color=black>" & regions
	Response.Write r("balle_numurs") & ".</td>"
 Response.Write "<td>" 
 
 If r("balle_numurs") = 0 then Response.Write "<font color = gray>" else Response.Write "<font color=black>"
 Response.Write r("burts") & "</td>"
 %><td <%'if Request.Form("regions") = "K" then Response.Write "nowrap width=8%"%>><%
 
 If r("balle_numurs") = 0 then Response.Write "<font color = gray>" else Response.Write "<font color=black>"
 
 If Left(r("v"),8) = "Rezerves" then Response.Write "<b>"
 Response.Write Replace(r("v"),"!Kompleksie un individuâlie pasûtîjumi","!Kompl/ind")
 position = 0
 j = i
 
 if not rNext.EOF then
  Do While (not rNext.EOF)
   If r("balle_numurs") <> rNext("balle_numurs") or r("balle_numurs") = 0 then Exit Do
   If rNext("v") <> r("v") then Response.Write "<br>" & rNext("v")
   rNext.MoveNext
   j = j + 1
  Loop
  rNext.MoveFirst
  rNext.Move i
 end if
 
 'Response.Write "<a href='balle_edit.asp?gid=" & r("id") & "&num=" & regions & r("balle_numurs") & "'>" & r("v") & "</a>
 Response.Write "</td><td width='300'>"
 if request.form("regions") = "K" then
  If r("balle_numurs") = 0 then Response.Write "<font color = gray>" else Response.Write "<font color=black>"
  Response.Write r("balle_knos") '!!!
  Response.Write "</td><td>"
 end if
 
'--- datums
 Response.Write "<a href='balle_edit.asp?gid=" & r("id") & "&num=" & regions & r("balle_numurs") & "'>"
 
If isnull(r("sakuma_dat")) then 
	Response.write "nav" 
else
	if r("personas")> 0 or r("brivas")> 0 then 
		Response.Write("<b>" + DatePrint(r("sakuma_dat")) + "</b>")
	else
		Response.Write DatePrint(r("sakuma_dat"))
	end if
end if
 
 'If DatePrint(r("sakuma_dat")) = "1/1/1900" then Response.write "nav" else Response.Write DatePrint(r("sakuma_dat"))
 Response.Write "</a>"
 
  str_gr_vad = ""
	
  Do While not rNext.EOF
     If r("balle_numurs") <> rNext("balle_numurs") or r("balle_numurs") = 0 then exit do
	 str_gr_vad = str_gr_vad + rNext("vards") + " " + rNext("uzvards") +"<br>"    
     rNext.MoveNext
  Loop
  
  rNext.MoveFirst
  rNext.Move i+1
  
 'If not rNext.EOF then
 
  Do While not rNext.EOF

		
	If r("balle_numurs") <> rNext("balle_numurs") or r("balle_numurs") = 0 then exit do
	
	Response.Write " <a href='balle_edit.asp?gid=" & rNext("id") & "&num=" & regions & rNext("balle_numurs") & "'>"
	
	if rNext("personas") > 0 or rNext("brivas")> 0 then 
		Response.Write("<b>" + DatePrint(rNext("sakuma_dat")) + "</b></a>")
	else
		Response.Write(DatePrint(rNext("sakuma_dat")) + "</a>")
	end if
	
   rNext.MoveNext
  Loop
 
' End If
 
 Response.Write "</td>"
 
 '-------
 
 '--- grupas vadîtâji
 if isnull(str_gr_vad) then str_gr_vad = ""
 Response.Write "<td><font size=2>"+str_gr_vad+"</font></td>"
 '--------------
 
 '---bileshu skaits pieteikts/izpirkts(max skaits)------
	
	pieteikts = 0
	izpirkts = 0
	max_vietas = 0
	
		
	'if not r_cnt.EOF then		
		'while r_cnt("balle_numurs")=0
		
		do while not r_cnt.EOF 'r_cnt("balle_numurs")=0 
			
			if r_cnt("balle_numurs") < r("balle_numurs") then
				r_cnt.MoveNext
			else
				exit do
			end if
		loop

	'end if
	
	' Response.Write("<br>"+cstr(r_cnt("balle_numurs"))+" =? "+cstr(r("balle_numurs"))+"<br>")
		
		do while not r_cnt.eof
			
			
			if r_cnt("balle_numurs") = r("balle_numurs") then
			
				pieteikts = pieteikts + r_cnt("biletes") + r_cnt("brivbiletes")

				if r_cnt("izpirkts")<>"1/1/1900" then	
				
					izpirkts = izpirkts + r_cnt("biletes")
						
				end if

				'--- izòemums, izmanto tikai k sektoraa chartetiem un ind
				if r_cnt("biletes")<>0 or r_cnt("brivbiletes")<>0 then	
					max_vietas = max_vietas + r_cnt("balle_maxvietas")
				end if				
				
				r_cnt.MoveNext
				
				if r_cnt.EOF then exit do
				
			else
				exit do
			end if
			
		loop

	
	
 
	
 '--- ðî bloka p mainiigie tiek paarakstiiti zemaak, bet recordseta magiskaas darbiibas paliek (4 Nov 2008 Nils) -------------


 p1 = 0
 p2 = 0
 p3 = 0
 
 theend = false
 
 if rNext.EOF then
  x = r("balle_numurs")
  theend = true
 else
  x = rNext("balle_numurs")
 end if
 
 moved = false
 
 Do While r("balle_numurs") <> x
  moved = true
  p1 = p1 + r("personas") + r("brivas")
  p2 = p2 + rs("personas") + r("brivas")
  p3 = p3 + r("balle_maxvietas")
  r.MoveNext
  i = i + 1
  rs.MoveNext
  if r("balle_numurs") = 0 or rNext.EOF then Exit Do 
 Loop
 
 if moved and not theend then
  r.MovePrevious
  i = i - 1
  rs.MovePrevious
 elseif theend then
  p1 = p1 + r("personas") + r("brivas")
  p2 = p2 + rs("personas") + r("brivas")
  p3 = p3 + r("balle_maxvietas")
  
 end if

'--- bloka beigas ----------------------
 
  
  p1 = pieteikts
  p2 = izpirkts
 
 if request.form("regions") = "K" and (r("id") = 292 or r("id") = 3100) then
   p3 = max_vietas
 end if

 
 If r("balle_numurs") = 0 then Response.Write "<font color = 'gray'>" else Response.Write "<font color='black'>"
 
 Response.Write "<td>"
 
 If p1 = 0 then 
	Response.Write "<font color='gray'>" 
 elseif p1 < 36 and (p1 < 16 or request.form("regions") <> "K") then
	Response.Write "<font color='black'>"
 else 
	Response.Write "<font color='black'>"
	'Response.Write "<strong><font color='red'>"
 end if
 

 if p1 <> "0" then
	if request.form("regions") <> "K" or p3 <> "0" then
		Response.write p1 & "/" & p2 & " <font color='blue'>(" & p3 & ")</td>"
	else
		Response.write p1 & "/" & p2 & "</td>"
	end if
 end if
 
 ps1 = ps1 + p1
 ps2 = ps2 + p2


	'----------------------------------------
	if piezimes_2<>"" then
		response.write "<td>"+piezimes_2+"</td>"
	else
		response.write "<td>&nbsp;</td>"
	end if
	'----------------------------------------

	response.write "</tr>"
	
	if not rNext.EOF then rNext.MoveNext
	if not r.EOF then r.MoveNext
	if not rs.EOF then rs.MoveNext
	i = i + 1
wend

If not done then
  done = true
  Response.Write "<tr><td><strong><u>" & Request.Form("regions") & "</td><td colspan="
  'If Request.Form("regions") = "K" then Response.Write 4 else Response.Write 3
  Response.Write "><strong><u>Kopâ</td><td><strong><u>" & ps1 & "/" & ps2 & "</td></tr>"
 end if
%>
</table>
<% end if %>

</form>
</body>
</html>
