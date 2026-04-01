<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("klub_gal_id")

maza_adr = request.form("maza_adr"+cstr(id))
liela_adr = request.form("liela_adr"+cstr(id))
apraksts = request.form("apraksts"+cstr(id))

conn.execute("update klub_gal set maza_adr = '"+maza_adr+"', liela_adr='"+liela_adr+"', apraksts = '"+apraksts+"' where id = "+cstr(id))

response.redirect "klub_gal.asp?id="+id
%>
