<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
docstart "Paziòojums","ice1.jpg"
defjavasubmit
%>

<center>
<p><p><p><p>
<font size="5">Session("message")</font>
<form name = "forma" method = "POST">
<input type="submit" value = "Turpinât" onclick="TopSubmit('<%=session("confirm")%>">
</form>
</body>
</html>
