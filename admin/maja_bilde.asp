<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.querystring("id")

set r = conn.execute("select * from bildes where id <> 1 order by cels")
%><center>
<font size=6>Izvçlieties naktsmâju attçlu:</font><br><br>
<table width = 250><tr></td><%
while not r.eof
 %><a href="bilde_izv.asp?bilde=<%=r("id")%>&id=<%=id%>"><img border=0 src="http://www.impro.lv/<%=r("cels")%>" height=50 width=50></a><%
 r.movenext
wend
%>
</td></tr></table>