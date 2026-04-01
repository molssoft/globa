<%

function STR_SQL(s)
dim i, s2
  s2 = ""
  for i = 1 to len(s)
    if i > 1 then s2 = s2 + "+"
    if within(mid(s,i,1),"â,è,ç,ì,î,í,ï,ò,ð,û,þ,Â,È,Ç,Ì,Î,Í,Ï,Ò,Ð,Û,Þ") then
      s2 = s2 + "NCHAR(" + cstr(ASC_SQL(ASC(mid(s,i,1)))) + ")"
    else
      s2 = s2 + "'" + mid(s,i,1) + "'"
    end if
  next
  STR_SQL = s2
end function

function within(s,s2)
dim i,j,s3
  i = 1
  within = FALSE
  while (i <= len(s2))
    j = i 
    s3 = ""
    while (mid(s2,i,1) <> ",") and (i <= len(s2))
      i = i + 1
    wend
    s3 = s3 + mid(s2,j,i-j)
    i = i + 1
	if s3 = s then within = TRUE
  wend
end function

function ASC_SQL(x)
  if x = 194 then
    s = 256
  elseif x = 200 then
    s = 268
  elseif x = 199 then
    s = 274
  elseif x = 204 then
    s = 290
  elseif x = 206 then
    s = 298
  elseif x = 205 then
    s = 310
  elseif x = 207 then
    s = 315
  elseif x = 210 then
    s = 325
  elseif x = 208 then
    s = 352
  elseif x = 219 then
    s = 362
  elseif x = 222 then
    s = 381
  elseif x = 226 then
    s = 257
  elseif x = 232 then
    s = 269
  elseif x = 231 then
    s = 275
  elseif x = 236 then
    s = 291
  elseif x = 238 then
    s = 299
  elseif x = 237 then
    s = 311
  elseif x = 239 then
    s = 316
  elseif x = 242 then
    s = 326
  elseif x = 240 then
    s = 353
  elseif x = 251 then
    s = 363
  elseif x = 254 then
    s = 382
  else
    s = x
  end if
  ASC_SQL = s  
end function

function Menesis(x)
dim s
  if x = "1" then
    s = "janvâris"
  elseif x = "2" then
    s = "februâris"
  elseif x = "3" then
    s = "marts"    
  elseif x = "4" then
    s = "aprîlis"
  elseif x = "5" then
    s = "maijs"
  elseif x = "6" then
    s = "jûnijs"
  elseif x = "7" then
    s = "jûlijs"
  elseif x = "8" then
    s = "augusts"
  elseif x = "9" then
    s = "septembris"
  elseif x = "A" then
    s = "oktobris"
  elseif x = "B" then
    s = "novembris"
  elseif x = "C" then
    s = "decembris"
  end if
  Menesis = s
end function
    
function SQLNum(s)
 if s = "" then
  SQLNum = "NULL"
 else
  SQLNum = s
 end if
end function

function SQLDateQ(s)
 if s = "" then
  SQLDateQ = "NULL"
 else
  SQLDateQ = "'" + SQLDate(FormatedDate(s,"dmy")) + "'"
 end if
end function

function IsValidCurr(x)
 if instr(x,",") then
  IsValidCurr = false
  exit function
 end if
 isValidCurr = true
 on error resume next
 a = ""
 a = ccur(x)
 if a = "" then isValidCurr = false
end function

function HexDigit(x)
 HexDigit = cstr(x)
 if x = 10 then HexDigit = "A"
 if x = 11 then HexDigit = "B"
 if x = 12 then HexDigit = "C"
end function

function MaziemBurtiem(s)
 if len(s)=1 then
  MaziemBurtiem = ucase(s)
 elseif len(s)>1 then
  MaziemBurtiem = ucase(mid(s,1,1))+lcase(mid(s,2,len(s)-1))
 end if
End function

function CheckBox(ch)
 if ch = "on" then
  CheckBox = "1" 
 else
  CheckBox = "0"
 end if
End Function

function Curr2Print(lvl_amount,usd_amount)
 Curr2Print = Curr2PrintHTML(lvl_amount,usd_amount)
