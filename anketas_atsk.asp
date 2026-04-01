<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
DocStart "Anketu atskaite","y1.jpg"
dim conn
OpenConn
headlinks
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if

dat_no = Request.Form("dat_no")
dat_lidz = Request.Form("dat_lidz")
%>

<center><b><font face=tahoma>
<br>Anketu atskaite<br><br></b>

<%
'set r = conn.execute("select * from anketas where gid = "+gid+" order by vards")
 %>
 <form name=forma method=POST>
 <table border=0 cellpadding=3>
 <tr bgcolor=lightgreen>
  <td>Periods</td>
  <td><input type=text size=10 name=dat_no value=<%=dat_no%>> - <input type=text size=10 name=dat_lidz value=<%=dat_lidz%>></td>
 </tr>
 </table>
 <input type=hidden name=subm value=1>
 <input type=submit name=poga value="Râdît atskaiti">
 </form>

<% if Request.Form("subm") = "1" then %>
 <table>
  <tr>
   <th>Kods</th>
   <th>Nosaukums,<br>Laiks</th>
   <th>Klienti</th>
   <th>Anketas</th>
   <th>Marðruta v.a.</th>
   <th>Autobuss</th>
   <th>Ðoferi</th>
   <th>Ðoferu v.a.</th>
   <th>Naktsmâju v.a.</th>
   <th>Vadîtâjs</th>
   <th>Vadîtâja v.a.</th>
   <th>Piezîmes par vadîtâju</th>
   <th>Piezîmes par ceïojumu</th>
  </tr>
  <%
   
   set rGrupa = conn.execute ("select G.id as idg, IsNull(G.autobuss_id,0) as aid, IsNull(G.vad,0) as vid, G.mid, G.kods, G.sakuma_dat, G.beigu_dat from grupa G where (G.beigu_dat<='"+Trim(SQLDate(dat_lidz))+"' and G.beigu_dat>='"+SQLDate(dat_no)+"') and (G.mid in (select id from marsruts)) and (G.id in (select gid from Anketas)) order by G.beigu_dat,G.sakuma_dat")
   
   set rMarsruti = conn.execute ("select id, v from marsruts where id = "+cstr(rGrupa("mid")))
   
   while not rGrupa.eof
     %><tr bgcolor = lightgreen>
     <td><%=rGrupa("kods")%></td>
     <td><%Response.Write rMarsruti("v")%><br>
     <%Response.Write DatePrint(rGrupa("sakuma_dat"))%> - <%Response.Write DatePrint(rGrupa("beigu_dat"))%></td>
     <%
     set rCount = conn.execute ("select count(id) AS cid,gid from Pieteikums where gid = "+cstr(rGrupa("idg"))+" group by gid")
     %><td><%if not rCount.eof then Response.Write rCount("cid")%></td>   
     <%set rAnketas = conn.execute ("select count(id) AS cid,gid from Anketas where gid = "+cstr(rGrupa("idg"))+" group by gid")%>
     <td><%if not rAnketas.eof then Response.Write rAnketas("cid")%></td>
     <% set rAnketas2 = conn.execute("select gid,avg(atz_marsruts) as atz from Anketas where gid = "+cstr(rGrupa("idg"))+" group by gid")%>
     <%if not rAnketas2.eof then
       atz=rAnketas2("atz") 
       atz=round(atz*10)/10
     %>
     <td><%Response.Write atz
     else
       Response.Write ("<td></td>")
     end if
     %></td>
     <% 'set rAnketas3 = conn.execute("select id, gid from Anketas where gid = "+cstr(rGrupa("idg")))%>
     <% 'if not rAnketas3.eof then Response.Write rAnketas3("gid")%>
     <% 
     If rGrupa("aid") <> 0 then 
       set rAutobusi = conn.execute("select id, nosaukums, soferis from Autobusi where id = "+cstr(rGrupa("aid")))
       %><td><%=rAutobusi("nosaukums")%></td><%
       %><td><%=Decode(rAutobusi("soferis"))%></td><%
     else
       Response.Write ("<td></td><td></td>")
     end if
     set rAnketas4 = conn.execute("select gid,avg(atz_transports) as atz from Anketas where gid = "+cstr(rGrupa("idg"))+" group by gid")%>
     <%if not rAnketas4.eof then
       atz=rAnketas4("atz") 
       atz=round(atz*10)/10
     %>
     <td><%Response.Write atz
     else
       Response.Write ("<td></td>")
     end if
     %></td><%
     set rAnketas5 = conn.execute("select gid,avg(atz_naktsmitne) as atz from Anketas where gid = "+cstr(rGrupa("idg"))+" group by gid")%>
     <%%>
     <%if not rAnketas5.eof then
       atz=rAnketas5("atz") 
       atz=round(atz*10)/10
     %>
     <td><%Response.Write atz
     else
       Response.Write ("<td></td>")
     end if
     %></td><%
     
     if (cstr(rGrupa("vid")) <> "0") then
     %>
     <td><%Response.Write rGrupa("vid")
     else
       Response.Write ("<td></td>")
     end if
     %></td><%
     set rAnketas6 = conn.execute("select gid,avg(atz_vaditajs) as atz from Anketas where gid = "+cstr(rGrupa("idg"))+" group by gid")%>
     <%if not rAnketas6.eof then
       atz=rAnketas6("atz") 
       atz=round(atz*10)/10
     %>
     <td><%Response.Write atz
     else
       Response.Write ("<td></td>")
     end if
     %></td><%
     
     set rAnketas7 = conn.execute("select gid, piezimes_vaditajs, piezimes_celojums from Anketas where gid = "+cstr(rGrupa("idg")))%>
     <%if not rAnketas7.eof then
     Piez1 = "" 
     Piez2 = ""
     While not rAnketas7.eof
       Piez1 = Piez1 + rAnketas7("piezimes_vaditajs") + "<br>"
       Piez2 = Piez2 + rAnketas7("piezimes_celojums") + "<br>"
       rAnketas7.movenext
     wend%>
     <td><%Response.Write piez1 & "</td><td>" & piez2
     else
       Response.Write ("<td></td><td></td>")
     end if
     %></td><%
     %></tr><%
     rGrupa.movenext
   wend
   
  %>
 </table>
<% end if %>