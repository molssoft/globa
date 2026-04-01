<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if
'standarts visaam lapaam
docstart "Anketu statistika","y1.jpg"
DefJavaSubmit
dim asc
if session("asc") = "" then session("asc") = "0"
if request.form("atkal") = 1 then
	session("fDatNo") = request.form("fDatNo")
	fDatNo = request.form("fDatNo")
	session("fDatLidz") = request.form("fDatLidz")
	fDatLidz = request.form("fDatLidz")
	session("atkal") = request.form("atkal")
	atkal = request.form("atkal")
	session("veids") = request.form("veids")
	veids = request.form("veids")
	session("order") = Request.Form("order")
	order = Request.Form("order")
	session("asc") = Request.Form("asc")
	asc = Request.Form("asc")
else
	fDatNo = ""
	fDatLidz = ""
	veids = session("veids")
	atkal = session("atkal")
	order = session("order")
	asc = session("asc")
end if

%>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Anketu statistika</b></font><hr>

<%
' standarta saites

headlinks

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

'@ 0 Atver valûtu tabulu
set r = server.createobject("ADODB.Recordset")
if veids = "" then veids = 0
if order = "" then order = 1
if asc = "" then asc = "0"
q = ""
if fDatNo <> "" then q = q + " and grupa.beigu_dat >= '" + sqldate(fDatNo) + "'"
if fDatLidz <> "" then q = q + " and grupa.sakuma_dat <= '" + sqldate(fDatLidz) + "'"
q = q
if veids = 0 then
 q = "select round(avg(atz_vaditajs),2) as atzime, count(atz_vaditajs) as skaits, grupu_vaditaji.vards, grupu_vaditaji.uzvards " + _
 "from anketas inner join grupa on gid = grupa.id " + _
 "inner join grupu_vaditaji on grupa.vaditajs = grupu_vaditaji.idnum " + _
 "where not atz_vaditajs is null " + q + _
 "group by grupu_vaditaji.vards, grupu_vaditaji.uzvards ORDER BY " & order & IIF(asc="0","desc","asc")
elseif veids = 1 then
 q = "select round(avg(atz_marsruts),2) as atzime, count(atz_marsruts) as skaits, marsruts.v as Marsruts, valstis.title as Valsts " + _
 "from anketas inner join grupa on gid = grupa.id " + _
 "inner join marsruts on grupa.mid = marsruts.id " + _
 "inner join valstis on valstis.id = marsruts.valsts " + _
 "where not atz_marsruts is null " + q + _
 "group by marsruts.v, valstis.title ORDER BY " & order & IIF(asc="0","desc","asc")
elseif veids = 2 then
 q = "select round(avg(atz_transports),2) as atzime, count(atz_transports) as skaits, autobusi.soferis, autobusi.nosaukums " + _
 "from anketas inner join grupa on gid = grupa.id " + _
 "inner join autobusi on grupa.autobuss_id = autobusi.id " + _
 "where not atz_transports is null " + q + _
 "group by autobusi.soferis, autobusi.nosaukums ORDER BY " & order & IIF(asc="0","desc","asc")
end if
r.open q,conn,3,3
%>

<form name="forma" action = "anketas_stat.asp" method = "POST">
<font color="BLACK" size="3"><br><b>Apkopot statistiku par anketâm
<table>
<tr><td bgcolor = #ffc1cc>Datums: </td><td colspan=2 bgcolor = #fff1cc><input type="text" name = "fDatNo" size = 10 value = <%=fDatNo%>>
-<input type="text" name = "fDatLidz" size = 10 value = <% = fDatLidz%>></td></tr>
<tr><td bgcolor = #ffc1cc>Veids: </td><td bgcolor = #fff1cc><select name="veids"><%
Response.Write "<option value=0" & IIF(veids=0," selected","") & ">Pçc grupas vadîtâja</option>"
Response.Write "<option value=1" & IIF(veids=1," selected","") & ">Pçc marðruta</option>"
Response.Write "<option value=2" & IIF(veids=2," selected","") & ">Pçc autobusa</option>"%>
</select></td>
<td><input type="submit" alt = "Nospieþot ðo pogu tiks apkopota statistika par anketâm" name = "poga" value = "Apkopot" onclick="{if (<%=veids%> != veids.value) {order.value = 1; asc.value = 0;}}"></td></tr>
</table>
<input type="hidden" name="atkal" value="1">
<input type="hidden" name="order" value=<%=order%>>
<input type="hidden" name="asc" value=<%=asc%>>

<!--@ 0 Attçlo tabulu -->

<%
if Request.Form("veids") <> "" then %>
<br>
<table width=100%>
<tr bgcolor = #ffC1cc>
<% if Request.Form("veids") = 0 then %>
 <th><a href="#" alt="Sakârtot pçc vârda" onclick="{if (order.value == 3) {asc.value = 1 - asc.value;} else {order.value = 3; asc.value = 1;} document.forms[0].submit();}">Vârds</a></th>
 <th><a href="#" alt="Sakârtot pçc uzvârda" onclick="{if (order.value == 4) {asc.value = 1 - asc.value;} else {order.value = 4; asc.value = 1;} document.forms[0].submit();}">Uzvârds</a></th>
<% elseif request.form("veids") = 1 then %>
 <th><a href="#" alt="Sakârtot pçc marðruta" onclick="{if (order.value == 3) {asc.value = 1 - asc.value;} else {order.value = 3; asc.value = 1;} document.forms[0].submit();}">Marðruts</a></th>
 <th><a href="#" alt="Sakârtot pçc valsts" onclick="{if (order.value == 4) {asc.value = 1 - asc.value;} else {order.value = 4; asc.value = 1;} document.forms[0].submit();}">Valsts</a></th>
<% elseif request.form("veids") = 2 then %>
 <th><a href="#" alt="Sakârtot pçc ðofera" onclick="{if (order.value == 3) {asc.value = 1 - asc.value;} else {order.value = 3; asc.value = 1;} document.forms[0].submit();}">Ðoferis</a></th>
 <th><a href="#" alt="Sakârtot pçc nosaukuma" onclick="{if (order.value == 4) {asc.value = 1 - asc.value;} else {order.value = 4; asc.value = 1;} document.forms[0].submit();}">Nosaukums</a></th>
<% end if %>
<th width=12%><a href="#" alt="Sakârtot pçc atzîmes" onclick="{if (order.value == 1) {asc.value = 1 - asc.value;} else {order.value = 1; asc.value = 0;} document.forms[0].submit();}">Atzîme</a></th>
<th width=12%><a href="#" alt="Sakârtot pçc skaita" onclick="{if (order.value == 2) {asc.value = 1 - asc.value;} else {order.value = 2; asc.value = 0;} document.forms[0].submit();}">Skaits</a></th>
</tr>
<%
while not r.eof
	response.write "<tr bgcolor = #fff1cc>"
	if Request.Form("veids") = 0 then %>
  <td><%=r("vards")%></td>
  <td><%=r("uzvards")%></td>
 <% elseif request.form("veids") = 1 then %>
  <td><%=r("marsruts")%></td>
  <td><%=r("valsts")%></td>
 <% elseif request.form("veids") = 2 then %>
  <td><%=Decode(r("soferis"))%></td>
  <td><%=Decode(r("nosaukums"))%></td>
 <% end if
 Response.Write "<td>" & r("atzime") & "</td>"
 Response.Write "<td>" & r("skaits") & "</td>"
	response.write "</tr>"
	r.movenext
wend
%>
</table>
<% end if %>
</form>
</body>
</html>
