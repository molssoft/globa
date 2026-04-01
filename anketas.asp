<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
DocStart "Anketas","y1.jpg"
dim conn
OpenConn

if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if

gid = Request.QueryString("gid")
set rGrupa = conn.execute("select * from grupa inner join marsruts on grupa.mid = marsruts.id where grupa.id = "+cstr(gid))
%>

<center><b><font face=tahoma>
<%=DatePrint(rGrupa("sakuma_dat")) + " " + rGrupa("v")+" "+rGrupa("kods")%><br><br></b>

<%
set r = conn.execute("select * from anketas where gid = "+gid+" order by datums desc")
 %><table border=0 cellpadding=3>
 <tr bgcolor=lightgreen>
  <th></th>
  <th>Datums</th>
  <th>Braucis (reizes)</th>
  <th>Ir pircis online</th>
  <th>Izvçles iemesls</th>
  <th>Info avots</th>
  <th>Soc.tîklu konts</th>
  <th>Grib aizbraukt uz</th>
  <th>Marðruta vçrtçjums</th>
  <th>Komentârs par marðrutu</th>
  <th>Naktsmîtnes vçrtçjums</th>
  <th>Komentârs par naktsmîtni</th>
  <th>Transporta vçrtçjums</th>
  <th>Komentârs par transportu</th>
  <th>Vadîtâja vçrtçjums</th>
  <th>Komentârs par vadîtâju</th>
  <th>Gida vçrtçjums</th>
  <th>Komentârs par gidu</th>
  <th>Iespaidi</th>
  <th>Kontaktinfo</th>
  <th></th>
 </tr>
 <%
 while not r.eof 
  %>
  <tr bgcolor=lightgreen>
   <td></td>
   <td align=center><%=dateprint(r("datums"))%></td>
   <td align=center><%if (getnum(r("braucis")) <> 3) then rw r("braucis") else rw "3+" %></td>
     <td align=center><% if r("pircis_online") then  rw "jâ" else rw "nç"%></td>
	   <td align=center><%=r("braucis")%></td>
   <td align=center><%=r("atz_marsruts")%></td>
   <td align=center><%=r("atz_naktsmitne")%></td>
   <td align=center><%=r("atz_transports")%></td>
   <td align=center><%=r("atz_vaditajs")%></td>
   <td align=center><%=r("atz_gids")%></td>
   <td><a href=anketa_del.asp?gid=<%=gid%>&id=<%=r("id")%> onclick="return confirm('Vai vçlaties dzçst anketu?')">Dzçst</a></td>
  </tr>
  <%
  r.movenext
 wend
 %><tr bgcolor=lightgreen>
  <td align=right><b>Vidçji</td>
  <td align=center><b><%=round(conn.execute("select avg(braucis) from anketas where not braucis is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td align=center><b><%=round(conn.execute("select avg(atz_marsruts) from anketas where not atz_marsruts is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td align=center><b><%=round(conn.execute("select avg(atz_naktsmitne) from anketas where not atz_naktsmitne is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td align=center><b><%=round(conn.execute("select avg(atz_transports) from anketas where not atz_transports is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td align=center><b><%=round(conn.execute("select avg(atz_vaditajs) from anketas where not atz_vaditajs is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td align=center><b><%=round(conn.execute("select avg(atz_gids) from anketas where not atz_gids is null and gid = "+cstr(gid))(0)*10)/10%></td>
  <td></td>
 </tr>
 <tr bgcolor=lightgreen><form name=forma action=anketa_add.asp method=POST>
  <td align=right><b></td>
  <td align=center><input type=text name=braucis size=4></td>
  <td align=center><input type=text name=atz_marsruts size=4></td>
  <td align=center><input type=text name=atz_naktsmitne size=4></td>
  <td align=center><input type=text name=atz_transports size=4></td>
  <td align=center><input type=text name=atz_vaditajs size=4></td>
  <td align=center><input type=text name=atz_gids size=4></td>
  <td align=center><input type=hidden name=gid value=<%=Request.QueryString("gid")%>>
   <input type=submit value=Pievienot name=poga></td>
 </tr>
 </table>
 </form>
 <%
 
%>
<br>
<a href="default.asp">Uz mâjâm</a>
<a href="anketa_grupa.asp">Cita grupa</a>
