<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim headings(10)
dim conn
openconn
oid = request.querystring("oid")
if oid = "" then message = "Nav norâdîts iemaksas ordera numurs"
%>

<% docstart "Iemaksas","ice1.jpg" %>
<center><font color="#FF0000" size="5"><b><i>Iemaksas</i></b></font><hr>
<% headlinks
if message <> "" then response.write "<big>"+Message+"</big>"
%>
<table border = "1">
<tr>
<td><strong>Ordera nummurs: </strong></td><td><%=id_field("orderis",oid,"num")%></td>
</tr><tr>
<td><strong>Datums: </strong></td><td><%=id_field("orderis",oid,"datums")%></td>
</tr><tr>
<td><strong>Maksâtâjs: </strong></td><td><%=id_field("orderis",oid,"kas")%></td>
</tr><tr>
<td><strong>Pamatojums: </strong></td><td><%=id_field("orderis",oid,"pamatojums")%></td>
</tr><tr>
<td><strong>Pielikumâ: </strong></td><td><%=id_field("orderis",oid,"pielikums")%></td>
</tr><tr>
<td><strong>Kredîta konts </strong></td><td align = 'right'><%=id_field("orderis",oid,"kredits")%></td>
</tr><tr>
<td><strong>Debeta konts </strong></td><td align = 'right'><%=id_field("orderis",oid,"debets")%></td>
</tr><tr>
<td><strong>Summa </strong></td><td align = 'right'><%=id_field("orderis",oid,"summaval")%></td>
</tr><tr>
<td><strong>Valûta </strong></td><td align = 'right'><%=id_field("valuta",id_field("orderis",oid,"valuta"),"val")%></td>
</tr>
<table>
</body>
</html>
