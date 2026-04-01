<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim dsk
dim conn
dim rez_id

openconn

docstart "Dzçstas rezervâcijas atjaunoðana","y1.jpg" 

if request.form("subm")="1" then
	rez_id = request.form("rez_id")
	'pârbauda, vai neeksistç pieteikums uz to paðu grupu tam paðam dalîbniekam
	set r_piet_online = conn.execute("select * from pieteikums where online_rez = "+rez_id)
	set gid = r_piet_online("gid")
	set did = r_piet_online("did")
	dim ssql
	ssql = "SELECT DISTINCT(pid) FROM piet_saite where did="+cstr(did)+" and deleted=0 and pid in (select id from pieteikums where gid="+cstr(gid)+" and deleted=0 and isnull(online_rez,0)<>"+cstr(rez_id)+")"

	'response.write(ssql)
	set r_piet = conn.execute(ssql)
	if r_piet.eof then
		conn.execute("update online_rez set no_delete = 1, deleted = 0 where id = "+rez_id)
		conn.execute("update pieteikums set deleted = 0 where online_rez = "+rez_id)
		conn.execute("update piet_saite set deleted = 0 where pid in (select id from pieteikums where online_rez = "+rez_id+") AND not (isnull(vid,0) =0 and isnull(kid,0)=0 and isnull(summaEUR,0)=0 and isnull(vietas_veids,0) = 0)")
		conn.execute("update ligumi set deleted = 0 where rez_id = "+rez_id)
		
		
		msg = "<BR><BR>Rezervâcija ir atjaunota"
		msg = msg + "<br><font color='red' font size='4'>Lûdzu, pârliecinieties, vai iepriekð rezervçtâ istabiòa nav aizòemta un<br>vai iepriekð pieteiktajiem pakalpojumiem nav pârsniegts skaita limits,<br> jo pa ðo laiku uz tiem varçja pieteikties citi dalîbnieki.</font>"
	else
		'while not r_piet.eof
			set pid=r_piet("pid")
		'wend
		msg = "<br><br><font color='red' font size='4'>Rezervâcija nav atjaunota.<br>Ðim dalîbniekam jau eksistç <a href='pieteikums.asp?pid="+cstr(pid)+"'>pieteikums</a> uz ðo ceïojumu</font>"
	 end if
	
end if

%>
<center><font color="GREEN" size="5"><b>Dzçstas rezervâcijas atjaunoðana</b></font><hr>
<%
headlinks 
response.write msg
%><BR><BR>
<form method=post>
	Rezervâcijas nr:<input type=text name=rez_id >
	<input type=submit value="Atjaunot">
	<input type=hidden name=subm value=1>
</form>


<h2>Pçdçjâs rezervâcijas</h2>
<table>
<tr>
	<th>ID</th>
	<th>Vârds</th>
	<th>Dzçsta</th>
	<th>Nevar dzçst</th>
</tr>
<%
set r = conn.execute("select top 100 * from online_rez order by id desc")
while not r.eof
'	ssql = "select * from dalibn where id in (select did from pieteikums where online_rez = "+cstr(r("id"))+")"
	ssql = "select * from profili where id  = "+cstr(r("profile_id"))+""
	set rdalibn = conn.execute(ssql)
	%><tr <% if r("deleted") = 0 then response.write "style='color:blue'" %>>
	<td><%=r("id")%></td>
	<td><% if not rdalibn.eof then response.write rdalibn("vards") + " " + rdalibn("uzvards")%></td>
	<td align=center><%=r("deleted")%></td>
	<td align=center><%=r("no_delete")%></td>
	</tr><%
	r.movenext
wend
%>
</table>