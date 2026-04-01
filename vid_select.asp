
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->


<script>
function handleError() {
	return true;
}
window.onerror = handleError;
</script>
<%

'atver konektu pie datubâzes
dim conn
openconn

dim dalibn_nos

psid = Request.QueryString("psid")
psid2 = Request.Form("psid2")
view = Request.QueryString("view")
did = Request.QueryString("did")
tempgid = Request.QueryString("gid")
qrs = qstring()
if Instr(1,qrs,"vid") > 0 then
 qrs = left(qrs,Instr(1,qrs,"vid"))
end if
vid = Request.Form("vid")

validToAdd = true

if vid = "" then vid = Request.QueryString("vid")

if psid <> 0 then
  set rTempPiet = conn.execute("select gid,id from pieteikums where id in (select pid from piet_saite where id = "+cstr(psid)+")")
  tempgid = rTempPiet("gid")
  pid = rTempPiet("id")
end if
set rGrupa = conn.execute("select id as gid,standarta_viesnicas,IsNull(viesnicas_slegtas,0) as vsl, kurators, beigu_dat from grupa where id=" & cstr(tempgid))
gid = rGrupa("gid")
standarta_viesnicas = rGrupa("standarta_viesnicas")

if did = "" and psid <> 0 then 
  set dalibn_id = conn.execute("select did,pid from piet_saite where id = "+cstr(psid))
  did = dalibn_id(0)
  pid = dalibn_id(1)
end if

set rDal = conn.execute("select tikai_single from dalibn where id = " + cstr(did))




'response.write(pid)
err = false
if Request.Form("subm")="insert" then
'Response.Write("> "+cstr(alertSingle(psid, gid, vid)) + "/ " + cstr(psid)+ "/ " + cstr(gid)+ "/ " + cstr(vid))
	if psid <> 0 then
		
		set old_saites_arr = GetPietSaitesDict(pid)	
		
		set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
	
	end if
  
	
  '--- TWIN+1/DOUBLE+1 nummuru paarbaude: vai viens no dalibniekiem ir jaunaaks par 16 (ieskaitot). Ja nav, tad neljauj pievienot 
	validToAdd = isValidToAdd(did,vid,rgrupa("beigu_dat"))
	
	if validToAdd = false then

		Response.Write("<div align=center>Kajîtç (TWIN+1/DOUBLE+1) vienam no dalîbniekiem ir jâbût ne vecâkam par 16 gadiem!</div>")

	elseif alertSingle(psid, gid, vid) = true then
		'noòemam single piemaksu:
		 conn.execute("UPDATE  piet_saite SET deleted=1 where deleted = 0 and pid = "+cstr(pid)+" and vietas_veids IN (select id from vietu_veidi where gid = "+cstr(gid)+" and tips = 'V1')")
		
		'Response.Write("<div align=center><font size=""4"" color=""red"">Pieteikumâ ir 'piemaksa par SINGLE numuru, tapçc citu numura veidu izvçlçties nav 'iespçjams.</font></div>")
	end if	

	'else
	if TikaiSingleBan(did,vid) then
		Response.Write("<script>alert('Atïauti tikai SINGLE')</script>")
		'err = true
	else
			'saglabâjam datubâzç
			conn.execute("update piet_saite set vid = "+ vid + " where id = "+cstr(psid))
	
			'LogAction "pieteikums",pid,"Nomainîts viesnîcas numurs"
			'saglabâ informâciju par piet_saiðu un pieteikuma izmaiòu saturu un autoru	
			if psid <> 0 then
				set new_saites_arr = GetPietSaitesDict(pid)	
				set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
				SavePietHistory old_saites_arr,new_saites_arr,pid,old_vals,new_vals
			end if
			'nolasam no datubâzes vid vçrtîbu
			set r = conn.execute("select isnull(nosaukums,'')+isnull(piezimes,'') as nosaukums from viesnicas_veidi where id in (select veids from viesnicas where id = "+vid+")")
  
			'aizveram logu
			%><body onload="
			opener.UpdateCheckPakalp('ievietots');
			opener.vid_psid_<%=psid%>.innerHTML = '<a target=vid_select href=vid_select.asp<%=qrs%>&vid=<%=vid%>><%=r("nosaukums")%></a>';
			opener.vid_div_<%=psid%>.innerHTML = '<input type=hidden name=vid_<%=psid%> value=<%=vid%>></input>';
			"><%
	end if
