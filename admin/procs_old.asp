<%
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

sub top_links
%>
<font face=Tahoma>
<a href="main.asp"><font size=3>[Tçmas]</font></a>
<a href="main.asp?parent=RAKSTGRUPAS"><font size=3>[Rakstu grupas]</font></a>
<a href="default.asp"><font size=3>[Marðruti]</font></a>
<a href="klub_gal.asp"><font size=3>[Kluba galerija]</font></a>
<a href="avio.asp"><font size=3>[Avio biïetes]</font></a>
<a href="geo.asp"><font size=3>[Ìeogrâfija]</font></a>
<a href="intereses.asp"><font size=3>[Intereses]</font></a>
<a href="kategorijas.asp"><font size=3>[Kategorijas]</font></a>
<%
end sub

function TwoDigits(s)
 TwoDigits = cstr(s)
 if len(TwoDigits) = 1 then 
  TwoDigits = "0"+TwoDigits
 end if
end function

function SQLText(s_p)
 SQLText = replace(s_p,"'","''")
end function

'--- getnum
function getnum(s_p)
  on error resume next
  getnum = 0
  getnum = s_p
  if cstr(len(s_p))=0 then getnum = 0
end function

'--- nullprint
function nullprint(what_p)
on error resume next
nullprint = ""
nullprint = cstr(what_p)
end function

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

Function MonthName(pm)
 MonthName = "Date overflow."
 if pm=1 then MonthName="Janvâris"
 if pm=2 then MonthName="Februâris"
 if pm=3 then MonthName="Marts"
 if pm=4 then MonthName="Aprîlis"
 if pm=5 then MonthName="Maijs"
 if pm=6 then MonthName="Jûnijs"
 if pm=7 then MonthName="Jûlijs"
 if pm=8 then MonthName="Augusts"
 if pm=9 then MonthName="Septembris"
 if pm=10 then MonthName="Oktobris"
 if pm=11 then MonthName="Novembris"
 if pm=12 then MonthName="Decembris"
End Function

Function PrintMonths(sel)
 for i_l=1 to 12
  PrintMonths = PrintMonths + "<option value="+cstr(i_l)+" " 
  if i_l = sel then PrintMonths = PrintMonths + " selected " 
  PrintMonths = PrintMonths + " >" + MonthName(i_l) + "</option>"
 next
End Function

Function SQLDate(dat_p)
 'SQLDate = Cstr(CDate(dat_p))
 SQLDate = cstr(month(dat_p))+"/"+cstr(day(dat_p))+"/"+cstr(year(dat_p))
End Function
%>