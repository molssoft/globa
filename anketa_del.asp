<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
OpenConn
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if

id = Request.QueryString("id")
gid = Request.QueryString("gid")
conn.execute "delete from anketas where id = "+cstr(id)
Response.Redirect "c_anketas.php?gid="+cstr(gid)
%>
