<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
rw Request.Form("vid")

vids = Split(Request.Form("vid"),",")
rw vids(0)
set rec = conn.execute ("Select gid from viesnicas_veidi where id in (select veids from viesnicas where id = "+cstr(vids(0))+")")
gid = cstr(rec("gid"))
For each vid in vids
	Del_Viesnica(vid)
next

response.redirect ("viesnicas.asp?gid="+gid)
%>