end function

function Curr2PrintHTML(lvl_amount,usd_amount)
 if getnum(usd_amount) = 0 then
  if getnum(lvl_amount) = 0 then
   Curr2PrintHTML = "0.00"
  else
   Curr2PrintHTML = "<nobr>"+CurrPrint(lvl_amount)+" LVL<nobr>"
  end if
 else
  if getnum(lvl_amount) = 0 then
    Curr2PrintHTML = "<nobr>"+CurrPrint(usd_amount)+" USD</nobr>"
  else
    Curr2PrintHTML = "<nobr>"+CurrPrint(lvl_amount)+" LVL</nobr> "
   if usd_amount <> 0 then
    Curr2PrintHTML = Curr2PrintHTML +"<nobr>"+CurrPrint(usd_amount)+" USD</nobr>"
   else
    Curr2PrintHTML = Curr2PrintHTML + "<nobr>" + "+" +CurrPrint(usd_amount)+" USD</nobr>"
   end if
  end if
 end if
end function

function Curr3PrintHTML(lvl_amount,usd_amount,eur_amount)
 Curr3PrintHTML = ""
 if lvl_amount<>0 then
  Curr3PrintHTML = "<nobr>"+CurrPrint(lvl_amount) + " LVL</nobr>"
 end if
 if usd_amount<>0 then
  Curr3PrintHTML = "<nobr>"+Curr3PrintHTML + " " +CurrPrint(usd_amount) + " USD</nobr>"
 end if
 if eur_amount<>0 then
  Curr3PrintHTML = "<nobr>"+Curr3PrintHTML + " " +CurrPrint(eur_amount) + " EUR</nobr>"
 end if
 if Curr3PrintHTML = "" then Curr3PrintHTML = "0.00"
end function

function Curr3Print(lvl_amount,usd_amount,eur_amount)
 Curr3Print = ""
 if lvl_amount<>0 then
  Curr3Print = CurrPrint(lvl_amount) + " LVL"
 end if
 if usd_amount<>0 then
  Curr3Print = Curr3Print + " " +CurrPrint(usd_amount) + " USD"
 end if
 if eur_amount<>0 then
  Curr3Print = Curr3Print + " " +CurrPrint(eur_amount) + " EUR"
 end if
 if Curr3Print = "" then Curr3Print = "0.00"
end function

Function CurrPrint(x)
 CurrPrint = cstr(getnum(x))
 if instr(currprint,".")=0 then currprint = currprint + ".00"
 if instr(currprint,".")=len(currprint)-1 then currprint = currprint + "0"
 if instr(currprint,".")<len(currprint)-2 then currprint = mid(currprint,1,instr(currprint,".")+2)
End Function

Function BrivasVietas(vietsk,vietsk_nakts,persona,papild)
 BrivasVietas = vietsk-persona-papild
 if getnum(vietsk_nakts)>0 then
  brivs_nakts = vietsk_nakts - persona
  if brivasvietas>brivs_nakts then BrivasVietas = brivs_nakts
 end if
End function

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


'DalHistory
Function DalHistory
 DalHistory = "<option value=0 selected></option>"
 For i = 1 to 10
  DalHistory = DalHistory + nullprint(session("DalHistory"+cstr(i)))
 next
End Function

'AddDalHistory
Sub AddDalHistory(did_p)
 for i = 9 to 1 step - 1
  session("DalHistory"+cstr(i+1)) = session("DalHistory"+cstr(i))
 next 
 set r_l = conn.execute ("select * from dalibn where id = " + cstr(did_p))
 if r_l.eof then exit sub
 session("DalHistory1") = "<option value='"+cstr(did_p)+"'>"+dalibnieks(did_p)+"</option>" 
End Sub

'--------------------------------------
'round
function round(cip)
	lastcip = (cip - int(cip))
	round = int(cip)
	if lastcip >= 0.5 then round = round + 1
end function

'--------------------------------------
'round100
function round100(cip)
	cip = cip*100
	lastcip = (cip - int(cip))
	round100 = int(cip)
	if lastcip >= 0.5 then round100 = round100 + 1
	round100 = round100 / 100
