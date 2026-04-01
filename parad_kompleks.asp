<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Kompleksie parâdnieki","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Kompleksie parâdnieki</b></font><hr>
<%
headlinks 
lietotajs = Request.QueryString("lietotajs")
Set rP = conn.Execute("select * from parametri")
Set r = conn.Execute("select * from pieteikums where izveidoja = '"+lietotajs+"' and deleted = 0 and gid = " + CStr(rP("kompleks")) + " and datums > '1/1/2003' and (bilanceLVL<>0 or bilanceUSD<>0 or bilanceEUR<>0) and beigu_datums<'" + SQLDate(Now) + "' order by beigu_datums")

%><br><br><table><%
%><tr>
 <th>Klients</td>
 <th>Izbrauc</td>
 <th>Atbrauc</td>
 <th>Summa</td>
 <th>Bilance</td>
</tr><%
while not r.eof
 %><tr>
  <td><a href=pieteikums.asp?pid=<%=r("id")%> target=_blank><%=conn.execute("select isnull(nosaukums,'')+' '+isnull(vards,'')+' '+isnull(uzvards,'') from dalibn where id in (select did from piet_saite where pid = "+cstr(r("id"))+")")(0)%></a></td>
  <td align=right><%=dateprint(r("sakuma_datums"))%></td>
  <td align=right><%=dateprint(r("beigu_datums"))%></td>
  <td align=right><%=curr3print(r("summaLVL"),r("summaUSD"),r("summaEUR"))%></td>
  <td align=right><%=curr3print(r("bilanceLVL"),r("bilanceUSD"),r("bilanceEUR"))%></td>
 </tr><%
 r.movenext
wend
%></table><%

%>

</form>
</body>
</html>
