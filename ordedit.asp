<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim dsk
dim conn
openconn
oid = request.querystring("oid")
valuta = request.querystring("valuta")
if oid = "" then 	message = "Nav noradits ordera id!"
set ord_L = server.createobject("ADODB.Recordset")
ord_L.open "select * from orderis where id = "+cstr(oid),conn,3,3

'nosakam operâcijas tipu
if getnum(ord_L("pid"))<>0 then
 if getnum(ord_L("nopid"))<>0 then
  tips = "ps"
 else
  tips = "io"
 end if
else
 tips = "oo"
end if

'dabonam informâciju par iesaistîtajâm grupâm
if tips = "ps" or tips = "io" then
 rnogrupa = conn.execute("select * from grupa where id in (select gid from pieteikums where id = "+cstr(ord_L("pid"))+")")
end if

if tips = "ps" or tips = "oo" then
 ruzgrupa = conn.execute("select * from grupa where id in (select gid from pieteikums where id = "+cstr(ord_L("nopid"))+")")
end if

'dabonam informaciju par valûtu
set rvaluta = conn.execute("select * from valuta where id = "+cstr(ord_L("valuta")))

%>


<% docstart "Orderis","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Labot operâciju</b></font><hr>
<%
If session("message")<>"" Then
	Response.write session("message")+"<BR>"
	session("message") = ""
End if
%>
<% headlinks 
DefJavaSubmit
JSPoints
%>


<form name="forma" method="POST">
<table>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Ordera numurs: </td><td bgcolor="#fff1cc"><%=ord_L("num")%>
<font color=#fff1cc>-----------------------</font>Rçíins: 
<input type=text name=rekins size=4 value="<%if getnum(ord_L("rekins"))<>0 then Response.Write ord_L("rekins")%>">
<input type=text size=4 name=rekins_gads value="<%if getnum(ord_L("rekins_gads"))<>0 then Response.Write ord_L("rekins_gads")%>">
Pazîme: <input type=text size=4 name=rekins_pazime value="<%if ord_L("rekins_pazime")<>"" then Response.Write ord_L("rekins_pazime")%>">
</td>
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Datums: </td><td bgcolor="#fff1cc"><input type="text" size="10" maxlength="20" name="datums" value="<%=dateprint(ord_L("datums"))%>"> </tr>
<%if not isnull(ord_L("datums_apst")) then%>
 <tr><td align="right" bgcolor="#ffc1cc"><b><big>Reìistrçjis: </td><td bgcolor="#fff1cc"><%=decode(conn.execute("select vards from agenti where id = " + cstr(ord_L("aid")))(0))%></tr>
 <tr><td align="right" bgcolor="#ffc1cc"><b><big>Reìistrçts: </td><td bgcolor="#fff1cc"><%=dateprint(ord_L("datums_apst"))%>
 <% if ord_L("parbaude") = True then %>
  <font color = red>(Nav apstiprinâta)</font>
 <% end if %>
 </tr>
<%end if %>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Maksâtâjs: </td><td bgcolor="#fff1cc"><input type="text" size="25" maxlength="20" name="kas" value="<%=ord_L("kas")%>"></td>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pamatojums: </td><td bgcolor="#fff1cc"><textarea rows="3" cols="40" name="pamatojums"><%=ord_L("pamatojums")%></textarea></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pielikumâ: </td><td bgcolor="#fff1cc"><input type="text" size="40" name="pielikums" value="<%=ord_L("pielikums")%>"> </tr>
<tr>
 <td align="right" bgcolor="#ffc1cc"><b><big>Debets: </td><td bgcolor="#fff1cc"><input type="text" size="14" name="debets" value="<%=ord_L("debets")%>" >
 <% 
  'nosakam ieteicamo debetu
  if tips = "io" then
   Response.Write rvaluta("kases_konts")
  else
   pieteikuma_rekviziti ord_L("nopid"),nokonts,noresurss
   Response.Write nokonts
  end if
 %>
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Kredîts: </td><td bgcolor="#fff1cc"><input type="text" size="14"  name="kredits" value="<%=ord_L("kredits")%>">
 <% 
  'nosakam ieteicamo kredîtu
  if tips = "oo" then
   Response.Write rvaluta("kases_konts")
  else
   pieteikuma_rekviziti ord_L("pid"),uzkonts,uzresurss
   Response.Write uzkonts
  end if
 %>
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Resurss (samazinâs): </td><td bgcolor="#fff1cc"><input type="text" size="14" name="resurss" value="<%=ord_L("resurss")%>"> 
 <% 
  'nosakam ieteicamo debetu
  if tips = "oo" or tips = "ps" then
   Response.Write noresurss
  else
   Response.Write uzresurss
  end if
 %>
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Resurss (palielinâs): </td><td bgcolor="#fff1cc"><input type="text" size="14" name="resurss_uz" value="<%=ord_L("resurss_uz")%>"> </tr>
<tr>
 <td align="right" bgcolor="#ffc1cc"><b><big>Iemaksas summa: </td>
 <td bgcolor="#fff1cc"><input type="text" size="7" maxlength="10" name="summa" value="<%=ord_L("summaval")%>"> 
  <%' if valuta="XXX" then %>
  <select name=parvalutu>
   <option value="LVL" <%if getnum(ord_l("summaLVL"))<>0 then response.write " selected "%> >Par latiem</option>
   <option value="USD" <%if getnum(ord_l("summaUSD"))<>0 then response.write " selected "%> >Par dolâriem</option>
   <option value="EUR" <%if getnum(ord_l("summaEUR"))<>0 then response.write " selected "%> >Par eiro</option>
  </select>
  <%' end if %>
