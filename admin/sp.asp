<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Apraksts</title></head>


<body>
<center>  
<font size="6">Speciālās Tēmas</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post action="save_sp.asp">
<table border="0" width="650">
 <tr>
  <td>Nr</td>
  <td>Pamattēma</td>
  <td>Apakštēma</td>
  <td>apraksts</td>
  <td>Val</td>
  <td>npk</td>
  <td align="center"></td>
 </tr>
 <% set rmg = conn.execute ("select * from sp_marsruts order by id")
 while not rmg.eof
  %>
  <tr>
   <td><a name="<%=rmg("ID")%>"><input type=text name=ID<%=rmg("id")%> value="<%=rmg("ID")%>" size = 4></a></td>
   <td><input type=text name=tema<%=rmg("id")%> value="<%=rmg("tema")%>" size = 26></td>
   <td><input type=text name=temap<%=rmg("id")%> value="<%=rmg("tema1")%>" size = 28></td>
   <td><input type=text name=marsruts<%=rmg("id")%> value="<%=rmg("marsruts")%>" size = 30></td>
   <td align="center">
    <input type=text name=valoda<%=rmg("id")%> value="<%=rmg("valoda")%>" size = 4>
   </td>
   <td>
    <input type=text name=npk<%=rmg("id")%> value="<%=rmg("npk")%>" size = 3>
   </td>
   <td align="center">
    <input type=submit onclick="forma2.id.value='<%=rmg("id")%>';forma2.action='save_sp.asp';" value="S">
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst aprakstu?')) {forma2.action='del_sp.asp';forma2.id.value='<%=rmg("id")%>';return true;} else return false;" value="-">
    <a href="sp_details.asp?id=<%=rmg("id")%>">Skatīt</a>
   </td>
  </tr>
  <%
  rmg.movenext
 wend %>
 <tr>
   <td><input type=text name=add_id size=4></td>
   <td><input type=text name=add_tema size=26></td>
   <td><input type=text name=add_tema1 size=28></td>
   <td><input type=text name=add_marsruts size=30></td>
   <td align="center"><input type=text name=add_valoda size=4 value="a"></td>
   <td><input type=text name=add_npk size=3 value="0"></td>
   <td align="center"><input type=submit onclick="forma2.action='add_sp.asp'" value="+"></td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
<a name="end">____</a>
</body>