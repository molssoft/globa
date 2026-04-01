<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%
dim conn
openconn

if Request.Form("subm") = 1 then
	conn.Execute "INSERT INTO IP (IP,office) VALUES ('"+request.Servervariables(33)+"','"+Request.Form("office")+"')"
	Response.Redirect Request.Form("return_url")
end if

docstart "Ofisa izvçle","y1.jpg"
%>
<form method = "POST" action = "choose_office.asp">
<center><font color="#FF0000" size="5"><b><i>Kurâ ofisâ jûs atrodaties?</i></b></font><br><br>
<table border = 0>
<tr><td><input type = "radio" name = "office" value = "biedriba" checked></td><td>Latvieðu biedrîbas namâ</td><br>
<tr><td><input type = "radio" name = "office" value = "kazarmas"></td><td>Jçkaba kazarmâs</td><br>
</table>
<br>
<input type = "submit" value = "Turpinât">
<input type = "hidden" name = "subm" value = "1">
<input type = "hidden" name = "return_url" value = "<%=Request.QueryString("return_url")%>">
</form>
</body>
</html>
