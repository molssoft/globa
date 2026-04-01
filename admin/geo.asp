<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

parent = Request.QueryString("parent")
set r = conn.execute("select * from geo where isnull(parent_id,'') = '"+parent+"' order by title")
set rparent = conn.execute("select * from geo where id = '"+parent+"'")
%>
<center>
<font face=Tahoma>
<font size=5>Ìeogrâfija</font><br><br>
<%top_links%>
<hr>
<p align=left>
<table border = 0>
<% if parent<>"" then %>
 <tr><td width=200><a href=geo.asp?parent=<%=rParent("parent_id")%>>...</a></td><td width=300></td><td></td></tr>
 <% 
else
 %><tr><td width=200></td><td width=300></td><td></td></tr><%
end if 

while not r.eof
 %>
 <tr>
 <td>
  <a href=geo.asp?parent=<%=r("id")%>><%=r("id")%></a>
 </td>
 <td>
  <%=r("title")%>
 </td>
 <td>
  <a href=geo_edit.asp?id=<%=r("id")%>>Labot</a>
  | <a href=geo_del.asp?id=<%=r("id")%> onclick="return confirm('Patieðâm dzçst?')">Dzçst</a>
 </td></tr><%
 r.movenext
 i = i + 1
wend
%></table><br><%

if parent<>"" then
 %><a href=geo_new.asp?parent=<%=rParent("id")%>>Jauns</a><%
else
 %><a href=geo_new.asp>Jauns</a><%
end if 
%>