end function

'--------------------------------------
'dalibnieks
function dalibnieks(did_p)
	vards=id_field("dalibn",did_p,"vards")
	uzvards=id_field("dalibn",did_p,"uzvards")
	nosaukums=id_field("dalibn",did_p,"nosaukums")
	dalibnieks = nosaukums
	if nosaukums = "" or isnull(nosaukums) then 
		dalibnieks = nullprint(vards)+" "+nullprint(uzvards)
	end if
end function

'--------------------------------------
'getnum
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

'--------------------------------------
'grupas_nosaukums
function grupas_nosaukums(gid_p)
dim result_l
result_l = ""
if gid_p <> 0 then 
	mid_l = id_field("grupa",gid_p,"mid")
	kods_l = id_field("grupa",gid_p,"kods")
	sakuma_dat_l = id_field("grupa",gid_p,"sakuma_dat")
	if not isnull(kods_l) then	result_l = result_l + kods_l+" "
	if len(sakuma_dat_l)>0 then result_l = result_l + dateprint(sakuma_dat_l)+" "
	result_l = result_l + id_field("marsruts",mid_l,"v")
	grupas_nosaukums = result_l
end if
end function

'-----------------------------------
'nullprint
function nullprint(what_p)
on error resume next
nullprint = ""
nullprint = cstr(what_p)
end function

'--------------------------------------
'dbcomboplus
sub dbcomboplus(table_p,tfield_p,vfield_p,name_p,value_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p + " ORDER BY " + tfield_p)
Response.Write "<select name=" + name_p + ">" + "<option value = 0>-</option>"
do while not grupas.eof
if trim(grupas(vfield_p))= trim(value_p) then
	Response.Write "<option selected value='" & grupas(vfield_p) &"'>" &  decode(grupas(tfield_p)) & "</option>"
else
	Response.Write "<option value='" & grupas(vfield_p) & "'>" &  decode(grupas(tfield_p)) & "</option>"
end if
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub

'--------------------------------------
'dbcombo
sub dbcombo(table_p,tfield_p,vfield_p,name_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p)
Response.Write "<select name=" + name_p + ">"
do while not grupas.eof
Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub

sub dbcombo_iem(table_p,tfield_p,vfield_p,name_p,office_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p)
Response.Write "<select name=" + name_p + _ 
	" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].debets.value = '26112'; " + _
	" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].debets.value = '26111';" + _
	" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'EUR') document.forms[0].debets.value = '2611Z';"">"
do while not grupas.eof
Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub



sub dbcombo_izm(table_p,tfield_p,vfield_p,name_p,office_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p)
Response.Write "<select name=" + name_p + _ 
	" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].kredits.value = '26112'; " + _
	" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].kredits.value = '26111';" + _
	" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'EUR') document.forms[0].kredits.value = '2611Z';"">"
do while not grupas.eof
Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub


'--------------------------------------
'incordnum
sub incordnum(connection_p)

dim table_l
dim num_l
set table_l = server.createobject("ADODB.Recordset")
table_l.open "ordnum",connection_p,3,3
table_l.movefirst
num_l = table_l("ordnum")
table_l("ordnum") = num_l+1
table_l.update
end sub
'--------------------------------------
'ordnum

function ordnum(connection_p)
dim table_l
set table_l = connection_p.execute ("select * from ordnum")
table_l.movefirst
ordnum = table_l("ordnum")
end function
'--------------------------------------
'id_field

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

'--------------------------------------
'grupas_combo Izdrukâ grupu sarakstu
'---- viss = 1 ja pilns saraksts. 0 ja tikai atktuaalie marshruti
'--------------------------------------
sub grupas_combo(selected_p,viss)

if selected_p = 0 or isnull(selected) then selected_p = 279
dim grupas_l
dim q_l
if viss = 1 then
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID ORDER BY marsruts.v, grupa.sakuma_dat;"
else
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= '" + SQLDate(now-5) + "' OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(selected_p) + _
    " ORDER BY marsruts.v, grupa.sakuma_dat;"
