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

'---- nosaka cik vietas ir aizòemtas
query = "SELECT sum(piet_saite.vietsk) as aizn " +_
	"FROM grupa,pieteikums,piet_saite " +_
	"WHERE grupa.id = "+cstr(gid)+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id  AND (piet_saite.deleted=0 and pieteikums.deleted = 0);"
set aizn = Server.CreateObject("ADODB.Recordset")
aizn.Open query,conn,3,3

if gid <> 0 then
	'--- pârbauda vai vietu skaits nav pârâk liels, ja nav tad cik ir brîvas
	if getnum(id_field("grupa",gid,"vietsk")) = getnum(aizn("aizn")) then vmess = "Grupa ir pilna": alert = 1
	if getnum(id_field("grupa",gid,"vietsk")) < getnum(aizn("aizn")) and getnum(id_field("grupa",gid,"vietsk")) <> 0  then vmess = "Grupa ir pârpildîta": alert = 1
	if id_field("grupa",gid,"vietsk") > aizn("aizn") then vmess = "Brîvo vietu skaits grupâ: "+cstr(id_field("grupa",gid,"vietsk") - getnum(aizn("aizn")))
	if id_field("grupa",gid,"atcelta") = true then vmess = "Grupa ir atcelta.": alert = 1
end if




'------------ Kopç kajîtes ja poga nospiesta
if Request.Form("poga") = "Kopçt" then
	Copy_Kajites gid,Request.Form("gid")
end if


docstart "Kajîtes","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Kajîtes</b></font>
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

<center><font size="2">[ <a href="kajites_veidi.asp?gid=<%=Request.QueryString("gid")%>">Kajîðu veidi</a> ]
[ <a href="pieteikumi.asp?gid=<%=Request.QueryString("gid")%>">Grupa</a> ]
<%
DefJavaSubmit
checkGroupBlocked(gid)
%>
<form name="forma" method="POST">
<%
'@ 1 Atrodam kajiites
set r = server.createobject("ADODB.Recordset")
r.open "Select kajite.id as kid, kajites_veidi.standart_cena as st_cn,  kajites_veidi.bernu_cena as br_cn,  kajites_veidi.papild_cena as p3_cn, kajites_veidi.papild2_cena as p2_cn,kajites_veidi.papild3_cena as p1_cn, kajites_veidi.senioru_cena as sn_cn,  kajites_veidi.papild_cena as pp_cn,kajites_veidi.papild2_cena as pp2_cn,kajites_veidi.papild3_cena as pp3_cn,* " + _ 
	"from kajite INNER JOIN kajites_veidi ON kajite.veids = kajites_veidi.id WHERE kajite.gid = " + cstr(gid) + " AND (deleted = 0) order by veids,kajite.id",conn,3,3
