<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Kluba galerija</title></head>

<body>
<center>  
<font size=6>Marðrutu grupas</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post>
<table>
 <tr>
  <td></td>
  <td>Mazâ bilde</td>
  <td>Lielâ bilde</td>
  <td>Apraksts</td>
  <td></td>
 </tr>
 <% set r = conn.execute ("select * from klub_gal order by id")
 while not r.eof
  %>
  <tr>
   <td><img src="http://www.impro.lv/<%=r("maza_adr")%>" height=40 width=40></td>
   <td valign=top><input type=text name=maza_adr<%=r("id")%> size=20 value="<%=r("maza_adr")%>"></td>
   <td valign=top><input type=text name=liela_adr<%=r("id")%> value="<%=r("liela_adr")%>" size = 20></td>
   <td><textarea name=apraksts<%=r("id")%>><%=r("apraksts")%></textarea></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst attçla adresi?')) {forma2.action='del_klub_gal.asp';forma2.klub_gal_id.value=<%=r("id")%>;return true;} else return false;" value="-">
    <input type=submit onclick="forma2.klub_gal_id.value=<%=r("id")%>;forma2.action='save_klub_gal.asp';" value="S">
   </td>
  </tr>
  <%
  r.movenext
 wend %>

 <tr>
   <td></td>
   <td><input type=text name=maza_adr size=20 ></td>
   <td><input type=text name=liela_adr  size = 20 ></td>
   <td><textarea name=apraksts></textarea></td>
   <td>
    <input type=submit onclick="forma2.action='add_klub_gal.asp';return true;" value="+">
   </td>
 </tr>
</table>
<input type=hidden name=klub_gal_id value=0>
</form>
</body>