end if

if Request.Form("subm")="remove" then
	if psid <> 0 then
		set old_saites_arr = GetPietSaitesDict(pid)	
		set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
	end if
    conn.execute("update piet_saite set vid = NULL where id = "+cstr(psid))
	if psid <> 0 then
		set new_saites_arr = GetPietSaitesDict(pid)	
		set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
		SavePietHistory old_saites_arr,new_saites_arr,pid,old_vals,new_vals
	end if
    'aizveram logu
    %><body onload="
    opener.UpdateCheckPakalp('iznemts'); opener.vid_psid_<%=psid%>.innerHTML = '<a target=vid_select href=vid_select.asp<%=qrs%>>Izvçlieties</a>';
    opener.vid_div_<%=psid%>.innerHTML = '<input type=hidden name=vid_<%=psid%> value=0></input>';
    "<%
    vid = ""
end if

if Request.Form("subm")="removeother" then
	
	qry_o = "SELECT  * FROM pieteikums WHERE id in (select distinct pid from piet_saite where id="+ cstr(psid2)+")"
	
	set old_saites_arr = GetPietSaiteDict(psid2)	
	set old_vals = CreateDict(qry_o) 	
	
   conn.execute("update piet_saite set vid = NULL where id = "+cstr(psid2))
   
  ' LogAction "pieteikums",pid,"Nomainîts viesnîcas numurs" 
	'saglabâ informâciju par piet_saiðu un pieteikuma izmaiòu saturu un autoru	
	set new_saites_arr = GetPietSaiteDict(psid2)		
	set new_vals = CreateDict(qry_o) 	
	other_pid = conn.execute("SELECT id from pieteikums where id in (select pid from piet_saite where id="+cstr(psid2)+")")(0)

	SavePietHistory old_saites_arr,new_saites_arr,other_pid,old_vals,new_vals
	
end if

if Request.Form("subm") = "change" then
	if getnum(pid) <> 0 then
		set old_saites_arr = GetPietSaitesDict(pid)	
		set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
	end if
	veids_change = Request.Form("veids_change")
	if (psid <> 0 ) then
		ps_vid = conn.execute("select vid from piet_saite where id = "+cstr(psid))(0) 
	end if
	'Response.write "select vid from piet_saite where id = "+cstr(psid)

	if cstr(vid) = cstr(ps_vid) and alertSingle(psid, gid, veids_change) = true then
		'noòemam single piemaksu:
		 conn.execute("UPDATE  piet_saite SET deleted=1 where deleted = 0 and pid = "+cstr(pid)+" and vietas_veids IN (select id from vietu_veidi where gid = "+cstr(gid)+" and tips = 'V1')")
		'Response.Write("<div align=center><font size=""4"" color=""red"">Pieteikumâ ir 'piemaksa par SINGLE numuru, tapçc citu numura veidu izvçlçties nav '.</font></div>")
	end if
	'else
		conn.execute ("update viesnicas set veids = "+cstr(Request.Form("veids_change"))+" where id = " + cstr(vid))
	'end if
	if getnum(pid) <> 0 then
		'saglabâ informâciju par piet_saiðu un pieteikuma izmaiòu saturu un autoru	
		set new_saites_arr = GetPietSaitesDict(pid)	
		set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
	   SavePietHistory old_saites_arr,new_saites_arr,pid,old_vals,new_vals
	 end if
end if

