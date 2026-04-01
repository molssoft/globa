<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
If request.querystring("i") = "" Then id = -1 Else id = request.querystring("i")
dim conn
openconn

dfields = "vards uzvards uzvards1 pases pasenr paseizd paseizddat pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD eadr nosaukums reg nmkods vaditajs kontaktieris piezimes"
dtypes = "text text text text text text date date text text text text text text text text text text text text text text"
dforms = "vards uzvards uzvards1 pases pasenr paseizd paseizddat pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD eadr nosaukums reg nmkods vaditajs kontaktieris piezimes"

poga_var = Request.form("poga")	
'@ 0 Meklçt esoðu ---------------------------
if request.form("meklet.x") <> "" then
query = "Select vards, uzvards, nosaukums, pilseta, adrese, id , piezimes from dalibn "
wh =  WhereClause(dfields,dtypes,dforms)
if wh<>"" then 
	query = query + " where (deleted = 0 or isnull(deleted)) and " + wh
else
	query = query + " where (deleted = 0 or isnull(deleted)) "
end if
skaits = QRecordCount(query)

'@ 1 Ja nav neviens -----------------------------
if skaits = 0 then  
	Message = "Nav atrasts neviens dalîbnieks!"
	vards_var = request.form("vards")
	uzvards_var = request.form("uzvards")
	uzvards1_var = request.form("uzvards1")
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
	eadr_var = request.form("eadr")
	piezimes_var = request.form("piezimes")
	nosaukums_var = request.form("nosaukums")
	reg_var = request.form("reg")
	nmkods_var = request.form("nmkods")
	vaditajs_var = request.form("vaditajs")
	kontaktieris_var = request.form("kontaktieris")
end if
'@ 1 Ja viens ---------------------------------
if skaits = 1 then 
	message = "Atrasts 1 dalîbnieks!"
	set recordset = conn.execute(query)
	id = recordset("id")
end if
if skaits>30 then Message = "Nosacîjumiem atbilst pârâk daudzi dalîbnieki!"
'@ 1 Saraksts ---------------------------
if skaits>=2 and skaits<=30 then
	session("dquery") = query
	response.redirect "dalibn_sar.asp"
	if skaits-int(skaits/10)*10 = 1 then
		Message = "Atrasts "+CStr(skaits)+" dalîbnieks"
	else
		Message = "Atrasti "+CStr(skaits)+" dalîbnieki"
	end if
end if
end if


'@ 0 Saglabât jaunu ---------------------------
if request.form("saglabatjaunu.x") <> "" then
	NewRecord conn,"select * from dalibn",dfields,dforms
	message = "Jauns dalîbnieks pievienots veiksmîgi!"
	id = session("newid")
	add_log "dalibn",id,"INSERT"
end if

'@ 0 Labot esoðo --------------------------
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
	uzvards1_var = recordset("uzvards1")
	paseS_var = recordset("paseS")
	paseNr_var = recordset("paseNr")
	paseIZD_var = recordset("paseIZD")
	paseIZDdat_var = recordset("paseIZDdat")
	paseDERdat_var = recordset("paseDERdat")
	pk1_var = recordset("pk1")
	pk2_var = recordset("pk2")
	adrese_var = recordset("adrese")
	pilseta_var = recordset("pilseta")
	indekss_var = recordset("indekss")
	talrunisM_var = recordset("talrunisM")
	talrunisD_var = recordset("talrunisD")
	eadr_var = recordset("eadr")
	piezimes_var = recordset("piezimes")
	nosaukums_var = recordset("nosaukums")
	reg_var = recordset("reg")
	nmkods_var = recordset("nmkods")
	vaditajs_var = recordset("vaditajs")
	kontaktieris_var = recordset("kontaktieris")
	add_log "dalibn",id,"READ"
end if
'@ 0 Sâkt jaunu --------------------------
if request.form("saktjaunu.x") <>"" then
	vards_var = ""
	uzvards_var = ""
	uzvards1_var = ""
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
	eadr_var = ""
	piezimes_var = ""
	nosaukums_var = ""
	reg_var = ""
	nmkods_var = ""
	vaditajs_var = ""
	kontaktieris_var = ""
end if
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
if message <> "" then %>
<center><font color="GREEN" size="4"><%=Message%></font>
<% end if 
DefJavaSubmit
%>

