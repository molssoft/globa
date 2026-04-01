<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'Response.CodePage = 1252
'Response.CharSet = "windows-1257" 

docstart "Grupas vietu veidi","y1.jpg" 
dim conn
OpenConn
gid = request.querystring("gid")
vid = request.querystring("vid")
if gid = cstr(GetComplexGroup) or vid <> "" then kompleks = 1 else kompleks = 0
session("LastGid") = gid
session("LastVid") = vid

if gid = "" then
 set rGrupa = conn.execute ("select * from grupa where id = (select gid from vietu_veidi where id = "+vid+")")
 gid = rGrupa("id")
else
 set rGrupa = conn.execute ("select * from grupa where id = " +cstr(gid))
end if

dim new_style
new_style = true
if not rGrupa.eof then
 set r = conn.execute("select sum(cena) from vietu_veidi where gid = " + cstr(rGrupa("id")))
 if getnum(r(0)) <>0 then new_style = false
end if


%>

<%checkGroupBlocked(gid)%>

<center><font color="GREEN" size="5"><b>Grupas vietas un pakalpojumi</b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>
<%
'Izdrukâ grupas nosaukumu, ja tie ir vienkârðie pakalpojumi
'Ja tie ir apakðpakalpojumi kompleksajai grupai, tad izdrukâ linku uz augstâko kategoriju
if gid <> "" then 
	response.write grupas_nosaukums (gid,NULL)
else
	set r = conn.execute ("select * from vietu_veidi where id = " + vid)
	if getnum(r("virsnieks")) = 0 then
		'Ja nâkamais lîmenis ir pçdçjais
		response.write "<a href = 'vietu_veidi.asp?gid=" + cstr(r("gid")) + "'>" + r("nosaukums") + "</a>"
	else
		'Ja nâkamais lîmenis nav pçdçjais
		response.write "<a href = 'vietu_veidi.asp?vid=" + cstr(r("virsnieks")) + "'>" + r("nosaukums") + "</a>"
	end if
end if
%>

</font><hr>
<% 
headlinks 
DefJavaSubmit
%>
<script>
function turnRadioButtons(id){

	el = document.getElementById('carter_berns_1_'+id);
	if(el.disabled==false){
		el.disabled=true;
		el.checked=false;
	}else{
		el.disabled=false;
	}
	el = document.getElementById('carter_berns_2_'+id);
	if(el.disabled==false){
		el.disabled=true;
		el.checked=false;
	}else{
		el.disabled=false;
	}
}
</script>
<% if session("message") <> "" then %>
	<br><font color = red size = 5><%=session("message")%></font><br>
	<% session("message") = ""
end if%>
<form name="forma" method="POST">
<%
'------------- 1 Atrodam kajiites --------------
set r = server.createobject("ADODB.Recordset")
'Atkarîbâ kas norâdîts vai grupa vai augstâka lîmeòa pakalpojums
if gid <> "" then
	r.open "Select laiks_no, laiks_lidz, spec_id, viesnicas_veids,vietu_veidi.id,vietu_veidi.nosaukums,vietu_veidi.tips,vietu_veidi.max_vecums,vietu_veidi.min_vecums,cena,cenaLVL,cenaUSD,cenaEUR,limits,limita_grupa,persona,papildv,viesnicas_veidi.nosaukums as vnosaukums,carter_berns_num,ekskursija from vietu_veidi left join viesnicas_veidi on vietu_veidi.viesnicas_veids = viesnicas_veidi.id where spec_id is null and vietu_veidi.gid = " + cstr(gid) + " and virsnieks = 0 order by vietu_veidi.nosaukums",conn,3,3
else
	r.open "Select laiks_no, laiks_lidz, spec_id, viesnicas_veids,vietu_veidi.id,vietu_veidi.nosaukums,vietu_veidi.tips,vietu_veidi.max_vecums,vietu_veidi.min_vecums,cena,cenaLVL,cenaUSD,cenaEUR,limits,limita_grupa,persona,papildv,viesnicas_veidi.nosaukums as vnosaukums,carter_berns_num,ekskursija from vietu_veidi left join viesnicas_veidi on vietu_veidi.viesnicas_veids = viesnicas_veidi.id where spec_id is null and virsnieks = " + cstr(vid) + " order by vietu_veidi.nosaukums",conn,3,3
end if



