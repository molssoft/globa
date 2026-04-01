<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
 <title>Datu tipi</title>
</head>

<body>
<center>  
<font size=6>Datu tipi</font><br>
<% top_links %>
<hr>

<%
Response.Write session("message")
session("message") = ""
%>

<form name="forma2" method=post>
<table>
 <tr>
  <td>ID</td>
  <td valign=top>Nosaukums</td>
  <td valign=top bgcolor=#DDDDDD>Katalogs</td>
  <td valign=top>Aktīvs</td>
  <td valign=top bgcolor=#DDDDDD>Aktīvs (laiks)</td>
  <td valign=top>Tips</td>
  <td valign=top bgcolor=#DDDDDD>Virsraksts</td>
  <td valign=top>Mazs virsraksts</td>
  <td valign=top bgcolor=#DDDDDD>Datums</td>
  <td valign=top>Jaunums</td>
  <td valign=top bgcolor=#DDDDDD>Banneris</td>
  <td valign=top>Lielā bilde</td>
  <td valign=top bgcolor=#DDDDDD>Raksta bilde</td>
  <td valign=top>Ievads</td>
  <td valign=top bgcolor=#DDDDDD>Teksts</td>
  <td valign=top>URL</td>
  <td valign=top bgcolor=#DDDDDD>Saistītie raksti</td>
  <td valign=top>Efekts</td>
  <td valign=top bgcolor=#DDDDDD>Čarters</td>
  <td valign=top>Grupas</td>
  <td valign=top bgcolor=#DDDDDD>Maršruti</td>
  <td valign=top>Cena</td>
  <td valign=top>Ikona</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from types order by title")
 while not r.eof
  %>
  <tr>
   <td valign=top><%=r("id")%></td>
   <td valign=top><input type=text name=title<%=r("id")%> size=20 value="<%=r("Title")%>"></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=katalogs<%=r("id")%> <%if r("bit_katalogs")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=aktivs<%=r("id")%> <%if r("bit_aktivs")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=aktivs_laiks<%=r("id")%> <%if r("bit_aktivs_laiks")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=tips<%=r("id")%> <%if r("bit_tips")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=virsraksts<%=r("id")%> <%if r("bit_virsraksts")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=mazs_virsraksts<%=r("id")%> <%if r("bit_mazs_virsraksts")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=datums<%=r("id")%> <%if r("bit_datums")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=jaunums<%=r("id")%> <%if r("bit_jaunums")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=banneris<%=r("id")%> <%if r("bit_banneris")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=liela_bilde<%=r("id")%> <%if r("bit_liela_bilde")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=raksta_bilde<%=r("id")%> <%if r("bit_raksta_bilde")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=ievads<%=r("id")%> <%if r("bit_ievads")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=teksts<%=r("id")%> <%if r("bit_teksts")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=url<%=r("id")%> <%if r("bit_url")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=saistitie_raksti<%=r("id")%> <%if r("bit_saistitie_raksti")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=efekts<%=r("id")%> <%if r("bit_efekts")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=carters<%=r("id")%> <%if r("bit_carters")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=grupas<%=r("id")%> <%if r("bit_grupas")=true then Response.Write " checked "%>></td>
   <td align=center bgcolor=#DDDDDD><input type=checkbox name=marsruti<%=r("id")%> <%if r("bit_marsruti")=true then Response.Write " checked "%>></td>
   <td align=center><input type=checkbox name=cena<%=r("id")%> <%if r("bit_cena")=true then Response.Write " checked "%>></td>
   <td valign=top><input type=text name=icon<%=r("id")%> size=10 value="<%=r("icon")%>"></td>
   <td><nobr>
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst ierakstu?')) {forma2.action='types_del.asp';forma2.id.value='<%=r("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=r("id")%>';forma2.action='types_save.asp';" value="S">
    </nobr>
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td><input type=text name=new_id size=20 ></td>
   <td><input type=text name=new_title size=20 ></td>
   <td>
    <input type=submit onclick="forma2.action='types_add.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>