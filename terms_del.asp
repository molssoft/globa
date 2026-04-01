<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
OpenConn
if request.querystring("id") = "" then
	session("message") = "Nav norâdîts termiòa numurs."
	response.redirect "terms.asp"
end if
session("lastgid") = request.form("gid")
conn.execute "Delete from terms where id = "+ request.querystring("id")
response.redirect "terms.asp"
%>