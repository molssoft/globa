
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%

dim conn
OpenConn
id=request.form("id")
k=1
jur_grupas_id=request.form("jur_grupas_id"&k)
sdelete_jur_grupas_id="delete from dalibn_jur_grupas where dalibn_id="&ID
Set eohfgvr = conn.execute(sdelete_jur_grupas_id)

do while jur_grupas_id<>""

	sinsert_jur_grupas_id="insert into dalibn_jur_grupas (jur_grupas_id,dalibn_id) VALUES ("&jur_grupas_id&","&ID&")"
	Set eohfgvr = conn.execute(sinsert_jur_grupas_id)
	k=k+1
	jur_grupas_id=request.form("jur_grupas_id"&k)
loop
 response.redirect "jur_grupas.asp?i=" + cstr(id)
%>