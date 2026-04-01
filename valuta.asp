<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Valûtu kursi","y1.jpg"
DefJavaSubmit

if request.form("atkal") = 1 then
	session("fDatNo") = request.form("fDatNo")
	fDatNo = request.form("fDatNo")
	session("fDatLidz") = request.form("fDatLidz")
	fDatLidz = request.form("fDatLidz")
	session("atkal") = request.form("atkal")
	atkal = request.form("atkal")
	session("fVal") = request.form("fVal")
	fVal = request.form("fVal")
else
	fDatNo = DatePrint(now)
	fDatLidz = DatePrint(now)
	fVal = session("fVal")
	ATKAL = session("atkal")
end if

if request.form("poga") = "Pievienot" then
	if request.form("nKurss") = "" then
		session("message") = "Nav norâdîts valûtas kurss."
	else  
		if request.form("nDat") = "" then 
			session("message") = "Nav norâdîts datums."
		else	
			set r = conn.execute("select * from valutakurss where datums = '" + sqldateYMD(request.form("nDat")) + "' and valuta = " + cstr(request.form("nVal")) )
			if r.eof then
			 conn.execute "insert into valutakurss (valuta, kurss, kurss2, datums) values (" + cstr(request.form("nVal")) + ",1/"+cstr(request.form("nKurss"))+", " + cstr(request.form("nKurss")) + " , '" + sqldateYMD(request.form("nDat")) + "' )"
			else
			 'Response.Write "update valutakurss set kurss = " + cstr(request.form("nKurss")) + " where datums =  '" + sqldate(request.form("nDat")) + "' and valuta = " + cstr(request.form("nVal"))
			 conn.execute "update valutakurss set kurss2 = " + cstr(request.form("nKurss")) + ",kurss = 1/" + cstr(request.form("nKurss")) + " where datums =  '" + sqldateYMD(request.form("nDat")) + "' and valuta = " + cstr(request.form("nVal"))
			end if
		end if
	end if
end if
%>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Valûtu kursi</b></font><hr>

<%
' standarta saites

headlinks

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if request.querystring("dzest") <> "" then
	conn.execute "DELETE FROM valutakurss WHERE id = " + request.querystring("dzest")
end if

'@ 0 Atver valûtu tabulu
set valut = server.createobject("ADODB.Recordset")
if fVal = "" then fVal = "0"

q = "select * from valuta v,valutakurss k where v.id = k.valuta"
if fVal <> "0" then
 q = q + " and v.id = " + fVal
end if
if fDatNo <> "" then
	q = q + " AND k.datums >= '" + sqldateYMD(fDatNo) + "' "
end if
if fDatLidz <> "" then
	q = q + " AND k.datums <= '" + sqldateYMD(fDatLidz) + "' "
end if

q = q + " ORDER BY v.val, k.datums"
response.write q
valut.open q,conn,3,3
%>

<form name="forma" action = "valuta.asp" method = "POST">
<font color="BLACK" size="3"><b>Pievienot vai labot valûtas kursu
<br>
<table>
<tr><td bgcolor = #ffc1cc>Datums: </td><td bgcolor = #fff1cc><input type="text" name = "nDat" size = 10 value =<%=dateprint(Now())%> ></td>
													       <%' Funkcija, kas izsauc shodienas datumu%>
<tr><td bgcolor = #ffc1cc>Valûta: </td><td bgcolor = #fff1cc><% dbcomboplus "valuta","val","id","nVal",68 %></td>
<tr><td bgcolor = #ffc1cc>Kurss (ECB formâts): </td><td bgcolor = #fff1cc><input type="text" name = "nKurss" size = 15 value = <% = nKurss %>></td>
<td><input type="submit" name = "poga" value = "Pievienot"></td></tr>
</table>

<font color="BLACK" size="3"><br><b>Atlasît valûtu kursus
<table>
<tr><td bgcolor = #ffc1cc>Datums: </td><td bgcolor = #fff1cc><input type="text" name = "fDatNo" size = 10 value = <% = fDatNo %>></td>
<td><input type="text" name = "fDatLidz" size = 10 value = <% = fDatLidz%>></td></tr>
<tr><td bgcolor = #ffc1cc>Valûta: </td><td bgcolor = #fff1cc><% dbcomboplus "valuta","val","id","fVal",fVal %></td>
<td><input type="submit" alt = "Nospieþot ðo pogu tiks saglabâtas valûtas kursos izdarîtâs izmaiòas" name = "poga" value = "Skatît"></td></tr>
</table>
<input type="hidden" name="atkal" value="1">

<!--@ 0 Attçlo tabulu -->

<%
if valut.recordcount <> 0 AND ATKAL = 1 then %>
<br>
<table>
<tr bgcolor = #ffC1cc><th>Valûta</th>
<th>Datums</th>
<th>Kurss</th></tr>
<%
while not valut.eof
	response.write "<tr bgcolor = #fff1cc>"
	response.write "<td>"+valut("val")+"</td>"
	response.write "<td>" +dateprint(valut("datums"))+"</td>"
	response.write "<td>"+nullprint(valut("kurss2"))+"</td>"
	'response.write "<td><a href='valuta.asp?dzest=" + cstr(getnum(valut("id"))) + "'><img src='impro/bildes/dzest.jpg' border = 0 alt = 'Dzçst'></a></td>"
	response.write "</tr>"
	valut.movenext
wend
%>
</table>
<% end if %>
</form>
</body>
</html>
