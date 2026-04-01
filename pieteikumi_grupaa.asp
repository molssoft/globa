<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

dim conn
openconn


'--- ligumi ---
'--- ja ir nodots GET parametrs mode=ligums, pasta indeksu saglabasana tiek izslegta, 
'--- jo to formas konfliktee ar ligumu izveidoshanas formu.

dim mode_ligums,mode_piezimes
mode_ligums = false
mode_piezimes = false

If request("force_delete") Then
	conn.execute("update pieteikums set deleted = 1 where id = "+CStr(request("force_delete")))
End if

if Request("mode")="piezimes_rez" then
	mode_piezimes_rez = true
end if

if Request("mode")="piezimes_prof" then
	mode_piezimes_prof = true
end if

if Request("mode")="ligums" then
	mode_ligums = true
	
	'liguma dzeshana
	d_lid = request.querystring("d_lid")
	if d_lid <> "" Then
	
		''atsledz abus ligumus droshibai, neparbaudot vai eksiste vai nee
		conn.execute ("update ligumi set deleted = 1 where isnull(rez_id,0) <> 0 and rez_id in (select rez_id from ligumi where id = " + d_lid + ")")
		conn.execute ("update online_rez set ligums_id = null where ligums_id = "&d_lid)
		conn.execute ("update pieteikums set ligums_id = null where deleted=0 and ligums_id = '"&d_lid&"'; update ligumi set deleted = 1 where id = '"&d_lid&"'")

		qs=Request.QueryString
		' Response.Write("-> "&qs)
		' Response.Write("<br>-> pieteikumi_grupaa.asp?"&Left(qs,instr(qs,"&d_lid=")-1))
		
		Response.Redirect("pieteikumi_grupaa.asp?"&Left(qs,instr(qs,"&d_lid=")-1))
		Response.End
	end if
end if

'vouèera dzeshana

del_voucer_pid = request.querystring("del_voucer_pid")

if del_voucer_pid <> "" Then

	
	query = "SELECT * FROM pieteikums WHERE id=" + cstr(del_voucer_pid)  + ""
	'set old_vals = CreateDict(query ) 
	
	conn.execute ("update pieteikums set carter_voucer = 0 where deleted=0 and id = " + cstr(del_voucer_pid)  + "")
	
	qs=Request.QueryString
	
	'set new_vals = CreateDict(query) 
	'UpdateActionDetails old_vals,new_vals,"pieteikums",cstr(del_voucer_pid),""
	
	Response.Redirect("pieteikumi_grupaa.asp?"&Left(qs,instr(qs,"&del_voucer_pid=")-1))
	Response.End
end if

'updeito ja vajag
if Request.Form("action") = "update" then
'rw Request.Form("did")
 conn.execute ("update dalibn set indekss = '"+Request.Form("indekss")+"' where id = "+cstr(Request.Form("did")))
end if

gid = request.querystring("gid")

if gid = "" then 
	gid = -1
	message = "Nav norâdîta grupa!"
else
	message = grupas_nosaukums(gid,NULL)
	Session("LastGid") = gid
end if

set rP = conn.execute("select * from parametri")

conn.execute ("update pieteikums set did = (select top 1 did from piet_saite ps where pid = pieteikums.id and deleted = 0) " + _
	" where gid = " + cstr(gid) + _
	" and isnull(did,'') <> (select top 1 did from piet_saite ps where pid = pieteikums.id and deleted = 0)  ")



%>

