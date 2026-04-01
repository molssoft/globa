<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai. "+NULLPRINT(Get_User())
	response.redirect "default.asp"
end if


docstart "Tiesîbas","y1.jpg"%>
<center><font color="GREEN" size="5"><b>Tiesîbas</b></font><hr>
<%headlinks
DefJavaSubmit
'atver konektu pie datubâzes



'tagad jâieraksta combo box ar visâm esoðajâm tiesîbâm un jâfokusç uz to, kas 
'nodota, izsaucot ðo lapu
%>
<script language="vbscript">
	sub changeuserlink
		ann=forma.cbo.value
		ahrefTiesiba.href="tiesibas.asp?tiesiba="+cstr(ann)
	end sub
</script>
<form name="forma" method="POST">
<center>
<select name="cboTiesibas" onchange="changeuserlink" language="vbscript" id="cbo">
<%
pd=chr(34)
'curNosaukums=""
curtiesiba=clng(request.querystring("tiesiba"))
if curTiesiba=0 then curTiesiba=1 end if

Response.Write "aaa:" +cstr( curtiesiba)
'atlasa visas tiesîbas priekð tiesîbu combo
set rstTiesibas=server.CreateObject("Adodb.recordset")
rstTiesibas.Open "Select * FROM tiesibas ORDER BY Nosaukums",conn,3,3
if rstTiesibas.RecordCount>0 then
	for i=1 to rstTiesibas.RecordCount
		'izraugâs, kas bûs redzams combo logâ
		if rstTiesibas("id")=curTiesiba then
			selectwrite=" "+"selected"
			curNosaukums=rstTiesibas("nosaukums")
			Piezimes=rstTiesibas("info")
		else
			selectwrite=""
		end if
		toWrite="<option value="+pd+cstr(rstTiesibas("id"))+pd+selectwrite+">"+rsttiesibas("nosaukums")+"</option>"
		Response.Write toWrite
		rstTiesibas.MoveNext
	next
end if
%>
</select><a href name="ahrefTiesiba"><img src="impro/bildes/meklet.jpg" border="0" WIDTH="25" HEIGHT="25"></a><p>

Tiesîbas nosaukums:<br><input type="text" style="width:400px" name="TiesibasNosaukums" value="<%=curNosaukums%>"><p>
Piezîmes:<br>
<textarea cols="50" rows="3" name="TiesibaInfo"><%=Piezimes%></textarea><p>

<!--poga izmaiòu saglabâðanai-->
<input type="image" src="impro/bildes/diskete.jpg" onclick="TopSubmit('tiesibas_save.asp')" alt="Saglabât izmaiòas lietotâju tiesîbâs" WIDTH="25" HEIGHT="25"><p>

<table cols="3">
 <tr bgcolor="#ffc1cc"><th>Lietotâjs</th><th>Ir vai nav</th><th></th></tr>
<%'tagad jâieraksta visi lietotâji pie dotâs tiesîbas
set rstLietotaji=server.CreateObject("Adodb.recordset")
qstrLiet="SELECT id,lietotajs FROM lietotaji order by lietotajs"
rstLietotaji.open qstrliet,conn,3,3
if rstLietotaji.RecordCount>0 then
	for i=1 to rstLietotaji.RecordCount
		'pirmâ kolonna
		strToWrite="<tr bgcolor=""#fff1cc""><td>"+rstLietotaji("lietotajs")+"</td>"
		Response.Write strToWrite
		'otrâ kolonna
		irties=" "
		if isUserAccess(rstLietotaji("id"),curTiesiba)=true then irties=" checked "'vai íeksis liekams vai nç
		selected=" "+cstr(irTies)
		strToWrite2="<td><center><input type=""checkbox"" name="+pd+"Lietotajs"+cstr(rstlietotaji("id"))+pd+irties+"></center></td>"
		Response.Write strToWrite2
		'treðâ kolonna
		strToWrite3="<td><a href="+pd+"lietotaji.asp?USER="+cstr(rstlietotaji("id"))+pd+"><image src="+pd+"impro/bildes/meklet.jpg"+pd+" border="+pd+"0"+pd+"></a></td></tr>"
		Response.Write strToWrite3
		rstLietotaji.MoveNext
	next
end if
%>
</form>
</body>
</html>