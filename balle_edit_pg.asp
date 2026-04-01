<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Balles biïetes","y1.jpg"
DefJavaSubmit

cnt = 0 'counter

if Request.Form("num")<>"" then

	regions = Request.Form("regions")
	num = Request.Form("num")
	old_num = Request.Form("old_num")
	nos = Request.Form("nosaukums")
	gid = Request.Form("gid") 'galda id
	pid = cstr(Request.Form("pid"))
	maxv = Request.Form("max_vietas")
	g_piezimes = Request.Form("piezimes")
	
	
	piezimes = Request.Form("piezimes_"+pid)
	vietas = Request.Form("vietas_"+pid)
	brivbiletes = Request.Form("brivbiletes_"+pid)
	datums = Request.Form("datums_"+pid)
	
	if pid<>"" then '--- saglabâ info par pieteikumu
	
		if vietas="" then vietas="null"
		if brivbiletes="" then brivbiletes="null"
		if trim(datums)="" then 
			datums="null"
		else
			datums = "'"+sqldate(datums)+"'"
		end if
		
		
		ssql = "UPDATE pieteikums SET balle_vietas="+vietas+", balle_brivbiletes="+brivbiletes+", balle_datums= "+datums+", balle_piezimes='"+piezimes+"' WHERE id=" + pid
		'rw ssql
		conn.execute(ssql)
		
		 LogUpdateAction "pieteikums",pid

	else '--- saglabaa info par galdu
	
		if maxv = "" then maxv = "null"	
		if getnum(num)>0 then 
			
			
						
			if old_num<>num then
				'--- parbauda vai tads galda numurs jau eksistç
				igads = cstr(year(date()))
				ssql = "SELECT * FROM balle WHERE gads = '"+igads+"' AND sektors='"+regions+"' AND galds=1 AND num="+cstr(num)
				'Response.Write "UPDATE balle SET num = "+cstr(num)+", piezimes = '"+g_piezimes+"', nosaukums='" + nos + "', max_vietas=" + maxv + " WHERE id=" + gid
				'Response.End 
				
				set r = conn.execute(ssql)
				'ja neeksistç
				if r.eof then
					
					'--- parbauda vai pie vecâ galda ir registreti pieteikumi
					ssql = "select * from pieteikums p " + _ 
							"inner join grupa g on g.id = p.gid " + _
							"inner join marsruts m on m.id = g.mid " + _
							"where p.deleted = 0 and b_sektors = '"+regions+"' and b_numurs = '"+cstr(old_num)+"'  " + _
							"and sakuma_dat between '12/01/" & CStr(Year(Now)) & "' and '12/31/" & CStr(Year(Now)) & "' and v like '%balle%'" 
							
					set r_p = conn.execute(ssql)

					if not r_p.eof then 
						session("message") = "Pie ðî galda ir reìistrçti pieteikumi. Izmaiòas netika saglabâtas."
						num = old_num
					else
						'Response.Write("UPDATE!")
						'Response.end
					
						conn.execute("UPDATE balle SET num = "+cstr(num)+", piezimes = '"+g_piezimes+"', nosaukums='" + nos + "', max_vietas=" + maxv + " WHERE id=" + gid)
					end if
				else
					session("message") = "<div align='center'><p>Galds "+regions+cstr(num)+" jau eksistç. Izmaiòas netika saglabâtas.</p></div>"
					'Response.Write("<div align='center'><p>Galds "+regions+cstr(num)+" jau eksistç. Izmaiòas netika saglabâtas.</p></div>")
					'Response.end
					num = old_num
				end if
			else
				'saglaba parejos galda laukus, jo numurs netika mainits
				conn.execute("UPDATE balle SET piezimes = '"+g_piezimes+"', nosaukums='" + nos + "', max_vietas=" + maxv + " WHERE id=" + gid)
			end if			
		else
			session("message") = "Nav ievadîts galda numurs. Izmaiòas netika saglabâtas."
			'Response.Write("Nav ievadîts galda numurs. Izmaiòas netika saglabâtas.")
			'Response.end
		end if
	end if
else

	regions = request.querystring("reg")
	num = request.querystring("num")
	if num = "" then 
		session("message") = "Nav norâdîts galda numurs."
		'Response.Write("Nav norâdîts galda numurs.")
		'Response.end
	end if
	
end if

if num <> "" then 

	'--- iegûst info par galdu

	ssql = "SELECT * FROM balle WHERE galds=1 AND datepart(yyyy,gads)=year(getdate()) AND sektors='"+regions+"' AND num="+num
	set r_pg = conn.execute(ssql)
	
	
	'---- iegûst visus pieteikumus pie ðî galda

	ssql = "SELECT b.*, d.vards, d.uzvards, isnull(d.talrunisM, d.talrunisMob) as telefons, p.balle_vietas, p.balle_datums, p.balle_brivbiletes, p.balle_piezimes as p_piezimes " + _ 
			"FROM balle b INNER JOIN dalibn d ON d.id = b.did " + _
			"INNER JOIN pieteikums p ON b.pid = p.id " + _
			"WHERE p.deleted=0 AND galds<>1 AND datepart(yyyy,gads)=year(getdate()) AND sektors='"+regions+"' AND num=" + num
		   
	set r = conn.execute(ssql)
	'rw ssql
	
