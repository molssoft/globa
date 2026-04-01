<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
docstart "Juridisko klientu meklçðana","y1.jpg"
%>

<center><font color="GREEN" size="5"><b>Juridisko klientu meklçðana</b></font><hr>

<form name=forma>

<table border=0>
<tr>
 <td>
  Nosaukums:
 </td>
 <td>
  <input type=text name=nosaukums size=20 value="<%=Request.QueryString("nosaukums")%>">
 </td>
</tr>
<tr>
 <td align=right>
  Vârds:
 </td>
 <td>
  <input type=text name=vards size=20 value="<%=Request.QueryString("vards")%>">
 </td>
</tr>
<tr>
 <td align=right>
  Uzvârds:
 </td>
 <td>
  <input type=text name=uzvards size=20 value="<%=Request.QueryString("uzvards")%>">
 </td>
</tr>
</table>
<input type=submit value=Meklçt name=poga>
<input type=hidden value=<%=Request.QueryString("return_id")%> name=return_id>
<input type=hidden value=<%=Request.QueryString("return_name")%> name=return_name>
<input type=hidden value=1 name=subm>


<%
if Request.QueryString("subm")="1" then
  set r = server.CreateObject("adodb.recordset")
  query = "select * from dalibn where deleted = 0 "
  if Request.QueryString("vards")<>"" then
   query = query + " and vards like '%"+Request.QueryString("vards")+"%'"
  end if
  if Request.QueryString("nosaukums")<>"" then
   query = query + " and nosaukums like '%"+Request.QueryString("nosaukums")+"%'"
  end if
  if Request.QueryString("uzvards")<>"" then
   query = query + " and uzvards like '%"+Request.QueryString("uzvards")+"%'"
  end if
  query = query + " order by vards,uzvards,nosaukums "
  r.Open query,conn,3,3
  if not r.EOF then
   %><br><br>Atrasts:<br><table border=0 border=0><%
   while not r.EOF
     %>
     <tr><td>
      <input type=hidden name=d<%=r("id")%> 
       value='<a target="_blank" href="dalibn.asp?i=<%=r("id")%>"><%=replace(nullprint(r("nosaukums"))+" "+nullprint(r("vards"))+" "+nullprint(r("uzvards")),"'","''")%></a>'>
         <b><%=nullprint(r("nosaukums"))+" "+nullprint(r("vards"))+" "+nullprint(r("uzvards"))%></td>
       <td><a href=dalibn.asp?i=<%=r("id")%>>Apskatît</a></td>
       <td><a href=return onclick="opener.<%=Request.QueryString("return_id")%>.value='<%=r("id")%>';opener.<%=Request.QueryString("return_name")%>.innerHTML=forma.d<%=r("id")%>.value;window.close();return false;">
         Ievietot</td>
       </a>
     </td></tr><%
     Response.Write chr(13)+chr(10)
     r.MoveNext
   wend
   %></table><%
  else
   response.write "<BR>Nav atrasts."
  end if
end if

%>
</form>
<br><br>
<a href=dalibn.asp?return=1>Izveidot jaunu vai meklçt detalizçtâk</a>
</body>
</html>
