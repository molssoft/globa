<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if

docstart "Ârçjie sistçmas lietotâji","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Ârçjie sistçmas lietotâji</b></font><hr>
<%
headlinks 



if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
'------------- Selektç epastus un paroles --------------
set r = server.createobject("ADODB.Recordset")
r.open "Select * from lietotaji_asp ORDER BY epasts",conn,3,3
if r.EOF then Response.Write "<font face=arial><b><br>Saraksts ir tukðs"
%>
<form name="forma" method="POST">
<center> <table border="0">
<tr bgcolor="#ffc1cc">
<th>Partneris</th>
<th>E-pasts</th>
<th>Parole</th>
<th></th>
<th></th>
</tr>
<%
if r.recordcount <> 0 then
	r.movefirst
	while not r.eof
		%>
		<tr bgcolor="#fff1cc">
		
		<td>
            <input type="text" name="partneris<%=r("id")%>" size="50" maxlength="255" value="<%=NullPrint(r("partneris"))%>">
        </td>
		
		<td><input type="text" name="epasts<%=r("id")%>" size="20" maxlength="50" value="<%=NullPrint(r("epasts"))%>"></td>
		<td><input type="text" name="parole<%=r("id")%>" size="20" maxlength="50" value="<%=NullPrint(r("parole"))%>"></td>
		<td><input type="image" src="impro/bildes/dzest.jpg" onclick="if (confirm('Vai vçlaties dzçst ierakstu?')) TopSubmit2('lietotaji_asp_del.asp?id=<%=cstr(r("id"))%>')" alt="Dzçst ierakstu." WIDTH="25" HEIGHT="25"></td>
		<td><input type="image" src="impro/bildes/diskete.jpg" onclick="TopSubmit2('lietotaji_asp_save.asp?id=<%=cstr(r("id"))%>')" alt="Saglabât ierakstu." WIDTH="25" HEIGHT="25"></td></tr>
		<%
		r.MoveNext
	wend
end if

%>

<tr bgcolor="#fff1cc">
<td align="center"><input type="text" maxlength="255" name="partneris" size="50" maxlength="255"></td>
<td align="center"><input type="text" maxlength="50" name="epasts" size="20" maxlength="50"></td>
<td align="center"><input type="text" maxlength="50" name="parole" size="20" maxlength="50"></td>
<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="TopSubmit2('lietotaji_asp_add.asp')" alt="Pievienot ierakstu." WIDTH="25" HEIGHT="25"></td>
</tr></table>

</form>
</body>
</html>
