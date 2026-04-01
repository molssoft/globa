<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn
docstart "Atrodi savu ceïojumu","y1.jpg"
sezi = request.querystring("i")
if sezi="" then sezi = 9
%>
<center><font color="GREEN" size="5"><b>Kavçtâju saraksts</b></font><hr>
<%headlinks%>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form
filt = "on"
if filt = "on" then%> 
<form action="kavetaji_param.asp?i=<%=sezi%>" method="POST">

<tr><td align="right" bgcolor="#ffc1cc">Ceïojums sâkas <b>ne agrâk par: </td><td bgcolor="#fff1cc">
<input type="text" size="10" maxlength="10" name="dat1" value="<% if request.form("dat1") = "" then Response.Write dateprint(now) else Response.Write Request.Form("Dat1")%>"> 
<b>ne vçlâk par:</b> <input type="text" size="10" maxlength="10" name="dat2" value="<%=request.form("dat2")%>"> </tr>

<tr><td align="right" bgcolor="#ffc1cc">Kods <b></td><td bgcolor="#fff1cc"><input type="text" size="8" maxlength="10" name="kods" value="<%=request.form("kods")%>"> </td></tr>
<tr><td align="right" bgcolor="#ffc1cc">	<a HREF="out_grupa.asp<%if sezi = 9 then%>?i=2">Aktuâlie 
<%else%>
	&quot;&gt;Visi
<%end if%>
marðruti: </a>
	</td><td bgcolor="#fff1cc">
<%
if sezi = 9 then
	Set grupas = conn.execute("SELECT marsruts.v, marsruts.ID FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>'"+sqldate(now-1)+"'))ORDER BY v")
else
	Set grupas = conn.execute("select * from marsruts ORDER BY v")
end if 
Response.Write "<select name=" & "marsruts" & " size=" & "1" & ">"
'------- Loop through the RECORDS
Response.Write ("<option value=0 selected> Visi  </option>")

marsID = 0
do while not grupas.eof
if sezi = 9 then
	if marsID<>grupas("ID") then Response.Write "<option value='" & grupas("ID") & "'>" & grupas("v") & "</option>"
	marsID=grupas("ID")
else 
	Response.Write "<option value='" & grupas("ID") & "'>" & grupas("v") & "</option>"
end if
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>
<tr><td align="right" bgcolor="#ffc1cc">Grupas veids: </td><td bgcolor="#fff1cc">
<%
Set veidi = conn.execute("select * from grveidi order by vards") '---- 60
Response.Write "<select name=" & "veids" & " size=" & "1" & ">"
'------- Loop through the RECORDS
Response.Write ("<option value=0 selected> Visi  </option>")

do while not veidi.eof

Response.Write "<option value='" & veidi("ID") & "'>" & veidi("vards") & "</option>"
veidi.MoveNext
loop
Response.write " </select>" & Chr(10)
%></tr>
<tr>
<td align="right" bgcolor="#ffc1cc">Sakârtojums</td>
	<td bgcolor="#fff1cc"><select name="order" size="1">
	<option value="0">Pçc Marðruta nosaukuma</option>
	<option value="1">Pçc sâkuma datuma</option>
	</select>
</td></tr>
<tr>
<%if sezi <>9 then%>

<td align="right" bgcolor="#ffc1cc">Bijuðie vai nâkamie braucieni</td>
	<td bgcolor="#fff1cc"><select name="time" size="1">
	<option value="0">Nâkamie</option>
	<option value="1">Bijuðie</option>
	<option value="2">Visi</option>
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
qb="FROM (grupa g INNER JOIN marsruts m  ON g.mID=m.ID) INNER JOIN terms ON terms.gid = g.id WHERE atcelta = 0 and terms.datums < '"+SQLDate(Date)+"' AND g.sakuma_dat > '" + SQLDate(Date-5) + "'"
if request.form("marsruts") <> "0" then '--- 100
	qb = qb + " AND m.id = "+request.form("marsruts") + " "
end if
if request.form("kods") <> "" then
	qb = qb + " AND g.kods LIKE '"+cstr(request.form("kods")) + "' "
end if
if request.form("veids") <> "0" then
	qb = qb + " AND g.veids = "+request.form("veids") + " "
end if
if request.form("dat1") <> "" then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(request.form("dat1")) + "' "
end if
if request.form("dat2") <> "" then
	qb = qb + " AND g.sakuma_dat <= '"+SQLDate(request.form("dat2")) + "' "
