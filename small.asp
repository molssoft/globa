<%

Function Encode(s)
 enlett = "âèçìîíïòðûþÂÈÇÌÎÍÏÒÐÛÞ"
 for u = 1 to len(s)
  z = mid(s,u,1)
  if instr(enlett,z) <> 0 then Encode = Encode + "#"
  if z = "â" then z = "a"
  if z = "è" then z = "c"
  if z = "ç" then z = "e"
  if z = "ì" then z = "g"
  if z = "î" then z = "i"
  if z = "í" then z = "k"
  if z = "ï" then z = "l"
  if z = "ò" then z = "n"
  if z = "ð" then z = "s"
  if z = "û" then z = "u"
  if z = "þ" then z = "z"
  if z = "Â" then z = "A"
  if z = "È" then z = "C"
  if z = "Ç" then z = "E"
  if z = "Ì" then z = "G"
  if z = "Î" then z = "I"
  if z = "Í" then z = "K"
  if z = "Ï" then z = "L"
  if z = "Ò" then z = "N"
  if z = "Ð" then z = "S"
  if z = "Û" then z = "U"
  if z = "Þ" then z = "Z"
  Encode = Encode + Z
 next
End Function


function Get_User()
Get_User = request.ServerVariables("LOGON_USER")
for i = 1 to len(Get_User)
	if mid(Get_User,i,1) = "\" then
		Get_User = mid(Get_User,i+1,len(Get_User)-i)
		exit function
	end if
next
if get_user = "" then get_user = "unknown"
end function

'-----------------------
'Atgrieþ, vai tekoðais jûzeris ir pilnvarots, òemot vçrâ usera tiesîbas (string*10)
'Ja tâda usera nav tad tas tiek piereìistrçts ar funkciju GetCurUserID
'----------------------
function IsAccess(tiesibas)
	set rAccess = conn.execute ("SELECT * FROM TiesibuSaites WHERE LietotajsID = " + cstr(GetCurUserID) + " AND TiesibasID = " + cstr(tiesibas))
	if not rAccess.eof then
		isAccess=true
	else
		isAccess=false
	end if
end function


'-----------------------
'Atgrieþ, vai tekoðais jûzeris ir pilnvarots, òemot vçrâ usera vârdu (string*20) un tiesîbas (string*10)
'Ja tâda usera nav tad atgrieþ false
'----------------------
function IsUserAccess(lietotajs,tiesibas)
	set rAccess = conn.execute ("SELECT * FROM TiesibuSaites WHERE LietotajsID = " + cstr(lietotajs) + " AND TiesibasID = " + cstr(tiesibas))
	if not rAccess.eof then
		isUserAccess=true
	else
		isUserAccess=false
	end if
end function



sub OpenConn ()
set conn = server.createobject("ADODB.Connection")
conn.open "DSN=globa"
end sub

sub headlinks()

response.write "<center><font size=2>"
response.write "[ <a href="+chr(34)+"default.asp"+chr(34)+">Mâjas</a> ]"
response.write "[ <a href="+chr(34)+"dalibn.asp"+chr(34)+">Dalîbnieki</a> ]  "
response.write "[ <a href="+chr(34)+"marsruti.asp"+chr(34)+">Labot marðrutus</a> ] "
response.write "[ <a href="+chr(34)+"grupas.asp"+chr(34)+">Labot grupas</a> ] "
response.write "[ <a href="+chr(34)+"out_grupa.asp"+chr(34)+">Ceïojumu Grupas</a> ] "
response.write "[ <a href=""terms.asp"">Iemaksu termiòi</a> ] "
response.write "[ <a href=""kavetaji_param.asp"">Kavçtâju saraksts</a> ] "
response.write "[ <a href=""ord_list.asp"">Operâciju pârskats</a> ] "
response.write "[ <a href="+chr(34)+"valuta.asp"+chr(34)+">Valûtas kursi</a> ] "
response.write "[ <a href="+chr(34)+"agenti.asp"+chr(34)+">Aìenti</a> ] "
response.write "[ <a href="+chr(34)+"agenti_stat.asp"+chr(34)+">Aìentu statistika</a> ] "
response.write "[ <a href="+chr(34)+"piet_meklesana.asp"+chr(34)+">Pieteikumu pârskats</a> ] "
response.write "</font></center>"
end sub

'--------------------------------------
'docstart

sub docstart(title,wallpaper)

response.write "<!DOCTYPE HTML PUBLIC "+chr(34)+"-//IETF//DTD HTML//EN"+chr(34)+">"
response.write "<html>"

response.write "<head>"
response.write "<meta http-equiv="+chr(34)+"Content-Type"+chr(34)+""
response.write "content="+chr(34)+"text/html; charset=windows-1257"+chr(34)+">"
response.write "<title>"+title+"</title>"
response.write "</head>"

