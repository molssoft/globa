<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
email = trim(request.form("email"))
status = request.form("status")

q = request.form("qstring")

session("message") = ""
if email = "" then session("message") = "Nav norâdîts emails."
if session("message") = "" then
 if CheckEmail(email) = False then session("message") = "Emails ir kïûdains."
end if
if session("message") = "" then conn.execute "INSERT INTO email_list (email,datums_izv,status) VALUES (N'" + email + "','"+sqldate(now)+"','"+status+"')"
response.redirect "email_list.asp"+q

%>


