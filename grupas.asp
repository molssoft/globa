<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn
docstart "Grupu laboðana","y1.jpg"
sezi = request.querystring("i")
if sezi="" then sezi = 9

act = request.form("act")
'-------------------- delete the record
if act="del" then
 id = request.form("id")
 set r = conn.execute ("select * from pieteikums where deleted=0 and gid = "+cstr(id))
 if r.eof then
  conn.execute "delete from grupa where id = " +cstr(id)
  session("message") = "Grupa ir dzçsta."
 else
  session("message") = "Grupu nevar dzest jo ta satur pieteikumus."
 end if
end if

'-------------------- save
if act="save" then
 id = request.form("id")
 kods = request.form("kods"+cstr(id))
 konts = request.form("konts"+cstr(id))
 sakuma_dat = "'"+sqldate(request.form("sakuma_dat"+cstr(id)))+"'"
 if sakuma_dat = "''" then sakuma_dat = "NULL"
 beigu_dat = "'"+sqldate(request.form("beigu_dat"+cstr(id)))+"'"
 if beigu_dat = "''" then beigu_dat = "NULL"
 sapulces_dat = "'"+sqldate(request.form("sapulces_dat"+cstr(id)))+"'"
 if sapulces_dat = "''" then sapulces_dat = "NULL"
 veids = request.form("veids"+cstr(id))
 vietsk = request.form("vietsk"+cstr(id))
 if vietsk = "" then vietsk = "0"
 vietsk_nakts = request.form("vietsk_nakts"+cstr(id))
 if vietsk_nakts = "" then vietsk_nakts = "0"
 if trim(cstr(veids)) = "2" and vietsk_nakts = "0" then vietsk_nakts = vietsk
 i_cena = request.form("i_cena"+cstr(id))
 if i_cena = "" then i_cena = "0"
 '-- gluk
 vad = Request.form("vad"+cstr(id))
 kurators = Request.form("kurators"+cstr(id))
 vad_id = Request.Form("vad_id"+cstr(id))
 piezimes = request.form("piezimes"+cstr(id))
 atcelta = request.form("atcelta"+cstr(id))
 if atcelta = "on" then atcelta = "1" else atcelta = "0"
 valuta = request.form("valuta"+cstr(id))
 if valuta = "on" then valuta = "XXX" else valuta = ""
 autobuss = Request.Form("autobuss"+cstr(id))
 autobusa_cena = Request.Form("autobusa_cena"+cstr(id))
 if autobusa_cena = "" then autobusa_cena = "0"
 piezimes2 = Request.Form("piezimes2"+cstr(id))
 LN = Request.Form("LN"+cstr(id))

 'pârbauda vai nedubultojas kods
 if kods <>"" and beigu_dat <> "NULL" then
  set rSameKod = conn.execute("select * from grupa where datepart(year,beigu_dat) = datepart(year,"+beigu_dat+") and kods = '"+kods+"' and id<>"+cstr(id))
  if not rSameKod.eof then
   session("message") = "Grupa ar tâdu kodu jau eksistç."
  end if
 end if

 if session("message") = "" then
  conn.execute "update grupa set kods='"+kods+"',konts='"+konts+"',sakuma_dat="+sakuma_dat+",beigu_dat="+beigu_dat+",sapulces_dat="+sapulces_dat+",vietsk="+vietsk+",vietsk_nakts="+vietsk_nakts+",i_cena="+i_cena+",vad_id=N'"+vad_id+"',kurators="+cstr(kurators)+",vad=N'"+vad+"',piezimes=N'"+piezimes+"',atcelta="+atcelta+",valuta='"+valuta+"',veids="+veids+",autobuss='"+autobuss+"',autobusa_cena="+autobusa_cena+" where id = "+cstr(id)
  if IsAccess(T_GRUPU_PAPILD_INFO) then
    conn.execute "update grupa set LN='"+LN+"',piezimes2='"+piezimes2+"' where id = "+cstr(id)
  end if
  LogEditAction "grupa",id
 end if
end if

