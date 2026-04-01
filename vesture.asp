<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
tabula = request.querystring("tabula")
id = request.querystring("id")

set rec = server.createobject("ADODB.Recordset") 
rec.open "select vesture from "+tabula+" where id = " + cstr(id),conn,3,3

docstart "Ieraksta vçsture","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Ieraksta vçsture</b></font><hr>
<p>
<center><font color="GREEN" size="3"><b>Ieraksta nr. <%=cstr(id)%></b></font>


<table border="1">
	<%
	
	
	formattedVesture = "<tr bgcolor='#ffc1cc'><td>"+Replace(rec("vesture"),"<br>","</td></tr><tr bgcolor='#ffc1cc'><td>")+"</td></tr>"
	formattedVesture = Replace(formattedVesture,"||","</td><td colspan='2' bgcolor=''>")
	formattedVesture = Replace(formattedVesture," :: ","</td><td bgcolor='#FEFFD5'>")
	formattedVesture = Replace(formattedVesture,"=>","</td><td bgcolor='#FEFFD5'>")
	'rw formattedVesture
	formattedVesture = Replace(formattedVesture,"*","<div style='text-align:right;font-style:italic;background-color:''>")
	
		formattedVesture = Replace(formattedVesture,"<tr bgcolor='#ffc1cc'><td></td></tr>","")
	%>
	<%=formattedVesture%>
	

</table>

