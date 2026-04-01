<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

dim conn
openconn
id = request.querystring("id")
vad_id = request.form("vad_id")

conn.execute "update grupu_vaditaji set did = " + cstr(id) + " where idnum = " + cstr(vad_id)


response.redirect "dalibn.asp?i=" + id

%>