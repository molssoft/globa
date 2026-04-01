<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%

dim PerPage
PerPage = 20

dim page
page = cint(request.querystring("page"))
if page = 0 then page = 1

dim id
dim query
dim notempty
dim headings(10)

dim conn
OpenConn

query = session("dquery")
set r = server.createobject("ADODB.Recordset")
r.open query+ " order by dbo.fn_str_to_num(ltrim(uzvards)),dbo.fn_str_to_num(ltrim(vards)),dbo.fn_str_to_num(ltrim(nosaukums)) ",conn,3,3
skaits = r.recordcount

if session("dalibn_sar_mode") = "new" then
  if skaits-int(skaits/10)*10 = 1 then
    Title = "Datubâzç jau eksistç "+CStr(skaits)+" lîdzîgs dalîbnieks"
  else
    Title = "Datubâzç jau eksistç "+CStr(skaits)+" lîdzîgi dalîbnieki"
  end if
else
  if skaits-int(skaits/10)*10 = 1 then
    Title = "Atrasts "+CStr(skaits)+" dalîbnieks"
  else
    Title = "Atrasti "+CStr(skaits)+" dalîbnieki"
  end if
end if

%>

<%docstart "Dalibnieku saraksts","y1.jpg"%>
<center><font color="GREEN" size="5"><b><%=Title%></b></font><hr>
<%headlinks%><br>
<form name=forma action="dalibn_join.asp" method=POST>

<table border='0' bgcolor=white>
<tr bgcolor = #ffc1cc>
 <td></td>
 <td>Vârds</td>
 <td>Uzvârds</td>
 <td>Nosaukums</td>
 <td>Pers.k.</td>
 <td>Pilsçta</td>
 <td>Adrese</td>
 <td></td>
</tr>
<%
r.pagesize = PerPage
r.absolutepage = page
i = 1
while not r.eof and i<=PerPage+1
 if i>PerPage then %>
  <tr  bgcolor = #fff8dd >
 <% else %>
  <tr  bgcolor = #fff1cc >
 <% end if %>
 <td><a href = 'dalibn.asp?i=<%=r("id")%>'><img src='impro/bildes/k_zals.gif'></a></td>
 <td><%=r("vards")%></td>
 <td><%=r("uzvards")%></td>
 <td><%=r("nosaukums")%></td>
 <td><%=r(3)%></td>
 <td><%=r("pilseta")%></td>
 <td><%=r("adrese")%></td>
 <td><input type=hidden name="hid<%=r("id")%>" value="did<%=r("id")%>"><input type=checkbox name="ch<%=r("id")%>" onclick="join.style.visibility='visible';join.style.display='block';"></td>
 </tr>
 <%
 i = i + 1
 r.movenext
wend
%>
</table>

<% 
for i = 1 to r.pagecount 
 if i<>page then
  %><a href='dalibn_sar.asp?page=<%=i%>'>[<%=i%>]</a><%
 else
  %><b>[<%=i%>]</b><%
 end if
next 
%>

<%
if session("dalibn_sar_mode") = "new" then
  %><form action="dalibn_add.asp"><input type=submit value="Pievienot jaunu dalibnieku: <%=session("dalibn_desc")%>"><%
end if
%>

<div id="join" style="position:relative; visibility: hidden; display:none">
<select name="jointo">
 <%=DalHistory%>
</select>
<input type=submit value="Apvienot">
</form>
</div>
</body>
</html>
