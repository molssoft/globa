<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

pid = Request.Form("pid") 'vecais pid
did = Request.Form("did")
new_gid = Request.Form("gid")
desc_gid = cstr(conn.execute("select gid from pieteikums where id = "+cstr(pid))(0))
set rGrupa = conn.execute("select * from grupa where id = "+cstr(desc_gid))

'izvelas pareizu atteikumu grupu
if ucase(nullprint(rGrupa("valuta")))<>"XXX" then
 atteikusies_id = conn.execute("select atteikusies from parametri")(0)
else
 atteikusies_id = conn.execute("select atteikusies2 from parametri")(0)
end if

'--- atcel veco pieteikumu
conn.execute "update pieteikums set atcelts = 1, gid = "+cstr(atteikusies_id)+", old_gid = "+cstr(desc_gid)+" where id = " +cstr(pid)
conn.execute "delete from piet_atlaides where pid = " + cstr(pid)
conn.execute "update piet_saite set cena = 0, vietas_cena = 0, kvietas_cena = 0, vietas_veids = 0, kvietas_veids = 0, kid = 0, vid = 0 where pid = " + cstr(pid)
pieteikums_recalculate pid
'--- izveido jaunu pieteikumu
conn.execute "insert into pieteikums (gid) values ("+cstr(new_gid)+")"
'--- atrod jauna pieteikuma id
new_pid = conn.execute ("select max(id) from pieteikums where gid = "+cstr(new_gid))(0)
LogInsertAction "pieteikums",new_pid
WriteLog 1,new_pid,"A"

'--- pievieno dalibnieku
conn.execute "insert into piet_saite (pid,did,vietsk) values ("+cstr(new_pid)+","+cstr(did)+",1)"

'--- sagatavo datus un pariet uz parskaitjumu
session("parsk") = "no"
session("lastpid") = new_pid
'--- desc_gid = lai varetu dabut bijušas grupas nosaukumu
Response.Redirect "operacija.asp?pid="+cstr(pid)+"&desc_gid="+desc_gid
%>