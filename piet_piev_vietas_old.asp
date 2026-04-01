<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
pid = request.querystring("pid")
sk = request.form("piet_vietas_sk")
if sk = "" then sk = 1
set r = conn.execute("select * from piet_saite where pid = " + pid)
if sk>10 then 
  sk = 10
  session("message") = "Nevar pievienot vairâk kâ 10 rindas vienâ reizç."
end if
for i = 1 to sk
	conn.execute "INSERT INTO piet_saite (pid,did,vietsk,persona) VALUES (" + cstr(getnum(pid)) + "," + cstr(getnum(r("did"))) + ",1,0)"
next
response.redirect "pieteikums.asp?pid=" + pid
%>