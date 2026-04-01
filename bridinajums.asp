<!-- #include file = "procs.inc" -->

<%
docstart "Brîdinâjums","y1.jpg"
DefJavaSubmit
%>

<center>
<font size="5"><%=session("message")%></font>
<p>
<form name="forma" method="POST">
<input type="image" name="ja" src="impro/bildes/ja.jpg" onclick="TopSubmit2(<%=session("confirm")%>)" WIDTH="116" HEIGHT="25">
<input type="image" name="ne" src="impro/bildes/ne.jpg" onclick="TopSubmit2(<%=session("decline")%>)" WIDTH="116" HEIGHT="25">
</form>
</body>
</html>