end if
if request.form("time") = "" or request.form("time") = 0 then
	qb = qb + " AND g.sakuma_dat >= '"+SQLDate(now()) + "' "
end if
if request.form("time") =  1 then
	qb = qb + " AND g.sakuma_dat < '"+SQLDate(now()) + "' "
end if

'

if request.form("order") = "" or request.form("order") = "0" then qb = qb + " ORDER by m.v "
if request.form("order") =  "1" then qb = qb + " ORDER by g.sakuma_dat "

qf="SELECT g.id as gid,m.ID as marID,m.v,terms.summa as summa,terms.datums as datums,sakuma_dat,terms.vietas_veids "+qb
'response.write(qf)
'response.end

set rec = server.createobject("ADODB.Recordset")
rec.open qf,conn,3,3
qc=rec.recordcount
if qc<500 and qc>0 then 
	%>
	<br>
	<table border="0">
	<tr bgcolor="#ffc1cc">
	<th>Pieteikums</th>
	<th>Vârds</th>
	<th>Iemaksâts</th>
	<th>Vajadzîgs</th>
	<th>Termiòð</th>
	<th>Tâlr.m.</th>
	<th>Tâlr.d.</th>
	<th>Tâlr.mob.</th>
	<th>Emails</th>
	</tr>
	<% 
	' -------- caurskata visas grupas
	set rPiet = server.createobject("ADODB.Recordset")
	PrevGid = 0
	while not rec.eof 
	' ----- selektç ðîs grupas pieteikumus
	rPiet.open "SELECT * FROM pieteikums INNER JOIN piet_saite ON pieteikums.id = piet_saite.pid WHERE (NOT PIETEIKUMS.DELETED=1) AND (NOT PIET_SAITE.DELETED = 1) AND gid = " + cstr(rec("gid")),conn,3,3
	while not rPiet.eof
	' ----- pârbauda vai ðis pieteikums nav nokavçjis
	vietas = piet_personas(rPiet("pid"))
	' ---- lai nebuutu daliijums ar nulli
	if vietas = 0 then vietas = 1
	if piet_iemaksas(rPiet("pid")) < rec("summa") then
		if GetNum(rec("vietas_veids")) = 0 OR GetNum(rec("vietas_veids")) = GetNum(rPiet("vietas_veids")) then
			' ------ pievieno sarakstam ðo pieteikumu
			if PrevGid <> rec("gid") then
				%>
				<tr><td colspan="9" bgcolor="NavajoWhite">
				<%=NullPrint(id_field("marsruts",id_field("grupa",rPiet("gid"),"mid"),"v")) + " " + DatePrint(rec("sakuma_dat"))%></td><tr>
				<%
				PrevGid = rec("gid")
			end if
			set rDal = Server.CreateObject("ADODB.Recordset")
			rDal.open "SELECT * FROM dalibn WHERE id = " +cstr(rPiet("did")),conn,3,3
			%>
			<tr bgcolor="#fff1cc">
			<td><a href="pieteikums.asp?pid=<%=rPiet("pid")%>"><%=NullPrint(DatePrint(rPiet("datums")))%></a></td>
			<td><a href="dalibn.asp?i=<%=rPiet("did")%>"><%=nullprint(rDal("vards"))+" "%> <%=nullprint(rDal("uzvards"))%> <%=nullprint(rDal("nosaukums"))%></a></td>
			<td align="center"><%=cstr(piet_iemaksas(rPiet("pid")))%></td>
			<td align="center"><%=rec("summa")%></td>
			<td align="center"><%=rec("datums")%></td>
			<td><%=nullprint(rDal("talrunisM"))%></td>
			<td><%=nullprint(rDal("talrunisD"))%></td>
			<td><%=nullprint(rDal("talrunisMob"))%></td>
			<td><%=nullprint(rDal("eadr"))%>
</td>
			<tr>


			<%
		end if
	end if
	rPiet.movenext
	wend
	rPiet.close
	rec.movenext
	wend %>
	</table>
	<%
else 
	if qc>100 then response.write("<br>Nav iespçjams izdrukât, atrastas pârâk daudz grupas!")
	if qc=0 then response.write("<br>Nav atrasta neviena grupa.")
end if
end if
	
%>
</body>
</html>