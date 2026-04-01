
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<html>
<body>
	<div align="center">

<%

'atver konektu pie datubâzes
dim conn
openconn

did = Request.QueryString("did")
pid = 0 

vv1 = true '--- true = abonementa veids ar cenu par visiem klubiniem; false = abonoments ar cenu 0

'Saglabâ pieteikuma numuru
 Session("pid") = pid
 Session("LastPid") = pid
  
 if Request.QueryString("command") = "new" then

			
	'--- insert pieteikums par katru klubinju
	Set klubins = conn.execute("SELECT grupa.id as gid FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE (((grupa.beigu_dat)>('"+sqldate(now-1)+"'))) and v like '%klubi%' and grupa.atcelta = 0 ORDER BY grupa.sakuma_dat")
	while not klubins.eof
		
		set conn2 = server.createobject("ADODB.Connection")
		conn2.open conn.connectionstring
		conn2.begintrans
		
		gid = klubins("gid") '--- grupas id

	
		'--- Pievieno jaunu pieteikumu
		conn2.execute "insert into pieteikums (did,gid,izveidoja) values ("+cstr(did)+","+cstr(gid)+",'"+Get_User+"')"
		set rPiet2 = conn2.execute ("select max(id) from pieteikums")
		pid = rPiet2(0)
		conn2.committrans
		conn2.close

		WriteLog 1,pid,"A"
		LogInsertAction "pieteikums",pid	
		 
	
		if vv1 = true then
			'--- get id abonomentam ar cenu par visiem klubiniem
			vietas_veids = conn.execute("SELECT id FROM vietu_veidi WHERE gid="+cstr(gid)+" AND nosaukums = 'Lielais abonoments pilna cena'")(0)
			vv1 = false
		else
			'--- get id abonomentam ar cenu 0
			vietas_veids = conn.execute("SELECT id FROM vietu_veidi WHERE gid="+cstr(gid)+" AND nosaukums = 'Lielais abonoments 0'")(0)
		end if

	
		
		'--- insert pieteikuma saite
		conn.execute "INSERT INTO piet_saite (pid,did,vietsk,vietas_veids) VALUES ("+cstr(pid)+","+cstr(did)+",1,"+cstr(vietas_veids)+")"
		
					 
		pieteikums_recalculate(pid)

	klubins.MoveNext
	wend
%>

	<p>Procedûra pabeigta</p>
	<p><a href="dalibn.asp?i=<%=did%>">Atpakaï</a></p>

<%
else

	Response.Redirect("dalibn.asp?i="+cstr(did))
	

end if 
%>



	</div>
	
</body>
</html>

