<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

dim conn
OpenConn

Set r = conn.execute("select * from piet_saite where id = 400000")
For Each f In r.Fields
	Response.write f.name + ", "
next

%>