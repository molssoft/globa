<form action = "words.asp" method = post>
<input type = text name = "number">
<input type = "submit">
</form>

<p>
<%
response.write request.form("number")
response.write "<br>" 

n = request.form("number")
response.write "<br>"



%>

