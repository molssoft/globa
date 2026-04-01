<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
id = request.querystring("id")
valsts = request.querystring("valsts")
tema = request.querystring("tema")
kat = request.querystring("kat")
%>

<html>
<head>
<title>Maršruti</title>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
</head>
<body>
<center>  
<% 
if id = "NEKLASIF" then
 set rm = conn.execute ("select * from marsruti where id not in (select marsruts from geo_marsruti) order by nosaukums")
 %>
 <font size=6><a href="default.asp">Maršrutu grupa</a>:Neklasificētie maršruti</font>
 <%
elseif valsts <> "" then
 set rm = conn.execute ("select * from marsruti where id in (select marsruts from geo_marsruti where geo='"+valsts+"') order by nosaukums")
 %>
 <font size=6><a href="default.asp">Valsts:</a><%=conn.execute("select title from geo where id = '"+valsts+"'")(0)%></font>
 <%
elseif tema <> "" then
 set rm = conn.execute ("select * from marsruti where id in (select marsruts from temas_marsruti where tema='"+tema+"') order by nosaukums")
 %>
 <font size=6><a href="default.asp">Interese:</a><%=conn.execute("select nosaukums from temas where id = '"+tema+"'")(0)%></font>
 <%
elseif kat <> "" then
 set rm = conn.execute ("select * from marsruti where id in (select marsruts from kat_marsruti where kategorija='"+kat+"') order by nosaukums")
 %>
 <font size=6><a href="default.asp">Kategorija:</a><%=conn.execute("select nosaukums from kategorijas where id = '"+kat+"'")(0)%></font>
 <%
else
 set rm = conn.execute ("select * from marsruti where mgrupa='"+cstr(id)+"' order by nosaukums")
 set rg = conn.execute ("select * from mgrupas where id = '"+cstr(id)+"'") 
 %>
 <font size=6><a href="default.asp">Maršrutu grupa</a>:<%=rg("nosaukums")%></font>
 <%
end if %>
<hr>
<%
'Response.Write(rm.count)
if rm.eof then
 %>Neviens maršruts nav atrasts.<%
else
 %><table border="0"  width="100%">
  <tr><td align=left nowrap  width="50%"><b>Maršruta nosaukums</td><td width="50%"><b>PDF Fails</b></td></tr>
 <%
  while not rm.eof
   %>
   <tr>
    <td align=left nowrap style="border-bottom-style: dotted; border-bottom-width: 1"><a href="marsruts.asp?id=<%=rm("id")%>"><%=rm("nosaukums")%></a></td><td style="border-bottom-style: dotted; border-bottom-width: 1"><%=rm("pdf")%></td>
    <% if id = "NEKLASIF" then 
     set r = conn.execute ("select nosaukums from mgrupas where id = '"+rm("mgrupa")+"'")
     'Response.Write("select nosaukums from mgrupas where id = '"+rm("mgrupa")+"'")
     if not r.eof then
      Response.Write "<td>"+r("nosaukums")+"</td><td></td>"
     end if
    end if %>
   </tr>
   <%
   rm.movenext
  wend
 %></table><%
end if
%>
</body>
</html>

