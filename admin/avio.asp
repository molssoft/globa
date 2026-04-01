<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn
%>

<html>
<head><title>Avio biïetes</title></head>


<body>
<center>  
<font size=6>Avio biïetes</font><br>
<% top_links %>
<hr>

<form name="forma2" method=post action="save_avio.asp">
<table>
 <tr>
  <td>Galapunkts</td>
  <td>Cena</td>
  <td>Kompânija</td>
  <td>Spec.<br>pied.</td>
  <td>Spec. p. teksts</td>
  <td>Cena</td>
  <td>Kontinents</td>
  <td></td>
 </tr>
 <% set rmg = conn.execute ("select * from lidm_bil order by galapunkts")
 while not rmg.eof
  %>
  <tr>
   <td><input type=text name=Galapunkts<%=rmg("id")%> value="<%=rmg("galapunkts")%>" size = 20></td>
   <td><input type=text name=cena_txt<%=rmg("id")%> value="<%=rmg("cena_txt")%>" size = 10></td>
   <td><input type=text name=kompanija<%=rmg("id")%> value="<%=rmg("kompanija")%>" size = 20></td>
   <td align=center><input type=checkbox name=specpied<%=rmg("id")%> <%if rmg("specpied") then response.write " checked " %>></td>
   <td><textarea name=spec_text<%=rmg("id")%> rows=3 cols = 30><%=rmg("spec_text")%></textarea></td>
   <td><input type=text name=cena<%=rmg("id")%> value="<%=rmg("cena")%>" size = 10></td>
   <td><select name=kontinents<%=rmg("id")%>>
    <option value="" ></option>
    <option value="afr" <%if nullprint(rmg("kontinents"))="afr" then response.write "selected"%> >Âfrika</option>
    <option value="ame" <%if nullprint(rmg("kontinents"))="ame" then response.write "selected"%> >Amerika</option>
    <option value="aus" <%if nullprint(rmg("kontinents"))="aus" then response.write "selected"%> >Austrâlija</option>
    <option value="azi" <%if nullprint(rmg("kontinents"))="azi" then response.write "selected"%> >Âzija</option>
    <option value="eir" <%if nullprint(rmg("kontinents"))="eir" then response.write "selected"%> >Eiropa</option>
   </select>
   </td>
   <td>
    <input type=submit onclick="if (confirm('Vai vçlaties dzçst marðrutu grupu?')) {forma2.action='del_avio.asp';forma2.id.value='<%=rmg("id")%>';return true;} else return false;" value="-">
    <input type=submit onclick="forma2.id.value='<%=rmg("id")%>';forma2.action='save_avio.asp';" value="S">
   </td>
  </tr>
  <%
  rmg.movenext
 wend %>
 <tr>
   <td><input type=text name=add_Galapunkts size = 20></td>
   <td><input type=text name=add_cena_txt size=10></td>
   <td><input type=text name=add_kompanija size=20></td>
   <td><input type=checkbox name=add_specpied></td>
   <td><textarea name=add_spec_text rows=3 cols = 30></textarea></td>
   <td><input type=text name=add_cena size = 10></td>
   <td><select name=add_kontinents>
    <option value="" ></option>
    <option value="afr" >Âfrika</option>
    <option value="ame" >Amerika</option>
    <option value="aus" >Austrâlija</option>
    <option value="azi" >Âzija</option>
    <option value="eir" >Eiropa</option>
   </td></select>
   <td colspan=2><input type=submit onclick="forma2.action='add_avio.asp'" value="+"></td>
 </tr>
</table>
<input type=hidden name=id value=0>
</form>
</body>