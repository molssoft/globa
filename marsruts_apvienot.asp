<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
id = request.querystring("id")
gads = request.querystring("gads")
set rMarsruts = conn.execute("select * from marsruts where id = "+cstr(id))

set rBad = conn.execute("select * from marsruts where id<> "+cstr(id)+" and v2 = '"+rMarsruts("v2")+"' and id in (select mid from grupa where beigu_dat>='1/1/"+cstr(clng(gads))+"' and beigu_dat<'1/1/"+cstr(clng(gads)+1)+"')")
while not rBad.eof
 conn.execute ("update grupa set mid = "+cstr(id)+ " where mid = " + cstr(rbad("id")))
 conn.execute ("delete from marsruts where id = "+cstr(rbad("id")))
 rBad.movenext
wend

Response.Write "Viss darîts."
%>