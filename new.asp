<!-- #include file = "dbprocs.inc" -->

<b>abc

<%
'function OpenConn
' set conn = server.CreateObject("ADODB.Connection")
' conn.Open "DSN=globa"
'end function
%>

<%
'---- Pieslçgðanâs datubâzei
dim conn
set conn = server.CreateObject("ADODB.Connection")
conn.Open "DSN=globa"



'conn.Execute("INSERT INTO agenti (vards) VALUES ('jauns agents')")
'conn.Execute("UPDATE agenti SET vards='" + Request.Form("vards") + "' where id = 69 ")
'conn.Execute("DELETE FROM agenti where id = 69 ")

set r = conn.Execute("select id,vards from agenti where id > 60 order by vards")

%><table border = 1><%
while not r.eof
 %><tr><%
 Response.Write "<td>" + cstr(r("id")) + "</td>"
 Response.Write "<td>" + r("vards") + "</td>"
 r.movenext
 %></tr><%
wend
%>
</table>

<form action="new.asp" method=POST>
 <input type = text name=vards>
 <input type = submit>
</form>


<b>abc
<b>abc
<b>abc
<b>abc
<b>abc

