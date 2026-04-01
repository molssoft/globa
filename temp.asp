<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn

set r = conn.execute ("select v,vards,uzvards,uznemums,telefons from (grupa inner join marsruts on grupa.mid = marsruts.id) left join interesenti on grupa.id = interesenti.gid where grupa.beigu_dat >= '11/01/2002' and grupa.beigu_dat < '11/01/2003' and (kods like '__.P%' or kods like '__.S%') order by v")

%><table><%
while not r.eof
  %>
  <tr>
  <td><%=r("v")%></td>
  <td><%=decode(r("vards"))%></td>
  <td><%=decode(r("uzvards"))%></td>
  <td><%=decode(r("uznemums"))%></td>
  <td><%=decode(r("telefons"))%></td>
  </tr>
  <%
  r.movenext
wend
%>
</table>