<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- jQuery FIRST -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Then Select2 -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<style>
/* Tooltip container */
.tooltip {
  position: relative;
  display: inline-block;
  border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
}

/* Tooltip text */
.tooltip .tooltiptext {
  visibility: hidden;
  width: 220px;
  background-color: #555;
  color: #fff;
  text-align: left;
  padding: 5px ;
  border-radius: 6px;

  /* Position the tooltip text */
  position: absolute;
  z-index: 1;
  bottom: 12%;
  left: -150%;
  margin-left: -60px;

  /* Fade in tooltip */
  opacity: 0;
  transition: opacity 0.3s;
}

/* Tooltip arrow */
.tooltip .tooltiptext::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: #555 transparent transparent transparent;
}
/* Document dialog box */
.ui-dialog-title {
	display:none;
}
.ui-widget-content{
border: 1px solid black;
background-color:#fff;
}
.ui-dialog-content {
padding:5%;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}
</style>


<%
'Header
dim conn
openconn
docstart "Atrodi savu ceïojumu","y1.jpg"

vecas = cstr(request.querystring("vecas"))
visi_veidi = cstr(request.querystring("visi_veidi"))
kartot = cstr(Request.form("kartot"))
kurators = cstr(Request.form("kurators"))
vaditajs = cstr(Request.form("vaditajs"))
kontrolieris2 = cstr(Request.form("kontrolieris"))

orderby = ""


if kartot = "" then kartot = "5"

if kartot = "5" then 
 orderby = "m.v,g.sakuma_dat"
elseif kartot = "1" then
 orderby = "g.kods,m.v"
elseif kartot = "2" then
 orderby = "g.sakuma_dat,g.beigu_dat"
elseif kartot = "3" then
 orderby = "g.beigu_dat,g.sakuma_dat"
elseif kartot = "4" then
 orderby = "g.i_cena,m.v"
end if

''response.write orderby

veids = Request.Form("veids")

v = Request.Form("v")
%>
<center><font color="GREEN" size="5"><b>Atrodi savu ceïojumu!</b></font><hr>
<%headlinks%>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form
filt = "on"
if filt = "on" then%>
<form action="out_grupa.asp?vecas=<%=vecas%>&visi_veidi=<%=visi_veidi%>" method="POST" name=forma>

<tr>
 <td align="right" bgcolor="#ffc1cc">Ceïojums sâkas <b>ne agrâk par: </td>
 <td bgcolor="#fff1cc">
  <input type="text" size="10" maxlength="10" name="dat1" value="<%=Request.Form("Dat1")%>">
 <b>ne vçlâk par:</b> 
  <input type="text" size="10" maxlength="10" name="dat2" value="<%=request.form("dat2")%>"></td>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Kods <b></td>
 <td bgcolor="#fff1cc"><input type="text" size="10" maxlength="25" name="kods" value="<%=request.form("kods")%>"> 
 </td>
</tr>
<%' if cstr(vecas)<>"1" then %>
<tr>
 <td align="right" bgcolor="#ffc1cc">Valsts <b></td>
 <td bgcolor="#fff1cc">
<%Dim valstis: Set valstis = conn.execute("select id, ltrim(title) as title from valstis where globa = 1 order by dbo.fn_str_to_num(ltrim(title)) asc")
%>
<div style="width:300px">
<select name=valsts id="valsts">
<option value="---Visas">-</option>
<%

valID = "---Visas"
while not valstis.eof
 Response.Write "<option "
 if request.form("valsts") = cstr(valstis("id")) then response.write "selected"
 response.write " value='" & cstr(valstis("id")) & "'>" & valstis("title") & "</option>"
 valstis.MoveNext
wend

 %></select>
</div>


 </td>
</tr>
<%' else %>
<%'  <input type=hidden name=valsts value="---Visas">%>
<%' end if %>

