<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))
partneris = request.form("partneris"+cstr(id))
parole = request.form("parole"+cstr(id))
epasts = request.form("epasts"+cstr(id))
'id = ucase(request.form("id"+cstr(id)))

session("message") = ""
if partneris = "" then session("message") = "Nav norâdîts partneris."
if epasts = "" then session("message") = "Nav norâdîts e-pasts."
if parole = "" then session("message") = "Nav norâdîta parole."

if len(partneris) > 255 then session("message")= "Partnera nosaukums ir pârâk garð."
if len(epasts) > 255 then session("message") = "epasts ir pârâk garð."
if len(parole) > 255 then session("message") = "Parole ir pârâk gara."
Response.Write len(parole)

if session("message") = "" then 
' Response.Write("UPDATE lietotaji_asp SET partneris = '" + partneris + "', epasts = '"+epasts+"', parole = '"+parole+"' WHERE id = " + id)
' Response.End
 conn.execute "UPDATE lietotaji_asp SET partneris = '" + partneris + "', epasts = '"+epasts+"', parole = '"+parole+"' WHERE id = " + id
end if
response.redirect "lietotaji_asp.asp"
%>


