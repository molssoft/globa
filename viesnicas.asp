<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
gid = request.querystring("gid")
p = request.querystring("p")
'page_size = 10 -- 10.05.19 RT: noòçmu dalîjumu lpp pçc Artas lûguma
page_size = 1000
if p="" then p = 1
session("LastGid") = gid
if Request.QueryString("viss") <> "" then
	session("viss") = Request.QueryString("viss")
end if
if session("viss") = "" then session("viss") = 0

docstart "Viesnicu numuri","y1.jpg" %> 
<center><font color="GREEN" size="5"><b>Viesnîcu numuri</b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>
<% 
headlinks 

IF SESSION("MESSAGE") <> "" THEN RESPONSE.WRITE "<FONT COLOR = RED SIZE = 4>" + SESSION("MESSAGE") + "</FONT>"
session("message") = ""
if alert = 1 then
%>
<script language="JScript">
window.alert ('<%=vmess%>')
</script>
<% end if %>

<center><font size="2">[ <a href="viesnicas_veidi.asp?gid=<%=Request.QueryString("gid")%>">Viesnicu numuru veidi</a> ]
[ <a href="grupa_edit.asp?gid=<%=Request.QueryString("gid")%>">Grupa</a> ]
<%
DefJavaSubmit
checkGroupBlocked(gid)

%>
<form name="forma" id="forma" method="POST">
<%if Request.Form("slegt") <> "" then 
  If Request.Form("slegt") then
  conn.execute("update grupa set viesnicas_slegtas = 1 where id = " & Request.QueryString("gid"))
 else
  conn.execute("update grupa set viesnicas_slegtas = 0 where id = " & Request.QueryString("gid"))
 end if
end if
set rGrupa = conn.execute("select *, IsNull(viesnicas_slegtas,0) as vsl from grupa where id = " & Request.QueryString("gid"))

'Response.Write("select *, IsNull(viesnicas_slegtas,0) as vsl from grupa where id = " & Request.QueryString("gid"))

if GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then %>
 <input type=hidden value="" name=slegt>
 <font size="3"><b>Slçgt viesnîcu numurus </b></font><input type=checkbox onclick="if (!checkBlocked()) {return false;} {form.slegt.value=form.slegti.checked;TopSubmit('viesnicas.asp?gid=<%=cstr(gid)%>')}" name=slegti<% if rGrupa("vsl") then Response.Write " checked"%>><br>
<% end if
'@ 1 Atrodam viesnicas
set r = server.createobject("ADODB.Recordset")
r.open "Select viesnicas.id as vid, viesnicas_veidi.nosaukums, * " + _ 
	"from viesnicas INNER JOIN viesnicas_veidi ON viesnicas.veids = viesnicas_veidi.id WHERE viesnicas.gid = " + cstr(gid) + " order by veids,viesnicas.id",conn,3,3