if Not r.eof then
	r.movefirst
	%> 
	<center> <table border=0>
	<tr bgcolor="#ffc1cc">
	<th>Nosaukums</th>
	<th>Tips</th>
	<% if not new_style then %>
		<th>Cena</th>
	<% else %>
		<th>LVL</th>
		<th>USD</th>
		<th>EUR</th>
	<% end if %>
	<!--th>Viesnica</th-->
	<th>Limits</th>
	<th>Limita grupa</th>
	<th>Persona</th>
	<th>Max vecums</th>
	<th>Papild v.</th>
	<%if rGrupa("carter") then%>
	<!--th>Eksk.</th-->
	<th>1.bçrns</th>
	<th>2.bçrns</th>
	<%end if%>
	<th></th>
	<th></th>
	<th></th>
	<th></th>
	<th></th>
	<th>Pasûtîts</th>
	<th>Summa</th>
	</tr>
	<%
	while not r.eof
		PrintRow(r)

		'pârbaudam vai nav spec gadîjumi ðim pakalpojumam
		Set rspec = conn.execute("Select laiks_no, laiks_lidz, spec_id,viesnicas_veids,vietu_veidi.id,vietu_veidi.nosaukums,vietu_veidi.tips,vietu_veidi.max_vecums,vietu_veidi.min_vecums,cena,cenaLVL,cenaUSD,cenaEUR,limits,limita_grupa,persona,papildv,viesnicas_veidi.nosaukums as vnosaukums,carter_berns_num,ekskursija from vietu_veidi left join viesnicas_veidi on vietu_veidi.viesnicas_veids = viesnicas_veidi.id where vietu_veidi.spec_id = " + cstr(r("id")) + " order by vietu_veidi.nosaukums")

		While Not rspec.eof
			PrintRow(rspec)
			rspec.movenext
		wend

		r.MoveNext
	wend
	%></table>
	<% if gid<>"" then %>
	Saglabât visu<BR>
	<input type="image" alt="Saglabât visu" src="impro/bildes/saglabat.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit('vietu_veidi_save.asp?id=all&gid=<%=gid%>');return false;" alt = "Saglabât izdarîtâs izmaiòas visos pakalpojumos." id=image1 name=image1>
	<% end if%>
	<%
else
	response.write "Grupai pakalpojumi nav ievadîti!"
end if

%><p><hr><p>
<% if rGrupa("veids")<>1 or IsAccess(T_V_Pakalpojumi) then %>
<center><font color="GREEN" size="4"><b>Grupas pakalpojumu pievienoðana</b></font>
<p>
<table>

<tr bgcolor="#ffc1cc">
<th colspan=2>Nosaukums</th>

<th>Tips</th>
<th>Max vecums</th>
<%if rGrupa("carter") then%>
	<!--th>Eksk.</th-->
	<th>1.bçrns</th>
	<th>2.bçrns</th>
<%end if%>
<!--th>Min vecums</th-->
<!--th>Viesnica</th-->
<% if not new_style then %>
	<th>Cena</th>
<% else %>
	<th>LVL</th>
	<th>USD</th>
	<th>EUR</th>
<% end if %>
<th>Limits</th>
<th>Limita grupa</th>

<th></th></tr>
<% for i = 1 to 5 %>
	<tr bgcolor="#fff1cc">

	<td>
		<select name="pk_veids<%=i%>" width=30>
			<option value=""></option>
			<% 
			Set rPK = conn.execute("select * from pakalpojums order by name") 
			While Not rPK.eof 
				%><option value="<%=rPK("name")%>"><%=rPK("name")%></option><%
				rPK.movenext
			wend
			%>
		</select>
	</td>

	<td align="center"><input type="text" name="nosaukums<%=i%>" size="30"></td>

	<td>
		<select name=tips<%=i%>>
			<option value="0">Nav norâdîts</option>
			<% 
			Set rVVT = conn.execute("select * from vietu_veidi_tipi where not kods like '%_NA'  order by nosaukums") 
			While Not rVVT.eof 
				%><option value="<%=rVVT("kods")%>"><%=rVVT("nosaukums")%></option><%
				rVVT.movenext
			wend
			%>
		</select>
	</td>
	
	<td align = right><input type = text name = "max_vec_<%=i%>" size=4 maxlength=2 ></td>
	<%if rGrupa("carter") then%>
	<!--td align = right><input type="checkbox" name = "ekskursija_<%=i%>"  onClick="turnRadioButtons(<%=i%>);"></td-->
	<td><input type="radio" id="carter_berns_1_<%=i%>" name="carter_berns_<%=i%>" value="1" /></td>
	<td><input type="radio" id="carter_berns_2_<%=i%>" name="carter_berns_<%=i%>" value="2" /></td>	
	<%end if%>
	<!--td align = right><input type = text name = "min_vec_<%=i%>" size=4 maxlength=2 ></td-->	
	

	<% if not new_style then %>
		<td align="center"><input type="text" name="cena<%=i%>" size="7"></td>
	<% else %>
		<td align="center"><input type="text" name="cenaLVL<%=i%>" value=0 size="4"></td>
		<td align="center"><input type="text" name="cenaUSD<%=i%>" value=0 size="4"></td>
		<td align="center"><input type="text" name="cenaEUR<%=i%>" value=0 size="4"></td>
	<% end if %>
	<td align = right><input type = text name = "limits<%=i%>" size = 4 ></td>
	<td align = right><input type = text name = "limita_grupa<%=i%>" size = 7 ></td>
	
	<%
	if gid = "" then gid = "0"
	if vid = "" then vid = "0"
	%>
	</tr>
