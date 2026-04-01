<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
gid = getNum(Request.QueryString("gid"))
skaits = request.form("skaits"+cstr(id))
session("message") = ""

if session("message") = "" then conn.execute  "update limits set skaits = " + cstr(skaits) + " WHERE ID in (select limits from grupu_limiti where id = "+cstr(id)+")"
response.redirect "limits.asp?gid="+gid
%>


