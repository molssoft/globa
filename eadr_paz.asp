<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn

id = request.querystring("id")
set r = conn.execute("select eadr_paz from dalibn where id = "+cstr(id))
if r("eadr_paz") then
 conn.execute "update dalibn set eadr_paz = 0 where id = " + cstr(id)
else
 conn.execute "update dalibn set eadr_paz = 1 where id = " + cstr(id)
end if

response.redirect "eadreses.asp"

%>