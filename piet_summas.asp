<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<center>
<br><br><br><br><br><br>

<%
dim conn
openconn

gid = request.querystring("gid")

set r = server.createobject("ADODB.Recordset")
r.open "select * from pieteikums where gid = " +cstr(gid),conn

if r.recordcount>150 then
 response.write "Pârâk daudz pieteikumu." 
else
 grupa_recalculate(gid)
 response.write "Summas pârrçíinâtas veiksmîgi." 
end if

%>

<br>
<br>
<a href="pieteikumi.asp?gid=<%=gid%>">Uz grupu</a>