<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

marsruts_id = request.form("marsruts_id")

virsraksts = request.form("add_virsraksts")
kartas_nr = request.form("add_kartas_nr")

conn.execute("insert into pr_saraksts (marshruts_id,virsraksts,kartas_nr,saturs) values ("+marsruts_id+",'"+virsraksts+"','"+kartas_nr+"')" )
response.redirect "pr_details.asp?id="+cstr(marsruts_id)
%>
