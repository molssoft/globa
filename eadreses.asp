<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

docstart "E-adreses","y1.jpg"
%>
<center><font color="#FF0000" size="5"><b><i>Dalîbnieku e-adreses</i></b></font><hr>
<%
headlinks
%><br><%
'set r = conn.Execute("SELECT id,vards,uzvards,nosaukums,eadr FROM dalibn where eadr like '%@%'")
set r = conn.Execute("SELECT id,vards,uzvards,nosaukums,eadr,eadr_paz FROM dalibn where eadr <> '' and deleted=0 order by eadr")

%><table border = 1>
<tr>
<td><b>Dalibnieks</td>
<td><b>e-adrese</td>
<td><b>Pazime</td>
</tr>
<%
while not r.eof
	%><tr><%
	%><td><a href = "dalibn.asp?i=<%=r("id")%>" target = none ><%
	Response.Write nullprint(r("vards")) + " " + nullprint(r("uzvards")) + " " + nullprint(r("nosaukums"))
	%></a></td><%
	%><td><%
	if CheckEmail(nullprint(r("eadr"))) then
	 Response.Write nullprint(r("eadr"))
	else
	 Response.Write "<font color=red>"+nullprint(r("eadr"))+"</font>"
	end if
	%></td>
	<% if r("eadr_paz") then %>
	<td><a href="eadr_paz.asp?id=<%=r("id")%>">ir</a></td>
	<% else %>
	<td><a href="eadr_paz.asp?id=<%=r("id")%>">nav</a></td>
	<% end if %>
	</tr><%
	r.movenext
wend

%>


</body>
</html>
