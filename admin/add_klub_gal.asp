<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("klub_gal_id")

maza_adr = request.form("maza_adr")
liela_adr = request.form("liela_adr")
apraksts = request.form("apraksts")

conn.execute("insert into klub_gal (maza_adr,liela_adr,apraksts) values ('"+maza_adr+"','"+liela_adr+"','"+apraksts+"')" )

response.redirect "klub_gal.asp?id="+id
%>
