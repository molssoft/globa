<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

galapunkts = request.form("galapunkts"+cstr(id))
cena_txt = request.form("cena_txt"+cstr(id))
kompanija = request.form("kompanija"+cstr(id))
if request.form("specpied"+cstr(id))="on" then
 spec_pied = "1"
else
 spec_pied = "0"
end if
spec_text = request.form("spec_text"+cstr(id))
cena = request.form("cena"+cstr(id))
if cena = "" then cena = "0"
kontinents = request.form("kontinents"+cstr(id))

'response.write "update lidm_bil set galapunkts = '"+galapunkts+"',cena_txt='" + cena_txt + "',kompanija ='" + kompanija + "', specpied = "+spec_pied+",spec_text='"+spec_text+"',cena = "+cena+",kontinents='"+kontinents+"' where id = "+cstr(id)
conn.execute("update lidm_bil set galapunkts = '"+galapunkts+"',cena_txt='" + cena_txt + "',kompanija ='" + kompanija + "', specpied = "+spec_pied+",spec_text='"+spec_text+"',cena = "+cena+",kontinents='"+kontinents+"' where id = "+cstr(id))
response.redirect "avio.asp"
%>