end if
Set grupas_l = conn.execute(q_l)
Response.Write "<select name='gID' size='1' value='6'>"
do while not grupas_l.eof
Response.Write "<option "
if selected_p<>0 and trim(selected_p)=trim(getnum(grupas_l("ID"))) then response.write "selected "
response.write "value='" & grupas_l("ID") & "'>" 
response.write nullprint(grupas_l("v"))+ " "+dateprint(grupas_l("sak"))+" "+nullprint(grupas_l("kods"))+"</option>"
grupas_l.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub



'--------------------------------------
'grupas_combo_piet Izdrukâ grupu sarakstu speciâli priekð pieteikuma
'Saraksts tiek disablçts ja nav tiesîbu mainît grupu
'---- viss = 1 ja pilns saraksts. 0 ja tikai atktuaalie marshruti
'--------------------------------------
sub grupas_combo_piet(selected_p,viss)

if selected_p = 0 or isnull(selected) then selected_p = 279
dim grupas_l
dim q_l
if viss = 1 then
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID ORDER BY marsruts.v, grupa.sakuma_dat;"
else
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= '" + SQLDate(now-5) + "' OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(selected_p) + _
    " ORDER BY marsruts.v, grupa.sakuma_dat;"
end if
Set grupas_l = conn.execute(q_l)
if GetLostMoneyGroup = selected_p and not IsAccess (T_ZAUD_LAB) then
	Response.Write "<select name='gID' disabled size='1' value='6'>"
else
	Response.Write "<select name='gID' size='1' value='6'>"
end if
do while not grupas_l.eof
Response.Write "<option "
if selected_p<>0 and trim(selected_p)=trim(getnum(grupas_l("ID"))) then response.write "selected "
response.write "value='" & grupas_l("ID") & "'>" 
response.write nullprint(grupas_l("v"))+ " "+dateprint(grupas_l("sak"))+" "+nullprint(grupas_l("kods"))+"</option>"
grupas_l.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub




'--------------------------------------
'galotne

function galotne(num,vsk,dsk)
s = dsk
if cipars(num,1)=1 then s = vsk
if cipars(num,2)=1 then s = dsk
galotne = s
end function
'--------------------------------------
'cipars

function cipars(num,k)
dim my
my = fix(num/(10^(k-1)))
cipars = my-(fix(my/10)*10)
end function
'--------------------------------------
'simts

function simts(num)
dim vieni(10)
dim celms(10)
dim vien
dim desm
dim sim
dim s
vieni(1)="viens"
vieni(2)="divi"
vieni(3)="trîs"
vieni(4)="èetri"
vieni(5)="pieci"
vieni(6)="seði"
vieni(7)="septiòi"
vieni(8)="astoòi"
vieni(9)="deviòi"
celms(1)="vien"
celms(2)="div"
celms(3)="trîs"
celms(4)="èetr"
celms(5)="piec"
celms(6)="seð"
celms(7)="septiò"
celms(8)="astoò"
celms(9)="deviò"
desm = cipars(num,2)
vien = cipars(num,1)
if desm = 0 then
	s = vieni(vien)+" "
end if
if desm=1 then
	if vien<>0 then
		s=celms(vien)+"padsmit "
	else
		s="desmit "
	end if
end if
if desm>1 then
	if cipars(num,1)<>0 then
		s=celms(desm)+"desmit "+vieni(vien)+" "
	else
		s=celms(desm)+"desmit "
	end if
end if
sim = cipars(num,3)
if sim<>0 then
	s = vieni(sim)+" "+galotne(sim,"simts ","simti ")+s
end if
simts = s
end function
'--------------------------------------
'nauda

function nauda(num, valuta_l)
dim tukst
dim milj
dim sant
dim s
milj = int(num/1000000)
if milj>0 then
	s = s + simts(milj)+galotne(milj,"miljons ","miljoni ")
end if
tukst = int(num/1000)
if tukst>0 then
	s = s + simts(tukst)+galotne(tukst,"tûkstotis ","tûkstoði ")
