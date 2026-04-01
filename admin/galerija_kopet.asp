<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<head><title>Galeriju kopēšana</title>
<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">


</head>
<center>
<%
dim conn
openconn

act = Request.Form("act")

%>
<form name=forma method=post>
<input type=hidden name=act>
<table>
 <tr>
  <td>
   Kopēt no:
  </td>
  <td>
   <% list_galerija "galerija_from",Request.Form("galerija_from")%>
  </td>
 </tr>
 <tr>
  <td>
   Kopēt uz:
  </td>
  <td>
   <% list_galerija "galerija_to",Request.Form("galerija_to")%>
   <a href="main.asp?parent=<%=Request.Form("galerija_to")%>">Apskatīt</a>
  </td>
 </tr>
</table>

<input type=submit name=poga value="Parādīt" onclick="forma.act.value='show';forma.submit();return false;"><br><br>

<%

if act = "copy" then
 parent = Request.Form("galerija_to")
 num = getnum(conn.execute("select max(order_num) from theMain where parent_id = '"+parent+"'")(0))
 set rFrom = conn.execute("select * from theMain where parent_id = '"+Request.Form("galerija_from")+"' order by order_num")
 while not rFrom.eof
  'pārbaudam vai ir šī bilde atzīmēta
  if Request.Form("bilde"+trim(rfrom("id")))="on" then
   'tad kopējam, dabonam brīvu identifikatoru
   i = 1
   while not conn.execute("select id from theMain where id = '"+parent+cstr(i)+"'").eof
    i = i + 1
   wend
   id = parent+cstr(i)
   
   'insertējam
   num = num + 1
   teksts = conn.execute("select text from theMain where id = '"+rFrom("id")+"'")(0)
   teksts = SQLText(nullstring(teksts))
   conn.execute("insert into theMain (id,type_id,parent_id,order_num,active,title,text,liela_bilde,datums) values ('"+trim(id)+"','BILDE','"+parent+"',"+cstr(num)+",1,'"+nullstring(rFrom("liela_bilde"))+"','"+teksts+"','"+nullstring(rFrom("liela_bilde"))+"','"+sqldate(now)+"')")
  end if
  rFrom.movenext
 wend
end if

if act = "show" or act = "copy" then
 set r = conn.execute("select title from theMain where id = '"+Request.Form("galerija_from")+"'")
 %>Galerija <%=r("title")%><br><br><%
 set rFrom = conn.execute("select * from theMain where parent_id = '"+Request.Form("galerija_from")+"' and not liela_bilde in (select liela_bilde from theMain where parent_id = '"+Request.Form("galerija_to")+"') order by order_num")
 %><table><%
 while not rFrom.eof
  %>
  <tr>
  <td align=right>
  <img src="http://www.impro.lv/common_images/<%=rFrom("liela_bilde")%>" height=100>
  </td>
  <td> 
   <%=rFrom("order_num")%>
  </td>
  <td>
  <input type=checkbox name=bilde<%=trim(rFrom("id"))%>>
  </td>
  <td>
  <%=conn.execute("select text from themain where id = '"+rFrom("id")+"'")(0)%>
  </td>
  </tr>
  <%
  rFrom.movenext
 wend
 %></table><br><br><input type=submit name=poga value="Kopēt" onclick="forma.act.value='copy';forma.submit();return false;"><%
end if
%></form><%

sub list_galerija(n,sel)
 set r = conn.execute("select * from theMain where type_id = 'GALERIJA' order by title")
 %><select name=<%=n%>><%
 while not r.eof
  %><option value=<%=r("id")%>
  <% if trim(sel) = trim(r("id")) then Response.Write " selected " %>
  >
  <%=r("title")%>
  </option><%
  r.movenext
 wend
 %></select><%
end sub
%>