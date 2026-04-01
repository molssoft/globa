<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
If request.querystring("i") = "" Then id = -1 Else id = request.querystring("i")
dim conn
OpenConn

'--- pârbauda vai ir zinâms kurâ ofisâ atrodas lietotâjs
check_office "dalibn_jur.asp"

dfields = "vards uzvards pases pasenr pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"
dtypes = "text text text text text text text text text text text text text text text text text text text text num"
dforms = "vards uzvards pases pasenr pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"

poga_var = Request.form("poga")	

'--- Meklçt esoðu ---------------------------
if request.form("meklet.x") <> "" then
  query = "Select nosaukums,reg,nmkods,vaditajs, pilseta, adrese, id , piezimes from dalibn "
  wh =  WhereClause(dfields,dtypes,dforms)
  if wh<>"" then 
    query = query + " where (deleted = 0 or isnull(deleted)) and " + wh
  else
    query = query + " where (deleted = 0 or isnull(deleted)) "
  end if
  skaits = QRecordCount(query)

  '--- Ja nav neviens -----------------------------
  if skaits = 0 then  
	Message = "Nav atrasts neviens dalîbnieks!"
	vards_var = request.form("vards")
	uzvards_var = request.form("uzvards")
	uzvards1_var = request.form("uzvards1")
	dzimta_var = request.form("dzimta")
	paseS_var = request.form("paseS")
	paseNr_var = request.form("paseNr")
	paseIZD_var = request.form("paseIZD")
	paseIZDdat_var = request.form("paseIZDdat")
	paseDERdat_var = request.form("paseDERdat")
	pk1_var = request.form("pk1")
	pk2_var = request.form("pk2")
	adrese_var = request.form("adrese")
	pilseta_var = request.form("pilseta")
	indekss_var = request.form("indekss")
	talrunisM_var = request.form("talrunisM")
	talrunisD_var = request.form("talrunisD")
	talrunisMob_var = request.form("talrunisMob")
	eadr_var = request.form("eadr")
	piezimes_var = request.form("piezimes")
	nosaukums_var = request.form("nosaukums")
	reg_var = request.form("reg")
	nmkods_var = request.form("nmkods")
	vaditajs_var = request.form("vaditajs")
	kontaktieris_var = request.form("kontaktieris")
	rajons_var = request.form("rajons")
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
	response.redirect "dalibn_jur_sar.asp"
	if skaits-int(skaits/10)*10 = 1 then
		Message = "Atrasts "+CStr(skaits)+" dalîbnieks"
	else
		Message = "Atrasti "+CStr(skaits)+" dalîbnieki"
	end if
  end if
end if

'--- Labot esoðo --------------------------
if request.form("labot.x") <> "" then
	id_query = "select * from dalibn where (deleted = 0 or isnull(deleted)) and id = " + CStr(id)
	EditRecord conn,id_query,dfields,dforms
	message = "Labojumi izdarîti veiksmîgi!"
	id = session("editid")	
	add_log "dalibn",id,"UPDATE"
end if

'@ 0 Nolasa tekoðo dalîbnieku --------------------------
if id<>"-1" then
	set recordset = server.createobject("ADODB.Recordset")
	recordset.open "select * from dalibn where  (deleted = 0 or isnull(deleted)) and id = " + CStr(id),conn,3,3
	recordset.movefirst 

	vards_var = recordset("vards")
	uzvards_var = recordset("uzvards")
	dzimta = recordset("dzimta")
	paseS_var = recordset("paseS")
	paseNr_var = recordset("paseNr")
	pk1_var = recordset("pk1")
	pk2_var = recordset("pk2")
	adrese_var = recordset("adrese")
	pilseta_var = recordset("pilseta")
	indekss_var = recordset("indekss")
	talrunisM_var = recordset("talrunisM")
	talrunisD_var = recordset("talrunisD")
	talrunisMob_var = recordset("talrunisMob")
	eadr_var = recordset("eadr")
	piezimes_var = recordset("piezimes")
	nosaukums_var = recordset("nosaukums")
	reg_var = recordset("reg")
	nmkods_var = recordset("nmkods")
	vaditajs_var = recordset("vaditajs")
	kontaktieris_var = recordset("kontaktieris")
	rajons_var = recordset("rajons")
	add_log "dalibn",id,"READ"
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
	paseDERdat_var = ""
	pk1_var = ""
	pk2_var = ""
	adrese_var = ""
	pilseta_var = ""
	indekss_var = ""
	talrunisM_var = ""
	talrunisD_var = ""
	talrunisMob_var = ""
	eadr_var = ""
	piezimes_var = ""
	nosaukums_var = ""
	reg_var = ""
	nmkods_var = ""
	vaditajs_var = ""
	kontaktieris_var = ""
end if
dalibn_jur_grupa=2
%>



<% 
'@ 0 HTML Start --------------------------
docstart "Dalibnieki","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Dalîbnieki</b></font>
<hr>
<% headlinks %>

