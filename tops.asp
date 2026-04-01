<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

docstart "Klientu tops","y1.jpg" 
dim conn
OpenConn
%>

<body>

<table>
<tr>
	<td>vieta</td>
	<td>pieteikumi</td>
	<td>vards</td>
</tr>
<%

Set r = conn.execute("select distinct ps.did,count (ps.did) as c from pieteikums p inner join piet_saite ps on p.id = ps.pid where p.deleted = 0 and ps.deleted = 0 " + _
" and not gid in (select id from grupa where [mid] in (select id from marsruts where v like '!%')) " + _
" and persona<>0 " + _
" group by ps.did " + _
" order by count(ps.did) desc ")

i = 1
While Not r.eof And i < 100
	%><tr>
		<td><%=i%></td>
		<td><%=r("c")%></td>
		<td>
			<a href="dalibn.asp?i=<%=cstr(r("did"))%>" _target="blank">
			<%=conn.execute("select isnull(vards,'') + ' ' + isnull(uzvards,'') + ' ' + isnull(nosaukums,'') from dalibn where id = "+CStr(r("did")))(0)%>
			</a>
		</td>
	</tr><%
	i = i + 1
	r.movenext
wend

%>
</table>

</body>
</html>
