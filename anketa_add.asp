<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
OpenConn
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if

gid = Request.Form("gid")

braucis = Request.Form("braucis")
if braucis = "" then braucis = "NULL"
atz_marsruts = Request.Form("atz_marsruts")
if atz_marsruts = "" then atz_marsruts = "NULL"
atz_naktsmitne = Request.Form("atz_naktsmitne")
if atz_naktsmitne = "" then atz_naktsmitne = "NULL"
atz_transports = Request.Form("atz_transports")
if atz_transports = "" then atz_transports = "NULL"
atz_vaditajs = Request.Form("atz_vaditajs")
if atz_vaditajs = "" then atz_vaditajs = "NULL"
atz_gids = Request.Form("atz_gids")
if atz_gids = "" then atz_gids = "NULL"

conn.execute  "INSERT INTO anketas (gid,braucis,atz_marsruts,atz_naktsmitne,atz_transports,atz_vaditajs,atz_gids) " + _
  " VALUES ("+cstr(gid)+","+cstr(braucis)+","+cstr(atz_marsruts)+","+cstr(atz_naktsmitne)+","+cstr(atz_transports)+","+cstr(atz_vaditajs)+","+cstr(atz_gids)+")"

session("message") = "Anketa pievienota."

Response.Redirect "anketas.asp?gid="+cstr(gid)
%>

