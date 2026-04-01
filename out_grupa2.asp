<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn
docstart "Grupu papildinformâcija","y1.jpg"
sezi = request.querystring("i")
if sezi="" then sezi = 9
%>
<font face=arial>
<center><font color="GREEN" size="5"><b>Grupu papildinformâcija</b></font><hr>
<%headlinks%><br>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form
filt = "on"
if filt = "on" then%>
<form action="out_grupa2.asp?i=<%=sezi%>" method="POST">

<tr>
 <td align="right" bgcolor="#ffc1cc">No: </td>
 <td bgcolor="#fff1cc">
  <input type="text" size="10" maxlength="10" name="dat1" value="<%=Request.Form("Dat1")%>">
 lîdz 
  <input type="text" size="10" maxlength="10" name="dat2" value="<%=request.form("dat2")%>"></td>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Kods <b></td>
 <td bgcolor="#fff1cc"><input type="text" size="8" maxlength="10" name="kods" value="<%=request.form("kods")%>"> 
 </td>
</tr>

<tr><td align="right" bgcolor="#ffc1cc">	
 <a HREF="out_grupa2.asp

<% if sezi = 9 then %>
?i=2">Aktuâlie 
<% else %>
 ">Visi
<% end if %>

marðruti: </a>
	</td><td bgcolor="#fff1cc">
<%
if sezi = 9 then
 Set grupas = conn.execute("SELECT distinct marsruts.v, marsruts.ID FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>('"+sqldate(now-1)+"'))) ORDER BY v")
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
 if request.form("marsruts") = cstr(grupas("id")) then response.write "selected"
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
<%if sezi <>9 then%>

<td align="right" bgcolor="#ffc1cc">Bijuðie vai nâkamie braucieni</td>
	<td bgcolor="#fff1cc"><select name="time" size="1">
	<option value="0"<%if request.form("time") = "0" then response.write " selected "%>>Nâkamie</option>
	<option value="1"<%if request.form("time") = "1" then response.write " selected "%>>Bijuðie</option>
	<option value="2"<%if request.form("time") = "2" or  request.form("time") = "" then response.write " selected "%>>Visi</option>
	</select>
</td>
<%end if%>
</tr>
</table>
<input type="hidden" name="subm" value="1"> 
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem." WIDTH="25" HEIGHT="25"> 
</form>
<% End if 

if request.form("subm") = "1"  then 
'@ 0 Creating SQL
qb="FROM grupa g, marsruts m  WHERE g.mID=m.ID and m.old=0 "

if request.form("marsruts") <> "0" then
	qb = qb + " AND m.id = "+request.form("marsruts") + " "
end if
if request.form("kods") <> "" then
	qb = qb + " AND g.kods LIKE '"+cstr(request.form("kods")) + "%' "
end if
if request.form("veids") <> "0" then
	qb = qb + " AND g.veids = "+request.form("veids") + " "
end if
if request.form("dat1") <> "" then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(FormatedDate(request.form("dat1"),"dmy")) + "' "
end if
if request.form("dat2") <> "" then
	qb = qb + " AND g.sakuma_dat <= '"+SQLDate(FormatedDate(request.form("dat2"),"dmy")) + "' "
end if
if request.form("time") = "" or request.form("time") = 0 then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(now()) + "' "
end if
if request.form("time") =  1 then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(now()) + "' "
end if

if request.form("order") = "0" then qb = qb + " ORDER by m.v, g.sakuma_dat "
if request.form("order") = "" or request.form("order") =  "1" then qb = qb + " ORDER by g.sakuma_dat, m.v "

qf="SELECT g.*,m.ID as marID,m.v,m.cena,g.i_cena "+qb
' response.write(qf)
set f = server.createobject("ADODB.Recordset")
f.open qf,conn,3,3

qc=f.recordcount
response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"grupa","grupas")
if qc<300 then 
%>

<p>
<table>
<font face=arial >
<tr bgcolor="#ffc1cc">
<td><p align="center"></td>
<td><p align="center">Kods</td>
<td><p align="center">Nosaukums</td>
<td><p align="center">Sâkuma datums</td>
<td><p align="center">Beigu datums</td>
<td><p align="center">Vadîtâjs</td>
<td><p align="center">Autobuss</td>
<td><p align="center">L/N</td>
<td><p align="center">Valûta</td>
<td><p align="center">Piezîmes 2</td>
</tr>

<%
for i=1 to qc

'@ 0 Printing table
%>
  <%
  c = "BLACK"
  if nullprint(f("LN")) = "L" then c = "#009900"
  if nullprint(f("LN")) = "N" then c = "#0000FF"
  if f("ATCELTA") = true then c = "RED"
  %>
  <tr bgcolor="#fff1cc" >
    <td><a target=_blank href="grupa_edit.asp?gid=<%=cstr(f("id"))%>">G</a></td>
    <td><font face=arial color=<%=c%> size="3"><%=f("kods")%></td>
	<td><font face=arial color=<%=c%> size="3"><%=f("v")%></a></td>
    <td><font face=arial color=<%=c%> size="3"><%=dateprint(f("sakuma_dat"))%></td>
    <td><font face=arial color=<%=c%> size="3"><%=dateprint(f("beigu_dat"))%></a></font></td>
	<td><font face=arial color=<%=c%> size="3"><%=f("vad")%></a></td>
    <td><font face=arial color=<%=c%> size="3"><%=f("autobuss")%></td>
    <td><font face=arial color=<%=c%> size="3"><%=f("LN")%></td>
    <td><font face=arial color=<%=c%> size="3"><%=f("valuta")%></td>
    <td><font face=arial color=<%=c%> size="3" color="#000000"></a></font><%=f("piezimes2")%></td>

 </tr>

<%
f.movenext
next
%>
</table>
<%
   else 
	response.write("<br>Nav iespçjams izdrukât!")
  end if
  end if
	
%>
</body>
</html>
