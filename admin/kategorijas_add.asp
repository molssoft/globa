<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = ucase(request.form("new_id"))
nosaukums = request.form("new_nosaukums")
bilde = request.form("new_bilde")
radit_bildi = request.form("new_radit_bildi")
if radit_bildi = "on" then
 radit_bildi = "1"
else
 radit_bildi = "0"
end if
order_num = request.form("new_order_num")

conn.execute("insert into kategorijas (id,nosaukums,bilde,radit_bildi,order_num) values ('"+id+"','"+SQLText(nosaukums)+"','"+SQLText(bilde)+"',"+radit_bildi+","+cstr(order_num)+")" )

response.redirect "kategorijas.asp"
%>
