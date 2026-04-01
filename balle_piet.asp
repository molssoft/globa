<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

'--- 30/10/008 Nils --------------------------------------------------------------

dim conn
openconn

did = Request.querystring("did")

if did="" then
	did = Request.Form("did")
end if

if request.form("regions") <> "" then
	regions = Request.Form("regions")
else
	regions = ""
end if

numurs = cstr(Request.Form("nr"))
pg = getnum(Request.Form("pg"))
'if pq = "" then pq = 0


'--- atrod jaunâko balles grupu	
ssql = "SELECT max(g.id) as id FROM grupa g inner join marsruts m on m.id = g.mid " + _
	   "where v like '%balle%'"
	   
set r_g = conn.execute(ssql)

if not r_g.eof then
	gid = r_g("id")
else
	Response.Write("Nav atrasta balles grupa")
	Response.end
end if


if numurs <> "" Then
	'--- izveido pieteikumu -----------------------------------------------
	Response.redirect "balle_add.asp?did="+CStr(did)+"&sektors="+regions+"&numurs="+numurs
end if


set r_d = conn.execute ("select vards, uzvards from dalibn where id = "+did)

vards = r_d("vards")
uzvards = r_d("uzvards")


'--------------------------------------------------------------------------------------------

docstart "Balles biïetes pieteikums","y1.jpg"%>
<center><font face=arial color="GREEN" size="5"><b>Balles biïetes pieteikums</b></font><hr>
<%
headlinks
DefJavaSubmit
%>

		<br />
		<div align="center">DALÎBNIEKS <%Response.write(vards+" "+uzvards)%></div>
		<br />

		<form name="forma" method="post" action="balle_piet.asp">
		
		<input type="hidden" name="did" value="<%=did%>">
		<input type="hidden" name="reg" value="<%=regions%>">
		<input type="hidden" name="nr" value="">	
		<input type="hidden" name="pg" value="">		

		
		<table width = "60%" border="0"  bgcolor="#fff1cc">

		<tr>
			<td bgcolor = #ffc1cc>Reìions: </td>
			<td bgcolor = #fff1cc>
				<select name="regions">
					<option value="R" <%if regions = "R" then Response.Write "selected"%>>Rietumeiropa</option>
					<option value="Z" <%if regions = "Z" then Response.Write "selected"%>>Ziemeïeiropa</option>
					<option value="C" <%if regions = "C" then response.write "selected"%>>Centrâleiropa</option>
					<option value="E" <%if regions = "E" then Response.Write "selected"%>>Eksotiskâs valstis</option>
					<option value="S" <%if regions = "S" then Response.Write "selected"%>>Sports / Individuâlie</option>
				</select>
			</td>
			<td><input type="submit" name = "poga" value = "Izvçlçties"></td>
		</tr>

		<tr>
			<td>&nbsp;</td>
		</tr>
		
				<%
				if regions <> "" then
					
					
					ssql = "SELECT *,isnull(nosaukums,'') as nos from balle where sektors = '" + regions + "' order by num "
					
					set r_s = conn.execute(ssql)
					
					while not r_s.eof 
						
						balle_sektors = regions
						balle_numurs = cstr(r_s("num"))

						'visas grupas pie ðî galda
						Set rgr = conn.execute("select valsts,grupa.id as grupa_id, sakuma_dat,v2 " + _
						" from grupa inner join marsruts on grupa.[mid] = marsruts.id " + _
						" where balle_sektors = '"+balle_sektors+"' and balle_numurs="+CStr(balle_numurs)+" order by sakuma_dat ")

						'notîram mainîgos
						nosaukumi = ""

						While Not rgr.eof
							
							nosaukums = decode(rgr("v2")) + "(" + dateprint(rgr("sakuma_dat")) + ")"
							If nosaukumi <> "" Then nosaukumi = nosaukumi + "<BR>"
							nosaukumi = nosaukumi + nosaukums

							rgr.movenext
						wend
						
						'pârbaudam vai ir pieteikumu tabulâ ieraksti (tie kas nepiesakâs caur grupâm un visi kas maksâjuði
						Set rPiet = conn.execute("select isnull(count(id),0) as sk from pieteikums where deleted = 0 and gid = "+CStr(gid)+" and b_sektors = '"+balle_sektors+"' and b_numurs = "+CStr(balle_numurs))

						
						If nosaukumi <> "" Then nosaukumi = nosaukumi + "<BR>"
						nosaukumi = nosaukumi + r_s("nos")+"("+CStr(rPiet("sk"))+")"

						
						%>
						<tr>
						<td><%Response.Write("<b>"+regions+balle_numurs+"</b>")%></td>
						<td><%=nosaukumi%></td>
						<td><input type="button" name="insert_<%=balle_numurs%>" value="Ievietot" onclick="form.nr.value=<%=balle_numurs%>;form.submit();"></td>
						</tr>
						<%
						
					r_s.movenext
					wend
					
					
					'-----------------------------
						
				end if
				%>
			
			
		
		</table>

		</form>

</body>
</html>