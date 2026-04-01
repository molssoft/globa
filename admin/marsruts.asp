<!-- #include file = "conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
id = request.querystring("id")
query = "select id,mgrupa,nosaukums,apraksts,[key],pdf,pdf_desc,dienas,izbrauc,chartergroup,skatit,spec,galva from marsruti where id = "+cstr(id)
set rm = conn.execute (query)
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Maršruts</title>
</head>

<script LANGUAGE="JavaScript">
<!--hide
function NewCenterWindow(url,w,h)
{
window.open(url,'pass', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes, resizable=no,copyhistory=no,width='+w+',height='+h+',top='+(screen.height/2-h/2)+',left='+(screen.width/2-w/2));
}
//-->
</script>

<body>
<center>  
<font size=6><a href="default.asp">Maršruts</a>:<%=rm("nosaukums")%></font>
<hr>
<form name=forma1 method=post action=save_marsruts.asp>
<table>
 <tr>
  <td>Nosaukums:</td>
  <td>
   <input size=40 type=text name=nosaukums value="<%=nullprint(rm("nosaukums"))%>"></td>
  </td>
 </tr>
 <tr>
  <td>PDF:</td>
  <td>
   <input size=20 type=text name=pdf value="<%=nullprint(rm("pdf"))%>"> PDF failu nosaukumi atdalīti ar |
  </td>
 </tr>
 <tr>
  <td>PDF links</td>
  <td>
   <input size=20 type=text name=pdf_desc value="<%=nullprint(rm("pdf_desc"))%>"> PDF failu redzamie linki atdalīti ar |
  </td>
 </tr>
 <tr>
  <td>Bilde (galva)</td>
  <td>
   <input size=20 type=text name=galva value="<%=nullprint(rm("galva"))%>">
  </td>
 </tr>
 <tr>
  <td>Saistītie raksti</td>
  <td>
   <%
    spec = ""
    set rSpec = conn.execute("select * from main_marsruti where marsruts = "+cstr(rm("id"))+" order by main")
    while not rSpec.eof
     spec = spec + trim(rspec("main")) + "|"
     rspec.movenext
    wend
    if spec<>"" then spec = mid(spec,1,len(spec)-1)
   %>
   <input size=20 type=text name=skatit value="<%=spec%><%=nullprint(rm("skatit"))%>"> Rakstu ID atdalīti ar |
  </td>
 </tr>
 <tr>
  <td>Speciālie piedāvājumi</td>
  <td>
   <input size=20 type=text name=spec value="<%=nullprint(rm("spec"))%>"> Viena raksta ID
  </td>
 </tr>
 <% 
  if not conn.execute("select * from kat_marsruti where kategorija = 'CHARTERS' and marsruts = "+cstr(rm("id"))).eof then 
  chartergroup = conn.execute("select chartergroup from marsruti where id = "+cstr(id))(0)
 %>
 <tr>
  <td>Čarteru grupa:</td>
   <td>
    <select name=chartergroup>
     <option value=''>-</option>
     <% set rChGr = conn.execute("select id,title from theMain where type_id = 'CARTERLIST' or type_id = 'CARTERDATE' order by title")
     while not rChGr.eof
      %><option value=<%=rChGr("id")%> <%if chartergroup=rChGr("id") then Response.Write " selected " %> ><%=rChGr("title")%></option><%
      rChGr.movenext
     wend %>
    </select>
   </td>
 </tr>
 <% end if 
 set rm = conn.execute (query)
 %>
 <tr>
  <td>Dienas:</td>
  <td>
   <input size=10 type=text name=dienas value="<%=rm("dienas")%>">
  </td>
 </tr>
 <tr>
  <td>Izbraukšana (ja nav grupu):</td>
  <td>
   <input size=54 type=text name=izbrauc value="<%=rm("izbrauc")%>">
  </td>
 </tr>
<% set rm = conn.execute (query) %>
 <tr>
  <td>Meklēšana:</td>
  <td><input size=54 type=text name=key value="<%=nullprint(rm("key"))%>"></td>
  </tr>
 <tr>
  <td>Apraksts:</td>
  <td>
   <textarea cols=40 rows = 10 name=apraksts><%=conn.execute("select apraksts from marsruti where id = "+cstr(id))(0)%></textarea>
   <input type=button name=poga onclick="NewCenterWindow('edit.asp?var=forma1.apraksts',800,600);return false;">
  </td>
 </tr>
 <tr>
  <td colspan=2 align=center>
  </td>
 </tr>
</table>
<input type=submit value="Dzēst" onclick="if (confirm('Vai vēlaties dzēst maršrutu')) {forma1.action='del_marsruts.asp'; return true;} else return false;">
<input type=submit value="Saglabāt">
<input type=hidden name=id value=<%=id%>>
</form>

<a name=#intereses>Intereses<br>
<table border = 1>
 <tr>
  <td>Piesaistītās</td>
  <td>Pārējās</td>
 </tr>
 <tr>
  <td>
   <%
    set rTemas=conn.execute("select * from temas where id in (select tema from temas_marsruti where marsruts = "+cstr(id)+") order by nosaukums")
    while not rTemas.eof
     %><a href="marsruts_del_tema.asp?m=<%=id%>&t=<%=rTemas("id")%>"><%=rTemas("nosaukums")%></a><%=" | "%><%
     rTemas.movenext
    wend
   %>
  </td>
  <td>
   <%
    set rTemas=conn.execute("select * from temas where not id in (select tema from temas_marsruti where marsruts = "+cstr(id)+") order by nosaukums")
    while not rTemas.eof
     %><a href="marsruts_add_tema.asp?m=<%=id%>&t=<%=rTemas("id")%>"><%=rTemas("nosaukums")%></a><%=" | "%><%
     rTemas.movenext
    wend
   %>
  </td>
</table>

<br><a name=#intereses>Kategorijas<br>
<table border = 1>
 <tr>
  <td>Piesaistītās</td>
  <td>Pārējās</td>
 </tr>
 <tr>
  <td>
   <%
    set rKat=conn.execute("select * from kategorijas where id in (select kategorija from kat_marsruti where marsruts = "+cstr(id)+") order by nosaukums")
    while not rKat.eof
     %><a href="marsruts_del_kat.asp?m=<%=id%>&t=<%=rKat("id")%>"><%=rKat("nosaukums")%></a><%=" | "%><%
     rKat.movenext
    wend
   %>
  </td>
  <td>
   <%
    set rKat=conn.execute("select * from kategorijas where not id in (select kategorija from kat_marsruti where marsruts = "+cstr(id)+") order by nosaukums")
    while not rKat.eof
     %><a href="marsruts_add_kat.asp?m=<%=id%>&t=<%=rKat("id")%>"><%=rKat("nosaukums")%></a><%=" | "%><%
     rKat.movenext
    wend
   %>
  </td>
</table>

<br><a name=#intereses>Valstis<br>
<table border = 1>
 <tr>
  <td>Piesaistītās</td>
  <td>Pārējās</td>
 </tr>
 <tr>
  <td>
   <%
    set rValstis=conn.execute("select * from geo where id in (select geo from geo_marsruti where marsruts = "+cstr(id)+") order by title")
    while not rValstis.eof
     %><a href="marsruts_del_geo.asp?m=<%=id%>&g=<%=rValstis("id")%>"><%=rValstis("title")%></a><%=" | "%><%
     rValstis.movenext
    wend
   %>
  </td>
  <td>
   <%
    set rValstis=conn.execute("select * from geo where id not in (select geo from geo_marsruti where marsruts = "+cstr(id)+") and (type_id = 'V' or type_id = 'D') order by title")
    while not rValstis.eof
     %><a href="marsruts_add_geo.asp?m=<%=id%>&g=<%=rValstis("id")%>"><%=rValstis("Title")%></a><%=" | "%><%
     rValstis.movenext
    wend
   %>
  </td>
</table>


<form name=forma2 method=post action=save_cena.asp>
Grupas
<table border = 1>
 <tr>
  <td>Cena Ls</td>
  <td>Cena (teksts)</td>
  <td>Laiks</td>
  <td>Naktsmītnes</td>
  <td> &nbsp; </td>
 </tr>
 
 <% set rc = conn.execute ("select * from cenas where marsruts = "+cstr(id)+" order by id")
 while not rc.eof %>
  <tr>
   <td><input size=5 type=text name="cena<%=rc("id")%>" value="<%=rc("cena")%>"></td>
   <td><input size=20 type=text name="cena_txt<%=rc("id")%>" value="<%=rc("cena_txt")%>"></td>
   <td>
    <% set rg=conn.execute("select * from grupas where cena = "+cstr(rc("id"))+" order by [no]")
    while not rg.eof
     response.write printdate(rg("no"))+"-"+printdate(rg("lidz"))+" - "+cstr(rg("gr_kods"))+"<br>"
     rg.movenext
    wend
    %>
    <a href=grupas.asp?cena_id=<%=rc("id")%>>Labot laikus</a>
   </td>
   <td>
    <% set rm=conn.execute("select * from majas where cena = "+cstr(rc("id")))
    while not rm.eof
     set rb = conn.execute("select * from bildes where id = " +cstr(rm("bilde")))
     %><img src = "http://www.impro.lv/<%=rb("cels")%>"><%=conn.execute("select apraksts from majas where id = "+cstr(rm("id")))(0)%><br><%
     rm.movenext
    wend
    %>
    <a href=majas.asp?id=<%=rc("id")%>>Labot naksmājas</a></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vēlaties dzēst cenu?')) {forma2.action='del_cena.asp';forma2.cena_id.value=<%=rc("id")%>;return true;} else return false;" value="-">
    <input type=submit onclick="forma2.cena_id.value=<%=rc("id")%>;forma2.action='save_cena.asp';" value="S">
   </td>
  </tr>
  <% rc.movenext
 wend %>

 <tr>
  <td><input type=text size=5 name=cena></td>
  <td><input type=text size=20 name=cena_txt></td>
  <td>...</td>
  <td>...</td>
  <td><input type=submit onclick="forma2.action='add_cena.asp'" value="+"></td>
 </tr>
</table>
<input type=hidden name=id value=<%=id%>>
<input type=hidden name=cena_id value=0>
</form>
