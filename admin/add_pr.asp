<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("add_id")
kompanija = request.form("add_kompanija")
valsts = request.form("add_valsts")
marsruts = request.form("add_marsruts")

conn.execute("insert into  pr_marsruts (id,kompanija,valsts,marsruts) values ("+cstr(id)+",'"+kompanija+"','"+valsts+"','"+marsruts+"')" )
'response.write  "insert into lidm_bil (galapunkts,cena_txt,kompanija,specpied,spec_text) values ('"+galapunkts+"','"+cena_txt+"','"+kompanija+"',"+spec_pied+",'"+spec_text+"')" 
response.redirect "pr.asp"
%>
