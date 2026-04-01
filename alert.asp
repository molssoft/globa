<!-- #include file = "procs.inc" -->

<%
docstart "Brîdinâjums","y1.jpg"
DefJavaSubmit
%>

<center>
<font size="5"><%=session("message")%></font><br>
<% session("message") = "" %>
Spiediet 'BACK' lai atgrieztos.
</body>
</html>
