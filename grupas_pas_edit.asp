<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn


'saglabâjam ierakstu
if Request.Form("id")<>"" then
 id = Request.Form("id")
 
 datums_labots = sqldateq(now)
 
 veids = "'"+Request.Form("veids")+"'"
 
 kurators = Request.Form("kurators")
 if kurators = "" then kurators = "NULL"
 
 rajons = Request.Form("rajons")
 if rajons = "" then rajons = "NULL"
 
 laiks = "'"+sqltext(Request.Form("laiks"))+"'" 

 vieta = "'"+sqltext(Request.Form("vieta"))+"'" 
 
 klients = "'"+sqltext(Request.Form("klients"))+"'" 
 
 adrese = "'"+sqltext(Request.Form("adrese"))+"'" 
 telefons = "'"+sqltext(Request.Form("telefons"))+"'" 
 epasts = "'"+sqltext(Request.Form("epasts"))+"'" 
 piezimes = "'"+sqltext(Request.Form("piezimes"))+"'" 
 
 conn.execute ("update grupa_pas set datums_labots="+datums_labots+",veids="+veids+",kurators="+kurators+",rajons="+rajons+",laiks="+laiks+",vieta="+vieta+",klients="+klients+",adrese="+adrese+",telefons="+telefons+",epasts="+epasts+",piezimes="+piezimes+" where id = " + id)
 %><body onload="window.close();"><body><%
 Response.End
end if

id = cstr(Request.QueryString("id"))
set r = conn.execute("select * from grupa_pas where id = "+id)
docstart "Labot ierakstu","y1.jpg" %>
<form name=forma method=POST>
<center><font color="GREEN" size="5"><b>Labot ierakstu</b></font>
<table border=0>

  <tr>
   <td align=right>Veids</td>
   <td>
    <select name=veids>
     <option value=P <%if r("veids") = "P" then Response.write " selected "%>>Pasûtîjuma</option>
     <option value=S <%if r("veids") = "S" then Response.write " selected "%>>Skolçnu</option>
    </select>
   </td>
  </tr>
    
  <tr>
   <td align=right>Kurators</td>
   <td>
    <select name=kurators>
     <% set rKurators = conn.execute("select id,isnull(vards,'')+' '+isnull(uzvards,'') as v from lietotaji order by vards") %>
     <% while not rKurators.eof %>
      <option value=<%=rKurators("id")%> <%if r("kurators") = rKurators("id") then Response.Write " selected "%> ><%=rKurators("v")%></option>
      <% rKurators.movenext%>
     <% wend %>
    </select>
   </td>
  </tr>

  <tr>
   <td align=right>Rajons</td>
   <td>
    <select name=rajons>
     <% set rRajons = conn.execute("select id,nosaukums from rajons order by nosaukums") %>
     <% while not rRajons.eof %>
      <option value=<%=rRajons("id")%> <%if r("rajons") = rRajons("id") then Response.Write " selected "%> ><%=rRajons("nosaukums")%></option>
      <% rRajons.movenext%>
     <% wend %>
    </select>
   </td>
  </tr>

  <tr>
   <td align=right valign=top>Brauciena laiks</td>
   <td>
    <textarea cols=30 rows=3 name="laiks"><%=r("laiks")%></textarea>
   </td>
  </tr>

  <tr>
   <td align=right valign=top>Brauciena virziens</td>
   <td>
    <textarea cols=30 rows=3 name="vieta"><%=r("vieta")%></textarea>
   </td>
  </tr>
    
  <tr>
   <td align=right valign=top>Klients</td>
   <td>
    <input type=text name="klients" value="<%=r("klients")%>" size=40>
   </td>
  </tr>
    
  <tr>
   <td align=right valign=top>Adrese</td>
   <td>
    <input type=text name="adrese" value="<%=r("adrese")%>" size=40>
   </td>
  </tr>

  <tr>
   <td align=right valign=top>Telefons</td>
   <td>
    <input type=text name="telefons" value="<%=r("telefons")%>" size=20>
   </td>
  </tr>

  <tr>
   <td align=right valign=top>Epasts</td>
   <td>
    <input type=text name="epasts" value="<%=r("epasts")%>" size=40>
   </td>
  </tr>

  <tr>
   <td align=right valign=top>Piezîmes</td>
   <td>
    <textarea cols=30 rows=3 name="piezimes"><%=r("piezimes")%></textarea>
   </td>
  </tr>
</table>
<input type=hidden name=id value=<%=id%>>
<input type=submit name=poga value="Saglabât">
<input type=submit name=poga value="Atcelt" onclick="window.close();return false;">
</form>