<tr>
 <td align="right" bgcolor="#ffc1cc">Kurators: </td>
 <td bgcolor="#fff1cc">
    <select name=kurators>
	<option value="0">-</option>
	<% 
	set rKurators = conn.execute( _
		"select vards as v, * " & _
		"from lietotaji " & _
		"where exists ( " & _
		"    select * " & _
		"    from tiesibusaites " & _
		"    where lietotajsid = lietotaji.id " & _
		"      and tiesibasid = 12 " & _
		") AND " & _
		" id in (select distinct kurators from grupa where sakuma_dat >= getdate())" & _
		" order by dbo.fn_str_to_num(ltrim(vards))" _
	)	
	while not rKurators.eof
	 response.write "<option value="+cstr(rKurators("id"))+" "
	 if cstr(rKurators("id")) = kurators then response.write " selected "
	 response.write ">"+rKurators("vards")+" "+rKurators("uzvards")
	 response.write "</Option>"
	 rKurators.movenext
	wend
	%></select>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Vadîtâjs </td>
 <td bgcolor="#fff1cc">
	<div style="width:300px">
    <select name=vaditajs id=vaditajs>
	<option value="0">-</option>
	<% set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by dbo.fn_str_to_num(ltrim(vards))")
	while not rVaditajs.eof
	 response.write "<option value="+cstr(rVaditajs("idnum"))+" "
	 if cstr(rVaditajs("idnum")) = vaditajs then response.write " selected "
	 response.write ">"+rVaditajs("vards")+" "+rVaditajs("uzvards")
	 response.write "</Option>"
	 rVaditajs.movenext
	wend
	%></select></div>
</tr>
<tr>
	<td align=right bgcolor="#ffc1cc">Kontrolieris: </td>
	<td><select name=kontrolieris>
			  <option value="0">-</option>
			  <% set rKurators = conn.execute("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by dbo.fn_str_to_num(ltrim(vards)) ")
			  while not rKurators.eof
				response.write "<option value="+cstr(rKurators("id"))+" "
				if cstr(rKurators("id")) = kontrolieris2 then response.write " selected "
				response.write ">"+rKurators("v")+" "+rKurators("uzvards")
				response.write "</Option>"
				response.write "</Option>"
			   rKurators.movenext
			  wend
			  %></select>&nbsp;
	</td>
</tr>

<tr><td align="right" bgcolor="#ffc1cc">	
 

<% if vecas = "" then %>
 <a HREF="out_grupa.asp?vecas=1&visi_veidi=<%=visi_veidi%>">[Aktuâlie marðruti]</a>
<% else %>
 <a HREF="out_grupa.asp?visi_veidi=<%=visi_veidi%>">[Visi marðruti]</a>
<% end if %>
&nbsp;
<% if visi_veidi="" then %>
 <a href="out_grupa.asp?vecas=<%=vecas%>&visi_veidi=1">[Vâktâs]</a>
<% end if %>

	</td><td bgcolor="#fff1cc">
<%
if cstr(vecas)="1" then
 if visi_veidi = "1" then
  Set grupas = conn.execute("select * from marsruts ORDER BY /*replace(v2,'#','')*/ dbo.fn_str_to_num(ltrim(marsruts.v))")
 else
  Set grupas = conn.execute("select * from marsruts where id in (select mid from grupa where veids = 1) ORDER BY /*replace(v2,'#','')*/ dbo.fn_str_to_num(ltrim(marsruts.v))")
 end if
else
 if visi_veidi="1" then
	 ssql = "SELECT distinct marsruts.v, replace(v2,'#',''), dbo.fn_str_to_num(ltrim(marsruts.v)),marsruts.ID FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>('"+sqldate(now-1)+"'))) ORDER BY /*replace(v2,'#','')*/ dbo.fn_str_to_num(ltrim(marsruts.v))"
	 'rw ssql
	Set grupas = conn.execute(ssql)
 else
	ssql = "SELECT distinct marsruts.v, replace(v2,'#',''),dbo.fn_str_to_num(ltrim(marsruts.v)), marsruts.ID FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>('"+sqldate(now-1)+"'))) and grupa.veids = 1 ORDER BY /*replace(v2,'#','')*/ dbo.fn_str_to_num(ltrim(marsruts.v))"
	''rw ssql
  Set grupas = conn.execute(ssql)
 end if
end if 
%>
<input type=text name=fin size=4 LANGUAGE=javascript onkeypress="find_group(event.keyCode);">
<select name=marsruts size=1>
<option value=0>---Visi</option>
<%

