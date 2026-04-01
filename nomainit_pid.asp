<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Pieteikuma personas maiòa","y1.jpg" %>
<center><font color="GREEN" size="5" face=Tahoma>Pieteikuma personas maiòa</b></font><hr>
<%
headlinks 

set rPiet = conn.execute("select * from piet_saite where deleted = 0 and pid = "+session("nomainit_pid"))
set rDalNO = conn.execute("select * from dalibn where id = "+cstr(rPiet("did")))
set rDalUZ = conn.execute("select * from dalibn where id = "+Request.QueryString("did"))
session("nomainit_pid") = ""
%>
<br><br>
<font color="GREEN" size="3" face=Tahoma>
Pieteikuma nr <b><%=rPiet("pid")%></b> personas maiòa.<br>
Vai nomainît personu no <b><%=rDalNo("vards")%></b> <b><%=rDalNo("uzvards")%></b> <b><%=rDalNo("nosaukums")%></b><br>
uz <b><%=rDalUz("vards")%></b> <b><%=rDalUz("uzvards")%></b> <b><%=rDalUz("nosaukums")%></b>
<br><br><br>
<a href="nomainit_pid_dal2.asp?pid=<%=rPiet("pid")%>&no=<%=rDalNo("id")%>&uz=<%=rDalUz("id")%>">[Jâ]</a>
<a href="dalibn.asp">[Nç]</a>

