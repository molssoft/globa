<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%
message= ""
if Request.QueryString("nomainit_pid")<>"" then
 session("nomainit_pid") = Request.QueryString("nomainit_pid")
end if

'--- carter rezervacijas mainigie
Response.write  Request.QueryString("rez_id")
if Request.QueryString("rez_id")<>"" then
	if Request.QueryString("rez_id")<>"-1" then
		session("carter_rez_id") = Request.QueryString("rez_id")
		session("carter_p_id") = Request.QueryString("p_id")
		session("carter_g_id") = Request.QueryString("g_id")
	else
		Session.Contents.Remove("carter_rez_id")
		Session.Contents.Remove("carter_p_id")
		Session.Contents.Remove("carter_g_id")
	end if
end if
'-----------------------------------------------------------

if Request.QueryString("return")="1" then session("return") = "1"

If request.querystring("i") = "" Then 
 id = -1 
Else 
 id = request.querystring("i")
end if



dim conn
OpenConn

'--- pârbauda vai ir zinâms kurâ ofisâ atrodas lietotâjs

dfields = "vards uzvards pases pasenr pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons novads ids idnr idderdat "+_
	"dzimsanas_datums"

dtypes = "text text text text text text text text text text text text text text text text text text text text text text num num text text text"

dforms = "vards uzvards pases pasenr pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons novads id_s id_nr id_derdat dzimsanas_datums"

poga_var = Request.form("poga")	
'if Request.form("jaunumi") = "on" then jaunumi = "1" else jaunumi = "0"
'if not CheckEmail(Request.form("eadr")) and jaunumi = "1" then
 'jaunumi = "0"
 'message = "<font color=red>Emails ir kïûdains.</font>"
'end if

'--- Labot esoðo --------------------------
if request.form("labot.x") <> "" then
'response.write("select * from dalibn where ID = " + CStr(id))
	set pk_query = conn.execute("select * from dalibn where ID =  " + CStr(id))
	if not pk_query.eof then
		pk1 = pk_query("pk1")
		pk2 = pk_query("pk2")
	end if
	id_query = "select * from dalibn where id = " + CStr(id)
	EditRecord conn,id_query,dfields,dforms
	'pârbauda, vai dalîbniekas eksistç arî profils, ja eksistç, atjauno pk , lai nepazûd sasaiste
	'response.write(pk1)
	'response.write("-")
		'response.write(pk2)
		
	If Request.form("pk1") <> "" And Request.form("pk2") <> ""  then
		Set profils = conn.execute("select id from profili where pk1 = '"+pk1+"' and pk2 = '"+pk2+"'")
		If Not profils.eof Then
			conn.execute("UPDATE profili SET pk1= '"+Request.form("pk1")+"', pk2 = '"+Request.form("pk2")+"' WHERE id="+cstr(profils("id"))+"")
			'response.end
		End if
	End If
	dzimsanas_datums_var = request.form("dzimsanas_datums")
	if (dzimsanas_datums_var = "") then
	
		pk1_var = Request.form("pk1")
		if pk1_var <> "" then
			
			' Drukaa dzimsanas datumu peec personas koda pirmaas daljas
				if len(pk1_var) = 6 then
					dim diena,men,gads
					diena = (mid(pk1_var,1,2)+".")
					
					men =  (mid(pk1_var,3,2)+".")
					gads = (ASC(mid(pk1_var,5,1)) - ASC("0"))*10+(ASC(mid(pk1_var,6,1))-ASC("0"))+1900
					if gads+99 < year(now) then gads = gads + 100
					if (diena>0 and diena<=31 and men>0 and men<=12 and gads<=year(Now())) then
						dzimsanas_datums_var = diena + men + (cstr(gads))
						
						conn.execute("UPDATE dalibn SET dzimsanas_datums= '"+dzimsanas_datums_var+"' WHERE id="+cstr(id)+"")
					end if
				end if
		end if
	end if
	'ja nav izdevies izkalkulçt dzimðanas datumu no pk
	if (dzimsanas_datums_var = "") then
		session("dmessage") = "<br><font color = red>Nav norâdîts dzimðanas datums.</font>"
	end if

	'parakstîðanâs uz jaunumiem
	'conn.execute "update dalibn set jaunumi = " + jaunumi + " where id = " + cstr(id)
	
	'rw jaunumi
	'if jaunumi = "1" then

	 'vai ir jau piereìistrçts
	 'set rE = conn.execute ("select * from email_list where did = "+cstr(id))
	 'if rE.EOF then
	  'varbût ðâds emails jau ir
	  'set rE = conn.execute ("select * from email_list where UPPER(email) = '"+ucase(Request.Form("eadr"))+"' and did is null")
	  'if not rE.eof then
	  ' conn.execute "UPDATE email_list set did = "+cstr(id)+" where UPPER(email) = '"+ucase(Request.Form("eadr"))+"'"
	  'else
	  ' randomize(minute(now)+second(now)+hour(now))
  	  ' kods = round(rnd(0)*10000)
	  ' conn.execute "INSERT INTO email_list (email,datums_izv,status,did,kods) VALUES ('"+Request.Form("eadr")+"','"+sqldate(now)+"','N',"+cstr(id)+","+cstr(kods)+")"
	  ' send_confirm = true
	  'end if
	 'end if
	'else 
	 'conn.execute "delete from email_list where did = " + cstr(id)
	'end if
	
	if send_confirm then
     response.redirect "dalibn_confirm_add.asp?id=" + cstr(id)
	end if
	session("dmessage") = session("dmessage") + message+"<br>Labojumi izdarîti veiksmîgi!"
	id = session("editid")	
end if



'@ 0 Sâkt jaunu --------------------------
if request.form("saktjaunu.x") <>"" then
	vards_var = ""
	uzvards_var = ""
	uzvards1_var = ""
	dzimta = "x"
	paseS_var = ""
	paseNr_var = ""
	paseIZD_var = ""
	paseIZDdat_var = ""
	pasederdat_var = ""
	pk1_var = ""
	pk2_var = ""
	adrese_var = ""
	pilseta_var = ""
	indekss_var = ""
	talrunisM_var = ""
	talrunisD_var = ""
	talrunisMob_var = ""
	Fax_var = ""
	eadr_var = ""
	piezimes_var = ""
	nosaukums_var = ""
	reg_var = ""
	nmkods_var = ""
	vaditajs_var = ""
	kontaktieris_var = ""
	'jaunumi="0"
	id_S_var = ""
	id_NR_var = ""
	id_derdat_var = ""
	dzimsanas_datums_var = ""
	
	
end if

if request.form("saktjaunu2.x") <>"" then
	vards_var = ""
	uzvards_var = ""
	uzvards1_var = ""
	dzimta = "x"
	paseS_var = ""
	paseNr_var = ""
	paseIZD_var = ""
	paseIZDdat_var = ""
	pasederdat_var = ""
	pk1_var = ""
	pk2_var = ""
	adrese_var = ucase(request.form("adrese"))
	pilseta_var = ucase(request.form("pilseta"))
	indekss_var = request.form("indekss")
	talrunisM_var = request.form("talrunisM")
	talrunisD_var = ""
	talrunisMob_var = ""
	fax_var = request.form("fax")
	eadr_var = request.form("eadr")
	piezimes_var = ""
	nosaukums_var = ""
	reg_var = ""
	nmkods_var = ""
	vaditajs_var = ""
	kontaktieris_var = ""
	rajons_var = request.form("rajons")
	novads_var = request.form("novads")
	'jaunumi="0"
	id_S_var = ""
	id_NR_var = ""
	id_derdat_var = ""
	dzimsanas_datums_var = ""
	
end if

