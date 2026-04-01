<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

new_id = request.form("id"+cstr(id))
temap = request.form("temap"+cstr(id))
tema = request.form("tema"+cstr(id))
marsruts = request.form("marsruts"+cstr(id))
valoda = request.form("valoda"+cstr(id))
npk = request.form("npk"+cstr(id))


conn.execute("update cl_marsruts set id = "+cstr(new_id)+", tema1 = '"+ temap +"', tema = '"+ tema +"', marsruts='" + marsruts + "', valoda='" + valoda + "', npk='" + npk + "' where id = "+cstr(id))
response.redirect "cl.asp#"+new_id
%>
