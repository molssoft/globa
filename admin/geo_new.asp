<!-- #include file = "../conn.asp" -->

<%
dim conn
openconn

parent = Request.QueryString("parent")
%>

<font face=Tahoma>
<font size=5>Jauna vieta</font><br><br>

<form name=forma method=POST action=geo_add.asp>
<table border = 0>

 <tr>
  <td align=right>
   ID
  </td>
  <td>
   <input type=text size=10 maxlength=10 name=id>
   <input type=hidden name=parent value="<%=parent%>">
  </td>
 </tr>

 <tr>
  <td align=right>
   Tips
  </td>
  <td>
   <select name=type_id>
    <% set rType = conn.execute("select * from Geo_types order by title")
    while not rType.eof
     %><option value=<%=rType("id")%>><%=rType("title")%></option><%
     rType.Movenext
    wend %>
   </select>
  </td>
 </tr>

 <tr>
  <td align=right>
   Virsraksts
  </td>
  <td>
   <input type=text size=50 maxlength=50 name=title>
  </td>
 </tr>

 <tr>
  <td align=right>
   Viescnias
  </td>
  <td>
   <input type=checkbox name=viesnicas>
  </td>
 </tr>
 
 <tr>
  <td></td>
  <td align=center>
   <a href=Saglabât onclick="forma.submit();return false;">Saglabât</a> |
   <a href=geo.asp?parent=<%=parent%>>Atcelt</a>
  </td>
  <td></td>
 </tr>

</table>
