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

%>

<form name="forma" action = "balle.asp" method = "POST">
<font color="BLACK" size="3"><br><b>Regions <%=regions%></b></font>

<!--@ 0 Attçlo tabulu -->

<%
if Request.Form("regions") <> "" then %>
	<br>
	<table width="100%">
	<tr>
	<th>Nr.</th>
	<th>Tips</th>
	<th>Nosaukums/Ceïojums</th>
	<%if request.form("regions") = "S" then %>
	 <th nowrap width='15%'>Galda nos</th>
	<%end if%>
	<th>Datums</th>
	<th>Grupas vad.</th>
	<th>piet./izp.(max)</th>
	<th>Piezîmes</th>
	</tr>

	<%

	sql = "select id,sektors,num,isnull(nosaukums,'') as nosaukums, isnull(piezimes,'') as piezimes from balle where sektors = '"+request.form("regions")+"' order by num"
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
			datumi = datumi + "" +  datums + ""

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
		If galds_nosaukums<>"" then
			nosaukumi = nosaukumi + "<BR>" + galds_nosaukums
		else	
			nosaukumi = nosaukumi + "<BR>." 
		End if
		If datumi <> "" Then datumi = datumi + "<BR>"
		datumi = datumi + "..."
		If vaditaji <> "" Then vaditaji = vaditaji+ "<BR>"
		vaditaji = vaditaji+ "."


		%>
		<tr>
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
			<% If max<>"" Then rw "(" + CStr(max) + ")"%>
			</td>
			<td align=left><%=piezimes%></td>

		</tr>
		<%

		r.movenext
	Wend
	%>

	</table>
<% end if %>

</body>
</html>
