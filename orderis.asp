<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'EUR_DATE = DateSerial(2013,1,1)
dim vu
dim oid
dim did(200)
dim dsk
dim conn
openconn
'check_office "dalibn.asp"
pid = request.querystring("pid")
valuta = request.querystring("valuta")
zils = request.querystring("zils")
pid = request.querystring("pid")
gid = request.querystring("gid")
num = request.querystring("num")
'session("lastpid") = pid
'session("pid") = pid
'session("nopid") = 0
'session("uzpid") = pid
if pid = "" then 	message = "Nav noradits pieteikuma nummurs!"

set dalibn_id = conn.execute ("select * from piet_saite where deleted = 0 and pid = "+cstr(pid))
vu = dalibnieks(dalibn_id("did"))
gid = id_field("pieteikums",pid,"gid")
set rGrupa = conn.execute("select * from grupa where id = "+cstr(gid))
set rMarsruts = conn.execute("select * from marsruts where id = "+cstr(rGrupa("mid")))
kods = nullprint(rGrupa("kods"))
Code_Replace_PID_DID kods,Request.QueryString("pid")
pamatojums = kods + " " + dateprint(rGrupa("sakuma_dat")) + " " + rMarsruts("v") + ". Dalîbnieks: "+ vu


'papildus pamatojums, ja nepiecieğams
if rGrupa("order_info") = true then
 set rParKo = conn.execute("select pid,kid,kajites_veidi.nosaukums as knos,vietu_veidi.nosaukums as vnos from ((piet_saite left join kajite on piet_saite.kid = kajite.id) left join kajites_veidi on kajite.veids = kajites_veidi.id) left join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id where pid = "+cstr(pid))
 while not rParKo.eof
  if getnum(rParKo("kid")) <> 0 then
   pamatojums = pamatojums + "||Kajîte:"+rParKo("knos")
  end if
  if NullPrint(rParKo("vnos")) <> "" then
   pamatojums = pamatojums + "||"+rParKo("vnos")
  end if
  rParKo.MoveNext
 wend
end if

if ucase(mid(kods,1,1))="K" or ucase(mid(kods,1,1))="I" then
	pielikums = "Kompl. Nr. "+cstr(pid)
end if


If request.querystring("balles_biletes")<>"" then
	pielikums = "Balles biïetes " + request.querystring("balles_biletes") + " gab. " + "Sektors " + request.querystring("sektors")
	summa = CInt(request.querystring("balles_biletes"))*20
End if

pieteikuma_rekviziti Request.QueryString("pid"),kredits,resurss
If request.querystring("kredits")<>"" Then kredits = request.querystring("kredits")
'debets = "2.6.1.1.1"
debets = "2.6.1.1.E"
%>


<% docstart "Orderis","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Reìistrçt jaunu iemaksu</b></font><hr>
<% 'Response.Write kredits%>
<% headlinks 
DefJavaSubmit
JSPoints
%>

<form name="forma" method="POST" target="window<%=now%>">
<table>
<input type="hidden" name="dID" value="<%=ID%>">
<input type=hidden name=changed value="false">
<input type=hidden name=ignore value="false">
<tr>
	<td align="right" bgcolor="#ffc1cc"><b><big>Ordera numurs: </td>
	<td bgcolor="#fff1cc"><%=ordnum(conn)%>. 
		<font color=#fff1cc>----------------------------</font>Rçíins: 
		<input type=text size=4 name=rekins value="<%=request.querystring("rekins")%>" >
		Gads <input type=text size=4 name=rekins_gads value="<%=request.querystring("rekins_gads")%>">
		Pazîme: <input type=text size=4 name=rekins_pazime value="<%=request.querystring("rekins_pazime")%>">
	</td>
