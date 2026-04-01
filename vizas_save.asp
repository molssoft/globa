<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

if Request.Form("action") = "iesniegts" then
 conn.execute(" insert into vizas (did,iesniegts) values ("+Request.Form("did")+",'"+sqldate(now)+"')")
end if

if Request.Form("action") = "delete" then
 conn.execute(" delete from vizas where id = "+Request.Form("id"))
end if

if Request.Form("action") = "save" then
 id = Request.Form("id")
 conn.execute(" update vizas set iesniegts = " + SQLDateQ(Request.form("iesniegts"+cstr(id))) + ", planots = " + SQLDateQ(Request.form("planots"+cstr(id))) + ",izsniegts = " + SQLDateQ(Request.form("izsniegts"+cstr(id))) + " where id = "+Request.Form("id"))
end if

if Request.Form("action") = "dokumenti_nav" then
 id = Request.Form("id")
 conn.execute(" update vizas set dokumenti_ir = 0 where id = "+Request.Form("id"))
end if

if Request.Form("action") = "dokumenti_ir" then
 id = Request.Form("id")
 conn.execute(" update vizas set dokumenti_ir = 1 where id = "+Request.Form("id"))
end if

Response.Redirect "dalibn.asp?i="+Request.Form("did")
%>