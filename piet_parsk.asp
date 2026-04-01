<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
session("parsk") = request.querystring("op")
session("parsk_first") = session("LastPid")
response.redirect "dalibn.asp?i="+Request.QueryString("did")
%>