end if
s = s + simts(num)+valuta_l+" "
sant = num*100
s = s+cstr(cipars(sant,2))+Cstr(cipars(sant,1))+" "
nauda = s
end function
'--------------------------------------
'DefJavaSubmit

sub DefJavaSubmit()

response.write "<script LANGUAGE=""JScript"">"
response.write "function TopSubmit(url)"
response.write "{"
response.write "window.event.cancelBubble = true;"
response.write "	document.all['forma'].action = url;"
response.write "	document.all['forma'].submit();"
response.write "	return true;	"
response.write "};"

response.write "function TopSubmit2(url)"
response.write "{"
response.write "	forma.action = url;"
response.write "}"

response.write "</script>"
end sub
'--------------------------------------
'WhereClause

function WhereClause (fields_p,types_p,forms_p)

dim result_l
dim field_l
dim type_l
dim val_l 
field_l = nextword(fields_p)
type_l = nextword(types_p)
val_l = request.form(nextword(forms_p))
while field_l<>""
	if val_l <> "" then
		if type_l = "text"   then result_l = result_l + " and " + field_l+" like N'%" + val_l + "%'"
		if type_l = "string" then result_l = result_l + " and " + field_l+" = '" + val_l + "'"
		if type_l = "num" and val_l <> "0"  then result_l = result_l + " and " + field_l + " = " + val_l
		if type_l = "date"   then result_l = result_l + " and " + field_l+" = '" + val_l + "'"
	end if
	field_l = nextword(fields_p)
	type_l = nextword(types_p)
	val_l = request.form(nextword(forms_p))
wend
if result_l<> "" then result_l = mid(result_l,5,len(result_l)- 4)
WhereClause = result_l
end function
'--------------------------------------
'EditRecord

sub EditRecord (conection_p,sql_p,fields_p,forms_p)
dim r_l
dim val_l
dim field_l
set r_l = server.createobject("ADODB.Recordset")
r_l.open sql_p,conection_p,3,3
r_l.movefirst
field_l = nextword(fields_p)
val_l = TRIM(request.form(nextword(forms_p)))
while field_l<>""
	if val_l<>"" then 
		r_l(field_l)=val_l
	else
		r_l(field_l)=NULL
	end if
	field_l = nextword(fields_p)
	val_l = request.form(nextword(forms_p))
wend
r_l.update
session("editid") = r_l("id")
end sub
'--------------------------------------
'NewRecord

sub NewRecord (conection_p,sql_p,fields_p,forms_p)
dim r_l
dim val_l
dim field_l
set r_l = server.createobject("ADODB.Recordset")
r_l.open sql_p,conection_p,3,3
r_l.addnew
if fields_p <> "" then 
field_l = nextword(fields_p)
val_l = TRIM(request.form(nextword(forms_p)))
while field_l<>""
	if val_l<>"" then 
		r_l(field_l)=val_l
	else
		r_l(field_l)=NULL
	end if
	field_l = nextword(fields_p)
	val_l = request.form(nextword(forms_p))
wend
end if
r_l.update
set r_l = conn.execute("select max(id) from dalibn")
session("newid")= r_l(0)
end sub
'--------------------------------------
'NewRecordID

Function NewRecordID (conection_p,sql_p,fields_p,forms_p)
dim r_l
dim val_l
dim field_l
set r_l = server.createobject("ADODB.Recordset")
r_l.open sql_p,conection_p,3,3
r_l.addnew
field_l = nextword(fields_p)
val_l = request.form(nextword(forms_p))
while field_l<>""
	if val_l<>"" then 
		r_l(field_l)=val_l
	else
		r_l(field_l)=NULL
	end if
	field_l = nextword(fields_p)
	val_l = request.form(nextword(forms_p))
wend
r_l.update
newrecordid = r_l("id")
end function
'--------------------------------------
'qstring

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

function fstring()
dim s
dim k
for each k in request.form
  if k<>"subm" then
	s = s + "<input type = hidden name = '" + k + "' value = '" + request.form(k)+"'>"
  end if
next
fstring = s
end function


