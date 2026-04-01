<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Viesnicas</title></head>

<body>
<center>  
<font size=6>Viesnicas</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post>
<table>
 <tr>
  <td>Nosaukums</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from viesnicas order by nosaukums")
 while not r.eof
  %>
  <tr>
   <td>
    <input type=hidden name=vieta<%=r("id")%>>
    <%
     set rvieta = conn.execute("select nosaukums_lat from viesnicu_vietas where id = "+cstr(r("vieta")))
     if not rvieta.eof then Response.Write rvieta(0)
    %>
   </td>
   <td valign=top><input type=text name=nosaukums<%=r("id")%> size=20 value="<%=r("Nosaukums")%>"></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst ierakstu?')) {forma2.action='viesnicas_del.asp';forma2.id.value='<%=r("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=r("id")%>';forma2.action='viesnicas_save.asp';" value="S">
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td>
    <select name=new_vieta>
     <option></option>
     <% set rVieta = conn.execute("select * from viesnicu_vietas order by nosaukums_lat") %>
     <% while not rVieta.eof %>
      <option value=<%=rVieta("id")%>><%=rVieta("nosaukums_lat")%></option>
      <% rVieta.movenext %>
     <% wend %>
    </select>
   </td>
   <td><input type=text name=new_nosaukums size=20 ></td>
   <td>
    <input type=submit onclick="forma2.action='viesnicas_add.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>