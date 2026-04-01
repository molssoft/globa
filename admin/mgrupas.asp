<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Maršrutu grupas</title>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">


</head>


<body>

<p align="center">

<font size=6>Maršrutu grupas</font><br>
<% top_links %>
<hr>
<form name="forma2" method=post action="save_mgrupa.asp">
<table width="600" height="408">
 <tr>
  <td width="55" height="21">Kods</td>
  <td width="284" height="21">
    <p align="center">Grupa&nbsp;</p>
  </td>
  <td width="189" height="21">
    <p align="center"> Nosaukums</td>
  <td width="46" height="21"></td>
 </tr>
 <% set rmg = conn.execute ("select * from mgrupas order by nosaukums")
 while not rmg.eof
  %>
  <tr>
   <td width="55"><input type=text name=id<%=rmg("id")%> size=4 value="<%=rmg("id")%>"></td>
   <td width="284"><input type=text name=gr_nosaukums<%=rmg("id")%> value="<%=rmg("gr_nosaukums")%>" size = 30></td>
   <td width="189">
    <p align="right"><input type=text name=nosaukums<%=rmg("id")%> value="<%=rmg("nosaukums")%>" size = 30></td>
   <td rowspan=2 width="46" align="center">
    <p align="center">
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst maršrutu grupu?')) {forma2.action='del_mgrupa.asp';forma2.mgrupa_id.value='<%=rmg("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.mgrupa_id.value='<%=rmg("id")%>';forma2.action='save_mgrupa.asp';" value="S"></p>
    <p align="left">
    <a href="mgrupa.asp?id=<%=rmg("id")%>">
    Marš</a><a href="mgrupa.asp?id=<%=rmg("id")%>">.</a></p>
   </td>
   </tr>
  <tr>
   <td colspan=2 width="345" valign="top"><textarea name=citats<%=rmg("id")%> cols=40 rows=6><%=nullprint(rmg("citats"))%></textarea></td>
   <td width="189" valign="top" align="right">Galva&nbsp; <input type=text name=galva<%=rmg("id")%> size=15 value="<%=rmg("galva")%>"><br>
    Karte&nbsp; <input type=text name=karte<%=rmg("id")%> size=15 value="<%=rmg("karte")%>"><br>
    Sadaļja<input type=text name=sadala<%=rmg("id")%> size=15 value="<%=rmg("sadala")%>"><br>
    NPK&nbsp;&nbsp; <input type=text name=npk<%=rmg("id")%> size=15 value="<%=rmg("npk")%>"></td>
  </tr>
  <tr><td colspan=4 width="592" height="21"><hr></td></tr>
  <%
  rmg.movenext
 wend %>
 <tr>
  <td width="55"><input type=text name=add_id size=4></td>
  <td width="284"><input type=text name=add_gr_nosaukums size = 30></td>
  <td width="189">
    <p align="right"><input type=text name=add_nosaukums size = 30></td>
  <td width="46"><input type=submit onclick="forma2.action='add_mgrupa.asp'" value="+"></td>
 </tr>
 <tr>
  <td colspan=2 width="347" valign="top"><textarea name=add_citats cols=40 rows=6></textarea></td>
  <td width="191" align="right" valign="top">Galva <input type=text name=add_galva size=15><br>
    Karte <input type=text name=add_karte size=15><br>
    sadaļa <input type=text name=add_sadala size=15><br>
    NPK<input type=text name=add_npk size=15></td>
 </tr>
</table>
<input type=hidden name=mgrupa_id value=0>
</form>
</body>
