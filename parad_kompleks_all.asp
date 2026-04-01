<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Kompleksie parâdnieki","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Kompleksie parâdnieki</b></font><hr>
<%
headlinks 

Set rP = conn.Execute("select * from parametri")

Set r = conn.Execute("select count(id) as sk,izveidoja from pieteikums where deleted = 0 and gid = " + CStr(rP("kompleks")) + " and datums > '1/1/2003' and (bilanceLVL<>0 or bilanceUSD<>0 or bilanceEUR<>0) and beigu_datums<'" + SQLDate(Now) + "' group by izveidoja order by izveidoja")

%><br><br><table><%
%><tr>
 <th>Darbinieks</td>
 <th>Parâdnieki</td>
</tr><%
while not r.eof
 %><tr>
  <td><%=r("izveidoja")%></td>
  <% if getnum(r("sk")) = 0 then %>
   <td align=right>0</td>
  <% else %>
   <td align=right><a href=parad_kompleks.asp?lietotajs=<%=r("izveidoja")%> class=redlink><font color=red><%=r("sk")%></a></font></td>
  <% end if %>
 </tr><%
 r.movenext
wend
%></table><%


Set r = conn.Execute("select count(id) as sk,izveidoja from pieteikums where deleted = 0 and gid = " + CStr(rP("charter")) + " and datums > '1/1/2003' and (bilanceLVL<>0 or bilanceUSD<>0 or bilanceEUR<>0) and beigu_datums<'" + SQLDate(Now) + "' group by izveidoja order by izveidoja")

%><br>Èarteri<br><br><table><%
%><tr>
 <th>Darbinieks</td>
 <th>Parâdnieki</td>
</tr><%
while not r.eof
 %><tr>
  <td><%=r("izveidoja")%></td>
  <% if getnum(r("sk")) = 0 then %>
   <td align=right>0</td>
  <% else %>
   <td align=right><a href=parad_charter.asp?lietotajs=<%=r("izveidoja")%> class=redlink><font color=red><%=r("sk")%></a></font></td>
  <% end if %>
 </tr><%
 r.movenext
wend
%></table><%

%>

</form>
</body>
</html>
