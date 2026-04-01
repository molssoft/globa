<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%
dim conn
OpenConn

'-------------- save -----------------
If request.form("save") = "1" Then
	id = request.querystring("id")
	liguma_vieta = encode(request.form("liguma_vieta"))
	liguma_datums = sqldateq(request.form("liguma_datums"))
	liguma_nr = encode(request.form("liguma_nr"))
	uznemums = encode(request.form("uznemums"))
	regnr = encode(request.form("regnr"))
	adrese = encode(request.form("adrese"))
	tur_regnr = encode(request.form("tur_regnr"))
	liguma_pamats = encode(request.form("liguma_pamats"))
	parstavis = encode(request.form("parstavis"))
	liguma_ievads = encode(request.form("liguma_ievads"))

	sql = ("update agenti set " + _
		" liguma_vieta = '" + liguma_vieta + "', " + _
		" liguma_datums = " + liguma_datums + ", " + _
		" liguma_nr = '" + liguma_nr + "', " + _
		" uznemums = '" + uznemums + "', " + _
		" regnr = '" + regnr + "', " + _
		" adrese = '" + adrese + "', " + _
		" tur_regnr = '" + tur_regnr + "', " + _
		" liguma_pamats = '" + liguma_pamats + "', " + _
		" parstavis = '" + parstavis + "', " + _
		" liguma_ievads = '" + sqltext(liguma_ievads) + "' " + _
		" where id = "+CStr(id))
	
	conn.execute sql
End if


%>

<% 
'@ 0 HTML Start --------------------------
docstart "Aìenta lîguma informâcija","y1.jpg" %>

<center><font color="GREEN" size="5"><b>Aìenta lîguma informâcija</b></font>
<hr>
<% headlinks %>

<% 
Set r = conn.execute("select * from agenti where id = "+request.querystring("id"))

if message <> "" then %>
<center><font color="RED" size="4"><BR><%=Message%></font>
<% end if %>


<center>

<BR>
<font size=4>Aìents:<%=decode(r("vards"))%></font>

<!-- Forma -------------------------->
<br><br>
<form name="forma" method="POST">

<table border=0>
	<tr>
		<th>Lîguma slçgðanas vieta</th>
		<td><input type=text size=20 name=liguma_vieta value="<%=decode(r("liguma_vieta"))%>"></td>
	</tr>
	<tr>
		<th>Lîguma datums</th>
		<td><input type=text size=10 name=liguma_datums value="<%=dateprint(r("liguma_datums"))%>"></td>
	</tr>
	<tr>
		<th>Lîguma numurs</th>
		<td><input type=text size=20 name=liguma_nr value="<%=decode(r("liguma_nr"))%>"></td>
	</tr>
	<tr>
		<th>Uzòçmums</th>
		<td><input type=text size=50 name=uznemums value="<%=decode(r("uznemums"))%>"></td>
	</tr>
	<tr>
		<th>Reì. nr. </th>
		<td><input type=text size=10 name=regnr value="<%=decode(r("regnr"))%>"></td>
	</tr>

	<tr>
		<th>Adrese</th>
		<td><input type=text size=50 name=adrese value="<%=decode(r("adrese"))%>"></td>
	</tr>
	<tr>
		<th>Tûr. Reì. nr. </th>
		<td><input type=text size=10 name=tur_regnr value="<%=decode(r("tur_regnr"))%>"></td>
	</tr>
	<tr>
		<th>Uz ... pamata</th>
		<td><input type=text size=20 name=liguma_pamats value="<%=decode(r("liguma_pamats"))%>"></td>
	</tr>
	<tr>
		<th>Pârstâvis</th>
		<td><input type=text size=20 name=parstavis value="<%=decode(r("parstavis"))%>"></td>
	</tr>
	<tr>
		<% 
		liguma_ievads = r("liguma_ievads") 
		liguma_ievads = decode(liguma_ievads)
		%>
		<th>Lîguma ievads <BR>(ja ðis ir ievadîts, <BR>tad pârçjie dati netiek òemti vçrâ)</th>
		<td><textarea name=liguma_ievads cols=60 rows=7><%=liguma_ievads%></textarea></td>
	</tr>
</table>
<BR>
<a href="#" onclick="forma.submit();return false;">[Saglabât]</a> <a href="agenti.asp">[Atcelt]</a>

<input type=hidden name="save" value="1" >
</form>
</body>
</html>