<% 
if session("dmessage")<>"" then 
	message = session("dmessage")
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
<!-- @ 0 Forma -------------------------->
<form name="forma" action="dalibn_jur.asp" method="POST">
<!-- @ 1 Juridiskâ un personîgâ -------------------------->
<tr>
<td>
<table>
<tr>
<td colspan = "2" align="center"><strong><font color=green>Juridiskas personas dati:</strong></td>
</tr>
<tr  bgcolor=NavajoWhite>
<td  align="right">Nosaukums: </td><td><input type="text" size="20" maxlength="30" name="nosaukums"  value="<%=nosaukums_var%>"></td>
</tr>
<tr bgcolor=NavajoWhite>
<td align="right">Reì. Nr.: </td><td><input type="text" size="15" maxlength="20" name="reg" value="<%=reg_var%>"> </tr>
</tr>

<tr bgcolor=NavajoWhite>
<td>Grupas: </td><td>
<% 
' Change
sSelect_jur_grupas_id="select grupa as grupas_name from dalibn_jur_grupas djg,dalibn_jur_klas djk where djg.dalibn_id="&id&" and djk.id=djg.jur_grupas_id"

Set e_jur_grupas = conn.execute(sSelect_jur_grupas_id)

	do while not e_jur_grupas.eof
		%><%=e_jur_grupas("grupas_name")%><br><%		
		e_jur_grupas.MoveNext
	loop
%>
<a href="jur_grupas.asp?i=<%=id%>">edit</a>

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
<td align="right">Adrese:</td><td> <input type="text" size="16" maxlength="60" name="adrese"  value="<%=adrese_var%>"></td>
<td align="right">Pilsçta:</td><td><input type="text" size="15" maxlength="20" name="pilseta" value="<%=pilseta_var%>"></td>
<td align="right">Indekss: LV - </td><td><input type="text" size="15" maxlength="20" name="indekss" value="<%=indekss_var%>"> </td>

</tr>
<tr bgcolor=NavajoWhite>
<td align="right"> Darba tâlrunis: </td><td><input type="text" size="7" maxlength="7" name="talrunisD" value="<%=talrunisD_var%>"></td>
<td align="right"> Mobîlais tâlrunis: </td><td><input type="text" size="7" maxlength="7" name="talrunisMob" value="<%=talrunisMob_var%>"></td>
</tr>
<tr bgcolor=NavajoWhite>
<td>Rajons: </td><td><% dbcomboplus "rajons","nosaukums","id","rajons",rajons_var %></td>
<td align="right"> e-adrese: </td><td colspan = 2><input type="text" size="16" maxlength="60" name="eadr"  value="<%=eadr_var%>"> </td>
</tr><tr  bgcolor=NavajoWhite>
<td>Piezîmes: </td><td  colspan=4><input type="text" size = "50"  name="piezimes"  value="<%=piezimes_var%>"></td>

</tr>
</table>
</td><td align=center>
<!-- @ 1 Pogas -------------------------->
<input type="image" alt="No ekranâ redzamâs formas notîra visus datus - sagatavo formu jaunu datu ievadei. Atbilstoðais ieraksts datu bâzç netiek izdzçsts." src="impro/bildes/saktjaunu.jpg" name="saktjaunu" onclick="TopSubmit('dalibn_jur.asp')">
<input type="image" alt="Uz ekrâna redzamos datus ievieto datu bâzç kâ jaunu ierakstu. UZMANÎTIES NO NEVAJADZÎGU DUBULTO IERAKSTU IZVEIDES !" name="saglabatjaunu" onclick="TopSubmit('dalibn_jur_add.asp')" src="impro/bildes/saglabatjaunu.jpg">
<input type="image" name="meklet" alt="Atrod dalîbnieku(s) pçc formâ norâdîtajiem datiem. Mekleðana notiek arî pçc daïçji aizpildîta(iem) lauka(iem)." src="impro/bildes/meklet.jpg" onclick="TopSubmit('dalibn_jur.asp')">

</td></tr></table>

<table border="0">
<tr><td align = "center">
<% if id<>"-1" then %>
	<input type="image" alt="Saglabâ izdarîtâs izmaiòas par doto dalîbnieku" name="labot" src="impro/bildes/labot.jpg" name = "labot" onclick="TopSubmit('dalibn_jur.asp?i=<%=id%>')">
	<input type="image" alt="Dzçð doto dalîbnieku no datu bâzes. Dalîbnieku iespçjams izdzçst tikai tad, ja izdzçsti visi viòa pieteikumi." name="dzestdal" src="impro/bildes/dzest.jpg" name = "labot" onclick="TopSubmit('dalibn_jur_del.asp?did=<%=id%>')">
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
'@ 1 SQL ------------------------
pquery = "SELECT pid,papildv "+_
	"FROM piet_saite INNER JOIN pieteikums ON pieteikums.id = piet_saite.pid WHERE (piet_saite.deleted = 0 or isnull(piet_saite.deleted)) and did = "+cstr(id) + " ORDER BY pieteikums.datums"
