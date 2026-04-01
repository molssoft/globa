<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<%
dim conn
openconn

Dim av, ssql, sakuma_dat, beigu_dat

sakuma_dat = request.form("sak_dat")
beigu_dat =  request.form("beigu_dat")

if len(Request.form("skatit.x")) <> 0 Then '--- post

	If (sakuma_dat = "" and beigu_dat = "") then
		session("message") = "Jânorâda kâds no datumiem."
	End If

Else '--- default

	If (sakuma_dat = "" and beigu_dat = "") Then
		sakuma_dat = formateddate(now,"dmy")
		beigu_dat = sakuma_dat
	End if

end if

docstart "Atskaite par pieteikumu atlaidçm","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Atskaite par pieteikumu atlaidçm</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='RED' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

veids = Request.Form("veids")

ssql = "select * from piet_atlaides_veidi"
Set av = conn.execute(ssql)

post_av = CStr(request.form("atlaides_veids"))

'rw "-> "&request.form("atlaides_veids")
%>

<form name="forma" action="atsk_piet_atlaides.asp" method="POST">
<table>
<tr>
	<td align="right" bgcolor="#ffc1cc">Datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="sak_dat" value="<%=sakuma_dat%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="beigu_dat" value="<%=beigu_dat%>"> 
	</td>
</tr>
<tr><td align="right" bgcolor="#ffc1cc">Atlaides veids</td><td bgcolor="#fff1cc">
	<select name="atlaides_veids">
		<option value="">visi</option>
		<% Do While Not av.eof 
			aid = CStr(av("id"))
			%>
				<option <%if post_av = aid then response.write " selected " %> value="<%=aid%>"><%=av("nosaukums")%></option>
			<%
			av.movenext
		Loop
		%>
	</select></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
<input type="image" src="impro/bildes/skatit.jpg" name="skatit" WIDTH="116" HEIGHT="25">
<p>

<table>
	<tr>
		<td valign=top>
			<%PrintTable()%>
		</td>
	</tr>
</table>


</form>
</body>
</html>

<%

Sub PrintTable ()

	if request.form("skatit.x") <> "" and (Request.Form("sak_dat") <> "" or Request.Form("beigu_dat") <> "") then
		
			atlaides_veids = getnum(Request.Form("atlaides_veids"))

			If atlaides_veids > 0 Then 
				where_veids = " and veids = "&atlaides_veids
			Else
				where_veids = "" '--- visi atlaiþu veidi			
			End if

			'Nosaka sakuma un beigu datumu
			sak_dat = SQLDate(formateddate(Request.Form("sak_dat"),"dmy"))
			beigu_dat = SQLDate(formateddate(Request.Form("beigu_dat"),"dmy"))
			
			ssql = "select distinct ps.did, d.vards, d.uzvards, v.nosaukums, a.* from piet_atlaides a " + _
					"inner join piet_atlaides_veidi v on v.id = a.veids " + _
					"inner join piet_saite ps on ps.pid = a.pid " + _
					"inner join dalibn d on d.id = ps.did " + _
					"where ps.deleted = 0 and isnull(uzcenojums, 0) = 0 and datums between '"& sak_dat &"' and '"& beigu_dat &"' "& where_veids + _
					"order by a.datums"
			
			Set atl = conn.execute(ssql)

			'rw ssql

			npk = 0
			kopa = 0
			atl_lvl = 0
			atl_eur = 0
		%>
		<center>
		<table >

		<tr bgcolor="#ffc1cc">
		<th>Npk.</th>
		<th>Datums</th>
		<th>Nosaukums</th>
		<th>Piet.</th>
		<th>Dalîbnieks</th>
		<th>Summa</th>
		<th>Atlaide LVL</th>
		<th>Atlaide EUR</th>
		<th>Kas</th>
		<th>Piezîmes</th>
		</tr>
		<% Do While Not atl.eof 
			
			npk = npk + 1 
			kopa = kopa + getnum(atl("summa"))
			atl_lvl = atl_lvl + getnum(atl("atlaideLVL"))
			atl_eur = atl_eur + getnum(atl("atlaideEUR"))
			%>
			<tr bgcolor="#fff1cc">
			<td align="right"><%=npk%>.</td>
			<td align="right"><%=atl("datums")%></td>
			<td align="right"><%=atl("nosaukums")%></td>
			<td align="right"><a href="pieteikums.asp?pid=<%=atl("pid")%>" target="_blank"><%=atl("pid")%></a></td>
			<td align="right"><a href="dalibn.asp?i=<%=atl("did")%>" target="_blank"><%=atl("vards")&" "&atl("uzvards")%></a></td>
			<td align="right"><%=currprint(atl("summa"))%></td>
			<td align="right"><%=currprint(atl("atlaideLVL"))%></td>
			<td align="right"><%=currprint(atl("atlaideEUR"))%></td>
			<td align="right"><%=atl("kas")%></td>
			<td align="right"><%=atl("piezimes")%></td>
			</tr>

		<% atl.movenext
		Loop %>
		
		<tr bgcolor="#ffc1cc">
		<td colspan="5"  align="right">Kopâ:</td>
		<td align="right"><%=currprint(kopa)%></td><td align="right"><%=currprint(atl_lvl)%></td><td align="right"><%=currprint(atl_eur)%></td>
		<td colspan="2">&nbsp;</td>
		</tr>
		</table>
			
		<%
	end if 

End Sub
%>