'--- Meklçt esoðu ---------------------------
if request.form("meklet.x") <> "" then
  query = "Select vards, uzvards, nosaukums, pk1+'-'+pk2, pilseta, adrese, id , piezimes from dalibn "
  wh =  WhereClause(dfields,dtypes,dforms)
  if wh<>"" then 
    query = query + " where (not deleted = 1) and " + wh
  else
    query = query + " where (not deleted = 1)"
  end if
  'if jaunumi = "1" then query = query + " and jaunumi = 1 "
  set rSk = server.createobject("ADODB.Recordset")
  rSk.open query,conn,3,3
  ''Response.Write(query)
  skaits = rSk.recordcount
  rSk.close

  '--- Ja nav neviens -----------------------------
  if skaits = 0 then  
	Message = "Nav atrasts neviens dalîbnieks!"
	vards_var = request.form("vards")
	uzvards_var = request.form("uzvards")
	uzvards1_var = request.form("uzvards1")
	dzimta_var = request.form("dzimta")
	paseS_var = ucase(request.form("paseS"))
	paseNr_var = request.form("paseNr")
	paseIZD_var = request.form("paseIZD")
	paseIZDdat_var = request.form("paseIZDdat")
	pasederdat_var = request.form("pasederdat")
	pk1_var = request.form("pk1")
	pk2_var = request.form("pk2")
	adrese_var = ucase(request.form("adrese"))
	pilseta_var = ucase(request.form("pilseta"))
	indekss_var = request.form("indekss")
	talrunisM_var = request.form("talrunisM")
	talrunisD_var = request.form("talrunisD")
	talrunisMob_var = request.form("talrunisMob")
	fax_var = request.form("fax")
	eadr_var = request.form("eadr")
	piezimes_var = request.form("piezimes")
	nosaukums_var = request.form("nosaukums")
	reg_var = request.form("reg")
	nmkods_var = request.form("nmkods")
	vaditajs_var = request.form("vaditajs")
	kontaktieris_var = request.form("kontaktieris")
	rajons_var = request.form("rajons")
	novads_var = request.form("novads")
	
	
	id_S_var = ucase(request.form("id_S"))
	id_NR_var = request.form("id_NR")
	id_derdat_var = request.form("id_derdat_var")
	
	
	
  end if
  '--- Ja viens ---------------------------------
  if skaits = 1 then 
    message = "Atrasts 1 dalîbnieks!"
    set recordset = conn.execute(query)
    id = recordset("id")
  end if

  '--- Saraksts ---------------------------
  if skaits>=2 then
	session("dquery") = query
        session("dalibn_sar_mode") = "show"
	response.redirect "dalibn_sar.asp"
	if skaits-int(skaits/10)*10 = 1 then
		Message = "Atrasts "+CStr(skaits)+" dalîbnieks"
	else
		Message = "Atrasti "+CStr(skaits)+" dalîbnieki"
	end if
  end if
end if


'@ 0 Nolasa tekoðo dalîbnieku --------------------------
if id<>"-1" then
 if session("nomainit_pid")<>"" then
  Response.Redirect "nomainit_pid.asp?did="+cstr(id)
 end if
	'AddDalHistory(id) 'patreiz netiek lietots
	set recordset = server.createobject("ADODB.Recordset")
	recordset.open "select * from dalibn where  id = " + CStr(id),conn,3,3
	recordset.movefirst 
	vards_var = recordset("vards")
	uzvards_var = recordset("uzvards")
	dzimta = recordset("dzimta")
	if recordset("paseNr") <> "" then
		paseS_var = ucase(recordset("paseS"))
		paseNr_var = recordset("paseNr")
		
		'response.write(recordset("pasederdat"))
		
		pasederdat_var = dateprint(recordset("pasederdat"))

	end if
	
	pk1_var = recordset("pk1")
	pk2_var = recordset("pk2")
	adrese_var = ucase(recordset("adrese"))
	pilseta_var = ucase(recordset("pilseta"))
	indekss_var = recordset("indekss")
	talrunisM_var = recordset("talrunisM")
	talrunisD_var = recordset("talrunisD")
	talrunisMob_var = recordset("talrunisMob")
	Fax_var = recordset("fax")
	eadr_var = recordset("eadr")
	piezimes_var = recordset("piezimes")
	nosaukums_var = ucase(recordset("nosaukums"))
	reg_var = recordset("reg")
	nmkods_var = recordset("nmkods")
	vaditajs_var = recordset("vaditajs")
	kontaktieris_var = recordset("kontaktieris")
	rajons_var = recordset("rajons")
	novads_var = recordset("novads")
	
	if recordset("idNr") <> "" then
		id_S_var = ucase(recordset("idS"))
		id_NR_var = recordset("idNr")
		id_derdat_var = dateprint(recordset("idDerDat"))
	end if
	
	dzimsanas_datums_var = dateprint(recordset("dzimsanas_datums"))
	'if recordset("jaunumi") then jaunumi="1" else jaunumi="0"
	if recordset("deleted") = 1 then
	 message = "<font color = red>Dalîbnieks ir dzçsts.</font>"
 end if	
end if

%>

<% 
'@ 0 HTML Start --------------------------
docstart "Dalibnieki","y1.jpg" %>

<script language="javascript" type"text/javascript">
	function toUp(pform){ //vards, uzvards to UPPERCASE
		
		vFname = pform.vards.value;
		pform.vards.value = vFname.toUpperCase();
		
		vSname = pform.uzvards.value;
		pform.uzvards.value = vSname.toUpperCase();
		
		return true;
	}

</script>

<center><font color="GREEN" size="5"><b>Dalîbnieki
<% IF ID <> -1 THEN %>
 Nr.<%=ID%>
<% END IF %>
</b></font>

<% '--- poga dalîbnieka pievienoðanai èartera rezervâcijai ---
if id<>"-1" and session("carter_rez_id")<>"" then

	'--- parbauda vai dalibnieks ir ziidainis
	dim zidainis
	zidainis = 0
	if session("carter_g_id")<>"" then
		if not ch_vecaksPar(2, pk1_var, session("carter_g_id")) then zidainis = 1
	end if

%>
<br />
<form name="f_add_to_carter" method="POST" action="pieteikums.asp?pid=<%=session("carter_p_id")%>">
	<input type="hidden" name="carter_did" value="<%=id%>" />
	<input type="hidden" name="carter_zidainis" value="<%=zidainis%>" />
	<input type="hidden" name="carter_rez_id" value="<%=session("carter_rez_id")%>" />
	<input type="submit" name="submit_carter" value="Pievienot dalîbnieku èartera rezervâcijai Nr. <%=session("carter_rez_id")%>" />
	<input type="button" name="del_carter_rez_id" value="Atcelt" onclick="javascript:window.location.assign('dalibn.asp?i=<%=id%>&rez_id=-1');" />
</form>
<%end if '-------------------------------------------------- %>

<hr>
<% headlinks %>

<% 
if session("dmessage")<>"" then 
	message = session("dmessage") + message
	session("dmessage") = ""
