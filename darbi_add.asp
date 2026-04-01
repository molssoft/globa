<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

dim conn
openconn
apraksts = request.form("apraksts")

Response.write "INSERT INTO darbi (apraksts,prioritate,registrets) VALUES (N'" + apraksts + "',"+request.form("prioritate")+",'"+SQLDate(Now)+"')"

conn.execute "INSERT INTO darbi (apraksts,prioritate,registrets) VALUES (N'" + apraksts + "',"+request.form("prioritate")+",'"+SQLDate(Now)+"')"

response.redirect "darbi.asp"

%>