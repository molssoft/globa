<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<!--Princips: pirmoreiz pievienojas db un dabû aìentu sarakstu, lai bûtu, no kâ izvçlçties;
tâlak: ja forma ir izsaukusi pati sevi, tad notiek otrs konnekts pie bâzes un tiek atgriezti
ieraksti, kas raksturo konkrçto aìentu.
-->

<% docstart "Aìenti","y1.jpg" 
veids = Request.Form("veids")
%>
<meta name="expires" value="0">
<center><font color="GREEN" size="5"><b>Aìentu norçíini</b></font><hr>
<%
dim conn
OpenConn
headlinks

Server.ScriptTimeout = 900

chkzilie = Request.Form("chkzilie")
agents = Request.Form("agents")
maks_veids = Request.Form("maks_veids")
order_by = Request.Form("order_by")

if session("message") <> "" then 
	%>
	<br><font size = 4 color = red><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

%>
<br>
<table cols="2" rows="5">
<form name="forma" method="POST" action="agenti_nauda.asp" border="1">
<tr>
<td align="right" bgcolor="#ffc1cc">Aìents: </td>
<td align="left" bgcolor="#fff1cc">
<%
set r = server.createobject("ADODB.Recordset")
r.open "Select * from agenti where aktivs = 1 ORDER BY pilseta,vards",conn,3,3
r.movefirst


if r.recordcount <> 0 then
	
	%>
	<select name="agents" >
		<option value = "" <%if agents="" then Response.Write " selected " %>>Pilnîgi visi pieteikumi</option>
		<option value = "0" <%if agents="0" then Response.Write " selected " %>>Pieteikumi bez aìenta</option>
	<% while not r.eof %> 
		<option value = "<%=r("id")%>" 
		<% 
		if Request.Form("agents")=cstr(r("id")) then 
			Response.Write "selected" 
			agents = CStr(r("id"))
		End if
		%>
		><%=decode(r("pilseta")) + ">" + decode(r("vards"))%></option>
	<%  r.movenext
	wend%>
	</select>
	</td></tr>
	<tr>
	 <td align="right" halign="center" bgcolor="#ffc1cc">Laikâ no: </td>
	 <td align="left" bgcolor="#fff1cc"><input type="textbox" name="no" size="10" value="<%=Request.Form("no")%>">
	 lîdz: 
	 <input type="textbox" name="lidz" value="<%=Request.Form("lidz")%>" size="10"></td>
	</tr>
	<tr>
	 <td align="right" halign="center" bgcolor="#ffc1cc">Operâciju veids:</td>
	 <td align="left" bgcolor="#fff1cc">
	  <select name=veids>
	   <option value=1 <%if veids="1" then Response.Write " selected "%>>Neapstiprinâtâs</option>
	   <option value=0 <%if veids="0" then Response.Write " selected "%>>Apstiprinâtâs</option>
	  </select>
	 </td>
	</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Maksâjuma veids</td>
 <td align="left" bgcolor="#fff1cc">
  <select name="maks_veids">
   <option value="">-</option>
   <option value="kase" <%if maks_veids = "kase" then Response.Write "selected"%>>Kase</option>
   <option value="banka" <%if maks_veids = "banka" then Response.Write "selected"%>>Banka</option>
  </select>
 </td>
</tr>
	
	<tr>
	 <td align="right" halign="center" bgcolor="#ffc1cc">Zilie:</td>
	 <td align="left" bgcolor="#fff1cc">
	  <input type=checkbox name=chkzilie <%if chkzilie = "on" then response.write " checked "%>>
	 </td>
	</tr>
	
<tr>
 <td align="right" bgcolor="#ffc1cc">Sakârtot pçc:</td>
 <td align="left" bgcolor="#fff1cc">
  <select name="order_by">
   <option value="">-</option>
   <option value="datums" <%if order_by = "datums" then Response.Write "selected"%>>Reìistrâcijas datums</option>
   <option value="sakuma_dat" <%if order_by = "sakuma_dat" then Response.Write "selected"%>>Sâkuma datums</option>
  </select>
 </td>
