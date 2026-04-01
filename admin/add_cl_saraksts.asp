<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

marsruts_id = request.form("marsruts_id")

virsraksts = request.form("add_virsraksts")
kartas_nr = request.form("add_kartas_nr")
saturs = request.form("add_saturs")

conn.execute("insert into cl_saraksts (marshruts_id,virsraksts,kartas_nr,saturs) values ("+marsruts_id+",'"+virsraksts+"','"+kartas_nr+"','"+saturs+"')" )
response.redirect "cl_details.asp?id="+cstr(marsruts_id)
%>
