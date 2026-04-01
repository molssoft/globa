<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "Data integrity check","y1.jpg"
DefJavaSubmit

set r = server.createobject("ADODB.Recordset")

pid = Request.Form("pid")
action = Request.Form("action")
message = ""

if action = 1 then

	ssql = "select * from pieteikums where id = "&pid&" order by datums"
	r.open ssql,conn,3,3
	
	if not r.EOF then
		message = r("id")
	else
		message = "Pieteikums nav atrasts"
	end if
 
end if
%>

<center>
<form name="forma" action="integrity.asp" method="POST">

<input type="hidden" name="action" value="0" />

<font color="BLACK" size="3"><br><b>Data integrity check
<br><br>
<table>
<tr>
	<td bgcolor = #ffc1cc>Pid: </td>
	<td bgcolor = #fff1cc><input type="text" name="pid" value="<%=pid%>"></td>
	
</tr>
<tr>
	<td colspan="2" align="center">
		<input type=image src="impro/bildes/diskete.jpg" onclick="forma.action.value=1; forma.submit(); return false;">
	</td>
</tr>
</table>

<p><%=message%></p>

<%

Dim dbsql_Connection
Function GetConnection( inpdatabase )
  Set dbsql_Connection = Server.CreateObject("ADODB.Connection")
  dbsql_Connection.Open "DSN=globa"
  dbsql_Connection.DefaultDatabase = inpdatabase
  Set GetConnection = dbsql_Connection
End Function

Dim result2: Set result2 = Server.CreateObject("ADODB.Recordset")
Dim cmd: Set cmd = Server.CreateObject("ADODB.Command")

With cmd
  Set .ActiveConnection = GetConnection("globa")
  .CommandType = adCmdStoredProc
  .CommandTimeout = 80
End With

  cmd.CommandText = "sp_columns"
  cmd.Parameters.Append cmd.CreateParameter("@table_name", adVarChar, adParamInput, 250, "pieteikums")
  result2.CursorLocation = adUseClient
  set result2 = cmd.Execute()
  cmd.Parameters.Delete 0
  dim columns : columns = ""
  dim fields : fields = ""

Do While not result2.EOF
   if result2("TYPE_NAME") <> "image" then
	 
     columns = columns + "<th>" + result2("COLUMN_NAME") + "</th>"
     fields = fields + "<td>" + nullprint(r(cstr(result2("COLUMN_NAME")))) + "</td>"
   end if
   result2.MoveNext
Loop
result2.Close

'columns = left(columns,Len(columns)-1)

Response.Write "<table border=1><tr>"+columns+"</tr>"
Response.Write "<tr>"+fields+"</tr>" 
Response.Write "</table>"  
%>

</form>
</center>
</body>
</html>
