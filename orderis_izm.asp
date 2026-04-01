<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim did(200)
dim dsk
dim conn
openconn
valuta = request.querystring("valuta")
pid = request.querystring("pid")
message = session("message")
session("message")=""
if pid = "" then 	message = "Nav noradits pieteikuma nummurs!" 

set dalibn_id = conn.execute ("select * from piet_saite where pid = "+cstr(pid))
vu = dalibnieks(dalibn_id("did"))
set rPiet = conn.execute ("select * from pieteikums where id = "+cstr(pid))
att_gid = cstr(conn.execute ("select atteikusies from parametri")(0))
if cstr(rPiet("gid"))= att_gid and getnum(rPiet("old_gid"))<>0 then
 gid = getnum(rPiet("old_gid"))
else
 gid = rPiet("gid")
end if
set rGrupa = conn.execute ("select * from grupa where id = "+cstr(gid))
set rMarsruts = conn.execute("select * from marsruts where id = "+cstr(rGrupa("mid")))
kods = nullprint(rGrupa("kods"))
Code_Replace_PID_DID kods,Request.QueryString("pid")
pamatojums = kods + " " + rMarsruts("v") + ". Dalîbnieks: "+ vu
if dsk>0 then
  pamatojums = pamatojums+ " "+dalibnieks(dalibn_id("did"))+","
  prev_did = dalibn_id("did")
  if len(pamatojums)>2 then pamatojums = mid(pamatojums,1,len(pamatojums)-1)+"."
end if
kods = rGrupa("kods")
Code_Replace_PID_DID kods,Request.QueryString("pid")
if mid(kods,1,1)="K" or mid(kods,1,1)="k" then
	pielikums = "Kompl. Nr. "+cstr(pid)
end if
pamatojums = "Izmaksa: " + pamatojums
pieteikuma_rekviziti Request.QueryString("pid"),debets,resurss
kredits = "2.6.1.1.E"
%>


<% docstart "Orderis","y1.jpg" %>
<SUP></SUP><center><font color="GREEN" size="5"><b>Reìistrçt izmaksu</b></font><hr>
<% headlinks 
DefJavaSubmit
JSPoints

if message<>"" then
%><p><font color="RED" size="4"><%=message%></font></p>
<%end if%>


<form name="forma" method="POST">
<table>
<input type="hidden" name="dID" value="<%=ID%>">
<input type=hidden name=changed value="false">
<input type=hidden name=ignore value="false">
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Datums: </td><td bgcolor="#fff1cc"><input type="text" size="25" maxlength="20" name="datums" value="<%=dateprint(date)%>"> </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Saòçmçjs: </td><td bgcolor="#fff1cc"><input type="text" size="50" maxlength="50" name="kas" value="<%=vu%>"></td>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pamatojums: </td><td bgcolor="#fff1cc"><textarea rows="3" cols="40" name="pamatojums"> <%=pamatojums%></textarea></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Pielikumâ: </td><td bgcolor="#fff1cc"><input type="text" size="40" name="pielikums" value="<%=pielikums%>"> </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Kredîta konts: </td><td bgcolor="#fff1cc"><input type="text" size="7" maxlength="10" name="kredits" value="<%=kredits%>" onblur='JSPoints (document.forma.kredits)' onchange="document.forma.changed.value='true'; document.forma.ignore.value='false';"> </tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Debeta konts: </td><td bgcolor="#fff1cc"><input type="text" size="7" maxlength="10" name="debets" value="<%=debets%>" onblur='JSPoints (document.forma.debets)'> Dalît:<input type=checkbox name=dala_no></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Resurss: </td><td bgcolor="#fff1cc"><input type="text" size="14" name="resurss" value="<%=resurss%>"> Dalît:<input type=checkbox name=dala_no></tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Izmaksas summa: </td>
 <td bgcolor="#fff1cc"><input type="text" size="7" maxlength="10" name="summa"> 
  <%' if valuta="XXX" then %>
  <select name=parvalutu>
   <option value="EUR" <% If rGrupa("valuta") = "EUR" Then response.write " selected " %>>Par eiro</option>
   <option value="LVL">Par latiem</option>
   <option value="USD">Par dolâriem</option>
  </select>
  <%' end if %>
</tr>
<tr><td align="right" bgcolor="#ffc1cc"><b><big>Valûta: </td><td bgcolor="#fff1cc">
<% 
query = "select id,val,kases_konts from valuta order by val asc"
set rVal = conn.execute(query)
Response.Write "<select name=valuta onchange="""
	while not rVal.eof
	  Response.Write "if (((document.forma.ignore.value=='true') || (document.forma.changed.value=='false')) && (document.forma.valuta.options[document.forma.valuta.options.selectedIndex].text == '"+rVal("val")+"')) { document.forma.kredits.value = '"+rVal("kases_konts")+"'; document.forma.ignore.value='true'; } "
	  rVal.MoveNext
	wend
Response.write """>"
Set grupas = conn.execute("select * from valuta order by val asc")
do while not grupas.eof
Response.Write "<option value='" & grupas("id") & "' "
if grupas("val") = "EUR" then Response.Write "selected" 
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
<input type="image" name="registret" src="impro/bildes/registret.jpg" alt="Nospieşot ğo pogu jauns orderis ar norâdîtajiem datiem tiks saglabâts datu bâzç." onclick="if (validate()) 
	{TopSubmit('ord_transf.asp<%=qstring()%>');}
	else {return false}" WIDTH="116" HEIGHT="25">
<input type="image" name="atcelt" src="impro/bildes/atcelt.jpg" alt="Nospieşot ğo pogu orderis netiks saglabâts, bet notiks pârçja uz pieteikuma logu." onclick="TopSubmit('pieteikums.asp<%=qstring()%>')" WIDTH="116" HEIGHT="25">
<input type="hidden" name="did" value="<%=id%>">
<input type="hidden" name="oid" value="<%=oid%>">
<input type="hidden" name="vu" value="<%=vu%>">
<input type="hidden" name="num" value="<%=ordnum(conn)%>">
<input type="hidden" name="tips" value="izmaksa">
</tr>
</table>
</form>

<!-- @ 0 Validation -->
<script language="JScript">
function validate()
{
	if (forma.summa.value == "") 
		{ window.alert('Nav norâdîta summa'); return false;}
	if (forma.kredits.value == "") 
		{ window.alert('Nav norâdîts kredîta konts'); return false;}
	if (forma.debets.value == "") 
		{ window.alert('Nav norâdîts debeta konts'); return false;}
	if (!isFloat(forma.summa.value))
		{ window.alert("Summa var saturçt tikai skaitïus un vienu punktu"); return false;}
	return true;
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
