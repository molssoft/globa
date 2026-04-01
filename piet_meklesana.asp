<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->
<%
dim conn
OpenConn


' Atver komplekso grupu pakalpojumu tabulu
kompgrupa=cstr(GetComplexGroup)
set rstVeidi=server.CreateObject("adodb.recordset")
   qstr="SELECT nosaukums,id FROM vietu_veidi WHERE gid ="+kompgrupa+";"
   rstVeidi.Open qstr,conn,3,3

if request.form("self") = "true" and request.form("poga") <> "Tîra forma" then
	DatumsNo = request.form("txtDatumsNo")
	DatumsLidz = request.form("txtDatumsLidz")
	izbrDatumsNo = request.form("izbrDatumsNo")
	izbrDatumsLidz = request.form("izbrDatumsLidz")
	AtteikumaDatumsNo = request.form("AtteikumaDatumsNo")
	AtteikumaDatumsLidz = request.form("AtteikumaDatumsLidz")
	Students = request.form("chkstudents")
	SummaNo = request.form("txtSummaNo")
	SummaLidz = request.form("txtSummaLidz")
	chkbilance = Request.Form("chkbilance")
	chkkavetajs = Request.Form("chkkavetajs")
	chkpozbilance = Request.Form("chkpozbilance")
	chkzilie = Request.Form("chkzilie")
	chknorakstits = Request.Form("chknorakstits")
	Vards = Request.form("txtVards")
	Uzvards = Request.form("txtUzvards")
	Registretajs = Request.form("txtRegistretajs")
	Pid = request.form("txtpid")
	Lid = request.form("txtlid")
	gr_veids = request.form("gr_veids")
	gr_kods = request.form("gr_kods")
	Kompleks = request.form("Kompleks")
	carter_firma = request.form("carter_firma")
else
	SummaNo = 0
	SummaLidz = 0
	DatumsLidz = DATEPRINT(Date)
	Kompleks = "V"
end if

Function GetPakalpojums(rinda_p)
for i_l = 4 to 1 step -1
	if request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l)) <> "" and request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l)) <> 0 then
		GetPakalpojums = request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l))
		exit function
	end if
next
GetPakalpojums = GetNum(request.form("viet_veid"+cstr(rinda_p)+"_1"))
End Function

docstart "Pieteikumu pârskats","y1.jpg" %>


<p align="center"><font color="#008000" size="5"><b>Pieteikumu pârskats</b></font></p>

<hr>
<%
headlinks 



if session("message") <> "" then 
	%>
<p align="center"><br>
<font color="#FF0000" size="4"><%=session("message")%></font><br>
<%
	session("message") = ""
end if

DefJavaSubmit%>
</p>

