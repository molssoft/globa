<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
id = request.querystring("id")

Set r = conn.execute("select * from dalibn where id = "+CStr(id))

sql = "insert into melnais_saraksts (did,pk1,pk2,datums) values (" + CStr(id) + ",'"+nullprint(r("pk1"))+"','"+nullprint(r("pk2"))+"',getdate())"

conn.execute(sql)

Response.redirect "dalibn.asp?i="+CStr(id)
%>