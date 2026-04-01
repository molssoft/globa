<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim vu
dim oid
dim did(200)
dim dsk
dim conn
openconn

'set rOrderi = conn.execute("select * from orderis where (pamatojums like '%?%' or pamatojums2 like '%?%' or kas like '%?%' or kas2 like '%?%') and isnull(nopid,0)=0 and id = 10470")
'set rOrderi = conn.execute("select * from g2008.dbo.orders where datums >= '01.22.2008' and id = 2893")
i = 0
while not rOrderi.eof 
  
  i = i + 1
  
  Response.Write(cstr(i)+". "+rOrderi("pamatojums")+"<br>")
  
  'conn.execute("update orderis set pamatojums2 = '"+encode(rOrderi("pamatojums2"))+"', kas2= '"+encode(rOrderi("kas"))+"' where id = "+cstr(rOrderi("id")))

  rOrderi.MoveNext

wend

%>


<% docstart "Orderis","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Procedure completed</b></font><hr>


</body>
</html>
<%

Function DecodeGr(s)
If IsNull(s) Then
 Decode = ""
 Exit Function
End If
m = s
m = Replace (m, "#a", "â")
m = Replace (m, "#c", "è")
m = Replace (m, "?", "ç")
m = Replace (m, "#g", "ì")
m = Replace (m, "#i", "î")
m = Replace (m, "#k", "í")
m = Replace (m, "#l", "ï")
m = Replace (m, "#n", "ò")
m = Replace (m, "#s", "ð")
m = Replace (m, "#u", "û")
m = Replace (m, "#z", "þ")
m = Replace (m, "#A", "Â")
m = Replace (m, "#C", "È")
m = Replace (m, "#E", "Ç")
m = Replace (m, "#G", "Ì")
m = Replace (m, "?", "Î")
m = Replace (m, "#K", "Í")
m = Replace (m, "#L", "Ï")
m = Replace (m, "#N", "Ò")
m = Replace (m, "#S", "Ð")
m = Replace (m, "#U", "Û")
m = Replace (m, "#Z", "Þ")

Decode = m
End Function

%>