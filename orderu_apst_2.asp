<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn

Dim db, query, result, oid, pid, gid, profile_id, cnt, skaits, i, str_oids
Dim valuta, datums, rekina_nr, whereC

cnt = 0
valuta = "Ls"

if Request.Form("subm") = 1 then
	'--- Form post------------------------------------------------------

	skaits = Request.Form("skaits")

	For i=1 To skaits

		oid = Request.Form("oid_"&i)
		pid = Request.Form("pid_"&i)
		datums = Request.Form("datums_"&i)
		rekina_nr = Request.form("rekina_nr_"&i)

		if rekina_nr<>"" then
			whereC = whereC + ", kredits='2.3.4.X', rekins=" & rekina_nr
		end If
		
		set result = conn.execute("update orderis set parbaude = 0, need_check=1, datums = '"+sqldate(datums)+"'"+whereC+" where id = "+oid)
		
		Conn.execute("exec pieteikums_calculate "+cstr(pid))
		
		'LogAction "orderis",oid,"Apstiprinâja" '!!!!!!!!!!!!!!!!!!!!!!!!
		str_oids = str_oids + CStr(oid) + " "
	Next
	
	response.write("<br><br>Orderi "+str_oids+" ir veiksmîgi apstiprinâti.<br><br><a href='orderu_apst_1.asp'>Atgriezties</a>")
	response.end
	'Response.Redirect "orderu_apst_1.asp"

	'--- End Form post -------------------------------------------------
else

	gid = Request.QueryString("gid")
	profile_id = Request.QueryString("profile_id")

	If gid="" Or profile_id="" Then 
		response.write("Nav nodoti parametri.")
		response.end
	End If
	
	set result = conn.execute("select * from orderis where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and tmp = 0 and step = '4' and atcelts = 0 and profile_id = "&profile_id&" and gid = "&gid&")")

End If

'@ 0 HTML Start --------------------------
docstart "Online maksâjumu apstiprinâðana","y1.jpg" %>


<h3 align="center">
	Online maksâjumu apstiprinâðana
</h3>



<form name="frm_orderu_apst" method="POST" action="orderu_apst_2.asp">
<center>
	<table border="1">
	<% While Not result.eof 
		
		cnt = cnt + 1
	%>

		<tr>
		 <th align=right>Ordera numurs</th>
		 <td>
			<%=result("num")%>
			<input type="hidden" name="oid_<%=cnt%>" value="<%=result("id")%>">
			<input type="hidden" name="pid_<%=cnt%>" value="<%=result("pid")%>">
		 </td>
		</tr>		
		<tr>
		 <th align=right>Reìistrçts</th>
		 <td><%=DatePrint(result("datums"))%></td>
		</tr>
		<tr>
		 <th align=right>Apstiprinâts</th>
		 <td><input type="text" name="datums_<%=cnt%>" value="<%=DatePrint(now)%>" size="9"></td>
		</tr>
		<tr>
		 <th align=right>Maksâtâjs</th>
		 <td><%=result("kas")%></td>
		</tr>
		<tr>
		 <th align=right>Pamatojums</th>
		 <td><%=result("pamatojums")%></td>
		</tr>
		<tr>
		 <th align=right>Debets</th>
		 <td><%=result("debets")%></td>
		</tr>
		<tr>
		 <th align=right>Kredîts</th>
		 <td><%=result("kredits")%></td>
		</tr>
		<tr>
		 <th align=right>Summa</th>
		 <td><% response.write(CurrPrint(result("summa"))&" "&valuta)%></td>
		</tr>
		<tr>
		 <th align=right>Rçíina Nr.</th>
		 <td><input type="text" name="rekina_nr_<%=cnt%>" size="9"></input></td>
		</tr>
   		<tr>
		 <td colspan="2">&nbsp;</td>
		</tr>
	 
	<% 
		result.MoveNext 
	 Wend  
	%>

	</table>
	<br />
	
	<input type="hidden" name="skaits" value="<%=cnt%>">
	<input type="hidden" name="subm" value="1">

	
	<table width="50%">
		<tr>
			<td align="center"><input type=submit value=Apstiprinât name=poga></td>
			<td align="center"><a href="orderu_apst_1.asp">Atgriezties</a></td>
		</tr>
	</table>

</center>
</form>