if 1=1 then

  if Request.Form("subm")="new" and not err then
   conn.execute "insert into viesnicas (veids,vietas,gid) values ("+Request.Form("veids")+",0,"+cstr(gid)+")"
   '05.08.2019 RT  - logojam vesturi detalizetaku
	set rID = conn.execute("select max(id) from viesnicas where gid = " + cstr("gid"))
	LogInsertAction "viesnicas",rID(0)
  end if
  docstart "Viesnicas numura izvçle","y1.jpg" 

  %>

  <form name=forma method=POST>
  <font face=Tahoma>
  <center><font color="GREEN" size="5" face=Tahoma>Viesnîcas numura izvçle</font> 
  <br>
  <%
  
  	if rGrupa("vsl")=true then
		Response.Write("<div align='center'><font color=""red"">VIESNÎCAS SLÇGTAS</font></div>")
	end if 
  
  %>
  <a href=vid_select.asp<%=qstring()%>>[Brîvâs]</a>
  <a href=vid_select.asp<%=qstring()%>&view=full>[Visas]</a>
  <hr>

  <%

  'cikls pa visiem viesnicu numuriem sakârtotiem pçc ietilpîbas un tipa
  set r = conn.execute("select viesnicas.id as vid,veids,viesnicas_veidi.vietas,isnull(nosaukums,'')+isnull(piezimes,'') as nosaukums " + _
   " from viesnicas inner join viesnicas_veidi on viesnicas.veids = viesnicas_veidi.id " + _
   " where viesnicas.veids in (select id from viesnicas_veidi where gid = "+cstr(gid)+") " + _
   " order by viesnicas_veidi.vietas,isnull(nosaukums,'')+isnull(piezimes,'') ")
  %><table>
   <tr>
    <th>Numurs</th>
    <th>Persona</th>
   </tr><%
  'te uzkrâsim visus kajîðu tipu id kuras izdrukâtas tukðas
  'lai divas reizes nerukâtu viena tipa tukðas kajîtes
  tukss = "|" 
  while not r.eof
   set rSaite = server.CreateObject("ADODB.Recordset")
   rSaite.Open "select dalibn.id AS did,vards,uzvards,dalibn.nosaukums as nos,piet_saite.id as psid, vid, vietas_veids, pk1 from piet_saite inner join dalibn on piet_saite.did = dalibn.id inner join pieteikums p on piet_saite.pid = p.id where p.deleted = 0 and (p.tmp = 0 or p.tmp = 1 and isnull(p.internets, 0 )= 0) and piet_saite.deleted = 0 and p.gid = "+CStr(gid)+" and vid = " + cstr(r("vid")),conn,3,3
  ' rw	"select dalibn.id AS did,vards,uzvards,dalibn.nosaukums as nos,piet_saite.id as psid, vid, vietas_veids, pk1 from piet_saite inner join dalibn on piet_saite.did = dalibn.id inner join pieteikums p on piet_saite.pid = p.id where p.deleted = 0 and (p.tmp = 0 or p.tmp = 1 and isnull(p.internets, 0 )= 0) and piet_saite.deleted = 0 and p.gid = "+CStr(gid)+" and vid = " + cstr(r("vid"))+"<br>"
   'rw "select vards,uzvards,dalibn.nosaukums as nos,piet_saite.id as psid, vid, vietas_veids from piet_saite inner join dalibn on piet_saite.did = dalibn.id inner join pieteikums p on piet_saite.pid = p.id where p.deleted = 0 and (p.tmp = 0 or p.tmp = 1 and isnull(p.internets, 0 )= 0) and piet_saite.deleted = 0 and vid = " + cstr(r("vid"))
   rSaite_RecordCount = rsaite.RecordCount
   
   'pârbaudam vai ðajâ numurâ nedzîvo izvçlçtâ persona
   dzivo = false
   if not rsaite.EOF then
    while not rSaite.EOF
     'Response.Write vid & "," & rSaite("vid") & "<br>"
     if (cstr(rsaite("psid")) = cstr(psid)) or (cstr(rsaite("vid")) = vid) then
      dzivo = true
     end if
     rsaite.MoveNext
    wend
    rsaite.MoveFirst
   end if
   if psid = 0 and vid = r("vid") then dzivo = true
   
   'pârbaudam vai tukða kajite neatkartojas
   tukss_atkartojas = false
   if rSaite_RecordCount = 0 and instr(tukss,"|"+cstr(r("veids"))+"|")<>0 then
    tukss_atkartojas = true
   end if

   'if (rSaite_RecordCount < r("vietas") or view = "full" or dzivo) and not tukss_atkartojas then
   if (rSaite_RecordCount < r("vietas") or view = "full" or dzivo) or true then
   'atlasam tipus uz kuriem ðo kajîti var nomainît
   if dzivo then color = "#ffc1cc" else color = "#fff1cc" 
   %>
   
   <tr bgcolor=<%=color%>>
   <td  valign=top>
   <% 
	'--- pçc Artas pieprasijuma. istabu mainjas izvelne aktivizeeta visaam grupaam, ne tikai grupaam ar standarta viesniicaam. 26.feb 2014 Nils
	
	if (not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN)) Then 
    'if standarta_viesnicas = true and (not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN)) then

    set rTipi = conn.execute("select * from viesnicas_veidi where gid = "+cstr(gid)+" and vietas>= "+cstr(rSaite_RecordCount))
    %>
    <select name=tips<%=r("vid")%> onchange="forma.subm.value='change';forma.vid.value=<%=r("vid")%>;forma.veids_change.value=forma.tips<%=r("vid")%>.value;forma.submit();return false;">
     <% while not rTipi.eof%>
      <option value=<%=rTipi("id")%>
      <% if r("veids")=rTipi("id") then Response.Write " selected " %>
      >
      <%=rTipi("nosaukums")%>&nbsp;<%=rTipi("pilns_nosaukums")%>&nbsp;<%=rTipi("piezimes")%>
      </option>
      <% rtipi.movenext %>
     <% wend %>
    </select>
   <% else %>
    <%=conn.execute("select isnull(nosaukums,'')+isnull(piezimes,'') as nosaukums from viesnicas_veidi where id = "+cstr(r("veids")))(0)%>
   <% end if %>
   </td>
   <%
   'cikls pa visiem cilvçkiem kas ir ðajâ viesnicas numurâ
   %><td><%
   while not rSaite.eof
    if rSaite("vietas_veids") <> 0 then
		   set rVieta = conn.execute("select nosaukums from vietu_veidi where tips = 'A' and id = " & rSaite("vietas_veids"))
		  else
 		  set rVieta = conn.execute("select nosaukums from vietu_veidi where 1=2")
		  end if
		  
	if nullprint(rSaite("vards"))="" and nullprint(rSaite("uzvards"))="" then
		dalibn_nos = nullprint(rSaite("nos"))
	else
		dalibn_nos = nullprint(rSaite("vards")) + " " + nullprint(rSaite("uzvards")) + " " + nullprint(vecums_new(rSaite("did"),rgrupa("beigu_dat")))
     end if
     
    if cstr(rSaite("psid")) = cstr(psid) then 
     %><B><font color=#880000><%
     
     if rVieta.eof then 
       response.write dalibn_nos
     else 
       Response.Write "aizòemts"
     end if
     %></font></B> <a href="Izòemt" onclick="forma.subm.value='remove';forma.vid.value='<%=r("vid")%>';forma.submit();return false;">[Izòemt]</a><%
    else
     %><a href=vid_select.asp<%=qstring()%>><font color=black><%
     if rVieta.eof then 
       response.write dalibn_nos
     else 
       Response.Write "aizòemts"
     end if
     %></font></a><a href="Izòemt" onclick="if (confirm('Izòemt cilvçku <%rw dalibn_nos%> no numura?')) {forma.subm.value='removeother';}forma.vid.value='<%=r("vid")%>';forma.psid2.value='<%=rSaite("psid")%>';forma.submit();return false;">[Izòemt]</a><%
    end if
    Response.Write "<BR>"
    rSaite.movenext
   wend
   
   if rSaite_RecordCount < r("vietas") then
	
    if cstr(psid) = "0" and cstr(vid) = cstr(r("vid")) then

     set rDalibn = server.CreateObject("ADODB.Recordset")
     rDalibn.Open "select vards,uzvards,nosaukums as nos from dalibn where id = " + cstr(did),conn,3,3 %>
     <B><font color=#880000><%
     
     if nullprint(rDalibn("vards"))="" and nullprint(rDalibn("uzvards"))="" then
		dalibn_nos = nullprint(rDalibn("nos"))
	else
		dalibn_nos = nullprint(rDalibn("vards")) + " " + nullprint(rDalibn("uzvards"))
     end if
     
		if Request.Form("subm")="insert" then
		
			if validToAdd = true then
				response.write dalibn_nos
			end if
		
		else
			response.write dalibn_nos
		end if     %>
		</font></B> <a href="Izòemt" onclick="forma.subm.value='remove';forma.vid.value='<%=r("vid")%>';forma.submit();return false;">[Izòemt]</a><%
    else
     %><a href="Ievietot" onclick="forma.subm.value='insert';forma.vid.value='<%=r("vid")%>';forma.submit();return false;">Ievietot</a><%
    end if
   end if
   %></td><%
   end if

   'vai kajîte tukða
   if rSaite_RecordCount = 0 then
    tukss = tukss + cstr(r("veids")) + "|"
   end if

   'ja cilvçku mazâk nekâ vietu atstâjam brîvas vietas kur ievietot jaunu cilvçku
    r.movenext
  wend
  'Response.End
  
  'saglabâðanas poga
  
  'pârbaudam vai grupai var pievienot jaunus numurus
  'ja var tad izdrukâjam linkus ar visiem viesnicu tipiem jaunu numuru pievienoðanai

