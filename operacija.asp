<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim did(200)
dim dsk
dim conn
openconn

if Session("parsk") = "no" then
	NoPid = request.querystring("pid")
	UzPid = session("LastPid")
	Session("parsk_tips") = "no"
end if
if Session("parsk") = "uz" then
	UzPid = request.querystring("pid")
	NoPid = session("LastPid")
	Session("parsk_tips") = "uz"
end if

if Request.Querystring("nopid") <> "" then
	UzPid = request.querystring("pid")
	NoPid = request.querystring("nopid")
	Session("parsk_tips") = "uz"
end if

desc_gid = Request.QueryString("desc_gid")


set r = conn.execute ("select gid,old_gid from pieteikums where id = "+cstr(UzPid))
if getnum(r("old_gid"))<>"0" then
 uz_grupa = r("old_gid")
else
 uz_grupa = r("gid")
end if
if session("parsk") = "uz" and desc_gid <> "" then uz_grupa = desc_gid


set r = conn.execute ("select gid,old_gid from pieteikums where id = "+cstr(NoPid))
if getnum(r("old_gid"))<>"0" then
 no_grupa = r("old_gid")
else
 no_grupa = r("gid")
end if
if session("parsk") = "no" and desc_gid <> "" then no_grupa = desc_gid


set rNoGrupa = conn.execute("select id,valuta from grupa where id = "+cstr(no_grupa))
set r = conn.execute ("select gid,old_gid from pieteikums where id = "+cstr(NoPid))
att_gid = cstr(conn.execute ("select atteikusies from parametri")(0))
if session("parsk") = "no" and desc_gid <> "" then no_grupa = desc_gid

pamatojums = "Pârskaitîjums NO "+grupas_nosaukums(no_grupa,NoPid)+"("+cstr(NoPid)+") UZ "+grupas_nosaukums(uz_grupa,UzPid)+"("+cstr(UzPid)+")"
%>


<% docstart "Orderis","y1.jpg" %>
<center><font color="GREEN" size="5"><b><i>Pârskaitîjums</i></b></font><hr>
<% headlinks 
DefJavaSubmit
JSPoints

'Parâda message no citâm lapâm
if session("message") <> "" then %>
	<br><font size = 4 color="RED"><%=session("message")%></font><br>
	<% session("message") = ""
end if
%>


<form name="forma" method="POST">
<table border="1">
<input type="hidden" name="dID" value="<%=Request.QueryString("did")%>">
<tr><td align="right"><b><big>Datums: </td><td><input type="text" size="25" maxlength="20" name="datums" value="<%=dateprint(date)%>"> </tr>
<tr><td align="right"><b><big>Maksâtâjs: </td><td><textarea rows="2" cols="40" name="kas" onchange="checkLength(50)">Pârskaitîjums</textarea></td>
<tr><td align="right"><b><big>Pamatojums: </td><td><textarea rows="8" cols="40" name="pamatojums"><%=pamatojums%></textarea></tr>
<tr><td align="right"><b><big>Pielikumâ: </td><td><input type="text" size="40" name="pielikums" value="<%=pielikums%>"></tr>
<%
 pieteikuma_rekviziti nopid,nokonts,noresurss
 pieteikuma_rekviziti uzpid,uzkonts,uzresurss
%>
<tr><td align="right"><b><big>Debeta konts: </td><td><input type="text" size="10" name="debets" value="<%=nokonts%>" onblur='JSPoints (document.forma.debets)'> </tr>
<tr><td align="right"><b><big>Kredîta konts: </td><td><input type="text" size="10" name="kredits" value="<%=uzkonts%>" onblur='JSPoints (document.forma.kredits)'> </tr>
<tr><td align="right"><b><big>Resurss (samazinâs): </td><td><input type="text" size="10" name="resurss" value="<%=noresurss%>"></tr>
<tr><td align="right"><b><big>Resurss (palielinâs): </td><td><input type="text" size="10" name="resurss_uz" value="<%=uzresurss%>"></tr>
<tr><td align="right">
 <b><big>Iemaksas summa: </td><td><input type="text" size="7" maxlength="10" name="summa"> 
  <select name="parvalutu">
   <option value="EUR">Par EUR</option>
   <option value="LVL">Par LVL</option>
   <option value="USD">Par USD</option>
  </select>
 </td>
