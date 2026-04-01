<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
Dim Conn
OpenConn
kid = Request.QueryString("kid")
session("kid") = kid
DalNr = Request.QueryString("DalNr")
if kid = "" then Response.Write "Nav norâdîts kajîtes ID."
if DalNr = "" then Response.Write "Nav norâdîts DalNr."

vards = ucase(Request.form("vards"+cstr(DalNr)))
uzvards = ucase(Request.form("uzvards"+cstr(DalNr)))
dzim_datums = ucase(Request.form("dzim_datums"+cstr(DalNr)))
PaseS = ucase(Request.form("PaseS"+cstr(DalNr)))
PaseNr = ucase(Request.form("PaseNr"+cstr(DalNr)))
dzimta = Request.form("dzimta"+cstr(DalNr))
kvietas_veids = Request.form("kvietas_veids"+cstr(DalNr))
session("kvietas_veids") = kvietas_veids
if Request.form("papildv"+cstr(DalNr)) = "on" then
 papildv = "TRUE"
else
 papildv = "FALSE"
end if
session("papildv") = papildv




Query = "SELECT * from dalibn WHERE (not deleted =1) "
if trim(vards) <> "" then query = query + " AND upper(vards) like N'%" + trim(vards) + "%' "
if trim(uzvards) <> "" then query = query + " AND upper(uzvards) like N'%" + trim(uzvards) + "%' "
if trim(dzim_datums) <> "" then query = query + " AND upper(pk1) = N'" + trim(dzim_datums) + "' "

set r = server.CreateObject("ADODB.Recordset")
r.Open Query,conn,3,3
if r.RecordCount = 0 then
	'---- if no such person found
	session("did") = 0
	session("vards") = vards
	session("uzvards") = uzvards
	session("dzim_datums") = dzim_datums
	session("PaseS") = PaseS
	session("PaseNr") = PaseNr
	session("dzimta") = dzimta
	session("Nr") = PaseNr
	session("papildv") = papildv

	docstart "Nav atrasts","y1.jpg"	
	checkGroupBlocked(session("LastGid"))
	
	%><center><font color="GREEN" size="4"><b><br><br>Nav atrasts neviens dalîbnieks.<br>
	Vai vçlaties saglabât ðo dalîbnieku datu bâzç?</b></font><br>
	<table border="0">
	<tr><td align="right">Vârds:</td><td><%=vards%></td></tr>
	<tr><td align="right">Uzvârds:</td><td><%=uzvards%></td></tr>
	<tr><td align="right">Dz. dat.:</td><td><%=dzim_datums%></td></tr>
	<tr><td align="right">Pase:</td><td><%=PaseS%> <%=PaseNr%></td></tr>
	<tr><td align="right">Dzimums:</td><td>
		<%if dzimta = "x" then Response.Write "-"%>
		<%if dzimta = "v" then Response.Write "M"%>
		<%if dzimta = "s" then Response.Write "F"%></td></tr>
	</table>
	<br>
	<a href="kajite.asp?gid=<%=cstr(session("LastGid"))%>"><img border="0" src="impro/bildes/atcelt.jpg" alt="Atcelt dalîbnieka pievienoðanu" WIDTH="116" HEIGHT="25"></a>
	<a href="kajite_dal_save2.asp"><img border="0" src="impro/bildes/saglabat.jpg" alt="Pievienot dalîbnieku datu bâzei un kajîtei." onclick="return checkBlocked();" WIDTH="25" HEIGHT="25"></a>
	<%
elseif r.RecordCount < 100 then
	'---- if serveral persons found
	docstart "Atrasti vairâki","y1.jpg"	
	checkGroupBlocked(session("LastGid"))
	
	%><center><font color="GREEN" size="4"><b><br><br>Atrasti vairâki dalîbnieki.<br> Izvçlieties, kuru pievienot kajîtei.<br></b></font><br>
	<table border="0">
	<tr bgcolor="ffc1cc"><th>Vârds</th>
	<th>Uzvârds</th>
	<th>Dz. dat.</th>
	<th></th>
	<th>Pase</th>
	<th></th></tr>
	<%
	while not r.EOF
		%><tr bgcolor="fff1cc"><td><%=NullPrint(r("vards"))%></td>
		<td><%=NullPrint(r("uzvards"))%></td>
		<td><%=NullPrint(r("pk1"))%></td>
		<td><%=NullPrint(r("paseS"))%></td>
		<td><%=NullPrint(r("paseNr"))%></td>
		<td><a href="kajite_dal_save2.asp?did=<%=r("id")%>"><img border="0" src="impro/bildes/pievienot.jpg" alt="Pievienot ðo dalîbnieku kajîtei" onclick="return checkBlocked();" WIDTH="25" HEIGHT="25"></a></td>
		</tr><%
		r.MoveNext
	wend
	%>
	</table <br><a href="kajite.asp?gid=<%=cstr(session("LastGid"))%>"><img border="0" src="impro/bildes/atcelt.jpg" alt="Atcelt dalîbnieka pievienoðanu" WIDTH="116" HEIGHT="25"></a><%
else
	'---- if too many persons found
	docstart "Atrasti pârâk daudzi","y1.jpg"	
	%><center><font color="GREEN" size="4"><b><br><br>Nosacîjumiem atbils pârâk daudzi dalîbnieki.<br></b></font><br>
	<a href="kajite.asp?gid=<%=cstr(session("LastGid"))%>"><img border="0" src="impro/bildes/atcelt.jpg" alt="Argriezties uz kajîtes lapu." WIDTH="116" HEIGHT="25"></a><%
end if

%>