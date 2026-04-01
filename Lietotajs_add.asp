<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if



UserName = request.form("username")

set rstLietotajs = conn.execute("SELECT lietotajs FROM Lietotaji WHERE lietotajs='"+UserName+"';")
if not rstLietotajs.eof then
	session("message")="Tâds lietotâjs jau eksistç"
	Response.Redirect("lietotaji.asp")
else
	conn.execute "INSERT into Lietotaji (lietotajs,info,aid,epasts,vards,uzvards,kolegis,tel_vietejais,tel_arejais,tel_mobilais,parole,skype) values ('"+username+"','"+request.form("userinfo")+"',"+Request.Form("agents")+",'"+request.Form("epasts")+"','"+request.Form("vards")+"','"+request.Form("uzvards")+"',"+cstr(request.Form("kolegis"))+",'"+request.Form("telviet")+"','"+request.Form("telar")+"','"+request.Form("telmob")+"','"+request.Form("tic_rezerv_parole")+"','"+request.Form("skype")+"');"
	newuserid = conn.execute ("select id from lietotaji where lietotajs = '"+username+"'")(0)
end if

'tagad jâizmaina tiesîbas
'ieraksta tikai tâs, kas ir "on"

set rTiesibas  = conn.execute ("SELECT * FROM Tiesibas")
while not rTiesibas.eof
	if request.form("tiesiba"+cstr(rTiesibas("id")))="on" then
		conn.execute "INSERT INTO TiesibuSaites (LietotajsID,TiesibasID) VALUES ("+cstr(newUserId)+","+cstr(rTiesibas("id"))+")"
	end if
	rTiesibas.movenext
wend
session("message") = "Jauns lietotâjs pievienots veiksmîgi."
Response.Redirect("lietotaji.asp?USER="+cstr(newUserId))
%>
