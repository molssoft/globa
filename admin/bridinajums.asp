<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.inc" -->

<%
docstart "Brîdinâjums","y1.jpg"
DefJavaSubmit
%>

<center>
<font size="5"><%=session("message")%></font>
<p>
<form name="forma" method="POST">
<input type="image" name="ja" src="bildes/ja.jpg" onclick="TopSubmit(<%=session("confirm")%>)" WIDTH="116" HEIGHT="25">
<input type="image" name="ne" src="bildes/ne.jpg" onclick="TopSubmit(<%=session("decline")%>)" WIDTH="116" HEIGHT="25">
</form>
</body>
</html>