response.write "<body background="+chr(34)+wallpaper+chr(34)+" text="+chr(34)+"#000000"+chr(34)+""
response.write "link="+chr(34)+"#008040"+chr(34)+" vlink="+chr(34)+"#804000"+chr(34)+" alink="+chr(34)+"#FF0000"+chr(34)+">"
end sub



'________________
Function IsDigit(d)
s = cstr(d)
if len(s) > 1 then IsDigit = false:exit function
if len(s) < 1 then IsDigit = false:exit function
if s<"0" then IsDigit = false:exit function
if s>"9" then IsDigit = false: exit function
IsDigit = true
end function

'getnum
function getnum(s_p)
on error resume next
getnum = 0
if isnull(s_p) then
 getnum = 0
else
 getnum = s_p
end if
end function

function nullprint(what_p)
on error resume next
nullprint = ""
nullprint = cstr(what_p)
end function

function dateprint(date_p)
dim ret_l
if not isnull(date_p) then 
	dateprint = cstr(day(date_p))+"/"+cstr(month(date_p))+"/"+cstr(year(date_p))
else
	dateprint = ""
end if
end function

function NormalDate(date_p)
on error resume next
if nullprint(date_p) = "" then
 NormalDate = ""
 exit function
end if

x = date_p + date_p
if len(cstr(date_p)) <> len(cstr(x))/2 then
	NormalDate = cstr(month(date_p))+"/"+cstr(day(date_p))+"/"+cstr(year(date_p))
else 
	s = date_p
	tim = ""
	if instr(s," ")<>0 then
	 tim = mid(s,instr(s," "),len(s)-instr(s," ")+1)
	end if
	i = 1
	while isdigit(mid(s,i,1))
		s1=s1+mid(s,i,1)
		i = i + 1
	wend
	i = i + 1
	while isdigit(mid(s,i,1))
		s2=s2+mid(s,i,1)
		i = i + 1
	wend
	i = i + 1
	while isdigit(mid(s,i,1))
		s3=s3+mid(s,i,1)
		i = i + 1
	wend
	i1 = cint(s1)
	i2 = cint(s2)
	i3 = cint(s3)
	NormalDate = cstr(i2)+"/"+cstr(i1)+"/"+cstr(i3)+" "+tim
end if
end function


' ------------------------------------
'SQLDate
function SQLDate(d_p)
sqldate = normaldate(d_p)
exit function
end function

function SQLDate2(d_p)
sqldate2 = normaldate2(d_p)
exit function
end function

function NormalDate2(date_p)
on error resume next
if typename(date_p) = "date" then
 NormalDate2 = "xx"
s = date_p
i = 1
while isdigit(mid(s,i,1))
	s1=s1+mid(s,i,1)
	i = i + 1
wend
i = i + 1
while isdigit(mid(s,i,1))
	s2=s2+mid(s,i,1)
	i = i + 1
wend
i = i + 1
while isdigit(mid(s,i,1))
	s3=s3+mid(s,i,1)
	i = i + 1
wend
i1 = cint(s1)
i2 = cint(s2)
i3 = cint(s3)
NormalDate2 = cstr(i1)+"/"+cstr(i2)+"/"+cstr(i3)
end if
end function

function timeprint(date_p)
dim ret_l
if not isnull(date_p) then 
	ret_l = ret_l + cstr(day(date_p))+"/"
	ret_l = ret_l + cstr(month(date_p))+"/"
	ret_l = ret_l + cstr(year(date_p))+" "
	ret_l = ret_l + twodigits(hour(date_p))+":"
	ret_l = ret_l + twodigits(minute(date_p))
	timeprint = ret_l
else
	timeprint = ""
end if
end function

function TwoDigits(x)
if x<10 then TwoDigits = "0" + cstr(x) else TwoDigits = cstr(x)
end function

function id_field(table_p, id_p,field_p)
dim q_l
dim table_l
if isnull(id_p) then id_p = "0"
if id_p = "" then id_p = "0"
q_l = "SELECT id,"+field_p+" from "+table_p+" where id = "+cstr(id_p)
set table_l = conn.execute(q_l)
if table_l.eof  then 
	id_field = ""
else
	id_field = table_l(field_p)
end if
table_l.close
end function

'DefJavaSubmit

sub DefJavaSubmit()
%>
<script LANGUAGE=""JScript"">
function TopSubmit(url)
{
window.event.cancelBubble = true;
	document.all['forma'].action = url;
	document.all['forma'].submit();
	return true;	
}
</script>

<%
end sub

function qstring()
dim s
dim k
for each k in request.querystring
	s = s + k + "=" + request.querystring(k)+"&"
next
if len(s) > 1 then s = mid(s,1,len(s)-1)
if len(s) = 1 then s = ""
if s<>"" then s = "?" + s
qstring = s
end function


%>