end if
session("message") = ""
if message <> "" then %>
<center><font color="GREEN" size="4"><%=Message%></font>
<% end if 
DefJavaSubmit
%>
<center>
<table border=0>
<tr><td valign=top>
<table border=0>
<!-- @ 0 Forma -------------------------->
<form name="forma" action="dalibn.asp" method="POST" onsubmit="return toUp(this)">
<!-- @ 1 Juridiskâ un personîgâ -------------------------->
<input type=hidden name=subm value=1>
<tr><td colspan = "4" align="center"><strong><font color="GREEN">Fiziskas personas dati:</font></strong></td>
<tr   bgcolor=NavajoWhite>
<td align="right">Vârds:</td><td><input type="text" size="25" maxlength="128" name="vards" value="<%=vards_var%>" style="text-transform: uppercase" <%if isDalibnInBlockedGroup(id) then %> onchange="alert('Dalîbnieka Vârdu/Uzvârdu nevar mainît, jo dalîbnieks atrodas bloíçtâ grupâ. Lûdzu griezties pie kuratora.'); forma.vards.value='<%=vards_var%>';"<%end if%>></td>
<td align="right">Uzvârds:</td><td> <input type="text" size="25" maxlength="128" name="uzvards" value="<%=uzvards_var%>" style="text-transform: uppercase" <%if isDalibnInBlockedGroup(id) then %> onchange="alert('Dalîbnieka Vârdu/Uzvârdu nevar mainît, jo dalîbnieks atrodas bloíçtâ grupâ. Lûdzu griesties pie kuratora.'); forma.uzvards.value='<%=uzvards_var%>';"<%end if%>></td>
</tr>
<tr  bgcolor=NavajoWhite>
	<td align="right">Pers. kods:</td>
	<td> <input type="text" size="6" maxlength="6" name="pk1"  value="<%=pk1_var%>"> - <input type="text" size="5" maxlength="5" name="pk2"  value="<%=pk2_var%>"></td>
	<td align="right">Dzimums:</td>
	<td> 	
		<select name = "dzimta" >
			<option value = "" <% if dzimta = "" then response.write "selected"%> >---</option>
			<option value = "v" <% if dzimta = "v" then response.write "selected"%> >vîrietis</option>
			<option value = "s" <% if dzimta = "s" then response.write "selected"%> >sieviete</option>
		</select>
	 </td>
</tr>
<tr  bgcolor=NavajoWhite>
	<td align="right">Dzimðanas datums</td>
	<td>	<input type="text" size="10" maxlength="10" name="dzimsanas_datums"  value="<%=dzimsanas_datums_var%>">
		<font size="2">dd.mm.yyyy</font>
	</td>
</tr>
<tr bgcolor=NavajoWhite>
	<td align="right">Pase:</td>
	<td>
		<input type="text" size="2" maxlength="2" name="paseS"  value="<%=paseS_var%>">
		<input type="text" size="7" maxlength="7" name="paseNR"  value="<%=paseNR_var%>"> 
	</td>
	<td align="right">ID karte:</td>
	<td>
		<input type="text" size="2" maxlength="2" name="id_S"  value="<%=id_S_var%>">
		<input type="text" size="7" maxlength="7" name="id_NR"  value="<%=id_NR_var%>"> 
	</td>
  
</tr>
<tr  bgcolor=NavajoWhite>
	
	<td align="right">Pase derîga lîdz:</td>
	<td>
		<input type="text" size="10" maxlength="10" name="pasederdat"  value="<%=pasederdat_var%>">
		<font size="2">dd.mm.yyyy</font>
	</td>
	<td align="right">ID derîga lîdz:</td>
	<td>
		<input type="text" size="10" maxlength="10" name="id_derdat"  value="<%=id_derdat_var%>">
		<font size="2">dd.mm.yyyy</font>
	</td>

</tr>
</table>
<table width = 100%>

</table>
</td><td>
<table>
<tr>
<td colspan = "2" align="center"><strong><font color=green>Juridiskas personas dati:</strong></td>
</tr>
<tr  bgcolor=NavajoWhite>
<td  align="right">Nosaukums: </td><td><input type="text" size="20" maxlength="100" name="nosaukums"  value="<%=nosaukums_var%>" style="text-transform: uppercase" <%if isDalibnInBlockedGroup(id) then %> onchange="alert('Dalîbnieka Nosaukumu nevar mainît, jo dalîbnieks atrodas bloíçtâ grupâ. Lûdzu griesties pie kuratora.'); forma.nosaukums.value='<%=nosaukums_var%>';"<%end if%>></td>
</tr>
<tr bgcolor=NavajoWhite>
<td align="right">Reì. Nr.: </td><td><input type="text" size="15" maxlength="20" name="reg" value="<%=reg_var%>"> </tr>
</tr>
<tr bgcolor=NavajoWhite>
<td align="right">Nod. maks. kods: </td><td><input type="text" size="15" maxlength="20" name="nmkods" value="<%=nmkods_var%>"> </tr>
</tr>
<tr bgcolor=NavajoWhite>
<td align="right">Vadîtâjs: </td><td><input type="text" size="15" maxlength="30" name="vaditajs"  value="<%=vaditajs_var%>"> </tr>
</tr>
<tr bgcolor=NavajoWhite>
     <td align="right">Kontaktp:</td><td> <input type="text" size="15" maxlength="30" name="kontaktieris" value="<%=kontaktieris_var%>"></td></tr>
</tr>
</table>
</table>

<!-- @ 1 Kopçjâ -------------------------->
<table>
<tr><td>
<table border = 0>
<tr>
<td  colspan=6><center><b><font color=green>Kopçjie dati:</td>
</tr>
<tr bgcolor=NavajoWhite>
<td align="right">Adrese:</td><td> <input type="text" size="40" maxlength="60" name="adrese"  value="<%=replace(nullprint(adrese_var),"""","&quot;")%>"></td>
<td align="right">Pilsçta/Pagasts:</td><td><input type="text" size="30" maxlength="30" name="pilseta" value="<%=replace(nullprint(pilseta_var),"""","&quot;")%>"></td>
<td align="right">Indekss: LV - </td><td><input type="text" size="14" maxlength="4" name="indekss" value="<%=indekss_var%>"> </td>

</tr>

</tr>
	<tr bgcolor=NavajoWhite>
	<td>Novads: </td><td colspan="3"><% dbcomboplus "novads","nosaukums","id","novads",novads_var %></td>
	<td colspan="2"></td>
</tr>

<tr bgcolor=NavajoWhite>
<td align="right">Mâjas t.: </td><td><input type="text" size="14" maxlength="15" name="talrunisM" value="<%=talrunisM_var%>"></td>
<td align="right"> Darba t.: </td><td><input type="text" size="14" maxlength="15" name="talrunisD" value="<%=talrunisD_var%>"></td>
<td align="right"> Mobîlais t.: </td><td><input type="text" size="14" maxlength="15" name="talrunisMob" value="<%=talrunisMob_var%>"></td>
</tr>
<tr bgcolor=NavajoWhite>
<td>Rajons: </td><td><% dbcomboplus "rajons","nosaukums","id","rajons",rajons_var %></td>
<td align="right"> e-adrese: </td><td><input type="text" size="30" maxlength="60" name="eadr"  value="<%=eadr_var%>"> </td>
<td align="right"> Fakss.: </td><td><input type="text" size="14" maxlength="15" name="fax" value="<%=Fax_var%>"></td>
</tr><tr  bgcolor=NavajoWhite>
<td>Piezîmes: </td><td  colspan=3><input type="text" size = "88"  name="piezimes"  value="<%=piezimes_var%>"></td>
<td colspan="2">&nbsp;</td>

</tr>
</table>
</td><td align=center>
<!-- @ 1 Pogas -------------------------->
<input type="image" name="meklet" alt="Atrod dalîbnieku(s) pçc formâ norâdîtajiem datiem. Mekleðana notiek arî pçc daïçji aizpildîta(iem) lauka(iem)." src="impro/bildes/meklet.jpg" onclick="forma.action='dalibn.asp'"><br><br>
<input type="image" alt="No ekranâ redzamâs formas notîra visus datus - sagatavo formu jaunu datu ievadei. Atbilstoðais ieraksts datu bâzç netiek izdzçsts." src="impro/bildes/saktjaunu.jpg" name="saktjaunu" onclick="forma.action='dalibn.asp';">
<input type="image" alt="No ekranâ redzamâs formas notîra visus datus izòemot adresi." src="impro/bildes/saktjaunu2.bmp" name="saktjaunu2" onclick="forma.action='dalibn.asp';">
<input type="image" alt="Uz ekrâna redzamos datus ievieto datu bâzç kâ jaunu ierakstu. UZMANÎTIES NO NEVAJADZÎGU DUBULTO IERAKSTU IZVEIDES !" name="saglabatjaunu" onclick="<%if id<>-1 then%> {if (('<%=pk1_var%>'!=pk1.value || '<%=pk2_var%>'!=pk2.value || confirm('Mçìinâjums izveidot jaunu dalîbnieku ar jau esoða dalîbnieka personas kodu! Vai vçlaties turpinât? \nOK = Jâ, Cancel = Nç')))<%end if%> {forma.action='dalibn_add.asp';}<%if id<>-1 then%> else {forma.action = '';}}<%end if%>" src="impro/bildes/saglabatjaunu.jpg">

