<HTML>

<HEAD>
<TITLE>Teksta formatçðana</TITLE>


<!-- LOAD THE EDITLIVE JAVASCRIPT LIBRARY -->
<SCRIPT language="JavaScript" src="editlive/editlive2.js"></SCRIPT>
<SCRIPT language="VBScript" src="editlive/editlive2.vbs"></SCRIPT>

<SCRIPT language="JavaScript1.2">
<!--	
//Use this function for retrieving the HTML from EditLive! before submitting it to the server
function form1_onsubmit() 
{
	opener.<%=request.querystring("var")%>.value = editLive1.getSource();
	window.close();
	return false;
}
//-->
</SCRIPT>

</HEAD>

<BODY >

<FORM name="form1" onsubmit="return form1_onsubmit()">

<SCRIPT language="JavaScript">
<!--	

//Important: set the directory where EditLive! download files can be found
EditLiveGlobal.setDownloadDirectory("editlive/");

//Instatiate the EditLiveObject
var editLive1 = new EditLive("Plugin1", 600, 450);

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
   editLive1.setWebRoot('http://www.impro.lv/');
   editLive1.loadStyleSheet('styles.css');
   editLive1.setImageMode('All');
   editLive1.setSource(opener.<%=request.querystring("var")%>.value);
 }

//-->
</SCRIPT>


  <P>
  <INPUT type="button" name="dublet" value="Pavairot" onclick="
  if (editLive1.getSelectedHTML()!='')
  {
    alert('Nevajag neko iezîmçt!');  
    return;
  }
  
  editLive1.insertHTMLAtCursor('!@#metka#@!');
  s = editLive1.getSource();
  i = s.indexOf('!@#metka#@!');
  original = i;
  goon = 1;
  while(goon)
  {
   // goon = confirm (s.substr(i,1));
   if (i>0)
   {
    if (s.indexOf('<tr',i)==i || s.indexOf('<TR',i)==i)
    {
     start_p = i;
     if (s.indexOf('</tr>',i)>start_p) end_p = s.indexOf('</tr>',i)
     if (s.indexOf('</TR>',i)>start_p) end_p = s.indexOf('</TR>',i)
     end_p = end_p + 5;
     gabals = s.substr(start_p,end_p-start_p);
     gabals_new = gabals.replace('!@#metka#@!','');
     s = s.replace(gabals,gabals_new+gabals_new);
     goon = 0;
    }
   }
   else
    goon = 0;
   i--;
  }
  s = s.replace('!@#metka#@!','');
  editLive1.setSource(s);
  ">
  
  <INPUT type="button" name="dublet" value="Pavairot 2" onclick="
  if (editLive1.getSelectedHTML()!='')
  {
    alert('Nevajag neko iezîmçt!');  
    return;
  }
  
  editLive1.insertHTMLAtCursor('!@#metka#@!');
  s = editLive1.getSource();
  i = s.indexOf('!@#metka#@!');
  original = i;
  goon = 1;
  while(goon)
  {
   // goon = confirm (s.substr(i,1));
   if (i>0)
   {
    if (s.indexOf('<tr',i)==i || s.indexOf('<TR',i)==i)
    {
     start_p = i;
     
     if (s.indexOf('</tr>',i)>start_p) 
      end_p = s.indexOf('</tr>',i);
     else
      if (s.indexOf('</TR>',i)>start_p) end_p = s.indexOf('</TR>',i)
     end_p = end_p + 5;
     
     if (s.indexOf('</tr>',end_p)>end_p) 
      end_p = s.indexOf('</tr>',end_p)
     else 
      if (s.indexOf('</TR>',end_p)>end_p) end_p = s.indexOf('</TR>',end_p)
     end_p = end_p + 5;
     
     gabals = s.substr(start_p,end_p-start_p);
     gabals_new = gabals.replace('!@#metka#@!','');
     s = s.replace(gabals,gabals_new+gabals_new);
     goon = 0;
    }
   }
   else
    goon = 0;
   i--;
  }
  s = s.replace('!@#metka#@!','');
  editLive1.setSource(s);
  ">
  editLive1.activateLicense('75DE6092F624','IMPRO.LV','http://www.ephox.com/elregister/el2/activate.asp',true); 

  <INPUT type="submit" name="poga" value="Ievietot"><INPUT type="button" name="poga" value="Atcelt" onclick="window.close();return false;"></P>
</FORM>

</BODY>

