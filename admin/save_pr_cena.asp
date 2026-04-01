<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

marsruts_id = request.form("marsruts_id")

klase = request.form("klase"+cstr(id))
klases_apraxts = request.form("klases_apraxts"+cstr(id))
vecums = request.form("vecums"+cstr(id))
dienas = request.form("dienas"+cstr(id))
laiki = request.form("laiki"+cstr(id))
cena = request.form("cena"+cstr(id))

conn.execute("update pr_cenas set klase = '"+klase+"',klases_apraxts='" + klases_apraxts + "',vecums ='" + vecums + "', dienas = '"+dienas+"',laiki='"+laiki+"',cena='"+cena+"' where id = "+cstr(id))
response.redirect "pr_details.asp?id="+cstr(marsruts_id)
%>