</td></tr></table>

<center>
<% 
if adrese_var <> "" and pilseta_var <> "" then
  set rkaimini = conn.execute("select * from dalibn where deleted = 0 and id <> "+cstr(id)+" and adrese = '"+sqltext(adrese_var)+"' and pilseta = '"+sqltext(pilseta_var)+"' ") 
  if not rkaimini.eof then
   %>Ðajâ adresç vçl dzîvo: <%
   while not rkaimini.eof
    
    kstr = "<a href='dalibn.asp?i="+cstr(rkaimini("id"))+"'>" + nullprint(rkaimini("vards"))
	
	if nullprint(rkaimini("uzvards"))<>"" then
		kstr = kstr + " " + nullprint(rkaimini("uzvards"))
	else
		kstr = kstr + " " + nullprint(rkaimini("nosaukums"))
	end if
	
	kstr = kstr + "</a> "
    
    Response.Write kstr
    'Response.Write "<a href='dalibn_testam.asp?i="+cstr(rkaimini("id"))+"'>" + nullprint(rkaimini("vards")) + " " + nullprint(rkaimini("uzvards")) + " " + nullprint(rkaimini("nosaukums")) + "</a>"
    
    rkaimini.movenext
   wend
  end if
end if

''-------------------- vai eksistç online profils
If pk1_var <> "" And pk2_var <> "" then
	Set ronline = conn.execute("select id from profili where pk1 = '"+pk1_var+"' and pk2 = '"+pk2_var+"'")
	If Not ronline.eof Then
		Response.write "<BR>Izveidots online <a href=profils.asp?pk1="+pk1_var+"&pk2="+pk2_var+">profils</a><BR><BR>"
	End if
End if

%>

<table border="0">
<tr><td align = "center">
<% if id<>"-1" then %>
	<input type="image" alt="Saglabâ izdarîtâs izmaiòas par doto dalîbnieku" name="labot" src="impro/bildes/labot.jpg" name = "labot" onclick="<%if isDalibnInBlockedGroup(id) then %>alert('Dalîbnieka Vârdu/Uzvârdu nevar mainît, jo dalîbnieks atrodas bloíçtâ grupâ.');forma.vards.value='<%=vards_var%>';forma.uzvards.value='<%=uzvards_var%>';<%end if%>forma.action='dalibn.asp?i=<%=id%>';">
	<input type="image" alt="Dzçð doto dalîbnieku no datu bâzes. Dalîbnieku iespçjams izdzçst tikai tad, ja izdzçsti visi viòa pieteikumi." name="dzestdal" src="impro/bildes/dzest.jpg" name = "labot" onclick="forma.action='dalibn_del.asp?did=<%=id%>';">
	<% if id<>0 then%>
	<a target = none href = "dalibn_vesture.asp?did=<%=id%>"><img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît ðî dalîbnieka vçsturi."></a>
	<% end if %>
 <%
  if session("return")="1" then
   Response.Write "<br><a href=# onclick=""opener.forma.klients.value="+cstr(id)+";window.close();"">Ievietot</a>"
   session("return")=""
  end if
 %>

<% end if %>
</td></tr>
</table>
</td></tr></table> 
<hr>
<%
'--------------------------
'@ 0 Pieteikumu saraksts
'--------------------------
if id<>"-1" then
dim parakstits,par_status,lig_color,par_poga
dim ssql
    
