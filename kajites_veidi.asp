<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
if Request.QueryString("gid") = "" then response.write "Nav norâdîts grupas ID<br><br>"
gid = request.querystring("gid")
if Request.QueryString("viss") <> "" then
	session("viss") = Request.QueryString("viss")
end if
if session("viss") = "" then session("viss") = 0

'------------ Kopç kajîtes ja poga nospiesta
if Request.Form("poga") = "Kopçt" then
	Copy_Kajites_Veidi gid,Request.Form("gid")
end if

docstart "Kajiðu veidi","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Kajîðu veidi</b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>
<%
headlinks 
%>
<center><font size="2">[ <a href="kajite.asp?gid=<%=gid%>">Kajîtes</a> ]
[ <a href="pieteikumi.asp?gid=<%=gid%>">Grupa</a> ]
<%
DefJavaSubmit
checkGroupBlocked(gid)

dim bernu_no,bernu_lidz,pusaudzu_no,pusaudzu_lidz
qry = "SELECT * FROM kajites_vecums"
set kajites_vecums = conn.execute(qry)
if ( not kajites_vecums.eof) then
	bernu_no = cstr(kajites_vecums("bernu_no"))
	bernu_lidz = cstr(kajites_vecums("bernu_lidz"))
	pusaudzu_no = cstr(kajites_vecums("pusaudzu_no"))
	pusaudzu_lidz = cstr(kajites_vecums("pusaudzu_lidz"))
end if
	
%>
<form name="forma" method="POST" action="kajites_veidi.asp<%=qstring()%>">
<center> <table border="0">
<tr bgcolor="#ffc1cc">
<th rowspan="2">Nosaukums</th>
<th rowspan="2">Vietas</th>
<th colspan="7">Cenas</th>
<th colspan="3">Statistika</th>
<th rowspan="2"></th>
<th rowspan="2"></th>

</tr>
<tr bgcolor="#ffc1cc">
<th>Standarta</th>
<th>Bçrnu<br><%=bernu_no%>g. - <%=bernu_lidz%>g. (iesk.)</th>
<th>Pusaudþu<br><%=pusaudzu_no%>g. - <%=pusaudzu_lidz%>g. (iesk.)</th>
<th>Brîva v.(3pers)</th>
<th>Brîva v.(2pers)</th>
<th>Brîva v.(1pers)</th>
<th>Senioru</th>
<th>Aizòemts</th>
<th>Brîvs</th>
<th>Kopâ</th>


</tr>
<%
'------------- 1 Atrodam kajiites --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select * from kajites_veidi where gid = " + cstr(gid) + " order by nosaukums",conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	while not r.eof
		%>
		<tr bgcolor="#fff1cc"><td><input type="text" size="10" name="nosaukums<%=r("id")%>" value="<%=NullPrint(r("nosaukums"))%>"></td>
		<td align="center"><input type="text" size="7" name="vietas<%=r("id")%>" value="<%=GetNum(r("vietas"))%>"></td>
		<td align="center"><input type="text" size="7" name="standart_cena<%=r("id")%>" value="<%=GetNum(r("standart_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="bernu_cena<%=r("id")%>" value="<%=GetNum(r("bernu_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="pusaudzu_cena<%=r("id")%>" value="<%=GetNum(r("pusaudzu_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="papild_cena<%=r("id")%>" value="<%=GetNum(r("papild_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="papild2_cena<%=r("id")%>" value="<%=GetNum(r("papild2_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="papild3_cena<%=r("id")%>" value="<%=GetNum(r("papild3_cena"))%>"></td>
		<td align="center"><input type="text" size="7" name="senioru_cena<%=r("id")%>" value="<%=GetNum(r("senioru_cena"))%>"></td>
		<td>
		 <% 'aizòemtâs vietas
		 a=conn.execute("select count(*) from piet_saite where deleted = 0 and kid in (select id from kajite where veids = "+cstr(r("id"))+")")(0)
		 Response.Write a
		 aiznemts = aiznemts + a %>	</td>
		<td>
		 <% 'brîvâs vietas
		 x=conn.execute("select count(*) from kajite where veids = "+cstr(r("id")))(0)*r("vietas")
		 b=x-a
		 Response.Write b
		 brivs = brivs + b %>	</td>
		<td>
		 <% 'vietas kopâ visâs ðî veida kajîtçs
		 Response.Write x
		 vietas = vietas + x %>	</td>
		<td><input type="image" src="impro/bildes/dzest.jpg" onclick="if (!checkBlocked()) {return false;} if (confirm('Dzçst')) {forma.action = 'kajites_veidi_del.asp?id=<%=cstr(r("id"))%>'; return true;} else return false;" alt="Dzçst kajites veidu ðai grupai." WIDTH="25" HEIGHT="25"></td>
		<td><input type="image" src="impro/bildes/saglabat.jpg" onclick="if (!checkBlocked()) {return false;} forma.action = 'kajites_veidi_save.asp?id=<%=cstr(r("id"))%>';forma.submit()" alt="Saglabât izmaiòas ðajâ rindâ." WIDTH="25" HEIGHT="25"></td></tr>
		<%
		r.MoveNext
	wend
end if

%><p>
<tr bgcolor="#fff1cc"><td align="center"><input type="text" name="nosaukums" size="10"></td>
<td align="center"><input type="text" name="vietas" size="7"></td>
<td align="center"><input type="text" name="standart_cena" size="7"></td>
<td align="center"><input type="text" name="bernu_cena" size="7"></td>
<td align="center"><input type="text" name="pusaudzu_cena" size="7"></td>
<td align="center"><input type="text" name="papild_cena" size="7"></td>
<td align="center"><input type="text" name="papild2_cena" size="7"></td>
<td align="center"><input type="text" name="papild3_cena" size="7"></td>
<td align="center"><input type="text" name="senioru_cena" size="7"></td>
<td><b><%=aiznemts%></b></td>
<td><b><%=brivs%></b></td>
<td><b><%=vietas%></b></td>
<input type=hidden name=mygid value=<%=gid%>>
<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="if (!checkBlocked()) {return false;} forma.action = 'kajites_veidi_add.asp<%=qstring()%>';" alt="Pievienot jaunu kajites veidu." WIDTH="25" HEIGHT="25"></td>
</tr></table>

<% if session("viss") = 0 then %>
	<a href="kajites_veidi.asp?gid=<%=gid%>&amp;viss=1">Aktuâlâs grupas</a>
<% else %>
	<a href="kajites_veidi.asp?gid=<%=gid%>&amp;viss=0">Visas grupas</a>
<% end if %>
<%Grupas_combo 0,session("viss") %><input type="submit" name="poga" value="Kopçt" onclick="return checkBlocked();">

</form>
</body>
</html>