<center>
<table border="0">
<tr><td valign="top">
<table border="0">
<!-- @ 0 Forma -------------------------->
<form name="forma" action="dalibn.asp" method="POST">
<!-- @ 1 Juridiskâ un personîgâ -------------------------->
<tr><td colspan="4" align="center"><strong><font color="GREEN">Fiziskas personas dati:</font></strong></td>
<tr bgcolor="NavajoWhite">
<td align="right">Vards:</td><td><input type="text" size="15" maxlength="20" name="vards" value="<%=vards_var%>"></td>
<td align="right">Uzvards:</td><td> <input type="text" size="15" maxlength="30" name="uzvards" value="<%=uzvards_var%>"></td>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Pers. kods:</td><td> <input type="text" size="6" maxlength="6" name="pk1" value="<%=pk1_var%>"> - <input type="text" size="5" maxlength="5" name="pk2" value="<%=pk2_var%>"></td>
<td align="right">Pirmslaulîbas uzvards: </td><td><input type="text" size="10" maxlength="30" name="uzvards1" value="<%=uzvards1_var%>"></td>
</tr>
<tr bgcolor="#fff1cc">
<td align="right">Pase:</td><td> <input type="text" size="2" maxlength="2" name="paseS" value="<%=paseS_var%>"><input type="text" size="7" maxlength="7" name="paseNR" value="<%=paseNR_var%>"> </td>
<td align="right"> Izdoðanas vieta: </td><td><input type="text" size="25" maxlength="40" name="paseIZD" value="<%=paseIZD_var%>"> </td>
</tr>
<tr bgcolor="#fff1cc">
<td align="right">Datums:</td><td> <input type="text" size="9" maxlength="10" name="paseIZDdat" value="<%=paseIZDdat_var%>"></td>
<td align="right">Derîguma termiòð:</td><td> <input type="text" size="9" maxlength="10" name="paseDERdat" value="<%=paseDERdat_var%>"></td>
</tr>
</table>
</td><td>
<table>
<tr>
<td colspan="2" align="center"><strong><font color="green">Juridiskas personas dati:</strong></td>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Nosaukums: </td><td><input type="text" size="20" maxlength="30" name="nosaukums" value="<%=nosaukums_var%>"></td>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Reì. Nr.: </td><td><input type="text" size="15" maxlength="20" name="reg" value="<%=reg_var%>"> </tr>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Nod. maks. kods: </td><td><input type="text" size="15" maxlength="20" name="nmkods" value="<%=nmkods_var%>"> </tr>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Vadîtâjs: </td><td><input type="text" size="15" maxlength="30" name="vaditajs" value="<%=vaditajs_var%>"> </tr>
</tr>
<tr bgcolor="NavajoWhite">
     <td align="right">Kontaktp:</td><td> <input type="text" size="15" maxlength="30" name="kontaktieris" value="<%=kontaktieris_var%>"></td></tr>
</tr>
</table>
</table>

<!-- @ 1 Kopçjâ -------------------------->
<table>
<tr><td>
<table border="0">
<tr>
<td colspan="6"><center><b><font color="green">Kopçjie dati:</td>
</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Adrese:</td><td> <input type="text" size="16" maxlength="60" name="adrese" value="<%=adrese_var%>"></td>
<td align="right">Pilseta:</td><td><input type="text" size="15" maxlength="20" name="pilseta" value="<%=pilseta_var%>"></td>
<td align="right">Indekss: LV - </td><td><input type="text" size="15" maxlength="20" name="indekss" value="<%=indekss_var%>"> </td>

</tr>
<tr bgcolor="NavajoWhite">
<td align="right">Mâjas tâlrunis: </td><td><input type="text" size="7" maxlength="7" name="talrunisM" value="<%=talrunisM_var%>"></td>
<td align="right"> Darba tâlrunis: </td><td><input type="text" size="7" maxlength="7" name="talrunisD" value="<%=talrunisD_var%>"></td>
<td align="right"> E-adrese: </td><td><input type="text" size="16" maxlength="60" name="eadr" value="<%=eadr_var%>"> </td>

</tr>
<tr bgcolor="NavajoWhite">
<td>Piezîmes: </td><td colspan="5"><input type="text" size="60" name="piezimes" value="<%=piezimes_var%>"></td>

</tr>
</table>
</td><td align="center">
<!-- @ 1 Pogas -------------------------->
<input type="image" alt="No ekranâ redzamâs formas notîra visus datus - sagatavo formu jaunu datu ievadei. Atbilstoðais ieraksts datu bâzç netiek izdzçsts." src="impro/bildes/saktjaunu.jpg" name="saktjaunu" onclick="TopSubmit('dalibn.asp')" WIDTH="116" HEIGHT="25">
<input type="image" alt="Uz ekrâna redzamos datus ievieto datu bâzç kâ jaunu ierakstu. UZMANÎTIES NO NEVAJADZÎGU DUBULTO IERAKSTU IZVEIDES !" name="saglabatjaunu" onclick="TopSubmit('dalibn.asp')" src="impro/bildes/saglabatjaunu.jpg" WIDTH="116" HEIGHT="25">
<input type="image" name="meklet" alt="Atrod dalîbnieku(s) pçc formâ norâdîtajiem datiem. Mekleðana notiek arî pçc daïçji aizpildîta(iem) lauka(iem)." src="impro/bildes/meklet.jpg" onclick="TopSubmit('dalibn.asp')" WIDTH="116" HEIGHT="25">

</td></tr></table>