if request.querystring("visi") then 
'@ 1 SQL ------------------------
oldpquery = "SELECT pieteikums.id as pid,pieteikums.datums,gid,old_gid,grupa.valuta,agents," + _
	"pieteikums.summa as summa,iemaksas,izmaksas,atlaides,bilance,atcelts,pieteikums.piezimes," + _
	"pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL," + _
	"pieteikums.iemaksasUSD,pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD," + _
	"pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD,pieteikums.atlaidesEUR," + _
	"pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL," + _
	"pieteikums.bilanceUSD,pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta," + _
	"agents_izv,dk_norakstita, Sum(isnull(o.summaLVL,0)) as neapstLVL, Sum(isnull(o.summaUSD,0)) as neapstUSD," + _
	" Sum(isnull(o.summaEUR,0)) as neapstEUR, isnull(pieteikums.internets,0) as internets,ligums_id,online_rez " + _
	"FROM (pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id) " + _
	"LEFT JOIN marsruts ON marsruts.id = grupa.mid " + _
	"LEFT JOIN orderis o ON o.pid = pieteikums.id and o.deleted = 0 and o.parbaude = 1 " + _
	"WHERE pieteikums.id in (select pid from piet_saite where did = "+cstr(id) + " and piet_saite.deleted = 0) " + _
	"and (pieteikums.deleted = 0 or pieteikums.atcelts = 1) and ((pieteikums.tmp = 0 " + _
	"and pieteikums.internets=1) or (isnull(pieteikums.internets,0)=0)) " + _
	"and marsruts.v NOT like '!Avanss "+cstr(Year(Date()))+"%' " + _
	"and marsruts.v NOT like '!Avanss "+cstr(Year(DateAdd("yyyy",-1,Date())))+"%' " + _
		"and marsruts.v NOT like '!Avanss "+cstr(Year(DateAdd("yyyy",-2,Date())))+"%' " + _
			"and marsruts.v NOT like '!Avanss "+cstr(Year(DateAdd("yyyy",-3,Date())))+"%' " + _
				"and marsruts.v NOT like '!Avanss "+cstr(Year(DateAdd("yyyy",-4,Date())))+"%' " + _
	"group by pieteikums.id,pieteikums.datums,gid,old_gid,grupa.valuta,agents,pieteikums.summa,iemaksas,izmaksas,atlaides,bilance,atcelts," + _
	"pieteikums.piezimes,pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL,pieteikums.iemaksasUSD," + _
	"pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD,pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD," + _
	"pieteikums.atlaidesEUR,pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL,pieteikums.bilanceUSD," + _
	"pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta,agents_izv,dk_norakstita,pieteikums.internets " + _
	",ligums_id,online_rez ORDER BY grupa.sakuma_dat"
	pquery="SELECT pieteikums.id as pid,pieteikums.datums,gid,old_gid,grupa.valuta,agents," + _
		"pieteikums.summa as summa,iemaksas,izmaksas,atlaides,bilance,atcelts,pieteikums.piezimes," + _
		"pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL," + _
		"pieteikums.iemaksasUSD,pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD," + _
		"pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD,pieteikums.atlaidesEUR," + _
		"pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL," + _
		"pieteikums.bilanceUSD,pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta," + _
		"agents_izv,dk_norakstita, Sum(isnull(o.summaLVL,0)) as neapstLVL, Sum(isnull(o.summaUSD,0)) as neapstUSD," + _
		" Sum(isnull(o.summaEUR,0)) as neapstEUR, isnull(pieteikums.internets,0) as internets,ligums_id,online_rez " + _
		
		"FROM (pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id) " + _
		"LEFT JOIN marsruts ON marsruts.id = grupa.mid " + _
		"LEFT JOIN orderis o ON o.pid = pieteikums.id and o.deleted = 0 and o.parbaude = 1 " + _
		"WHERE pieteikums.id in (select pid from piet_saite where did = "+cstr(id) + " and piet_saite.deleted = 0) " + _
		"and (pieteikums.deleted = 0 or pieteikums.atcelts = 1) and ((pieteikums.tmp = 0 " + _
		"and pieteikums.internets=1) or (isnull(pieteikums.internets,0)=0)) " + _
		"group by pieteikums.id,pieteikums.datums,gid,old_gid,grupa.valuta,agents,pieteikums.summa,iemaksas,izmaksas,atlaides,bilance,atcelts," + _
		"pieteikums.piezimes,pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL,pieteikums.iemaksasUSD," + _
		"pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD,pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD," + _
		"pieteikums.atlaidesEUR,pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL,pieteikums.bilanceUSD," + _
		"pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta,agents_izv,dk_norakstita,pieteikums.internets " + _
		",ligums_id,online_rez,pieteikums.sakuma_datums " +_
		"ORDER BY COALESCE(grupa.sakuma_dat,pieteikums.sakuma_datums,pieteikums.datums)"
	else

	dim sak_datums
	'sak_datums = "'"+cstr(CDate(dateserial(2007,1,1)))+"'"
	sak_datums = "'2007-01-01'"
	dim sis_gads 
	'sis_gads = "'"+cstr(CDate(dateserial(year(date),1,1)))+"'"
	sis_gads = "CONVERT(varchar(4),YEAR(GETDATE()))+ '-01-01'"
	dim senakais_datums
	'senakais_datums = "'"+cstr(CDate(dateserial(1900,1,1)))+"'"
	senakais_datums = "'1900-01-01'"
	dim pernais_gads
	pernais_gads = "CONVERT(varchar(4),YEAR(DATEADD(year,-1,GETDATE())))+ '-01-01'"
	'response.write pernais_gads
	sis_gads = pernais_gads
	
	
	pquery="SELECT pieteikums.id as pid,pieteikums.datums,gid,old_gid,grupa.valuta,agents," + _
		"pieteikums.summa as summa,iemaksas,izmaksas,atlaides,bilance,atcelts,pieteikums.piezimes," + _
		"pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL," + _
		"pieteikums.iemaksasUSD,pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD," + _
		"pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD,pieteikums.atlaidesEUR," + _
		"pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL," + _
		"pieteikums.bilanceUSD,pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta," + _
		"agents_izv,dk_norakstita, Sum(isnull(o.summaLVL,0)) as neapstLVL, Sum(isnull(o.summaUSD,0)) as neapstUSD," + _
		" Sum(isnull(o.summaEUR,0)) as neapstEUR, isnull(pieteikums.internets,0) as internets,ligums_id,online_rez " + _
		"FROM (pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id) " + _
		"LEFT JOIN marsruts ON marsruts.id = grupa.mid " + _
		"LEFT JOIN orderis o ON o.pid = pieteikums.id and o.deleted = 0 and o.parbaude = 1 " + _
		"WHERE pieteikums.id in (select pid from piet_saite where did = "+cstr(id) + " and piet_saite.deleted = 0) " + _
		"and (pieteikums.deleted = 0 or pieteikums.atcelts = 1) and ((pieteikums.tmp = 0 " + _
		"and pieteikums.internets=1) or (isnull(pieteikums.internets,0)=0)) " + _
		"/*atlasam visus pieteikumus (jebkâda veida), kuriem ir pozitîva vai negatîva bilance(nav nulle), sâkot ar 2007.gadu*/ " + _
		"and ((isnull(pieteikums.BilanceEUR,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sis_gads+" and grupa.sakuma_dat>="+sak_datums+"  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sak_datums+" then pieteikums.BilanceEUR else " +_ 
		"case when isnull(grupa.sakuma_dat,"+sis_gads+")>="+sis_gads+" then -9999999999 else -99999999999 end end  end) " +_
		" or (isnull(pieteikums.BilanceLVL,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sis_gads+" and grupa.sakuma_dat>="+sak_datums+"  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sak_datums+" then pieteikums.BilanceLVL else " +_ 
		"case when isnull(grupa.sakuma_dat,"+sis_gads+")>="+sis_gads+" then -9999999999 else -99999999999 end end  end) " +_
		" or (isnull(pieteikums.BilanceUSD,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sis_gads+" and grupa.sakuma_dat>="+sak_datums+"  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<"+sak_datums+" then pieteikums.BilanceUSD else " +_ 
		"case when isnull(grupa.sakuma_dat,"+sis_gads+")>="+sis_gads+" then -9999999999 else -99999999999 end end  end)) " +_
		" and pieteikums.datums >= case when marsruts.v like '!%' AND marsruts.v not like '!Atteik%' then "+sak_datums+" else "+senakais_datums+" end " +_
		
		" and ((isnull(pieteikums.BilanceEUR,0) <> case when marsruts.v like '!%' AND marsruts.v not like '!Atteik%' and pieteikums.datums<"+sis_gads+" and pieteikums.datums>="+sak_datums+" then 0 else case" +_
		" when marsruts.v like '!%' AND marsruts.v not like '!Atteik%'  and pieteikums.datums<"+sak_datums+" then pieteikums.BilanceEUR else case" +_
		" when marsruts.v like '!%' AND marsruts.v not like '!Atteik%'  and pieteikums.datums>="+sis_gads+" then -999999999 else -9999999999 end end end))  " +_
	" and pieteikums.datums >= case when marsruts.v like '!Atteik%' then "+pernais_gads+" else "+senakais_datums+" end " +_
		
		" /*and ((isnull(pieteikums.BilanceEUR,0) <> case when marsruts.v like '!Atteik%' and pieteikums.datums<"+sis_gads+" and pieteikums.datums>="+sak_datums+" then 0 else case" +_
		" when marsruts.v like '!Atteik%' and pieteikums.datums<"+sak_datums+" then pieteikums.BilanceEUR else case" +_
		" when marsruts.v like '!Atteik%' and pieteikums.datums>="+pernais_gads+" then -999999999 else -9999999999 end end end))*/  " +_
		"group by pieteikums.id,pieteikums.datums,gid,old_gid,grupa.valuta,agents,pieteikums.summa,iemaksas,izmaksas,atlaides,bilance,atcelts," + _
		"pieteikums.piezimes,pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL,pieteikums.iemaksasUSD," + _
		"pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD,pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD," + _
		"pieteikums.atlaidesEUR,pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL,pieteikums.bilanceUSD," + _
		"pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta,agents_izv,dk_norakstita,pieteikums.internets " + _
		",ligums_id,online_rez, pieteikums.sakuma_datums ORDER BY COALESCE(grupa.sakuma_dat,pieteikums.sakuma_datums,pieteikums.datums)"
	'response.write(pquery0)
	pquery0="SELECT pieteikums.id as pid,pieteikums.datums,gid,old_gid,grupa.valuta,agents," + _
		"pieteikums.summa as summa,iemaksas,izmaksas,atlaides,bilance,atcelts,pieteikums.piezimes," + _
		"pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL," + _
		"pieteikums.iemaksasUSD,pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD," + _
		"pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD,pieteikums.atlaidesEUR," + _
		"pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL," + _
		"pieteikums.bilanceUSD,pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta," + _
		"agents_izv,dk_norakstita, Sum(isnull(o.summaLVL,0)) as neapstLVL, Sum(isnull(o.summaUSD,0)) as neapstUSD," + _
		" Sum(isnull(o.summaEUR,0)) as neapstEUR, isnull(pieteikums.internets,0) as internets,ligums_id,online_rez " + _
		"FROM (pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id) " + _
		"LEFT JOIN marsruts ON marsruts.id = grupa.mid " + _
		"LEFT JOIN orderis o ON o.pid = pieteikums.id and o.deleted = 0 and o.parbaude = 1 " + _
		"WHERE pieteikums.id in (select pid from piet_saite where did = "+cstr(id) + " and piet_saite.deleted = 0) " + _
		"and (pieteikums.deleted = 0 or pieteikums.atcelts = 1) and ((pieteikums.tmp = 0 " + _
		"and pieteikums.internets=1) or (isnull(pieteikums.internets,0)=0)) " + _
		"/*atlasam visus pieteikumus (jebkâda veida), kuriem ir pozitîva vai negatîva bilance(nav nulle), sâkot ar 2007.gadu*/ " + _
		"and ((isnull(pieteikums.BilanceEUR,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(year(date),1,1)))+"' and grupa.sakuma_dat>='"+cstr(CDate(dateserial(2007,1,1)))+"'  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(2007,1,1)))+"' then pieteikums.BilanceEUR else " +_ 
		"case when isnull(grupa.sakuma_dat,'"+cstr(CDate(dateserial(year(date),1,1)))+"')>='"+cstr(CDate(dateserial(year(date),1,1)))+"' then -9999999999 else -99999999999 end end  end) " +_
		" or (isnull(pieteikums.BilanceLVL,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(year(date),1,1)))+"' and grupa.sakuma_dat>='"+cstr(CDate(dateserial(2007,1,1)))+"'  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(2007,1,1)))+"' then pieteikums.BilanceLVL else " +_ 
		"case when isnull(grupa.sakuma_dat,'"+cstr(CDate(dateserial(year(date),1,1)))+"')>='"+cstr(CDate(dateserial(year(date),1,1)))+"' then -9999999999 else -99999999999 end end  end) " +_
		" or (isnull(pieteikums.BilanceUSD,0) <> case when  grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(year(date),1,1)))+"' and grupa.sakuma_dat>='"+cstr(CDate(dateserial(2007,1,1)))+"'  then 0 else " +_
		"	case when grupa.sakuma_dat is not null and grupa.sakuma_dat<'"+cstr(CDate(dateserial(2007,1,1)))+"' then pieteikums.BilanceUSD else " +_ 
		"case when isnull(grupa.sakuma_dat,'"+cstr(CDate(dateserial(year(date),1,1)))+"')>='"+cstr(CDate(dateserial(year(date),1,1)))+"' then -9999999999 else -99999999999 end end  end)) " +_
		" and pieteikums.datums >= case when marsruts.v like '!%' then '"+cstr(CDate(dateserial(2007,1,1)))+"' else '"+cstr(CDate(dateserial(1900,1,1)))+"' end " +_
		
		" and ((isnull(pieteikums.BilanceEUR,0) <> case when marsruts.v like '!%' and pieteikums.datums<'"+cstr(CDate(dateserial(year(date),1,1)))+"' and pieteikums.datums>='"+cstr(CDate(dateserial(2007,1,1)))+"' then 0 else case" +_
		" when marsruts.v like '!%' and pieteikums.datums<'"+cstr(CDate(dateserial(2007,1,1)))+"' then pieteikums.BilanceEUR else case" +_
		" when marsruts.v like '!%' and pieteikums.datums>='"+cstr(CDate(dateserial(year(date),1,1)))+"' then -999999999 else -9999999999 end end end))  " +_
	
		"group by pieteikums.id,pieteikums.datums,gid,old_gid,grupa.valuta,agents,pieteikums.summa,iemaksas,izmaksas,atlaides,bilance,atcelts," + _
		"pieteikums.piezimes,pieteikums.summaLVL,pieteikums.summaUSD,pieteikums.summaEUR,pieteikums.iemaksasLVL,pieteikums.iemaksasUSD," + _
		"pieteikums.iemaksasEUR,pieteikums.izmaksasLVL,pieteikums.izmaksasUSD,pieteikums.izmaksasEUR,pieteikums.atlaidesLVL,pieteikums.atlaidesUSD," + _
		"pieteikums.atlaidesEUR,pieteikums.sadardzinLVL,pieteikums.sadardzinUSD,pieteikums.sadardzinEUR,pieteikums.bilanceLVL,pieteikums.bilanceUSD," + _
		"pieteikums.bilanceEUR,krasa,kods,v,sakuma_dat,beigu_dat,atcelta,agents_izv,dk_norakstita,pieteikums.internets " + _
		",ligums_id,online_rez, pieteikums.sakuma_datums ORDER BY COALESCE(grupa.sakuma_dat,pieteikums.sakuma_datums,pieteikums.datums)"
	end if
	'' and pieteikums.step = '4'
