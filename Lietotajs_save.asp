<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
'atver konektu pie datubâzes
dim conn
openconn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if

	
	

CurUser = request.querystring("USER")

set rstLietotajs=server.CreateObject("Adodb.recordset")
rstLietotajs.Open "SELECT * FROM Lietotaji WHERE id="+cstr(CurUser)+";",conn,3,3

if rstLietotajs.RecordCount<>1 then
	session("message")="Tâds lietotâjs nav atrasts vai arî jau eksistç"
else
	rstlietotajs("lietotajs")=request.form("username")
	if request.form("active") = "on" then			
		rstlietotajs("Active") = 1
	else
		rstlietotajs("Active") = 0
	end if
	if request.form("bloket_globu") = "on" then			
		rstlietotajs("Bloket_globu") = 1
	else
		rstlietotajs("Bloket_globu") = 0
	end if
	rstlietotajs("vards")=request.form("vards")
	rstlietotajs("uzvards")=request.form("uzvards")
	rstlietotajs("epasts")=Request.Form("epasts")
	rstlietotajs("info")=request.form("userinfo")
	rstlietotajs("aid")=cint(Request.Form("agents"))
	rstlietotajs("kolegis")=cint(Request.Form("kolegis"))
	rstlietotajs("tel_vietejais")=Request.Form("telviet")
	rstlietotajs("tel_arejais")=Request.Form("telar")
	rstlietotajs("tel_mobilais")=Request.Form("telmob")
	rstlietotajs("parole")=Request.Form("tic_rezerv_parole")	
	rstlietotajs("skype")=Request.Form("skype")	
	rstlietotajs("adrese")=Request.Form("adrese")	
	rstlietotajs("nosaukums")= Request.Form("f_nosaukums")
	rstlietotajs.Update
end if

'tagad jâizmaina tiesîbas
'uz brîdi izmet visus ierakstus no saiðu tabulas, kas atbilst dotajam id
'un pçc tam ieraksta tikai tâs, kas ir "on"
conn.Execute "DELETE from TiesibuSaites WHERE LietotajsID="+cstr(CurUser)+";"

set rTiesibas  = conn.execute ("SELECT * FROM Tiesibas")
while not rTiesibas.eof
	if request.form("tiesiba"+cstr(rTiesibas("id")))="on" then
		conn.execute "INSERT INTO TiesibuSaites (LietotajsID,TiesibasID) VALUES ("+cstr(CurUser)+","+cstr(rTiesibas("id"))+")"
	end if
	rTiesibas.movenext
wend
session("message") = "Izmaiòas izdarîtas veiksmîgi."
Response.Redirect("lietotaji.asp?USER="+cstr(CurUser))%>