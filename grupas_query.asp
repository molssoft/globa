<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->
<%
dim conn
OpenConn


docstart "Grupu saraksts","y1.jpg" %>


<p align="center"><font color="#008000" size="5"><b>Grupu saraksts</b></font></p>

<center>
<table>
<%
 nosacijums = "(1=1 "
 if Request.QueryString("kods") <> "" then
  nosacijums = nosacijums + " and kods like '__."+Request.querystring("kods")+"%'"
 end if
 if Request.QueryString("no") <> "" then
  nosacijums = nosacijums + " and beigu_dat >= '"+Request.QueryString("no")+"'"
 end if
 if Request.QueryString("no") <> "" then
  nosacijums = nosacijums + " and beigu_dat < '"+Request.QueryString("lidz")+"'"
 end if
 if Request.QueryString("dienas") <> "" then
  nosacijums = nosacijums + " and sakuma_dat=beigu_dat"
 end if
 nosacijums = nosacijums + ")"

 set r = conn.execute("select * from grupa,marsruts where "+nosacijums+" and grupa.mid = marsruts.id")
 while not r.eof
  %><tr><%
   %><td><%=r("kods")%></td><%
   %><td><%=dateprint(r("sakuma_dat"))%></td><%
   %><td><%=dateprint(r("beigu_dat"))%></td><%
   %><td><%=r("v")%></td><%
  %></tr><%
  r.movenext
 wend
%>
</table>