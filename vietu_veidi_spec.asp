<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%
dim conn
OpenConn
id = request.querystring("id")
gid = conn.execute("select gid from vietu_veidi where id = "+id)(0)


'-------------- save -----------------
If request.form("save") = "1" Then

	Set r = conn.execute("select * from vietu_veidi where id = " + id)

	nosaukums = request.form("nosaukums")
	cenaEUR = request.form("cenaEUR")
	laiks_no = encode(request.form("laiks_no"))
	laiks_lidz = encode(request.form("laiks_lidz"))
	tips = r("tips") + "_NA"

	fl = fieldlist("vietu_veidi")
	sql = "insert into vietu_veidi (" + fl + ") select " + fl + " from vietu_veidi where id = " + id

	conn.execute sql

	newid = LastID("vietu_veidi")

	sql = "update vietu_veidi set " + _
		" nosaukums = '" + nosaukums + "', " + _
		" cenaEUR = " + cenaEUR + ", " + _
		" laiks_no = '" + SQLTime(laiks_no) + "', " + _
		" laiks_lidz = '" + SQLTime(laiks_lidz)+ "', " + _
		" spec_id = '" + id + "', " + _
		" tips = '" + tips + "'" + _
		" where id = "+CStr(newid)
	
	
	conn.execute sql

	Response.redirect "vietu_veidi.asp?gid=" + CStr(gid)
End if


%>

<% 
'@ 0 HTML Start --------------------------
docstart "Aìenta lîguma informâcija","y1.jpg" %>

<center><font color="GREEN" size="5"><b>Jauna speciâlâ cena</b></font>
<hr>
<% headlinks %>

<% 
Set r = conn.execute("select * from vietu_veidi where id = "+request.querystring("id"))

if message <> "" then %>
<center><font color="RED" size="4"><BR><%=Message%></font>
<% end if %>


<center>

<BR>

<!-- Forma -------------------------->
<br><br>
<form name="forma" method="POST">

<table border=0>
	<tr>
		<th>Nosaukums</th>
		<td><input type=text size=20 name=nosaukums value="<%=decode(r("nosaukums"))%>"></td>
	</tr>
	<tr>
		<th>Cena EUR</th>
		<td><input type=text size=10 name=cenaEUR value="<%=currprint(r("cenaEUR"))%>"></td>
	</tr>
	<%	
		If session("vietu_veidi_laiks_no") = 0 Then session("vietu_veidi_laiks_no") = now
		If session("vietu_veidi_laiks_lidz") = 0 Then session("vietu_veidi_laiks_lidz") = now+7
		
	%>
	<tr>
		<th>No</th>
		<td><input type=text size=20 name=laiks_no value="<%=timeprint(session("vietu_veidi_laiks_no"))%>"></td>
	</tr>
	<tr>
		<th>Lîdz</th>
		<td><input type=text size=20 name=laiks_lidz value="<%=timeprint(session("vietu_veidi_laiks_lidz"))%>"></td>
	</tr>

</table>
<BR>
<a href="#" onclick="forma.submit();return false;">[Saglabât]</a> <a href="vietu_veidi.asp?gid=<%=CStr(gid)%>">[Atcelt]</a>

<input type=hidden name="save" value="1" >
</form>
</body>
</html>