'response.write(pquery)	
set pieteikumi = server.CreateObject("ADODB.Recordset")
pieteikumi.Open pquery,conn,3,3

'set old_pieteikumi = server.CreateObject("ADODB.Recordset")
'old_pieteikumi.Open old_pquery,conn,3,3
'rw pquery

if irMelnajaSaraksta(pk1_var,pk2_var) then rw "<br/><font color='WHITE' style='BACKGROUND-COLOR: black'>&nbsp;&nbsp;IMPRO PAKALPOJUMI IR ATTEIKTI&nbsp;&nbsp;</font><br/><br/>"

dim this_year 
this_year = dateserial(year(date),1,1)
if not pieteikumi.EOF then
%>
<!-- @ 1 HTML ------------------------------>
<center><font color="GREEN">
<!--Lîdz <% Response.Write DateAdd("yyyy", -1, Date())
%> veikti xxx pieteikumi.  -->
<%   


%>
<% if request.querystring("visi") then %>
<a href="?i=<%=id%>">Paslçpt vçsturi</a>
<br>
<b>Lîdz ðim veiktie pieteikumi:</b>
<%else %>
<a href="?i=<%=id%>&visi=1">Parâdît visus pieteikumus</a>
<br>
<b>No <% response.write this_year %> veiktie pieteikumi:</b>
<%end if%>
</font>


<table >

