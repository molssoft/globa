<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
gid=Request.QueryString("gid")+""
if gid="" then
	message = "Nav norādīta grupa!"
else
	message = "<a href = 'pieteikumi.asp"+qstring()+"'> Grupas saraksts </a><br>" + grupas_nosaukums(gid,NULL)
end if
poga_var = request.form("poga")

query = " SELECT dalibn.* , Pieteikums.id as pid, Pieteikums.gid, Pieteikums.datums " + _
" FROM dalibn INNER JOIN (Pieteikums INNER JOIN piet_saite ON Pieteikums.id = piet_saite.pid) ON dalibn.ID = piet_saite.did " + _
"WHERE pieteikums.gid = "+cstr(gid)+" AND (piet_saite.deleted = 0) "

if request.form ("sort") = "datums" then
	query = query + "ORDER BY pieteikums.datums; "
else
	query = query + "ORDER BY dalibn.uzvards; "
end if
	
set rec = server.createobject("ADODB.Recordset")
rec.open query,conn,3,3
%>

<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<META NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080">

<center>
<font size="4"><%=message%></font>

<% if rec.recordcount > 0 then %>
<table border = "1" align = left width = 100%>
<%
col = 1
rec.movefirst
while not rec.eof
pid=rec("pid")
did=rec("id")
%>

<% if col = 1 then %>
<tr><td>
<%=ucase(nullprint(rec("vards")))+" "+ucase(nullprint(rec("uzvards")))%><br>
<%=ucase(nullprint(rec("adrese")))%><br>
<%=ucase(nullprint(rec("pilseta")))+" "%>

<% if rec("indekss")<>"" and not isnull(rec("indekss")) then %>
<br>LV - <%=ucase(nullprint(rec("indekss")))%>
<% end if %>
</td>
<% 
rec.movenext
col = 2
end if 

if col = 2 and not rec.eof then %>
<td>
<%=ucase(nullprint(rec("vards")))+" "+ucase(nullprint(rec("uzvards")))%><br>
<%=ucase(nullprint(rec("adrese")))%><br>
<%=ucase(nullprint(rec("pilseta")))+" "%>

<% if rec("indekss")<>"" and not isnull(rec("indekss")) then %>
<br>LV - <%=ucase(nullprint(rec("indekss")))%>
<% end if %>
</td><% 
rec.movenext
col = 3
end if 


if col = 3 and not rec.eof then %>
<td>
<%=ucase(nullprint(rec("vards")))+" "+ucase(nullprint(rec("uzvards")))%><br>
<%=ucase(nullprint(rec("adrese")))%><br>
<%=ucase(nullprint(rec("pilseta")))+" "%>

<% if rec("indekss")<>"" and not isnull(rec("indekss")) then %>
<br>LV - <%=ucase(nullprint(rec("indekss")))%>
<% end if %>
</td></tr>
<% col =1
end if %>

<%
lastpid = pid
lastdid = did
if not rec.eof then rec.movenext
i = i+1
wend
%>
</table>
<% else %>
<font color = "BLACK" size = "5"><BR><BR>Grupā dalībnieki nav pieteikušies</font>
<% end if %>

</BODY>
</HTML>
