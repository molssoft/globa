<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Prâmji</title></head>


<body>
<center>  
<font size=6>Prâmji</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post action="save_pr.asp">
<table>
 <tr>
  <td>Nr</td>
  <td>Kompanija</td>
  <td>Valsts</td>
  <td>Marsruts</td>
  <td></td>
 </tr>
 <% set rmg = conn.execute ("select * from pr_marsruts order by id")
 while not rmg.eof
  %>
  <tr>
   <td><input type=text name=ID<%=rmg("id")%> value="<%=rmg("ID")%>" size = 4></td>
   <td><input type=text name=Kompanija<%=rmg("id")%> value="<%=rmg("kompanija")%>" size = 30></td>
   <td><input type=text name=valsts<%=rmg("id")%> value="<%=rmg("valsts")%>" size = 40></td>
   <td><input type=text name=marsruts<%=rmg("id")%> value="<%=rmg("marsruts")%>" size = 40></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst prâmju marðrutu?')) {forma2.action='del_pr.asp';forma2.id.value='<%=rmg("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=rmg("id")%>';forma2.action='save_pr.asp';" value="S">
    <a href="pr_details.asp?id=<%=rmg("id")%>">Skatît</a>
   </td>
  </tr>
  <%
  rmg.movenext
 wend %>
 <tr>
   <td><input type=text name=add_id size=4></td>
   <td><input type=text name=add_kompanija size=30></td>
   <td><input type=text name=add_valsts size=40></td>
   <td><input type=text name=add_marsruts size=40></td>
   <td><input type=submit onclick="forma2.action='add_pr.asp'" value="+"></td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>