<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Grupu pakalpojumu atskaite","y1.jpg" 
PageSize = 20

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>Grupu pakalpojumu atskaite</b></font><hr>
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

<% 'citi ierobeþojumi 
set rGrupas = conn.execute("select * from grupa where id in (select gid from vietu_veidi where isnull(limita_grupa,'')<>'') and sakuma_dat>='"+sqldate(now)+"' order by sakuma_dat ")
while not rGrupas.eof
 gid = rGrupas("id")
 set rM = conn.execute("select * from marsruts where id = "+cstr(rGrupas("mid")))
 set rLimiti = conn.execute("select * from vietu_veidi where gid="+cstr(gid)+" and limita_grupa <> ''")
 if not rLimiti.eof then
  Response.write "<br>"+rGrupas("kods")+" "+rM("v")+" "+dateprint(rGrupas("sakuma_dat"))+"<br>"
  %><table><tr><td><strong>Ierobeþojums</td><td><strong>Atïauts</td><td><strong>Aizpildîts</td><td><strong>Ðajâ grupâ</td><td><strong>Brîvs</td></tr><%
  while not rLimiti.eof
   %><tr><%
   %><td><%=rLimiti("nosaukums")%></td><%
   %><td align=center><%=rLimiti("limits")%></td><%
   AiznemtsLimits = getnum(conn.execute("select sum(vietsk) from piet_saite where  deleted = 0 and vietas_veids in (select id from vietu_veidi where limita_grupa = '"+rLimiti("limita_grupa")+"')")(0))
   AiznemtsGrupa = getnum(conn.execute("select sum(vietsk) from piet_saite where  deleted = 0 and pid in (select id from pieteikums where gid = "+cstr(gid)+" and deleted = 0) and vietas_veids in (select id from vietu_veidi where limita_grupa = '"+rLimiti("limita_grupa")+"')")(0))
   %><td align=center><%=AiznemtsLimits%></td><%
   %><td align=center><%=AiznemtsGrupa%></td><%
   if rLimiti("limits")-AiznemtsLimits >= 0 then
    %><td align=center><b><font color=green><%=rLimiti("limits")-AiznemtsLimits%></td><%
   else
    %><td align=center><b><font color=red><%=rLimiti("limits")-AiznemtsLimits%></td><%
   end if
   %><tr><%
   rLimiti.movenext
  wend
  %></table><%
 end if
 rGrupas.movenext
wend
%>

</body>
</html>
