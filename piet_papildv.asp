<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
set dal = server.createobject("ADODB.Recordset")
set pakalp = server.createobject("ADODB.Recordset")

psid = request.querystring("psid")



dal.open "select * from piet_saite where id = "+cstr(psid),conn,3,3

set old_saites_arr = GetPietSaitesDict(dal("pid"))
Dim old_vals
set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(dal("pid"))) 


set rstPiet = conn.execute("SELECT * FROM Pieteikums where id = " + cstr(dal("pid")))
pakalp.open "select * from vietu_veidi WHERE papildv = 1 AND gid = " + cstr(rstPiet("gid")),conn,3,3
if pakalp.eof then
	conn.execute "INSERT INTO piet_saite (pid,did,papildv,vietsk) VALUES ("+cstr(dal("pid"))+","+cstr(dal("did"))+",1,1)"
else
	conn.execute "INSERT INTO piet_saite (pid,did,papildv,vietsk,vietas_veids) VALUES ("+cstr(dal("pid"))+","+cstr(dal("did"))+",1,1," + cstr(pakalp("id"))+ ")"
end if	

set new_saites_arr = GetPietSaitesDict(dal("pid"))
Dim new_vals
set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(dal("pid"))) 

SavePietHistory old_saites_arr,new_saites_arr,dal("pid"),old_vals,new_vals

response.redirect ("pieteikums.asp?pid="+cstr(dal("pid")))
%>