'-------------------- add
if act="add" then
 id = request.form("id")
 kods = request.form("add_kods")
 konts = request.form("add_konts")
 sakuma_dat = "'"+sqldate(request.form("add_sakuma_dat"))+"'"
 if sakuma_dat = "''" then sakuma_dat = "NULL"
 beigu_dat = "'"+sqldate(request.form("add_beigu_dat"))+"'"
 if beigu_dat = "''" then beigu_dat = "NULL"
 sapulces_dat = "'"+sqldate(request.form("add_sapulces_dat"))+"'"
 if sapulces_dat = "''" then sapulces_dat = "NULL"
 veids = request.form("add_veids")
 vietsk = request.form("add_vietsk")
 if vietsk = "" then vietsk = "0"
 vietsk_nakts = request.form("add_vietsk_nakts")
 if vietsk_nakts = "" then vietsk_nakts = "0"
 if trim(cstr(veids)) = "2" and vietsk_nakts = "0" then vietsk_nakts = vietsk
 i_cena = request.form("add_i_cena")
 if i_cena = "" then i_cena = "0"
 vad = request.form("add_vad")
 kurators = request.form("add_kurators")
 vad_id = Request.Form("add_vad_id")
 piezimes = request.form("add_piezimes")
 atcelta = request.form("add_atcelta")
 if atcelta = "on" then atcelta = "1" else atcelta = "0"
 valuta = request.form("add_valuta")
 if valuta = "on" then valuta = "XXX" else valuta = ""
 autobuss = Request.Form("add_autobuss")
 autobusa_cena = Request.Form("add_autobusa_cena")
 if autobusa_cena = "" then autobusa_cena = "0"
 
 'pârbauda vai nedubultojas kods
 if kods <>"" and beigu_dat <> "NULL" then
  set rSameKod = conn.execute("select * from grupa where datepart(year,beigu_dat) = datepart(year,"+beigu_dat+") and kods = '"+kods+"'")
  if not rSameKod.eof then
    session("message") = "Grupa ar tâdu kodu jau eksistç."
  end if
 end if
 
 if session("message") = "" then
  conn.execute "insert into grupa (mid,kods,konts,sakuma_dat,beigu_dat,sapulces_dat,i_cena,vietsk,vietsk_nakts,vad_id,vad,kurators,piezimes,atcelta,valuta,veids,autobuss,autobusa_cena) values ("+request.form("marsruts")+",'"+kods+"','"+konts+"',"+sakuma_dat+","+beigu_dat+","+sapulces_dat+","+i_cena+","+vietsk+","+vietsk_nakts+",N'"+vad_id+"',N'"+vad+"',"+kurators+",N'"+piezimes+"',"+atcelta+",'"+valuta+"',"+veids+",'"+autobuss+"',"+autobusa_cena+")"
  LogInsertAction "grupa",conn.execute("select max(id) from grupa where mid = "+request.form("marsruts"))(0)
 end if
end if

marsruts = Request.Form("marsruts")
if Request.QueryString("mid")<>"" then marsruts = Request.QueryString("mid")

%>
<center><font color="GREEN" size="5"><b>Grupu laboðana!</b></font><hr>
<%headlinks
%>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form
filt = "on"
if filt = "on" then%>
<form name=forma action="grupas.asp?i=<%=sezi%>" method="POST">

<tr>
 <td align="right" bgcolor="#ffc1cc">Ceïojums sâkas <b>ne agrâk par: </td>
 <td bgcolor="#fff1cc">
  <input type="text" size="10" maxlength="10" name="dat1" value="<%=Request.Form("Dat1")%>">
 <b>ne vçlâk par:</b> 
  <input type="text" size="10" maxlength="10" name="dat2" value="<%=request.form("dat2")%>"></td>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Kods <b></td>
 <td bgcolor="#fff1cc"><input type="text" size="8" maxlength="10" name="kods" value="<%=request.form("kods")%>"> 
 </td>
</tr>

<tr><td align="right" bgcolor="#ffc1cc">	
 <a HREF="grupas.asp

<% if sezi = 9 then %>
?i=2">Aktuâlie 
<% else %>
 ">Visi
<% end if %>

marðruti: </a>
	</td><td bgcolor="#fff1cc">
<%
if sezi = 9 then
 Set grupas = conn.execute("SELECT distinct marsruts.v, marsruts.ID FROM marsruts where old=0 ORDER BY v")
else
 Set grupas = conn.execute("select * from marsruts ORDER BY v")
end if 
%>
<select name=marsruts size=1>
<option value=0>Visi</option>
<%

marsID = 0
while not grupas.eof
 Response.Write "<option "
 if marsruts = cstr(grupas("id")) then response.write "selected"
 response.write " value='" & cstr(grupas("ID")) & "'>" & grupas("v") & "</option>"
 grupas.MoveNext
wend

%></select>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Grupas veids: </td><td bgcolor="#fff1cc">
<%
Set veidi = conn.execute("select * from grveidi order by vards")
Response.Write "<select name=veids>"
Response.Write ("<option value=0 selected>Visi</option>")
while not veidi.eof
 Response.Write "<option "
 if request.form("veids") = cstr(veidi("id")) then response.write " selected "
 response.write " value='" & cstr(veidi("ID")) & "'>" & veidi("vards") & "</option>"
 veidi.MoveNext
wend
Response.write " </select>" & Chr(10)
%>
</tr>

