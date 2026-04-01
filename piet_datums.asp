<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn

pid = request.querystring("pid")

if not IsAccess(T_PIET_DAT) then
	session("message") = "Nav tiesîbu labot pieteikuma datumu"
	response.redirect("pieteikums.asp?pid="+cstr(pid))
end if

'---------- paarbauda submiteetos datus
if request.form("atcelt.x") <> "" then response.redirect("pieteikums.asp?pid="+cstr(pid))
if request.form("labot.x") <> "" then 
	
	set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
	set pieteikums = server.createobject("ADODB.recordset")
	pieteikums.CursorLocation= 3
	pieteikums.open "select * from pieteikums where id ="+cstr(pid),conn,3,3
	'pieteikums("datums") = normaldate2(request.form("datums"))
	pieteikums("datums") = FormatedTime(request.form("datums"),"dmy")
	pieteikums.update
	
	set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 	
	UpdateActionDetails old_vals,new_vals,"pieteikums",pid,""
	'CONN.EXECUTE "UPDATE PIETEIKUMS SET DATUMS = '"+SQLTimeNow(request.form("datums"))+"' WHERE ID = " + CSTR(PID)
	response.redirect("pieteikums.asp?pid="+cstr(pid))
end if

set rec = server.createobject("ADODB.Recordset") 
rec.open "select * from pieteikums where id = " + cstr(pid),conn,3,3


if pid = 0 or pid = "" then 
	session("message") = "Nav norâdîts pieteikuma nummurs"
end if
	
docstart "Pieteikuma datuma izmaiòa","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Pieteikuma datuma izmaiòa</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if pid <> 0 and pid <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Pieteikums nr. <%=cstr(pid)%></b></font>
<form name="forma" action="piet_datums.asp?pid=<%=pid%>" method="POST">
	<table border="0">
	<input type="hidden" name="sumb" value="1">
	<tr><td align="right" bgcolor="#ffc1cc"><b>Pieteikuma datums:<b></td><td bgcolor="#fff1cc"><input type="text" name="datums" size="10" value="<%=DATEPRINT(rec("datums"))%>"></td></tr>
	<tr><td colspan="2"><input type="image" name="labot" src="impro/bildes/diskete.jpg" WIDTH="25" HEIGHT="25">
	<input type="image" name="atcelt" src="impro/bildes/atcelt.jpg" WIDTH="116" HEIGHT="25"></td></tr>
	<table>
</form> 
<% end if %>

