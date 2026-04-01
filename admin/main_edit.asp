<html>
<head>
	<title><%=title%></title>
    <meta http-equiv="content-type" content="text/html; charset=windows-1257">
<style type="text/css">
</style>
</head>

<!-- #include file = "conn.asp" -->
<!-- #include file = "procs.asp" -->
<%

dim conn
openconn

id = Request.QueryString("id")
marker = Request.QueryString("marker")
set r = conn.execute("select id,order_num,datums,active,active_start,active_end,type_id,title,small_title,first_page_start,first_page_end,banner_start,banner_end,parent_id,charter,liela_BILDE,picture,cena_txt,grupa,url,rg,skatit from themain where id = '"+id+"'")
set rParent = conn.execute("select isnull(parent_id,''),type_id from themain where id = '"+id+"'")
set rType = conn.execute("select * from types where id = '"+cstr(rParent("type_id"))+"'")

%>


<script LANGUAGE="JavaScript">
<!--hide
function NewCenterWindow(url,w,h)
{
window.open(url,'pass', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes, resizable=no,copyhistory=no,width='+w+',height='+h+',top='+(screen.height/2-h/2)+',left='+(screen.width/2-w/2));
}
//-->
</script>

<SCRIPT Language=JavaScript>
function BreakItUp()
{
  //Set the limit for field size.
  var FormLimit = 102399

  //Get the value of the large input object.
  var TempVar = new String
  TempVar = document.forma.text.value

  //If the length of the object is greater than the limit, break it
  //into multiple objects.

  if (TempVar.length > FormLimit)
  {
    document.forma.text.value = TempVar.substr(0, FormLimit)
    TempVar = TempVar.substr(FormLimit)

    while (TempVar.length > 0)
    {
      var objTEXTAREA = document.createElement("TEXTAREA")
      objTEXTAREA.name = "text"
      objTEXTAREA.value = TempVar.substr(0, FormLimit)
      document.forma.appendChild(objTEXTAREA)
      
      TempVar = TempVar.substr(FormLimit)
    }
  }
}
</SCRIPT>


<form name=forma method=POST action=main_save.asp>
<table border = 0>

 <tr>
  <td align=right>
   ID:
  </td>
  <td>
   <%=id%>
   <input type=hidden name=id value="<%=id%>">
  </td>
 </tr>
 
<% if rType("bit_katalogs")=true then %>
 <tr>
  <td align=right>
   Katalogs:
  </td>
  <td>
   <select name=parent>
    <option value=NULL>NAV</option>
    <% 
     set rParents = conn.execute("select id,title from theMain order by id")
     while not rParents.eof
      %><option 
      <% if rParent(0) = rParents("id") then response.write " selected " %>
      value="<%=rParents("id")%>"><%=rParents("id")%>-<%=rParents("title")%></option><%
      rParents.movenext
     wend
    %>
   </select>
  </td>
 </tr>
<% else %>
 <input type=hidden name=parent value="<%=rParent(0)%>">
<% end if %>

<% if rType("bit_aktivs")=true then %>
 <tr>
  <td align=right>
   Aktīvs:
  </td>
  <td>
   <input type=checkbox name=active <%if r("active")=true then Response.Write "checked"%> >
  </td>
 </tr>
<% else %>
 <input type=hidden name=active value="<%if r("active")=true then Response.Write "on"%>">
<% end if %>

<% if rType("bit_aktivs_laiks")=true then %>
 <tr>
  <td align=right>
   Aktīvs (laiks):
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=active_start value="<%=DatePrint(r("active_start"))%>">
   līdz <input type=text size=10 maxlength=10 name=active_end value="<%=DatePrint(r("active_end"))%>">
  </td>
 </tr>
<% else %>
 <input type=hidden name=active_start value="<%=DatePrint(r("active_start"))%>">
 <input type=hidden name=active_end value="<%=DatePrint(r("active_end"))%>">
<% end if %>

<% if rType("bit_tips")=true then %>
 <tr>
  <td align=right>
   Tips:
  </td>
  <td>
   <select name=type_id>
    <% set rTypes = conn.execute("select * from types order by title")
    while not rTypes.eof
     %><option value=<%=rTypes("id")%> <%if rTypes("id")=r("type_id") then Response.Write " selected "%> ><%=rTypes("title")%></option><%
     rTypes.Movenext
    wend %>
   </select>
  </td>
 </tr>
<% else %>
 <input type=hidden name=type_id value="<%=r("type_id")%>">
<% end if %>

<% if rType("bit_virsraksts")=true then %>
 <tr>
  <td align=right>
   Virsraksts:
  </td>
  <td>
   <input type=text size=50 maxlength=500 name=title value="<%=r("title")%>">
  </td>
 </tr>
<% else %>
 <input type=hidden name=title value="<%=r("title")%>">
<% end if %>

<% if rType("bit_mazs_virsraksts")=true then %>
 <tr>
  <td align=right>
   Mazs virsraksts:
  </td>
  <td>
   <input type=text size=25 maxlength=200 name=small_title value="<%=r("small_title")%>">
  </td>
 </tr>
<% else %>
 <input type=hidden name=small_title value="<%=r("small_title")%>">
<% end if %>

<% if rType("bit_datums")=true then %>
 <tr>
  <td align=right>
   Datums:
  </td>
  <td>
   <input type=text size=10 maxlength=10 name=datums value="<%=DatePrint(r("datums"))%>">
  </td>
  <td>
	<input type=text size=3 maxlength=3 name=order_num value="<%=r("order_num")%>">

  </td>
 </tr>
<% else %>
 <input type=hidden name=datums value="<%=r("datums")%>">
<% end if %>
<% if rType("bit_jaunums")=true then %>
 <tr>
  <td align=right>
   Jaunums:
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=first_page_start value="<%=DatePrint(r("first_page_start"))%>">
   līdz <input type=text size=10 maxlength=10 name=first_page_end value="<%=DatePrint(r("first_page_end"))%>">
   <select name=rg>
    <option value='' <%if nullstring(r("rg")) = "" then Response.Write " selected " %>>-</option>
    <% set rg = conn.execute("select id,title from themain where parent_id = 'RAKSTGRUPAS' order by order_num")
    while not rg.eof
     %><option value=<%=rg("id")%> <%if nullstring(r("rg")) = rg("id") then Response.Write " selected " %> ><%=rg("title")%></option><%
     rg.movenext
    wend
    %>
   </select>
  </td>
 </tr>
<% else %>
   <input type=hidden size=10 maxlength=10 name=first_page_start value="<%=DatePrint(r("first_page_start"))%>">
   <input type=hidden size=10 maxlength=10 name=first_page_end value="<%=DatePrint(r("first_page_end"))%>">
<% end if %>

<% if rType("bit_banneris")=true then %>
 <tr>
  <td align=right>
   Baneris:
  </td>
  <td>
   no <input type=text size=10 maxlength=10 name=banner_start value="<%=DatePrint(r("banner_start"))%>">
   līdz <input type=text size=10 maxlength=10 name=banner_end value="<%=DatePrint(r("banner_end"))%>">
  </td>
 </tr>
<% else %>
   <input type=hidden size=10 maxlength=10 name=banner_start value="<%=DatePrint(r("banner_start"))%>">
   <input type=hidden size=10 maxlength=10 name=banner_end value="<%=DatePrint(r("banner_end"))%>">
<% end if %>

<% if rType("bit_liela_bilde")=true then %>
 <tr>
  <td align=right>
   Lielā bilde:
  </td>
  <td>
   common_images/<input type=text size=10 maxlength=50 name=liela_bilde value="<%=r("liela_bilde")%>">
   <input type=button name=poga onclick="NewCenterWindow('upload.asp?var=liela_bilde&prefix=big',300,300);return false;">
  </td>
 </tr>
<% else %>
   <input type=hidden size=10 maxlength=50 name=liela_bilde value="<%=r("liela_bilde")%>">
<% end if %>

<% if rType("bit_raksta_bilde")=true then %>
 <tr>
  <td align=right>
   Raksta bilde:
  </td>
  <td>
   common_images/<input type=text size=10 maxlength=50 name=picture value="<%=r("picture")%>">
   <input type=button name=poga onclick="NewCenterWindow('upload.asp?var=picture&prefix=pic',300,300);return false;">
  </td>
 </tr>
<% else %>
   <input type=hidden size=10 maxlength=50 name=picture value="<%=r("picture")%>">
<% end if %>

<% if rType("bit_ievads")=true then %>
 <tr>
  <td align=right>
   Ievads:
  </td>
  <td>
   <textarea name=ievads cols=50 rows=5><%=conn.execute("select ievads from theMain where id = '"+cstr(id)+"'")(0)%></textarea>
   <input type=button name=poga onclick="NewCenterWindow('edit.asp?var=forma.ievads',900,600);return false;">
  </td>
 </tr>
<% else %>
   <input type=hidden name=ievads value="<%=conn.execute("select ievads from theMain where id = '"+cstr(id)+"'")(0)%>">
<% end if %>

<% if rType("bit_teksts")=true then %>
 <tr>
  <td align=right>
   Teksts:
  </td>
  <td>
   <textarea name=text cols=50 rows=10><%=conn.execute("select text from theMain where id = '"+cstr(id)+"'")(0)%></textarea>
   <input type=button name=poga onclick="NewCenterWindow('edit.asp?var=forma.text',900,600);return false;">
  </td>
 </tr>
<% else %>
   <input type=hidden name=text value="<%=conn.execute("select text from theMain where id = '"+cstr(id)+"'")(0)%>">
<% end if %>
 
<% if rType("bit_url")=true then %>
 <tr>
  <td align=right>
   URL:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=url value="<%=r("url")%>">
  </td>
 </tr>
<% else %>
   <input type=hidden name=url value="<%=r("url")%>">
<% end if %>

<% if rType("bit_saistitie_raksti")=true then %>
 <tr>
  <td align=right>
   Saistītie raksti:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=skatit value="<%=r("skatit")%>"> Rakstu ID atdalīti ar |
  </td>
 </tr>
<% else %>
   <input type=hidden name=skatit value="<%=r("skatit")%>">
<% end if %>

<% if rType("bit_efekts")=true then %>
 <tr>
  <td align=right>
   Efekts:
  </td>
  <td>
   <textarea name=efekts cols=50 rows=2><%=conn.execute("select efekts from theMain where id = '"+cstr(id)+"'")(0)%></textarea>
  </td>
 </tr>
<% else %>
   <input type=hidden name=efekts value="<%=conn.execute("select efekts from theMain where id = '"+cstr(id)+"'")(0)%>">
<% end if %>

<% if rType("bit_carters")=true then %>
 <tr>
  <td align=right>
   Čarters:
  </td>
  <td>
   <select name=charter>
    <option value=0>-</option>
    <% set rC = conn.execute("select * from marsruti where id in (select marsruts from kat_marsruti where kategorija = 'CHARTERS') order by nosaukums")
    while not rC.eof
     %><option value=<%=rC("id")%> <%if rC("id")=r("charter") then Response.Write " selected " %>><%=rC("nosaukums")%></option><% '+" - "+rc("chartergroup")
     rC.MoveNext
    wend
    %>
   </select>
  </td>
 </tr>
<% else %>
   <input type=hidden name=charter value="<%=r("charter")%>">
<% end if %>

<% if rType("bit_grupas")=true then %>
 <tr>
  <td align=right>
   Grupas:
  </td>
  <td>
   <select name=grupa>
    <option value=0>-</option>
    <% set rC = conn.execute("select * from grupas where cena in (select id from cenas where marsruts = '"+cstr(getnum(r("charter")))+"')")
    while not rC.eof
     %><option value=<%=rC("id")%> <%if rC("id")=r("grupa") then Response.Write " selected " %>><%=dateprint(rC("no"))+" - "+dateprint(rc("lidz"))%></option><%
     rC.MoveNext
    wend
    %>
   </select>
  </td>
 </tr>
<% else %>
   <input type=hidden name=grupa value="<%=r("grupa")%>">
<% end if %>



<% if rType("bit_marsruti")=true then %>
 <tr>
  <td align=right>
   Maršruti:
  </td>
  <td>
   <table><tr>
    <td>
     <% set rM = conn.execute("select id,nosaukums from marsruti where (id in (select marsruts from geo_marsruti) and not id in (select marsruts from main_marsruti where main = '"+id+"')) order by nosaukums")  %>
     <select name=marsruti_free size=5>
      <%
       while not rM.eof
        %><option value=<%=rM("id")%>><%=rM("nosaukums")%></option><%
        rM.movenext
       wend
      %>
     </select><br>
     <input type=submit name=poga value="Pievienot maršrutu">
    </td></tr>
    <tr><td>
     <% set rM = conn.execute("select id,nosaukums from marsruti where id in (select marsruts from main_marsruti where main = '"+r("id")+"') order by nosaukums")  %>
     <select name=marsruti_used size=5>
      <%
       while not rM.eof
        %><option value=<%=rM("id")%>><%=rM("nosaukums")%></option><%
        rM.movenext
       wend
      %>
     </select><br>
     <input type=submit name=poga value="Atslēgt maršrutu">
    </td>
   </tr></table>
  </td>
 </tr>
<% end if %>

<% if rType("bit_cena")=true then %>
 <tr>
  <td align=right>
   Cena (teksts):
  </td>
  <td>
   <input type=text size=10 maxlength=50 name=cena_txt value="<%=r("cena_txt")%>">
  </td>
 </tr>
<% else %>
   <input type=hidden name=cena_txt value="<%=r("cena_txt")%>">
<% end if %>
 
 <input type=hidden name=back value="0">
 <input type=hidden name=marker value="<%=marker%>">
 
 
 <tr>
  <td></td>
  <td align=center>
   <a href=Saglabāt onclick="BreakItUp();forma.submit();return false;">Saglabāt</a> |
   <a href=Saglabāt onclick="BreakItUp();forma.back.value='1';forma.submit();return false;">Saglabāt un iziet</a> |
   <a href="main.asp?parent=<%=rParent(0)%>&marker=<%=marker%>">Atcelt</a>
  </td>
  <td></td>
 </tr>

</table>
