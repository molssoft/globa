<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

marshruts_id = request.form("marsruts_id")

virsraksts = request.form("virsraksts"+cstr(id))
kartas_nr = request.form("kartas_nr"+cstr(id))
saturs = request.form("saturs"+cstr(id))

conn.execute("update sp_saraksts set virsraksts = '"+virsraksts+"',kartas_nr ='"+kartas_nr+"',saturs = '"+saturs+"' where id = "+cstr(id))
response.redirect "sp_details.asp?id="+cstr(marshruts_id)
%>
