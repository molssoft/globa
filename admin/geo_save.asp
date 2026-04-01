<!-- #include file = "../conn.asp" -->
<!-- #include file = "../procs.asp" -->

<%
dim conn
openconn

id = Request.form("id")
parent = Request.form("parent")
new_parent = Request.form("new_parent")
if new_parent = "" then 
 new_parent = "NULL"
else
 new_parent = "'"+new_parent+"'"
end if

type_id = Request.form("type_id")
title = SQLText(Request.form("title"))
bilde = SQLText(Request.form("bilde"))
if bilde = "" then bilde = "NULL" else bilde = "'" + bilde + "'"
viesnicas = Request.Form("viesnicas")
if viesnicas = "on" then
 viesnicas = "1" 
else
 viesnicas = "0"
end if

conn.execute  "UPDATE geo set type_id='"+type_id+"',title='"+SQLText(title)+"',parent_id="+new_parent+",bilde="+bilde+",viesnicas="+viesnicas+" WHERE id = '"+id+"'"
Response.Redirect "geo.asp?parent="+Request.form("parent")
%>
