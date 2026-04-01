<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
userID=request.querystring("USER")

dim conn
openconn

If not IsAccess(T_LIETOT_ADMIN) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu lietotâju administrçðanai."
	response.redirect "default.asp"
end if



'jâieliek brîdinâjums par dzçðanu; ja apstiprinâjums jau ir, tad turpinât dzçðanu
if Request.QueryString("confirmed")="yes" then
	session("message")=""
	session("confirm")=""
	session("decline")=""
else'ja nav apstiprinâts
	session("message")="Vai Tieðâm vçlaties dzçst lietotâju?"
	session("confirm")="'Lietotajs_delete.asp?confirmed=yes&user="+cstr(userID) + "'"
	session("decline")="'lietotaji.asp?USER="+cstr(userID)+"'"
	Response.Redirect "bridinajums.asp"
end if

deleteUser(userID)
Response.Redirect("lietotaji.asp")%>