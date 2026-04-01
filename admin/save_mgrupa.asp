<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

mgrupa_id = request.form("mgrupa_id")

id = request.form("id"+cstr(mgrupa_id))
nosaukums = request.form("nosaukums"+cstr(mgrupa_id))
gr_nosaukums = request.form("gr_nosaukums"+cstr(mgrupa_id))
galva = request.form("galva"+cstr(mgrupa_id))
karte = request.form("karte"+cstr(mgrupa_id))
sadala = request.form("sadala"+cstr(mgrupa_id))
npk = request.form("npk"+cstr(mgrupa_id))
citats = request.form("citats"+cstr(mgrupa_id))

conn.execute("update mgrupas set nosaukums = '"+nosaukums+"',gr_nosaukums = '"+gr_nosaukums+"',galva = '"+galva+"',karte = '"+karte+"',sadala = '"+sadala+"',npk = '"+npk+"', citats='"+citats+"' where id = '"+cstr(mgrupa_id)+"'")

response.redirect "default.asp"
%>