<% docstart "Pieteikumu saraksts","y1.jpg" %>
<center><font color="GREEN" size="5"><b><%=Message%></b></font>
<% headlinks %>
<hr>
<%
'Normâlo pieteikumu saraksts
if gid<>"-1" then
pquery = "SELECT isnull(p.vieta_rezerveta_lidz,'') as vieta_rezerveta_lidz " + _ 
" ,p.piezimes as piezimes_rez " + _ 
" ,p.step,p.id " + _ 
" ,p.datums " + _ 
" ,p.personas " + _ 
" ,p.papildvietas " + _ 
" ,p.summaLVL" + _
" ,p.summaUSD " + _ 
" ,p.summaEUR " + _ 
" ,p.atlaidesLVL " + _ 
" ,p.atlaidesUSD " + _ 
" ,p.atlaidesEUR " + _ 
" ,p.sadardzinLVL " + _
" ,p.sadardzinUSD " + _ 
" ,p.sadardzinEUR " + _ 
" ,p.iemaksasLVL " + _ 
" ,p.iemaksasUSD " + _ 
" ,p.iemaksasEUR " + _ 
" ,p.izmaksasLVL " + _
" ,p.izmaksasUSD " + _ 
" ,p.izmaksasEUR " + _ 
" ,p.bilanceLVL " + _ 
" ,p.bilanceUSD " + _ 
" ,p.bilanceEUR " + _
" ,(select sum(summaLVL) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasLVL " + _ 
" ,(select sum(summaUSD) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasUSD " + _ 
" ,(select sum(summaEUR) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasEUR " + _ 
" ,isnull(online_rez,0) as online_rez " + _ 
" ,agents " + _
" ,p.ligums_id " + _ 
" ,l.printed " + _ 
" ,isnull(p.carter_voucer,0) as carter_voucer " + _ 
" ,online_rez " + _
" ,p.paseS " + _ 
" ,p.paseNR " + _ 
" ,p.paseDERdat " + _ 
" ,p.idS " + _ 
" ,p.idNR " + _ 
" ,p.idDerDat " + _
" ,p.did " + _
" ,d.paseS as d_paseS " + _
" ,d.paseNR as d_paseNR" + _
" ,d.paseDERdat as d_paseDERdat " + _
" ,d.idS as d_idS " + _
" ,d.idNR as d_idNR " + _
" ,d.idDerDat as d_idDerDat " + _
" ,d.adrese as d_adrese " + _
" ,d.pilseta as d_pilseta " + _
" ,d.novads as d_novads " + _
" ,d.indekss as d_indekss " + _
" ,isnull(d.vards,'')+' '+isnull(d.uzvards,d.nosaukums) as v " + _
" ,isnull(rz.no_delete,2) as no_delete " + _
" ,(select count(*) from piet_saite ps join vietu_veidi vv on ps.vietas_veids = vv.id " + _
" where ps.pid = p.id and ps.deleted = 0 and vv.tips in ('C','Z1')) as bazes " + _
" ,(select count(*) from piet_saite ps where ps.pid = p.id and ps.deleted = 0 and  isnull(kid,0)<>0 ) as kajites " + _
"from pieteikums as p " + _
"left join ligumi l on (l.id = p.ligums_id and l.deleted=0) "+_
"left join dalibn d on d.id = p.did "+_
"left join novads n on n.id = d.novads " +_
"left join online_rez rz on rz.id = p.online_rez " + _
"Where p.gid = "+gid + _
	" AND p.deleted = 0 " + _
	" AND isnull(grupas_vad,0) = 0 /*isnull(p.piezimes,'') not like 'GRUPAS VAD_T_JS'*/" &_
" order by p.id"

'pasutijuma grupas ir cilveki kur pashi nebrauc 
pas_query = "SELECT isnull(p.vieta_rezerveta_lidz,'') as vieta_rezerveta_lidz " + _ 
" ,p.piezimes as piezimes_rez " + _ 
" ,p.step,p.id " + _ 
" ,p.datums " + _ 
" ,p.personas " + _ 
" ,p.papildvietas " + _ 
" ,p.summaLVL" + _
" ,p.summaUSD " + _ 
" ,p.summaEUR " + _ 
" ,p.atlaidesLVL " + _ 
" ,p.atlaidesUSD " + _ 
" ,p.atlaidesEUR " + _ 
" ,p.sadardzinLVL " + _
" ,p.sadardzinUSD " + _ 
" ,p.sadardzinEUR " + _ 
" ,p.iemaksasLVL " + _ 
" ,p.iemaksasUSD " + _ 
" ,p.iemaksasEUR " + _ 
" ,p.izmaksasLVL " + _
" ,p.izmaksasUSD " + _ 
" ,p.izmaksasEUR " + _ 
" ,p.bilanceLVL " + _ 
" ,p.bilanceUSD " + _ 
" ,p.bilanceEUR " + _
" ,(select sum(summaLVL) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasLVL " + _ 
" ,(select sum(summaUSD) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasUSD " + _ 
" ,(select sum(summaEUR) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasEUR " + _ 
" ,isnull(online_rez,0) as online_rez " + _ 
" ,agents " + _
" ,p.ligums_id " + _ 
" ,l.printed " + _ 
" ,isnull(p.carter_voucer,0) as carter_voucer " + _ 
" ,online_rez " + _
" ,p.paseS " + _ 
" ,p.paseNR " + _ 
" ,p.paseDERdat " + _ 
" ,p.idS " + _ 
" ,p.idNR " + _ 
" ,p.idDerDat " + _
" ,p.did " + _
" ,d.paseS as d_paseS " + _
" ,d.paseNR as d_paseNR" + _
" ,d.paseDERdat as d_paseDERdat " + _
" ,d.idS as d_idS " + _
" ,d.idNR as d_idNR " + _
" ,d.idDerDat as d_idDerDat " + _
" ,d.adrese as d_adrese " + _
" ,d.pilseta as d_pilseta " + _
" ,d.novads as d_novads " + _
" ,d.indekss as d_indekss " + _
" ,isnull(d.vards,'')+' '+isnull(d.uzvards,d.nosaukums) as v " + _
" ,isnull(rz.no_delete,2) as no_delete " + _
"from pieteikums as p " + _
"left join ligumi l on (l.id = p.ligums_id and l.deleted=0) "+_
"left join dalibn d on d.id = p.did "+_
"left join novads n on n.id = d.novads " +_
"left join online_rez rz on rz.id = p.online_rez " + _
"Where p.gid = "+gid + _
	" AND p.deleted = 0 " + _
	" AND isnull(grupas_vad,0) = 1 " &_
" order by p.id"

