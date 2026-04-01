<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = ucase(request.form("id"))
partneris = request.form("partneris")
epasts = request.form("epasts")
parole = request.form("parole")
session("message") = ""

if partneris = "" then session("message") = "Nav norâdîts partneris."
if epasts = "" then session("message") = "Nav norâdîts epasts."
if parole = "" then session("message") = "Nav norâdîta parole."

if len(partneris)>255 then session("message")="Partnera nosaukums pârâk garð."
if len(epasts) > 255 then session("message") = "E-pasts ir pârâk garð."
if len(parole) > 255 then session("message") = "Parole ir pârâk gara."

if session("message") = "" then conn.execute "INSERT INTO lietotaji_asp (partneris,epasts,parole) VALUES (N'" + partneris + "',N'" + epasts + "',N'"+parole+"')"
response.redirect "lietotaji_asp.asp"
%>


