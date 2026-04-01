<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn
docstart "Gaidâmâs grupas","y1.jpg"
sezi = request.querystring("sezi")

order = "polijas_dat"

%>
<font face=arial>
<center><font color="GREEN" size="5"><b>Gaidâmâs grupas</b></font><hr>
<%headlinks
%>

<table border="0" bgcolor="#FDFFDD">

<% 
' @ 0 Filter form

'@ 0 Creating SQL
qb="FROM grupa g left join lietotaji li on g.kurators=li.id , marsruts m  WHERE g.mID=m.ID "
qb = qb + " AND DATEDIFF(day, beigu_dat, getdate())=0 and (kods like '__.V.2%' or kods like '__.V.3%' or kods like '__.P.2%' or kods like '__.P.3%' or kods like '__.S.2%' or kods like '__.S.3%')"
qb = qb + " ORDER by polijas_dat "

qf="SELECT g.*,m.ID as marID,m.v,m.cena,vards "+qb
set f = server.createobject("ADODB.Recordset")
f.open qf,conn,3,3
'Response.Write(qf)

qb="FROM grupa g left join lietotaji li on g.kurators=li.id , marsruts m  WHERE g.mID=m.ID "
qb = qb + " AND DATEDIFF(day, beigu_dat, getdate())=0 and (kods like '__.V.1%' or kods like '__.V.7%' or kods like '__.V.6%' or kods like '__.V.5%' or kods like '__.V.4%' or kods like '__.P.1%' or kods like '__.P.6%' or kods like '__.P.5%' or kods like '__.P.4%' or kods like '__.S.1%' or kods like '__.S.6%' or kods like '__.S.5%' or kods like '__.S.4%')"
qb = qb + " ORDER by polijas_dat "

qf="SELECT g.*,m.ID as marID,m.v,m.cena,vards "+qb
set fCitas = server.createobject("ADODB.Recordset")
fCitas.open qf,conn,3,3
'Response.Write(qf)
%>

<BR><b>Grupas no rietumiem</b>
<table>
<tr bgcolor="#ffc1cc">
<td><p align="center"></td>
<td><p align="center">Kods</td>
<td><p align="center">Nosaukums</td>
<td><p align="center">Sâkuma datums</td>
<td><p align="center">Beigu datums</td>
<td><p align="center">Vadîtâjs</td>
<td><p align="center">Iebrauc Lietuvâ</td>
</tr>

<%
' Printing table
if not f.eof then
	while not f.EOF and rec<=PageSize
	 if f("ATCELTA") = true then c = "RED" else c = "GREEN"%>
	  <tr bgcolor="#fff1cc" >
	    <td><a href="javascript:void(window.open('grupa_edit.asp?gid=<%=f("id")%>'))"><img src="impro/bildes/k_zals.gif" WIDTH="31" HEIGHT="14"></a></td>
		<td><%=f("kods")%></td>
		<td><%=f("v")%></td>
		<td align=right><%=dateprint(f("sakuma_dat"))%></td>
		<td align=right><%=dateprint(f("beigu_dat"))%></td>
		<td align=right>
		 <%
		 Response.write f("vad")
		 set rGrVad = conn.execute("select vards+' '+uzvards from grupu_vaditaji where idnum = "+cstr(getnum(f("vaditajs")))+"")
		 if not rGrVad.eof then Response.Write " " + rGrVad(0)
		 set rGrVad = conn.execute("select vards+' '+uzvards from grupu_vaditaji where idnum = "+cstr(getnum(f("vaditajs2")))+"")
		 if not rGrVad.eof then Response.Write " " + rGrVad(0)
		 %>
		</td>
		<form name=forma<%=f("id")%> method=POST action="grupas_gaidam_save.asp">
		<% if not isnull(f("polijas_dat")) then %>
		    <td align=right><input type=text size=13 value="<%=timeprint(f("polijas_dat"))%>" name=polijas_dat></td>
		<% else %>
		    <td align=right><input type=text size=13 value="nav info" id=text1 name=polijas_dat></td>
		<% end if %>
		<td><input type=image src="impro/bildes/diskete.jpg"><input type=hidden name="grupa_id" value="<%=f("id")%>"></a></td>
		</form>
		
	  </tr>
	<%
	f.movenext
	wend
end if
%>
</table>



<BR><b>Citas grupas</b>
<table>
<tr bgcolor="#ffc1cc">
<td><p align="center"></td>
<td><p align="center">Kods</td>
<td><p align="center">Nosaukums</td>
<td><p align="center">Sâkuma datums</td>
<td><p align="center">Beigu datums</td>
<td><p align="center">Vadîtâjs</td>
<td><p align="center">Iebrauc Rîgâ</td>
</tr>

<%
' Printing table
if not fCitas.eof then
	while not fCitas.EOF
	 if fCitas("ATCELTA") = true then c = "RED" else c = "GREEN"%>
	  <tr bgcolor="#fff1cc" >
	    <td><a href="javascript:void(window.open('grupa_edit.asp?gid=<%=fCitas("id")%>'))"><img src="impro/bildes/k_zals.gif" WIDTH="31" HEIGHT="14"></a></td>
		<td><%=fCitas("kods")%></td>
		<td><%=fCitas("v")%></td>
		<td align=right><%=dateprint(fCitas("sakuma_dat"))%></td>
		<td align=right><%=dateprint(fCitas("beigu_dat"))%></td>
		<td align=right><%=fCitas("vad")%></td>
		<form name=forma<%=fCitas("id")%> method=POST action="grupas_gaidam_save.asp">
		<% if not isnull(fCitas("polijas_dat")) then %>
		    <td align=right><input type=text size=13 value="<%=timeprint(fCitas("polijas_dat"))%>" id=text2 name=polijas_dat></td>
		<% else %>
		    <td align=right><input type=text size=13 value="nav info" id=text1 name=polijas_dat></td>
		<% end if %>
		<td><input type=image src="impro/bildes/diskete.jpg" id=image1 name=image1><input type=hidden name="grupa_id" value="<%=fCitas("id")%>"></a></td>
		</form>
		
	  </tr>
	<%
	fCitas.movenext
	wend
end if
%>
</table>

</body>
</html>