</tr>
<tr><td align="right"><b><big>Valûta: </td><td><% dbcombo "valuta order by priority desc","val","id","valuta" %></td></tr>
</table>
<table>
<tr>
<td align="center">
<input type="image" name="registret" src="impro/bildes/registret.jpg" onclick="if (validate()) 
	{TopSubmit('ord_transf.asp<%=qstring()%>');}
	else {return false}" WIDTH="116" HEIGHT="25">
<input type="image" name="atcelt" src="impro/bildes/atcelt.jpg" onclick="TopSubmit('pieteikums.asp<%=qstring()%>')" WIDTH="116" HEIGHT="25">
<input type="hidden" name="NoPid" value="<%=NoPid%>"></td>
<input type="hidden" name="UzPid" value="<%=UzPid%>"></td>
<input type="hidden" name="parsk" value="1"></td>
<input type="hidden" name="num" value="<%=ordnum(conn)%>"></td>
<input type="hidden" name="tips" value="parskaitijums">
<input type="hidden" name="a" value="registret">
</tr>
</table>
</form>

<!-- @ 0 Validation -->
<script language="JScript">
function validate()
{
	if (forma.summa.value == "") 
		{ window.alert('Nav norâdîta summa'); return false;}
	if (forma.debets.value == "") 
		{ window.alert('Nav norâdîts debeta konts'); return false;}
	if (forma.kredits.value == "") 
		{ window.alert('Nav norâdîts kredîta konts'); return false;}
	if (!isFloat(forma.summa.value))
		{ window.alert("Summa var saturçt tikai skaitïus un vienu punktu"); return false;}
	return true;
}

function checkLength(plen){

	maks = forma.kas.value;
	if(maks.length>plen){
		alert('Lauka garuma ierobezhojums '+plen+' simboli.');
		forma.kas.value = maks.substr(0,plen);
	}
}

<!-- @ 1 Standart functions -->
function isInt(checkP)
{
  var checkOK = "0123456789";
  var checkStr = checkP
  var allValid = true;
  for (i = 0;  i < checkStr.length;  i++)
  {
    ch = checkStr.charAt(i);
    for (j = 0;  j < checkOK.length;  j++)
      if (ch == checkOK.charAt(j))
        break;
    if (j == checkOK.length)
    {
      allValid = false;
      break;
    }
  }
  if (!allValid) return (false);
  return true;
}
function isFloat(checkP)
{
  var checkOK = "0123456789.";
  var checkStr = checkP
  var allValid = true;
  var count = 0;
  for (i = 0;  i < checkStr.length;  i++)
  {
    ch = checkStr.charAt(i);
    for (j = 0;  j < checkOK.length;  j++)
      if (ch == checkOK.charAt(j))
        break;
    if (j == checkOK.length)
    {
      allValid = false;
      break;
    }
  }
  if (!allValid) return (false);

  for (i = 0;  i < checkStr.length;  i++)
  {
    if (checkStr.charAt(i)==".") count++;
  }
  if (count>1)  return false;
  return true;
}
function isString(checkP)
{
  var checkOK = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz¨ª¯¸º¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõöøùúûüış";
  var checkStr = checkP
  var allValid = true;
  for (i = 0;  i < checkStr.length;  i++)
  {
    ch = checkStr.charAt(i);
    for (j = 0;  j < checkOK.length;  j++)
      if (ch == checkOK.charAt(j))
        break;
    if (j == checkOK.length)
    {
      allValid = false;
      break;
    }
  }
  if (!allValid) return (false);
  return true;
}
</script>

</body>
</html>
