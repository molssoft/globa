<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
docstart "Pieteikumu statistika","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pieteikumu statistika</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

%>

<form name="forma" action="piet_stat.asp" method="POST">
<table>
<tr><td align="right" bgcolor="#ffc1cc">Datums <b>ne agrâk par: </td><td bgcolor="#fff1cc"><input type="text" size="8" maxlength="10" name="dat1" value="<%=request.form("dat1")%>"> <b>ne vçlâk par:</b> 
	<input type="text" size="8" maxlength="10" name="dat2" value="<%=request.form("dat2")%>"> </tr>
<tr><td align="right" bgcolor="#ffc1cc">Periods</td><td bgcolor="#fff1cc">
	<select name="periods">
		<option <%if request.form("periods") = "day" then response.write " selected "%> value="day">Diena</option>
		<option <%if request.form("periods") = "week" then response.write " selected "%> value="week">Nedçïa</option>
		<option <%if request.form("periods") = "month" then response.write " selected "%> value="month">Mçnesis</option>
		<option <%if request.form("periods") = "year" then response.write " selected "%> value="year">Gads</option>
	</select></td></tr>
</table>
<input type="image" src="impro/bildes/skatit.jpg" name="skatit" WIDTH="116" HEIGHT="25">
<p>

<%
if request.form("skatit.x") <> "" then
	if request.form("periods") = "day" then qb = "SELECT str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) as dat,Count(*) as sk "
	if request.form("periods") = "week" then qb = "SELECT str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) as dat,Count(*) as sk "
	if request.form("periods") = "month" then qb = "SELECT str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) as dat,Count(*) as sk "
	if request.form("periods") = "year" then qb = "SELECT str(DatePart(yyyy,datums)) as dat,Count(*) as sk "
	qb = qb + " FROM pieteikums "
	qb = qb + " where deleted = 0 "
	if request.form("dat1") <> "" then
		qb = qb + " AND datums >= '"+SQLDate(request.form("dat1")) + "' "
	end if
	if request.form("dat2") <> "" then
		qb = qb + " AND datums <= '"+SQLDate(request.form("dat2")) + "' "
	end if
	if request.form("periods") = "day" then qb = qb + " GROUP BY str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) order by str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) "
	if request.form("periods") = "week" then qb = qb + " GROUP BY (str(int(datums) - DatePart(ww,datums)+1) + ' - ' + str(int(datums) - DatePart(ww,datums)+7)),DatePart(yyyy,datums) ORDER BY DatePart(yyyy,datums)  "
	if request.form("periods") = "month" then qb = qb + " GROUP BY str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) order by str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) "
	if request.form("periods") = "year" then qb = qb + " GROUP BY str(DatePart(yyyy,datums)) order by str(DatePart(yyyy,datums)) "

	set rec = server.createobject("ADODB.Recordset")
	rec.open qb,conn,3,3
	if rec.recordcount <> 0 then
		while not rec.eof
			if rec("sk")>max then max = rec("sk")
			rec.movenext
		wend
		rec.movefirst %>
		
		<table width=100%>
		<tr bgcolor="#ffc1cc">
		<th>Datums</th>
		<th>Piet. sk.</th>
		<th></th>
		</tr>
		<% while not rec.eof %>
		<tr bgcolor="#fff1cc">
			<td align="right"><%=nullprint(rec("dat"))%></td>
			<td align="right"><b><%=cstr(rec("sk"))%></b></td><td width="70%">
			<table width="<%=(rec("sk")/max)*100%>%"><tr><td bgcolor="#0000B0">.</td></tr></table>
		</td></tr>
		<% rec.movenext
		wend %>
	
		</table>
		
	<% else %>
		Nav informâcijas par doto laika intervâlu.
	<% end if
end if %>


</form>
</body>
</html>
