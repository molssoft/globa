<%
sub top_links
%>
<font face=Tahoma>
<a href="main.asp"><font size=3>[Tçmas]</font></a>
<a href="main_first.asp"><font size=3>[1.Lapas tçmas]</font></a>
<a href="main.asp?parent=RAKSTGRUPAS"><font size=3>[Rakstu grupas]</font></a>
<a href="default.asp"><font size=3>[Marðruti]</font></a>
<a href="avio.asp"><font size=3>[Avio biïetes]</font></a>
<a href="geo.asp"><font size=3>[Ìeogrâfija]</font></a>
<a href="intereses.asp"><font size=3>[Intereses]</font></a>
<a href="kategorijas.asp"><font size=3>[Kategorijas]</font></a>
<a href="types.asp"><font size=3>[Datu tipi]</font></a>
<a href="galerija_kopet.asp"><font size=3>[Galeriju kopçðana]</font></a>
<a href="viesnicas.asp"><font size=3>[Viesnîcas]</font></a>
<a href="viesnicu_vietas.asp"><font size=3>[Viesnîcu vietas]</font></a>

<%
end sub

Function Decode(s)
If IsNull(s) Then
 Decode = ""
 Exit Function
End If
m = s
m = Replace (m, "#a", "â")
m = Replace (m, "#c", "è")
m = Replace (m, "#e", "ç")
m = Replace (m, "#g", "ì")
m = Replace (m, "#i", "î")
m = Replace (m, "#k", "í")
m = Replace (m, "#l", "ï")
m = Replace (m, "#n", "ò")
m = Replace (m, "#s", "ð")
m = Replace (m, "#u", "û")
m = Replace (m, "#z", "þ")
m = Replace (m, "#A", "Â")
m = Replace (m, "#C", "È")
m = Replace (m, "#E", "Ç")
m = Replace (m, "#G", "Ì")
m = Replace (m, "#I", "Î")
m = Replace (m, "#K", "Í")
m = Replace (m, "#L", "Ï")
m = Replace (m, "#N", "Ò")
m = Replace (m, "#S", "Ð")
m = Replace (m, "#U", "Û")
m = Replace (m, "#Z", "Þ")

Decode = m
End Function

Function ToUnicode(s)
 ToUnicode = s
 exit function
 'pagaidâm atslçgts
 if isnull(s) then
  ToUnicode = ""
  exit function
 end if
 for i = 1 to len(s)
  Response.Write asc(mid(s,i,1))
 next
 for i = 170 to 255 
  s = replace(s,chr(i),"&#"+cstr(i+848)+";")
 next 
 ToUnicode = s
end function

Function MonthName(ch)
 If ch = "1" Then MonthName = "Janvâris"
 If ch = "2" Then MonthName = "Februâris"
 If ch = "3" Then MonthName = "Marts"
 If ch = "4" Then MonthName = "Aprîlis"
 If ch = "5" Then MonthName = "Maijs"
 If ch = "6" Then MonthName = "Jûnijs"
 If ch = "7" Then MonthName = "Jûlijs"
 If ch = "8" Then MonthName = "Augusts"
 If ch = "9" Then MonthName = "Septembris"
 If ch = "10" Then MonthName = "Oktobris"
 If ch = "11" Then MonthName = "Novembris"
 If ch = "12" Then MonthName = "Decembris"
end Function

Function TwoDigits(x)
 TwoDigits = cstr(x)
 if len(TwoDigits)<2 then TwoDigits = "0" + TwoDigits
End function

Function CurrPrint(x)
 CurrPrint = cstr(getnum(x))
 if instr(currprint,".")=0 then currprint = currprint + ".00"
 if instr(currprint,".")=len(currprint)-1 then currprint = currprint + "0"
 if instr(currprint,".")<len(currprint)-2 then currprint = mid(currprint,1,instr(currprint,".")+2)
End Function

function getnum(s_p)
on error resume next
getnum = 0
if isnull(s_p) then
 getnum = 0
else
 if cstr(s_p) = "" then
  getnum = 0
 else
  getnum = s_p
 end if
end if
end function

'--- nullprint  LEONS
function nullprint(what_p)
on error resume next
nullprint = ""
nullprint = cstr(what_p)
end function

'--- LEONS
function printdate(dat_p)
 if isnull(dat_p) then
  exit function
 end if
 printdate = cstr(day(dat_p))+"/"+cstr(month(dat_p))+"/"+cstr(year(dat_p))
end function
 
'--- atgrie&thorn; datumu p&ccedil;c dotas dienas, mene&eth;a gada
Function GetDate(pd,pm,py)
ret_l = date
 ld = clng(pd)
 lm = clng(pm)
 ly = clng(py)
 while year(ret_l)<ly
  ret_l = ret_l + 365
 wend
 while year(ret_l)>ly
  ret_l = ret_l - 365
 wend
 while month(ret_l)<lm and year(ret_l)=ly
  ret_l = ret_l + 28
 wend
 while month(ret_l)>lm and year(ret_l)=ly
  ret_l = ret_l - 28
 wend
 while day(ret_l)<ld and month(ret_l)=lm
  ret_l = ret_l + 1
 wend
 while day(ret_l)>ld and month(ret_l)=lm
  ret_l = ret_l - 1
 wend
 GetDate = ret_l
