<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<% docstart "Tûrisma informâcijas sistçma - Globa Tûr","y1.jpg" 

Dim conn
OpenGlobaConn()

if Request.Form("submit")=1 then

	username = Request.Form("username")
	password = Request.Form("password")
	
	if username = "" or password = "" then
		message = "Lûdzu aizpildiet visus laukus."		
	else
		set rlogin = conn.execute("select * from lietotaji where lower(lietotajs)=lower('"+username+"')")
		if not rlogin.eof then 
			if rlogin("parole") = "" then
				conn.execute("update lietotaji set parole = '"+replace(password,"'","''")+"' where lietotajs='"+username+"'")
			end if
		end if

		set r = conn.execute("select * from lietotaji where lower(lietotajs)=lower('"+username+"') and parole='"+replace(password,"'","''")+"'")
		if not r.eof then
			Session("user_name") = username
			%>
				<form method=POST id=forma name=forma action=login.php>
				<input type=hidden name=username value="<%=username%>">
				<input type=hidden name=password value="<%=password%>">
				</form>
				<script>
					forma.submit();
				</script>
			<%
			''Response.redirect("default.asp")
			Response.End
		else
			message = "Nevar pieslçgties datubâzei. Nepareizs lietotâjvârds vai parole."
		end if
	end if

end if

%>

<center><img src="impro/bildes/globatur.jpg" WIDTH="417" HEIGHT="70"><br>
<img src="impro/bildes/turisma.jpg" WIDTH="417" HEIGHT="26"><br>
<br><br><br>

<% 
if message <> "" then
	%><font color=red><%=message%></font><BR><BR><%
end if
%>	
  <form name="loginForm" method="post" action="login.asp">
	<table>
		<tr>
			<td>Lietotâjs:</td>
			<td><input type="text" name="username" maxlength="25" value="<%=request("username")%>"></td>
		</tr>
		<tr>
			<td>Parole:</td>
			<td><input type="password" name="password" maxlength="25"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
			  <input type="submit" value="Ieiet">
			  <input type="reset" value="Atcelt">
			</td>
		</tr>
	</table>
	<input type="hidden" name="submit" value="1">
  </form>

 </body>
</html>
