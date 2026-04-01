<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
gid=Request.QueryString("gid")+""

set r = conn.execute("select isnull(count(id),0) as x from pieteikums where deleted = 0 and gid = "+cstr(gid))
if r("x")=0 then
	conn.execute("delete from grupa where id = "+cstr(gid))
	response.write "Grupa ir dzesta."
end if

%>