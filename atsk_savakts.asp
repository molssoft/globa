<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<%
dim conn
openconn
datums = Request.Form("datums")
men = Request.Form("menesis")
kods = Request.Form("kods")
gads1 = Request.Form("gads1")
gads2 = Request.Form("gads2")

docstart "Pieteikumu skaits uz datumu","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pieteikumu skaits uz datumu</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

grupa = getparameter("charter")
carter_firma = request.form("carter_firma")
%>

<form name="forma" method="POST">
 <table>
  <tr>
  	<td align="right" bgcolor="#ffc1cc">Datums</td>
  	<td bgcolor="#fff1cc">
  		<input type="text" size="2" maxlength="2" name="datums" value="<%=request.form("datums")%>"></b> 
  	</td>
  </tr>
  <tr>
  	<td align="right" bgcolor="#ffc1cc">Mçnesis</td>
  	<td bgcolor="#fff1cc">
  		<input type="text" size="2" maxlength="2" name="menesis" value="<%=request.form("menesis")%>"></b> 
  	</td>
  </tr>
  <tr>
  	<td align="right" bgcolor="#ffc1cc">Valsts kods</td>
  	<td bgcolor="#fff1cc">
  	 <% 
  	 set rKods = conn.execute("select num,globa.dbo.fn_encode_web(nosaukums) as nos from g"+cstr(year(now))+".dbo.resursi where num like '"+mid(cstr(year(now)),3)+".V._._._' order by nosaukums")
  	 %><select name=kods><%
  	 while not rkods.eof
  	  %><option value='<%=rKods("num")%>'<%
  	  if rkods("num") = kods then Response.Write " selected "
  	  %>><%=rKods("num")%>-<%=decode(rKods("nos"))%>
  	  </option><%
  	  rkods.movenext
  	 wend
  	 %><select><%
  	 %>
  	</td>
  </tr>
  <tr>
  	<td align="right" bgcolor="#ffc1cc">Divi salîdzinâmie gadi</td>
  	<td bgcolor="#fff1cc">
  		1.<input type="text" size="4" maxlength="4" name="gads1" value="<%=request.form("gads1")%>"> 
  		2.<input type="text" size="4" maxlength="4" name="gads2" value="<%=request.form("gads2")%>">
  	</td>
  </tr>
 </table>
 <br>
 <input type=submit value=Râdît name=poga>
</form>

<% if datums<>"" then %>
 <b>Par <%=gads1%>. gadu</b><br><br>
 <%
 'atlasam grupas par ðo gadu
 set rgrupas= conn.execute("select grupa.id as gid,* from grupa inner join marsruts on grupa.mid =marsruts.id where kods like '"+mid(gads1,3)+mid(kods,3)+"%' order by sakuma_dat")
 %><table border=0><%
 while not rgrupas.eof
  %><TR><TD align=right><b><%=dateprint(rgrupas("sakuma_dat"))%></b></TD><TD><%=rgrupas("v")%></TD><%
  'nosakam pieteikumu skaitu
  if dateserial(clng(gads1),clng(men),clng(datums))>rgrupas("sakuma_dat") then
   rSkaits =conn.execute ("select isnull(sum(personas),0) from pieteikums where deleted = 0 and gid = "+cstr(rgrupas("gid"))+" and datums<='"+men+"/"+datums+"/"+cstr(clng(gads1)-1)+"'")
   %><td><b><%=rskaits(0)%></b></td><%
   %><td>uz <%=dateprint(dateserial(clng(gads1)-1,clng(men),clng(datums)))%></td><%
  else
   rSkaits =conn.execute ("select isnull(sum(personas),0) from pieteikums where deleted = 0 and gid = "+cstr(rgrupas("gid"))+" and datums<='"+men+"/"+datums+"/"+gads1+"'")
   %><td><b><%=rskaits(0)%></b></td><%
   %><td>uz <%=dateprint(dateserial(clng(gads1),clng(men),clng(datums)))%></td><%
  end if
  %></tr><%
  rgrupas.movenext
 wend
 %>
 </table><br><br>
 <%if gads2<>"" then %>
  <b>Par <%=gads2%>. gadu</b><br><br>
  <%
  'atlasam grupas par ðo gadu
  set rgrupas= conn.execute("select grupa.id as gid,* from grupa inner join marsruts on grupa.mid =marsruts.id where kods like '"+mid(gads2,3)+mid(kods,3)+"%' order by sakuma_dat")
  %><table border=0><%
  while not rgrupas.eof
   %><TR><TD align=right><b><%=dateprint(rgrupas("sakuma_dat"))%></b></TD><TD><%=rgrupas("v")%></TD><%
   'nosakam pieteikumu skaitu
   if dateserial(clng(gads2),clng(men),clng(datums))>rgrupas("sakuma_dat") then
    rSkaits =conn.execute ("select isnull(sum(personas),0) from pieteikums where deleted = 0 and gid = "+cstr(rgrupas("gid"))+" and datums<='"+men+"/"+datums+"/"+cstr(clng(gads2)-1)+"'")
    %><td><b><%=rskaits(0)%></b></td><%
    %><td>uz <%=dateprint(dateserial(clng(gads2)-1,clng(men),clng(datums)))%></td><%
   else
    rSkaits =conn.execute ("select isnull(sum(personas),0) from pieteikums where deleted = 0 and gid = "+cstr(rgrupas("gid"))+" and datums<='"+men+"/"+datums+"/"+gads2+"'")
    %><td><b><%=rskaits(0)%></b></td><%
    %><td>uz <%=dateprint(dateserial(clng(gads2),clng(men),clng(datums)))%></td><%
   end if
   %></tr></table><%
   rgrupas.movenext
  wend
 %>
 </table>
<% end if %>

<% end if %>

</body>
</html>

