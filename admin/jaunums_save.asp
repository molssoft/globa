<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "procs.asp" -->

<%

dim conn
openconn
id = getNum(Request.QueryString("id"))
virsraksts = Dubultot(request.form("virsraksts"+cstr(id)),"'")
s_datums = request.form("s_datums"+cstr(id))
b_datums = request.form("b_datums"+cstr(id))
iis = Dubultot(request.form("iis"+cstr(id)),"'")
'apraksts = Dubultot(request.form("apraksts"+cstr(id)),"'")
apraksts = request.form("apraksts"+cstr(id))
bilde1 = request.form("bilde1"+cstr(id))
bilde2 = request.form("bilde2"+cstr(id))
ipass = request.form("ipass"+cstr(id))
if ipass = "on" then ipass = "true" else ipass = "false"

session("message") = ""

if virsraksts = "" then session("message") = "Jaunuma virsraksts nevar bût tukðs."
if len(virsraksts) > 200 then session("message") = "Jaunuma visraksts ir pârâk garð."
if apraksts = "" then session("message") = "Jaunuma apraksts nevar bût tukðs."
if len(bilde1) > 50 then session("message") = "1. attçla nosaukums ir pârâk garð."
if len(bilde2) > 50 then session("message") = "2. attçla nosaukums ir pârâk garð."
query = "UPDATE jaunumi SET virsraksts = '" + virsraksts + "', "
if not isnull(sqldate(s_datums)) and s_datums <> "" then 
	query = query + "s_datums = '" +sqldate(s_datums)+"'" 
else
	query = query + "s_datums = NULL" 
end if

if not isnull(sqldate(b_datums)) and b_datums <> "" then 
	query = query + ",b_datums = '" +sqldate(b_datums)+"'" 
else
	query = query + ",b_datums = NULL" 
end if
query = query + ", iis = '"+iis+"'"
query = query + ", bilde1 = '"+bilde1+"', bilde2 = '"+bilde2+"', ipass = "+ipass+"  WHERE id = " + cstr(id)

set r = server.CreateObject("adodb.recordset")
r.Open "select * from jaunumi where id = "+cstr(id),conn,3,3
r("apraksts") = apraksts
r.Update
'response.write query
if session("message") = "" then conn.execute Query
response.redirect "jaunumu_lab.asp"
%>


