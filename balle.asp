<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Balles biïetes","y1.jpg"
DefJavaSubmit


'atrodam balles grupu
ssql = "SELECT max(g.id) as id FROM grupa g inner join marsruts m on m.id = g.mid " + _
	   "where v like '%balle%'"
set r_g = conn.execute(ssql)
balles_grupa = r_g("id")

if request.form("regions") <> "" then
	
	regions = Request.Form("regions")
	
else
	
	regions = ""
end if

'--- pievieno sektoram jaunu galdu
galda_num = Request.Form("galda_num")
if galda_num <> "" then
		
	igads = cstr(year(date()))
	'--- parbauda vai tads jau eksistç
	gnosaukums = request.form("gnosaukums")
	ssql = "SELECT * FROM balle WHERE gads = '"+igads+"' AND sektors='"+regions+"' AND galds=1 AND num="+cstr(galda_num)
	set r = conn.execute(ssql)
	if r.EOF then
		conn.execute("INSERT INTO balle(gads,sektors,num,galds,max_vietas,nosaukums) VALUES('"+igads+"','"+regions+"',"+cstr(galda_num)+",1,0,'"+gnosaukums+"')")
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

%>

<form name="forma" action = "balle.asp" method = "POST">
<font color="BLACK" size="3"><br><b>Izvçlçties ceïojumu reìionu
<table>
<tr><td bgcolor = #ffc1cc>Reìions: </td><td bgcolor = #fff1cc><select name="regions">
<option value="R" <%if regions = "R" then Response.Write "selected"%>>Rietumeiropa</option>
<option value="Z" <%if regions = "Z" then Response.Write "selected"%>>Ziemeïeiropa</option>
<option value="C" <%if regions = "C" then response.write "selected"%>>Centrâleiropa</option>
<option value="E" <%if regions = "E" then Response.Write "selected"%>>Eksotiskâs valstis</option>
<option value="S" <%if regions = "S" then Response.Write "selected"%>>Sports / Individuâlie</option>
<option value="X" <%if regions = "X" then Response.Write "selected"%>>Bez sektora</option>
</select></td>
	<td>
		<input type="submit" name = "poga" value = "Izvçlçties" onclick="forma.action = 'balle.asp'">
		<input type="submit" name = "poga2" value = "Izdruka" onclick="forma.action = 'balle_print.asp'">
	</td>
</tr>

<%if Request.Form("regions") <> "" then ' and Request.Form("regions") <> "K" then 
	%>
