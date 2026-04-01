<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

set rKaj = conn.execute("SELECT ID FROM Kajite WHERE veids = " + cstr(id))
while not rKaj.eof 
	Del_Kajite rKaj("id")
	rKaj.movenext
wend
conn.execute "DELETE FROM kajites_veidi WHERE id = " + cstr(id)


response.redirect "kajites_veidi.asp?gid="+cstr(Request.Form("mygid"))

%>


