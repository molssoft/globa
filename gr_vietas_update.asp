<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
set r = conn.execute("SELECT g.ID FROM grupa g, vietas v WHERE g.sakuma_dat>getdate() AND g.internets = 1 AND g.atcelta = 0 AND g.veids = 1	AND v.gid=g.ID	AND v.vietas>0")
while not r.eof 

id = r(0)
rw id
rw"<br>"
 conn.execute ("delete from vietas where gid = "+cstr(id))
 conn.execute ("insert into vietas (gid,vietas,viesn_online_pieaug,viesn_online_bernu) values ("+cstr(id)+",isnull(dbo.fn_brivas_vietas("+cstr(id)+"),0),dbo.fn_get_brivas_pieaug_vietas("+cstr(id)+"),dbo.fn_get_brivas_bernu_vietas("+cstr(id)+"))")
	r.movenext
wend
 

%>