end if 'if subm=1
%></table><%
'--- pçc Artas pieprasijuma. istabu mainjas izvelne aktivizeeta visaam grupaam, ne tikai grupaam ar standarta viesniicaam. 26.feb 2014 Nils
if (not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN)) then
'if standarta_viesnicas = true and (not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN)) then
 set rTipi = conn.execute("select * from viesnicas_veidi where gid = "+cstr(gid)+" order by vietas")
 %><select name=veids><% 
 while not rTipi.eof
  %><option <%if rTipi("nosaukums")="TWIN" then Response.Write " selected "%> value=<%=rTipi("id")%>><%=rTipi("nosaukums")+nullprint(rTipi("piezimes"))%></option><%
  rTipi.movenext
 wend
 %>
 </select>
<input type=submit value="Pievienot numuru" name="POGA" onclick="subm.value='new'">
<% end if%>

<input type=hidden name=subm>
<input type=hidden name=vid>
<input type=hidden name=psid2>
<input type=hidden name=veids_change>
</form>  

<%

Function alertSingle(psid, gid, vid)
'--- funkcija parbauda vai pieteikumaa ir saite par Single piemaksu
	'Response.write psid&", "&gid&", "&vid&"<br>"
	res = false
	set piet = conn.execute("select pid from piet_saite where deleted = 0 and id = " + cstr(psid) )
	
	'Response.write "select pid from piet_saite where deleted = 0 and id = " + cstr(psid)+"<br>"
	
	if not piet.eof then
	
	'--- parbauda vai izveeleetais nummurs ir single
	set vveids = conn.execute("select vietas from viesnicas_veidi where id in (select veids from viesnicas where id = "+cstr(vid)+")")
	
	'Response.write "select vietas from viesnicas_veidi where id in (select veids from viesnicas where id = "+cstr(vid)+")"
	If Not vveids.eof then	
		if cint(vveids(0))<>1 then 'ja nav single
		
			set sngl = conn.execute("select count(*) from piet_saite where deleted = 0 and pid = "+cstr(piet("pid"))+" and vietas_veids IN (select id from vietu_veidi where gid = "+cstr(gid)+" and tips = 'V1')")
		
			if not sngl.eof then 
		
				if sngl(0) > 0 then
					res = true		
				end if
				
			end if
		
		end If
	End if		
	
	end if
	
	
	alertSingle = res
	