</tr>	
	
	<tr>
	 <td colspan="2" align="center" valign="bottom" bgcolor="#fff1cc">
	<input type="submit" value="Meklçt" name="poga">
	<input type="hidden" value="1" name="submit">
	</td></tr>
	</table>
	<!---------------------------------Formas un tabulas beigas------------------>
	
<%else '' ja aìentu bâzç nav%>
	Aìentu saraksts ir tukðs, tâpçc statistika nav pieejama!
<%end if%>

<!----Otrâ daïa: aìenta statistika-->
<% if request.form("submit")="1" then%>
	
	<%set d = server.createobject("ADODB.Recordset")
	where = " and orderis.deleted=0"
	
	if request.form("no")<>"" then
	 where = where + " and datums>='"+sqldate(formateddate(request.form("no"),"dmy"))+"'"
	end if
	if request.form("lidz")<>"" then
	 where = where + " and datums<='"+sqldate(formateddate(request.form("lidz"),"dmy"))+"'"	
	end if
	if chkzilie="on" then
	 where = where + " and (pid in (select id from pieteikums where krasa = 'B') or nopid in (select id from pieteikums where krasa = 'B')) "	
	end if

	if request.form("maks_veids")<>"" then
	 where = where + " and maks_veids='"+cstr(request.form("maks_veids"))+"' "
	end if


	if Request.Form("agents")<>"" then
	 where = where + " and isnull(aid,0) = " + Request.Form("agents")
	 else
	 where = where + " and isnull(aid,0) <> 0 "
	end if
	
    where = where + " and parbaude = " + Request.Form("veids")

	''Where = Where + " and (isnull(resurss,'') = '' or grupa.id in " + _
	''	"(select gid from pieteikums where id = orderis.pid " + _
	''	"union  " + _
	''	"select gid from pieteikums where id = orderis.nopid " + _
	''	"))"

    if request.form("order_by")<>"" then
	 orderC = " order by " + request.form("order_by")
	else
	 orderC = " order by datums" 
	end if
    
	'izveido pieprasîjuma sql komandu
	qstr = "Select grupa.sakuma_dat, orderis.*  from orderis left join grupa on orderis.resurss = grupa.kods " + _
			"Where orderis.id in (Select id from orderis where orderis.deleted=0 and isnull(aid,0) <> 0 and parbaude = "+Request.Form("veids")+" ) " + _ 
			"" + where + orderC
	

	'	qstr="Select * from orderis " + _
	'			"where " + where + orderC
		
	 ''Response.Write qstr

if Request.Form("act")="ok" then 
	d.open qstr,conn,3,3
	while not d.EOF
	 if Request.Form("ok"+cstr(d("id")))="on" then
	  conn.execute("update orderis set parbaude = 0 where id = "+cstr(d("id")))
	  logaction "orderis",d("id"),"Apstiprinâja"
	 end if
	 d.MoveNext
	wend
	d.Close
end if