r.PageSize = page_size
if r.recordcount <> 0 then
 
 'izdrukâjam cilvçkus, kuri nav ievietoti viesnicâ
 
 ssql = "select distinct p.id from pieteikums p inner join piet_saite ps on ps.pid = p.id" +_
   " where p.gid = "+ cstr(gid) +" and p.deleted = 0 and ps.deleted = 0 and (isnull(online_rez,0)=0 or (isnull(online_rez,0)<>0 and online_rez in (SELECT id FROM online_rez WHERE no_delete=1)))" + _
   " and isnull(grupas_vad,0) = 0/*isnull(p.piezimes,'') not like 'GRUPAS VAD_T_JS'*/" + _ 
   " and not p.id in (select pid from piet_saite where deleted = 0" + _
   " and vid in (select id from viesnicas where gid = "+cstr(gid)+")) "
 
 'ssql = "select id from pieteikums where gid = "+ cstr(gid) +" and deleted = 0 and (isnull(online_rez,0)=0 or isnull(online_rez,0)<>0 and tmp=0 and step='4')" + _
 '  " and isnull(piezimes,'') not like 'GRUPAS VAD_T_JS'" + _ 
 '  " and not id in (select pid from piet_saite where deleted = 0" + _
 '  " and vid in (select id from viesnicas where gid = "+cstr(gid)+")) "
  
  
  
  'Response.Write ssql

  set rNavVid = conn.execute(ssql) 
   
 if not rNavVid.eof then
 %> <b><font color=red>Nav izvietoti viesnîcâ</font><b><BR> <%
 while not rNavVid.eof
	
	set rDal = conn.execute("select isnull(vards,'')+' '+isnull(uzvards,'')+' '+isnull(nosaukums,'') as v from dalibn where id in (select did from piet_saite where pid = "+cstr(rNavVid("id"))+" and deleted = 0)")
	%>
	
	<a href=pieteikums.asp?pid=<%=rNavVid("id")%> target=blank>
	
	<%if not rdal.eof then 
		response.write rdal("v") 
	else 
		response.write "KÏÛDA - pieteikumam nav piesaistîta persona"
	end if
	%>
	
	<br></a>
	
	<%
   rNavVid.movenext
   'if not rdal.eof then response.write rdal("v") else response.write "select isnull(vards,'')+' '+isnull(uzvards,'')+' '+isnull(nosaukums,'') as v from dalibn where id in (select did from piet_saite where pid = "+cstr(rNavVid("id"))+" and deleted = 0)"
   '=rdal("v")
   wend
 rNavVid.movefirst
 %><BR><BR><%
 end if
	KajNr = 1
	DalNr = 1
	KajVeids = 0
	i = 1
	start_rec = (clng(p)-1)*page_size+1
	while i < start_rec
	 if KajVeids <> r("veids") then
	  KajVeids = r("veids")
	  KajNr = 1
	 end if
	 KajNr = KajNr + 1
	 DalNr = DalNr + r("vietas")
	 r.MoveNext
	 i = i + 1
	wend
	'PageLinks
	dim rDal
	set rDal = Server.createobject("ADODB.Recordset")
	%> <center> <table style="border-collapse: collapse;">
	<tr bgcolor="#ffc1cc">
	
	<th>Numurs</th>
	<th>Nr.</th>
	<th>Uzvârds</th>
	<th>Vârds</th>
	<th>Dzimð. dat.</th>
	<th></th>
	<th>Pase/ID</th>
	<th>Dz.</th>
	<th>Lîguma nr.</th>
	<th>Çdinâðana</th>
	<th>Ekskursijas</th>
	<th>Zîdainis</th>
	<th><input type="checkbox" id="checkAll" title="Ieíeksçt visus numuriòus dzçðanai"></th> 
	<th></th>
	</td>
	<%
	pi = 1
	 
		while not r.eof and pi<=page_size
			set rDal = conn.execute( _
		"SELECT " & _
			"isnull(dalibn.dzimsanas_datums,'') AS dzimsanas_datums, " & _
			"p.zid, " & _
			"dalibn.vards, " & _
			"dalibn.uzvards, " & _
			"dalibn.pk1, " & _
			"dalibn.paseS, " & _
			"dalibn.paseNR, " & _
			"dalibn.idS, " & _
			"dalibn.idNr, " & _
			"dalibn.ID, " & _
			"piet_saite.vid, " & _
			"piet_saite.id AS id, " & _
			"piet_saite.pid AS pid, " & _
			"piet_saite.did AS did, " & _
			"dalibn.dzimta AS dzimta, " & _
			"piet_saite.papildv2, " & _
			"piet_saite.vietas_veids, " & _
			"p.agents, " & _
			"p.online_rez, " & _
			"p.ligums_id, " & _
			"p.id AS pid " & _	
		"FROM dalibn " & _
			"INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " & _
			"INNER JOIN pieteikums p ON p.id = piet_saite.pid " & _
		"WHERE pid IN ( " & _
			"SELECT id FROM pieteikums " & _
			"WHERE gid = " & cstr(gid) & " " & _
			  "AND deleted = 0 " & _
			  "AND (isnull(tmp,0)=0 OR agents_izv=1) " & _
		") " & _
		"AND piet_saite.deleted = 0 " & _
		"AND vid = " & cstr(r("vid")) _
	)
		DalKajNr = 0
			response.write "<tr bgcolor = #AAAAAA><td colspan = 13><font size = 2>.</font></td></tr>"
		while not rDal.eof
			
			'--- ierakstu kraasu atðíirîbas. agenti zils, online zals ieraksts.		
			if rDal("online_rez")>0 then
 				row_style = "style=""color:#008040;"""
 			elseif rDal("agents")>0 then
 				row_style = "style=""color:blue;"""
 			else
 				row_style = "style=""color:black;"""
 			end if
 			'--------------------------------------------------------------------
		
		 if rDal("vietas_veids") <> 0 then
		  set rVieta = conn.execute("select nosaukums from vietu_veidi where tips = 'A' and id = " & rDal("vietas_veids"))
		 else
		  set rVieta = conn.execute("select nosaukums from vietu_veidi where 1=2")
		 end if
			%><tr bgcolor="#fff1cc" ><!--td><%
			 if not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then
			 %>
			<input type="checkbox" name="vid" value="<%=getnum(r("vid"))%>">
			 <%
			
			 end if
			%></td--><td><%
			DalKajNr = DalKajNr + 1
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums")+" "+ nullprint(r("pilns_nosaukums")) + " " +nullprint(r("piezimes")) + " - " + cstr(KajNr) 
			end if
			%></td>
			<td><%=cstr(DalNr)%></td>
			<%if rVieta.eof then%>
			<td><a href="dalibn.asp?i=<%=rDal("did")%>"><%=rDal("uzvards")%></a></td>
			<td><a href="dalibn.asp?i=<%=rDal("did")%>"><%=rDal("vards")%></a></td>
			<td <%=row_style%>><%
		
			if (rDal("dzimsanas_datums") <> "" and rDal("dzimsanas_datums") <> CDate("1900-01-01")) then
				response.write(DatePrint(rDal("dzimsanas_datums")))
				else 
				' Drukaa dzimsanas datumu peec personas koda pirmaas daljas
				if len(rDal("pk1")) = 6 then					
					response.write(mid(rDal("pk1"),1,2)+".")
					response.write(mid(rDal("pk1"),3,2)+".")
					Y = (ASC(mid(rDal("pk1"),5,1)) - ASC("0"))*10+(ASC(mid(rDal("pk1"),6,1))-ASC("0"))+1900
					if y+99 < year(now) then y = y + 100
					response.write(cstr(y))
				end if
			end if
			%></td>
			<% if NullPrint(rDal("paseNr"))<>"" then %>
				<td <%=row_style%>><%=NullPrint(rDal("paseS"))%></td>
				<td <%=row_style%>><%=NullPrint(rDal("paseNr"))%></td>
			<% else %>
				<td <%=row_style%>><%=NullPrint(rDal("idS"))%></td>
				<td <%=row_style%>><%=NullPrint(rDal("idNr"))%></td>
			<% end if %>
			
			<td <%=row_style%>>
				<%if NullPrint(rDal("dzimta")) = "x" then Response.Write "-"%>
				<%if NullPrint(rDal("dzimta")) = "v" then Response.Write "M"%>
				<%if NullPrint(rDal("dzimta")) = "s" then Response.Write "F"%>
			</td>
			<td <%=row_style%>><%
				ligums_id = getnum(rDal("ligums_id"))
				accepted = 0
				
				'mçìinam atrast lîgumu kas saglabâts savâdâk. 
				'tâ nevajadzçtu bût, bet daþreiz gadâs
				if ligums_id = 0 and getnum(rDal("online_rez"))<>0 then
					set rlig = conn.execute("select id from ligumi where deleted = 0 and rez_id = "+cstr(rDal("online_rez"))+" order by id desc" )
					if not rlig.eof then 
						ligums_id = rlig("id")
					end if
				end if
				'rw ligums_id
				
				if ligums_id <> 0 then 
					eksiste_ligumi = 1
					ssql = "select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id)
					'rw ssql
					Set ligums = conn.execute("select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id))
					accepted = ligums("accepted")
					accepted = 1
					parakstits = ligums("parakstits")
					nosutits = ligums("nosutits")
					
					
					If accepted <> 0 then
						response.write(ligums_id)
					end if
				else
					'--- parbauda vai nav online_rez un taas liigums
					ssql = "select r.ligums_id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
							"where p.id = "&rDal("pid")&" and r.deleted = 0 and p.deleted = 0" 
							
					set o_rez = conn.execute(ssql)
					if not o_rez.eof Then
						If getnum(o_rez("ligums_id")) <> 0 then
							response.write(getnum(o_rez("ligums_id")))
						end if
						end if
				end if
			%></td>
			<%
			else
			  Response.Write "<td>aizòemts</td><td></td><td></td><td></td><td></td><td></td>"
			end if
			%>
			<td>
				<%
				''------------ çdinâðanas
				Set rEd = conn.execute("select nosaukums,* from piet_saite inner join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id where pid = "+CStr(rDal("pid"))+" and deleted = 0 and tips = 'ED'")
				While Not rEd.eof
					Response.write(rEd("nosaukums"))+"<BR>"
					rEd.MoveNext
				wend
				%>
			</td>
			<td>
				<%
				''------------ ekskursijas
				Set rEx = conn.execute("select nosaukums,* from piet_saite inner join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id where pid = "+CStr(rDal("pid"))+" and deleted = 0 and tips = 'EX'")
				While Not rEx.eof
					Response.write(rEx("nosaukums"))+"<BR>"
					rEx.MoveNext
				wend
				%>
			</td>
			<td>
				<%
				''------------ zidainis
				If getnum(rDal("zid")) <> 0 Then 
					Set rzid = conn.execute("select * from dalibn where id = "+CStr(getnum(rDal("zid"))))
					If Not rzid.eof then
						Response.write nullprint(rzid("vards")) + " " + nullprint(rzid("uzvards"))+ " "+CStr(nullprint(rzid("pk1")))+"-"+CStr(nullprint(rzid("pk2")))
					End if
				End if
				%>
			</td>
			<td>
			<%
			 if not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then
			%><input type="image" src="impro/bildes/dzest.jpg" onclick="if (confirm('Dzçst?')) {forma.action = 'viesnicas_del.asp?vid=<%=getnum(r("vid"))%>';forma.submit();} return false;" alt="Dzçst kajîti." WIDTH="25" HEIGHT="25"><%
			 end if
			%></td>
			<td valign=bottom>
			<input type="image" src="impro/bildes/iznemt.jpg" onclick="if (confirm('Izòemt?')) {forma.action = 'viesnicas_rem.asp?vid=<%=getnum(r("vid"))%>&did=<%=rDal("did")%>&gid=<%=gid%>';forma.submit();} return false;" alt="Izòemt no numura." WIDTH="25" HEIGHT="25" id=image2 name=image2>
			</td>
			</tr><%
			DalNr = DalNr + 1
			rDal.MoveNext
		wend
		while (DalKajNr < r("vietas"))
			DalKajNr = DalKajNr + 1
			%><tr bgcolor="#fff1cc"><td><%
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums")+ " " + nullprint(r("pilns_nosaukums")) + " " + nullprint(r("piezimes")) + " - " + cstr(KajNr)
			end if
			%></td>
			<td></td>
			<td><%=DalNr%></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><%
			if DalKajNr = 1 then 
			 if not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then
			 %>
			 <input type="checkbox" class="tuksie_dzesanai" name="vid" value="<%=getnum(r("vid"))%>" >
			 <%
			 end if
			end if
			%></td>
			<!--td><%
			if DalKajNr = 1 then 
			 if not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then

				%><input type="image" src="impro/bildes/dzest.jpg" onclick="if (confirm('Dzçst?')) {forma.action = 'viesnicas_del.asp?vid=<%=getnum(r("vid"))%>';forma.submit();} return false;" alt="Dzçst ierakstu." id="image1" name="image1" WIDTH="25" HEIGHT="25"><%
  			 end if
			end if
			%></td-->
			<td>
			
			</td>
			</tr><%
			DalNr = DalNr + 1
		wend
		KajNr = KajNr + 1
		rDal.close
		pi = pi + 1
		r.movenext
	wend
	%>
	<tr><td colspan=10></td><td colspan=4 style="text-align:right"><button type="" id="dzest_vairakus">Dzçst ieíeksçtos tukðos numuriòus</button></td></tr>
	</table>
	
	
	<%'PageLinks%><br>

<!--input type="image" src="impro/bildes/drukat.jpg" onclick="TopSubmit2('viesnicas_print.asp?gid=<%=gid%>')" alt="Attçlot drukâjamu viesnicu numuru sarakstu." WIDTH="116" HEIGHT="25">
	<br><input type="checkbox" name="anglu" value="yes">Angïu burtiem</input-->
	

	<br>
	<table>

	<tr><th>Izdrukas sagatavoðana</th></tr>
	
	<tr bgcolor="#fff1cc"><td><input type="checkbox" name="anglu" value="yes">Angïu burtiem</input>
	</td></tr>
	<tr bgcolor="#fff1cc">
		<td>
			<input type="checkbox" name="edinasana" value="yes">Iekïaut çdinâðanu</input>
		</td>
	</tr>
	<tr bgcolor="#fff1cc">
		<td>
			<input type="checkbox" name="ekskursijas" value="yes">Iekïaut ekskursijas</input>
		</td>
	</tr>
	<tr bgcolor="#fff1cc">
		<td>
			<input type="checkbox" name="vaditajs" value="yes">Iekïaut grupas vadîtâju</input>
		</td>
	</tr>
	<tr ><td align="center"> <input type="image" src="impro/bildes/drukat.jpg" onclick="TopSubmit2('viesnicas_print.asp?gid=<%=gid%>')" alt="Attçlot drukâjamu viesnicu numuru sarakstu." WIDTH="116" HEIGHT="25">
	</td></tr>
	</table>
	<br>
	<%
else
	response.write "Grupâ viesnîcu numuru nav!"
end if




%>
<br><a target = none href = "viesnicas_vesture.asp?gid=<%=gid%>"><img border = 0 src="impro/bildes/clock.bmp" alt="Apskatît vçsturi."></a>
<p><hr><p>
<center><font color="GREEN" size="5"><b>Viesnîcu numuru pievienoðana</b></font><%
%>
<p>
<% if not rGrupa("vsl") or GetCurUserID = rGrupa("kurators") or IsAccess(T_LIETOT_ADMIN) then %>
<table>
<tr bgcolor="#ffc1cc"><th>Veids</th><th>Skaits</th><th></th></tr>
<tr bgcolor="#fff1cc"><td align="center">
<select name="viesnicas_veids">
<%
set rKVeids = conn.execute ("select * from viesnicas_veidi where gid = " + cstr(gid))
while not rKVeids.eof
	Response.Write "<option value = " + cstr(rKVeids("id")) + ">" + nullprint(rKVeids("nosaukums")) + " - " +nullprint(rKVeids("pilns_nosaukums"))+"</option>"
	rKVeids.movenext
wend
%>
</select></td>
<td align="center"><input type="text" name="skaits" size="7" value="1"></td>
<td>
<input type="image" src="impro/bildes/pievienot.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit2('viesnicas_add.asp?gid=<%=cstr(gid)%>')" WIDTH="25" HEIGHT="25">
</td>
</tr></table>
<% else %>
 Viesnîcu numurus ðai grupai var labot tikai kurators<br>
<% end if %>
<% if session("viss") = 0 then %>
	<a href="viesnicas.asp?gid=<%=gid%>&amp;viss=1">Aktuâlâs grupas</a>
<% else %>
	<a href="viesnicas.asp?gid=<%=gid%>&amp;viss=0">Visas grupas</a>
<% end if %>




</form>
</body>
<script>
$("#checkAll").click(function(){
    $('input:checkbox.tuksie_dzesanai').not(this).prop('checked', this.checked);
});
$("#dzest_vairakus").on("click",function(){

	if(jQuery('#forma input[type=checkbox].tuksie_dzesanai:checked').length) {

		if (confirm('Vai tieðâm vçlaties dzçst izvçlçtos viesnîcu numuriòus?')){
			var forma = $("#forma");
			forma.attr('action', 'viesnicas_vairakas_del.asp');
			forma.submit();
		}
		else return false;
	}
	else{
		alert('Lûdzu, izvçlieties vismaz vienu numuriòu, ko dzçst!');
		return false;
	}
});
</script>
</html>





<%
Sub PageLinks()
 for i = 1 to r.PageCount
  if cstr(p)<>cstr(i) then
   %><a href="viesnicas.asp?gid=<%=gid%>&p=<%=i%>">[<%=i%>]</a><%
  else
   %><b>[<%=i%>]</b><%
  end if
 next
end Sub


%>


