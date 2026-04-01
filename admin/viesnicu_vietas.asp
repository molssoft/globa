<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Viesnicu pilsçtas</title></head>

<body>
<center>  
<font size=6>Viesnicu pilsçtas</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post>
<table>
 <tr>
  <td>Nosaukums LV</td>
  <td>Nosaukums EN</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from viesnicu_vietas order by nosaukums_lat")
 while not r.eof
  %>
  <tr>
   <td valign=top><input type=text name=nosaukums_lat<%=r("id")%> size=20 value="<%=r("Nosaukums_lat")%>"></td>
   <td valign=top><input type=text name=nosaukums_eng<%=r("id")%> size=20 value="<%=r("Nosaukums_eng")%>"></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst ierakstu?')) {forma2.action='viesnicu_vietas_del.asp';forma2.id.value='<%=r("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=r("id")%>';forma2.action='viesnicu_vietas_save.asp';" value="S">
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td><input type=text name=new_nosaukums_lat size=20 ></td>
   <td><input type=text name=new_nosaukums_eng size=20 ></td>
   <td>
    <input type=submit onclick="forma2.action='viesnicu_vietas_add.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>