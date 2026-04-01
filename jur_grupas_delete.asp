
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%

dim conn
OpenConn
jur_grupas_id=request.querystring("jur_grupas_id")
id=request.querystring("i")


sdelete_jur_grupas_id="delete from dalibn_jur_grupas where jur_grupas_id="&jur_grupas_id&" and dalibn_id="&ID
Set eohfgvr = conn.execute(sdelete_jur_grupas_id)
response.redirect "jur_grupas.asp?i=" + cstr(id)
%>