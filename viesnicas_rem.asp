<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

did = request.querystring("did")
vid = request.querystring("vid")
gid = Request.QueryString("gid")
set rec = server.createobject("ADODB.Recordset")
rec.open "update piet_saite set vid = null where vid = " & vid & " AND did = " & did,conn,3,3
response.redirect ("viesnicas.asp?gid="+gid)
%>