'--------------------------------------
'docstart

sub docstart(title,wallpaper)

response.write "<!DOCTYPE HTML PUBLIC "+chr(34)+"-//IETF//DTD HTML//EN"+chr(34)+">"
response.write "<html>"

response.write "<head>"
response.write "<meta http-equiv='Content-Type' "
response.write "content= 'text/html; charset=windows-1257'>"
response.write "<link rel=stylesheet type='text/css' href='styles.css'><style type='text/css'></style>"
response.write "<title>"+title+"</title>"
response.write "</head>"

response.write "<body background="+chr(34)+wallpaper+chr(34)+" text="+chr(34)+"#000000"+chr(34)+""
response.write "link="+chr(34)+"#008040"+chr(34)+" vlink="+chr(34)+"#804000"+chr(34)+" alink="+chr(34)+"#FF0000"+chr(34)+">"
end sub

'--------------------------------------
'QRecordCount

function QRecordCount (query_p)

i_l = instr(1,query_p,"from")
if i_l = 0 then i_l = instr(1,query_p,"FROM")
query_l = "select count(*) as sk " + mid(query_p,i_l,len(query_p)-i_l+1)
set c=conn.execute(query_l) 
QRecordCount = c("sk")
end function

'--------------------------------------
'NextWord

function NextWord (t_p)

'words must be divided by spaces
dim w
dim i
i = instr(t_p," ")
if i<>0 then
	w = mid(t_p,1,i-1)
	t_p = mid(t_p,i+1,len(t_p)-i)
else
	w = t_p
	t_p = ""
end if
NextWord = w
end function

'--------------------------------------
'QueryToTable

sub QueryToTable (query_p,num_p,head_p())

	set t=conn.execute(query_p)
	response.write("<table border="+chr(34)+"1"+chr(34)+" bgcolor=white>")
	response.write("<tr>")
	for i=1 to num_p
		response.write("<td>")
		response.write(head_p(i-1))
		response.write("</td>")
	next
	response.write("</tr>")
	t.movefirst
	while not t.eof
		response.write("<tr>")
		for i=0 to num_p-1
		if isnull(t(i)) then s = "" else s = CStr(t(i))
		cell_l = "<td>"+s+"</td>"
		response.write(cell_l)
		next
		response.write("</tr>")
		t.movenext
	wend
	response.write("</table>")
end sub

'--------------------------------------
'QueryToLinkTable

sub QueryToLinkTable (query_p,num_p,url_p,head_p())
	set t=conn.execute(query_p)
	response.write("<table border='0' bgcolor=white>")
	response.write("<tr bgcolor = #ffC1cc >")
	response.write("<td></td>")
	for i=1 to num_p
		response.write("<td>")
		response.write(head_p(i-1))
		response.write("</td>")
	next
	response.write("</tr>")
	t.movefirst
	while not t.eof
		if not isnull (t(num_p)) then  linkid = CStr(t(num_p)) else linkid = ""
		response.write("<tr  bgcolor = #fff1cc ><td><a href = '"+url+linkid+"'><img src='impro/bildes/k_zals.gif'></a></td>")
		for i=0 to num_p-1
		if isnull(t(i)) then s = "" else s = CStr(t(i))
		cell_l = "<td>"+s+"</td>"
		response.write(cell_l)
		next
		response.write("</tr>")
		t.movenext
	wend
	response.write("</table>")
end sub

'--------------------------------------
'TRecordCount

function TRecordCount (table_p)
	set c=conn.execute("select count(*) as sk from "+table_p) 
	TRecordCount = c("sk")
end function

