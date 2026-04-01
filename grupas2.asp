<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn
docstart "Grupu laboðana","y1.jpg"
sezi = request.querystring("sezi")

PageSize = 20
'Current page
p = request.querystring("p")
if p = "" then p = "1"


act = request.QueryString("act")
'-------------------- delete the record
if act="del" then
 id = request.QueryString("id")
 set r = conn.execute ("select * from pieteikums where deleted=0 and gid = "+cstr(id))
 if not r.eof then
  session("message") = "Grupu nevar dzest jo ta satur pieteikumus."
 end if
 
 if session("message") = "" then
  set r = conn.execute ("select * from vietu_veidi where gid = "+cstr(id))
  if not r.eof then
   session("message") = "Grupu nevar dzçst jo tâ satur pakalpojumus."
  end if
 end if

 if session("message") = "" then
  'nosaka marsrutu
  set r = conn.execute("select * from grupa where id = "+cstr(id))
  kods = nullprint(r("kods"))
  if kods <>"" and isnull(r("beigu_dat")) = false then
   'dzçð grâmatvedîbâ resursu
   y = year(r("beigu_dat"))
   on error resume next
   conn.execute("delete from g"+cstr(y)+".dbo.resursi where num = '"+kods+"' and not num in (select resurss from transakcijas)")
   on error resume next
   conn.execute("delete from g"+cstr(y+1)+".dbo.resursi where num = '"+kods+"' and not num in (select resurss from transakcijas)")
   on error resume next
   conn.execute("delete from g"+cstr(y-1)+".dbo.resursi where num = '"+kods+"' and not num in (select resurss from transakcijas)")
  end if
  
  if not r.eof then
   marsr_id = r("mid")
  else
   marsr_id = 0
  end if
  conn.execute "delete from grupa where id = " +cstr(id)
  'dzçð marðrutu ja nav vairâk grupu
  set r = conn.execute ("select * from grupa where mid = "+cstr(marsr_id))
  if r.eof then
   conn.execute "delete from marsruts where id = " + cstr(marsr_id)
  end if
  session("message") = "Grupa ir dzçsta."
 end if

 
end if

marsruts = Request.Querystring("marsruts")
if Request.QueryString("mid")<>"" then marsruts = Request.QueryString("mid")
veids = Request.QueryString("veids")
dat1 = Request.QueryString("dat1")
dat2 = Request.QueryString("dat2")
kods = Request.QueryString("kods")
if kods <> "" then
    kods = Code_Update(kods)
	qb = qb + " AND g.kods LIKE '"+cstr(kods) + "%' "
end if
kurators = Request.QueryString("kurators")
v = Request.QueryString("v")
order = Request.QueryString("order")
if order = "" then
 if IsAccess(T_KURATORS) THEN
  kurators = cstr(GetCurUserId)
 end if
end if
if order = "" then order = "sakuma_dat"

%>
<font face=arial>
<center><font color="GREEN" size="5"><b>Grupu laboðana!</b></font><hr>
<%headlinks
%>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form
filt = "on"
if filt = "on" then%>
<form name=forma action="grupas2.asp" method="PUT">
<input type=hidden name=subm value=1>
<tr>
 <td align="right" bgcolor="#ffc1cc">Sâkuma datums no: </td>
 <td bgcolor="#fff1cc">
  <input type="text" size="10" maxlength="10" name="dat1" value="<%=Dat1%>">
 lîdz:
  <input type="text" size="10" maxlength="10" name="dat2" value="<%=dat2%>"></td>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Kods <b></td>
 <td bgcolor="#fff1cc"><input type="text" size="15" name="kods" value="<%=kods%>"> 
 </td>
</tr>

<tr><td align="right" bgcolor="#ffc1cc">	
 <a HREF="grupas2.asp

<% if sezi = "" then %>
?sezi=2">Aktuâlie 
<% else %>
 ">Visi
<% end if %>

marðruti: </a>
	</td><td bgcolor="#fff1cc">
<%
if sezi = "" then
 Set grupas = conn.execute("SELECT distinct marsruts.v,  dbo.fn_str_to_num(ltrim(marsruts.v)), marsruts.ID FROM marsruts where old=0 ORDER BY dbo.fn_str_to_num(ltrim(marsruts.v))")
else
 Set grupas = conn.execute("select * from marsruts ORDER BY  dbo.fn_str_to_num(ltrim(marsruts.v))")
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
  <td align="right" bgcolor="#ffc1cc">Nosaukums satur: </td>
  <td bgcolor="#fff1cc"><input type=text name=v value="<%=v%>" size=20></td>
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
 <td align="right" bgcolor="#ffc1cc">Kurators: </td><td bgcolor="#fff1cc">
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
		" id in (select distinct kurators from grupa where sakuma_dat >= DATEADD(year, -3, GETDATE()))" & _
		" order by dbo.fn_str_to_num(ltrim(vards))" _
	)	
	while not rKurators.eof
	 response.write "<option value="+cstr(rKurators("id"))+" "
	 if cstr(rKurators("id")) = kurators then response.write " selected "
	 response.write ">"+rKurators("uzvards")+" "+rKurators("v")
	 response.write "</Option>"
	 rKurators.movenext
	wend
	%></select>
</tr>

