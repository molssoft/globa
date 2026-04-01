<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
kajites_veids = getnum(request.form("kajites_veids"))
skaits = getnum(request.form("skaits"))
'---- nosaka vietu skaitu
set r = conn.execute("SELECT vietas FROM kajites_veidi where id = " + cstr(kajites_veids))
for i = 1 to skaits
conn.execute "INSERT INTO kajite (gid,vietas,veids) VALUES (" + cstr(session("LastGid")) + "," + cstr(r("vietas"))+"," + cstr(kajites_Veids) + ")"
next
response.redirect "kajite.asp?gid="+cstr(session("lastgid"))
%>


