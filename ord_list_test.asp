<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
'@ 0 Header
dim conn
openconn
docstart "Izdevumi, ieòçmumi un pârskaitîjumi.","y1.jpg"
%>
<font color="GREEN" size="5"><b>
<html>

<head>
<title></title>
</head>

<body>

<p align="center">Pârskats par naudas operâcijâm.</b></font></p>

<hr align="center">
<%headlinks%>

<p align="center"><br>
</p>
<div align="center"><center>

<table border="0" bgcolor="#FDFFDD">
<% 
' @ 0 Filter form
JSPoints
filt = "on"
if filt = "on" then%>
  <tr>
    <td><form action="ord_list.asp" name=forma method="POST">
    </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Datums: </td>
    <td bgcolor="#fff1cc">No:<input type="text" size="10" maxlength="10" name="dat1"
    value="<%=request.form("dat1")%><%if request.form("subm")<>"1" then response.write dateprint(now)%>">Lîdz: <input type="text" size="10" maxlength="10"
    name="dat2" value="<%=request.form("dat2")%><%if request.form("subm")<>"1" then response.write dateprint(now)%>"> </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Numurs</td>
    <td bgcolor="#fff1cc"><input type="text" size="5" maxlength="10" name="num"> </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Maksâtâjs</td>
    <td bgcolor="#fff1cc"><input type="text" size="10" maxlength="50" name="kas"> </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Dzçsts/Reâls</td>
    <td align="left" bgcolor="#fff1cc"><select name="deleted" size="1">
      <option value="0">Visi</option>
      <option value="1">Dzçstie</option>
      <option value="2" selected>Reâlie</option>
    </select> </td>
  </tr>
  <% operacija = Request.Form("operacija") 
  if request.form("subm") <> "1"  then operacija = "0" %>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Operâcija</td>
    <td align="left" bgcolor="#fff1cc"><select name="operacija" size="1">
      <option value="0" <%if operacija="0" then Response.Write " selected " %>>Visas</option>
      <option value="1" <%if operacija="1" then Response.Write " selected " %>>Ieòçmumi</option>
      <option value="2" <%if operacija="2" then Response.Write " selected " %>>Izdevumi</option>
      <option value="3" <%if operacija="3" then Response.Write " selected " %>>Pârskaitîjumi</option>
    </select> </td>
  </tr>
  <% parbaude = Request.Form("parbaude") 
  if request.form("subm") <> "1"  then parbaude = "0" %>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Apstiprinâtâs</td>
    <td align="left" bgcolor="#fff1cc"><select name="parbaude">
      <option value="" <%if parbaude="" then Response.Write " selected " %>>Visas</option>
      <option value="0" <%if parbaude="0" then Response.Write " selected " %>>Apstiprinâtâs</option>
      <option value="1" <%if parbaude="1" then Response.Write " selected " %>>Neapstiprinâtâs</option>
    </select> </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Pieteikums</td>
    <td bgcolor="#fff1cc"><input type="text" size="6" maxlength="6" name="fpid"> </td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Kredîts:</td>
    <td bgcolor="#fff1cc"><input type="text" name="kredits"
    value="<%=Request.Form("kredits")%>" size="20" onblur='JSPoints (document.forma.kredits)'></td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Debets:</td>
    <td bgcolor="#fff1cc"><input type="text" name="debets" value="<%=Request.Form("debets")%>"
    size="20" onblur='JSPoints (document.forma.debets)'></td>
  </tr>
  <tr>
    <td align="right" bgcolor="#ffc1cc">Izdrukai</td>
    <td bgcolor="#fff1cc"><input type="checkbox" name="izdrukai" <%if request.form("izdrukai") = "on" then response.write " checked "%> ></td>
  </tr>
</table>
</center></div><INPUT type="hidden" name="subm" value="1"><!--webbot
bot="HTMLMarkup" endspan -->


