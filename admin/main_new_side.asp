<!-- #include file = "../conn.asp" -->

<%
dim conn
openconn

parent = Request.QueryString("parent")

'dabonam nākamo id
i = 1
while not conn.execute("select id from theMain where id = '"+parent+cstr(i)+"'").eof
 i = i + 1
wend
id = parent+cstr(i)

%>
<head>
    <meta http-equiv="content-type" content="text/html; charset=windows-1257">
</head>
<body>

<script LANGUAGE="JavaScript">
<!--hide
function NewCenterWindow(url,w,h)
{
window.open(url,'pass', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes, resizable=no,copyhistory=no,width='+w+',height='+h+',top='+(screen.height/2-h/2)+',left='+(screen.width/2-w/2));
}
//-->
</script>

<font face=Tahoma>
<font size=5>Jaunums uzmanību sadaļā</font><br><br>

<form name=forma method=POST action=main_add.asp>
<table border = 0>

   <input type=hidden size=20 maxlength=20 name=id value=<%=id%>>
   <input type=hidden name=parent value="<%=parent%>">

 <tr>
  <td align=right>
   Aktīvs:
  </td>
  <td>
   <input type=checkbox name=active>
  </td>
 </tr>

 <input type=hidden name=type_id value=ARTICLE>

 <tr>
  <td align=right>
   Īsais virsraksts:
  </td>
  <td>
   <input type=text size=25 maxlength=200 name=small_title>
  </td>
 </tr>
 
 <tr>
  <td align=right>
   Pilnais virsraksts:
  </td>
  <td>
   <input type=text size=50 maxlength=200 name=title>
  </td>
 </tr>

   <input type=hidden size=10 maxlength=10 name=datums value=<%=day(now)%>/<%=month(now)%>/<%=year(now)%>>

 <tr>
  <td align=right>
   Rādīt sānos no
  </td>
  <td>
   <input type=text size=10 maxlength=10 name=banner_start value=<%=day(now)%>/<%=month(now)%>/<%=year(now)%>>
   līdz <input type=text size=10 maxlength=10 name=banner_end value=<%=day(now+14)%>/<%=month(now+14)%>/<%=year(now+14)%>>
 </tr>

 <tr>
  <td align=right>
   Teksts:
  </td>
  <td>
   <textarea name=text cols=50 rows=10></textarea>
   <input type=button name=poga onclick="NewCenterWindow('../edit.asp?var=forma.text',900,600);return false;">  </td>
  </td>
 </tr>
 
 <tr>
  <td></td>
  <td align=center>
   <a href=Saglabāt onclick="forma.submit();return false;">Saglabāt</a> |
   <a href=main.asp?parent=<%=parent%>>Atcelt</a>
  </td>
  <td></td>
 </tr>

</table>
</form>