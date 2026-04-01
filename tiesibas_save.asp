<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%

dim conn
openconn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if

TiesibasID=request.form("cboTiesibas")
TiesibasNosaukums=request.form("TiesibasNosaukums")
TiesibaInfo=Request.form("TiesibaInfo")

'ieraksta mainîto nosaukumu un info tiesîbai
qstrUpdateTiesiba="UPDATE tiesibas SET nosaukums='"+TiesibasNosaukums+"', info='"+TiesibaInfo+ _
			"' WHERE id="+cstr(TiesibasID)+";"
conn.Execute qstrUpdateTiesiba

'Izmet no tiesîbu saiðu tabulas visu ar konkrçto tiesîbu
conn.Execute "DELETE FROM tiesibusaites where tiesibasID="+cstr(tiesibasID)+";"


'Òem pa jûzerim un ieraksta viòa konkrçto tiesîbu
set rstJuzeri = server.CreateObject("Adodb.recordset")
rstJuzeri.Open "SELECT id from lietotaji",conn,3,3
if rstJuzeri.RecordCount<1 then
	session("message")="Nav neviena lietotâja"
else
	for i=1 to rstJuzeri.RecordCount
		paramname="Lietotajs"+cstr(rstjuzeri("id"))
		if Request.Form(paramname)="on" then
			grantaccess rstjuzeri("id"),TiesibasID
		end if
		rstJuzeri.MoveNext
	next
end if
Response.Redirect "tiesibas.asp?tiesiba="+cstr(TiesibasID)
%>
