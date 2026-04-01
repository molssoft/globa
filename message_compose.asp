<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

if not IsAccess(T_SUT_EMAILI) then
 session("message") = "Emailu sûtîðana jums nav pieejama"
 Response.Redirect "default.asp"
end if

docstart "E-vçstules sastâdîðana","y1.jpg" 
PageSize = 20

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
<%

'Current page
p = request.querystring("p")
if p = "" then p = "1"

%>
<center><font color="GREEN" size="5"><b>E-vçstules sastâdîðana</b></font><hr>
<%
headlinks 

if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
%>
<form name="forma" action="message_save.asp" enctype="multipart/form-data" onsubmit="return forma_onsubmit()" method=POST>
<center>
 <table>
  <tr>
   <td >Tçma:</td>
  </tr>
  <tr>
   <td bgcolor="fff1cc"><input type="text" name="subject" size=80></td>
  </tr>
  <tr>
   <td >Teksts:</td>
  </tr>
  <tr>
   <td>
  
  <INPUT type="hidden" name="mySource" 
  value="
  <table width=100% border=0>
   <tr>
    <td align=left><img src='logo.jpg'></td>
    <td align=center><b><FONT face=Arial color=#008000 size=5>Ðeit bûs virsraksts</FONT></b></td>
   </tr>
  </table>
  <HR width='100%' height='0.5' color=#008000>
  <P>Ziòojuma teksts ðeit</P><HR width='100%' height='0.5' color=#008000>
  <P>IMPRO CEÏOJUMI<br>Latvieðu Biedrîbas nams<br>Meríeïa iela 13-122<br>Tâlrunis: 7221312<br>
  <A href='http://www.impro.lv/'>http://www.impro.lv/</A></P>">
  <INPUT type="hidden" name="mysource2" value="IMPRO CELOJUMI<br>Latvieshu Biedriibas nams<br>Merkelja iela 13-122<br>Taalrunis: 7221312<br>WWW.IMPRO.LV">
  <input type="hidden" name="subject2" value="IMPRO CELOJUMI<br>Latvieshu Biedriibas nams<br>Merkelja iela 13-122<br>Taalrunis: 7221312<br>WWW.IMPRO.LV" size=80>
  <!-- "article_title" is an example of the fields you could store with the HTML from EditLive! -->

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
   editLive1.activateLicense('75DE6092F624','IMPRO.LV','http://www.ephox.com/elregister/el2/activate.asp',true);
</td>    

  </tr>
 </table>
Pievienot failu:<input type=file name=fails><br>
<input type=hidden name=var value=<%=request.querystring("var")%>>
<input type=hidden name=prefix value=<%=request.querystring("prefix")%>>
Sûtît klientiem: <input type = checkbox name=klientiem><br>
Sûtît adresçm aizpildîtajâs anketâs: <input type = checkbox name=anketam><br><br>
<input type = submit value="Sûtît" id=submit1 name=submit1>
<input type = submit value="Atcelt" onclick="forma.action='default.asp';return true;" id=submit2 name=submit2>
</form>
</body>
</html>
