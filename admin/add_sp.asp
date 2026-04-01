<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("add_id")
tema1 = request.form("add_tema1")
tema = request.form("add_tema")
marsruts = request.form("add_marsruts")
valoda = request.form("add_valoda")
npk = request.form("add_npk")


conn.execute("insert into  sp_marsruts (id,tema1,tema,marsruts,valoda,npk) values ("+cstr(id)+",'"+tema1+"','"+tema+"','"+marsruts+"','"+valoda+"','"+npk+"')" )
response.redirect "sp.asp#end"
%>