<p align="center"><input type="image" name="meklet" src="impro/bildes/meklet.jpg"
alt="Nospieþot ðo pogu tiks atrastas visas grupas, kas atbilst dotajiem nosacîjumiem."
WIDTH="25" HEIGHT="25"> <% End if 

if request.form("subm") = "1"  then 
'@ 0 Creating SQL
qbfrom="FROM orderis o, valuta  WHERE 1=1  AND o.valuta=valuta.id"
qb2from="FROM orderis o Where 1=1"
	if request.form("kas") <> "" then
		qb = qb + " AND o.kas like '%"+cstr(request.form("kas")) + "%' "
	end if
	if Request.Form("kredits")<>"" then
		qb=qb+" AND o.kredits like '"+cstr(request.form("kredits"))+"%' "
	end if
	if Request.Form("debets")<>"" then
		qb=qb+" AND o.debets like '"+cstr(request.form("debets"))+"%' "
	end if
	if request.form("num") <> "" then
		qb = qb + " AND o.num = '"+cstr(request.form("num")) + "' "
	end if
	if request.form("operacija") = "1" then
		qb = qb + " AND o.pid <> 0 "
		qb = qb + " AND (o.nopid = 0 ) "
	end if
	if request.form("operacija") = "2" then
		qb = qb + " AND o.nopid <> 0  "
		qb = qb + " AND (o.pid = 0 ) "
	end if
	if request.form("operacija") = "3" then
		qb = qb + " AND o.nopid <> 0 "
		qb = qb + " AND o.pid <> 0 "
	end if
	if request.form("deleted") = "1" then
		qb = qb + " AND o.deleted = 1 "
	end if
	if request.form("deleted") = "2" then
		qb = qb + " AND (o.deleted = 0)"
	end if
	if request.form("parbaude") <> "" then
		qb = qb + " AND o.parbaude = " + Request.Form("parbaude")
	end if

	if request.form("dat1") <> "" then
		qb = qb + " AND o.datums >= '"+SQLDate(request.form("dat1")) + "' "
	end if
	if request.form("dat2") <> "" then
		qb = qb + " AND o.datums <= '"+SQLDate(request.form("dat2")) + "' "
	end if

	if request.form("fpid") <> "" then
		qb = qb+ " AND (PID = " +REQUEST.FORM("FPID") + " OR nopid = " +request.form("fpid")+ ") "
	END IF
' qb satur atlases nosacîjumus, kas visiem pieprasîjumiem vienâdi
qb2=qb
qf="SELECT o.*, valuta.val  "+qbfrom+qb+" order by o.id "
qf2="Select sum(summaval) as [valsumma] "+qb2from+qb
qf3="Select sum(summa) as [latsumma] "+qb2from+qb
set f = server.createobject("ADODB.Recordset")
f.open qf,conn,3,3
'Response.Write qf

qc=f.recordcount
if qc = 0 then response.write "Nav atrasta neviena operâcija."
if qc > 500 then response.write "Atrastas vairâk nekâ 500 operâcijas. Nevar parâdît."
if qc > 0 and qc < 500 then
	'rekordsets, kas skatâs, vai ir vajadzîga summa valûtâ- vai ir tikai viena valûta, vai vairâkas
	qvalqstr="Select distinct valuta "+qb2from+qb2
	set qval=server.CreateObject("adodb.recordset")
	qval.open qvalqstr,conn,3,3
	set rs0=conn.Execute(qf2)
	valsum= nullprint(rs0("valsumma"))
	set rsLs=conn.Execute(qf3)
	latsum=nullprint(rsLs("latsumma"))
	
response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"operâcija","operâcijas")
%></p>
<div align="center"><center>

<table cols="8">
  <tr bgcolor="#ffc1cc">
    <td><p align="center"><font color="BLACK"><strong>ID</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Nr.</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Datums</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Maksâtâjs/Saòçmçjs</strong></font></td>
	    <td><p align="center"><font color="BLACK"><strong>Klients</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Summa latos</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Summa valûtâ</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Valûta</strong></font></td>
