<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

order = request.form("order")
if order = "" then order = "datums_labots,id"

subm = request.form("subm")

if  subm<>"" then
 kurators = request.form("kurators")
 rajons = request.form("rajons")
 datums_no = Request.Form("datums_no")
 datums_lidz = Request.Form("datums_lidz")
 teksts = Request.Form("teksts")
 subm = request.form("subm")
else
 
end if
page_size = 30
if p="" then p = 1

docstart "Pasûtîjuma grupu pieteikumi","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Pasûtîjuma grupu pieteikumi</b></font>
<form name=forma method=POST>
<hr>
<% 
headlinks 
IF SESSION("MESSAGE") <> "" THEN RESPONSE.WRITE "<FONT COLOR = RED SIZE = 4>" + SESSION("MESSAGE") + "</FONT>"
session("message") = ""

%>
<br>
<table>
 <tr>
  <th align=right>Sâkuma datums</th>
  <td><input type=text size=10 name=datums_no value="<%=datums_no%>"></td>
 </tr>
 <tr>
  <th align=right>Beigu datums</th>
  <td><input type=text size=10 name=datums_lidz value="<%=datums_lidz%>"></td>
 </tr>
 <tr>
  <th align=right>Kurators</th>
  <td>
   <select name=kurators>
    <option value="">Visi</option>
    <% set rKurators = conn.execute("select id,isnull(vards,'')+' '+isnull(uzvards,'') as v from lietotaji where id in (select lietotajsID from tiesibusaites where tiesibasID = 12) order by vards") %>
    <% while not rKurators.eof %>
     <option value=<%=rKurators("id")%> <%if cstr(kurators) = cstr(rKurators("id")) then Response.Write " selected "%> ><%=rKurators("v")%></option>
     <% rKurators.movenext%>
    <% wend %>
   </select>
  </td>
 </tr>

  <tr>
   <th align=right>Rajons</th>
   <td>
    <select name=rajons>
     <option value="">Visi</option>
     <% set rRajons = conn.execute("select id,nosaukums from rajons order by nosaukums") %>
     <% while not rRajons.eof %>
      <option value=<%=rRajons("id")%> <%if cstr(rajons) = cstr(rRajons("id")) then Response.Write " selected "%> ><%=rRajons("nosaukums")%></option>
      <% rRajons.movenext%>
     <% wend %>
    </select>
   </td>
  </tr>

  <tr>
   <th align=right>Teksts</th>
   <td>
    <input type=text name=teksts value="<%=teksts%>">
   </td>
  </tr>

  <tr>
   <th align=right>Sakârtot pçc</th>
   <td>
    <select name=order>
     <option 
      <%if order="datums_izveidots,id" then response.write " selected "%>
      value="datums_izveidots,id">Datums (izveidots)</option>
     <option 
      <%if order="datums_labots,id" then response.write " selected "%> 
      value="datums_labots,id">Datums (labots)</option>
    </select>
   </td>
  </tr>

</table>
<input type=submit value="Meklçt" id=submit1 name=submit1>
<input type=hidden value="1" name=subm>
<%
if subm<>"" then

 query = "select * from grupa_pas where 1=1"
 if kurators<>"" then
  query = query + " and kurators = "+kurators
 end if
 if rajons<>"" then
  query = query + " and rajons = "+rajons
 end if
 if datums_no<>"" then
  query = query + " and datums_labots >= '"+sqldate(datums_no)+"'"
 end if
 if datums_lidz<>"" then
  query = query + " and datums_labots <= '"+sqldate(datums_lidz)+"'"
 end if
 if teksts<>"" then
  query =query + " and (kontaktpersona like N'%"+teksts+"%' or piezimes like N'%"+teksts+"%' or laiks like N'%"+teksts+"%' or vieta like N'%"+teksts+"%') " 
 end if
 query = query + " order by " + order
 'Response.Write query
 'Response.End
 set r = conn.execute(query)

 %><BR><table border=0><%
 %><tr>
  <th></td>
  <th>Veids</td>
  <th>Kurators</td>
  <th>Rajons</td>
  <th>Laiks</td>
  <th>Vieta</td>
  <th>Klients</td>
  <th>Kontaktpersona</td>
  <th>Adrese</td>
  <th>Telefons</td>
  <th>Epasts</td>
  <th>Piezîmes</td>
  <th>Izveidots</td>
  <th>Mainîts</td>
 </tr><%
 while not r.eof
  %><tr>
  	<td valign=top><a target=_new href = 'grupas_pas_edit.asp?id=<%=cstr(r("id"))%>'><img src='impro/bildes/k_zals.gif'></a>
   <td valign=top><%=r("veids")%></td>
   <td valign=top><nobr>
    <% if getnum(r("kurators"))<>"0" then %>
     <%=conn.execute("select isnull(vards,'')+isnull(uzvards,'') from lietotaji where id = "+cstr(r("kurators")))(0)%>
    <% end if %>
   </nobr></td>
   <td valign=top><nobr>
    <% if getnum(r("rajons"))<>"0" then %>
      <%=conn.execute("select nosaukums from rajons where id = "+cstr(r("rajons")))(0)%>
    <% end if %>
   </nobr></td>
   <td valign=top><%=r("laiks")%></td>
   <td valign=top><%=r("vieta")%></td>
   <td valign=top><%=r("klients")%></td>
   <td valign=top><%=r("kontaktpersona")%></td>
   <td valign=top><%=r("adrese")%></td>
   <td valign=top><%=r("telefons")%></td>
   <td valign=top><%=r("epasts")%></td>
   <td valign=top><%=r("piezimes")%></td>
   <td valign=top><nobr><%=dateprint(r("datums_izveidots"))%></nobr></td>
   <td valign=top><nobr><%=dateprint(r("datums_labots"))%></nobr></td>
  </tr><%
  r.movenext
 wend
 %></table>
<% end if 'if subm<>""%>
</form>
<br><a target=_new href="grupas_pas_add.asp"><img border=0 src="impro/bildes/pievienot.jpg"></a>