marsID = 0
if visi_veidi="" and vecas="" then
	Set klubins = conn.execute("SELECT marsruts.v, marsruts.ID, grupa.sakuma_dat FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>('"+sqldate(now-1)+"'))) and v like 'klubi%' ORDER BY grupa.sakuma_dat ")
	while not klubins.eof
	 Response.Write "<option "
	 if request.form("marsruts") = cstr(klubins("id")) then response.write "selected"
	 response.write " value='" & cstr(klubins("ID")) & "'>" & dateprint(klubins("sakuma_dat")) & " " & klubins("v") & "</option>"
	 klubins.MoveNext
	wend
end if



while not grupas.eof
 Response.Write "<option "
 if request.form("marsruts") = cstr(grupas("id")) then response.write "selected"
 response.write " value='" & cstr(grupas("ID")) & "'>" & grupas("v") & "</option>"
 grupas.MoveNext
wend

%></select>
<tr>
  <td align="right" bgcolor="#ffc1cc">Nosaukums satur: </td>
  <td bgcolor="#fff1cc"><input type=text name=v value="<%=v%>" size=20 autocomplete="off"></td>
</tr>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Grupas veids: </td><td bgcolor="#fff1cc">
<%
Set veidi = conn.execute("select * from grveidi order by vards")
Response.Write "<select name=veids>"
Response.Write ("<option value=0 selected>Visi</option>")
while not veidi.eof
 Response.Write "<option "
 if veids = cstr(veidi("id")) then response.write " selected "
 response.write " value='" & cstr(veidi("ID")) & "'>" & veidi("vards") & "</option>"
 veidi.MoveNext
wend
Response.write " </select>" & Chr(10)
%>
</tr>

<tr>
<%if vecas="1" then%>

<td align="right" bgcolor="#ffc1cc">Bijuðie vai nâkamie braucieni</td>
	<td bgcolor="#fff1cc"><select name="time" size="1">
	<option value="0"<%if request.form("time") = "0" then response.write " selected "%>>Nâkamie</option>
	<option value="1"<%if request.form("time") = "1" then response.write " selected "%>>Bijuðie</option>
	<option value="2"<%if request.form("time") = "2" or  request.form("time") = "" then response.write " selected "%>>Visi</option>
	</select>
</td>
</tr><tr>
<%end if%>
<td align="right" bgcolor="#ffc1cc">Tikai klubiòa pasâkumi</td>
<td bgcolor="#fff1cc">
 <input type=checkbox name=klubins <%if Request.Form("klubins") = "on" then Response.Write "checked"%>>
</td>
</tr>
<tr>

<td align="right" bgcolor="#ffc1cc">Íçde</td>
<td bgcolor="#fff1cc">
 <select name="kede">
			<option></option>
			<% for i=1 to 25 step 1
				%><option value="<%=i%>" <% if request.form("kede") = cstr(i) then response.write "selected"%>><%=i%>.</option><%
			next%></select>
</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Izbraukðanas vieta</td>
	<td bgcolor="#fff1cc">
		<select name=izbr_vieta>
			<%izbr_vieta = request.form("izbr_vieta")%>
			  <option value=0 <%if izbr_vieta=0 then Response.Write("selected")%>><%=getIVieta(0)%></option>
			  <option value=1 <%if izbr_vieta=1 then Response.Write("selected")%>><%=getIVieta(1)%></option>
			  <option value=2 <%if izbr_vieta=2 then Response.Write("selected")%>><%=getIVieta(2)%></option>
			  <option value=3 <%if izbr_vieta=3 then Response.Write("selected")%>><%=getIVieta(3)%></option>
			  <option value=4 <%if izbr_vieta=4 then Response.Write("selected")%>><%=getIVieta(4)%></option>
			  <option value=5 <%if izbr_vieta=5 then Response.Write("selected")%>><%=getIVieta(5)%></option>
			  <option value=6 <%if izbr_vieta=6 then Response.Write("selected")%>><%=getIVieta(6)%></option>			  
			  <option value=7 <%if izbr_vieta=7 then Response.Write("selected")%>><%=getIVieta(7)%></option>			  
			  <option value=8 <%if izbr_vieta=8 then Response.Write("selected")%>><%=getIVieta(8)%></option>			  
			  <option value=9 <%if izbr_vieta=9 then Response.Write("selected")%>><%=getIVieta(9)%></option>			  
			  <option value=10 <%if izbr_vieta=10 then Response.Write("selected")%>><%=getIVieta(10)%></option>			  
			  <option value=11 <%if izbr_vieta=11 then Response.Write("selected")%>><%=getIVieta(11)%></option>			  
			  <option value=12 <%if izbr_vieta=12 then Response.Write("selected")%>><%=getIVieta(12)%></option>			  
			  <option value=13 <%if izbr_vieta=13 then Response.Write("selected")%>><%=getIVieta(13)%></option>			  
			</select>
		</td>
	</tr>