%><hr width="100%">
<%
	d.open qstr,conn,3,3
		if d.recordcount=0 then
		response.write "Par doto aìentu nav datu"
		else
			d.movefirst %>
			<center>
			<div id="agenti_nauda_count">
			</div>
			<% If CStr(agents)<>"0" Then %>
				<a href="https://www.impro.lv/rezervacija/operacijas.asp?a=<%=agents%>&x=edkelerj439dkjf9e" target=agenti>Rçíinu veidoðana</a>
				<BR>
			<% End If %>
			<table border=0 cols="4">
			<tr bgcolor="#ffc1cc">
				<th>Nr</th>
				<th>Datums</th>
				<th>TIC</th>				
				<th>No</th>
				<th>Uz</th>
				<th>Grupas kods</th>
				<th>Sâk. datums</th>				
				<th>Maksâtâjs/Saòçmçjs</th>
				<th>Summa</th>
				<th>Bilance</th>
				<th>Veids</th>
				<th>Rçíins</th>
				<th></th>
			</tr>
			<%
			BilanceKopa = 0
			SummaKopa = 0
			KopaLVL = 0
			KopaEUR = 0
			KopaUSD = 0
			i = 0
			IdArray = Array() '--- masiivs, kuraa saglabaa orderu id, kuriem nav resursa (avansi, davanu kartes uc.)		
							'--- uztaisiits, lai nofiltreetu dubultos ierakstus, ko atgriez query:
							'--- ja orderim nav resursa, taa id saglabaa masiivaa. Pec tam skataas, 
							'--- ja kartejais orderis jau ir masiivaa t.n. ka tas jau ir izvadiits  
							'--- tad ottreiz sarakstaa to neizvada. (27/7/2006 Nils)
			
			while not d.eof
			
				inArray = false	
						
				if d("resurss")= "" Or d("resurss")="X.1" then

					'--- parbauda vai ir masiivaa
					For Each rId In IdArray
						if rId = d("id") then
							
							inArray = true
							exit for
							
						end if
					next
					
					if not inArray then '--- saglabaa masiivaa
						
						ReDim Preserve IdArray(UBound(IdArray)+1)
						IdArray(UBound(IdArray)) = d("id")
						
					end if
						
				end if
				
				if not inArray then '--- ja orderis nav masiivaa, izvada to sarakstaa
				
					if d("resurss")<>"" And d("resurss")<>"X.1" then
						swhere = "kods='"+d("resurss")+"'"
					else
						swhere = "1=0" 'nofeilo rezultaatu
					end if
						
					ssql = "select sakuma_dat from grupa where " + swhere
					set r_sd = conn.execute(ssql)

					if nullprint(d("aid")) <> "" then
						ssql = "  select vards,pilseta from agenti where id="+cstr(d("aid"))
						'ssql = "select lietotajs, vards, uzvards from lietotaji where aid = "+cstr(d("aid"))+" and lietotajs like 'tic_%'"
						set agents = conn.execute(ssql)
					end if
					
					'Incrementing counter
					i=i+1
					%>
					<tr bgcolor = "#fff1cc">
					<td><%=cstr(i)%></td>
					<td><a href="javascript:void(window.open('ordedit.asp?oid=<%=d("id")%>'))"><%=DatePrint(d("datums"))%></a></td>
					<td><% if nullprint(d("aid")) <> "" then
								if not agents.eof then rw decode(agents("pilseta")) + ">" + decode(agents("vards"))'Response.Write(agents("lietotajs")+", "+agents("vards")+" "+agents("uzvards"))
						   end if
						%></td>		      
					<td>
					 <% if getnum(d("nopid"))<>0 then %>
					  <a href="javascript:void(window.open('pieteikums.asp?pid=<%=d("nopid")%>'))"><%=d("nopid")%></a>
					 <% end if %>
					</td>
					<td>
					 <% if getnum(d("pid"))<>0 then %>
					  <a href="javascript:void(window.open('pieteikums.asp?pid=<%=d("pid")%>'))"><%=d("pid")%></a>
					 <% end if %>
					</td>
					<td><%=d("resurss")%></td>		      
					<td>
						<% if not r_sd.eof and isDate(r_sd("sakuma_dat")) then Response.write(dateprint(r_sd("sakuma_dat")))%>
					</td>		      
					<%
					valuta = conn.execute("select val from valuta where id = "+cstr(d("valuta")))(0)
					summaval = getnum(d("summa"))

					''apstradajam LVL un EUR atseviski
					''principaa tas ir gulka labojums jo lauks summa aizpildaas nepareizi kad agenti veido iemaksu (latus par eiro)
					''lauks summa netiek izmantots aprekiniem, tapec tas nav kritiski, kaut gan vajadzetu izlabot agentos
					If valuta = "LVL" Then
						summaval = getnum(d("summaLVL"))
						If summaval = 0 Then
							summaval = getnum(d("nosummaLVL"))
						End If
						If summaval = 0 And getnum(d("summaEUR")<>0) Then
							summaval = round100(d("summaEUR") * EUR_RATE)
						End If 
						If summaval = 0 And getnum(d("nosummaEUR")<>0) Then
							summaval = round100(d("nosummaEUR") * EUR_RATE)
						End If 
					End If
					If valuta = "EUR" Then
						summaval = getnum(d("summaEUR"))
						If summaval = 0 Then
							summaval = getnum(d("nosummaEUR"))
						End if
					End if
					%>
					<td align = right><%=Nullprint(d("kas"))%></td>
					<td align = right><%=CurrPrint(summaval)%> <%=valuta%></td>
					<td><%
					    summaLVL = 0
					    summaUSD = 0
					    summaEUR = 0
					    if getnum(d("pid")) <> 0 then
					     summaLVL = getnum(d("summaLVL"))
					     summaEUR = getnum(d("summaEUR"))
					     summaUSD = getnum(d("summaUSD"))
						 If valuta = "LVL" Then kopaLVL = kopaLVL + summaval
						 If valuta = "EUR" Then kopaEUR = kopaEUR + summaval
					    end if
					    if getnum(d("nopid")) <> 0 then
					     summaLVL = summaLVL - getnum(d("summaLVL"))
					     summaEUR = summaEUR - getnum(d("summaEUR"))
					     summaUSD = summaUSD - getnum(d("summaUSD"))
						 If valuta = "LVL" Then kopaLVL = kopaLVL - summaval
						 If valuta = "EUR" Then kopaEUR = kopaEUR - summaval
					    end if
					    Response.Write Curr3Print(summaLVL,summaUSD,summaEUR)
    					BilanceLVL = BilanceLVL + summaLVL
    					BilanceEUR = BilanceEUR + summaEUR
    					BilanceUSD = BilanceUSD + summaUSD
					    %></td>
		        
					<td><%=d("maks_veids")%></td>
					<td>
					<% 
					If getnum(d("rekins"))<>0 Then 
						Response.write d("rekins")
						if getnum(d("agentu_rekins_id"))<>0 then
	
							%> [<a href="https://www.impro.lv/php/agentu_rekins.php?id=<%=d("agentu_rekins_id")%>&aid=<%=d("aid")%>" target="_blank">Drukât</a>]<%
							%> [<a href="https://www.impro.lv/rezervacija/operacijas.asp?a=<%=d("aid")%>&x=edkelerj439dkjf9e" target=agenti>apskatît</a>]<%
						end if
					Else
						%><a href="https://www.impro.lv/rezervacija/operacijas.asp?a=<%=d("aid")%>&x=edkelerj439dkjf9e" target=agenti>izrakstît</a><%
					End If 
					%>
					</td>
					<td>
					 <% if d("parbaude")=true then %>
					 <a href="javascript:void(window.open('agenti_nauda_apst.asp?oid=<%=d("id")%>'))"><img border=0 src="impro/bildes/dolars.jpg"></a>
					 <% end if %>
					</td>
					</tr>
			<% 
			
				end if
				d.MoveNext
			wend
            %>
            <tr bgcolor = "#ffc1Ac">
            	<td></td>
            	<td></td>
            	<td></td>            	
            	<td></td>            	
            	<td></td>
            	<td></td>
            	<td></td>            	
            	<td></td>
            	<td align = right><%=Curr3Print(KopaLVL,0,KopaEUR)%></td>
            	<td align = right><%=Curr3Print(BilanceLVL,BilanceUSD,BilanceEUR)%></td>
            	<td></td>
            	<td></td>            	
            </tr>
            </table>
            <%
			if i>0 Then
			%>
			<script>
			document.getElementById("agenti_nauda_count").innerHTML="<%
			response.write Galotne(i,"Atrasts","Atrasti")+ " "+cstr(i)+" "+Galotne(i,"norçíins","norçíini")
			%>";
			</script>
			<%			
			End if
		end if
end if
	%>
</form>
</body>
</html>