<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<% 

'atver konektu pie datubâzes
dim Conn
OpenConn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if



docstart "Lietotâja tiesîbas " +cstr(get_user),"y1.jpg" %>
<center><font color="GREEN" size="5"><b>Lietotâja tiesîbas <%=get_user%></b></font><hr>
<% headlinks 
DefJavaSubmit


%>


<% if session("message") <> "" then %>
<br><font size="5" color="red"><%=session("message")%></font><br>
<%
session("message") = "" 
end if
%>

<script>
	function  changeuserlink(){
		var ann=forma.cbo.value;
		window.location.href="lietotaji.asp?USER="+ann;
	}
</script>


<form name="forma" method="POST">
<center><BR>
<select name="cboLietotaji" id="cbo" onchange="changeuserlink();">

<%
requestedUser=clng(request.querystring("USER"))

'atlasa visus lietotâjus lietotâju combo
set rstLietotaji=server.createobject("Adodb.recordset")
rstLietotaji.open "SELECT id,lietotajs,vards,uzvards,epasts FROM lietotaji ORDER BY lietotajs",conn,3,3
if rstLietotaji.RecordCount<>0 then
	if requestedUser=0 then 'jâizraugâs pirmais jûzeris no 
		curUser=rstLietotaji("id")
	else
		curUser=requestedUser
	end if
end if

while not rstLietotaji.eof
	if rstLietotaji("id")=curuser then' izraugâs, kurð cbobox bûs selektçtais
		selectwrite=" selected"
	else
		selectwrite=""
	end if
	response.write "<option value="+cstr(rstlietotaji("id"))+selectwrite+">("+rstLietotaji("lietotajs")+") "+rstLietotaji("vards")+" "+rstLietotaji("uzvards")+"</option>"
	rstLietotaji.movenext
wend
%>
</select>

<%
'tagadît atlasa datus par lietotâju, kas ir fokusâ combo boxâ
set rstUser=server.CreateObject("adodb.recordset")
qstrAllUsers="SELECT * FROM Lietotaji WHERE id="+cstr(clng(curuser))
rstUser.Open qstrAllUsers,conn,3,3