r.PageSize = page_size
if r.recordcount <> 0 then
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
	%> <center> <table border="0">
	<tr bgcolor="#ffc1cc">
	<th>Kajîte</th>
	<th>Vieta</th>
	<th>P.A.</th>
	<th>Cena</th>
	<th>Nr.</th>
	<th>Uzvârds</th>
	<th>Vârds</th>
	<th>Dzimð. dat.</th>
	<th></th>
	<th>Pase</th>
	<th>Id karte</th>
	<th>Dz.</th>
	<th>Lîguma nr.</th>
	<th></th>
	<th></th>
	</td>
	<%
	pi = 1
	while not r.eof and pi<=page_size
	
			
		rDal.open "SELECT isnull(dalibn.dzimsanas_datums,'') as dzimsanas_datums,dalibn.vards, dalibn.uzvards, dalibn.pk1, dalibn.paseS, dalibn.paseNR, dalibn.IdS, dalibn.idNR, " + _
			" dalibn.ID, piet_saite.kid, piet_saite.id as id, piet_saite.pid as pid, piet_saite.did as did, " + _ 
			" piet_saite.kvietas_veids as kvietas_veids, dalibn.dzimta as dzimta, piet_saite.papildv2, " + _
			" piet_saite.vietas_veids as vietas_veids, "+ _
			" p.agents,p.internets,p.ligums_id,p.online_rez "+ _
			" FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
			" LEFT JOIN pieteikums p ON piet_saite.pid=p.id "+ _
			" LEFT JOIN vietu_veidi vv ON vv.id=piet_saite.vietas_veids " + _
			" WHERE (NOT PIET_SAITE.DELETED = 1) AND kid = " + cstr(r("kid")) ,conn,3,3
		DalKajNr = 0
				response.write "<tr bgcolor = #AAAAAA><td colspan = 12><font size = 2>.</font></td></tr>"
				
		atlaut_vel_dalibn = true	
		while not rDal.eof
			if getnum(rDal("agents"))<>0 then
				fstyle = " style='color: #0030ff'"
			elseif getnum(rDal("internets"))=true then	
				fstyle = " style='color: green'"
			else
				fstyle = ""
			end if
			'bgcolor="#fff1cc"
			%><tr ><td><%
			DalKajNr = DalKajNr + 1
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + " - " + cstr(KajNr)
			end if
			%></td>
			<td <%=fstyle%>>
			<% 'rw rDal("kvietas_veids") 
				cena = ""
				if rDal("kvietas_veids") = 0 then 
					if (rDal("vietas_veids")<>0) then
						set vvt = conn.execute("select tips,cenaEUR FROM vietu_veidi WHERE id="+cstr(rDal("vietas_veids")))
						if not vvt.eof then
							if vvt("tips")="Z1" then 
								response.write "Pçdçjâ brîþa piedâvâjums"
								cena = vvt("cenaEUR")
							end if
						end if
					end if
				end if
				'response.write "nav"%>
				<%if rDal("kvietas_veids") = 1 then response.write "Standarta"%>
				<%if rDal("kvietas_veids") = 2 then response.write "Bçrnu"%>
				<%if rDal("kvietas_veids") = 5 then response.write "Pusaudþu"%>
				<%if rDal("kvietas_veids") = 6 then response.write "Brîva v.(2 pers)"%>
				<%if rDal("kvietas_veids") = 3 then response.write "Brîva v.(3 pers)"%>
				<%if rDal("kvietas_veids") = 7 then 
					response.write "Brîva v.(1 pers)"
					atlaut_vel_dalibn = false
				end if %>
				<%if rDal("kvietas_veids") = 4 then response.write "Senioru"%>
				
			</td>
			<td <%=fstyle%>>
				<%if rDal("papildv2") then response.write "IR"%>
			</td>
			<td <%=fstyle%>>
				<%if rDal("kvietas_veids") = 1 then response.write GetNum(r("st_cn"))%>
				<%if rDal("kvietas_veids") = 2 then response.write GetNum(r("br_cn"))%>
				<%if rDal("kvietas_veids") = 5 then response.write GetNum(r("p3_cn"))%>
				<%if rDal("kvietas_veids") = 6 then response.write GetNum(r("p2_cn"))%>
				<%if rDal("kvietas_veids") = 3 then response.write GetNum(r("pp_cn"))%>
				<%if rDal("kvietas_veids") = 7 then response.write GetNum(r("p1_cn"))%>
				<%if rDal("kvietas_veids") = 4 then response.write GetNum(r("sn_cn"))%>
				<% if cena<> "" then rw  GetNum(cena) %>
			</td>
			<td <%=fstyle%>><%=cstr(DalNr)%></td>
			<td <%=fstyle%>><a href="dalibn.asp?i=<%=rDal("did")%>"><%=rDal("uzvards")%></a></td>
			<td <%=fstyle%>><a href="dalibn.asp?i=<%=rDal("did")%>"><%=rDal("vards")%></a></td>
			<td <%=fstyle%>><%
			if (DatePrint(rDal("dzimsanas_datums")) <> "") then
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
			<td <%=fstyle%>><%=NullPrint(rDal("paseS"))%></td>
			<td <%=fstyle%>><%=NullPrint(rDal("paseNr"))%></td>
			<td <%=fstyle%>><%=NullPrint(rDal("idS"))%><%=NullPrint(rDal("idNR"))%></td>
			<td <%=fstyle%>>
				<%if NullPrint(rDal("dzimta")) = "x" then Response.Write "-"%>
				<%if NullPrint(rDal("dzimta")) = "v" then Response.Write "M"%>
				<%if NullPrint(rDal("dzimta")) = "s" then Response.Write "F"%>
			</td>
			<td <%=fstyle%>><%
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
			<td <%=fstyle%>><%
			if DalKajNr = 1 and IsAccess(T_KAJITES) then 
				%><input type="image" src="impro/bildes/dzest.jpg" onclick="if (!checkBlocked()){return false;} TopSubmit('kajite_del.asp?kid=<%=getnum(r("kid"))%>');return false;" alt="Dzçst kajîti." WIDTH="25" HEIGHT="25"><%
			end if
			%></td>
			<td><input type="image" src="impro/bildes/dzest.jpg" onclick="TopSubmit('kajite_dal_del.asp?id=<%=getnum(rDal("id"))%>');return false;" alt="Dzçst dalîbnieku." WIDTH="25" HEIGHT="25"></td>
			<td><input type="image" src="impro/bildes/dolars.jpg" onclick="TopSubmit('orderis.asp?pid=<%=getnum(rDal("pid"))%>');return false;" alt="Izdrukât iemaksu." ></td>
			</tr><%
			DalNr = DalNr + 1
			rDal.MoveNext
		wend
		while (DalKajNr < r("vietas") and atlaut_vel_dalibn)
			DalKajNr = DalKajNr + 1
			%><tr bgcolor="#fff1cc"><td><%
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + " - " + cstr(KajNr)
			end if
			%></td>
			<td><select name="kvietas_veids<%=cstr(DalNr)%>">
				<option value="1">Standarta</option>
				<option value="2">Bçrnu</option>
				<option value="5">Pusaudþu</option>
				<option value="3">Brîva v. 3p.</option>
				<option value="6">Brîva v. 2p.</option>
				<option value="7">Brîva v. 1p.</option>
				<option value="4">Senioru</option>
			</select></td>
			<td><input type = checkbox name="papildv<%=cstr(DalNr)%>"></td>
			<td></td>
			<td><%=DalNr%></td>
			<td><input type="text" size="10" name="uzvards<%=cstr(DalNr)%>"></td>
			<td><input type="text" size="10" name="vards<%=cstr(dalNr)%>"></td>
			<td><input type="text" size="10" name="dzim_datums<%=cstr(dalNr)%>"></td>
			<td><input type="text" size="2" name="paseS<%=cstr(dalNr)%>"></td>
			<td><input type="text" size="7" name="paseNr<%=cstr(dalNr)%>"></td>
			<td><select name="dzimta<%=cstr(DalNr)%>">
				<option value="x">-</option>
				<option value="v">M</option>
				<option value="s">F</option>
			</select></td>
			<td><%
			if DalKajNr = 1 and IsAccess(T_KAJITES) then 
				%><input type="image" src="impro/bildes/dzest.jpg" onclick="if (!checkBlocked()){return false;} TopSubmit('kajite_del.asp?kid=<%=getnum(r("kid"))%>');return false;" alt="Dzçst kajîti." id="image1" name="image1" WIDTH="25" HEIGHT="25"><%
			end if
			%></td>
			<td><input type="image" src="impro/bildes/saglabat.jpg" onclick="TopSubmit('kajite_dal_save.asp?kid=<%=getnum(r("kid"))%>&amp;dalnr=<%=cstr(dalNr)%>');return false;" alt="Saglabât dalîbnieku." WIDTH="25" HEIGHT="25"></td>
			</tr><%
			DalNr = DalNr + 1
		wend
		KajNr = KajNr + 1
		rDal.close
		pi = pi + 1
		r.movenext
	wend
	%></table>
	<%'PageLinks%><br>
	<input type="image" src="impro/bildes/drukat.jpg" onclick="TopSubmit('kajite_print.asp')" alt="Attçlot drukâjamu kajîðu sarakstu." WIDTH="116" HEIGHT="25">
	<br><input type="checkbox" name="anglu" value="yes">Angïu burtiem</input>
	<%