End Function

'--- pasaka vai datums ir ok
Function IsDateOK(pd,pm,py)
 ret = false
 if py< 1700 then exit function
 if py> 2500 then exit function
 if pm < 1 then exit function
 if pm > 12 then exit function 

 while year(ret)<py
  ret = ret + 365
 wend
 while year(ret)>py
  ret = ret - 365
 wend

 while month(ret)<pm
  ret = ret + 28
 wend
 while month(ret)>pm
  ret = ret - 28
 wend

 while day(ret)<pd
  ret = ret + 1
 wend
 while day(ret)>pd
  ret = ret - 1
 wend

 if pm <> month(ret) then exit function

 IsDateOK = true
End Function

Function PrintMonths(sel)
 for i_l=1 to 12
  PrintMonths = PrintMonths + "<option value="+cstr(i_l)+" " 
  if i_l = sel then PrintMonths = PrintMonths + " selected " 
  PrintMonths = PrintMonths + " >" + MonthName(i_l) + "</option>"
 next
End Function


'------------LEONS

function SQLDate(d_p)
 SQLDate = cstr(month(d_p))+"/"+cstr(day(d_p))+"/"+cstr(year(d_p))
end function

function SQLTime(d_p)
 SQLTime = cstr(month(d_p))
 SQLTime = SQLTime + "/"+cstr(day(d_p))
 SQLTime = SQLTime + "/"+cstr(year(d_p))
 SQLTime = SQLTime + " "+cstr(hour(d_p))
 SQLTIME = SQLTime+":"+cstr(minute(d_p))
 SQLTime = SQLTime+":"+cstr(second(d_p))
end function

function InputSQLDate(inp_p)
InputSQLDate = inp_p
if InputSQLDate = "" or isnull(inp_p) then
 InputSQLDate = "NULL"
else
 InputSQLDate = "'"+SQLDate(FormatedDate(InputSQLDate,"dmy"))+"'"
end if
end function

Function IsDigit(d)
s = cstr(d)
if len(s) > 1 then IsDigit = false:exit function
if len(s) < 1 then IsDigit = false:exit function
if s<"0" then IsDigit = false:exit function
if s>"9" then IsDigit = false: exit function
IsDigit = true
end function

function MoveToDigit(stringg,pp)
f = true
while pp<=len(stringg) and f
 if isdigit(mid(stringg,pp,1)) = true then 
  f = false
 else
  pp = pp + 1
 end if
wend
end function

function ReadNumber(stringg,pp)
f = true
while pp<=len(stringg) and f
 if isdigit(mid(stringg,pp,1)) = false then 
  f = false
 else
  ReadNumber = ReadNumber + mid(stringg,pp,1)
  pp = pp + 1
 end if
wend
end function


function FormatedDate(stringg,formatt)
dim d
dim m
dim y
d = day(now)
m = month(now)
y = year(now)

dim p 
p = 1
movetodigit stringg,p
for i = 1 to len(formatt)

 if mid(formatt,i,1) = "m" then
  m = cint(ReadNumber(stringg,p))
  movetodigit stringg,p
 end if
 if mid(formatt,i,1) = "d" then
  d = cint(ReadNumber(stringg,p))
  movetodigit stringg,p
 end if
 if mid(formatt,i,1) = "y" then
  sy = ReadNumber(stringg,p)
  if len(sy) = 2 then sy = "20"+sy
  y = cint(sy)
  movetodigit stringg,p
 end if
next 
if y = 0 then y = year(now)
FormatedDate = DateSerial(y,m,d)
end function

Function SQLBit(s)
 if s = "on" then
  SQLBit = "1"
 else
  SQLBit = "0"
 end if
End Function

function SQLText(s_P)
 s = s_p
 SQLText = replace(s,"'","''")
end function

function DatePrint(d)
 if isnull(d) then
  DatePrint = ""
  exit function
 end if
 a = cstr(day(d))
 if len(a)<2 then a = "0" + a
 M = cstr(month(d))
 if len(m)<2 then m = "0" + m
 Y = cstr(year(d))
 DatePrint = a+"."+m+"."+y
end function

