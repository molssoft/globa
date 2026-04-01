<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
%>

<center>
Pievienoties IMPRO ziòu listei.<br>
<form method=POST action=register2.asp>
<table>
 <tr>
  <td>
   Jûsu e-pasta adrese:
  </td>
  <td>
   <input type=text size=20 name=email>
  </td>
 </tr>
 <tr>
  <td>
   Parole:
  </td>
  <td>
   <input type=password size=10 name=password>
  </td>
 </tr>
 <tr>
  <td>
   Paroles pârbaude:
  </td>
  <td>
   <input type=password size=10 name=password2>
  </td>
 </tr>
</table>
<input type=submit value="Parakstîties">
</form>