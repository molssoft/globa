<script LANGUAGE="JavaScript">
<!--hide
function NewCenterWindow(url,w,h)
{
window.open(url,'pass', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes, resizable=no,copyhistory=no,width='+w+',height='+h+',top='+(screen.height/2-h/2)+',left='+(screen.width/2-w/2));
}
//-->
</script>
<form name=forma>
 <input type=text name=bilde>
 <input type=button name=poga onclick="NewCenterWindow('upload.asp?var=bilde&prefix=pre',300,300);return false;">
</form>