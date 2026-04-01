'<!-- #includ file = "../conn.asp" -->
'<!-- #includ file = "procs.asp" -->
fdhgdfhgfgh
<%
'dim conn
'openconn

mgrupa = request.form("mgrupa")
if mgrupa = "" then mgrupa = "X"
nosaukums = request.form("nosaukums")
if nosaukums = "" then nosaukums = "Jauns marðruts."

conn.execute "INSERT INTO marsruti (mgrupa,nosaukums) VALUES ('"+mgrupa+"','"+nosaukums+"')" 
response.redirect "marsruts.asp?id="+cstr(conn.execute("select max(id) from marsruti")(0))
%>