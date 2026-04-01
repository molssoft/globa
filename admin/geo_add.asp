<!-- #include file = "../conn.asp" -->
<!-- #include file = "../procs.asp" -->

<%
dim conn
openconn

id = Request.form("id")
if not conn.execute("select * from geo where id = '"+id+"'").eof then
 session("message") = "Identifikators aizòemts."
 Response.Redirect "message.asp"
end if
parent = Request.form("parent")
if parent = "" then
 parent = "NULL" 
else
 parent = "'"+parent+"'"
end if

type_id = Request.form("type_id")
title = SQLText(Request.form("title"))
viesnicas = Request.Form("viesnicas")
if viesnicas = "on" then
 viesnicas = "1" 
else
 viesnicas = "0"
end if

conn.execute ("INSERT INTO geo (id,parent_id,type_id,title,viesnicas) VALUES ('"+ucase(id)+"',"+parent+",'"+type_id+"','"+title+"',"+viesnicas+")")
Response.Redirect "geo.asp?parent="+Request.form("parent")
%>
