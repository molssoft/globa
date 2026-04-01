<!-- #include file = "../conn.asp" -->

<%
dim conn
openconn

id = Request.QueryString("id")
set r = conn.execute("select * from geo where id = '"+id+"'")
set rParent = conn.execute("select isnull(parent_id,'') from geo where id = '"+id+"'")
%>

<font face=Tahoma>
<font size=5>Labot vietu <%=id%></font><br><br>

<form name=forma method=POST action=geo_save.asp>
<table border = 0>

 <tr>
  <td align=right>
   ID
  </td>
  <td>
   <%=id%>
   <input type=hidden name=id value="<%=id%>">
   <input type=hidden name=parent value="<%=rParent(0)%>">
  </td>
 </tr>

 <tr>
  <td align=right>
   Vecâks
  </td>
  <td>
   <select name=new_parent>
    <% set rPar = conn.execute("select * from Geo order by id")
    %> <option value="" <%if isnull(rPar("id")) then Response.Write " selected "%> ></option><%
    while not rPar.eof
     %><option value=<%=rPar("id")%> <%if rPar("id")=r("parent_id") then Response.Write " selected "%> ><%=rPar("title")%></option><%
     rPar.Movenext
    wend %>
   </select>
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
     %><option value=<%=rType("id")%> <%if rType("id")=r("type_id") then Response.Write " selected "%> ><%=rType("title")%></option><%
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
   <input type=text size=50 maxlength=50 name=title value="<%=r("title")%>">
  </td>
 </tr>

 <tr>
  <td align=right>
   Bilde
  </td>
  <td>
   <input type=text size=20 maxlength=50 name=bilde value="<%=r("bilde")%>">
  </td>
 </tr>

 <tr>
  <td align=right>
   Viesnîcas
  </td>
  <td>
   <input type=checkbox name=viesnicas <% if r("viesnicas") then Response.Write " checked " %>>
  </td>
 </tr>

<tr>
  <td></td>
  <td align=center>
   <a href=Saglabât onclick="forma.submit();return false;">Saglabât</a> |
   <a href=geo.asp?parent=<%=rParent(0)%>>Atcelt</a>
  </td>
  <td></td>
 </tr>

 </table>
