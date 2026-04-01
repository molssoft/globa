<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Vietu ierobeþojumi","y1.jpg" 
gid = Request.QueryString("gid")
%>
<center><font color="GREEN" size="5"><b>Vietu ierobeþojumi</b></font><hr>
<%
headlinks 



if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
%>
<form name="forma" method="POST">
<%

set r = server.createobject("ADODB.Recordset")
r.open "Select * from grupu_limiti where gid = "+cstr(gid),conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	%> 
	<center> <table border="0">
	<tr bgcolor="#ffc1cc">
	<th>Ierobeþojums</th>
	<th>Skaits</th>
	<th></th>
	<th></th>
	</tr>
	<%
	while not r.eof
	 set rL = conn.execute("select * from limits where id = "+cstr(r("limits")))
		%>
		<tr bgcolor="#fff1cc"><td><%=NullPrint(rl("nosaukums"))%></td>
		<td><input type=text size=7 name=skaits<%=r("id")%> value="<%=getnum(rl("skaits"))%>"></td>
		<td><input type="image" src="impro/bildes/diskete.jpg" onclick="TopSubmit2('limits_save.asp?id=<%=cstr(r("id"))%>&gid=<%=gid%>')" alt="Saglabât izdarîtâs izmaiòas ðajâ rindâ." ></td></tr>
		<%
		r.MoveNext
	wend
	%></table>
	<%
else
	response.write "Ierobeþojumu nav."
end if

%>

<table>
<tr bgcolor="#fff1cc"><td align="center"><input type="text" maxlength="50" name="vards" size="30"></td>
</tr></table>

</form>
</body>
</html>