<tr>
<td align="right" bgcolor="#ffc1cc">Sakârtojums</td>
<td bgcolor="#fff1cc"><select name="order" size="1">
	<option value="1" <%if request.form("order") = "1" then response.write " selected "%>>Pçc sâkuma datuma</option>
	<option value="0" <%if request.form("order") = "0" then response.write " selected "%>>Pçc Marðruta nosaukuma</option>
	</select>
 </td>
</tr>

<tr>
</tr>
</table>
<input type="hidden" name="subm" value="1"> 
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem." WIDTH="25" HEIGHT="25"> 
<% End if 

if session("message") <>"" then response.write "<br><center><font color=red>"+session("message")+"</font><br>"
session("message") = ""

if request.form("subm") = "1" or Request.QueryString("mid")<>"" then 

'@ 0 Creating SQL
qb="FROM grupa g, marsruts m  WHERE g.mID=m.ID and m.old=0 "

if marsruts <> "0" and marsruts <>"" then
	qb = qb + " AND m.id = "+marsruts + " "
end if
if request.form("kods") <> "" then
	qb = qb + " AND g.kods LIKE '"+cstr(request.form("kods")) + "%' "
end if
if request.form("veids") <> "0" and request.form("veids") <> "" then
	qb = qb + " AND g.veids = "+request.form("veids") + " "
end if
if request.form("dat1") <> "" then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(request.form("dat1")) + "' "
end if
if request.form("dat2") <> "" then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(1+FormatedDate(request.form("dat2"),"dmy")) + "' "
end if

if request.form("order") = "0" then qb = qb + " ORDER by m.v, g.sakuma_dat "
if request.form("order") = "" or request.form("order") =  "1" then qb = qb + " ORDER by g.sakuma_dat, m.v "

qf="SELECT g.*,m.ID as marID,m.v,m.cena "+qb
'response.write(qf)
set f = server.createobject("ADODB.Recordset")
f.open qf,conn,3,3

qc=f.recordcount
%><br><%
response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"grupa","grupas")
%>

<p>
<table>
<tr bgcolor="#ffc1cc">
<td><p align="center"></td>
<td><p align="center">Kods</td>
<td><p align="center">Konts</td>
<td><p align="center">Sâkuma datums</td>
<td><p align="center">Beigu datums</td>
<td><p align="center">Sapulces datums</td>
<td><p align="center">Vietas autob.</td>
<td><p align="center">Vietas naktsm.</td>
<td><p align="center">Cena</td>
<td><p align="center"><a href="grupu_vaditaji.asp" target=_blank>Vadîtâjs</a></td>
<td><p align="center">Kurators</td>
<td><p align="center">Veids</td>
<td><p align="center">Piezîmes</td>
<td><p align="center">Atcelta</td>
<td><p align="center">Ls+$</td>
<td><p align="center">Autobuss</td>
<td><p align="center">Autob.cena</td>
</tr>

<%