<form method="POST" name="forma"  ACCEPT-CHARSET=windows-1257 action="">
<%%>    <div align="center"><center><table border="0">
        <tr>
            <td align="right" bgcolor="#ffc1cc">Reìistrâcijas datums no: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" maxlength="80"
            name="txtdatumsno" value="<%=DatumsNo%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Reìistrâcijas datums lîdz: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" name="txtdatumslidz" value="<%=DatumsLidz%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Izbraukðanas datums no: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" maxlength="80"
            name="izbrdatumsno" value="<%=izbrDatumsNo%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Izbraukðanas datums lîdz: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" maxlength="80"
            name="izbrdatumsLidz" value="<%=izbrDatumsLidz%>"></td>
      	</tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Atteikuma datums no: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" maxlength="80"
            name="AtteikumaDatumsNo" value="<%=AtteikumaDatumsNo%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Atteikuma datums lîdz: </td>
            <td bgcolor="#fff1cc"><input type="text" size="16" name="AtteikumaDatumsLidz" value="<%=AtteikumaDatumsLidz%>">
      	</tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Students </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chkstudents"
            <%if students = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Summa no:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="10"
            name="txtsummano" value="<%=SummaNo%>"></td>
        </tr>
        <tr>
            <td align="right"  bgcolor="#ffc1cc">Summa lîdz:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="10"
            name="txtsummalidz" value="<%=SummaLidz%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Negatîva bilance </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chkbilance"
            <%if chkbilance = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Kavçtâjs </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chkkavetajs"
            <%if chkkavetajs = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Pozitîva bilance </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chkpozbilance"
            <%if chkpozbilance = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Norakstîts </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chknorakstits"
            <%if chknorakstits = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Zilie </td>
            <td bgcolor="#fff1cc"><input type="checkbox" name="chkzilie"
            <%if chkzilie = "on" then response.write "checked"%>></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Dalîbnieka vârds: </td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="80"
            name="txtvards" value = "<%=vards%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Dalîbnieka uzvârds:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="80"
            name="txtuzvards" value = "<%=uzvards%>"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Reìistrçtâjs:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="80"
            value="<%=Registretajs%>" name = "txtRegistretajs"></td>
        </tr>
        <tr>
            <td align="right" bgcolor="#ffc1cc">Pieteikuma ID:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="10"
            name = "txtpid" value="<%=Pid%>"></td>
        </tr>
		<tr>
            <td align="right" bgcolor="#ffc1cc">Lîguma ID:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="10"
            name = "txtlid" value="<%=Lid%>"></td>
        </tr>
		<tr>
            <td align="right" bgcolor="#ffc1cc">Grupas veids:</td>
            <td bgcolor="#fff1cc">
			<% 
			set rGrVeidi = conn.execute("select * from grveidi ORDER By vards ASC")
			if not rGrVeidi.eof then
			%>
			<select name="gr_veids">
				<option value="0">-</option>
			<%
				while not rGrVeidi.eof
					%>
					<option value="<%=cstr(rgrVeidi("id"))%>" <% if gr_veids=cstr(rgrVeidi("id")) then rw "selected" %>><%=cstr(rGrVeidi("vards"))%></option>
					<%
					rGrVeidi.movenext
				wend
				%>
			</select>
				<%
			end if
					
			%>
			</td>
        </tr>
		<tr>
            <td align="right" bgcolor="#ffc1cc">Grupas kods:</td>
            <td bgcolor="#fff1cc"><input type="text" size="23" maxlength="23"
            name = "gr_kods" value="<%=gr_kods%>"></td>
        </tr>
        <tr>
            <td align="right"  bgcolor="#ffc1cc">Kompleksie pakalpojumi:</td>
            <td bgcolor="#fff1cc">
            <%
		grupa = kompgrupa
		for i = 1 to 3
			if i <> 1 then response.write "<br>"
			vid = GetPakalpojums(i)
			if vid = "" then vid = 0
			if request.form("Poga") = "Tîra forma" then vid = 0
			output = VietuVeidiCombo(grupa,vid,i,virsn,lim)
			if vid <> 0 then
				output = output + VietuVeidiSubCombo(vid,i,lim)
				lim = lim + 2
			else
				lim = lim + 1
			end if
			while lim<5
				output = output + "<span id = ""vieta" + cstr(i) + "_" + cstr(lim) + """></span>"
				lim = lim + 1
			wend
			while virsn<>0
				vid = virsn
				output = VietuVeidiCombo(grupa,vid,i,virsn,lim) + output
			wend
			response.write output
			GenerateComplexLevels grupa,i
		next
            %>
            </td>
        </tr>
        <tr>
            <td align="right"  bgcolor="#ffc1cc">Èarteru pakalpojumi:</td>
            <td bgcolor="#fff1cc">
            <%
		grupa = GetParameter("charter")
		for i = 4 to 6
			if i <> 1 then response.write "<br>"
			vid = GetPakalpojums(i)
			if vid = "" then vid = 0
			if request.form("Poga") = "Tîra forma" then vid = 0
			output = VietuVeidiCombo(grupa,vid,i,virsn,lim)
			if vid <> 0 then
				output = output + VietuVeidiSubCombo(vid,i,lim)
				lim = lim + 2
			else
				lim = lim + 1
			end if
			while lim<5
				output = output + "<span id = ""vieta" + cstr(i) + "_" + cstr(lim) + """></span>"
				lim = lim + 1
			wend
			while virsn<>0
				vid = virsn
				output = VietuVeidiCombo(grupa,vid,i,virsn,lim) + output
			wend
			response.write output
			GenerateComplexLevels grupa,i
		next
            %>
            </td>
        </tr>
        <tr> 
         <td align="right" bgcolor="#ffc1cc">Èartera firma:</td>
         <td bgcolor="#fff1cc"><%DbComboPlus "Carter_firmas","nosaukums","id","carter_firma",carter_firma%></td>
        </tr>
         <tr>
            <td align="right" bgcolor="#ffc1cc">Meklçt tikai<br>kompleksajâ grupâ:</td>
            <td bgcolor="#fff1cc">
              <select name=kompleks>
               <option value='V' <%if kompleks = "V" then response.write " selected "%>>Visi</option>
               <option value='K' <%if kompleks = "K" then response.write " selected "%>>Tikai kompleksie</option>
               <option value='I' <%if kompleks = "I" then response.write " selected "%>>Tikai ienâkoðie</option>
              </select>
            </td>
        </tr>
    </table>
            <input type="submit" name = "Poga" value="Meklçt!"></td>
            <input type="submit" name = "Poga" value="Tîra forma"></td>
    </center></div>
    <input type="hidden" name="self" value="true" >
