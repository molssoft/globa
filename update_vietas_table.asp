<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->


<%
dim conn
openconn

gid = request.querystring("gid")

set r = conn.execute("select id from grupa where sakuma_dat >= getdate() and not id in (select gid from vietas) order by id")

while not r.eof 
	conn.execute("delete from vietas where gid = "+cstr(r("id")))
	conn.execute("insert into vietas (gid,vietas) values ("+cstr(r("id")) + _
	",isnull(dbo.fn_brivas_vietas("+cstr(r("id"))+"),0))")	
	response.write cstr(r("id")) + " done.<BR>"
	
	r.movenext
wend 



%>