function JavaProcs() %>
<script LANGUAGE="JavaScript">
<!--hide
function NewCenterWindow(url,w,h)
{
window.open(url,'pass', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes, resizable=no,copyhistory=no,width='+w+',height='+h+',top='+(screen.height/2-h/2)+',left='+(screen.width/2-w/2));
}
//-->
</script>

<% 
end function 

Function CheckEmail(s)
 CheckEmail = False
 valid_chars = "abcdefghijklmnopqrstuvxywz-._ABCDEFGHIJKLMNOPQRSTUVWXYZ@1234567890"
 at_pos = Instr(s,"@")
 if at_pos = 0 then exit function
 if instr(s," ") <> 0 then exit function
 if len(s)<6 then exit function
 if mid(s,len(s)-2,1)<>"." and mid(s,len(s)-3,1)<>"." then exit function
 if mid(s,1,1)="@" or mid(s,1,1)="." then exit function
 for i = 1 to len(s)
  if instr(valid_chars,mid(s,i,1)) = 0 then exit function
 next
 CheckEmail = true
End Function

function IrBrivasVietas(kods,beigu_datums)
set gconn = server.createobject("ADODB.Connection")
gconn.open "DSN=glo","www","www"


'Nosaka grupas id
'
if kods="" or IsNull(kods) then
 IrBrivasVietas = -1
 exit function
end if

set f = gconn.execute("select id,vietsk,vietsk_nakts from grupa where kods = '"+kods+"' and beigu_dat>='1/1/"+cstr(year(beigu_datums))+"' and beigu_dat<'1/1/"+cstr(year(beigu_datums)+1)+"'")
'response.write "select id,vietsk,vietsk_nakts from grupa where kods = '"+kods+"' and beigu_dat>='1/1/"+cstr(year(beigu_datums))+"' and beigu_dat<'1/1/"+cstr(year(beigu_datums)+1)+"'"
if f.eof then
 IrBrivasVietas = -1
 exit function
end if

query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
" and gid = "+cstr(f("id"))+" and pieteikums.deleted = 0 and piet_saite.deleted = 0 " + _
" and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3)"
set personas = gconn.execute(query)
query = "SELECT sum(piet_saite.vietsk) as sk " +_
	"FROM grupa,pieteikums,piet_saite " +_
	"WHERE grupa.id = "+cstr(f("id"))+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0);"
set pap = gconn.execute(query)

if BrivasVietas(getnum(f("vietsk")),getnum(f("vietsk_nakts")),getnum(personas("aizn")),getnum(pap("sk"))) > 0 then
 IrBrivasVietas = 1
else
 IrBrivasVietas = 0
end if

end function

function BrivasVietasSk(kods,beigu_datums)
set gconn = server.createobject("ADODB.Connection")
gconn.open "DSN=glo","www","www"


'Nosaka grupas id
'
if kods="" or IsNull(kods) then
 BrivasVietasSk = "Zvanît"
 exit function
end if

set f = gconn.execute("select id,vietsk,vietsk_nakts from grupa where kods = '"+kods+"' and beigu_dat>='1/1/"+cstr(year(beigu_datums))+"' and beigu_dat<'1/1/"+cstr(year(beigu_datums)+1)+"'")
'response.write "select id,vietsk,vietsk_nakts from grupa where kods = '"+kods+"' and beigu_dat>='1/1/"+cstr(year(beigu_datums))+"' and beigu_dat<'1/1/"+cstr(year(beigu_datums)+1)+"'"
if f.eof then
 BrivasVietasSk = "Zvanît"
 exit function
end if

query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
" and gid = "+cstr(f("id"))+" and pieteikums.deleted = 0 and piet_saite.deleted = 0 " + _
" and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3)"
set personas = gconn.execute(query)
query = "SELECT sum(piet_saite.vietsk) as sk " +_
	"FROM grupa,pieteikums,piet_saite " +_
	"WHERE grupa.id = "+cstr(f("id"))+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0);"
set pap = gconn.execute(query)

BrivasVietasSk = BrivasVietas(getnum(f("vietsk")),getnum(f("vietsk_nakts")),getnum(personas("aizn")),getnum(pap("sk"))) 
if BrivasVietasSk<=0 then 
 BrivasVietasSk = "0"
elseif BrivasVietasSk>7 then
 BrivasVietasSk = " vairâk par 7"
else
 BrivasVietasSk = Cstr(BrivasVietasSk)
end if

end function

Function BrivasVietas(vietsk,vietsk_nakts,persona,papild)
 BrivasVietas = vietsk-persona-papild
 if getnum(vietsk_nakts)>0 then
  brivs_nakts = vietsk_nakts - persona
  if brivasvietas>brivs_nakts then BrivasVietas = brivs_nakts
 end if
End function

function NullString(x)
 if isnull(x) then
  NullString = ""
 else
  NullString = cstr(x)
 end if
end function

Function IsSpec(id_p)
 IsSpec = false
 set r_l = conn.execute("select active,active_start,active_end,first_page_start,first_page_end,banner_start,banner_end from theMain where id = '"+id_p+"'")
 if not isnull(r_l("active_start")) then
  if r_l("active_start")>now then exit function
 end if
 if not isnull(r_l("active_end")) then
  if r_l("active_end")<now then exit function
 end if
 if not isnull(r_l("first_page_start")) then
  if r_l("first_page_start")>now then exit function
 end if
 if not isnull(r_l("first_page_end")) then
  if r_l("first_page_end")<now then exit function
 end if
 if not isnull(r_l("banner_start")) then
  if r_l("banner_start")>now then exit function
 end if
 if not isnull(r_l("banner_end")) then
  if r_l("banner_end")<now then exit function
 end if
 if r_l("active") = false then exit function
 if isnull(r_l("first_page_start")) and isnull(r_l("banner_start")) then exit function
 IsSpec = true
End Function
%>
