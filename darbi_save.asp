<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

prioritate = request.form("prioritate"+CStr(id))
apraksts = request.form("apraksts"+CStr(id))

conn.execute "UPDATE darbi SET apraksts = '" + apraksts + "',prioritate = "+prioritate+" WHERE id = " + cstr(id)

response.redirect "darbi.asp"
%>