<tr>
<td align="right" bgcolor="#ffc1cc">Sakârtojums</td>
<td bgcolor="#fff1cc"><select name="order" size="1">
	<option value="id" <%if order = "id" then response.write " selected "%>>Ievadîðanas secîbâ</option>
	<option value="sakuma_dat" <%if order = "sakuma_dat" then response.write " selected "%>>Pçc sâkuma datuma</option>
	<option value="v" <%if order = "v" then response.write " selected "%>>Pçc Marðruta nosaukuma</option>
	</select>
 </td>
</tr>

<tr>
</tr>
</table>
<input type="hidden" name="sezi" value=<%=sezi%>>
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem." onclick="forma.p.value='1';forma.submit();return false;"> 
<% End if 

if session("message") <>"" then response.write "<br><center><font color=red>"+session("message")+"</font><br>"
session("message") = ""

'@ 0 Creating SQL
qb="FROM grupa g left join lietotaji li on g.kurators=li.id , marsruts m  WHERE g.mID=m.ID "

if marsruts <> "0" and marsruts <>"" then
	qb = qb + " AND m.id = "+marsruts + " "
end if
if kods <> "" then
	qb = qb + " AND g.kods LIKE '"+cstr(kods) + "%' "
end if
if veids <> "0" and veids <> "" then
	qb = qb + " AND g.veids = "+veids + " "
end if
if dat1 <> "" then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(dat1) + "' "
end if
if dat2 <> "" then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(1+FormatedDate(dat2,"dmy")) + "' "
end if
if kurators <> "" and kurators<>"0" then
    qb = qb + " AND g.kurators = " +cstr(kurators)
end if
if v <> "" then
    qb = qb + " AND v like '%"+v+"%'"
end if

if isaccess(T_DROSIBA) then
    qb = qb + " AND kods in (select num from sk_karinas_grupas) " 
end if

'lai nerâdîtu TEST Grupas
qb  = qb + " AND (g.TESTAM!=1 OR g.TESTAM IS NULL) "

if order = "id" then
 qb = qb + " ORDER by g.id "
elseif order = "v" then
 qb = qb + " ORDER by m.v, g.sakuma_dat "
elseif order = "sakuma_dat" then
 qb = qb + " ORDER by g.sakuma_dat "
end if


qf="SELECT g.*,m.ID as marID,m.v,m.cena,old,vards "+qb
'response.write(qf)
if Request.querystring("subm")="1" then
	set f = server.createobject("ADODB.Recordset")
	f.PageSize = PageSize
	f.open qf,conn,3,3

	qc=f.recordcount
	%><BR><%
	response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"grupa","grupas")
	%>

	<p>
	<table>
	<tr bgcolor="#ffc1cc">
	<td><p align="center"></td>
	<td><p align="center">Kods</td>
	<td><p align="center">Nosaukums</td>
	<td><p align="center">Sâkuma datums</td>
	<td><p align="center">Beigu datums</td>
	<td><p align="center">Cena</td>
	<td><p align="center">Kurators</td>
	</tr>

	<%
	' Printing table
	if not f.eof then
	  f.AbsolutePage = p
	  rec = 1
		while not f.EOF and rec<=PageSize
		 if f("ATCELTA") = true then c = "RED" else c = "GREEN"%>
		  <tr bgcolor="#fff1cc" >
		    <td><a href="javascript:void(window.open('grupa_edit.asp?gid=<%=f("id")%>'))">G</a></td>
			<td><font color=<%=c%> size="3"><%=f("kods")%></td>
			<td><font color=<%=c%> size="3"><%=f("v")%></td>
			<td align=right><font color=<%=c%> size="3"><%=dateprint(f("sakuma_dat"))%></td>
			<td align=right><font color=<%=c%> size="3"><%=dateprint(f("beigu_dat"))%></td>
			<td><font color=<%=c%> size="3"><%=f("i_cena")%></td>
			<td><font color=<%=c%> size="3"><%=f("vards")%></td>
			<td><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.act.value='del';forma.id.value='<%=f("id")%>';return confirm('Vai vçlaties dzçst grupu?');" ></td>
			<td><a href="vesture.asp?tabula=grupa&id=<%=f("id")%>" target=_blank><img border=0 src="impro/bildes/clock.bmp"></a></td>
		  </tr>
		<%
		f.movenext
		rec=rec+1
		wend
	end if
	%>
	<input type=hidden name="id" value="0">
	<input type=hidden name="act" value="">
	<input type=hidden name="p" value="<%=p%>">
	</form>
	</table>
	<%

	if f.RecordCount > 0 then
	   response.write "<form name=""pageselect"" action=xx method=POST>"
	   %>
	   Lappuse:<select name="lpp" onchange="pageselect.action = 'grupas2.asp?subm=1&marsruts=<%=marsruts%>&kods=<%=kods%>&dat1=<%=dat1%>&dat2=<%=dat2%>&veids=<%=veids%>&order=<%=order%>&kurators=<%=kurators%>&v=<%=v%>&p='+lpp.value;pageselect.submit();">"
	 <%
	 for i = 1 to f.PageCount
	  if cstr(p) = cstr(i) then
	   response.write "<option selected value="+cstr(i)+">"+cstr(i)+"</option>"
	  else
	   response.write "<option  value="+cstr(i)+">"+cstr(i)+"</option>"
	  end if
	 next
	 %></select><%
	end if
else
	%>
	<input type=hidden name="id" value="0">
	<input type=hidden name="act" value="">
	<input type=hidden name="p" value="<%=p%>">
	</form>
	<%
end if 
%>
	

<a href="javascript:void(window.open('grupa_add.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
</form>
</body>
</html>