' Printing table
while not f.EOF
 if f("ATCELTA") = true then c = "RED" else c = "GREEN"%>
  <tr bgcolor="#fff1cc" >
    <td><a href="pieteikumi.asp?gid=<%=cstr(f("id"))%>"><img src="impro/bildes/k_zals.gif" WIDTH="31" HEIGHT="14"></a></td>
	<td><input type=text name=kods<%=f("id")%> value="<%=f("kods")%>" size=8></td>
	<td><input type=text name=konts<%=f("id")%> value="<%=f("konts")%>" size=8></td>
	<td><input type=text name=sakuma_dat<%=f("id")%> value="<%=timeprint(f("sakuma_dat"))%>" size=13></td>
	<td><input type=text name=beigu_dat<%=f("id")%> value="<%=dateprint(f("beigu_dat"))%>" size=10></td>
	<td><input type=text name=sapulces_dat<%=f("id")%> value="<%=timeprint(f("sapulces_dat"))%>" size=13></td>
	<td><input type=text name=vietsk<%=f("id")%> value="<%=getnum(f("vietsk"))%>" size=3></td>
	<td><input type=text name=vietsk_nakts<%=f("id")%> value="<%=getnum(f("vietsk_nakts"))%>" size=3></td>
	<td><input type=text name=i_cena<%=f("id")%> value="<%=f("i_cena")%>" size=6></td>
	<td><input type=text name=vad<%=f("id")%>  size=15 value="<%=f("vad")%>"></td>
    <td><select name=kurators<%=f("id")%>>
	  <option value="0">-</option>
	  <% set rKurators = conn.execute("select * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12)")
	  while not rKurators.eof
	   response.write "<option value="+cstr(rKurators("id"))+" "
	   if rKurators("id") = f("kurators") then response.write " selected "
	   response.write ">"+rKurators("vards")
	   response.write "</Option>"
	   rKurators.movenext
	  wend
	 %></select>
	 </td>
	<td>
	 <select name=veids<%=f("id")%> >
	  <% 
	  set rVeidi = conn.execute("select * from grveidi order by vards ")
	  while not rveidi.eof
	   response.write "<option value="+cstr(rVeidi("id"))+" "
	   if rVeidi("id") = f("veids") then response.write " selected "
	   response.write ">"+rVeidi("vards")
	   response.write "</Option>"
	   rveidi.movenext
	  wend
	  %>
	 </select>
	</td>
	<td><input type=text name=piezimes<%=f("id")%> value="<%=f("piezimes")%>" size=10></td>
	<td align=center><input type=checkbox name=atcelta<%=f("id")%> <%if f("atcelta") then response.write " checked " %>></td>
	<td align=center><input type=checkbox name=valuta<%=f("id")%> <%if f("valuta")="XXX" then response.write " checked " %>></td>
	<td><input type=text name=autobuss<%=f("id")%> value="<%=f("autobuss")%>" size=20></td>
	<td><input type=text name=autobusa_cena<%=f("id")%> value="<%=getnum(f("autobusa_cena"))%>" size=6></td>
	<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.act.value='del';forma.id.value='<%=f("id")%>';return confirm('Vai vçlaties dzçst grupu?');" WIDTH="25" HEIGHT="25"></td>
	<td><input type="image" src="impro/bildes/diskete.jpg" onclick="forma.act.value='save';forma.id.value='<%=f("id")%>';return true;" WIDTH="25" HEIGHT="25"></td></tr>
  </tr>
  <%if IsAccess(T_GRUPU_PAPILD_INFO) then %>
  <tr>
    <td></td>
    <td align=right>Pazîme:</td>
    <td><input type="text" name="LN<%=f("id")%>" value="<%=f("LN")%>" size=2 maxlength=1></td>
    <td align=right>Piezîmes:</td>
    <td colspan=4><input type="text" name="piezimes2<%=f("id")%>" value="<%=f("piezimes2")%>" size=30></td>
    <td>Vadîtâjs</td>
    <td><select name=vad_id<%=f("id")%>>
	  <option value="">-</option>
	  <% set rVad = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards ")
	  while not rVad.eof
	   response.write "<option value="+cstr(rVad("id"))+" "
	   if rVad("id") = f("vad_id") then response.write " selected "
	   response.write ">"+rVad("vards")+" "+rVad("uzvards")
	   response.write "</Option>"
	   rvad.movenext
	  wend
	 %></select>
	 </td>
  </tr>
  <%end if %>
<%
 f.movenext
wend
%>

<tr bgcolor="#fff1cc" >
    <td></td>
    <% if request.form("marsruts")<>"0" then %>
	<td><input type=text name=add_kods size=8></td>
	<td><input type=text name=add_konts size=8></td>
	<td><input type=text name=add_sakuma_dat size=13></td>
	<td><input type=text name=add_beigu_dat size=10></td>
	<td><input type=text name=add_sapulces_dat size=13></td>
	<td><input type=text name=add_vietsk size=3></td>
	<td><input type=text name=add_vietsk_nakts size=3></td>
	<td><input type=text name=add_i_cena size=6></td>
	<td><input type=text name=add_vad size=15></td>
    <td><select name=add_kurators>
	  <option value="0">-</option>
	  <% set rKurators = conn.execute("select * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12)")
	  while not rKurators.eof
	   response.write "<option value="+cstr(rKurators("id"))+" "
	   response.write ">"+rKurators("vards")
	   response.write "</Option>"
	   rKurators.movenext
	  wend
	 %></select>
	 </td>
	<td>
	 <select name=add_veids>
	  <% set rVeidi = conn.execute("select * from grveidi order by vards ")
	  while not rveidi.eof
	   response.write "<option value="+cstr(rVeidi("id"))+">"
	   response.write rVeidi("vards")
	   response.write "</Option>"
	   rveidi.movenext
	  wend
	  %>
	 </select>
	</td>
	<td><input type=text name=add_piezimes size=10></td>
	<td align=center><input type=checkbox name=atcelta ></td>
	<td align=center><input type=checkbox name=valuta ></td>
	<td><input type=text name=add_autobuss size=20></td>
	<td><input type=text name=add_autobusa_cena value="0" size=6></td>
	<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='add';return true;" WIDTH="25" HEIGHT="25"></td>
   <% end if %>
</tr>

</table>
<%
end if
	
%>
<input type=hidden name="id" value="0">
<input type=hidden name="act" value="">
</form>
</body>
</html>