<% next %>
</table>
<input type="image" src="impro/bildes/pievienot.jpg" 
	onclick="if (!checkBlocked()) {return false;}
		<% for i = 1 to 5 %>
		if (!(nosaukums<%=i%>.value==''&&pk_veids<%=i%>.value=='')) 
			if (tips<%=i%>.value=='0') 
			{
				alert('Norâdiet tipu!');
				return false;
			}
		<% next %>
		TopSubmit('vietu_veidi_add.asp?gid=<%=gid%>&vid=<%=vid%>');return false;
		" 
	alt = "Pievienot jaunu vietu veidu.">
<% else %>
 <center><font color="GREEN" size="4"><b>Nav tiesîbu pievienot vâkto grupu pakalpojumus</b></font>
<% end if %>

</form>

</table>

</body>
</html>


<%

Sub PrintRow(r)
		bg = "#fff1cc"
		If getnum(r("spec_id"))<>0 Then bg = "88FF88"
		
		%>
		<tr bgcolor = <%=bg%>><td><input type = text name = "nosaukums<%=r("id")%>" size = 15 value = "<%=NullPrint(r("nosaukums"))%>">
		<%
			If (getnum(r("laiks_no"))<>0) Then
				Response.write "<BR><font size=2>"+timeprint(r("laiks_no"))+"-"+timeprint(r("laiks_lidz"))+"</font>"
			End if
		%>
		</td>
		<td>
			<% if nullprint(r("tips"))="" or nullprint(r("tips"))="0" then 
				ir_tips = false	%>
				<select name=tips<%=r("id")%>>
					<option value="">Nav norâdîts</option>
					<% 
					Set rVVT = conn.execute("select * from vietu_veidi_tipi where not kods like '%_NA' order by nosaukums") 
					While Not rVVT.eof 
						%><option value=<%=rVVT("kods")%>><%=rVVT("nosaukums")%></option><%
						rVVT.movenext
					wend
					%>
				</select>
			<% else
				Set rVVT = conn.execute("select * from vietu_veidi_tipi where not kods like '%_NA' order by nosaukums") 
				While Not rVVT.eof 
					if r("tips") = rVVT("kods") then %>
						<a href=vietu_veidi_change.asp?gid=<%=gid%>&vv=<%=r("id")%>&vvt=<%=rVVT("id")%>><%=rVVT("nosaukums")%></a>
					<% end if 
					rVVT.movenext
				wend
				ir_tips = true
				%><input type=hidden name=tips<%=r("id")%> value=<%=r("tips")%>><%
			end if %>
		</td>
		<% if not new_style then %>
			<td align = right><input type = text name = "cena<%=r("id")%>" size = 7 value = <%=GetNum(r("cena"))%>></td>
		<% else %>
			<td align = right><input type = text name = "cenaLVL<%=r("id")%>" size = 4 value = <%=GetNum(r("cenaLVL"))%>></td>
			<td align = right><input type = text name = "cenaUSD<%=r("id")%>" size = 4 value = <%=GetNum(r("cenaUSD"))%>></td>
			<td align = right><input type = text name = "cenaEUR<%=r("id")%>" size = 4 value = <%=GetNum(r("cenaEUR"))%>></td>
		<% end if %>
