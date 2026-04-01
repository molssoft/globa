<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn

Dim db, query, result, oid, pid, gid, profile_id, cnt, skaits, i, str_oids
Dim valuta, datums, rekina_nr, whereC
dim rez_id, maksatajs

cnt = 0
valuta = "Ls"

if Request.Form("subm") = 1 then
	'--- Form post------------------------------------------------------

	skaits = Request.Form("skaits")
	'response.write(skaits + "< skaits")
	

	For i=1 To skaits

		oid = Request.Form("oid_"&i)
		pid = Request.Form("pid_"&i)
		datums = Request.Form("datums_"&i)
		rekina_nr = Request.form("rekina_nr_"&i)
		maksatajs = Request.form("maksatajs_"&i)
		
		whereC = ""
		
		if rekina_nr<>"" then
			whereC = ", kredits='2.3.4.X', rekins=" & rekina_nr
		end If
		
		if maksatajs<>"" then
			whereC = whereC + ", kas='" & maksatajs &"'"
		end if
		
		'set result = conn.execute("update orderis set parbaude = 0, need_check=1, datums = '"+sqldate(datums)+"'"+whereC+" where id = "+oid)
		
		ssql = "update orderis set parbaude = 0, need_check=1, datums = '"+sqldate(datums)+"'"+whereC+" where id = "+oid
		
		'Response.Write ssql
		'Response.end
		 
		set result = conn.execute(ssql)
		
		Conn.execute("exec pieteikums_calculate "+cstr(pid))
		
		'LogAction "orderis",oid,"Apstiprinâja" '!!!!!!!!!!!!!!!!!!!!!!!!
		str_oids = str_oids + CStr(oid) + " "
	Next
	
	response.write("<br><br>Orderi "+str_oids+" ir veiksmîgi apstiprinâti.<br><br><a href='orderu_apst_2_1.asp'>Atgriezties</a>")
	response.end
	'Response.Redirect "orderu_apst_1.asp"

	'--- End Form post -------------------------------------------------
else

	'gid = Request.QueryString("gid")
	rez_id = Request.QueryString("rez_id")
	trans_uid = Request.QueryString("trans_uid")

	If rez_id="" Then 
		response.write("Nav norâdîts rezervâcijas id.")
		response.end
	End If
	
	join_str = ""
	where_str = ""
	
	if trans_uid<>"" then
		join_str = "inner join trans_uid t on t.o_id = o.id"
		where_str = " and t.trans_id = '"&trans_uid&"'"
	end if
	
	'--- dal. maks. izmainjas: pievienots where nosacijums parbaude=1 t.n. atlasa tikai neapstiprinatos orderus
	'--- pievienots join ar trans_uid transakciju tabulu
	ssql = "select o.*, v.val from orderis o inner join pieteikums p on p.id = o.pid "&join_str&" inner join valuta v on o.valuta = v.id where o.parbaude=1 and o.deleted = 0 and p.deleted = 0 and p.tmp = 0 and (p.step='4' or p.online_rez in (SELECT id FROM online_rez WHERE no_delete=1)) and p.atcelts = 0 and p.online_rez = " & rez_id & where_str
	
	'ssql = "select * from orderis where parbaude=1 and deleted = 0 and pid in (select id from pieteikums where deleted = 0 and tmp = 0 and step='4' and atcelts = 0 and online_rez = "&rez_id&")"
	
	'--- temp hardcode selection
	'ssql = "select * from orderis where parbaude=1 and deleted = 0 and (id = 583440 or id = 583441)"
	
	' Response.Write ssql
	set result = conn.execute(ssql)

End If

'@ 0 HTML Start --------------------------
'docstart "Online maksâjumu apstiprinâðana","y1.jpg" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Online rezervâcijas</title>
<link rel="stylesheet" href="online_rez/css/default.css" type="text/css"/>
</head>

<body>
<div id="main_area">
	<div id="main_area_center">

<h3 align="center">
	Online maksâjumu apstiprinâðana
</h3>



<form name="frm_orderu_apst" method="POST" action="orderu_apst_2_2.asp">
<center>
	<table border="1">
	<% While Not result.eof 
		
		cnt = cnt + 1
	%>

		<tr>
		 <th align=right>Ordera numurs</th>
		 <td align=left>
			<%=result("num")%>
			<input type="hidden" name="oid_<%=cnt%>" value="<%=result("id")%>">
			<input type="hidden" name="pid_<%=cnt%>" value="<%=result("pid")%>">
		 </td>
		</tr>		
		<tr>
		 <th align=right>Reìistrçts</th>
		 <td align=left><%=DatePrint(result("datums"))%></td>
		</tr>
		<tr>
		 <th align=right>Apstiprinâts</th>
		 <td align=left><input type="text" name="datums_<%=cnt%>" value="<%=DatePrint(now)%>" size="9"></td>
		</tr>
		<tr>
		 <th align=right>Maksâtâjs</th>
		 <td align=left><input type="text" name="maksatajs_<%=cnt%>" value="<%=result("kas")%>" size="50" maxlength="50"></td>
		</tr>
		<tr>
		 <th align=right>Pamatojums</th>
		 <td align=left><%=result("pamatojums")%></td>
		</tr>
		<tr>
		 <th align=right>Debets</th>
		 <td align=left><%=result("debets")%></td>
		</tr>
		<tr>
		 <th align=right>Kredîts</th>
		 <td align=left><%=result("kredits")%></td>
		</tr>
		<tr>
		 <th align=right>Summa</th>
		 <td align=left><% response.write(CurrPrint(result("summaval"))&" "&result("val"))%></td>
		</tr>
		<tr>
		 <th align=right>Rçíina Nr.</th>
		 <td align=left><input type="text" name="rekina_nr_<%=cnt%>" size="9"></input></td>
		</tr>
   		<tr>
		 <td colspan="2">&nbsp;</td>
		</tr>
	 
	<% 
		result.MoveNext 
	 Wend  
	%>
		<tr>
		
			<td colspan="3">
				<input type=submit value=Apstiprinât name=poga>
				&nbsp;
				<input type="button" value="Atcelt" name="atcelt" onclick="javascript:history.go(-1)">
			</td>
		</tr>
	</table>
	<br />
	
	<input type="hidden" name="skaits" value="<%=cnt%>">
	<input type="hidden" name="subm" value="1">


</center>
</form>
