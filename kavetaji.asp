<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
docstart "Kavçtâju sraksts. ","y1.jpg"
dim Conn
dim rec
OpenConn

if request.form("grupaskavetaji.x") <> "" then
query = "SELECT gid,datums,summa,sakuma_dat FROM terms INNER JOIN grupa ON terms.gid = grupa.id " + _
" WHERE gid = " + cstr(request.form("gid"))
end if

if request.form("visikavetaji.x") <> "" then
query = "SELECT gid,datums,summa,sakuma_dat,vietas_veids  FROM terms INNER JOIN grupa ON terms.gid = grupa.id WHERE sakuma_dat > #" + SQLDate(date()) + "# and datums < #" + SQLDate(date()) + "#"
end if

set rec = conn.execute (query)

DefJavaSubmit
%>
<center><font color="GREEN" size="5"><b>Kavçtâju saraksts</b></font><hr>
<%headlinks
if session("message") <> "" then
%>
<font size = "4" color = "GREEN"><%=session("message")%></font>
<% session("message") = ""
end if %>
<br>
<table border = 0>
<tr bgcolor = #ffc1cc>
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
rPiet.open "SELECT * FROM pieteikums INNER JOIN piet_saite ON pieteikums.id = piet_saite.pid WHERE gid = " + cstr(rec("gid")),conn,3,3
while not rPiet.eof
' ----- pârbauda vai ðis pieteikums nav nokavçjis
vietas = piet_personas(rPiet("pieteikums.id"))
' ---- lai nebuutu daliijums ar nulli
if vietas = 0 then vietas = 1
if piet_iemaksas(rPiet("pieteikums.id")) / vietas < rec("summa") AND (GetNum(rec("vietas_veids")) = GetNum(rPiet("vietas_veids")) OR GetNum(rec("vietas_veids")) = 0)  then
	' ------ pievieno sarakstam ðo pieteikumu
	if PrevGid <> rec("gid") then
		%>
		<tr><td colspan = 9 bgcolor = NavajoWhite>
		<%=NullPrint(id_field("marsruts",id_field("grupa",rPiet("gid"),"mid"),"v")) + " " + DatePrint(rec("sakuma_dat"))%></td><tr>
		<%
		PrevGid = rec("gid")
	end if
	set rDal = Server.CreateObject("ADODB.Recordset")
	rDal.open "SELECT * FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did WHERE piet_saite.deleted <> 1 and pid = "+cstr(rPiet("id")),conn,3,3
	while not rDal.eof
	%>
	<tr bgcolor = #fff1cc>
	<td><a href = "pieteikums.asp?pid=<%=rPiet("id")%>"><%=NullPrint(DatePrint(rPiet("datums")))%></a></td>
	<td><a href = "dalibn.asp?i=<%=rDal("did")%>"><%=nullprint(rDal("vards"))+" "%> <%=nullprint(rDal("uzvards"))%> <%=nullprint(rDal("nosaukums"))%></a></td>
	<td align = "center"><%=cstr(piet_iemaksas(rPiet("id")))%></td>
	<td align = "center"><%=rec("summa")%></td>
	<td align = "center"><%=dateprint(rec("datums"))%></td>
	<td><%=nullprint(rDal("talrunisM"))%></td>
	<td><%=nullprint(rDal("talrunisD"))%></td>
	<td><%=nullprint(rDal("talrunisMob"))%></td>
	<td><%=nullprint(rDal("eadr"))%></td>
	<tr>
	<%
	rDal.movenext
	wend
	%>


	<%
end if
rPiet.movenext
wend
rPiet.close
rec.movenext
wend %>
</table>

</body>
</html>