'--------------------------------------
'DefValidate
sub DefValidate()
Response.Write("<script language = 'JScript'>")
Response.Write("function isInt(checkP)")
Response.Write("{")
Response.Write("  var checkOK = '0123456789';")
Response.Write("  var checkStr = checkP;")
Response.Write("  var allValid = true;")
Response.Write("  for (i = 0;  i < checkStr.length;  i++)")
Response.Write("  {")
Response.Write("    ch = checkStr.charAt(i);")
Response.Write("    for (j = 0;  j < checkOK.length;  j++)")
Response.Write("      if (ch == checkOK.charAt(j))")
Response.Write("        break;")
Response.Write("    if (j == checkOK.length)")
Response.Write("    {")
Response.Write("      allValid = false;")
Response.Write("      break;")
Response.Write("    }")
Response.Write("  }")
Response.Write("  if (!allValid) return (false);")
Response.Write("  return true;")
Response.Write("}")
Response.Write("function isFloat(checkP)")
Response.Write("{")
Response.Write("  var checkOK = '0123456789.';")
Response.Write("  var checkStr = checkP;")
Response.Write("  var allValid = true;")
Response.Write("  var count = 0;")
Response.Write("  for (i = 0;  i < checkStr.length;  i++)")
Response.Write("  {")
Response.Write("    ch = checkStr.charAt(i);")
Response.Write("    for (j = 0;  j < checkOK.length;  j++)")
Response.Write("      if (ch == checkOK.charAt(j))")
Response.Write("        break;")
Response.Write("    if (j == checkOK.length)")
Response.Write("    {")
Response.Write("      allValid = false;")
Response.Write("      break;")
Response.Write("    }")
Response.Write("  }")
Response.Write("  if (!allValid) return (false);")
Response.Write("")
Response.Write("  for (i = 0;  i < checkStr.length;  i++)")
Response.Write("  {")
Response.Write("    if (checkStr.charAt(i)=='.') count++;")
Response.Write("  }")
Response.Write("  if (count>1)  return false;")
Response.Write("  return true;")
Response.Write("}")
Response.Write("function isString(checkP)")
Response.Write("{")
Response.Write("  var checkOK = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz¨ª¯¸º¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþ';")
Response.Write("  var checkStr = checkP;")
Response.Write("  var allValid = true;")
Response.Write("  for (i = 0;  i < checkStr.length;  i++)")
Response.Write("  {")
Response.Write("    ch = checkStr.charAt(i);")
Response.Write("    for (j = 0;  j < checkOK.length;  j++)")
Response.Write("      if (ch == checkOK.charAt(j))")
Response.Write("        break;")
Response.Write("    if (j == checkOK.length)")
Response.Write("    {")
Response.Write("      allValid = false;")
Response.Write("      break;")
Response.Write("    }")
Response.Write("  }")
Response.Write("  if (!allValid) return (false);")
Response.Write("  return true;")
Response.Write("}")
Response.Write("function isDate(checkP)")
Response.Write("{")
Response.Write("  var checkStr = checkP;")
Response.Write("  var arr;")
Response.Write("  var allValid = true;")
Response.Write("  var m;")
Response.Write("  var d;")
Response.Write("  var y;")
Response.Write("  arr = checkStr.split('/');")
Response.Write("  d = parseInt(arr[1]);")
Response.Write("  m = parseInt(arr[0]);")
Response.Write("  y = parseInt(arr[2]);")
Response.Write("  if (isNaN(m))  return false;")
Response.Write("  if (m<1) return false;")
Response.Write("  if (m>12) return false;")
Response.Write("  if (isNaN(d)) return false;")
Response.Write("  if (d<1) return false;")
Response.Write("  if (d>31) return false;")
Response.Write("  if (isNaN(y)) return false;")
Response.Write("  if (y<1890) return false;")
Response.Write("  if (y>2100) return false;")
Response.Write("  return true;")
Response.Write("}")
Response.Write("</script>")
end sub

' ------------------------------------
'dateprint 
function dateprint(date_p)
dim ret_l
on error resume next
dateprint = ""
if not isnull(date_p) then 
	dateprint = cstr(day(date_p))+"/"+cstr(month(date_p))+"/"+cstr(year(date_p))
else
	dateprint = ""
end if
end function

'timeprint
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

'@ DigitCount
'Prints at least two digits 01,02 etc.
function TwoDigits(x)
if x<10 then TwoDigits = "0" + cstr(x) else TwoDigits = cstr(x)
end function

