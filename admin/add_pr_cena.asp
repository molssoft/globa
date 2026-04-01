<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

marsruts_id = request.form("marsruts_id")

klase = request.form("add_klase")
klases_apraxts = request.form("add_klases_apraxts")
vecums = request.form("add_vecums")
dienas = request.form("add_dienas")
laiki = request.form("add_laiki")
cena = request.form("add_cena")

conn.execute("insert into pr_cenas (marshruts_id,klase,klases_apraxts,vecums,dienas,laiki,cena) values ("+cstr(marsruts_id)+",'"+klase+"','"+klases_apraxts+"','"+vecums+"','"+dienas+"','"+laiki+"','"+cena+"')" )
response.redirect "pr_details.asp?id="+cstr(marsruts_id)
%>
