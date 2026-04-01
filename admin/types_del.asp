<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

set r = conn.execute("select * from theMain where type_id = '"+id+"'")
if r.eof then
 conn.execute "DELETE FROM types where id = '" +cstr(id) + "'"
else
 session("message") = "<font color=red size=2>Nevar dzçst jo eksistç dati ar ðâdu tipu</font>"
end if
response.redirect "types.asp"
%>