<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

marsruts_id = request.form("marsruts_id")

teksts = request.form("teksts"+cstr(id))
skaidrojums = request.form("skaidrojums"+cstr(id))
cena = request.form("cena"+cstr(id))

conn.execute("update pr_spec_pied set teksts = '"+teksts+"',skaidrojums='" + skaidrojums + "',cena ='" + cena + "' where id = "+cstr(id))
response.redirect "pr_details.asp?id="+cstr(marsruts_id)
%>