else
	response.write "Grupâ kajîðu nav!"
end if

%><p><hr><p>
<center><font color="GREEN" size="5"><b>Kajîðu pievienoðana</b></font>

<% if IsAccess(T_KAJITES) then %>

<p>
<table>
<tr bgcolor="#ffc1cc"><th>Kajîtes veids</th><th>Kajîðu skaits</th><th></th></tr>
<tr bgcolor="#fff1cc"><td align="center">
<select name="kajites_veids">
<%
set rKVeids = conn.execute ("select * from kajites_veidi where gid = " + cstr(gid))
while not rKVeids.eof
	Response.Write "<option value = " + cstr(rKVeids("id")) + ">" + nullprint(rKVeids("nosaukums")) + "</option>"
	rKVeids.movenext
wend
%>
</select></td>
<td align="center"><input type="text" name="skaits" size="7" value="1"></td>

	<td><input type="image" src="impro/bildes/pievienot.jpg" onclick="if (!checkBlocked()) {return false;} TopSubmit('kajite_add.asp?gid=<%=cstr(gid)%>');return false;" WIDTH="25" HEIGHT="25"></td>
</tr></table>

<%else %>

	<p>Nav tiesîbas pievienot un dzçst kajîtes</p>

<%end if %>

Kopçjamâ grupa
<%Grupas_combo_last_year 0 %><input type="submit" name="poga" value="Kopçt" onclick="return checkBlocked();">


</form>
</body>
</html>





<%
Sub PageLinks()
 for i = 1 to r.PageCount
  if cstr(p)<>cstr(i) then
   %><a href="kajite.asp?gid=<%=gid%>&p=<%=i%>">[<%=i%>]</a><%
  else
   %><b>[<%=i%>]</b><%
  end if
 next
end Sub
%>