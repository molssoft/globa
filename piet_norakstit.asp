<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn

pid = request.querystring("pid")

if not IsAccess(T_NORAKSTIT) then
	session("message") = "Nav tiesîbu norakstît"
	response.redirect("pieteikums.asp?pid="+cstr(pid))
end if

'---------- paarbauda submiteetos datus
if cstr(request.form("subm")) = "1" then 
	CONN.EXECUTE "UPDATE PIETEIKUMS SET norakstitsLVL = "+request.form("norakstitsLVL")+",norakstitsUSD = "+request.form("norakstitsUSD")+",norakstitsEUR = "+request.form("norakstitsEUR")+"  WHERE ID = " + CSTR(PID)
end if

set rec = server.createobject("ADODB.Recordset") 
rec.open "select * from pieteikums where id = " + cstr(pid),conn,3,3

docstart "Pieteikuma atlikuma norakstîðana","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pieteikuma atlikuma norakstîðana</b></font><hr>
<%
headlinks
if session("message") <> "" then
 response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if
%>
<p>
<form name="forma" action="piet_norakstit.asp?pid=<%=pid%>" method="POST">
	<table border="0">
	<input type="hidden" name="subm" value="1">
	<tr >
	 <th>LVL</td>
	 <th>USD</td>
	 <th>EUR</td>
	</tr>
	<tr>
	 <td><input type=text size=7 name=norakstitsLVL value="<%=currprint(rec("norakstitsLVL"))%>"></td>
	 <td><input type=text size=7 name=norakstitsUSD value="<%=currprint(rec("norakstitsUSD"))%>"></td>
	 <td><input type=text size=7 name=norakstitsEUR value="<%=currprint(rec("norakstitsEUR"))%>"></td>
	</tr>
	<table>
	<input type="image" name="labot" src="impro/bildes/diskete.jpg" >
	<input type="image" name="close" src="impro/bildes/aizvert.bmp" onclick="window.close()">
	<br>
</form> 

