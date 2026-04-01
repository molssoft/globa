<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
if Request.QueryString("gid") = "" then response.write "Nav norâdîts grupas ID<br><br>"
gid = request.querystring("gid")

docstart "Viesnicu numuru veidi","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Viesnicu numuru veidi</b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>
<%
headlinks 

%>
<center><font size="2">[ <a href="viesnicas.asp?gid=<%=Request.QueryString("gid")%>">Viesnicu numuri</a> ]
[ <a href="grupa_edit.asp?gid=<%=Request.QueryString("gid")%>">Grupa</a> ]
<%
DefJavaSubmit
checkGroupBlocked(gid)

if session("message") <> "" then
	response.write  "<center><font color='RED' size='5'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if
%>
<form name="forma" method="POST" action="viesnicu_numuru_veidi.asp<%=qstring()%>">
<center> <table border="0">
<tr bgcolor="#ffc1cc">
<th>Nosaukums</th>
<th>Latvisks nosaukums<BR>priekð online</th>
<th>+1 +2 utt.</th>
<th>Pieauguoðo<BR>vietas</th>
<th>Bçrnu<BR>vietas</th>
<th>Kopâ<BR>vietas</th>
<th>Var 2</th>
<th>Bâzes cena</th>
<th>Bçrna cena</th>
<th>Pieejams<br>online*</th>
<th colspan=3>Statistika</th>
<th></th>
<th></th>
</tr>
<%
'------------- 1 Atrodam kajiites --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select * from viesnicas_veidi where gid = " + cstr(gid),conn,3,3 '--+ " order by nosaukums"
if r.recordcount <> 0 then
	r.movefirst
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
		<td>
			<input type="text" size="20" name="nosaukums<%=r("id")%>" value="<%=NullPrint(r("nosaukums"))%>">
		</td>
		<td><input type="text" size="20" name="pilns_nosaukums<%=r("id")%>" value="<%=NullPrint(r("pilns_nosaukums"))%>">
		</td>
		<td><input type="text" size="10" name="piezimes<%=r("id")%>" value="<%=NullPrint(r("piezimes"))%>"></td>
		<td align="center"><input type="text" size="7" name="pieaug_vietas<%=r("id")%>" value="<%=GetNum(r("pieaug_vietas"))%>"></td>
		<td align="center"><input type="text" size="7" name="bernu_vietas<%=r("id")%>" value="<%=GetNum(r("bernu_vietas"))%>"></td>
		
		<td align="center"><input type="text" size="7" name="vietas<%=r("id")%>" value="<%=GetNum(r("vietas"))%>"></td>
		<td><input type=checkbox name="var2<%=r("id")%>" value=1 
				<%if r("var2")=1 then response.write " checked " %>
			></td>
		<td>
			<% set rcena = conn.execute("select * from vietu_veidi where gid = "+cstr(gid)+" and tips = 'VV' order by nosaukums") %>
			<select name="cena<%=r("id")%>">
				<option value="">-</option>
				<% 
				while not rcena.eof 
					%><option value="<%=rcena("id")%>"
					<% if rcena("id") = r("vietu_veidi_id") then response.write " selected " %>
					><%=rcena("nosaukums")%></option><%
					rcena.movenext
				wend
				%>
			</select>
		</td>
		<td>
			<% set rcena = conn.execute("select * from vietu_veidi where gid = "+cstr(gid)+" and tips = 'VV' order by nosaukums") %>
			<select name="cena_child<%=r("id")%>">
				<option value="">-</option>
				<% 
				while not rcena.eof 
					%><option value="<%=rcena("id")%>"
					<% if rcena("id") = r("vietu_veidi_child_id") then response.write " selected " %>
					><%=rcena("nosaukums")%></option><%
					rcena.movenext
				wend
				%>
			</select>
		</td>
		<td><% if (r("pieejams_online")) then %><font color="green">&#10004;</font><% else %><font color="red">nav</font><% end if%></td>
		<td>
		 <% 'aizòemtâs vietas
		 a=conn.execute("select count(*) from piet_saite where deleted = 0 and vid in (select id from viesnicas where veids = "+cstr(r("id"))+")")(0)
		 Response.Write a
		 aiznemts = aiznemts + a %>	</td>
		<td>
		 <% 'brîvâs vietas
		 x=conn.execute("select count(*) from viesnicas where veids = "+cstr(r("id")))(0)*r("vietas")
		 b=x-a
		 Response.Write b
		 brivs = brivs + b %>	</td>
		<td>
		 <% 'vietas kopâ visâs ðî veida kajîtçs
		 Response.Write x
		 vietas = vietas + x %>	</td>
		<td><input type="image" src="impro/bildes/dzest.jpg" onclick="if (!checkBlocked()) {return false;} if (confirm('Dzçst?')) {forma.action='viesnicas_veidi_del.asp?id=<%=cstr(r("id"))%>';forma.submit();} return false;" alt="Dzçst ierakstu." WIDTH="25" HEIGHT="25"></td>
		<td><input type="image" src="impro/bildes/saglabat.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit2('viesnicas_veidi_save.asp?id=<%=cstr(r("id"))%>')" alt="Saglabât izmaiòas ðajâ rindâ." WIDTH="25" HEIGHT="25"></td>
		</tr>
		<%
		r.MoveNext
	wend
end if

%><p>
<tr bgcolor="#fff1cc">
<td align="center"><input type="text" name="nosaukums" size="20"></td>
<td align="center"><input type="text" name="pilns_nosaukums" size="20"></td>
<td align="center"><input type="text" name="piezimes" size="10"></td>
<td align="center"><input type="text" name="pieaug_vietas" size="7">
<td align="center"><input type="text" name="bernu_vietas" size="7">
<td align="center"><input type="text" name="vietas" size="7">
	<input type=hidden name=gid value=<%=gid%>>
</td>
<td></td>
<td><b><%=aiznemts%></b></td>
<td><b><%=brivs%></b></td>
<td><b><%=vietas%></b></td>
<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit2('viesnicas_veidi_add.asp')" alt="Pievienot jaunu viesnicas numura veidu." WIDTH="25" HEIGHT="25"></td>
</tr></table>
<div style="max-width:900px;text-align:left">
*Ja nosaukumâ parâdîsies kaut kas cits, izòemot:<br>
<ul>
<% set rV = conn.execute("SELECT nosaukums FROM viesnicas_veidi_online")

while not rV.eof
	rw "<li>"+rV("nosaukums")+"</li>"
	rV.MoveNext

wend
 %>
 </ul>
 ,tad ðie viesnîcas numuru veidi nebûs pieejami online rezervâcijâm. 
 </div>

</form>
</body>
</html>


