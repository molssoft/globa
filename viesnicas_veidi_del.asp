<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

set r = conn.execute("select gid from viesnicas_veidi where id = "+cstr(id))
gid = cstr(r("gid"))
conn.execute "UPDATE piet_saite set vid = NULL where vid in (select id from viesnicas where veids = "+cstr(id)+")"
conn.execute "DELETE FROM viesnicas WHERE veids = " + cstr(id)
conn.execute "DELETE FROM viesnicas_veidi WHERE id = " + cstr(id)
response.redirect "viesnicas_veidi.asp?gid="+gid


%>