skquery = "SELECT pid,papildv "+_
	"FROM piet_saite WHERE (deleted = 0 or isnull(deleted)) and did = "+cstr(id)+";"
set pieteikumi = conn.execute(pquery)
psk = QRecordCount(skquery)
if psk<>0 then
%>
<!-- @ 1 HTML ------------------------------>
<center><font color="GREEN"><b>Lîdz ðim veiktie pieteikumi:</b></font>
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
<th align = "left">Bilance</th>
<th align = "center">P.v.</th>
<th align = "left"></th>
</tr>
<%
p = 0
while not pieteikumi.eof
   if pieteikumi("pid")<>p or pieteikumi("papildv") = true then
	set kopa = conn.execute("select sum(vietsk) as vietas, sum(summa) as sm from piet_saite where (deleted = 0 or isnull(deleted)) and pid = "+cstr(pieteikumi("pid")))
	set iem_piet = conn.execute("select sum(summa) as sm from orderis where  (deleted = 0 or isnull(deleted)) and pid = "+cstr(pieteikumi("pid")))
	response.write "<tr bgcolor  = #fff1cc>"
	response.write "<td><a href = 'pieteikums.asp?pid="+cstr(pieteikumi("pid"))+"'><img src='impro/bildes/k_zals.gif'</a>"
	response.write "<td>"+cstr(pieteikumi("pid"))
	gid = id_field("pieteikums",pieteikumi("pid"),"gid")
	response.write "<td>"+grupas_nosaukums(gid,pieteikumi("pid"))
	response.write "<td>"+cstr(getnum(kopa("vietas")))
	response.write "<td>"+cstr(getnum(piet_kopsumma(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_iemaksas(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_izmaksas(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_atlaides(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_bilance(pieteikumi("pid"))))

%>
<td><% if getnum(pieteikumi("papildv")) <> 0 then %>
	<img src ='impro/bildes/papildvieta.jpg' alt = 'Papildvieta'>
<% end if %>
</td>

<td><input type = 'image' name = 'dzest' src='impro/bildes/dzest.jpg' alt = '' onclick=TopSubmit('piet_jur_del.asp?pid=<%=pieteikumi("pid")%>&did=<%=id%>')></td>
	<% if session("parsk") = "no" or session("parsk") = "uz" then %>

<td><input type = 'image' src='impro/bildes/parskaitit.jpg' name='parskaitit' alt = '' onclick=TopSubmit('operacija.asp?pid=<%=pieteikumi("pid")%>&did=<%=id%>')></td>
	<%
	end if
	response.write "</tr>"
    end if
    if pieteikumi("papildv") = false then p = pieteikumi("pid")
    pieteikumi.movenext
wend
%>
</table>
<table>
<tr><td align = "center">
<% if id<>"-1" then %>
	<input type="image" alt="Izveido jaunu pieteikumu un pievieno ðim pieteikumam formâ redzamo dalîbnieku" src="impro/bildes/jaunspieteikums.jpg" name="jaunspieteikums" onclick="TopSubmit('pieteikums_jur.asp?command=new&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>')">
<% if session("pievienot")="1" then %>
	<input type="image" alt="Pievieno ekrânâ redzamo dalîbnieku pieteikumam, kurâ tika nospiesta poga 'Pievienot'" src="impro/bildes/pievienot.jpg" name="pievienot"  onclick="TopSubmit('pieteikums_jur.asp?pid=<%=session("pid")%>&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>')">
<% end if 
if session("pid")<>"" then %>
	<input type="image" alt="Pievieno formâ redzamo dalîbnieku pçdçjam apskatîtajam pieteikumam" name="pievienotpedejam" src="impro/bildes/pievienotpedejam.jpg" onclick="TopSubmit('pieteikums_jur.asp?pid=<%=session("pid")%>&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>')">
<% end if 
end if%>

</td></tr>
</table>

<%
else %>
	<center>
	<font size = "5"><strong>Nav reìistrçtu pieteikumu</strong></font><br><br>
<% if id<>"-1" then %>
	<input type="image" alt="Izveido jaunu pieteikumu un pievieno ðim pieteikumam formâ redzamo dalîbnieku" src="impro/bildes/jaunspieteikums.jpg" name="jaunspieteikums" onclick="TopSubmit('pieteikums.asp?command=new&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>')">
<% if session("pievienot")="1" then %>
	<input type="image" alt="Pievieno ekrânâ redzamo dalîbnieku pieteikumam, kurâ tika nospiesta poga 'Pievienot'" src="impro/bildes/pievienot.jpg" name="pievienot"  onclick="TopSubmit('pieteikums.asp?pid=<%=session("pid")%>&did=<%=id%>&time=<%=cstr(hour(now))+cstr(minute(now))+cstr(second(now))%>')">
<% end if 
end if
end if
end if %>
</form>
</body>
</html>


