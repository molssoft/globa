<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
pid = request.querystring("pid")

set old_saites_arr = GetPietSaitesDict(pid)
Dim old_vals
set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 

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
set new_saites_arr = GetPietSaitesDict(pid)
Dim new_vals
set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 

SavePietHistory old_saites_arr,new_saites_arr,pid,old_vals,new_vals

response.redirect "pieteikums.asp?pid=" + pid
%>