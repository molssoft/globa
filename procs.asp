<%


function NullString(x)
 if isnull(x) then
  NullString = ""
 else
  NullString = cstr(x)
 end if
end function

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


Function Encode(s)
If IsNull(s) Then
 Decode = ""
 Exit Function
End If
m = s
m = Replace (m, "â", "#a")
m = Replace (m, "è","#c")
m = Replace (m, "ç","#e")
m = Replace (m, "ì","#g")
m = Replace (m, "î","#i")
m = Replace (m, "í","#k")
m = Replace (m, "ï","#l")
m = Replace (m, "ò","#n")
m = Replace (m, "ð","#s")
m = Replace (m, "û","#u")
m = Replace (m, "þ","#z")
m = Replace (m, "Â","#A")
m = Replace (m, "È","#C")
m = Replace (m, "Ç","#E")
m = Replace (m, "Ì","#G")
m = Replace (m, "Î","#I")
m = Replace (m, "Í","#K")
m = Replace (m, "Ï","#L")
m = Replace (m, "Ò","#N")
m = Replace (m, "Ð","#S")
m = Replace (m, "Û","#U")
m = Replace (m, "Þ","#U")

Encode = m
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

Function ToUnicodeLV(x)
 s = x
 s = replace(s,"â","&#257;")
 s = replace(s,"è","&#269;")
 s = replace(s,"ç","&#275;")
 s = replace(s,"ì","&#291;")
 s = replace(s,"î","&#299;")
 s = replace(s,"í","&#311;")
 s = replace(s,"ï","&#316;")
 s = replace(s,"ò","&#326;")
 s = replace(s,"ð","&#352;")
 s = replace(s,"û","&#363;")
 s = replace(s,"þ","&#382;")
 s = replace(s,"Â","&#256;")
 s = replace(s,"È","&#268;")
 s = replace(s,"Ç","&#274;")
 s = replace(s,"Ì","&#290;")
 s = replace(s,"Î","&#298;")
 s = replace(s,"Í","&#310;")
 s = replace(s,"Ï","&#315;")
 s = replace(s,"Ò","&#325;")
 s = replace(s,"Ð","&#351;")
 s = replace(s,"Û","&#362;")
 s = replace(s,"Þ","&#381;")
 ToUnicodeLV = s
End function

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

function SQLDate(d_p)
 SQLDate = cstr(month(d_p))+"/"+cstr(day(d_p))+"/"+cstr(year(d_p))
end function

function SQLDateYMD(d_p)
 SQLDateYMD = cstr(year(d_p))+"-"+cstr(month(d_p))+"-"+cstr(day(d_p))
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

function SQLText(s_P)
 s = s_p
 SQLText = replace(s,"'","''")
end function

function DatePrint(d)
 if isnull(d) then
  DatePrint = ""
  exit function
 end if
 if cstr(year(d)) = "1900" then
  DatePrint = ""
 'exit function
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

query = "SELECT isnull(sum(piet_saite.vietsk),0) as sk " +_
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
'BrivasVietasSk = Cstr(kods)
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
'BrivasVietas = persona
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
