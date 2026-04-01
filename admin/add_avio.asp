<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

galapunkts = request.form("add_galapunkts")
cena_txt = request.form("add_cena_txt")
kompanija = request.form("add_kompanija")
if request.form("add_specpied")="on" then
 spec_pied = "1"
else
 spec_pied = "0"
end if
spec_text = request.form("add_spec_text")
cena = request.form("add_cena")
if cena = "" then cena = "0"
kontinents = request.form("add_kontinents")

conn.execute("insert into lidm_bil (galapunkts,cena_txt,kompanija,specpied,spec_text,cena,kontinents) values ('"+galapunkts+"','"+cena_txt+"','"+kompanija+"',"+spec_pied+",'"+spec_text+"',"+cena+",'"+kontinents+"')" )
'response.write  "insert into lidm_bil (galapunkts,cena_txt,kompanija,specpied,spec_text,cena,kontinents) values ('"+galapunkts+"','"+cena_txt+"','"+kompanija+"',"+spec_pied+",'"+spec_text+"',"+cena+",'"+kontinents+"')" 
response.redirect "avio.asp"
%>