</table>
<input type="hidden" name="subm" value="1"> 
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem." WIDTH="25" HEIGHT="25"> 
<% End if 

if request.form("subm") = "1"  then 
'analîze
'param = "dat1="+Request.Form("dat1")+";dat2="+Request.Form("dat2")+";kods="+Request.Form("kods")+";marsruts="+Request.Form("marsruts")+";v="+Request.Form("v")+";veids="+veids+";time="+Request.Form("time")
'param = SQLText(param)
'conn.execute "INSERT INTO analize (laiks,forma,parametri,lietotajs) VALUES ('"+SQLTime(now)+"','out_grupa','"+param+"','"+get_user+"')"


'Creating SQL
qb="FROM grupa g left join lietotaji li on g.kurators=li.id left join lietotaji li2 on g.kontrolieris=li2.id left join marsruts m  on g.[mID]=m.ID left join vietas on vietas.gid = g.id where 1=1 "

if Request.Form ("klubins") = "on" then
 qb = qb + " AND g.veids = 8 " 'm.klubins=1 "
end if
if vecas = "" then
	qb = qb + " and m.old=0 "
end if
if request.form("marsruts") <> "0" then
	qb = qb + " AND m.id = "+request.form("marsruts") + " "
end if
kods = Request.Form("kods")
if request.form("kods") <> "" then
    kods = Code_Update(kods)
	qb = qb + " AND g.kods LIKE '"+cstr(kods) + "%' "
end if
if Request.Form("valsts") <> "---Visas" and Request.Form("valsts") <> "" then
 qb = qb + " AND m.valsts = '" & Request.Form("valsts") & "' "
end if
if veids <> "0" then
	qb = qb + " AND g.veids = "+veids + " "
end if
if request.form("dat1") <> "" then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(FormatedDate(request.form("dat1"),"dmy")) + "' "
end if
if request.form("dat2") <> "" then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(1+FormatedDate(request.form("dat2"),"dmy")) + "' "
end if
if request.form("time") = "" or request.form("time") = 0 then
	qb = qb + " AND g.beigu_dat >= '"+SQLDate(now()-2) + "' "
end if
if request.form("time") =  1 then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(now()) + "' "
end if
if kurators <> "" and kurators<>"0" then
    qb = qb + " AND g.kurators = " +cstr(kurators)
end if
if vaditajs <> "" and vaditajs <>"0" then
    qb = qb + " AND (g.vaditajs = " +cstr(vaditajs) + "or g.vaditajs2 = "+CStr(vaditajs)+") " 
end if

if kontrolieris2 <> "" and kontrolieris2<>"0" then
    qb = qb + " AND g.kontrolieris = " +cstr(kontrolieris2)
end if
if v <> "" then
    qb = qb + " AND upper(v) like upper('%"+v+"%')"
end if

if request.form("kede") <> "" then
	qb = qb + " AND g.kede = '"+request.form("kede") + "' "
end if

if request.form("izbr_vieta") <> 0 then
	qb = qb + " AND g.izbr_vieta = '"+request.form("izbr_vieta") + "' "
end if

if isaccess(T_DROSIBA) then
    ''qb = qb + " AND kods in (select num from sk_karinas_grupas) " 
end if

'lai nerâdîtu TEST Grupas
qb  = qb + " AND (g.TESTAM!=1 OR g.TESTAM IS NULL) "

''Response.write qb
set rAktivas = conn.execute("select count(*) " + qb + " and atcelta = 0 ")

