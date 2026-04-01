<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

vid = request.querystring("vid")

set rec = server.createobject("ADODB.Recordset")
rec.open "Select gid from viesnicas_veidi where id in (select veids from viesnicas where id = "+cstr(vid)+")",conn,3,3
gid = cstr(rec("gid"))
Del_Viesnica(vid)
response.redirect ("viesnicas.asp?gid="+gid)
%>


