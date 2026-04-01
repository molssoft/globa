<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

datums_no = request.form("datums_no")
datums_lidz = request.form("datums_lidz")
subm = request.form("subm")
page = request.form("page")
aizsutits = request.form("aizsutits")

if page = "" then page = 1
if aizsutits = "" then aizsutits = "0"
if subm <> 1 then
 if datums_no = "" then datums_no = "01/01/"+ cstr(year(now))
 if datums_lidz = "" then datums_lidz = dateprint(now)
end if


'--- atzîmç ka ir aizsûtîts
if aizsutits <> "0" then
  conn.execute "UPDATE dalibn set aizsutits = not aizsutits where id = " + cstr(aizsutits)
end if

docstart "Koplekso pasûtîtjumu klienti","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Komplekso pasûtîjumu klienti</b></font><hr>
<%
headlinks 
defjavasubmit



if session("message") <> "" then 
   %>
   <br><font size="4" color="red"><%=session("message")%></font><br>
   <%
   session("message") = ""
end if

DefJavaSubmit

%>
<form name = "forma" method = POST action = "dalibn_kompleks.asp">
<table border = 0>
<tr><td  bgcolor="#ffc1cc">Datums:</td>
 <td  bgcolor="#fff1cc"><input type = text name = "datums_no" value = "<%=datums_no%>" size = 8>
 - <input type = text name = "datums_lidz" value = "<%=datums_lidz%>" size = 8></td>
</tr>
<tr></tr>
</table>
<input type = submit value = "Meklçt" onclick = "forma.page.value = 1;return true;"> 
<input type = hidden name = subm value ="1">
<input type = hidden name = page value =<%=page%>>
<input type = hidden name = aizsutits value = 0>
</form>
<br>
<% if subm = 1 then %>

<%
'------------------- Atlasam vajadzigos klientus (pieteikumus)
set r = server.createobject("ADODB.Recordset")
CG = cstr(GetComplexGroup)
query = "select * from dalibn where id in (SELECT distinct dalibn.id FROM Pieteikums INNER JOIN (dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did) ON Pieteikums.id = piet_saite.pid  where (not dalibn.deleted = 1) and (not piet_saite.deleted = 1) and gid = "+CG
if datums_no <> "" then query = query + " and datums>= '" + sqldate(datums_no)+"'"
if datums_lidz <> "" then query = query + " and datums-1<= '" + sqldate(datums_lidz)+"')"
query = query + " order by nosaukums,uzvards"
r.open query,conn,3,3
r.pagesize = 20
r.absolutepage = page
%>

 <% if r.eof then %>
   Neviens pasûtîtâjs nav atrasts.
 <% else %>
   Atrasto dalîbnieku skaits: <%=r.recordcount%>.<br>
   <% if cstr(page)<>"1" then %><span onclick="forms['forma'].elements['page'].value = <%=page-1%>; TopSubmit('dalibn_kompleks.asp')" onmouseover="this.style.color = 'red'" onmouseout="this.style.color = 'black'">Iepriekðçjâ lapa</span><% end if %>
   <% for i = 1 to r.pagecount %>
   <% if cstr(i) = cstr(page) then response.write "<b>" %>
   <span onclick="forms['forma'].elements['page'].value = <%=i%>; TopSubmit('dalibn_kompleks.asp')" onmouseover="this.style.color = 'red'" onmouseout="this.style.color = 'black'"><%=i%></span></b>
   <% next %>
   <% if cstr(page)<>cstr(r.pagecount) then %><span onclick="forms['forma'].elements['page'].value = <%=page+1%>; TopSubmit('dalibn_kompleks.asp')" onmouseover="this.style.color = 'red'" onmouseout="this.style.color = 'black'">Nâkamâ lapa</span><% end if %>
 <table border = 0>
 <tr bgcolor="#ffc1cc"><td>Dalîbnieks</td><td>Tel. d.</td><td>Tel. m.</td><td>Mob. tel.</td><td>Adrese</td><td>Emails</td><td>Aizsûtîts</td></tr>
 <% for i = 1 to r.pagesize 
 if not r.eof then %>
   <tr>
   <td><a target = none href = "dalibn.asp?i=<%=r("id")%>">-<%=Nullprint(r("nosaukums"))+" "%><%=Nullprint(r("uzvards"))+" "%><%=Nullprint(r("vards"))+" "%></td>
   <td><%=Nullprint(r("talrunisd"))%></td>
   <td><%=Nullprint(r("talrunism"))%></td>
   <td><%=Nullprint(r("talrunismob"))%></td>
   <td><%=Nullprint(r("pilseta"))%> <%=Nullprint(r("adrese"))%> LV-<%=Nullprint(r("indekss"))%></td>
   <td><a href = "mailto:<%=Nullprint(r("eadr"))%>"><%=Nullprint(r("eadr"))%></a></td>

   <td><%if r("aizsutits")=true then 
     %><span onclick="forms['forma'].elements['aizsutits'].value = <%=cstr(r("id"))%>; TopSubmit('dalibn_kompleks.asp')" onmouseover="this.style.color = 'red'" onmouseout="this.style.color = 'black'">IR</span><%
   else 
     %><span onclick="forms['forma'].elements['aizsutits'].value = <%=cstr(r("id"))%>; TopSubmit('dalibn_kompleks.asp')" onmouseover="this.style.color = 'red'" onmouseout="this.style.color = 'black'">NAV</span><%
   end if
   %></td></tr>

 <% r.movenext
 end if
 next %>
 </table>

 <% end if '---   if r.eof %>
<% end if   '---- if subm = 1 %>