</tr>

<tr><td align="right" bgcolor="#ffc1cc"><b><big>Valûta: </td><td bgcolor="#fff1cc"><% dbcomboplus "valuta","val","id","valuta",ord_L("valuta") %></td></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Bilances summa: </td><td bgcolor="#fff1cc"> <%response.write Curr3Total(ord_L("summaLVL"),ord_L("summaUSD"),ord_L("summaEUR"))%></td></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Parole: </td><td bgcolor="#fff1cc"><input type="password" size="7" name="parole"><td bgcolor="#fff1cc"> </td></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Zils: </td><td bgcolor="#fff1cc"><input type="checkbox" name="zils" <%if ord_l("zils")=true then Response.Write " checked " %>><td bgcolor="#fff1cc"> </td></tr>
</table>
<table>
<tr>
<td align="center">

<%  ''konvetaciju nevar saglabat
If ord_L("kas")<>"KONVERTACIJA" then %>
<input type="image" name="labot" src="impro/bildes/diskete.jpg" alt="Tiks saglabâtas teksta laukos izdarîtâs izmaiòas. Pçc tam var spiest pogu ATCELT lai pârietu atpakaï uz pieteikumu." onclick="if (validate()) 
	{TopSubmit('ord_save.asp<%=qstring()%>');}
	else {return false}" WIDTH="25" HEIGHT="25">
<% End If %>

<input type="image" name="drukat" src="impro/bildes/drukat.jpg" alt="Tiks parâdîta izdrukas forma atkarîbâ no operâcijas veida. Vai nu izmaksas vai iemaksas ordera forma." onclick="if (validate()) 
	{TopSubmit('ord_save.asp<%=qstring()+"&drukat=1"%>');}
	else {return false}" WIDTH="116" HEIGHT="25">
	<% if isaccess(T_GRAMATVEDIS) then %>
<% ''  rw getnum(ord_L("parbaude"))

 If cstr(ord_L("parbaude")) = "True" then %>	
	
		<a href="c_orderi.php?f=apstiprinat&oid=<%=cstr(oid)%>" title="Apstiprinât" onclick="if (confirm('Vai tieğâm vçlaties apstiprinât ğo orderi?')){return true;console.log($('#apstiprinat_forma'));alert('submit');$('#apstiprinat_forma').submit();}else return false;">	<img style="border:none" border=0 src="images/dolars.jpg"></a>
		

<% end if %>
<% end if %>
</tr>
</table>
<% if getnum(ord_L("pid"))<>0 then %>
 <a href="pieteikums.asp?pid=<%=ord_L("pid")%>">[Uz pieteikumu]</a>
<% end if %>
<% if getnum(ord_L("nopid"))<>0 then %>
 <a href="pieteikums.asp?pid=<%=ord_L("nopid")%>">[Uz pieteikumu]</a>
<% end if %>
</form>
<!--form method="post" id="apstiprinat_forma" action="c_orderi.php">
		<input type="hidden" name="submit" value="1">
		<input type="hidden" name="oid" value="<%=cstr(oid)%>" />
</form-->
<hr>
<%=NullPrint(ord_l("vesture"))%>
<!-- @ 0 Validation -->
<script language="JScript">
function validate()
{
	if (forma.summa.value == "") 
		{ window.alert('Nav norâdîta summa'); return false;}
	if (!isFloat(forma.summa.value))
		{ window.alert("Summa var saturçt tikai skaitïus un vienu punktu"); return false;}
	return true;
}

<!-- @ 1 Standart functions -->
function isInt(checkP)
{
  var checkOK = "0123456789-";
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