end function

Function TikaiSingleBan(did,vid) 
	TikaiSingleBan = false
	sql = "SELECT isnull(tikai_single,0) as s FROM dalibn WHERE id = " & did
	set r = conn.execute(sql)
	if r("s") = 0 then 
		TikaiSingleBan = false
		exit function
	end if


	sql = "SELECT vv.nosaukums FROM viesnicas v " & _
      "INNER JOIN viesnicas_veidi vv ON v.veids = vv.id " & _
      "WHERE v.id = " & vid

	set r = conn.execute(sql)
	if r("nosaukums") <> "SINGLE" then
		TikaiSingleBan = True
		exit function
	end if
	
end function

Function isValidToAdd(did,vid,beigu_dat)
'--- TWIN+1/DOUBLE+1 nummuru paarbaude, vai viens no dalibniekiem ir jaunaaks par 'parbaudesVecums' (nosaka peec personas koda)
'--- Atgriez -> True, ja jau ir, un False, ja nav taada dalibnieka shinii nummuraa.
	
	parbaudesVecums = 16
	res = false
	
	'paarbauda veidu, vai tas ir '+1' viesnicas nummurs
	'set r = conn.execute("select nosaukums from viesnicas_veidi where gid = " + cstr(gid) + ") and (nosaukums = 'TWIN+1' OR nosaukums = 'DOUBLE+1')")
	set r = conn.execute("select nosaukums from viesnicas_veidi where id in (select veids from viesnicas where id = " + cstr(vid) + ") and (nosaukums = 'TWIN+1' OR nosaukums = 'DOUBLE+1')")
	
	'Pârbaudi veic, kad nummurâ jau ir 2 dalibnieki un tiek likts treðais. 
	dalibnCount = conn.execute("select count(did) from piet_saite where deleted=0 and vid = " + cstr(vid))

	
	if (not r.eof) and (dalibnCount(0) = 2) then 
		
		'paarbauda vai kads no jau ievietotajiem nummuraa dalibniekiem nav vecaks par parbaudesVecums
		set dalibnieki = conn.execute("select did from piet_saite where deleted=0 and vid = " + cstr(vid))

		
		Do Until dalibnieki.eof

			set pk = conn.execute("select pk1 from dalibn where id=" + cstr(dalibnieki(0)))	
			if vecums(pk(0),beigu_dat)>parbaudesVecums	Then 
				res = true
				Exit Do
			end if
			dalibnieki.movenext
		Loop
		
		'paarbauda vai dalibnieks, kuru liek nummurâ, nav vecaks par parbaudesVecums
		set pk = conn.execute("select ID from dalibn where id=" + cstr(did))	
		
		if vecums_new(pk(0),beigu_dat)<=parbaudesVecums	Then 
				res = true
		end if
	else
		'rezultats true, jo tie nav +1 nummuri 
		'vai arî kajîte vel nav pilna un to var nepârbaudît
		
		res =true
		
	end if

	
	isValidToAdd = res
	

