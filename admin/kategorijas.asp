<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Kategorijas</title></head>

<body>
<center>  
<font size=6>Kategorijas</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post>
<table>
 <tr>
  <td>ID</td>
  <td>Nr.</td>
  <td>Nosaukums</td>
  <td>Bilde</td>
  <td>Râdît<br>bildi</td>
  <td>Râdît<br>mekl.</td>  
  <td>Krâsa</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from kategorijas order by order_num")
 while not r.eof
  %>
  <tr>
   <td valign=top><%=r("id")%></td>
   <td valign=top><input type=text name=order_num<%=r("id")%> size=3 value="<%=r("order_num")%>"></td>
   <td valign=top><input type=text name=nosaukums<%=r("id")%> size=20 value="<%=r("Nosaukums")%>"></td>
   <td valign=top><input type=text name=bilde<%=r("id")%> size=20 value="<%=r("Bilde")%>">
    <%if nullprint(r("bilde"))<>"" then Response.Write "<img src='../common_images/"+r("bilde")+"'>" %>
   </td>
   <td ><input type=checkbox name=radit_bildi<%=r("id")%> <%if r("radit_bildi")=true then Response.Write " checked "%>></td>
   <td ><input type=checkbox name=radit_mekl<%=r("id")%> <%if r("radit_mekl")=true then Response.Write " checked "%>></td>
   <td valign=top><input type=text name=krasa<%=r("id")%> size=8 value="<%=r("krasa")%>">
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst ierakstu?')) {forma2.action='kategorijas_del.asp';forma2.id.value='<%=r("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=r("id")%>';forma2.action='kategorijas_save.asp';" value="S">
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td><input type=text name=new_id size=10 ></td>
   <td><input type=text name=new_order_num size=3 ></td>
   <td><input type=text name=new_nosaukums size=20 ></td>
   <td><input type=text name=new_bilde size=20 ></td>
   <td><input type=checkbox name=new_radit_bildi></td>
   <td>
    <input type=submit onclick="forma2.action='kategorijas_add.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>