<!-- viesnicas iznjemts 26 feb 2009 /Nils-->
		<td align = right><input type = text name = "limits<%=r("id")%>" size = 4 value = <%=r("limits")%>></td>
		<td align = right><input type = text name = "limita_grupa<%=r("id")%>" size = 10 value = <%=NullPrint(r("limita_grupa"))%>></td>
		<td align = right><input type = checkbox name = "persona<%=r("id")%>" <% if r("persona") = true then Response.Write " checked "%> <% if ir_tips = true then Response.Write " disabled "%>></td>
		
		<% if r("persona") = True Or r("tips") = "X" Or r("tips") = "EX" Or r("tips") = "ED" then %>
		<td align = right><input type = text name = "max_vec_<%=r("id")%>" size=2 maxlength=2 value=<%=r("max_vecums")%>></td>
		<% else %>
		<td align = right>&nbsp;</td>
		<% end if %>
		
		<td align = center><input type = checkbox name = "papildv<%=r("id")%>" <% if r("papildv") = true then Response.Write " checked "%> <% if ir_tips = true then Response.Write " disabled "%>></td>
		<%if rGrupa("carter") then%>
		<!--td align = center-->
			<% if 1=0 And r("tips") = "X" then '--- iznemts 27. dec 2013 Nils. ieviests vietu veidu tips - Ekskursija %>
			<input type="checkbox" name="ekskursija_<%=r("id")%>" <% if r("ekskursija") = true then Response.Write " checked "%> onClick="turnRadioButtons(<%=r("id")%>);">
			<% end if %>
		<!--/td-->
		<td>
			<%if getnum(r("max_vecums"))>0 then%>
			<input type="radio" id="carter_berns_1_<%=r("id")%>" name="carter_berns_<%=r("id")%>" value="1" <%if r("carter_berns_num")=1 then rw "checked"%> <% if r("tips") = "EX" then Response.Write " disabled "%> />
			<%end if%>
		</td>
		<td>
			<%if getnum(r("max_vecums"))>0 then%>
			<input type="radio" id="carter_berns_2_<%=r("id")%>" name="carter_berns_<%=r("id")%>" value="2" <%if r("carter_berns_num")=2 then rw "checked"%> <% if r("tips") = "EX" then Response.Write " disabled "%> />
			<%end if%>
		</td>
		
		<%end if%>
		<% if rGrupa("veids")<>1 or IsAccess(T_V_Pakalpojumi) then %>
		  <td align=right><input type="image" border=0 src="impro/bildes/dzest.jpg" onclick="if (!checkBlocked()) {return false;} if (confirm('Dzçst?')) {window.open('vietu_veidi_del.asp?id=<%=r("id")%>')} return false;" alt = "Dzçst vietu veidu."></td>
		  <td align=right><input type="image" border=0 src="impro/bildes/saglabat.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit('vietu_veidi_save.asp?id=<%=cstr(r("id"))%>');return false;" alt = "Saglabât izdarîtâs izmaiòas ðajâ rindâ." id=image1 name=image1></td>
		<% else %>
		  <td align=right></td><td align=right></td>
		<% end if %>
		<td><a href="vietu_veidi.asp?vid=<%=r("id")%>" ><img style="border:none" src = "impro/bildes/meklet.jpg" alt = "Apskatît apakðkategorijas"></td>
		<td><a href = "vesture.asp?tabula=vietu_veidi&id=<%=r("id")%>" target=_blank><img  style="border:none" src="impro/bildes/clock.bmp"></a></td>
		<td>
			<% If (r("tips")="C" Or r("tips")="CH1") Then %>
			<a href = "vietu_veidi_spec.asp?tabula=vietu_veidi&id=<%=r("id")%>"><img  style="border:none" src="impro/bildes/spec.bmp"></a>
			<% End If %>
		</td>
		<td align = right><%=conn.execute("select count(id) from piet_saite where deleted = 0  and pid in (select id from pieteikums where deleted = 0 and id = piet_saite.pid) and vietas_veids="+cstr(r("id")))(0)%></td>
		<%
		  set rSumma = conn.execute("select sum(summaLVL) as s1, sum(summaUSD) as s2, sum(summaEUR) as s3 from piet_saite where vietas_veids = "+cstr(r("id"))+" and deleted = 0 and pid in (select id from pieteikums where deleted=0 and bilanceLVL>=0 and bilanceEUR>=0 and bilanceUSD>=0)")
		 ' response.write("select sum(summaLVL) as s1, sum(summaUSD) as s2, sum(summaEUR) as s3 from piet_saite where vietas_veids = "+cstr(r("id"))+" and deleted = 0 and pid in (select id from pieteikums where deleted=0 and bilanceLVL>=0 and bilanceEUR>=0 and bilanceUSD>=0)<br><br>")
		  
		  
		  if not rSumma.eof then
		    summaLVL=rSumma("s1")
		    if isnull(summaLVL) then summaLVL=0
		    summaUSD=rSumma("s2")
		    if isnull(summaUSD) then summaUSD=0
		    summaEUR=rSumma("s3")
		    if isnull(summaEUR) then summaEUR=0
		    Response.Write "<td nowrap=1 align=right>" & Curr3Print(clng(summaLVL),clng(summaUSD),clng(summaEUR)) & "</td>"
		  else
		    Response.Write "<td align=right>0.00</td>"
		  end if
		%>
		</tr>
		<%

End Sub

%>