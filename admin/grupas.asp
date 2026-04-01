<!-- #include file = "conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
id = request.querystring("cena_id")
set rg = conn.execute ("select * from grupas where cena = "+cstr(id)+" order by [no]")
set rc = conn.execute ("select * from cenas where id = " + cstr(id))
%>

<head>

<meta http-equiv="Content-Language" content="lv">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Grupu izbraukšanas laiki</title>
</head>

<body>
<center>  
<font size=6><a href="marsruts.asp?id=<%=rc("marsruts")%>">Cenas grupa</a>:<%=rc("cena")%></font>
<hr>

<form name=forma2 method=post action=save_grupa.asp>
<table border = 1>
 <tr>
  <td>Izbraukšanas laiks</td>
  <td>Atbraukšanas laiks</td>
  <td>pd. cena</td>
  <td>Kods</td>
  <td>&nbsp;</td>
 </tr>
 
 <%
 while not rg.eof %>
  <tr>
   <td>
    <a name="<%=rg("id")%>">
    <input type=text size=2 name=sakuma_diena<%=rg("id")%> value=<%=day(rg("no"))%>>
    <select name=sakuma_menesis<%=rg("id")%>><%=PrintMonths(month(rg("no")))%></select>
    <input type=text size=4 name=sakuma_gads<%=rg("id")%> value=<%=year(rg("no"))%>>
   </td>
   <td>
    <input type=text size=2 name=beigu_diena<%=rg("id")%> value=<%=day(rg("lidz"))%>>
    <select name=beigu_menesis<%=rg("id")%>><option>-</option><%=PrintMonths(month(rg("lidz")))%></select>
    <input type=text size=4 name=beigu_gads<%=rg("id")%> value=<%=year(rg("lidz"))%>>
   </td>
   <td>
    <input type=text size=6 name=pm_cena<%=rg("id")%> value="<%=rg("pm_cena")%>">
   </td>
   <td>
    <input type=text size=15 name=gr_kods<%=rg("id")%> value="<%=rg("gr_kods")%>">
   </td>
   <td>
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst laikus?')) {forma2.action='del_grupa.asp';forma2.grupa_id.value=<%=rg("id")%>;return true;} else return false;" value="-">
    <input type=submit onclick="forma2.grupa_id.value=<%=rg("id")%>;forma2.action='save_grupa.asp';" value="S">
   </td>
  </tr>
  <% rg.movenext
 wend %>
 <input type=hidden name=grupa_id value=<%=rc("id")%>>
 <input type=hidden name=id value=<%=id%>>
</form>
<form name=forma3 method=post action=add_grupa.asp>
 <tr>
  <td>
   <a name="LAST">
   <input type=text size=2 name=add_sakuma_diena>
   <select name=add_sakuma_menesis>
    <option>-</option>
    <%=PrintMonths(0)%></select>
   <%=mid(cstr(year(now)),1,3)%><input type=text size=1 name=add_sakuma_gads value=<%=mid(cstr(year(now)),4,1)%>>
  </td>
  <td>
   <input type=text size=2 name=add_beigu_diena>
   <select name=add_beigu_menesis>
    <option>-</option>
    <%=PrintMonths(0)%></select>
   <%=mid(cstr(year(now)),1,3)%><input type=text size=1 name=add_beigu_gads value=<%=mid(cstr(year(now)),4,1)%>>
  </td>
  <td>
   <input type=text size=6 name=pm_cena > 
  </td>
  <td>
   <input type=text size=6 name=gr_kods > 
  </td>
  <td><input type=submit value="+"></td>
 </tr>
</table>
<input type=hidden name=grupa_id value=<%=rc("id")%>>
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=marsruts_id value=<%=rc("marsruts")%>>

</form>

<% for i = 1 to 19
Response.Write "<BR>"
next %>