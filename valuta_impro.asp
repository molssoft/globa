<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn

'standarts visaam lapaam
docstart "IMPRO valûtu kursi","y1.jpg"

%>

<center>
<font size=5>IMPRO valûtu kursi</font>

<table border=0>
<tr>
 <th>
  <font face=Verdana>Valûta
 </tH>
 <th>
  <font face=Verdana>Kurss
 </th>
 <th>
  <font face=Verdana>Datums
 </th>
</tr>
<%
 set r = conn.execute("select * from valuta order by val")
 while not r.eof
  set rKurss = conn.execute("select top 1 kurss2,datums from valutakurss where valuta = "+cstr(r("id"))+" order by datums desc" )
  if not rkurss.eof then
  %><tr>
       <td align=center><font face=verdana><%=ucase(r("val"))%></td>
       <td><%=rKurss("kurss2")*1.025%></td>
       <td><%=dateprint(rKurss("datums"))%></td>
    </tr><%
  end if
  r.movenext
 wend
%>
</table>
</body>
</html>

