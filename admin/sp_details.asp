<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

marsruts_id = request.querystring("id")
set rPr = conn.execute("select * from sp_marsruts where id = " + cstr(marsruts_id))
%>

<html>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Apraksti</title>


<body>
<center>  
<a href="sp.asp"><font size=4>Apraksts:<%=rPr("tema1")%></font></a>
<br><font size=6>Tēma:<%=rPr("marsruts")%></font><br>
<% top_links %>
<hr>

<form name="forma3" method=post action="save_sp.asp">
<font size=4>Saraksts:</font>
<table border=1 width="700" height="175">
 <tr>
  <td width="198" height="38">Virsraksts</td>
  <td width="70" height="38">Kārtas nr.</td>
  <td width="210" height="38">Saturs</td>
  <td width="17" height="38">&nbsp;</td>
 </tr>
 <% set r = conn.execute ("select * from sp_saraksts where marshruts_id = "+cstr(marsruts_id)+" order by kartas_nr")
 while not r.eof
  %>
  <tr>
   <td width="198" height="94"><input type=text name=virsraksts<%=r("id")%> value="<%=r("virsraksts")%>" size = 34></td>
   <td width="70" height="94"><input type=text name=kartas_nr<%=r("id")%> value="<%=r("kartas_nr")%>" size = 15></td>
   <td width="210" height="94"><textarea name=saturs<%=r("id")%> rows="4" cols="40"><%=r("saturs")%> </textarea></td>
   <td width="17" height="94">
    <nobr>
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst saraksta rindu?')) {forma3.action='del_sp_saraksts.asp';forma3.id.value='<%=r("id")%>';return true;} else return false;" value="-" id=submit1 name=submit1>
    <input type=submit onclick="forma3.id.value='<%=r("id")%>';forma3.action='save_sp_saraksts.asp';" value="S" id=submit2 name=submit2>
    <nobr>
   </td>
  </tr>
  <%
  r.movenext
 wend %>
 <tr>
   <td width="198" height="25"><input type=text name=add_virsraksts size = 34></td>
   <td width="70" height="25"><input type=text name=add_kartas_nr size = 15></td>
   <td width="210" height="25"><textarea name=add_saturs rows="4" cols="40"></textarea></td>
   <td width="17" height="25"><input type=submit onclick="forma3.action='add_sp_saraksts.asp'" value="+" id=submit3 name=submit3></td>
 </tr>
</table>
<input type=hidden name=id value=0>
<input type=hidden name=marsruts_id value=<%=marsruts_id%>>
</form>


</body>