set pieteikumi = conn.execute(pquery)
set pas_pieteikumi = conn.execute(pas_query)




if not pieteikumi.eof then
%>

<center><font color="GREEN" size="4"><b>Pieteikumi grupâ</b></font><br />
<% If (Not mode_ligums) Then %>
	<a href="pieteikumi_grupaa.asp?gid=<%=gid%>&mode=ligums">Râdît lîgumus</a>
<% End If %>

<% If (Not mode_piezimes_rez) Then %>
	<a href="pieteikumi_grupaa.asp?gid=<%=gid%>&mode=piezimes_rez">Râdît rezervâcijas piezîmes</a>
<% End If %>

<% If (Not mode_piezimes_prof) Then %>
	<a href="pieteikumi_grupaa.asp?gid=<%=gid%>&mode=piezimes_prof">Râdît profila piezîmes</a>
<% End If %>
<div id="pieteikumi_count">
<%
qc=pieteikumi.recordcount
pas_c=pas_pieteikumi.recordcount
response.write Galotne(qc,"Atrasts","Atrasti")+ " "+cstr(qc)+ Galotne(qc,"pieteikums","pieteikumi")





%>
</div>
<% if session("message")<>"" then
%>
<center><font color="GREEN" ><b><%=session("message")%></b></font><br />
<%
	session("message") = ""
end if%>



<table style="border-collapse: collapse;">
<%
if mode_ligums then%>
<form name="f_ligumi" id="f_ligumi" method="POST" action="ligums.asp">
<%end if%>
<tr bgcolor = #ffc1cc>
<th>Nr</th>
<th align = "left">Piet.</th>
<!--th align = "left"> Dalibn.ID </th-->
<% if GetUser() <> "IMPRO\diana" then %>
<th align = "left"> Vârds </th>
<th align = "left"> Adrese </th>
<th align = "left"> Pilsçta </th>
<!--th align = "left"> Novads </th-->
<th align = "left"> Indekss </th>
<% end if %>
<th align = "left"> Datums </th>
<th align = "left"> Vietas </th>
<th align = "left"> Bilance </th>
<th align = "left"> Neapst.<br />iemaksas </th>

<th align = "left"> Vauèeris</th>
<th> Dokumenti</th>
<th>Vieta rez.<br>lîdz</th>

<%if mode_ligums then%>
<th align = "left"> Lîgums </th>
<th align = "left" style="">Lîgums<br>nosûtîts</th>
<th align = "left" style="">Lîgums<br>parakst.</th>
<th align = "left">&nbsp;</th>

<% end if

if mode_piezimes_rez then
	%>
	<th align = "left">Rezervâcijas piezîmes </th>
	<%
end if%>

<%if mode_piezimes_prof then
	%>
	<th align = "left">Profila piezîmes </th>
	<%
end if%>
<th align = "left">&nbsp;</th>
</tr>



