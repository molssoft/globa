<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'--- izveido balles pieteikumu -----------------------------------------------

dim conn
openconn

did = Request.querystring("did")
sektors = Request.querystring("sektors")
numurs = cstr(Request.querystring("numurs"))
grupa_gid = cstr(Request.querystring("gid"))


'--- atrod jaunâko balles grupu	
ssql = "SELECT max(g.id) as id FROM grupa g inner join marsruts m on m.id = g.mid " + _
	   "where v like '%balle%'"
	   
set r_g = conn.execute(ssql)

if not r_g.eof then
	gid = r_g("id")
else
	Response.Write("Nav atrasta balles grupa")
	Response.end
end if

ssql = "SET NOCOUNT ON;INSERT INTO pieteikums (did, gid, izveidoja, b_numurs, b_sektors, piezimes) " + _
	   "VALUES ("+cstr(did)+","+cstr(gid)+",'"+Get_User+"',"+numurs+",'"+sektors+"', 'Balles biïete') " + _
	   "; SELECT @@IDENTITY as ID"
	
set r_pid = conn.execute(ssql)
	
pid = r_pid.Fields.Item("ID")
	
if pid <> "" then

	conn.execute "INSERT INTO piet_saite (pid,did,vietsk) VALUES ("+cstr(pid)+","+cstr(did)+",1)"

	'ðis vajadzîgs lai varçtu viegli noteikt vai grupâ ir kâds balles gâjçjs
	If grupa_gid <> "" then
		conn.execute "INSERT INTO balles_pieteikumi (pid,gid) values ("+cstr(pid)+","+cstr(grupa_gid)+")"
	End if
	
	loginsertaction "pieteikums",pid
	
	session("message") = "Pieteikums ballei izveidots"
	Response.Redirect("balle_edit.asp?gid="+grupa_gid+"&pid="+cstr(pid)+"&num="+sektors+numurs+"&did="+did)
else
	
	session("message") = "Kïûda. Pieteikums ballei nav izveidots"
	Response.Redirect("dalibn.asp?i="+cstr(did))

end if

	
%>