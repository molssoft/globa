<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
id = Request.QueryString("id")
docstart "E-pasta vçstule nr."+cstr(id),"y1.jpg" 

%>
<!-- LOAD THE EDITLIVE JAVASCRIPT LIBRARY -->
<SCRIPT language="JavaScript" src="editlive/editlive2.js"></SCRIPT>
<SCRIPT language="VBScript" src="editlive/editlive2.vbs"></SCRIPT>

<SCRIPT language="JavaScript1.2">
<!--	
//Use this function for retrieving the HTML from EditLive! before submitting it to the server
function forma_onsubmit() 
{
	document.forma.mysource2.value = editLive1.getSource();
}
//-->
</SCRIPT>

<center><font color="GREEN" size="5"><b>E-pasta vçstule nr.<%=cstr(id)%></b></font><hr>
<%
if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

set r = conn.execute("select *,subject as subj,message as mess from email_history where id = " + cstr(id))

%>
<br>
<center>
<form name=forma>
<table >
 <tr>
  <td align = right><b>Nr.</td>
  <td align = left><%=r("id")%>
 </tr>
 <tr>
  <td align = right><b>Kad sûtîts:</td>
  <td align = left><%=dateprint(r("kad"))%>
 </tr>
 <tr>
  <td align = right><b>Kas sûtîjis:</td>
  <td align = left><%=r("kas")%>
 </tr>
 <tr>
  <td align = right><b>Tçma:</td>
  <td align = left><%=Decode(CStr(r("subj")))%>
 </tr>
 <tr>
  <td align = right valign=top	><b>Teksts:</td>
  <td align = left>
  <textarea name=mySource rows=1 cols=1>
  <%=nullprint(r("mess"))%>
  </textarea>
  <SCRIPT language="JavaScript">
<!--	

//Important: set the directory where EditLive! download files can be found
EditLiveGlobal.setDownloadDirectory("editlive/");

//Instatiate the EditLiveObject
var editLive1 = new EditLive("Plugin1", 600, 300);

//Assign a window onload function
editLive1.onload = EditLive1_onload;

//Use this function for initalizing and customizing EditLive!
function EditLive1_onload()
{
   editLive1.serverRegister('SIA IMPRO CELOJUMI','IMPRO.LV','2FFF-3051-566A-4FD3');
   editLive1.setEditLiveMode('HTMLString');
   editLive1.setFTPServer('ftp.ephox.com');
   editLive1.setFTPServerPort(21);
   editLive1.setFTPUsername('anon');
   editLive1.setFTPPassword('anon');
   editLive1.setWebRoot('http://www.ephox.com/ftp/');
   editLive1.setImageMode('All');
   editLive1.setSource(document.forms.forma.mySource.value);
}

//-->
</SCRIPT>
</form>
 </tr>
</table>
</body>
</html>
