<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
OpenConn
id = Request.Form("grupa_id")
set r = conn.execute("select beigu_dat from grupa where id = "+id)
if Request.Form("polijas_dat") = "" or Request.Form("polijas_dat") = "nav info" then
 polijas_dat = "NULL" 
else
 if len(Request.Form("polijas_dat"))<=5 then
    polijas_dat = "'"+sqldate(r("beigu_dat"))+" "+Request.Form("polijas_dat")+"'"
 else
    polijas_dat = "'"+SQLTime(FormatedTime(Request.Form("polijas_dat"),"dmyhns"))+"'"
 end if
end if
conn.execute("update grupa set polijas_dat = "+polijas_dat+" where id = "+cstr(id))
Response.Redirect "grupas_gaidam.asp"
%>