</form>
<hr>
<!-- beidzas forma, sâkas atlasîtie dati -->
<%
if request.form("self")="true" and request.form("Poga") <> "Tîra forma" then 'ja neizsauc pati sevi, nedarît neko
	'Izveidot stâvokïa stringu pçc ievadîtajiem laukiem
	
	'Pârbauda vai vajag piesaistît dalîbnieku tabulu
	If Vards <> "" or Uzvards <> "" then 
		Stavoklis = Stavoklis + "1"
	else
		Stavoklis = Stavoklis + "0"
	end if
	
	'Pârbauda vai vajag piesaistît reìistrçtâju tabulu (piet_saite)
	If Registretajs <> "" then
		Stavoklis = Stavoklis + "1"
	else
		Stavoklis = Stavoklis + "0"
	end if

	'Parbauda vai vajag piesaistît pakalpojumu tabulu
	rstveidi.movefirst
	stopF = 0
	while (not rstVeidi.eof) and stopF = 0
			if request.form("checks"+cstr(rstVeidi("id"))) = "on" then stopF = 1
			rstVeidi.MoveNext
	wend
	if kompleks <> "V" then stopf = 0
	If StopF = 1 then
		Stavoklis = Stavoklis + "1"
	else
		Stavoklis = Stavoklis + "0"
	end if
	
	'if izbrDatumsNo <> "" or izbrDatumsLidz <> "" then
	
	'	Stavoklis = Stavoklis + "0"
	
	'end if
	
	
	'SQL Query for retrieving results
	Dim Query
	Dim rResults
	'Karogs, kas parâda vai kvçrija jau ir saformçta un izpildîta
	Dim Done
	Done = 0

	'Izvçlas pareizo SQL izteiksmi
	if Stavoklis = "000" then
		Query = "SELECT DISTINCT pieteikums.ID As ResultID FROM Pieteikums INNER JOIN piet_saite ps ON ps.pid = pieteikums.id INNER JOIN grupa g ON g.id = pieteikums.gid WHERE pieteikums.deleted = 0 "
	end if
	if Stavoklis = "001" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = Piet_saite.pid WHERE pieteikums.deleted = 0 and piet_saite.deleted = 0 "
	end if
	if Stavoklis = "010" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN LietotajuLog ON Pieteikums.ID = LietotajuLog.ieraksts WHERE LietotajuLog.Tabula = 1 and  Pieteikums.deleted = 0 "
	end if
	if Stavoklis = "011" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"(Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = Piet_saite.pid) INNER JOIN LietotajuLog ON Pieteikums.ID = LietotajuLog.ieraksts WHERE LietotajuLog.Tabula = 1 and pieteikums.deleted = 0 and piet_saite.deleted = 0 "
	end if
	if Stavoklis = "100" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"(Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = piet_saite.pid) INNER JOIN Dalibn ON piet_saite.did = dalibn.id WHERE pieteikums.deleted = 0 and piet_saite.deleted = 0 and dalibn.deleted = 0 "
	end if
	if Stavoklis = "101" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"(Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = Piet_saite.pid) INNER JOIN Dalibn ON Piet_Saite.did = dalibn.id WHERE pieteikums.deleted = 0 and piet_saite.deleted = 0 and dalibn.deleted = 0 "
	end if
	if Stavoklis = "110" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"((Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = Piet_saite.pid) INNER JOIN Dalibn ON Piet_Saite.did = dalibn.id) INNER JOIN LietotajuLog ON Pieteikums.ID = LietotajuLog.ieraksts WHERE LietotajuLog.Tabula = 1 and pieteikums.deleted = 0 and piet_saite.deleted = 0 and dalibn.deleted = 0 "
	end if
	if Stavoklis = "111" then
		Query = "SELECT DISTINCT Pieteikums.ID As ResultID FROM " + _
			"((Pieteikums INNER JOIN grupa g ON g.id = pieteikums.gid INNER JOIN Piet_saite ON Pieteikums.ID = Piet_saite.pid) INNER JOIN Dalibn ON Piet_Saite.did = dalibn.id) INNER JOIN LietotajuLog ON Pieteikums.ID = LietotajuLog.ieraksts WHERE LietotajuLog.Tabula = 1 and pieteikums.deleted = 0 and piet_saite.deleted = 0 and dalibn.deleted = 0 "
	end if
	

	'If DatumsNo <> "" then Query = Query + " AND Datums>='"+SQLDate(DatumsNo)+"' "
	'If DatumsNo <> "" then Query = Query + " AND (time_stamp>='"+SQLDate(DatumsNo)+"' OR Datums >= '"+SQLDate(DatumsNo)+"')" 
	'If DatumsLidz <> "" then Query = Query + " AND (Datums<'"+SQLDate(FormatedDate(DatumsLidz,"dmy")+1)+"' OR time_stamp<'"+SQLDate(FormatedDate(DatumsLidz,"dmy")+1)+"')"
	
	If DatumsNo <> "" then
		where_dat_no = "Datums>='"+SQLDate(DatumsNo)+"'"
		where_ts_no = "time_stamp>='"+SQLDate(DatumsNo)+"'"
	else
		where_dat_no = "1=1"
		where_ts_no = "1=1"
	End if
	
	If DatumsLidz <> "" then
		where_dat_lidz = "Datums<'"+SQLDate(FormatedDate(DatumsLidz,"dmy")+1)+"'"
		where_ts_lidz = "time_stamp<'"+SQLDate(FormatedDate(DatumsLidz,"dmy")+1)+"'"
	else
		where_dat_lidz = "1=1"
		where_ts_lidz = "1=1"
	End if
	
	Query = Query + " AND ( ("+ where_dat_no+" AND "+where_dat_lidz+") OR ("+ where_ts_no+" AND "+where_ts_lidz+") )"
	
	If izbrDatumsNo <> "" then 
		if kompleks = "V" then
			Query = Query + " AND (g.sakuma_dat>='"+SQLDate(izbrDatumsNo)+"' OR ((g.kods like 'K.%' or g.kods like 'I.%') AND sakuma_Datums>='"+SQLDate(izbrDatumsNo)+"') )"
		else
			Query = Query + " AND sakuma_Datums>='"+SQLDate(izbrDatumsNo)+"' "
		end if
	end if
	
	

	If izbrDatumsLidz <> "" then 
		if kompleks = "V" then
			Query = Query + " AND (g.sakuma_dat<'"+SQLDate(FormatedDate(izbrDatumsLidz,"dmy")+1)+"' OR ((g.kods like 'K.%' or g.kods like 'I.%') AND sakuma_Datums<'"+SQLDate(FormatedDate(izbrDatumsLidz,"dmy")+1)+"') )"
		else
			Query = Query + " AND sakuma_Datums<'"+SQLDate(FormatedDate(izbrDatumsLidz,"dmy")+1)+"' "
		end if
	end if
	
	If AtteikumaDatumsNo <> "" then 
		Query = Query + " AND dat_atcelts >='"+SQLDate(AtteikumaDatumsNo)+"' "
	end if

	If AtteikumaDatumsLidz <> "" then 
		Query = Query + " AND dat_atcelts <'"+SQLDate(FormatedDate(AtteikumaDatumsLidz,"dmy")+1)+"' "
	end if

	'If izbrDatumsNo <> "" then Query = Query + " AND sakuma_Datums>='"+SQLDate(izbrDatumsNo)+"' "
	'If izbrDatumsLidz <> "" then Query = Query + " AND sakuma_Datums<'"+SQLDate(FormatedDate(izbrDatumsLidz,"dmy")+1)+"' "
	
	If Students = "on" then Query = Query + " AND Students = true "
	If cstr(SummaNo) <> "" and cstr(SummaNo) <> "0" then Query = Query + " AND Pieteikums.Summa >= " + sqlnum(SummaNo) + " "
	If cstr(SummaLidz) <> "" and cstr(SummaLidz) <> "0" then Query = Query + " AND Pieteikums.Summa <= " + SummaLidz + " "
	if chkbilance = "on" then query = query + " AND (bilanceLVL<0 or bilanceUSD<0 or bilanceEUR<0) " 
	if chkpozbilance = "on" then query = query + " AND (bilanceLVL>0 or bilanceUSD>0 or bilanceEUR>0) " 
	if chkkavetajs = "on" then query = query + " AND Pieteikums.ID in (select P.ID from pieteikums P, grupa G where (P.gid = G.id) and (((GetDate() >= G.term1_dat) and (iemaksasLVL-izmaksasLVL+atlaidesLVL<G.term1_summa)) or ((GetDate() >= G.term2_dat) and (iemaksasLVL-izmaksasLVL+atlaidesLVL<G.term2_summa)) or ((GetDate() >= G.term3_dat) and (bilanceLVL<0)))) " 
	if chknorakstits = "on" then query = query + " AND (norakstitsLVL<>0 or norakstitsUSD<>0 or norakstitsEUR<>0) " 
	If chkzilie = "on" then Query = Query + " AND krasa = 'B' "
	If Vards <> "" then Query = Query + " AND Vards LIKE '%"+Vards+"%' "
	If Uzvards <> "" then Query = Query + " AND Uzvards LIKE '%"+uzvards+"%' "
	If Registretajs <> "" then 
		Query = Query + " AND Lietotajs = " + Cstr(ReturnUserID(Registretajs)) + " AND Darbiba = 'A' "
		if ReturnUserid(registretajs) = 0 then response.write "<center><font color = red><b>Tads registretajs neeksistç.<b><br></font>"
	end if
	If Pid <> "" then Query = Query + " AND Pieteikums.ID = " + Pid + " "
	If Lid <> "" then Query = Query + " AND (Pieteikums.ligums_id = " + Lid + ") OR (isnull(online_rez,0) in (select id from online_rez where ligums_id =  " + Lid + "))"
	If kompleks = "K" then 
		Query = Query + " AND Pieteikums.GID IN (select id from grupa where kods like 'K%') "
		rstveidi.movefirst
		for m = 1 to 6
			if CSTR(GetPakalpojums(m)) <> "0" then
					query = query + " AND EXISTS (SELECT vietas_veids FROM Piet_saite WHERE pid = pieteikums.id and vietas_veids IN (" + GetPakalpojumsSet(cstr(GetPakalpojums(m))) + ")) "
			end if
		next
	end if
	if kompleks = "I" then
		Query = Query + " AND Pieteikums.GID IN (select id from grupa where kods like 'I%') "
	end if
	if carter_firma <> "0" then
	 Query = Query + " AND carter_firma = "+carter_firma+" "
	end if
    if (gr_veids <> "0") then
		Query = Query + " AND Pieteikums.GID IN (select id from grupa where VEIDS="+gr_veids+" )"
	end if
	if (gr_kods <>"") then
		Query = Query + " AND Pieteikums.GID IN (select id from grupa where kods LIKE '%"+gr_kods+"%')"
	end if
    query = query + " ORDER BY pieteikums.id"
    
	
   'Response.Write(Stavoklis+"<br />")
   'Response.Write query
   ' Response.End
        
	set rResults = server.createobject("ADODB.Recordset")
	rResults.open Query,conn,3,3
 if not rresults.eof then
  %><center>
  Atrasto pieteikumu skaits <%=rResults.recordcount%>
  <table border = 1>
  <tr>
  <th>Nr</th>
  <th>Pieteikuma apraksts</th>
  <th>Pakalpojums</th>
  <th>Reì.</th>
  <th>Summa</th>
  <th>Norakstîts</th>
  <th>Bilance</th>
  </tr>
  <%
  while not rresults.eof
   set rPiet = conn.execute ("SELECT id,info,piezimes,summa,summaLVL,summaUSD,summaEUR,atlaidesLVL,atlaidesUSD,atlaidesEUR,sadardzinLVL,sadardzinUSD,sadardzinEUR,bilance,bilanceLVL,bilanceUSD,bilanceEUR,norakstitsLVL,norakstitsUSD,norakstitsEUR,ISNULL(sakuma_datums,'') as sakuma_datums,ISNULL(beigu_datums,'') as beigu_datums,agents_izv,tmp,internets,isnull(profile_id,0) as profile_id,gid FROM Pieteikums WHERE ID = " + cstr(rResults("ResultID")))
   grupa_id = rPiet("gid")
   
   sakuma_datums = rPiet("sakuma_datums")
 
   beigu_datums = rPiet("beigu_datums")
   'rw "SELECT * FROM grupa where id="+ cstr(grupa_id)
   if (DatePrint(sakuma_datums)="" and DatePrint(sakuma_datums)="") then
   set rGrupa = conn.execute("SELECT * FROM grupa where id="+ cstr(grupa_id))
   if (not rGrupa.eof) then
	sakuma_datums = rGrupa("sakuma_dat")
	beigu_datums = rGrupa("beigu_dat")
   end if
   end if
   pietsumma = Curr3Print(rPiet("summaLVL"),rPiet("summaUSD"),rPiet("summaEUR"))
   pietbilance = Curr3Print(rPiet("bilanceLVL"),rPiet("bilanceUSD"),rPiet("bilanceEUR"))
   summaLVL = summaLVL + getnum(rPiet("summaLVL"))
   summaUSD = summaUSD + getnum(rPiet("summaUSD"))
   summaEUR = summaEUR + getnum(rPiet("summaEUR"))
   bilanceLVL = bilanceLVL + getnum(rPiet("bilanceLVL"))
   bilanceUSD = bilanceUSD + getnum(rPiet("bilanceUSD"))
   bilanceEUR = bilanceEUR + getnum(rPiet("bilanceEUR"))
   norakstitsLVL = norakstitsLVL + getnum(rPiet("norakstitsLVL"))
   norakstitsUSD = norakstitsUSD + getnum(rPiet("norakstitsUSD"))
   norakstitsEUR = norakstitsEUR + getnum(rPiet("norakstitsEUR"))
   piet_id = rPiet("id")
   pietinfo = rPiet("info")
   set rPakalp = conn.execute ("SELECT nosaukums FROM Piet_saite INNER JOIN Vietu_veidi ON Piet_saite.vietas_veids = vietu_veidi.id WHERE PID = " + cstr(rResults("ResultID")))
   
   if rPiet("agents_izv") = true then
		fstyle = " style='color: #0060ff'"
	elseif (rPiet("tmp") = 0 and rPiet("internets") = true) then '   and rPiet("profile_id")<>0 
		fstyle = " style='color: green;';" '8b4513 a7750b font-weight: bold;
	else
		fstyle = ""
	end if
   
   %><tr<%=fstyle%> valign = top>
    <td><a<%=fstyle%> target = none href = "pieteikums.asp?pid=<%=piet_id%>"><%=piet_id%></a></td>
    <td><%=pietinfo%>
	<%
	'--- 28.09.2023 Nils, lauks papildinats ar celojuma nosaukumu, no kura nauda ir ieskaitita uz avansu (kad atsakaas).
	if InStr(pietinfo, "!Avanss") > 0 or InStr(pietinfo, "!Zaud") > 0 then
		'–-- mekle orderi, lai iegutu info.
		set rOrderis = conn.execute ("SELECT pamatojums FROM orderis WHERE pid = " + cstr(piet_id))
		if (not rOrderis.eof) then
			response.write  "<br>" + rOrderis("pamatojums") 
		end if
	end if
	%>
     <%' if DatePrint(rPiet("sakuma_datums"))<>"" then response.write "<br>Sak.dat.:"+DatePrint(rPiet("sakuma_datums"))+"."%>
     <% 'if DatePrint(rPiet("beigu_datums"))<>"" then response.write "<br>Beig.dat.:"+DatePrint(rPiet("beigu_datums"))+"."%>
	 <% if DatePrint(sakuma_datums)<>"" then response.write "<br>Sâk.dat.:"+DatePrint(sakuma_datums)+"."%>
     <% if DatePrint(beigu_datums)<>"" then response.write "<br>Beig.dat.:"+DatePrint(beigu_datums)+"."%>
     <%="<i><br>"+rPiet("piezimes")+"</i>"%>
    </td>
    <td><%
     while not rPakalp.eof 
      response.write rPakalp("Nosaukums")+"<br>" 
      rPakalp.movenext
     wend
     rPakalp.close
    %></td>
    <td><%
     'set rLog = conn.execute("SELECT lietotajs FROM LietotajuLog where tabula = 1 and darbiba = 'A' and ieraksts = " + cstr(piet_id))
     'if not rLog.eof then 
     ' set rLiet = conn.execute("SELECT Lietotajs from Lietotaji where id = " + cstr(rLog("lietotajs")))
     ' if not rLiet.eof then response.write rLiet("Lietotajs")
     'end if
     %></td>
     <td><%=pietsumma%>
      <% if  curr3print(rPiet("sadardzinLVL"),rPiet("sadardzinUSD"),rPiet("sadardzinEUR"))<>"0.00" then %>
       <br>Piemaksas:<%=curr3print(rPiet("sadardzinLVL"),rPiet("sadardzinUSD"),rPiet("sadardzinEUR"))%>
      <% end if %>
      <% if  curr3print(rPiet("atlaidesLVL"),rPiet("atlaidesUSD"),rPiet("atlaidesEUR"))<>"0.00" then %>
       <br>Atlaides:<%=curr3print(rPiet("atlaidesLVL"),rPiet("atlaidesUSD"),rPiet("atlaidesEUR"))%>
      <% end if %>
     </td>
     <td><%=curr3print(rPiet("norakstitsLVL"),rPiet("norakstitsUSD"),rPiet("norakstitsEUR"))%></td>
     <td><%=pietbilance%></td>
   </tr><%
   rresults.movenext
  wend
  %>
  <tr>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th>
   <%=curr3print(summaLVL,summaUSD,summaEUR)%>
  </th>
  <th><%=curr3print(norakstitsLVL,norakstitsUSD,norakstitsEUR)%></th>
  <th><%=curr3print(bilanceLVL,bilanceUSD,bilanceEUR)%></th>
  </tr>
  <%
 else
  %><br>
  <font size = 5><center>Nav atrasts neviens pieteikums</center></font><%
 end if
end if
%>
</body>
</html>