if rstUser.RecordCount<>0 then
	LietVards=rstuser("lietotajs")
	Active=rstuser("active")
	Bloket_globu=rstuser("bloket_globu")
	Vards=rstuser("vards")
	Uzvards=rstuser("uzvards")	
	Epasts=rstuser("epasts")
	Piezimes=rstuser("info")
	Agents=rstuser("aid")
	Kolegis=rstuser("kolegis")
	telviet=rstuser("tel_vietejais")
	telar=rstuser("tel_arejais")
	telmob=rstuser("tel_mobilais")
	tic_rezerv_parole=rstuser("parole")	
	skype = rstuser("skype")	
	'--- pievienoti lauki agentu lietotajiem, lai attelotu kipras vaucherii. 28.02.2014
	nosaukums = Replace(nullprint(rstuser("nosaukums")), """", "'")
	adrese = Replace(nullprint(rstuser("adrese")), """", "'")
else
	LietVards=""
	Vards=""
	Epasts=""
	Piezimes=""
	Agents=0
end if

%>
<table>
	<tr>
		<td bgcolor="ffc1cc">Lietotâja vârds:</td>
		<td bgcolor="fff1cc"><input type="text" name="username" style="width:300px" value="<%=Lietvards%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Aktîvs</td>
		<td bgcolor="fff1cc"><input type="checkbox" name="active" 
			<% if Active then response.write " checked " %>></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Bloíçt Globu</td>
		<td bgcolor="fff1cc"><input type="checkbox" name="bloket_globu" 
			<% if Bloket_globu then response.write " checked " %>></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Firmas nosaukums<br>(aìentiem):</td>
		<td bgcolor="fff1cc"><input type="text" name="f_nosaukums" style="width:300px" value="<%=nosaukums%>" maxlength="128"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Adrese (aìentiem):</td>
		<td bgcolor="fff1cc"><input type="text" name="adrese" style="width:420px" value="<%=adrese%>" maxlength="512"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Personas vârds:</td>
		<td bgcolor="fff1cc"><input type="text" name="vards" style="width:300px" value="<%=vards%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Personas uzvârds:</td>
		<td bgcolor="fff1cc"><input type="text" name="uzvards" style="width:300px" value="<%=uzvards%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">E-pasta adrese:</td>
		<td bgcolor="fff1cc"><input type="text" name="epasts" style="width:300px" value="<%=epasts%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Vietçjais tel nr:</td>
		<td bgcolor="fff1cc"><input type="text" name="telviet" style="width:300px" value="<%=telviet%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Ârçjais tel nr:</td>
		<td bgcolor="fff1cc"><input type="text" name="telar" style="width:300px" value="<%=telar%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Mobilais tel nr:</td>
		<td bgcolor="fff1cc"><input type="text" name="telmob" style="width:300px" value="<%=telmob%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Skype vârds:</td>
		<td bgcolor="fff1cc"><input type="text" name="skype" style="width:300px" value="<%=skype%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Piezîmes:</td>
		<td bgcolor="fff1cc"><textarea cols="50" rows="3" name="Userinfo"><%=Piezimes%></textarea></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Aìents</td>
		<td bgcolor="fff1cc">
		 <select name=agents>
		  <% 
		  set rAg = conn.execute ("select * from agenti order by vards")
		  %><option value=0>-<%
		  while not rAg.eof
		   %><option <%if agents=rAg("id") then Response.Write " selected "%> value=<%=rAg("id")%>><%=decode(rAg("vards"))%></option><%
		   rAg.movenext 
		  wend
		  %>
		 </select>
		</td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Aìenta parole online<br>rezervâcijas sistçmâ:</td>
		<td bgcolor="fff1cc"><input type="password" name="tic_rezerv_parole" style="width:300px" value="<%=tic_rezerv_parole%>"></td>
	</tr>
	<tr>
		<td bgcolor="ffc1cc">Kolçìis</td>
		<td bgcolor="fff1cc">
		 <select name=kolegis>
		  <% 
		  set rAg = conn.execute ("select * from lietotaji order by vards")
		  %><option value=0>-<%
		  while not rAg.eof
		   %><option <%if Kolegis=rAg("id") then Response.Write " selected "%> value=<%=rAg("id")%>><%Response.write(decode(rAg("vards"))&" "&decode(rAg("uzvards")))%></option><%
		   rAg.movenext 
		  wend
		  %>
		 </select>
		</td>
	</tr>
</table>
 
<!--Pogas izmaiòu ieglabâðanai-->
<center>
 
<input type="image" src="impro/bildes/pievienot.jpg" alt="Pievienot kâ jaunu lietototâju" onclick="TopSubmit('Lietotajs_add.asp')" WIDTH="25" HEIGHT="25">
<% if rstUser.RecordCount<>0 then  %>
	<input type="image" src="impro/bildes/diskete.jpg" alt="Saglabât izmaiòas par tekoðo lietotâju" onclick="TopSubmit('Lietotajs_save.asp?USER=<%=CurUser%>')" WIDTH="25" HEIGHT="25">
	<input type="image" src="impro/bildes/dzest.jpg" alt="Dzçst tekoðo lietotâju no saraksta" onclick="TopSubmit('Lietotajs_delete.asp?USER=<%=CurUser%>')" WIDTH="25" HEIGHT="25">
<% end if %>
</center>
 
 
<%
'atlasa administrçjamâ lietotâja tiesîbas
set rstTiesibas=server.CreateObject("adodb.recordset")
rsttiesibas.Open "Select * FROM tiesibas ORDER BY Nosaukums",conn,3,3
%>
 <!--tabula ar tiesîbâm-->
 <p>	
 <table cols="3">
 <tr bgcolor="#ffc1cc"><th>Tiesîbas</th><th>Ir vai nav</th><th></th></tr>

<%
while not rstTiesibas.eof 
	'pirmâ kolonna-tiesîbu nosaukums
	response.write "<tr bgcolor=""#fff1cc""><td>"+rstTiesibas("nosaukums")+"</td>"
	'otrâ kolonna - ir vai nav dotâ tiesîba
	irTies="   "
	if IsUserAccess(curuser,rstTiesibas("id"))=true then irties=" checked" 'vai íeksis liekams vai nç
		%>
		<td><center><input type="checkbox" <%=irTies%> name="tiesiba<%=cstr(rstTiesibas("id"))%>"></center></td>
		<%
	'treðâ kolonna
	pogaskods="<a href=""tiesibas.asp?tiesiba="+cstr(rstTiesibas("id"))+chr(34)+"><image src=""impro/bildes/meklet.jpg"" border=""0""></a>"
	Response.Write "<td>"+pogaskods+"</td></tr>"
	rstTiesibas.movenext
wend
%>
 

 
</table>
</form>
</body>
</html>