<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Darbi","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Darbi</b></font><hr>
<%
headlinks 



if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
%>
<form name="forma" method="POST">
<%
set r = server.createobject("ADODB.Recordset")
r.open "Select * from darbi where pabeigts is null ORDER BY prioritate",conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	%> 
	<center> <b>Darbu saraksts<table border="0">
	<tr bgcolor="#ffc1cc">
	<th>Apraksts</th>
	<th>Registrets</th>
	<th>Prioritate</th>
	<th></th>
	<th></th>
	<th></th>
	</tr>
	<%
	while not r.eof
		%>
		<tr bgcolor="#fff1cc"><td><textarea cols=60 name=apraksts<%=r("id")%>><%=NullPrint(r("apraksts"))%></textarea></td>
		<td><%=DatePrint(r("registrets"))%></td>
		<td><select name=prioritate<%=r("id")%>>
		<%
			For i=1 To 5
				If i = r("prioritate") Then
					%><option value="<%=i%>" selected><%=i%></option><%
				Else
					%><option value="<%=i%>"><%=i%></option><%
				End if
			Next
		%>
		</select></td>
		<td><input type="submit" value="Dzçst" name="poga" onclick="if (!confirm('Dzest?')) {return false}; forma.action='darbi_del.asp?id=<%=cstr(r("id"))%>';forma.submit();return false;" ></td>
		 <td>
		 <input type="submit" value="Saglabat" name="poga" onclick="forma.action='darbi_save.asp?id=<%=cstr(r("id"))%>';forma.submit();return false;" >
		 <input type="submit" value="P" name="poga" onclick="
			if (confirm('Pabeigt darbu?'))
			{
				forma.action='darbi_pabeigt.asp?id=<%=CStr(r("id"))%>';
				forma.submit();
				return false;
			}
			return false;
			">
		 </td><tr>
		<%
		r.MoveNext
	wend
else
	response.write "Darbu nav."
end if

'''''''''''''''''''' Jauns darbs
%>
		<tr bgcolor="#fff1cc"><td><textarea cols=60 name=apraksts></textarea></td>
		<td><%=DatePrint(now)%></td>
		<td><select name=prioritate>
		<%
			For i=1 To 5
				%><option><%=i%></option><%
			Next
		%>
		</select></td>
		<td><input type="submit" value="Pievienot" name="poga" onclick="forma.action='darbi_add.asp';forma.submit();return false;" ></td>
		 <td></td><tr>
		<%
%></table>


</form>

<%
''''''''''''''''''''''''''''''''''
'' pabeigtie darbi
''''''''''''''''''''''''''''''''''''

set r = server.createobject("ADODB.Recordset")
r.open "Select * from darbi where not pabeigts is null ORDER BY pabeigts desc",conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	%> 
	<center> <b>Pabeigtie darbi<table border="0">
	<tr bgcolor="#ffc1cc">
	<th>Apraksts</th>
	<th>Registrets</th>
	<th>Pabeigts</th>
	<th>Prioritate</th>
	<th></th>
	<th></th>
	<th></th>
	</tr>
	<%
	while not r.eof
		%>
		<tr bgcolor="#fff1cc"><td><%=NullPrint(r("apraksts"))%></td>
		<td><%=DatePrint(r("registrets"))%></td>
		<td><%=DatePrint(r("pabeigts"))%></td>
		<td><%=r("prioritate")%></td>
		<td>
		<tr>
		<%
		r.MoveNext
	wend
else
	response.write "Pabeigtu darbu nav."
end if

'''''''''''''''''''' Jauns darbs
%></table>


</form>

</body>
</html>
