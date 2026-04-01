<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
email = request.form("email"+cstr(id))
status = request.form("status"+cstr(id))
q = request.form("qstring")

session("message") = ""
if email = "" then session("message") = "Nav norâdîta eadrese."
if session("message") = "" then
 if Not CheckEmail(email) then session("message") = "Emails ir nepareizs."
end if

if session("message") = "" then
	'Pârbauda vai status ir mainîjies
	set r = conn.execute("select * from email_list where id = " +cstr(id))
	if r("status") <> status then
	 'Ir mainîjies
	 conn.execute "update email_list set datums_status = '"+sqldate(now)+"' where id = " + cstr(id)
	end if
    conn.execute "UPDATE email_list SET email = N'" + email + "',status = '"+status+"' WHERE id = " + cstr(id)
end if

response.redirect "email_list.asp"+q
%>


