<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
id = request.querystring("id")
set rm = conn.execute ("select * from majas where cena = "+cstr(id))
set rc = conn.execute ("select * from cenas where id = " + cstr(id))
%>

<html>
<head><title>Naktsmîtnes</title></head>
<body>
<center>  
<font size=6><a href="marsruts.asp?id=<%=rc("marsruts")%>">Cenas grupa</a>:<%=rc("cena")%></font>
<hr>

<form name=forma2 method=post action=save_maja.asp>
<table border = 1>
 <tr>
  <th>Attçls</th>
  <th>Apraksts</th>
 </tr>
 
 <%
 while not rm.eof %>
  <tr>
   <td>
    <% set rb = conn.execute("select * from bildes where id = " +cstr(rm("bilde"))) %>
    <a href="maja_bilde.asp?id=<%=rm("id")%>"><img border=0 src="http://www.impro.lv/<%=rb("cels")%>"></a>
   </td>
   <td>
    <textarea cols=30 name=apraksts<%=rm("id")%>><%=conn.execute("select apraksts from majas where id = "+cstr(rm("id")))(0)%></textarea>
   </td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst naktsmâjas?')) {forma2.action='del_maja.asp';forma2.maja_id.value=<%=rm("id")%>;return true;} else return false;" value="-">
    <input type=submit onclick="forma2.maja_id.value=<%=rm("id")%>;forma2.action='save_maja.asp';" value="S">
   </td>
  </tr>
  <% rm.movenext
 wend %>
  <tr>
   <td>
   </td>
   <td>
    <textarea cols=30 name=add_apraksts></textarea>
   </td>
   <td>
    <input type=submit onclick="forma2.action='add_maja.asp'" value="+">
   </td>
  </tr>
</table>
<input type=hidden name=maja_id value=0>
<input type=hidden name=id value=<%=id%>>
</form>