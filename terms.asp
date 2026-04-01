<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim gid
dim conn
OpenConn
docstart "Iemaksu termiòi. ","y1.jpg"
DefJavaSubmit
%>
<center><font color="GREEN" size="5"><b>Iemaksu termiòi.</b></font><hr>
<%headlinks
if session("message") <> "" then
%>
<font size="4" color="GREEN"><%=session("message")%></font>
<% session("message") = ""
end if %>
<br>

<% if request.form("subm") = "1"  or session("lastgid") <> "" then 
if session("lastgid") <> "" then gid = session("lastgid")
if request.form("subm") = "1" then gid = request.form("gid")
end if %>
<form name="forma" method="POST">
<table border="0">
<tr><td align="right" bgcolor="#ffc1cc"><b>Grupa: </td><td bgcolor="#fff1cc"><%grupas_combo gID, 0%></td></tr>
<input type="hidden" name="subm" value="1">
</table>
<input type="image" name="skatit" src="impro/bildes/termini.jpg" WIDTH="116" HEIGHT="25">
<!--<input type="image" name="grupaskavetaji" src="impro/bildes/grupaskavetaji.jpg" onclick="TopSubmit('kavetaji.asp')" WIDTH="116" HEIGHT="25"> -->
<!--<input type="image" name="visikavetaji" src="impro/bildes/visikavetaji.jpg" onclick="TopSubmit('kavetaji.asp')" WIDTH="116" HEIGHT="25"> -->
<hr>
<font size="4" color="GREEN">
Samaksas termiòu saraksts grupai: <%=grupas_nosaukums(gID,NULL)%>
<table border="0">
<tr bgcolor="#ffc1cc">
	<th>Datums</th>
	<th>Summa</th>
	<th>Pakalpojums</th>
	<th></th>
</tr>
<%
set rec = server.createobject("ADODB.Recordset")
rec.open "select * from terms WHERE gid = "+cstr(gID),conn,3,3
while not rec.eof
%>
<tr bgcolor="#fff1cc">
	<td><%=dateprint(rec("datums"))%></td>
	<td><%=cstr(rec("summa"))%> Ls</td>
	<td><%=NullPrint(id_field("vietu_veidi",rec("vietas_veids"),"nosaukums"))%></td>
	<td><input type="image" src="impro/bildes/dzest.jpg" onclick="TopSubmit('terms_del.asp?id=<%=rec("id")%>')" WIDTH="25" HEIGHT="25"></td>
</tr>
<% 
rec.movenext
wend
%>
<tr bgcolor="#fff1cc">
	<td><input type="text" size="10" name="datums"></td>
	<td><input type="text" size="7" name="summa"></td>
	<td>
	<select name = "vietas_veids">
	<option value = 0>-</option>
	<%
	set rViet = conn.execute("SELECT * FROM vietu_veidi WHERE gid = " + cstr(gid))
	while not rViet.eof
		Response.Write "<option value = " + cstr(rViet("id")) + ">" + cstr(rViet("nosaukums")) + "</option>"
		rViet.movenext
	wend
	%>
	</td>
	<td><input type="image" src="impro/bildes/pievienot.jpg" name="pievienot" onclick="TopSubmit('terms_add.asp')" WIDTH="25" HEIGHT="25"></td>
</table>
<p>
<center><font color="GREEN" size="4"><b>Uzstâdît augstâkminçtos termiòus visam marðurtam.</b></font><br>
<%
dbcomboplus "marsruts","v","id","mid",session("lastmid")
%>
<br><input type="image" src="impro/bildes/uzstaditmarsrutam.jpg" name="pievienot" onclick="TopSubmit('terms_setm.asp')" WIDTH="116" HEIGHT="25"><br>



</form>
</body>
</html>

