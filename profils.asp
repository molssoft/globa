<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "md5.asp" -->

<%
'@ 0 HTML Start --------------------------
docstart "Profils","y1.jpg" %>

<center><font color="GREEN" size="5"><b>Online profils
</b></font>
<%
Dim conn
openconn

pk1 = request.querystring("pk1")
pk2 = request.querystring("pk2")

If request.form("poga")<>"" Then
	If (request.form("pass")<>"") then
		Set c = New cmd5
		pass = c.md5(request.form("pass"))
		conn.execute("update profili set pass = '"+pass+"' where pk1 = '"+pk1+"' and pk2 = '"+pk2+"'")
	End if
	
	If (request.form("eadr")<>"") then
		eadr = request.form("eadr")
		conn.execute("update profili set status = 1, eadr = '"+eadr+"' where pk1 = '"+pk1+"' and pk2 = '"+pk2+"'")
	End if
End if


Set r = conn.execute("select * from profili where pk1 = '"+pk1+"' and pk2 = '"+pk2+"'")

If Not r.eof Then
	%><form method=POST>
	<BR><BR><BR><table><%
	%><tr><td>Vârds</td><td><% 
		Response.write nullprint(r("vards"))
	%></td></tr><%
	%><tr><td>Uzvârds</td><td><% 
		Response.write nullprint(r("uzvards"))
	%></td></tr><%
	Response.write "<tr><td>Personas kods</td><td>"+nullprint(r("pk1"))+"-"+nullprint(r("pk2"))+"</td></tr>"
	Response.write "<tr><td>Pase</td><td>"+nullprint(r("paseS"))+" "+nullprint(r("paseNr"))+"</td></tr>"
	%><tr><td>Pases termiòð</td><td><% 
	Response.write dateprint(r("paseTerm"))
	Response.write "<tr><td>id karte</td><td>"+nullprint(r("idS"))+" "+nullprint(r("idNr"))+"</td></tr>"
	%><tr><td>ID kartes termiòð</td><td><% 
		Response.write dateprint(r("idDerDat"))
	%></td></tr><%
	%><tr><td>Dzimums</td><td><% 
		Response.write nullprint(r("dzimta"))
	%></td></tr><%
	%><tr><td>Online lietotâjs</td><td><% 
		Response.write nullprint(r("user_name"))
	%></td></tr><%
	%><tr><td>E-pasts</td><td>
		<input type=text name=eadr value="<%=r("eadr")%>">
	</td></tr><%
	%><tr><td>Jauna parole</td><td>
		<input type=text name=pass value="">
	</td></tr><%
	%><tr><td>Adrese</td><td><% 
		Response.write nullprint(r("adrese"))
	%></td></tr><%
	%><tr><td>Pilsçta</td><td><% 
		Response.write nullprint(r("pilseta"))
	%></td></tr><%
	%><tr><td>Indekss</td><td><% 
		Response.write nullprint(r("indekss"))
	%></td></tr><%
	%><tr><td>Tâlrunis mâjâs</td><td><% 
		Response.write nullprint(r("talrunisM"))
	%></td></tr><%
	%><tr><td>Tâlrunis darbâ</td><td><% 
		Response.write nullprint(r("talrunisD"))
	%></td></tr><%
	%><tr><td>Mobilais</td><td><% 
		Response.write nullprint(r("talrunisMob"))
	%></td></tr><%
	%><tr><td>Novads</td><td><% 
		if r("novads") <> "" then
			Set rnov = conn.execute("select * from novads where id = "+CStr(r("novads")))
			If Not rnov.eof then
				Response.write nullprint(rnov("nosaukums"))
			End if
		end if
	%></td></tr><%

	Response.write "</table>"
	%>
	<input type=submit name=poga value="Saglabât">
	</form>
	
	<%
	If r("banned") then
		%>
		<font size="4" color="red">Liegta pieeja tieðsaistes rezervâcijas sistçmai no <%=dateprint(r("ban_date"))%></font>
		<%
	else
		If isaccess(T_LIETOT_ADMIN) Then
			%><BR><br><a href=bloket_online_profilu.php?id=<%=cstr(r("id"))%> onclick="return confirm('Vai tieðâm vçlaties bloíçt ðî lietotâja online profilu?');">Bloíçt profilu</a><%
		End if
	end if
End if
%>

