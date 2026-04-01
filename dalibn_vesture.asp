<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
did = request.querystring("did")

if did = 0 or did = "" then 
	session("message") = "Nav norâdîts dalîbnieka nummurs"
end if
	
docstart "Dalîbnieka vçsture","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Dalîbnieka vçsture</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if did <> 0 and did <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Dalîbnieks nr. <%=cstr(did)%></b></font>
	<center>
	<table border="1">
	<%
	set r = conn.Execute("Select JN_veids, JN_laiks, JN_lietotajs FROM dalibn_jn WHERE id = " & cstr(did) & " ORDER BY JN_laiks")
	
	Dim action
	%>

	
	<% while not r.eof
	%><tr bgcolor="#ffc1cc"><td align="right" ><%
	Response.write r("JN_lietotajs") + " - " 
	Select Case r("JN_veids")
			Case "I"
				action = "Izveidoja"
			Case "U"
				action = "Laboja"
			Case "D"
				action = "Dzçsa"
		End Select
		Response.Write action + ". "
	
		Response.write r("JN_laiks")
		
		r.movenext 
	%></td></tr><%
	Wend
	qry = "Select AuditDMLAction, AuditDateTime,AuditUser FROM dalibn_Audit WHERE  id = " & cstr(did) & " AND AUditdatetime<'2017-04-07' ORDER BY AuditDateTime, AuditDMLAction"
	'rw qry
	set r = conn.Execute(qry)
	'rw "Select AuditDMLAction, AuditDateTime,AuditUser FROM dalibn_Audit WHERE  id = " & cstr(did) & " ORDER BY AuditDateTime"
	while not r.eof
	%><tr bgcolor="#ffc1cc"><td align="right" ><%
		
		
		Response.write r("AuditUser") + " - " 
			Select Case r("AuditDMLAction")
			Case "Insert"
				action = "Izveidoja"
			Case "Update"
				action = "Laboja"
			Case "Delete"
				action = "Dzçsa"
		End Select
		Response.Write action + ". "
		Response.write r("AuditDateTime")
		r.movenext 
	%></td></tr><%
	Wend
	%>
	</table>
	<table border="1">
	<%
	
	set r = conn.Execute("Select vesture FROM dalibn WHERE id = " + cstr(did))
	formattedVesture = "<tr bgcolor='#ffc1cc'><td>"+Replace(nullprint(r("vesture")),"<br>","</td></tr><tr bgcolor='#ffc1cc'><td>")+"</td></tr>"
	formattedVesture = Replace(formattedVesture,"||","</td><td colspan='2' bgcolor=''>")
	formattedVesture = Replace(formattedVesture,":: ","</td><td bgcolor='#FEFFD5'>")
	formattedVesture = Replace(formattedVesture,"=>","</td><td bgcolor='#FEFFD5'>")
	'rw formattedVesture
	formattedVesture = Replace(formattedVesture,"*","<div style='text-align:right;font-style:italic;background-color:''>")
	
		formattedVesture = Replace(formattedVesture,"<tr bgcolor='#ffc1cc'><td></td></tr>","")
	%>
	<%=formattedVesture%>
	
	</table>
<% end if %>

