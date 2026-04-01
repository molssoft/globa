<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
 <title>Intereses</title>
</head>

<body>
<center>  
<font size=6>Intereses</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post>
<table>
 <tr>
  <td>ID</td>
  <td>Nosaukums</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from temas order by id")
 while not r.eof
  %>
  <tr>
   <td valign=top><%=r("id")%></td>
   <td valign=top><input type=text name=nosaukums<%=r("id")%> size=20 value="<%=r("Nosaukums")%>"></td>
   <td ><input type=checkbox name=aktivs<%=r("id")%> <%if r("aktivs")=true then Response.Write " checked "%>></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst ierakstu?')) {forma2.action='intereses_del.asp';forma2.id.value='<%=r("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=r("id")%>';forma2.action='intereses_save.asp';" value="S">
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td><input type=text name=new_id size=20 ></td>
   <td><input type=text name=new_nosaukums size=20 ></td>
   <td>
    <input type=submit onclick="forma2.action='intereses_add.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>