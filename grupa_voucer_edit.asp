<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn

gid = request.querystring("gid")
Set grupa = conn.execute("select reiss_no,reiss_uz,sakuma_dat,beigu_dat,[mid],carter_viesn_id from grupa where id = "+CStr(gid))
m_v = conn.execute("select v2 from marsruts where id = (select [mid] from grupa where id = "+CStr(gid)+")")(0)

''meklçjam vai vauèeris ðai grupai eksistç
Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
If rv.eof Then
	'' vauèera nav, izveidojam jaunu ierakstu
	conn.execute("insert into voucer (gid) values ("+CStr(gid)+")")
End if


If request.form("submit")<>"" Then
	lidojums1 = encode(sqltext(request.form("lidojums1")))
	lidojums2 = encode(sqltext(request.form("lidojums2")))
	lidojums_info = encode(sqltext(request.form("lidojums_info")))
	beigu_teksts = encode(sqltext(request.form("beigu_teksts")))

	If request.form("n_lidojums")<>"" then
		n_lidojums = "1"
	Else
		n_lidojums = "0"
	End If
	If request.form("n_ekskursija")<>"" then
		n_ekskursija = "1"
	Else
		n_ekskursija = "0"
	End If
	If request.form("n_viesnica")<>"" then
		n_viesnica = "1"
	Else
		n_viesnica = "0"
	End If
	
End if

''---------------- mainam vienai grupai ----------------------
If request.form("submit")="1" Then
	

	Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
	voucer_id = rv("id")


	conn.execute("update voucer set " + _
		" lidojums1 = '"+lidojums1+"'," + _
		" lidojums2 = '"+lidojums2+"'," + _
		" lidojums_info = '"+lidojums_info+"'," + _
		" beigu_teksts = '"+beigu_teksts+"', " + _
		" n_lidojums = "+n_lidojums+", " + _
		" n_viesnica = "+n_viesnica+", " + _
		" n_ekskursija = "+n_ekskursija+" " + _
		" where id = "+CStr(voucer_id))
End if

''---------------- mainam marðrutam ----------------------
If request.form("submit")="2" Then

	m_id = grupa("mid")
	Set rgr = conn.execute("select id from grupa where [mid] = "+CStr(m_id))
	While Not rgr.eof 
		gid = rgr("id")
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		If rv.eof Then
			'' vauèera nav, izveidojam jaunu ierakstu
			conn.execute("insert into voucer (gid) values ("+CStr(gid)+")")
		End if
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		voucer_id = rv("id")


		conn.execute("update voucer set " + _
			" lidojums1 = '"+lidojums1+"'," + _
			" lidojums2 = '"+lidojums2+"'," + _
			" lidojums_info = '"+lidojums_info+"'," + _
			" beigu_teksts = '"+beigu_teksts+"', " + _
			" n_lidojums = "+n_lidojums+", " + _
			" n_viesnica = "+n_viesnica+", " + _
			" n_ekskursija = "+n_ekskursija+" " + _
			" where id = "+CStr(voucer_id))
		rgr.movenext
	wend
End if

''---------------- mainam valstij (atslçgts nav vajadzîgs) ----------------------
If request.form("submit")="3" Then

	''carter_viesn_id
	cvid = grupa("carter_viesn_id")
	Set rgr = conn.execute("select id from grupa where sakuma_dat > getdate() and carter_viesn_id in (select id from carter_viesnicas where valsts in (select valsts from carter_viesnicas where id = "+CStr(cvid)+"))")
	While Not rgr.eof 
		gid = rgr("id")
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		If rv.eof Then
			'' vauèera nav, izveidojam jaunu ierakstu
			conn.execute("insert into voucer (gid) values ("+CStr(gid)+")")
		End if
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		voucer_id = rv("id")


		conn.execute("update voucer set " + _
			" lidojums1 = '"+lidojums1+"'," + _
			" lidojums2 = '"+lidojums2+"'," + _
			" lidojums_info = '"+lidojums_info+"'," + _
			" beigu_teksts = '"+beigu_teksts+"', " + _
			" n_lidojums = "+n_lidojums+", " + _
			" n_viesnica = "+n_viesnica+", " + _
			" n_ekskursija = "+n_ekskursija+" " + _
			" where id = "+CStr(voucer_id))
		rgr.movenext
	Wend