qb = qb + " ORDER by " & orderby & " "
qf="SELECT top 300 g.*,dbo.fn_brivas_vietas(g.id) as vietas, m.ID as marID,m.v,m.cena,g.i_cena,m.valsts,kurators,g.autobuss as autobusa_piezimes, "

'qf=qf+"(select sum(personas) from pieteikums p where deleted = 0 and gid = g.id and (isnull(tmp,0)=0 OR agents_izv=1) and (isnull(piezimes,'') not like 'GRUPAS VAD_T_JS') and exists (select id from piet_saite where pid = p.id and deleted = 0)	) as pieteikumi, "
qf=qf+"(select sum(personas) from pieteikums p where deleted = 0 and gid = g.id and (isnull(tmp,0)=0 OR agents_izv=1) and (isnull(grupas_vad,0) = 0 /*isnull(piezimes,'') not like 'GRUPAS VAD_T_JS'*/) and exists (select id from piet_saite where pid = p.id and deleted = 0)	) as pieteikumi, "

qf=qf+"(select sum(papildvietas) from pieteikums where deleted = 0 and gid = g.id and (isnull(tmp,0)=0 OR agents_izv=1) ) as papildvietas, "
qf=qf+"(select count(*) from interesenti where gid = g.id) as cid, " + _
"(select vards+' '+uzvards from lietotaji where id = g.kontrolieris) as k_vu, " +_
"(select nosaukums from autobusi where id = g.autobuss_id) as autobuss, " + _
"/*(select top 1 pdf from portal.dbo.grupas p where p.gr_kods = g.kods AND pdf IS NOT NULL) as pdf*/ " +_
"g.pdf as pdf "
qf=qf+qb
'rw qf
set f = server.createobject("ADODB.Recordset")
f.open qf,conn,3,3



'Response.Write qf
qc=f.recordcount

Response.Write "<BR>"
response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"grupa","grupas") + "<br>"
response.write "Bez atceltajâm: " + cstr(rAktivas(0))
if qc<300 then 
%>
<input type=hidden name="kartot" value="<%=kartot%>">
<p>
<table>
<tr bgcolor="#ffc1cc">
<td><p align="center"></td>
<td><p align="center"><a href="#" onclick="forma.kartot.value='1';document.forma.submit();return false;">Kods</a></td>
<td><p align="center">Avio vietas</td>
<td><p align="center">Vietas autob.</td>
<td><p align="center">Vietas naktsm.</td>

<td><p align="center">Pers.</td>
<td><p align="center">Pap.v.</td>
<td><p align="center">Brîvs</td>
<td><p align="center">Interesenti</td>
<td><p align="center"><a href="#" onclick="forma.kartot.value='5';document.forma.submit();return false;">Nosaukums</a></td>
<td><p align="center"><a href="#" onclick="forma.kartot.value='2';document.forma.submit();return false;">Sâkuma datums</a></td>
<td><p align="center"><a href="#" onclick="forma.kartot.value='3';document.forma.submit();return false;">Beigu datums</a></td>
<td><p align="center"><a href="#" onclick="forma.kartot.value='4';document.forma.submit();return false;">Cena <br>(EUR ar PVN)</a></td>
<td><p align="center">Vadîtâjs</td>
<td><p align="center">Grupas sapulce</td>
<!--td><p align="center">Val</td-->
<td><p align="center">Lidojums / Kurators</td>
<td><p align="center">Íçde</td>
<td><p align="center">Skatîjumu skaits www</td>
<td><p align="center">Piezîmes</td>
</tr>

