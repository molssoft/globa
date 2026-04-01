<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'--- izveido balles pieteikumu -----------------------------------------------

dim conn
openconn

id = Request.querystring("id")


conn.execute("delete from balle where id = "+CStr(id))

Response.redirect "balle.asp"
	
%>