<tr>
	<td align="right" bgcolor="#ffc1cc"><b><big>Datums: </td><td bgcolor="#fff1cc"><input type="text" size="10" maxlength="20" name="datums" value="<%=dateprint(date)%>">
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Maksâtâjs: </td><td bgcolor="#fff1cc"><input type="text" size="50" maxlength="50" name="kas" value="<%=vu%>"></td>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pamatojums: </td><td bgcolor="#fff1cc"><textarea rows="3" cols="40" name="pamatojums"> <%=pamatojums%></textarea></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pielikumâ: </td><td bgcolor="#fff1cc"><input type="text" size="40" name="pielikums" value="<%=pielikums%>"> </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Kredîta konts: </td><td bgcolor="#fff1cc"><input type="text" size="14" name="kredits" value="<%=kredits%>" onblur='JSPoints (document.forma.kredits)'> Dalît:<input type=checkbox name=dala_uz></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Debeta konts: </td><td bgcolor="#fff1cc"><input type="text" size="14" name="debets" value="<%=debets%>" onblur='JSPoints (document.forma.debets)' onchange="document.forma.changed.value='true'; document.forma.ignore.value='false';">
 </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Resurss: </td><td bgcolor="#fff1cc"><input type="text" size="14" name="resurss" value="<%=resurss%>"> </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Iemaksas summa: </td>
  <td bgcolor="#fff1cc"><input type="text" size="7" maxlength="10" name="summa" value=<%=summa%>> 
  <select name=parvalutu>
   <% If rGrupa("valuta") = "EUR" Then %>
	<option value="EUR" selected >Par eiro</option>
   <% else %>
	<option value="EUR">Par eiro</option>
	<option value="LVL">Par latiem</option>
	<option value="USD">Par dolâriem</option>
   <% end if %>
  </select>
  
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Valûta: </td><td bgcolor="#fff1cc"><% 
query = "select id,val,kases_konts from valuta order by val asc"
set rVal = conn.execute(query)
Response.Write "<select name=valuta onchange="""
	while not rVal.eof
	  Response.Write "if (((document.forma.ignore.value=='true') || (document.forma.changed.value=='false')) && (document.forma.valuta.options[document.forma.valuta.options.selectedIndex].text == '"+rVal("val")+"')) { document.forma.debets.value = '"+rVal("kases_konts")+"'; document.forma.ignore.value='true'; } "
	  '((document.forma.ignore.value=='true') or (document.forma.changed.value=='false')) and (document.forma.valuta.options[document.forma.valuta.options.selectedIndex].text == '"+rVal("val")+"')
	  rVal.MoveNext
	wend
Response.write """>"
Set grupas = conn.execute("select * from valuta order by val asc")
do while not grupas.eof
Response.Write "<option value='" & grupas("id") & "' "
If (EUR_DATE>Now()) then 
	if grupas("val") = "LVL" then Response.Write "selected" 
else
	if grupas("val") = "EUR" then Response.Write "selected" 
End If

Response.write " >" &  grupas("val") & "</option>"
grupas.MoveNext
loop
Response.Write "</select>" & Chr(10)
%>
</td></tr>
</table>
<table>
<tr>
<td align="center">
<input type="image" name="registret" src="impro/bildes/registret.jpg" alt="Nospieşot ğo pogu orderis tiks saglabâts datu bâze." onclick="if (validate()) 
	{TopSubmit2('ord_transf.asp<%=qstring()%>');}
	else {return false}" WIDTH="116" HEIGHT="25">
<a href=pieteikums.asp?pid=<%=pid%>><img src="impro/bildes/atcelt.jpg" style="border:none" alt="Nospieşot ğo pogu orderis netiks saglabâts datu bâze. Tiks parâdîts pieteikuma logs." border=0></a>
<!--<input type="image" name="atcelt" src="impro/bildes/atcelt.jpg" alt="Nospieşot ğo pogu orderis netiks saglabâts datu bâze. Tiks parâdîts pieteikuma logs." onclick="forma.target='';TopSubmit2('pieteikums.asp<%=qstring()%>')" WIDTH="116" HEIGHT="25">-->
<input type="hidden" name="did" value="<%=id%>"></td>
<input type="hidden" name="oid" value="<%=oid%>"></td>
<input type="hidden" name="vu" value="<%=vu%>"></td>
<input type="hidden" name="num" value="<%=ordnum(conn)%>"></td>
<input type="hidden" name="tips" value="iemaksa">
<% if zils="1" then %>
<input type="hidden" name="zils" value="1">
<% else %>
<input type="hidden" name="zils" value="0">
<% end if %>
</tr>
<tr>
	<td colspan=2 align=center>
		<% If num<>"" Then %>
			<a href=balle_edit.asp?gid=<%=request.querystring("gid")%>&num=<%=num%>><B>ATGRIEZTIES UZ BALLI</B></a>
		<% end If %>
	</td>
</tr>
</table>
</form>

<BR>

<!-- @ 0 Validation -->
<script language="JScript">
function validate()
{
	if (forma.kredits.value == "") 
		{ window.alert('Nav norâdîts kredîta konts'); return false;}
	if (forma.kredits.value.substr(forma.kredits.value.length-1,1) == ".") 
		{ window.alert('Kredîta konts nevar beigties punktu'); return false;}
	if (forma.debets.value == "") 
		{ window.alert('Nav norâdîts debeta konts'); return false;}
	if (forma.debets.value.substr(forma.debets.value.length-1,1) == ".") 
		{ window.alert('Debeta konts nevar beigties punktu'); return false;}
	if (forma.summa.value == "") 
		{ window.alert('Nav norâdîta summa'); return false;}
	if (!isFloat(forma.summa.value))
		{ window.alert("Summa var saturçt tikai skaitïus un vienu punktu"); return false;}
	if (forma.rekins.value != "")
		{ window.alert('Tâ kâ rçíins tika norâdîts, tad kredîta konts tiks mainîts uz 2.3.4.X'); forma.kredits.value = "2.3.4.X";}
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
  var checkOK = "0123456789.-";
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