<tr bgcolor = #ffc1cc>
<th align = "left"></th>
<th align = "left">Nr.</th>
<th align = "center">Grupa</th>
<th align = "left">Vietas</th>
<th align = "left">Summa</th>
<th align = "left">Iemaksâts</th>
<th align = "left">Atskaitîts</th>
<th align = "left">Atlaide</th>
<th align = "left">Piemaksa</th>
<th align = "center">Neapst.</th>
<th align = "left">Bilance</th>
<!--<th align = "center">Rçíins</th>-->
<th align = "center" style="min-width:90px">Lîgums</th>
<th align = "left"></th>
</tr>
<%
p = 0
while not pieteikumi.eof
 set rIemaks = conn.execute("select max(CAST(zils AS INT)) as zils from orderis where deleted = 0 and pid = " & pieteikumi("pid"))
 if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) and not rIemaks.eof and rIemaks("zils") = 1 then
  response.write "<tr bgcolor  = lightblue>"
 else
  response.write "<tr bgcolor  = #fff1cc>"
 end if
 piezimes = NullPrint(pieteikumi("piezimes"))
 
 if pieteikumi("atcelta") = true or dkVecakaPar(2006,pieteikumi("v")) = true or pieteikumi("dk_norakstita") = true then 
	fstyle = " style='color: red'"
 else 
	
	if getnum(pieteikumi("agents"))<>0 then
		fstyle = " style='color: #0030ff'"
	elseif getnum(pieteikumi("internets"))=true then
		fstyle = " style='color: green'"
	else
		fstyle = ""
	end if
	
 end if
 'Response.Write ("-> "&pieteikumi("internets"))
 
 if piezimes<>"" then piezimes = "<br>"+piezimes
 if pieteikumi("pid")<>p then
	response.write "<td><a href = 'pieteikums.asp?pid="+cstr(pieteikumi("pid"))+"'><img src='impro/bildes/k_zals.gif'</a>"
	response.write "<td"+fstyle+">"+cstr(pieteikumi("pid"))
	if getnum(pieteikumi("old_gid"))<>0 then 
	 response.write "<td"+fstyle+"><b>"+nullprint(pieteikumi("kods"))+" " + nullprint(pieteikumi("v")) + " " + dateprint(pieteikumi("sakuma_dat")) + " " + dateprint(pieteikumi("beigu_dat"))+piezimes
	 Response.Write "<br>"+grupas_nosaukums(pieteikumi("old_gid"),pieteikumi("pid"))
	else
	 response.write "<td"+fstyle+">"+nullprint(pieteikumi("kods"))+" " + nullprint(pieteikumi("v")) + " " + dateprint(pieteikumi("sakuma_dat")) + " " + dateprint(pieteikumi("beigu_dat")) + piezimes
	end if
	set kopa = conn.execute("select sum(vietsk) as vietas, sum(summa) as sm from piet_saite where deleted = 0 and pid = "+cstr(pieteikumi("pid")))
	response.write "<td"+fstyle+">"+cstr(getnum(kopa("vietas")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("summaLVL")),getnum(pieteikumi("summaUSD")),getnum(pieteikumi("summaEUR")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("iemaksasLVL")),getnum(pieteikumi("iemaksasUSD")),getnum(pieteikumi("iemaksasEUR")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("izmaksasLVL")),getnum(pieteikumi("izmaksasUSD")),getnum(pieteikumi("izmaksasEUR")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("atlaidesLVL")),getnum(pieteikumi("atlaidesUSD")),getnum(pieteikumi("atlaidesEUR")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("sadardzinLVL")),getnum(pieteikumi("sadardzinUSD")),getnum(pieteikumi("sadardzinEUR")))
	if getnum(pieteikumi("neapstLVL"))<>0 or getnum(pieteikumi("neapstUSD"))<>0 or getnum(pieteikumi("neapstEUR"))<>0 then
		fstyle1 = " style='color: #FF0000'"
	else
		fstyle1 = ""
	end if
	response.write "<td"+fstyle1+">"+curr3printHTML(getnum(pieteikumi("neapstLVL")),getnum(pieteikumi("neapstUSD")),getnum(pieteikumi("neapstEUR")))
	response.write "<td"+fstyle+">"+curr3printHTML(getnum(pieteikumi("bilanceLVL")),getnum(pieteikumi("bilanceUSD")),getnum(pieteikumi("bilanceEUR")))
	    %>

    <!--<td>
     <% 
	gads =Year(pieteikumi("datums"))
	If gads>=2007 Then
		Set r = conn.execute("select * from s"+CStr(gads)+".dbo.rekini_tr tr inner join s"+CStr(gads)+".dbo.rekini r on tr.rekins=r.id where globa_pid = "+CStr(pieteikumi("pid")))
		If Not r.eof Then
			  %><a href=orderis.asp?pid=<%=pieteikumi("pid")%>&zils=1&rekins=<%=r("num")%>&rekins_gads=<%=CStr(gads)%>&kredits=2.3.4.X><%
			  response.write "<nobr>"+nullprint(r("num"))+"-"+nullprint(gads)+"</nobr><BR>"
			  response.write "<nobr>"+nullprint(r("summa_pvn_val")) + " "+r("valuta")+"</nobr>"
		End If
		%></a><%
	End if
     %>
    </td>-->
	<td>
	<%
		'meklçjam online lîgumu
		if getnum(pieteikumi("online_rez"))<>0 then
			set rrez = conn.execute("select * from online_rez where id = "+cstr(pieteikumi("online_rez")))
			if not rrez.eof then
			'href=download_pdf.asp
			'response.write(pieteikumi("datums"))
			%><a href=paradit_ligumu.php?id=<%=rrez("ligums_id")%> target=ligums><%=rrez("ligums_id")%></a><%
			end if
		else
			if getnum(pieteikumi("ligums_id"))<>0 then
			ssql = "SELECT isnull(parakstits,0) as parakstits FROM ligumi WHERE id="+cstr(pieteikumi("ligums_id"))+""
			set lig = conn.execute(ssql)
			parakstits = lig(0)
			
			
			if parakstits then
				lig_color = "green"
				par_status="<small><font color='green'>Parakstîts</font></small>"
				par_poga = "OK"
			else
				lig_color = "red"
				par_status = "<small><font color='red'>Nav parakstîts</font></small>"
				par_poga = "OK"
			end if
			%><a href=download_pdf.asp?id=<%=pieteikumi("ligums_id")%> target=ligums><font color="<%=lig_color%>"><%=pieteikumi("ligums_id")%></font></a>
			
		
				
				<input type="button" onclick="location.href='c_ligumi.php?f=parakstit&did=<%=id%>&ligums_id=<%=pieteikumi("ligums_id")%>';" value="<%=par_poga%>" />
			<%
			end if
		end if
		
		
		
		
	%>
	</td>

    <td><input type = 'image' name = 'dzest' src='impro/bildes/dzest.jpg' alt = '' onclick="<% if isGroupBlocked(pieteikumi("gid")) then %>alert('Izmaiòas veikt nav iespçjams, jo grupa kurâ atrodas ðis pieteikums ir bloíçta! Lûdzu griezties pie grupas kuratora.');return false; <%else%> forma.action='piet_del.asp?pid=<%=pieteikumi("pid")%>&did=<%=id%>'<%end if%>"></td>
    <% 'ja pieteikuma bilance nav 0 tad nosaka pieteikuma pakalpojumus 
    if getnum(pieteikumi("bilance"))<>0 or getnum(pieteikumi("summa"))=0 then
		pakalpojumi = ""
		set rPak = server.CreateObject("adodb.recordset")
		rPak.open "select nosaukums from vietu_veidi where id in (select vietas_veids from piet_saite where pid = "+cstr(pieteikumi("pid"))+" and deleted = 0)",conn,3,3
		while not rPak.EOF
		 pakalpojumi = pakalpojumi+nullprint(rPak("nosaukums"))
		 rPak.MoveNext
		 if not rPak.eof then pakalpojumi = pakalpojumi + ", "
		wend
	else
		pakalpojumi = ""
	end if
	if pieteikumi("atcelta") = 1 then
	 if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) then
	  %><td><input type="image" src="impro/bildes/dolarszils.jpg" onclick="if (confirm('Grupa ir atcelta. Vai vçlaties veikt iemaksu?')) TopSubmit('orderis.asp?pid=<%=pieteikumi("pid")%>&zils=1'); else return false;" alt="<%=pakalpojumi%>"  id=image1 name=image1></td><%
	 end if
	 %><td><input type="image" src="impro/bildes/dolars.jpg" onclick="if (confirm('Grupa ir atcelta. Vai vçlaties veikt iemaksu?')) TopSubmit('orderis.asp?pid=<%=pieteikumi("pid")%>'); else return false;" alt="<%=pakalpojumi%>"  id=image1 name=image1></td><%
	else
	 if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) then
	  %><td><input type="image" src="impro/bildes/dolarszils.jpg" onclick="forma.action='orderis.asp?pid=<%=pieteikumi("pid")%>&zils=1'" alt="<%=pakalpojumi%>"  id=image1 name=image1></td><%
	 end if
	 %><td><input type="image" src="impro/bildes/dolars.jpg" onclick="forma.action='orderis.asp?pid=<%=pieteikumi("pid")%>'" alt="<%=pakalpojumi%>"  id=image1 name=image1></td><%
	end if
 if session("parsk") = "no" or session("parsk") = "uz" then
   %><td><input type = 'image' src='impro/bildes/parskaitit.jpg' name='parskaitit' alt = '' onclick=forma.action='operacija.asp?pid=<%=pieteikumi("pid")%>&did=<%=id%>'></td><%
 end if
    
 response.write "</tr>"
 end if
 p = pieteikumi("pid")
 pieteikumi.movenext
wend
%>

</table>
		
<% else %>
<font size = 5><% if request.querystring("visi") then %>
Nav reìistrçtu pieteikumu


<%else %>

No <% response.write this_year %> nav reìistrçti jauni pieteikumi
<br>
<a href="?i=<%=id%>&visi=1">Parâdît visus pieteikumus</a>

<%end if%>
</font>
<%end if%>
<table>
<tr><td align = "center">
<% 