<%
pieteikumi_kopa = 0
while not f.eof
'Printing table
%>
  <%if f("ATCELTA") = true then c = "RED" else c = "GREEN"%>
  <tr bgcolor="#fff1cc" >
    <td><a href="grupa_edit.asp?gid=<%=f("id")%>" target="_blank">G</a></td>
    <td><font color=<%=c%> size="3"><%=f("kods")%>
		<% if f("pdf")<>"" then%>
		<br>
		<font size=2><a href="https://www.impro.lv/pdf/<%=f("pdf")%>.pdf" target="_blank">Apraksts</a></font>
		<% end if%>
		
		<% if f("garantets") then %>
			<% if f("pdf")<>"" then %>
				/ 
			<% else %>
				<BR>
			<% end if %>
		<font size=2 color=brown>Garantçts</font>
		<% end if%>
	</td>
	<td align=center><font color=<%=c%> size="3"><%=GetNum(f("avio_vietas"))%></td>
    <td align=center><font color=<%=c%> size="3"><%=GetNum(f("vietsk"))%></td>
    <td align=center><font color=<%=c%> size="3"><%=GetNum(f("vietsk_nakts"))%></td>
	
   
    <td align=center><font color=<%=c%> size="3">
		<a href="pieteikumi_grupaa.asp?gid=<%=cstr(f("id"))%>">
			<% 
			'vietu skaits aprekinaats no tabulas piet_saites
			Response.write(GetNum(f("pieteikumi"))) 
			pieteikumi_kopa = pieteikumi_kopa + GetNum(f("pieteikumi"))
			
			'vaktajaam grupaam
			'ja skaits nesakriit ar pieteikumu skaitu grupaa, izvada atskiriibu, kas signalizee ka grupaa ir kads nekorekts pieteikuma ieraksts
			''if instr(f("kods"),".V.") and GetNum(f("pieteikumi"))<>0 then
			''	if GetNum(f("personas"))<>GetNum(f("pieteikumi")) then
			''		Response.write("<br><font color=blue size=3>(piet. skaits "&GetNum(f("pieteikumi"))&"!)</font> ") 
					'Response.write("<br>"&cstr(f("pieteikumi")) ) 													
			''	end if
			''end if

			%>
		</a>
	</td>
    <td align=center><font color=<%=c%> size="3"><%=GetNum(f("papildvietas"))%></td>

	<%

	%>

    <td align=center><font color=<%=c%> size="3"><%=f("vietas")%></td>
    <td align=center><font color=<%=c%> size="3">
    <% if mid(f("kods"),4,1)="P" or mid(f("kods"),4,1)="S" then %>
     <a href="kontakti.asp?gid=<%=cstr(f("id"))%>"><%=f("cid")%></a>
    <% else %>
    <a href="interesenti.asp?gid=<%=cstr(f("id"))%>"><%=f("cid")%></a>
    <% end if %>
    </td>
    <td align="center"><b><font size="3" color="#000000"><a href="grupas.asp?marsruts=<%=f("marID")%>">
	<%=f("v")%></a></td>
    <td>
		<font color=<%=c%> size="3"><b><%=dateprint(f("sakuma_dat"))%></b><br>
		<%if inStr(f("kods"),".V.7.")<>0 then%>	
			Izlidoðana:  
		<%else%>
			Izbraukðana: 
		<%end if
		Response.Write(timeprint2(f("izbr_laiks"))+" "+getIVieta(f("izbr_vieta")))%>
		</font>
    </td>
    <td><font color=<%=c%> size="3"><b><%=dateprint(f("beigu_dat"))%></b><br>
		<%if inStr(f("kods"),".V.7.")<>0 then%>	
			Ielidoðana:  
		<%else%>
			Iebraukðana: 
		<%end if
		Response.Write(timeprint2(f("iebr_laiks"))+" "+getIVieta(f("iebr_vieta")))%>
		</font>
	</td>
    <td align="center"><font color=<%=c%> size="3" color="#000000"><%=Curr3Print2(f("i_cena"),f("i_cena_usd"),f("i_cena_eur"))%></a></font></td>
    <td align="center">
      <% 
      isvad=false
      if getnum(f("vaditajs"))<>0 then
       set rVad = conn.execute("select * from grupu_vaditaji where idnum = "+cstr(getnum(f("vaditajs"))))
       if not rVad.eof then 
        isvad=true
        Response.Write rVad("vards")+" "+rVad("uzvards")
       end if
      end if
      if getnum(f("vaditajs2"))<>0 then
       set rVad = conn.execute("select * from grupu_vaditaji where idnum = "+cstr(getnum(f("vaditajs2"))))
       if not rVad.eof then 
        isvad=true
        Response.Write ",<br>"+rVad("vards")+" "+rVad("uzvards")
       end if
      end if
      %>
      <font color=<%=c%> size="3" color="#000000"><%if isvad = false then Response.write f("vad")%> 
      </b></a></font>
    </td>
    <td align="right"><font color=<%=c%> size="3" color="#000000"><%=dateprint(f("sapulces_dat"))%><br><%=TimePrint2(f("sapulces_laiks_no"))%> - <%=TimePrint2(f("sapulces_laiks_lidz"))%><br>
	<%
		if not isnull(f("dokumenti")) and f("dokumenti") <> "" then %>
			<div id = "dialog-<%=f("id")%>" 
				title = "..."><%=f("dokumenti")%></div>
			<a href="#" id = "opener-<%=f("id")%>">Dokumenti</a>
			
			<script>
			$(function() {
            $( "#dialog-<%=f("id")%>" ).dialog({
               autoOpen: false,
			   closeText: "aizvçrt",
			   position: { my: "left bottom", of: "#opener-<%= f("id")%>", within: $("body"), collision: "flipfit"}
            });
            $( "#opener-<%=f("id")%>" ).click(function() {
               $( "#dialog-<%=f("id")%>" ).dialog( "open" );
			return false;
            });
         });
			</script>
			
			<%
		end if
	%>
	</b></a></font></td>
    <%
    'if getnum(f("kontrolieris"))<>0 then
	if not isnull(f("k_vu")) then
		
		kontrolieris = "<BR><i>Kontrolieris:</i> "+cstr(f("k_vu"))
		
    else
		kontrolieris = ""
    end if
    
    if not isnull(f("autobuss")) then
		
		autobuss = "<BR><i>Autobuss:</i> "+cstr(Decode(f("autobuss")))
		
    else
		autobuss = ""
    end if
	
	 if not isnull(f("autobusa_piezimes")) then
		
		autobuss = autobuss + " " + cstr(f("autobusa_piezimes"))		
   
    end if
    
    
    %>
	<!--td><font color=<%=c%> size="3" color="#000000"></a></font><%=f("valuta")%></td-->
	<td align=center>
		<%
		If (f("lidojums"))<>"" Then
			'' cik kopâ vietas lidojumâ
			set rlidkopa = conn.execute("select vietas from lidojums_vietas where lidojums in (select lidojums from grupa where id = "+cstr(f("id"))+")")
			'Response.write("select count(id) as s from pieteikums where deleted = 0 and gid in (select id from grupa where lidojums in (select lidojums from grupa where id = "+cstr(f("id"))+"))")
			 ''set raiznemts = conn.execute("select count(id) as s from pieteikums where deleted = 0 and gid in (select id from grupa where lidojums in (select lidojums from grupa where id = "+cstr(f("id"))+"))")
			set raiznemts = conn.execute("select sum(personas) as s from pieteikums where deleted = 0 and gid in (select id from grupa where lidojums in (select lidojums from grupa where id = "+cstr(f("id"))+"))")
			
			if not rlidkopa.eof then
				%><nobr><%=raiznemts("s")%> no <%=rlidkopa("vietas")%></nobr><BR><%
			end if
		End if%>
		<%
		if getnum(f("kurators"))<>0 then
		   set rVad = conn.execute("select * from lietotaji where id = "+cstr(getnum(f("kurators"))))
		   if not rVad.eof then 
			isvad=true
			Response.Write rVad("vards")+" "+rVad("uzvards")
		   end if
		end if
		%>

	</td>
	<td><%=f("kede")%></td>
	<td align=center><% set rSkat = conn.execute("SELECT COUNT(id) as skaits FROM skatijumi WHERE gid="+cstr(f("id")))
			skat = rSkat("skaits")
			rw skat%>
	</td>
    <td><!--font color=<%=c%> size="3" color="#000000"></a></font-->
		<%' if nullprint(f("piezimes")) <> "" then %>
			<!--div class="tooltip"><i class="material-icons">&#xe616;</i>
				<!--span class="tooltiptext"><%=f("piezimes")%></span-->
			</div-->
		<% 'end if %>
		<%=f("piezimes")%><%if nullprint(f("valsts"))="" then Response.Write "x"%><%=kontrolieris%><%=autobuss%></td>

 </tr>

