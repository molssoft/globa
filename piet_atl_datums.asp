<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn

pid = request.querystring("pid")
id = request.querystring("id")

if not IsAccess(T_PIET_ATL_DAT) then
	session("message") = "Nav tiesîbu labot pieteikuma atlaides datumu"
	response.redirect("pieteikums.asp?pid="+cstr(pid))
end if

'---------- paarbauda submiteetos datus
if request.form("atcelt.x") <> "" then response.redirect("pieteikums.asp?pid="+cstr(pid))
if request.form("labot.x") <> "" then 
	CONN.EXECUTE "UPDATE piet_atlaides SET need_check = 1, DATUMS = '"+SQLDATE(request.form("datums"))+"' WHERE id = " + CSTR(ID)
	response.redirect("pieteikums.asp?pid="+cstr(pid))
end if

set rec = server.createobject("ADODB.Recordset") 
rec.open "select * from piet_atlaides where id = " + cstr(id),conn,3,3



if id = 0 or id = "" then 
	session("message") = "Nav norâdîts pieteikuma nummurs"
end if
	
docstart "Pieteikuma atlaides datuma izmaiòa","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pieteikuma atlaides datuma izmaiòa</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if id <> 0 and id <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Pieteikums nr. <%=cstr(pid)%></b></font>
<form name="forma" action="piet_atl_datums.asp?pid=<%=pid%>&id=<%=id%>" method="POST">
	<table border="0">
	<input type="hidden" name="sumb" value="1">
	<tr><td align="right" bgcolor="#ffc1cc"><b>Pieteikuma atlaides datums:<b></td><td bgcolor="#fff1cc"><input type="text" name="datums" size="10" value="<%=DATEPRINT(rec("datums"))%>"></td></tr>
	<tr><td colspan="2"><input type="image" name="labot" src="impro/bildes/diskete.jpg" WIDTH="25" HEIGHT="25">
	<input type="image" name="atcelt" src="impro/bildes/atcelt.jpg" WIDTH="116" HEIGHT="25"></td></tr>
	<table>

</form> 
<% end if %>

