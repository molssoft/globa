<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
act = request.querystring("act")

select case act

	case 1 '---new
		pk_nos = Request.Form("pakalpojums")
		conn.execute ("insert into pakalpojums(name) values('"+nullprint(pk_nos)+"')")
		session("message") = "Pakalpojuma veids ir pievienots!"
	case 2 '---delete
		pk_id = Request.QueryString("id")
		conn.execute ("delete from pakalpojums where id="+nullprint(pk_id)+"")
		session("message") = "Pakalpojuma veids ir dzçsts!"
	case 3 '---edit
		pk_id = Request.QueryString("id")		
		if nullprint(pk_id)<>"" then
			pk_nos = Request.Form("name"+cstr(pk_id))
			conn.execute ("update pakalpojums set name = '"+pk_nos+"' where id="+nullprint(pk_id))
			session("message") = "Izmaiòas ir saglabâtas!"
		else
			session("message") = "Kïûda (id). Izmaiòas nav saglabâtas!"
		end if
end select



'--- html start ---------------------------------------------------------------------------

docstart "Pakalpojumu veidi","y1.jpg" 
%>

<center><p><font size=5 color="green"><b>Pakalpojumu veidi</b></font></p></center>
<hr>

<% 
headlinks 
DefJavaSubmit
%>
<% if session("message") <> "" then %>
	<br>
	<center><font color = red size = 3><%=session("message")%></font></center><br>
	<% session("message") = ""
end if%>

<form name="forma" method="POST">
<%

set r = server.createobject("ADODB.Recordset")

r.open "Select * from pakalpojums order by name",conn,3,3
'Set r = conn.execute("Select * from pakalpojums order by name")

if Not r.eof Then 'if r.recordcount <> 0 then
	r.movefirst
	%> 
	<center> 
	<table border=0>
	<tr bgcolor="#ffc1cc">
	<th>Nosaukums</th>
	<th></th>
	<th></th>
	</tr>
	<%
	while not r.eof
		%>
		<tr bgcolor = #fff1cc>
		
		<td align = right><input type = text name = "name<%=r("id")%>" size=30 value = "<%=r("name")%>"></td>
		
		<% if IsAccess(T_V_Pakalpojumi) then %>
		  <td align=right><input type="image" src="impro/bildes/dzest.jpg" onclick="forma.action='pakalpojumi.asp?act=2&id=<%=r("id")%>'; return confirm('Vai dzçst ierakstu?'); forma.submit();" alt = "Dzçst pakalpojuma veidu."></td>
		  <td align=right><input type="image" src="impro/bildes/saglabat.jpg" onclick="forma.action='pakalpojumi.asp?act=3&id=<%=r("id")%>'; forma.submit();" alt = "Saglabât izdarîtâs izmaiòas ðajâ rindâ." id=image1 name=image1></td>
		<% else %>
		  <td align=right></td><td align=right></td>
		<% end if %>
		</tr>
		<%
		r.MoveNext
	wend
	%></table>
	<%
else
	response.write "<center>Pakalpojumu veidi nav ievadîti!<center>"
end if

%>

<p><hr><p>

	<center><font color="GREEN" size="4"><b>Pakalpojumu veidu pievienoðana</b></font>
	<p>
	<table>
	<th bgcolor="#ffc1cc">Nosaukums<td></td></th>
	<tr>
	<td><input type = text size=30 name="pakalpojums"></td>


	<%
	if gid = "" then gid = "0"
	if vid = "" then vid = "0"
	%>
	<td><input type="image" src="impro/bildes/pievienot.jpg" 
		onclick="document.forma.action='pakalpojumi.asp?act=1'; document.forma.submit();" 
		alt = "Pievienot jaunu pakalpojumu veidu."></td>
	</tr></table>



</form>

</table>

</body>
</html>