<table border="0">
<tr><td align="center">
<% if id<>"-1" then %>
	<input type="image" alt="Saglabâ izdarîtâs izmaiòas par doto dalîbnieku" name="labot" src="impro/bildes/labot.jpg" name="labot" onclick="TopSubmit('dalibn.asp?i=<%=id%>')" WIDTH="116" HEIGHT="25">
	<input type="image" alt="Dzçð doto dalîbnieku no datu bâzes. Dalîbnieku iespçjams izdzçst tikai tad, ja izdzçsti visi viòa pieteikumi." name="dzestdal" src="impro/bildes/dzest.jpg" name="labot" onclick="TopSubmit('dalibn_del.asp?did=<%=id%>')" WIDTH="25" HEIGHT="25">
<% end if %>
</td></tr>
</table>
</td></tr></table> 
<hr><br><br>
<%
'--------------------------
'@ 0 Pieteikumu saraksts
'--------------------------
if id<>"-1" then
'@ 1 SQL ------------------------
pquery = "SELECT * "+_
	"FROM piet_saite WHERE (deleted = 0 or isnull(deleted)) and did = "+cstr(id)
skquery = "SELECT * "+_
	"FROM piet_saite WHERE (deleted = 0 or isnull(deleted)) and did = "+cstr(id)+";"
set pieteikumi = conn.execute(pquery)
psk = QRecordCount(skquery)
if psk<>0 then
%>
<!-- @ 1 HTML ------------------------------>
<center><font color="GREEN"><b>Lîdz ðim veiktie pieteikumi:</b></font>
<table border="1">
<th align="left"></th>
<th align="left"> Nr. </th>
<th align="center"> Grupa </th>
<th align="left"> Vietas </th>
<th align="left"> Summa </th>
<th align="left"> Iemaksâts </th>
<th align="left"> Atskaitîts </th>
<th align="left"></th>
<%
while not pieteikumi.eof
	set kopa = conn.execute("select sum(vietsk) as vietas, sum(summa) as sm from piet_saite where (deleted = 0 or isnull(deleted)) and pid = "+cstr(pieteikumi("pid")))
	set iem_piet = conn.execute("select sum(summa) as sm from orderis where  (deleted = 0 or isnull(deleted)) and pid = "+cstr(pieteikumi("pid")))
	response.write "<tr>"
	response.write "<td><a href = 'pieteikums.asp?pid="+cstr(pieteikumi("pid"))+"'><img src='impro/bildes/k_zals.gif'</a>"
	response.write "<td>"+cstr(pieteikumi("pid"))
	gid = id_field("pieteikums",pieteikumi("pid"),"gid")
	response.write "<td>"+grupas_nosaukums(gid,pieteikumi("pid"))
	response.write "<td>"+cstr(getnum(kopa("vietas")))
	response.write "<td>"+cstr(getnum(piet_kopsumma(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_iemaksas(pieteikumi("pid"))))
	response.write "<td>"+cstr(getnum(piet_izmaksas(pieteikumi("pid"))))
	%>
	<td><input type="image" name="dzest" src="impro/bildes/dzest.jpg" onclick="TopSubmit('piet_del.asp?pid=<%=pieteikumi("pid")%>&amp;did=<%=id%>')" WIDTH="25" HEIGHT="25"></td>
	<% if session("parsk") = "no" or session("parsk") = "uz" then %>
	<td><input type="image" src="impro/bildes/parskaitit.jpg" name="parskaitit" alt onclick="TopSubmit('operacija.asp?pid=<%=pieteikumi("pid")%>&amp;did=<%=id%>')" WIDTH="116" HEIGHT="25"></td>
	<%
	end if
	response.write "</tr>"
	pieteikumi.movenext
wend
%>
</table>
</form>
<table>
<tr><td align="center">
<% if id<>"-1" then %>
	<input type="image" alt="Izveido jaunu pieteikumu un pievieno ðim pieteikumam formâ redzamo dalîbnieku" src="impro/bildes/jaunspieteikums.jpg" name="jaunspieteikums" onclick="TopSubmit('pieteikums.asp?command=new&amp;did=<%=id%>')" WIDTH="116" HEIGHT="25">
<% if session("pievienot")="1" then %>
	<input type="image" alt="Pievieno ekrânâ redzamo dalîbnieku pieteikumam, kurâ tika nospiesta poga 'Pievienot'" src="impro/bildes/pievienot.jpg" name="pievienot" onclick="TopSubmit('pieteikums.asp?pid=<%=session("pid")%>&amp;did=<%=id%>')" WIDTH="25" HEIGHT="25">
<% end if 
if session("pid")<>"" then %>
	<input type="image" alt="Pievieno formâ redzamo dalîbnieku pçdçjam apskatîtajam pieteikumam" name="pievienotpedejam" src="impro/bildes/pievienotpedejam.jpg" onclick="TopSubmit('pieteikums.asp?pid=<%=session("pid")%>&amp;did=<%=id%>')" WIDTH="116" HEIGHT="25">
<% end if 
end if%>

</td></tr>
</table>

<%
else %>
	<center>
	<font size="5"><strong>Nav reìistrçtu pieteikumu</strong></font>
<%
end if
end if
%>
</body>
</html>


