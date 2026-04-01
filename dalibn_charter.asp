<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

y = cstr(year(now))

docstart y + ". gada klienti uz èarteriem","y1.jpg" 
headlinks

%><center><br><br><font size=5>Èarteru klienti par <%=y%>. gadu</font><br><br><%
set r = conn.execute("select * from dalibn where adrese<>'' and deleted = 0 and id in (select did from piet_saite where deleted = 0 and pid in (select id from pieteikums where gid = 3100 and beigu_datums >= '1/1/"+y+"' and beigu_datums <= '12/31/"+y+"')) order by pilseta,adrese ")
%><table><%
i = 1
while not r.eof
 link = "<a target=new href=dalibn.asp?i="+cstr(r("id"))+">"
 %><tr><td><%=i%></td><%
 Response.Write "<td><font size=2>"+link+cstr(nullprint(r("adrese")))
 Response.Write "<td><font size=2>"+link+cstr(nullprint(r("pilseta")))
 Response.Write "<td><font size=2>"+link+cstr(nullprint(r("indekss")))
 Response.Write "<td><font size=2>"+link+cstr(nullprint(r("vards")))
 Response.Write "<td><font size=2>"+link+cstr(nullprint(r("uzvards")))
 r.movenext
 i=i+1
 %></tr><%
wend
%>
</table>