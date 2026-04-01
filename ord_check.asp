<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim did(200)
dim dsk
dim conn
openconn
vid = request.form("valuta")
poga = request.form("poga")
if poga = "Reìistrçt" then
set valu = server.createobject("ADODB.Recordset")
valu.open "select * from valuta where id" = vid,conn,3,3
if dateprint(valu("datums")) = dateprint(now) then redirect

</body>
</html>