'________________
Function IsDigit(d)
s = cstr(d)
if len(s) > 1 then IsDigit = false:exit function
if len(s) < 1 then IsDigit = false:exit function
if s<"0" then IsDigit = false:exit function
if s>"9" then IsDigit = false: exit function
IsDigit = true
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
	if s3 = "" then 
         s3 = cstr(year(now))
	end if
	i3 = cint(s3)
	NormalDate = cstr(i2)+"/"+cstr(i1)+"/"+cstr(i3)+" "+tim
end if
end function
' ------------------------------------


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


function SQLTime(d_p)
 SQLTime = cstr(month(d_p))
 SQLTime = SQLTime + "/"+cstr(day(d_p))
 SQLTime = SQLTime + "/"+cstr(year(d_p))
 SQLTime = SQLTime + " "+cstr(hour(d_p))
 SQLTIME = SQLTime+":"+cstr(minute(d_p))
 SQLTime = SQLTime+":"+cstr(second(d_p))
end function

function NormalDate2(date_p)
on error resume next
x = date_p + date_p
if len(cstr(date_p)) <> len(cstr(x))/2 then
	NormalDate = cstr(day(date_p))+"/"+cstr(month(date_p))+"/"+cstr(year(date_p))
else 
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
	if s3 = "" then 
         s3 = cstr(year(now))
	end if
	i3 = cint(s3)
	NormalDate2 = cstr(i1)+"/"+cstr(i2)+"/"+cstr(i3)
end if
end function


'----------------------
'GetUser - atgrieþ lietotâja loginu
'----------------------
function GetUser()
	GetUser=request.servervariables("logon_user")
	If GetUser = "" then GetUser = "unknown"
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

function IsValidDate(stringg,formatt)
dim d
dim m
dim y
d = 0
m = 0
y = 0

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
if y = 0 or m = 0 or d = 0 then
  IsValidDate = false
else
  IsValidDate = true
end if
end function


Function FormatedTime(stringg,formatt)
n = 0
s = 0
h = 0
d = day(now)
m = month(now)
y = year(now)

p = 1
movetodigit stringg,p
for i = 1 to len(formatt)
 if mid(formatt,i,1) = "s" then
  s = cint(ReadNumber(stringg,p))
  movetodigit stringg,p
 end if
 if mid(formatt,i,1) = "n" then
  n = cint(ReadNumber(stringg,p))
  movetodigit stringg,p
 end if
 if mid(formatt,i,1) = "h" then
  h = cint(ReadNumber(stringg,p))
  while h>23
   h=h-23
   d=d+1
  wend
  movetodigit stringg,p
 end if

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
FormatedTime = DateSerial(y,m,d)+TimeSerial(h,n,s)
end function


Function CheckEmail(s)
 CheckEmail = False
 valid_chars = "abcdefghijklmnopqrstuvxywz-._ABCDEFGHIJKLMNOPQRSTUVWXYZ@1234567890+"
 at_pos = Instr(s,"@")
 if at_pos = 0 then exit function
 if instr(s," ") <> 0 then exit function
 if len(s)<6 then exit function
 if mid(s,len(s)-2,1)<>"." and mid(s,len(s)-3,1)<>"." then exit function
 if mid(s,1,1)="@" or mid(s,1,1)="." then exit function
 atcount = 0
 for i = 1 to len(s)
  if instr(valid_chars,mid(s,i,1)) = 0 then exit function
  if mid(s,i,1) = "@" then atcount = atcount + 1
 next
 if atcount <> 1 then exit function
 CheckEmail = true
End Function

Function DoubleChar(s,ch)
 for i = 1 to len(s)
  DoubleChar = DoubleChar + mid(s,i,1)
  if mid(s,i,1) = ch then doubleChar = doubleChar + ch
 next
End function

Function ReplaceChar(s,ch,repl)
 for i = 1 to len(s)
  if mid(s,i,1) = ch then 
   ReplaceChar = ReplaceChar + repl
  else
   ReplaceChar = ReplaceChar + mid(s,i,1)
  end if
 next
End function

function SQLText(s)
 dim i
 SQLText = replace(s,"'","''")
end function

%>