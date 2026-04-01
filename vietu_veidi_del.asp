<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
id = getNum(Request.QueryString("id"))

set r = conn.execute("select * from vietu_veidi where id = "+cstr(id))

conn.execute "UPDATE piet_saite set vietas_veids = "+cstr(getnum(r("virsnieks")))+" WHERE vietas_veids = " + cstr(id)
conn.execute "DELETE FROM vietu_veidi where id = " + cstr(id)
	

recalc = false
if getnum(r("cena"))<>0 or getnum(r("cenaLVL"))<>0 or getnum(r("cenaUSD"))<>0 or getnum(r("cenaEUR"))<>0 then
 recalc = true
 set rPietSaite = conn.execute("SELECT DISTINCT pid FROM piet_saite WHERE deleted = 0 and vietas_veids = " + cstr(id))
 while not rPietSaite.eof
 	Pieteikums_recalculate rPietSaite("pid")
 	rPietSaite.MoveNext
 wend
end if
session("message") = "Pakalpojums dzçsts"
%>

<BODY onload="
 <% if recalc=true then Response.Write "alert('Summas pârrçíinâtas');" %>
 window.close();
 opener.location.reload();
 ">
</BODY>


