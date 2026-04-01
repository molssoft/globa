<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
gid = request.querystring("gid")
set rMarsruts = conn.execute("select * from marsruts where id in (select mid from grupa where id = "+cstr(gid)+")")
conn.execute("insert into marsruts (v,cena,usd,old,v2,need_check,valsts)  select v,cena,usd,old,v2,need_check,valsts from marsruts where id = "+cstr(rMarsruts("id")))
set rID = conn.execute("select max(id) from marsruts")
conn.execute ("update grupa set mid = "+cstr(rID(0))+" where id = "+cstr(gid))
Response.Write "Viss darîts."
%>