<%
f.movenext
wend
%>
	<tr bgcolor="#ffc1cc">
		<td></td>
		<td>Kopâ</td>
		<td></td>
		<td></td>
		<td></td>
		<td align=center><%=pieteikumi_kopa%></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>

	</tr>
</table>
<%
   else 
	response.write("<br>Nav iespçjams izdrukât! max=300")
  end if
  end if

set r=conn.execute("select g1.kods k1, g2.kods k2, g1.id as id1, g2.id as id2 from grupa g1 " + _
"join grupa g2 on g1.vaditajs = g2.vaditajs " + _
"where  " + _
"	g1.beigu_dat > getdate() " + _
"	and g2.beigu_dat > getdate() " + _
"	and g1.sakuma_dat <= g2.beigu_dat " + _
"	and g1.beigu_dat >= g2.sakuma_dat " + _
"	and g1.id <> g2.id " + _
"	and g1.vaditajs <> 0 " + _
"")

if not r.eof then	
	%><BR><BR>Grupas, kam iespçjams pârklâjas vadîtâji
	<table>
		<% while not r.eof %>
			<tr>
				<td><a href="grupa_edit.asp?gid=<%=r("id1")%>"><%=r("k1")%></a></td>
				<td> un </td>
				<td><a href="grupa_edit.asp?gid=<%=r("id2")%>"><%=r("k2")%></a></td>
			</tr>
		<% r.movenext
		wend %>
	</table>
	<%