<%
i = 0
eksiste_ligumi = 0
while not pieteikumi.eof

	
	
	dim nepabeigts_online
	nepabeigts_online = false
	if pieteikumi("online_rez") = 0 then nepabeigts_online = true
	
 if (not nepabeigts_online) then

 i = i + 1

 	if pieteikumi("online_rez")>0 then
 		row_style = "style=""color:green;"""
 	elseif pieteikumi("agents")>0 then
 		row_style = "style=""color:blue;"""
 	else
 		row_style = "style=""color:black;"""
 	end if
 	
 	if not mode_ligums then%>
 	<form name=forma method=POST>
 	<input type=hidden name=action value=update>
 	<% end if%>
 	<input type=hidden name=did value=<%=pieteikumi("did")%>>
 	
 	<tr bgcolor = #fff1cc>
	<td <%=row_style%>><%=cstr(i)%>.</td>
 	<td <%=row_style%>><a href = 'pieteikums.asp?pid=<%=cstr(pieteikumi("id"))%>'><img src='impro/bildes/k_zals.gif'></a></td>
 	<!--td><%=pieteikumi("id")%></td-->
	<td <%=row_style%>><a href=dalibn.asp?i=<%=pieteikumi("did")%> target=new>
	<nobr><%=pieteikumi("V")%></a></nobr>
			<% if getnum(pieteikumi("bazes")) = 0 and getnum(pieteikumi("kajites")) = 0 then %>
				<font color=red style="font-size:10pt"><br>trûkst bâzes cena</font>
			<% end if %>
	</td>
	<% if GetUser() <> "IMPRO\diana" then %>

 	<td <%=row_style%>><nobr><%=pieteikumi("d_adrese")%></nobr></td>
 	<td <%=row_style%>><nobr><%=pieteikumi("d_pilseta")%></nobr></td>
 	<!--td <%=row_style%>><nobr><%=pieteikumi("d_novads")%></nobr></td-->
 	<td <%=row_style%>>
		<%if not mode_ligums and not mode_piezimes_rez and not mode_piezimes_prof then%>
			<input type=input size=4 name=indekss value="<%=pieteikumi("d_indekss")%>">
		<%else
			response.write "LV-"&pieteikumi("d_indekss")	
		end if
	end if
	%>
 	</td>
 	<td <%=row_style%>><%=dateprint(pieteikumi("datums"))%></td>
 	<td <%=row_style%>><%=getnum(pieteikumi("personas"))%> + <%=getnum(pieteikumi("papildvietas"))%></td>
 	<td <%=row_style%>><%=Curr3Print(pieteikumi("bilanceLVL"),pieteikumi("bilanceUSD"),pieteikumi("bilanceEUR"))%></td>
	<td><span style="color:red;"><%=Curr3Print(pieteikumi("neapsiemaksasLVL"),pieteikumi("neapsiemaksasUSD"),pieteikumi("neapsiemaksasEUR"))%></span></td>
	<td <%=row_style%>><% If pieteikumi("carter_voucer") = True Then 
								rw "IR"
								%>
								<!--input type="image" name="dzest" alt="Dzçst vouèeri" src="impro/bildes/dzest.jpg" onclick="javascript:if(confirm('Vai dzçst vauèeri?')){document.forms[0].action='pieteikumi_grupaa.asp?<%=Request.QueryString%>&del_voucer_pid=<%=pieteikumi("id")%>';document.forms[0].submit();}else{return false;}" WIDTH="15" HEIGHT="15"-->
			<img src="impro/bildes/dzest.jpg" onclick="javascript:if(confirm('Vai dzçst vauèeri?')){window.location.replace('pieteikumi_grupaa.asp?<%=Request.QueryString%>&del_voucer_pid=<%=pieteikumi("id")%>');}else{return false;}" WIDTH="15" HEIGHT="15">
			
								<%
							Else
								rw "nav"
							End if
						%>
	</td>
	
	<% 

	
		 dokumenti_ok = 1
		   
		if (pieteikumi("paseS") <> "") then

	
			if StrComp(Trim(UCase(pieteikumi("paseS"))),Trim(UCase(pieteikumi("d_paseS")))) <> 0 then 
				dokumenti_ok = 0
			end if
		end if
		if (pieteikumi("paseNR") <> "") then
		
			if StrComp(Trim(pieteikumi("paseNR")),Trim(pieteikumi("d_paseNR"))) <> 0  then 
				dokumenti_ok = 0
			end if
			
		end if
		if (pieteikumi("paseDERdat") <> "") then
		
			if StrComp(pieteikumi("paseDERdat"),pieteikumi("d_paseDERdat")) <> 0  then 
				dokumenti_ok = 0
			end if
			
		end if
			if (pieteikumi("idS") <> "") then
		
			if StrComp(Trim(UCase(pieteikumi("idS"))),Trim(UCase(pieteikumi("d_idS")))) <> 0  then 
				dokumenti_ok = 0
			end if
			
		end if
			if (pieteikumi("idNR") <> "") then
		
			if StrComp(Trim(pieteikumi("idNR")),Trim(pieteikumi("d_idNR"))) <> 0  then 
				dokumenti_ok = 0
			end if
			
		end if
			if (pieteikumi("idDerDat") <> "") then
		
			if StrComp(pieteikumi("idDerDat"),pieteikumi("d_idDerDat")) <> 0  then 
				dokumenti_ok = 0
			end if
			
		end if
		
		if (dokumenti_ok) then
			dok_teksts = "OK"
			dok_style = ""
		else
			dok_teksts= "nesakrît"
			dok_style = "color:red"
		end if
		
		
	%>
	<td  >
		<a style="<%=dok_style%>" href="pieteikums_dalibn_dok.php?pid=<%=pieteikumi("id")%>"><%=dok_teksts%></a>
	</td>
	
		<% 
		style = ""
		if pieteikumi("vieta_rezerveta_lidz") <> "" then
			
			if  pieteikumi("vieta_rezerveta_lidz") < date() and  pieteikumi("vieta_rezerveta_lidz")<> cdate("1900-01-01") then
				style="color:red"
			end if
		end if
	%>
	<td style="<%=style%>"><%=dateprint(pieteikumi("vieta_rezerveta_lidz"))%></td>
	<%


	if mode_ligums Then

		
	%>
	<td>
		<%
		ligums_id = getnum(pieteikumi("ligums_id"))
		accepted = 0
		
		'mçìinam atrast lîgumu kas saglabâts savâdâk. 
		'tâ nevajadzçtu bût, bet daþreiz gadâs
		if ligums_id = 0 and getnum(pieteikumi("online_rez"))<>0 then
			set rlig = conn.execute("select id from ligumi where deleted = 0 and rez_id = "+cstr(pieteikumi("online_rez"))+" order by id desc" )
			if not rlig.eof then 
				ligums_id = rlig("id")
			end if
		end if
		'rw ligums_id
		
		if ligums_id <> 0 then 
		
			eksiste_ligumi = 1
			ssql = "select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id)
			'rw ssql
			Set ligums = conn.execute("select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id))
			accepted = ligums("accepted")
			accepted = 1
			parakstits = ligums("parakstits")
			nosutits = ligums("nosutits")
			if pieteikumi("printed")=true then  
				printed_str = "izdrukâts"
				page = "download_pdf"
				target = "_blank"
			else
				printed_str = "nav izdr."
				page = "ligums"
				target = ""
			end if
			
			If accepted <> 0 then
				%>
				<a href="<%=page%>.asp?id=<%=ligums_id%>" target="<%=target%>"><%=ligums_id%></a>
				<font size="1"><%=printed_str%>&nbsp;
			<% Else %>
				<a href="<%=page%>.asp?id=<%=ligums_id%>" target="<%=target%>">sagatave</a>
				<font size="1">&nbsp;
			<% End If %>
			
			<input type="image" name="dzest" alt="Dzçst lîgumu" src="impro/bildes/dzest.jpg" onclick="javascript:if(confirm('Vai dzçst lîgumu <%=ligums_id%>?')){document.forms[0].action='pieteikumi_grupaa.asp?<%=Request.QueryString%>&d_lid=<%=ligums_id%>';document.forms[0].submit();}else{return false;}" WIDTH="15" HEIGHT="15">
			</font>
		<%else

			'--- parbauda vai nav online_rez un taas liigums
			ssql = "select r.ligums_id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
					"where p.id = "&pieteikumi("id")&" and r.deleted = 0 and p.deleted = 0" 
					
			set o_rez = conn.execute(ssql)
			if not o_rez.eof Then
				If getnum(o_rez("ligums_id")) <> 0 Then 
					%>
					<a href="download_pdf.asp?id=<%=o_rez("ligums_id")%>" target="_blank"><%=o_rez("ligums_id")%></a>&nbsp;<font size="1">online</font>&nbsp;
					<input type="image" name="dzest" alt="Dzçst lîgumu" src="impro/bildes/dzest.jpg" onclick="javascript:if(confirm('Vai dzçst lîgumu <%=o_rez("ligums_id")%>?')){document.forms[0].action='pieteikumi_grupaa.asp?<%=Request.QueryString%>&d_lid=<%=o_rez("ligums_id")%>&o_rez=1';document.forms[0].submit();}else{return false;}" WIDTH="15" HEIGHT="15"><%
				Else
					%><input type="checkbox" name="ligums" value="<%=cstr(pieteikumi("id"))%>" /><%
				End If %>
			<%else%>
				<input type="checkbox" name="ligums" value="<%=cstr(pieteikumi("id"))%>" />
			<%end if	
		end if%>
		
	</td>
		<% if mode_ligums and ligums_id <> 0 Then 
			Set ligums = conn.execute("select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id))
			
			parakstits = ligums("parakstits")
			nosutits = ligums("nosutits")%>
	<td>
		<input type="checkbox" name="nosutits_<%=ligums_id%>" value="<%=cstr(ligums_id)%>" id="nosutits_<%=ligums_id%>" <% if nosutits then rw "checked" end if %>>	
		<input type="hidden" name="nosutits_<%=ligums_id%>" value="0" id="nenosutits_<%=ligums_id%>" >
		
	<td>
	<!--<input type="hidden" name="checkbox[<%=ligums_id%>]" value="0">
		<input type="checkbox" name="checkbox[<%=ligums_id%>]" value="<%=ligums_id%>">
		
		<input type="hidden" name="visi_ligumi" value="<%=cstr(ligums_id)%>" id="visi_ligumi_<%=ligums_id%>"/>
		-->
		<% if not nosutits then %>
		<div class="slept_parakstit_<%=ligums_id%>" style="display:none">
		<% end if %>
		<input type="checkbox" name="parakstit_<%=ligums_id%>" value="<%=cstr(ligums_id)%>" id="parakstit_<%=ligums_id%>" <% if parakstits then rw "checked" else rw "style='outline-color:red;outline-style:solid;outline-width:thin'" end if %>>	
		<% if not nosutits then %>
		</div>
		<% end if %>
		<input type="hidden" name="parakstit_<%=ligums_id%>" value="0" id="neparakstit_<%=ligums_id%>" >
		
	</td>	
	
		<%end if %>

	<% if i=1 then 'rowspan izvada tikai pirmo rindu%>
	<td rowspan="<%=qc%>"><button type="submit" name="subm" id="b_ligums" value="1" style="display:none">Izveidot lîgumu</button></td>
	<% end if%>




	
	<%else 	 
		if mode_piezimes_rez then
		%>
		<td><%=pieteikumi("piezimes_rez")%></td>
		<%
		else 
			if mode_piezimes_prof then
			%><td><%=r("piezimes_prof")%></td>
			<%
			else%>
		
			<td><input type=image src=impro/bildes/diskete.jpg ></td>
			<%
			end if
		end if
	end if%>
 	</tr>
 	
 	<%if not mode_ligums then%>
 	</form>
 	<%end if
 	
 Else

 
	if pieteikumi("online_rez") = 0 and not nepabeigts_online then
		%><tr bgcolor = red>
		<td ><%=cstr(i)%>.</td>
		<td ><a href = 'pieteikums.asp?pid=<%=cstr(pieteikumi("id"))%>'><img src='impro/bildes/k_zals.gif'></a></td>
		<td>Kïûdains pieteikums <a href="pieteikumi_grupaa.asp?gid=<%=gid%>&force_delete=<%=cstr(pieteikumi("id"))%>" onclick="return confirm('Dzest?')">[dzest]</a></td>
		</tr>
		<%
	else
		i=i+1
		dim minutes
		minutes = round((now() - pieteikumi("datums"))*24*60)
		%><tr bgcolor = yellow>
		<td ><%=cstr(i)%>.</td>
		<td ><a href = 'pieteikums.asp?pid=<%=cstr(pieteikumi("id"))%>'><img src='impro/bildes/k_zals.gif'></a></td>
		<td>Nepabeigts online (<%=minutes%> min)</td>
		</tr>
		<%
	end if
 end if
	pieteikumi.movenext
wend

if mode_ligums then%>
 <% if eksiste_ligumi then %>
 <tr><td colspan="13" align="right"></td>
 <td colspan="2"><button type="submit"  onclick="return beforeSubmit();" >Saglabât izmaiòas</button>
 <input type="hidden" name="subm"  value="2" />
	<input type="hidden" name="gid" value="<%=gid%>"/></td></tr>
 <%
 

 end if %>
</form>
<%end if%>

</table>

<%
if i>0 and i<>qc Then
	%>
	<script>
		document.getElementById("pieteikumi_count").innerHTML = "<%response.write Galotne(i,"Atrasts","Atrasti")+ " "+cstr(i)+ " "+Galotne(i,"pieteikums","pieteikumi")%>";
	</script>
	<%
End if
%>
<% else %>
	<center>
	<font size = "5"><strong>Nav reìistrçtu pieteikumu</strong></font>
<%
end if
end if


%><br><br><%




'Atteikuðies 

	

if gid<>"-1" then

pquery0 = "SELECT p.id " + _
",p.datums " + _
",p.personas " + _
",p.papildvietas " + _
",p.summaLVL " + _
",p.summaUSD " + _
",p.summaEUR " + _
",p.atlaidesLVL " + _
",p.atlaidesUSD " + _
",p.atlaidesEUR " + _
",p.sadardzinLVL " + _
",p.sadardzinUSD " + _
",p.sadardzinEUR " + _
",p.iemaksasLVL " + _
",p.iemaksasUSD " + _
",p.iemaksasEUR " + _
",p.izmaksasLVL " + _
",p.izmaksasUSD " + _
",p.izmaksasEUR " + _
",p.bilanceLVL " + _
",p.bilanceUSD " + _
",p.bilanceEUR " + _
",(select sum(summaLVL) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasLVL " + _ 
",(select sum(summaUSD) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasUSD " + _ 
",(select sum(summaEUR) from orderis where pid = p.id and parbaude=1 and deleted=0) as neapsiemaksasEUR " + _ 
",(select sum(summaEUR) from orderis where nopid = p.id and resurss_uz like '__.Z') as zaud " + _
",p.dat_atcelts " + _ 
"from pieteikums as p  " + _
"Where p.old_gid = "+gid +" AND p.deleted = 0 AND p.gid = "+cstr(rP("atteikusies")) 
pquery = pquery0 + " order by p.id;Select @@RowCount"

set pieteikumi = conn.execute(pquery)
set skaits = conn.execute("Select count(t.id) from ("+pquery0+") t")
qc = skaits(0)



 'Response.Write(pquery)

if not pieteikumi.eof then
%>

<center><font color="GREEN" size="4"><b>Atteikuðies</b></font><br />
<%
'qc=pieteikumi.recordcount

response.write Galotne(qc,"Atrasts","Atrasti")+ " "+cstr(qc)+ " "+Galotne(qc,"pieteikums","pieteikumi")
%>
<table>
<tr bgcolor = #ffc1cc>
<th>Nr</th>
<th align = "left"></th>
<th align = "left"> Nr. </th>
<th align = "left"> Vârds </th>
<th align = "left"> Datums </th>
<th align = "left"> Pers. </th>
<th align = "left"> Pap.v. </th>
<th align = "left"> Summa </th>
<th align = "left"> Atlaides </th>
<th align = "left"> Piemaksas </th>
<th align = "left"> Iemaksâts </th>
<th align = "left"> Atteikuma datums </th>
<th align = "left"> Zaudçtâ nauda </th>
<th align = "left"> Izmaksâts </th>
<th align = "left"> Bilance </th>
<th align = "left"> Neapst. iemaksas </th>

</tr>
<%
i = 0
while not pieteikumi.eof
	i = i + 1

	%>
	<tr bgcolor = #fff1cc>
		<td><%=cstr(i)%>.</td>
		<td><a href = 'pieteikums.asp?pid=<%=cstr(pieteikumi("id"))%>'><img src='impro/bildes/k_zals.gif'></a></td>
		<td><%=pieteikumi("id")%></td>
		<td>
			<%=conn.execute("select isnull(vards,'')+' '+isnull(uzvards,nosaukums) from dalibn where id in (select did from piet_saite where pid = "+cstr(pieteikumi("id"))+")")(0)%>
		</td>
		<td><%=dateprint(pieteikumi("datums"))%></td>
		<td><%=getnum(pieteikumi("personas"))%></td>
		<td><%=getnum(pieteikumi("papildvietas"))%></td>
		<td><%=Curr3Print(pieteikumi("summaLVL"),pieteikumi("summaUSD"),pieteikumi("summaEUR"))%></td>
		<td><%=Curr3Print(pieteikumi("atlaidesLVL"),pieteikumi("atlaidesUSD"),pieteikumi("atlaidesEUR"))%></td>
		<td><%=Curr3Print(pieteikumi("sadardzinLVL"),pieteikumi("sadardzinUSD"),pieteikumi("sadardzinEUR"))%></td>
		<td><%=Curr3Print(pieteikumi("iemaksasLVL"),pieteikumi("iemaksasUSD"),pieteikumi("iemaksasEUR"))%></td>
		<td><%=dateprint(pieteikumi("dat_atcelts"))%></td>
		<td><%=pieteikumi("zaud")%></td>
		<td><%=Curr3Print(pieteikumi("izmaksasLVL"),pieteikumi("izmaksasUSD"),pieteikumi("izmaksasEUR"))%></td>
		<td><%=Curr3Print(pieteikumi("bilanceLVL"),pieteikumi("bilanceUSD"),pieteikumi("bilanceEUR"))%></td>
		<td><span style="color:red;"><%=Curr3Print(pieteikumi("neapsiemaksasLVL"),pieteikumi("neapsiemaksasUSD"),pieteikumi("neapsiemaksasEUR"))%></span></td>
	</tr>
	<%
	pieteikumi.movenext
wend
%>
</table>

<% else %>
	<center>
	<font size = "5"><strong>Nav reìistrçtu atteikumu</strong></font>
<%
end if
end if

%><br><br><%



'Atcelti
if gid<>"-1" then
pquery0 = "SELECT p.id,p.datums,p.personas,p.papildvietas,p.summaLVL,p.summaUSD,p.summaEUR,p.atlaidesLVL,p.atlaidesUSD,p.atlaidesEUR,p.sadardzinLVL,p.sadardzinUSD,p.sadardzinEUR,p.iemaksasLVL,p.iemaksasUSD,p.iemaksasEUR,p.izmaksasLVL,p.izmaksasUSD,p.izmaksasEUR,p.bilanceLVL,p.bilanceUSD,p.bilanceEUR, Sum(isnull(o.summaLVL,0)) as neapsiemaksasLVL, Sum(isnull(o.summaUSD,0)) as neapsiemaksasUSD, Sum(isnull(o.summaEUR,0)) as neapsiemaksasEUR from pieteikums as p left join orderis as o on (o.pid=p.id and o.parbaude=1  and o.deleted=0) "+_
"Where p.old_gid = "+gid +" AND p.deleted = 0 AND p.gid = "+cstr(rP("atcelts")) &_
" group by p.id,p.datums,p.personas,p.papildvietas,p.summaLVL,p.summaUSD,p.summaEUR,p.atlaidesLVL,p.atlaidesUSD,p.atlaidesEUR,p.sadardzinLVL,p.sadardzinUSD,p.sadardzinEUR,p.iemaksasLVL,p.iemaksasUSD,p.iemaksasEUR,p.izmaksasLVL,p.izmaksasUSD,p.izmaksasEUR,p.bilanceLVL,p.bilanceUSD,p.bilanceEUR" 
pquery = pquery0 + " order by p.id"
set pieteikumi = conn.execute(pquery)
set skaits = conn.execute("Select count(t.id) from ("+pquery0+") t")
qc = skaits(0)
'Response.Write pquery
if not pieteikumi.eof then
%>

<center><font color="GREEN" size="4"><b>Atcelti</b></font><br />
<%
'qc=pieteikumi.recordcount
response.write Galotne(qc,"Atrasts","Atrasti")+ " "+cstr(qc)+ " "+Galotne(qc,"pieteikums","pieteikumi")
%>
<table>
<tr bgcolor = #ffc1cc>
<th>Nr</th>
<th align = "left"></th>
<th align = "left"> Nr. </th>
 <th align = "left"> Vârds </th>
<th align = "left"> Datums </th>
<th align = "left"> Pers. </th>
<th align = "left"> Pap.v. </th>
<th align = "left"> Summa </th>
<th align = "left"> Atlaides </th>
<th align = "left"> Piemaksas </th>
<th align = "left"> Iemaksâts </th>
<th align = "left"> Izmaksâts </th>
<th align = "left"> Bilance </th>
<th align = "left"> Neapstiprinatas iemaksas </th>
</tr>
<%
i = 0
while not pieteikumi.eof
	i = i + 1
	%>
	<tr bgcolor = #fff1cc>
	<td><%=cstr(i)%>.</td>
	<td><a href = 'pieteikums.asp?pid=<%=cstr(pieteikumi("id"))%>'><img src='impro/bildes/k_zals.gif'></a>
	<td><%=pieteikumi("id")%>
	<td><%=conn.execute("select isnull(vards,'')+' '+isnull(uzvards,nosaukums) from dalibn where id in (select did from piet_saite where pid = "+cstr(pieteikumi("id"))+")")(0)%>
	<td><%=dateprint(pieteikumi("datums"))%>
	<td><%=getnum(pieteikumi("personas"))%>
	<td><%=getnum(pieteikumi("papildvietas"))%>
	<td><%=Curr3Print(pieteikumi("summaLVL"),pieteikumi("summaUSD"),pieteikumi("summaEUR"))%>
	<td><%=Curr3Print(pieteikumi("atlaidesLVL"),pieteikumi("atlaidesUSD"),pieteikumi("atlaidesEUR"))%>
	<td><%=Curr3Print(pieteikumi("sadardzinLVL"),pieteikumi("sadardzinUSD"),pieteikumi("sadardzinEUR"))%>
	<td><%=Curr3Print(pieteikumi("iemaksasLVL"),pieteikumi("iemaksasUSD"),pieteikumi("iemaksasEUR"))%>
	<td><%=Curr3Print(pieteikumi("izmaksasLVL"),pieteikumi("izmaksasUSD"),pieteikumi("izmaksasEUR"))%>
	<td><%=Curr3Print(pieteikumi("bilanceLVL"),pieteikumi("bilanceUSD"),pieteikumi("bilanceEUR"))%>
	<td><span style="color:red;"><%=Curr3Print(pieteikumi("neapsiemaksasLVL"),pieteikumi("neapsiemaksasUSD"),pieteikumi("neapsiemaksasEUR"))%></span></td>
	</tr>
	<%
	pieteikumi.movenext
wend
%>
</table>

<% else %>
	<center>
	<font size = "5"><strong>Nav atceltu pieteikumu</strong></font>
<%
end if
end if

%>


<script type="text/javascript">
$(document).ready(function() {


  $(":checkbox[name='ligums']").click(function() {
  	 if($(this).is(':checked') && !$("#b_ligums").is(":visible")){ //parâda pogu, ja ir iekliskinâts kâds checkbox un poga nav redzama
  	

  		$("#b_ligums").show();
  			
  	 }else if($("input:checkbox[name='ligums']:checked").length == 0){ //slçpj pogu, ja neviens checkbox nav iezîmçts

  		$("#b_ligums").hide();
  	 }
  });
   $(":checkbox[name^='nosutits']").click(function() {
 
	if($(this).is(':checked')){ //
  		//ieíesçjam arî pârçjos vienâdos	
		var value=$(this).val();
  		$("input:checkbox[name^='nosutits'][value='"+value+"']").prop('checked', true);
  		//parâdâm arî parakstîðanas íeksi
		$(".slept_parakstit_"+value).show();
  				
  	 }else { 
		var value=$(this).val();
		//izíeksçjam , ka ir parakstîts:
		$("input:checkbox[name^='parakstit'][value='"+value+"']").prop('checked',false);
		//un noslçpjama paraksta boxu
		$(".slept_parakstit_"+value).hide();
  		$("input:checkbox[name^='nosutits'][value='"+value+"']").prop('checked',false);
  		
  	 }
	   });
	 
  $(":checkbox[name^='parakstit']").click(function() {

	   if($(this).is(':checked')){ //
			//ieíesçjam arî pârçjos vienâdos	
			var value=$(this).val();
			$("input:checkbox[name^='parakstit'][value='"+value+"']").prop('checked', true);
			//IEÍESKÇJAM ARÎ, KA NOSÛTÎTS
			$("input:checkbox[name^='nosutits'][value='"+value+"']").prop('checked', true);
			
		}else {
	
		var value=$(this).val();
			$("input:checkbox[name^='parakstit'][value='"+value+"']").prop('checked',false);

		}
	});


});
</script>

<script>
function beforeSubmit(){


 $(":checkbox[name^='parakstit']").each(function( index ) {
 // console.log( index + ": " + $( this ).val() );
   var ch=$(this).is(":checked");
   var id = $(this).attr("name");
  // console.log(id);
  // console.log(ch);
   if (ch){
	   $(":input:hidden[name="+id+"]").each(function( index ) {
			$(this).prop( "disabled", true );
	   });
   }
   else{
	 $(":checkbox[name="+id+"]").each(function( index ) {
			$(this).prop( "disabled", true );
	   });
   }
});
$(":checkbox[name^='nosutits']").each(function( index ) {
 // console.log( index + ": " + $( this ).val() );
   var ch=$(this).is(":checked");
   var id = $(this).attr("name");
  // console.log(id);
  // console.log(ch);
   if (ch){
	   $(":input:hidden[name="+id+"]").each(function( index ) {
			$(this).prop( "disabled", true );
	   });
   }
   else{
	 $(":checkbox[name="+id+"]").each(function( index ) {
			$(this).prop( "disabled", true );
	   });
   }
});
return true;

}
</script>