if id<>"-1" then 
	
	if not irMelnajaSaraksta(pk1_var,pk2_var) then 
	
	%>
	<input type="image" alt="Izveido jaunu pieteikumu un pievieno ðim pieteikumam formâ redzamo dalîbnieku" src="impro/bildes/jaunspieteikums.jpg" name="jaunspieteikums" onclick="if(forma.gid.value == '-1'){forma.action='pieteikums_klub_abon.asp?command=new&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>';}else{forma.action='pieteikums.asp?command=new&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>';}">
	<select name="gid">
	 <% set rParam = conn.execute ("select * from parametri") %>
	  <option value="">-</option>
	  <option value="<%=rParam("kompleks")%>">Kompleksais</option>
	  <option value="<%=rParam("charter")%>">Èarters</option>
	  <option value="<%=rParam("incoming")%>">Ienâkoðais</option>
	  <option value="-1">Klubiòu Abonoments</option>
	  <option value="balle">Balles biïete</option>
	</select>
		<% if session("pievienot")="1" then %>
			<input type="image" alt="Pievieno ekrânâ redzamo dalîbnieku pieteikumam, kurâ tika nospiesta poga 'Pievienot'" src="impro/bildes/pievienot.jpg" name="pievienot"  onclick="forma.action='pieteikums.asp?pid=<%=session("pid")%>&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>'">
		<% end if 
		If isaccess(T_LIETOT_ADMIN) Then
			%><BR><a href=melnais_saraksts.asp?id=<%=id%>>Ielikt melnaja saraksta</a><%
		End if
	
	else
		rw "<br/><font color='WHITE' style='BACKGROUND-COLOR: black'>&nbsp;&nbsp;IMPRO PAKALPOJUMI IR ATTEIKTI&nbsp;&nbsp;</font>"
	end if
 %>
 </td></tr>
 </table>
 </form>
 
 <% '--------  vîzas %>
 <hr>
 <center><font color="GREEN"><b>Vîzas</b></font>
 <form name=fvizas method=POST action=vizas_save.asp>
 <input type=hidden name=id value=0>
 <input type=hidden name=did value=<%=id%>>
 <input type=hidden name=action value=0>
 <%
 set rVizas = conn.execute("select * from vizas where did = "+cstr(id)+" order by id")
 if not rVizas.eof then
  %>
  <table>
   <tr>
    <td>Iesniegts</td>
    <td>Plânots</td>
    <td>Izsniegts</td>
    <td>Dokumenti</td>
   </tr>
  <%
  while not rVizas.eof
   %>
   <tr>
    <td>
     <input type=text name=iesniegts<%=rVizas("id")%> size=10 value="<%=DatePrint(rVizas("iesniegts"))%>">
    </td>
    <td>
     <input type=text name=planots<%=rVizas("id")%> size=10 value="<%=DatePrint(rVizas("planots"))%>">
    </td>
    <td>
     <input type=text name=izsniegts<%=rVizas("id")%> size=10 value="<%=DatePrint(rVizas("izsniegts"))%>">
    </td>
    <td>
      <% 
      if rVizas("dokumenti_ir") = true then 
       title = "Uz vietas"
       action = "dokumenti_nav"
      end if
      if rVizas("dokumenti_ir") = false then 
       title = "Nav uz vietas" 
       action = "dokumenti_ir"
      end if
      %>
     <a href="dokumentu statusa maiòa" onclick="fvizas.action.value='<%=action%>';fvizas.id.value=<%=rVizas("id")%>;fvizas.submit();return false;"><%=title%></a>
    </td>
    <td>
     <input type=image src="impro/bildes/diskete.jpg" onclick="fvizas.id.value=<%=rVizas("id")%>;fvizas.action.value='save';fvizas.submit();return false;">
     <input type=image src="impro/bildes/dzest.jpg" onclick="if (confirm('Dzçst?')) {fvizas.id.value=<%=rVizas("id")%>;fvizas.action.value='delete';fvizas.submit();}return false;">
    </td>
   </tr>
   <%
   rVizas.movenext
  wend
  %></table><%
 end if
 %>
 <a href="" onclick="fvizas.action.value='iesniegts';fvizas.submit();return false;">Iesniedz dokumentus</a>
 </form>
 <%

else
 %></form><%
end if 'if id<>"-1"
%>


</td></tr>
</table>

<% end if 

%>
</body>
</html>

<%
'---------------------------------------------------------------


function WhereClause (fields_p,types_p,forms_p)
dim result_l
dim field_l
dim type_l
dim val_l 
field_l = nextword(fields_p)
type_l = nextword(types_p)
val_l = request.form(nextword(forms_p))
while field_l<>""
	if val_l <> "" then
		if type_l = "text"   then result_l = result_l + " and " + field_l+" like N'%" + val_l + "%'"
		if type_l = "string" then result_l = result_l + " and " + field_l+" = '" + val_l + "'"
		if type_l = "num" and val_l <> "0"  then result_l = result_l + " and " + field_l + " = " + val_l
		if type_l = "date"   then result_l = result_l + " and " + field_l+" = '" + val_l + "'"
	end if
	field_l = nextword(fields_p)
	type_l = nextword(types_p)
	val_l = request.form(nextword(forms_p))
wend
if result_l<> "" then result_l = mid(result_l,5,len(result_l)- 4)
WhereClause = result_l
end function

function NextWord (t_p)

'words must be divided by spaces
dim w
dim i
i = instr(t_p," ")
if i<>0 then
	w = mid(t_p,1,i-1)
	t_p = mid(t_p,i+1,len(t_p)-i)
else
	w = t_p
	t_p = ""
end if
NextWord = w
end function

'AddDalHistory
Sub AddDalHistory(did_p)
 for i = 9 to 1 step - 1
  session("DalHistory"+cstr(i+1)) = session("DalHistory"+cstr(i))
 next 
 set r_l = conn.execute ("select * from dalibn where id = " + cstr(did_p))
 if r_l.eof then exit sub
 session("DalHistory1") = "<option value='"+cstr(did_p)+"'>"+dalibnieks(did_p)+"</option>" 
End Sub

function dalibnieks(did_p)
	vards=id_field("dalibn",did_p,"vards")
	uzvards=id_field("dalibn",did_p,"uzvards")
	nosaukums=id_field("dalibn",did_p,"nosaukums")
	dalibnieks = nosaukums
	if nosaukums = "" or isnull(nosaukums) then 
		dalibnieks = nullprint(vards)+" "+nullprint(uzvards)
	end if
end function

sub check_office(return_url)
	if nullprint(session("office")) <> "" then exit sub
	set r = server.createobject("ADODB.Recordset")
	my_ip = request.Servervariables(33)
	r.open "SELECT * FROM IP WHERE ip = '" + my_ip + "'",conn,3,3
	if r.recordcount = 0 then response.redirect "Choose_office.asp?return_url=" + return_url
	session("office") = r("office")
end sub

'--------------------------------------
'dbcomboplus
sub dbcomboplus(table_p,tfield_p,vfield_p,name_p,value_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p + " ORDER BY " + tfield_p)
Response.Write "<select name=" + name_p + ">" + "<option value = 0>-</option>"
do while not grupas.eof
if trim(grupas(vfield_p))= trim(value_p) then
	Response.Write "<option selected value='" & grupas(vfield_p) &"'>" &  grupas(tfield_p) & "</option>"
else
	Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
end if
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub

function dkVecakaPar(pGads, pNosaukums)

	'pârbauda vai ta ir Dâvanu karte
	if Instr(pNosaukums,"!Dâvanu kartes")>0 then
	
		yearPos = Instr(pNosaukums,"20")
	
		if yearPos > 0 then
			if cint(mid(pNosaukums,yearPos,4)) < pGads then 
				dkVecakaPar = true	
			else
				dkVecakaPar = false
			end if
		else
			dkVecakaPar = true 'veca dk, bez gada norâdîjuma
		end if
	else
		dkVecakaPar = false
	end if
	

end function


%>