end if

%>


<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>
<!--

function find_group(ch) 
{
	var s;
	var s2;
	var direction = '';
	var f = 1;
	s = forma.fin.value + String.fromCharCode(ch);
	s = s.toLowerCase();
	// s = ConvertAlpha(s);
	while(f)
	{
		s2 = forma.marsruts.options(forma.marsruts.selectedIndex).text;
		s2 = s2.toLowerCase();
		// s2 = ConvertAlpha(s2);
		if (s>s2 && (direction=='' || direction=='down') && forma.marsruts.selectedIndex<forma.marsruts.length-1) 
		{
			forma.marsruts.value = forma.marsruts.options(forma.marsruts.selectedIndex+1).value;
			direction = 'down';
		}
		else if (s<s2 && (direction=='' || direction=='up') && forma.marsruts.selectedIndex>0) 
		{
			forma.marsruts.value = forma.marsruts.options(forma.marsruts.selectedIndex-1).value;
			direction = 'up';
		}
		else
			f = 0;
	}
	if (s>s2 && (direction=='' || direction=='up') && forma.marsruts.selectedIndex<forma.marsruts.length-1) 
		forma.marsruts.value = forma.marsruts.options(forma.marsruts.selectedIndex+1).value;
}

function ConvertAlpha(s)
{
	var ret;
	ret = '';
	var i;
	for (i=0;i<s.length;i++)
	{
		if (s.substr(i,1)=='â')
			ret = ret + 'a';
		else if (s.substr(i,1)=='è')
			ret = ret + 'c';
		else if (s.substr(i,1)=='ç')
			ret = ret + 'e';
		else if (s.substr(i,1)=='ì')
			ret = ret + 'g';
		else if (s.substr(i,1)=='î')
			ret = ret + 'i';
		else if (s.substr(i,1)=='í')
			ret = ret + 'k';
		else if (s.substr(i,1)=='ï')
			ret = ret + 'l';
		else if (s.substr(i,1)=='ò')
			ret = ret + 'n';
		else if (s.substr(i,1)=='ð')
			ret = ret + 's';
		else if (s.substr(i,1)=='û')
			ret = ret + 'u';
		else if (s.substr(i,1)=='þ')
			ret = ret + 'z';
		else
			ret = ret + s.substr(i,1);
	};
	return ret;
}

$(document).ready(function() {
    new TomSelect('#valsts', {
        create: false,  // Disable creating new items (optional)
        maxItems: 1,    // Single selection
		maxOptions: 200
    });	

    new TomSelect('#vaditajs', {
        create: false,  // Disable creating new items (optional)
        maxItems: 1,    // Single selection
		maxOptions: 200
    });

});
//-->
</SCRIPT>
</form>

</body>
</html>