End if

''---------------- mainam reisam ----------------------
If request.form("submit")="4" Then

	''reiss
	Set grupa = conn.execute("select lidojums,sakuma_dat,beigu_dat,[mid],carter_viesn_id from grupa where id = "+CStr(gid))
	lidojums = grupa("lidojums")

	If getnum(lidojums) = 0 Then
		response.write "Reiss nav noradits (lidojuma datums vietu kontrolei)"
		Response.end
	End if

	Set rgr = conn.execute("select id from grupa where sakuma_dat > getdate() and lidojums = '"+sqldate(lidojums)+"'")
	While Not rgr.eof 
		gid = rgr("id")
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		If rv.eof Then
			'' vauèera nav, izveidojam jaunu ierakstu
			conn.execute("insert into voucer (gid) values ("+CStr(gid)+")")
		End if
		Set rv = conn.execute("select id from voucer where gid = "+CStr(gid))
		voucer_id = rv("id")

		conn.execute("update voucer set " + _
			" lidojums1 = '"+lidojums1+"'," + _
			" lidojums2 = '"+lidojums2+"'," + _
			" lidojums_info = '"+lidojums_info+"'," + _
			" beigu_teksts = '"+beigu_teksts+"', " + _
			" n_lidojums = "+n_lidojums+", " + _
			" n_viesnica = "+n_viesnica+", " + _
			" n_ekskursija = "+n_ekskursija+" " + _
			" where id = "+CStr(voucer_id))
		rgr.movenext
	Wend
End if


Set r = server.createobject("ADODB.Recordset")
r.open "select * from voucer where gid = "+CStr(gid),conn,3,3


docstart "Vauèera rediìçðana","y1.jpg"%>
<center><font color="GREEN" size="5"><b>Vauèera rediìçðana</b></font><hr>
<%headlinks
DefJavaSubmit


%>
<BR>
<font style="font-size:20">
	<a href=grupa_edit.asp?gid=<%=gid%>><%=decode(m_v)%><BR><%=grupa("sakuma_dat")%> - <%=grupa("beigu_dat")%></a>
</font>
<BR><BR>



<form name="forma" method="POST">
<center>
<table>
	<tr>
		<td>
		Lidojums 1
		</td>
		<td>
		<textarea cols=50 rows=10 name=lidojums1><%=decode(r("lidojums1"))%></textarea>
		</td>
	</tr>
	<tr>
		<td>
		Lidojums 2
		</td>
		<td>
		<textarea cols=50 rows=10 name=lidojums2><%=decode(r("lidojums2"))%></textarea>
		</td>
	</tr>
	<tr>
		<td>
		Informâcija par lidojumu
		</td>
		<td>
		<textarea cols=50 rows=10 name=lidojums_info><%=decode(r("lidojums_info"))%></textarea>
		</td>
	</tr>
	<tr>
		<td>
		Beigu teksts
		</td>
		<td>
		<textarea name=beigu_teksts cols=50 rows=10><%=decode(r("beigu_teksts"))%></textarea>
		</td>
	</tr>
	<tr>
		<td>
		Nerâdît lidojumu
		</td>
		<td>
		<input type=checkbox name=n_lidojums <% If r("n_lidojums") Then Response.write " checked " %>>
		</td>
	</tr>
	<tr>
		<td>
		Nerâdît ekskursijas
		</td>
		<td>
		<input type=checkbox name=n_ekskursija <% If r("n_ekskursija") Then Response.write " checked " %>>
		</td>
	</tr>
	<tr>
		<td>
		Nerâdît viesnicas
		</td>
		<td>
		<input type=checkbox name=n_viesnica <% If r("n_viesnica") Then Response.write " checked " %>>
		</td>
	</tr>
</table>
<input type=hidden name=submit value=1>
<input type=submit value="Saglabât">
<input type=submit value="Saglabât visam marsrutam" onclick="
	if (!confirm('Tiks izmainiti vairaku grupu vauceri!')) 
		return false; 
	form.submit.value=2">
<input type=submit value="Saglabât visam reisam" onclick="
	if (!confirm('Tiks izmainiti vairaku grupu vauceri!')) 
		return false; 
	form.submit.value=4">
<!--<input type=submit value="Saglabât visâm marðruta grupâm">-->
</form>
</body>
</html>