<% if request.form("izdrukai") <> "on" then %>
    <td><p align="center"><font color="BLACK"><strong>Pieteikuma ieòçmums</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Pieteikuma izdevums</strong></font></td>
    <td width="50"><p align="center"><font color="BLACK"><strong>Pielikums</strong></font></td>
    <td><p align="center"><font color="BLACK"><strong>Konti</strong></font></td>
<% end if %>
  </tr>
  <tr bgcolor="#fff1cc">
    <td colspan="5" align=right>Kopâ:</td>
    <td valign="center" align=right><%=CurrPrint(latsum)%>
   </td>
    <td valign="center" align=right><%=CurrPrint(valsum)%>
   </td>
    <td colspan="5"></td>
  </tr>
<%
dim par_nosaukums,did
for i=1 to qc
'response.write(nullprint(f("pid")) +"<<<< pid ")
'response.write(nullprint(f("nopid")) +"<<<<< nopid <br>")
	par_nosaukums = ""
	if(nullprint(f("pid")) <> "" and nullprint(f("pid"))<>0) then
		set dalibn = conn.execute("SELECT DISTINCT did FROm piet_saite WHERE pid="+cstr(f("pid"))+"")
		if not dalibn.eof then
			did = dalibn(0)
			set maksaja_par = conn.execute("SELECT * FROm dalibn WHERE id ="+cstr(did)) 
			if not maksaja_par.eof then
				par_nosaukums = maksaja_par("vards") + " " + maksaja_par("uzvards")
		
				
			end if
		end if
	else
		if (nullprint(f("nopid")) <> "" and nullprint(f("nopid"))<>0) then
			set dalibn = conn.execute("SELECT DISTINCT did FROm piet_saite WHERE pid="+cstr(f("nopid"))+"")
			if not dalibn.eof then
				did = dalibn(0)
				set maksaja_par = conn.execute("SELECT * FROm dalibn WHERE id ="+cstr(did)) 
				if not maksaja_par.eof then
					par_nosaukums = maksaja_par("vards") + " " + maksaja_par("uzvards")
			
					
				end if
			end if
		end if
	end if
	
%>
  <tr bgcolor="#fff1cc" >
    <td><a href="ordedit.asp?oid=<%=cstr(f("id"))%>" target="none"><%=f("id")%></a></td>
	<% If f("resurss")="14.B" Then %>
	    <td><font color=red><%=f("num")%></font>
	<% else %>
	    <td><font><%=f("num")%></font>
	<% End If %>
</td>
    <td><%=dateprint(f("datums"))%>
</td>
    <td><%=NullPrint(f("kas"))%>
</td>
    <td><%=par_nosaukums%>
</td>
    <td align=right><%=CurrPrint(f("summa"))%>
    <% ssumma = ssumma + getnum(f("summa"))%>
</td>
    <td align=right><%=CurrPrint(f("summaval"))%>
    <% ssummaval = ssummaval + getnum(f("summaval"))%>
</td>
    <td><%=f("val")%>
</td>
<% if request.form("izdrukai") <> "on" then %>
    <td><a href="pieteikums.asp?pid=<%=nullprint(f("pid"))%>" target="none"><%=piet_info(nullprint(f("pid")))%></a></td>
    <td><a href="pieteikums.asp?pid=<%=nullprint(f("nopid"))%>" target="none"><%=piet_info(nullprint(f("nopid")))%></a></td>
<!--    <td><a href="pieteikums.asp?pid=<%=nullprint(f("pid"))%>" target = none >Pieteikums</a></td>    <td><a href="pieteikums.asp?pid=<%=nullprint(f("nopid"))%>" target = none >Pieteikums</a></td> -->
	<td wrap><%=nullprint(f("pielikums"))%></td>
    <td>Kredîts: <%=f("kredits")%><br>
    Debets: <%=f("debets")%></td>
<% end if %>
  </tr>
<%
f.movenext
next
end if
%>
</table>
</center></div><%end if%>

</form>
</body>
</html>
