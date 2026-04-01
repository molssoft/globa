<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
id = Request.QueryString("id")
if id<>"" then
 set r = conn.execute("select email from email_list where id = +"+cstr(id))
 if not r.eof then email = r(0)
end if
%>
<center>
Atteikties no IMPRO ziòu saòemðanas.<br>
<form method=POST action=unregister2.asp name=forma>
<table>
 <tr>
  <td align=right>
   Jûsu e-pasta adrese:
  </td>
  <td>
   <input type=text size=20 name=email value="<%=email%>">
  </td>
 </tr>
 <tr>
  <td align=right>
   Parole:
  </td>
  <td>
   <input type=password size=10 name=password>
  </td>
 </tr>
</table>
<input type=submit value="Apstiprinu">
<br><br>
<br>
Ja esat aizmirsuði savu paroli,<br> varat to saòemt uz savu e-pasta adresi<br> 
nospieþot ðo pogu.<br>
<input type=submit value="Saòemt paroli" onclick="forma.action='send_my_password.asp';return true;">
</form>
