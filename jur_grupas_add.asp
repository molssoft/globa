
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%

dim conn
OpenConn
jur_grupas_id=request.form("jur_grupas_id")
id=request.form("id")


sinsert_jur_grupas_id="insert into dalibn_jur_grupas (jur_grupas_id,dalibn_id) VALUES ("&jur_grupas_id&","&ID&")"
Set eohfgvr = conn.execute(sinsert_jur_grupas_id)
response.redirect "jur_grupas.asp?i=" + cstr(id)
%>