else
	Response.End
end if
 

'---------------------------------------------------------------------------------------------------------------------
%>
<body>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Balles biïetes grupai</b></font><hr>

<%
' standarta saites
headlinks

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if not r_pg.eof then	   
	nosaukums = r_pg("nosaukums")
	max_vietas = r_pg("max_vietas")
	gid = r_pg("id")
	g_piezimes = r_pg("piezimes")
end if




%>


<br>
<form name=forma action="balle_edit_pg.asp" method="POST">
<input type="hidden" name="pid">
<input type="hidden" name="regions" value="<%=regions%>">
<input type="hidden" name="old_num" value="<%=num%>">
<input type="hidden" name="gid" value="<%=gid%>">

<font color="BLACK" size="3"><b>Papildus galds</b></font>
<br><br>
<table>
	<tr>
		<td>Numurs <% if regions = "K" then Response.Write("S") else  Response.Write(regions) end if%></td>
		<td><input type="text" name="num" value="<%=num%>" size="5" maxlength="3"></td>
	</tr>
	<tr>
		<td>Nosaukums</td>
		<td><input type="text" name="nosaukums" value="<%=nosaukums%>" size="50" maxlength="50"></td>
	</tr>
	<tr>
		<td>Piezîmes</td>
		<td><input type="text" name="piezimes" value="<%=g_piezimes%>" size="50" maxlength="512"></td>
	</tr>
	<tr>
		<td>Max vietas</td>
		<td><input type="text" name="max_vietas" value="<%=max_vietas%>" size="2" maxlength="2">
			<input type=button value='Saglabât' src="impro/bildes/saglabat.jpg" alt="Tiek saglabâts nosaukums un max vietu skaits." onclick="form.submit();" id=button1 name=button1>
		</td>
	</tr>

</table>
<br><br>
<table>
	<tr bgcolor = #ffC1cc>
		<th>Nr.</th>
		<th>Piet</th>
		<th>Vârds</th>
		<th>Uzvârds</th>
		<th>Vietu skaits</th>
		<th>Bezmaksas</th>
		<th>Telefons</th>
		<th>Iegâdes dat.</th>
		<th>Piezîmes</th>
		<th>.</th>
	</tr>
	<% 
	if not r.eof then

		while not r.EOF 
		
			pid = r("pid")
			did = r("did")
			vards = r("vards")
			uzvards = r("uzvards")
			vietas = r("balle_vietas")
			brivbiletes = r("balle_brivbiletes")
			telefons = r("telefons")
			piezimes = r("p_piezimes")
			
			if not isnull(r("balle_datums")) then
				datums = dateprint(r("balle_datums")) 
			else
				datums = ""
			end if
					
			cnt = cnt + 1
		
			%>
			<tr bgcolor="#fff1cc">
				<td><%=cnt%>.</td>
				<td><a href="pieteikums.asp?pid=<%=pid%>"><%=pid%></a></td>
				<td><a href="dalibn.asp?i=<%=did%>"><%=vards%></a></td>
				<td><a href="dalibn.asp?i=<%=did%>"><%=uzvards%></a></td>
				<td align="right"><input type="text" name="vietas_<%=pid%>" value="<%=vietas%>" size="2"></td>
				<td align="right"><input type="text" name="brivbiletes_<%=pid%>" value="<%=brivbiletes%>" size="2"></td>
				<td><%=telefons%></td>
				<td><input type="text" name="datums_<%=pid%>" value="<%=datums%>" size="10" maxlength="10"></td>
				<td><input type="text" name="piezimes_<%=pid%>" value="<%=piezimes%>" size="30" maxlength="1024"></td>
				<td><input type="image" name="saglabat" src="impro/bildes/saglabat.jpg" alt="Saglabât izmaiòas" onclick="form.pid.value=<%=pid%>;form.submit();">
				<a target="none" href="piet_vesture.asp?pid=<%=pid%>"><img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît ðî pieteikuma vçsturi."></a>
				<%if vietas > 0 then%>
					<input type="image" name="drukat" src="impro/bildes/drukat.jpg" alt="Tiek izdrukâti dati par vçlamajâm biïetçm" onclick="TopSubmit(&quot;balle_print.asp?num=<%=regions%><%=num%>&burts=<%=nr_sub%>&name=<%=r("vards")%>%20<%=r("uzvards")%>&count=<%=r("balle_vietas")%>&quot;)">
				<% end if %>				
				</td>
			</tr>
			<%
			r.movenext
		wend
	end if
	%>
</table>

</body>
</html>
