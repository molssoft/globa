<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = trim(request.form("id"))
nosaukums = request.form("nosaukums"+cstr(id))
bilde = request.form("bilde"+cstr(id))
radit_bildi = request.form("radit_bildi"+cstr(id))
if radit_bildi = "on" then
 radit_bildi = "1"
else
 radit_bildi = "0"
end if
radit_mekl = request.form("radit_mekl"+cstr(id))
if radit_mekl = "on" then
 radit_mekl = "1"
else
 radit_mekl = "0"
end if
krasa = request.form("krasa"+cstr(id))
order_num = request.form("order_num"+cstr(id))

conn.execute ("update kategorijas set nosaukums = '"+SQLText(nosaukums)+"',bilde='"+SQLText(bilde)+"',radit_bildi = "+radit_bildi+",radit_mekl = "+radit_mekl+",order_num = "+ cstr(order_num)+",krasa='"+krasa+"' where id = '"+cstr(id))+"'"

Response.redirect "kategorijas.asp"
%>
