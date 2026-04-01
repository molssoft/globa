<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%
dim conn
openconn

docstart ("Iemaksu tabula","ice1.jpg")
headlinks
%>

<!------------------------------------>
<!--------Iemaksu tabula ----->
<!------------------------------------>

<!--@ 0 Iemaksu tabula -->
<% if iemsk > 0 then %>
<table border = "1">
<th></th>
<th align = "left"><strong>Maksâtâjs<strong></th>
<th align = "left"><strong>Datums<strong></th>
<th align = "right"><strong>Summa<strong></th>
<th align = "right"><strong>Valuta<strong></th>
<%
for i = 1 to iemsk
	response.write "<tr>"
	response.write("<td><a href = 'iemaksas.asp?oid="+cstr(iemaksas("id"))+"'><img src='impro/bildes/k_zals.gif'></a></td>")
	response.write "<td>"+nullprint(iemaksas("kas"))+"</td>"
	response.write "<td>"+nullprint(iemaksas("datums"))+"</td>"
	response.write "<td align = 'right'>"+nullprint(iemaksas("summaval"))+"</td>"

	response.write "<td align = 'right'>"
	if not isnull(iemaksas("valuta")) then response.write id_field("valuta",iemaksas("valuta"),"val")
	response.write "</td>"
	response.write "</tr>"
	iemaksas.movenext
next
end if
%>
</table>
</body>
</html>
