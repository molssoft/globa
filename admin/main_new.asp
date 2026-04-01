<!-- #include file = "../conn.asp" -->

<%
dim conn
openconn

parent = Request.QueryString("parent")
typ = Request.QueryString("typ")

'dabonam nâkamo id
i = 1
while not conn.execute("select id from theMain where id = '"+parent+cstr(i)+"'").eof
 i = i + 1
wend
id = parent+cstr(i)

%>

<font face=Tahoma>
<font size=5>Jauns raksts</font><br><br>

<form name=forma method=POST action=main_add.asp>
<table border = 0>

 <tr>
  <td align=right>
   ID:
  </td>
  <td>
   <input type=text size=20 maxlength=20 name=id value=<%=id%>>
   <input type=hidden name=parent value="<%=parent%>">
  </td>
 </tr>

 <tr>
  <td align=right>
   Aktîvs:
  </td>
  <td>
   <input type=checkbox name=active>
  </td>
 </tr>

 <tr>
  <td align=right>
   Aktîvs (laiks):
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=active_start >
   lîdz <input type=text size=10 maxlength=10 name=active_end >
  </td>
 </tr>

 <tr>
  <td align=right>
   Tips:
  </td>
  <td>
   <select name=type_id>
    <% set rType = conn.execute("select * from types order by title")
    while not rType.eof
     %><option <%
     if mid(parent,1,6)="PARAMS" and rType("id") = "PARAM" then
      Response.Write " selected "
     end if
     %> value=<%=rType("id")%>><%=rType("title")%></option><%
     rType.Movenext
    wend %>
   </select>
  </td>
 </tr>

 <tr>
  <td align=right>
   Virsraksts:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=title>
  </td>
 </tr>

 <tr>
  <td align=right>
   Mazs virsraksts:
  </td>
  <td>
   <input type=text size=25 maxlength=200 name=small_title>
  </td>
 </tr>

 <tr>
  <td align=right>
   Datums:
  </td>
  <td>
   <input type=text size=10 maxlength=10 name=datums value=<%=day(now)%>/<%=month(now)%>/<%=year(now)%>>
  </td>
 </tr>

 <tr>
  <td align=right>
   Jaunums:
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=first_page_start>
   lîdz <input type=text size=10 maxlength=10 name=first_page_end>
   <select name=rg>
    <option value=''>-</option>
    <% set rg = conn.execute("select id,title from themain where parent_id = 'RAKSTGRUPAS' order by order_num")
    while not rg.eof
     %><option value=<%=rg("id")%> ><%=rg("title")%></option><%
     rg.movenext
    wend
    %>
   </select>
  </td>
 </tr>

 <tr>
  <td align=right>
   Baneris:
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=banner_start>
   lîdz <input type=text size=10 maxlength=10 name=banner_end>
  </td>
 </tr>

 <tr>
  <td align=right>
   Lielâ bilde:
  </td>
  <td>
   common_images/<input type=text size=10 maxlength=50 name=liela_bilde>
  </td>
 </tr>

 <tr>
  <td align=right>
   Raksta bilde:
  </td>
  <td>
   common_images/<input type=text size=10 maxlength=50 name=picture>
  </td>
 </tr>

 <tr>
  <td align=right>
   Teksts:
  </td>
  <td>
   <textarea name=text cols=50 rows=10></textarea>
  </td>
 </tr>
 
 <tr>
  <td align=right>
   URL:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=url>
  </td>
 </tr>

 <tr>
  <td align=right>
   Saistîtie raksti:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=skatit> (rakstu ID atdalîti ar | )
  </td>
 </tr>

 <tr>
  <td align=right>
   Èarters:
  </td>
  <td>
   <select name=charter>
    <option value=0>-</option>
    <% set rC = conn.execute("select * from marsruti where id in (select marsruts from kat_marsruti where kategorija = 'CHARTERS') order by nosaukums")
    while not rC.eof
     %><option value=<%=rC("id")%>><%=rC("nosaukums")%></option><% '+" - "+rc("chartergroup")
     rC.MoveNext
    wend
    %>
   </select>
  </td>
 </tr>

 <tr>
  <td align=right>
   Cena (teksts):
  </td>
  <td>
   <input type=text size=10 maxlength=50 name=cena_txt>
  </td>
 </tr>


 <tr>
  <td></td>
  <td align=center>
   <a href=Saglabât onclick="forma.submit();return false;">Saglabât</a> |
   <a href=main.asp?parent=<%=parent%>>Atcelt</a>
  </td>
  <td></td>
 </tr>

</table>
