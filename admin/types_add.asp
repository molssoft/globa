<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("new_id")
title = request.form("new_title")

conn.execute("insert into types (id,title) values ('"+id+"','"+SQLText(title)+"')" )

response.redirect "types.asp"
%>