end function




function vecums_old(p_kods,beigu_dat)

			if len(p_kods)=6 then
				
				dz_gads = right(p_kods,2)
				
				if cint(dz_gads) < int(right(Year(Date),2)) then
					dz_gads = "20" + dz_gads
				else
					dz_gads = "19" + dz_gads
				end if
			
				dz_menesis = cint(mid(p_kods,3,2))
				dz_diena = cint(mid(p_kods,1,2))
				
				dz_datums = dateserial(dz_gads,dz_menesis,dz_diena)
				
				''vecums = Year(Date) - dz_gads
				''vecums = Year(Date) - year(dz_datums)
				vecums = MyDateDiff("yyyy",dz_datums,beigu_dat)
				''vecums = MyDateDiff("yyyy",dateserial(1999,12,31),dateserial(2000,1,1))
				''vecums = dateprint(dz_datums)
			else
				
				vecums = ""
				
			end if

end function

Function MyDateDiff_old(difftype , date1 , date2 ) 
    Dim EarlyDate, LateDate 
    Dim tempDate 
    If date1 <= date2 Then 
        EarlyDate = date1 
        LateDate = date2 
    Else 
        EarlyDate = date2 
        LateDate = date1 
    End If 
     
    tempDate = EarlyDate 
    i = 0 
    Do While tempDate <= LateDate 
        i = i + 1 
        tempDate = DateAdd(difftype, i, EarlyDate) 
    Loop 
    MyDateDiff = i - 1 
End Function 

%>