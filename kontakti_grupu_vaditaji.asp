<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<% 

'atver konektu pie datubâzes
dim Conn
OpenConn

response.write "<!DOCTYPE HTML PUBLIC "+chr(34)+"-//IETF//DTD HTML//EN"+chr(34)+">"
response.write "<html>"

response.write "<head>"
response.write "<meta http-equiv='Content-Type' "
response.write "content= 'text/html; charset=windows-1257'>"
response.write "<link rel=stylesheet type='text/css' href='styles.css'><style type='text/css'></style>"
response.write "<title>Grupu vadîtâju kontakti</title>"

response.write "</head>"

response.write "<body background='y1.jpg' text="+chr(34)+"#000000"+chr(34)+""
response.write "link="+chr(34)+"#008040"+chr(34)+" vlink="+chr(34)+"#804000"+chr(34)+" alink="+chr(34)+"#FF0000"+chr(34)+">"

%>
<center><font color="GREEN" size="5"><b>Grupu vadîtâju kontakti</b></font><hr>
<% headlinks 
DefJavaSubmit


set rLietotaji = conn.execute ("select v.*, d.eadr as epasts, d.talrunisd, d.talrunism, d.talrunisMob from grupu_vaditaji v inner join dalibn d on d.id = v.did where v.deleted=0 order by v.uzvards") 

%>
<br />
<a href="grafiks_sais.asp">Atgriezties</a>
<br /><br />
<table>
<tr bgcolor = #ffC1cc>
<th nowrap>NPK</th>
<th nowrap>Uzvârds, Vârds</th>
<th>E-pasts</th>
<th>Darba tâlrunis</th>
<th>Mâjâs tâlrunis</th>
<th>Mobilais tâlrunis</th>
</tr>

<%

cnt = 0
do while not rLietotaji.eof

cnt = cnt+1
	
 Response.Write "<tr bgcolor = #fff1cc>"
 
 
	Response.Write("<td>"&cnt&"</td><td>"& rLietotaji("uzvards") &" "& rLietotaji("vards") & "</td>")
	Response.Write "<td><a href=mailto:" & rLietotaji("epasts") & ">" & rLietotaji("epasts") & "</td>"
	Response.Write "<td>" & rLietotaji("talrunisd") & "</td>"
	Response.Write "<td>" & rLietotaji("talrunism") & "</td>"
	Response.Write "<td>" & rLietotaji("talrunisMob") & "</td>"


 
 Response.Write "</tr>"
 rLietotaji.movenext
loop
%>
</table>
</body>
</html>