<tr>
	<td align="right"><%=regions%></td>
	<td><input type="text" size=3 name="galda_num" /><input type="text" name="gnosaukums" /></td>
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
	<th>Nosaukums/Ceïojums</th>
	<th>Datums</th>
	<th>Grupas vad.</th>
	<th>piet./izp.(max)</th>
	<th>Piezîmes</th>
	</tr>

	<%

	sql = "select id,sektors,num,isnull(nosaukums,'') as nosaukums,isnull(piezimes,'') as piezimes from balle where sektors = '"+request.form("regions")+"' order by num"
	''Response.write sql
	Set r = conn.execute(sql)


	rezervets_kopa = 0
	nopirkts_kopa = 0

	While Not r.eof

		balle_sektors = r("sektors")
		balle_numurs = r("num")
		galds_nosaukums = r("nosaukums")
		piezimes = r("piezimes")

		sql = "select valsts,grupa.id as grupa_id, balle_maxvietas,vards2,uzvards2,sakuma_dat,v2,kods,balle_sektors,balle_numurs,piezimes_2, " + _
		" (select count(*) from balles_pieteikumi where gid = grupa.id) as sk " + _
		" from grupa inner join marsruts on grupa.[mid] = marsruts.id left join grupu_vaditaji on grupa.vaditajs = grupu_vaditaji.idnum " + _
		" where balle_sektors = '"+balle_sektors+"' and balle_numurs="+CStr(balle_numurs)+" order by sakuma_dat "

		''Response.write sql

		Set rgr = conn.execute(sql)

		'notîram mainîgos
		veidi = ""
		nosaukumi = ""
		datumi = ""
		vaditaji = ""
		max = ""

		'visas grupas pie ðî galda
		While Not rgr.eof
			
			grupa_id = rgr("grupa_id")

			veids = Mid(rgr("kods"),4,1)
			If veidi <> "" Then veidi = veidi + "<BR>"
			veidi = veidi + veids

			nosaukums = decode(rgr("v2")) + "(" + decode(rgr("valsts")) + ")"
			If nosaukumi <> "" Then nosaukumi = nosaukumi + "<BR>"
			If getnum(rgr("sk"))<>0 then
				nosaukumi = nosaukumi + "<B>"+nosaukums+"</B>"
			Else
				nosaukumi = nosaukumi + nosaukums
			End if

			datums = dateprint(rgr("sakuma_dat"))
			If datumi <> "" Then datumi = datumi+ "<BR>"
			If getnum(rgr("sk"))<>0 Then
				datums = "<B>" + datums + "</B>"
			End if
			datumi = datumi + "<a href='balle_edit.asp?gid="+CStr(grupa_id)+"&num="+balle_sektors+CStr(balle_numurs)+"'>" +  datums + "</a>"

			vaditajs = decode(rgr("vards2")) + " " + decode(rgr("uzvards2"))
			If vaditaji <> "" Then vaditaji = vaditaji+ "<BR>"
			vaditaji = vaditaji+ vaditajs

			If getnum(rgr("balle_maxvietas"))<>0 Then
				If max="" Then
					max = rgr("balle_maxvietas")
				End if
			End if

			piezime = decode(rgr("piezimes_2"))
			If piezimes <> "" Then piezimes = piezimes + "<BR>"
			If getnum(rgr("sk"))<>0 then
				piezimes = piezimes + piezime
			End If
			
			rgr.movenext
		wend
		
		'pârbaudam vai ir pieteikumu tabulâ ieraksti (tie kas nepiesakâs caur grupâm un visi kas maksâjuði
		Set rPiet = conn.execute("select isnull(count(id),0) as sk from pieteikums where deleted = 0 and b_sektors = '"+balle_sektors+"' and b_numurs = "+CStr(balle_numurs) + " and gid = " + CStr(balles_grupa))

		If veidi <> "" Then veidi = veidi + "<BR>"
		veidi = veidi + "."
		If nosaukumi <> "" Then nosaukumi = nosaukumi + "<BR>"
		If galds_nosaukums<>"" then
			nosaukumi = nosaukumi + galds_nosaukums+"."
		Else 
			nosaukumi = nosaukumi + "."
		End if
		If datumi <> "" Then 
			datumi = datumi + "<BR>"
		End if
		datumi = datumi + "<a href='balle_edit.asp?num="+balle_sektors+CStr(balle_numurs)+"'>Apskatît</a>"
		If vaditaji <> "" Then vaditaji = vaditaji+ "<BR>"
		vaditaji = vaditaji+ "."


		%>
		<tr bgcolor="#fff1cc">
			<td align=center><%=balle_sektors%><%=balle_numurs%></td>
			<td align=center><%=veidi%></td>
			<td align=left><%=nosaukumi%></td>
			<td align=left><%=datumi%></td>
			<td align=left><%=vaditaji%></td>

			<%
			'balles vietas
			Set rvietas = conn.execute("select sum(isnull(balle_vietas,0)+isnull(balle_brivbiletes,0)) as sk from pieteikums where deleted = 0 and gid = "+CStr(balles_grupa)+" and b_sektors = '"+request.form("regions")+"' and b_numurs = "+CStr(balle_numurs))
			rezervets = getnum(rvietas("sk"))
			rezervets_kopa = rezervets_kopa + rezervets

			'nopirkts
			Set rvietas = conn.execute("select sum(isnull(balle_vietas,0)+isnull(balle_brivbiletes,0)) as sk from pieteikums where deleted = 0 and gid = "+CStr(balles_grupa)+" and b_sektors = '"+request.form("regions")+"' and b_numurs = "+CStr(balle_numurs) + " and not balle_datums is null ")
			nopirkts = getnum(rvietas("sk"))
			nopirkts_kopa = nopirkts_kopa + nopirkts
			%>
			<td align=left><%=rezervets%>/<%=nopirkts%>
			<% If max<>"" Then rw "(" + CStr(max) + ")"
			If rezervets+nopirkts = 0 Then
				rw " <a href='balle_galds_dzest.asp?id="+CStr(r("id"))+"' onclick='return confirm(""Dzest?"");'>Dzest</a>"
			End if
			%>
			</td>
			<td align=left><%=piezimes%></td>

		</tr>
		<%

		r.movenext
	Wend
	
	'summa
	%>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD><b>Kopâ:</b></TD>
		<TD></TD>
		<TD></TD>
		<td align=left><b><%=rezervets_kopa%>/<%=nopirkts_kopa%></b></td>
	</TR>
	<%

		'notîram mainîgos
		veidi = ""
		nosaukumi = ""
		datumi = ""
		vaditaji = ""
		max = ""


	'vçl nenosçdinâtâs grupas

	If request.form("regions") <> "X"  Then
		'grupas ar sektoru
		Set r = conn.execute("select valsts,grupa.id as grupa_id, balle_maxvietas,vards2,uzvards2,sakuma_dat,v2,kods,balle_sektors,balle_numurs, " + _
		" (select sum(isnull(balle_vietas,0)+isnull(balle_brivbiletes,0)) from pieteikums where gid=grupa.id ) as sk " + _
		" from grupa inner join marsruts on grupa.[mid] = marsruts.id left join grupu_vaditaji on grupa.vaditajs = grupu_vaditaji.idnum " + _
		" where balle_sektors = '"+request.form("regions")+"' and isnull(balle_numurs,0)=0 order by balle_numurs,sakuma_dat ")
	Else
		'grupas bez sektora
		Set r = conn.execute("select valsts,grupa.id as grupa_id, balle_maxvietas,vards2,uzvards2,sakuma_dat,v2,kods,isnull(balle_sektors,'') as balle_sektors,balle_numurs, " + _
		" (select sum(isnull(balle_vietas,0)+isnull(balle_brivbiletes,0)) from pieteikums where gid=grupa.id ) as sk " + _
		" from grupa inner join marsruts on grupa.[mid] = marsruts.id left join grupu_vaditaji on grupa.vaditajs = grupu_vaditaji.idnum " + _
		" where atcelta = 0 and balle_sektors is null and isnull(balle_numurs,0)=0 and sakuma_dat>'2014-01-01' and beigu_dat<'2014-12-31' and (veids = 1 or veids = 2) order by balle_numurs,sakuma_dat ")
	End if

	While Not r.eof
		'vispirms savâcam mainîgos
		'un ja galds ir mainîjies tad izdrukâjam visu rindu
		balle_sektors = r("balle_sektors")
		balle_numurs = r("balle_numurs")
		grupa_id = r("grupa_id")
		datums = dateprint(r("sakuma_dat"))

		If nullprint(max) = "" Then max = nullprint(r("balle_maxvietas"))

		veids = Mid(r("kods"),4,1)
		If veidi <> "" Then veidi = veidi + "<BR>"
		veidi = veidi + veids

		nosaukums = decode(r("v2")) + "(" + decode(r("valsts")) + ")"
		If nosaukumi <> "" Then nosaukumi = nosaukumi + "<BR>"
		If getnum(r("sk"))<>0 then
			nosaukumi = nosaukumi + "<B>"+nosaukums+"</B>"
		Else
			nosaukumi = nosaukumi + nosaukums
		End If
		
		If datumi <> "" Then datumi = datumi+ "<BR>"
		If getnum(r("sk"))<>0 Then
			datums = "<B>" + datums + "</B>"
		End if
		datumi = datumi + "<a href='balle_edit.asp?gid="+CStr(grupa_id)+"&num="+(balle_sektors)+"0'>" +  datums + "</a>"

		vaditajs = decode(r("vards2")) + " " + decode(r("uzvards2"))
		If vaditaji <> "" Then vaditaji = vaditaji+ "<BR>"
		vaditaji = vaditaji+ vaditajs

		r.movenext

		'vienmçr drukâjam
		flag = 1
		

		If flag = 1 then
			%>
			<tr bgcolor="#e3d9c4">
				<td align=center><%=balle_sektors%><%=balle_numurs%></td>
				<td align=center><%=veidi%></td>
				<td align=left><%=nosaukumi%></td>
				<td align=left><%=datumi%></td>
				<td align=left><%=vaditaji%></td>

				<td align=left>
				<% If max<>"" Then rw "(" + max + ")"%>
				</td>
				<td></td>

			</tr>
			<%
			'notîram mainîgos
			veidi = ""
			nosaukumi = ""
			datumi = ""
			vaditaji = ""
			max = ""
		End if
	wend
	%>

	</table>
<% end if %>

</form>
</body>
</html>
