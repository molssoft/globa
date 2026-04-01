<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
docstart "Pievienot vadîtâju","y1.jpg"
%><center><%

if Request.Form("subm")<>"1" then %>

<form name=forma method=POST action=vaditajs_new.asp>
<input type=hidden name=subm value=1>
<table>
<tr><td>Vârds:</td><td><input type=text name=vards></td>
<tr><td>Uzvârds:</td><td><input type=text name=uzvards></td>
</table>
<a href="Saglabât jaunu grupas vadîtâju" onclick="forma.submit();return false;">Saglabât</a> <a href="Aizvçrt logu" onclick="window.close();">Atcelt</a>
</form>

<% else %>
<% conn.execute("INSERT INTO grupu_vaditaji (id,vards,uzvards) VALUES ('nav','"+Request.Form("vards")+"','"+Request.Form("uzvards")+"')")%>
Vadîtâjs pievienots.<br>
<a href="Aizvçrt logu" onclick="window.close();">Aizvçrt</a>

<% end if %>
