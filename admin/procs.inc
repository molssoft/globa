<%

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
getnum = s_p
if cstr(len(s_p))=0 then getnum = 0
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
if office_p = "biedriba" then
	Response.Write "<select name=" + name_p + _ 
		" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].debets.value = '26112'; " + _
		" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].debets.value = '26111';"">"
end if
if office_p = "kazarmas" then
	Response.Write "<select name=" + name_p + _ 
		" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].debets.value = '26122'; " + _
		" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].debets.value = '26121';"">"
end if
do while not grupas.eof
Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub



sub dbcombo_izm(table_p,tfield_p,vfield_p,name_p,office_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p)
if office_p = "biedriba" then
	Response.Write "<select name=" + name_p + _ 
		" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].kredits.value = '26112'; " + _
		" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].kredits.value = '26111';"">"
end if
if office_p = "kazarmas" then
	Response.Write "<select name=" + name_p + _ 
		" onchange=""if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'USD') document.forms[0].kredits.value = '26122'; " + _
		" if (document.forms[0].valuta.options[document.forms[0].valuta.options.selectedIndex].text == 'Ls') document.forms[0].kredits.value = '26121';"">"
end if
do while not grupas.eof
Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
end sub


'--------------------------------------
'dbcomboplus
sub dbcomboplus(table_p,tfield_p,vfield_p,name_p,value_p)

dim grupas
Set grupas = conn.execute("select * from " + table_p + " ORDER BY " + tfield_p)
Response.Write "<select name=" + name_p + ">" + "<option value = 0>-</option>"
do while not grupas.eof
if trim(grupas(vfield_p))= trim(value_p) then
	Response.Write "<option selected value='" & grupas(vfield_p) &"'>" &  grupas(tfield_p) & "</option>"
else
	Response.Write "<option value='" & grupas(vfield_p) & "'>" &  grupas(tfield_p) & "</option>"
end if
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
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID ORDER BY marsruts.v;"
else
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= #" + SQLDate(now-5) + "# OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(selected_p) + _
    " ORDER BY marsruts.v;"
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
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID ORDER BY marsruts.v;"
else
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= #" + SQLDate(now-5) + "# OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(selected_p) + _
    " ORDER BY marsruts.v;"
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
		if type_l = "text"   then result_l = result_l + " and " + field_l+" like '" + val_l + "%'"
		if type_l = "string" then result_l = result_l + " and " + field_l+" = '" + val_l + "'"
		if type_l = "num" and val_l <> "0"  then result_l = result_l + " and " + field_l + " = " + val_l
		if type_l = "date"   then result_l = result_l + " and " + field_l+" = #" + val_l + "#"
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
r_l.movelast
session("newid")= r_l("id")
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
	s = s + "<input type = hidden name = '" + k + "' value = '" + request.form(k)+"'>"
next
fstring = s
end function


'--------------------------------------
'headlinks

sub headlinks()

response.write "<center><font size=2>"
response.write "[ <a href="+chr(34)+"default.asp"+chr(34)+">Mâjas</a> ]"
response.write "[ <a href="+chr(34)+"dalibn.asp"+chr(34)+">Dalîbnieki</a> ]  "
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
		response.write("<tr  bgcolor = #fff1cc ><td><a href = '"+url+linkid+"'><img src='/impro/bildes/k_zals.gif'></a></td>")
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
if not isnull(date_p) then 
	ret_l = ret_l + cstr(day(date_p))+"/"
	ret_l = ret_l + cstr(month(date_p))+"/"
	ret_l = ret_l + cstr(year(date_p))
	dateprint = ret_l
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
x = date_p + date_p
if len(cstr(date_p)) <> len(cstr(x))/2 then
	NormalDate = cstr(month(date_p))+"/"+cstr(day(date_p))+"/"+cstr(year(date_p))
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
	i3 = cint(s3)
	NormalDate = cstr(i2)+"/"+cstr(i1)+"/"+cstr(i3)
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

function Dubultot(s,ch)
for i = 1 to len(s)
 Dubultot = Dubultot + mid(s,i,1)
 if mid(s,i,1)=ch then Dubultot = Dubultot + ch
next
end function



%>