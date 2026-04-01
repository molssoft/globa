<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
id = request.querystring("id")
set rm = conn.execute ("select * from marsruti where id = "+cstr(id))
%>

<html>
<head><title>Marðruts</title></head>
<body>
<center>  
<font size=6><a href="mgrupa.asp?id=<%=rm("mgrupa")%>">Marðruts</a>:<%=rm("nosaukums")%></font>
<hr>
<form name=forma1 method=post action=save_marsruts.asp>
<table>
 <tr>
  <td>Nosaukums:</td>
  <td><input size=40 type=text name=nosaukums value="<%=nullprint(rm("nosaukums"))%>">
    <input size=7 type=text name=mgrupa value="<%=nullprint(rm("mgrupa"))%>"></td>
 </tr>
 <tr>
  <td>Meklçðana:</td>
  <td><input size=54 type=text name=key value="<%=nullprint(rm("key"))%>"></td>
  </tr>
 <tr>
  <td>Apraksts:</td>
  <td><textarea cols=40 rows = 10 name=apraksts><%=nullprint(rm("apraksts"))%></textarea></td>
 </tr>
 <tr>
  <td colspan=2 align=center>
   Jauns<input type=checkbox name="jauns" <%if rm("jauns") then response.write "checked"%> >|
   Izstâde<input type=checkbox name="izstade" <%if rm("izstade") then response.write "checked"%> >|
   Sports<input type=checkbox name="sports" <%if rm("sports") then response.write "checked"%> >|
   Kultûra<input type=checkbox name="kultura" <%if rm("kultura") then response.write "checked"%> >|
   Cope<input type=checkbox name="cope" <%if rm("cope") then response.write "checked"%> >|
   Slçpoðana<input type=checkbox name="sleposana" <%if rm("sleposana") then response.write "checked"%> ><br>
   Kalni<input type=checkbox name="kalni" <%if rm("kalni") then response.write "checked"%> >|
   Ziema<input type=checkbox name="ziema" <%if rm("ziema") then response.write "checked"%> >|
   Nometne<input type=checkbox name="nometne" <%if rm("nometne") then response.write "checked"%> >|
   Eksotika<input type=checkbox name="eksotika" <%if rm("eksotika") then response.write "checked"%> >|
   Atpûta<input type=checkbox name="atputa" <%if rm("atputa") then response.write "checked"%> >
  </td>
 </tr>
</table>
<input type=submit value="Dzçst" onclick="if (confirm('Vai vçlaties dzçst marðrutu')) {forma1.action='del_marsruts.asp'; return true;} else return false;">
<input type=submit value="Saglabât">
<input type=hidden name=id value=<%=id%>>
</form>

<form name=forma2 method=post action=save_cena.asp>
<table border = 1>
 <tr>
  <th>Cena Ls</th>
  <th>Cena (teksts)</th>
  <th>Laiks</th>
  <th>Naktsmîtnes</th>
 </tr>
 
 <% set rc = conn.execute ("select * from cenas where marsruts = "+cstr(id)+" order by cena")
 while not rc.eof %>
  <tr>
   <td><input size=5 type=text name="cena<%=rc("id")%>" value="<%=rc("cena")%>"></td>
   <td><input size=20 type=text name="cena_txt<%=rc("id")%>" value="<%=rc("cena_txt")%>"></td>
   <td>
    <% set rg=conn.execute("select * from grupas where cena = "+cstr(rc("id"))+" order by [no]")
    while not rg.eof
     response.write printdate(rg("no"))+"-"+printdate(rg("lidz"))+"<br>"
     rg.movenext
    wend
    %>
    <a href=grupas.asp?cena_id=<%=rc("id")%>>Labot laikus</a>
   </td>
   <td>
    <% set rm=conn.execute("select * from majas where cena = "+cstr(rc("id")))
    while not rm.eof
     set rb = conn.execute("select * from bildes where id = " +cstr(rm("bilde")))
     %><img src = "<%=rb("cels")%>"><%=rm("apraksts")%><br><%
     rm.movenext
    wend
    %>
    <a href=majas.asp?id=<%=rc("id")%>>Labot naksmâjas</a></td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst cenu?')) {forma2.action='del_cena.asp';forma2.cena_id.value=<%=rc("id")%>;return true;} else return false;" value="-">
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
