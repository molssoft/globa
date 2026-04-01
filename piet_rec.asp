<%
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

function piet_vietas(pid_p)
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (deleted = 0 ) and pid ="+cstr(pid_p))
piet_vietas = r("sk")
end function


'-------------------------------
'---- Pieteikums_recalculate ---
'-------------------------------
'Pârçíina visas piet_saites pakalpojumâ
Sub Pieteikums_recalculate(pid_p)
set r_l = conn.execute ("SELECT id FROM piet_saite WHERE pid = " + cstr(pid_p) + " AND (not deleted=1)")
while not r_l.eof
 piet_saite_recalculate(r_l("id"))
 r_l.movenext
wend

atlaides_l = getnum(piet_atlaides(pid_p))
iemaksas_l = getnum(piet_iemaksas(pid_p))
izmaksas_l = getnum(piet_izmaksas(pid_p))
summa_l =    getnum(piet_kopsumma(pid_p))
personas_l = getnum(piet_personas(pid_p))
papildvietas_l = getnum(piet_papildvietas(pid_p))

conn.execute "UPDATE Pieteikums SET personas = "+cstr(personas_l)+",papildvietas="+cstr(papildvietas_l)+", atlaides = "+cstr(atlaides_l)+",iemaksas = "+cstr(iemaksas_l)+",izmaksas = "+cstr(izmaksas_l)+",summa = "+cstr(summa_l) + " WHERE id = " + cstr(pid_p)

bilance_l = getnum(piet_bilance(pid_p))
info_l = piet_info(pid_p)
conn.execute "UPDATE Pieteikums SET bilance = "+cstr(bilance_l)+",info = '"+info_l+"' where id = " + cstr(pid_p)
End Sub




'-------------------------------
'---- Pieteikums_recalculate_short ---
'-------------------------------
'Pârçíina tikai pashu pieteikumu nepaarekinot saites
Sub Pieteikums_recalculate_short(pid_p)

atlaides_l = getnum(piet_atlaides(pid_p))
iemaksas_l = getnum(piet_iemaksas(pid_p))
izmaksas_l = getnum(piet_izmaksas(pid_p))
summa_l =    getnum(piet_kopsumma(pid_p))
conn.execute "UPDATE Pieteikums SET atlaides = "+cstr(atlaides_l)+",iemaksas = "+cstr(iemaksas_l)+",izmaksas = "+cstr(izmaksas_l)+",summa = "+cstr(summa_l) + " WHERE id = " + cstr(pid_p)

bilance_l = piet_bilance(pid_p)
conn.execute "UPDATE Pieteikums SET bilance = "+cstr(bilance_l)+ " WHERE id = " + cstr(pid_p)

conn.execute "UPDATE Pieteikums SET Info = '"+Piet_info(pid_p)+"' WHERE id = " + cstr(pid_p)

End Sub



'-------------------------------
'---- Piet_saite_recalculate ---
'-------------------------------
'Pârçíina pakalpojuma vai vietas cenu un citas lietas
Sub Piet_saite_recalculate(psid_p)
  '---- sakalkuleetaa summa
  dim sum_l
  sum_l = 0
  '---- dabon ðo saiti no datubâzes
  set r_l = conn.execute ("select * from piet_saite where id = " + cstr(psid_p))
  '---- pârbauda vai ir pieðíirta kâda vieta
  if getnum(r_l("vietas_veids")) <> 0 then
    '----- Atrod ðîs vietas cenu
    set r_cena_l = conn.execute ("select * from vietu_veidi where id = " + cstr(r_l("vietas_veids")))
    '----- Pârbauda vai ðâds vietas veids eksistç
    if not r_cena_l.eof then
		'----- saglabâ ðîs vietas cenu, papildv un personas pazimi
		if r_cena_l("papildv") then papildv_l = "1" else papildv_l="0"
		if r_cena_l("persona") then persona_l = "1" else persona_l="0"
		conn.execute "UPDATE piet_saite set vietas_cena = " + cstr(getnum(r_cena_l("cena"))) + _
		", papildv = "+papildv_l+", persona = "+persona_l+" WHERE id = " + cstr(psid_p)
	else
		'----- saglabâ ðîs vietas cenu ka tâ ir 0
		conn.execute "UPDATE piet_saite set vietas_cena = 0 " + _
		" WHERE id = " + cstr(psid_p)
	end if
  else
    '----- saglabâ ðîs vietas cenu ka tâ ir 0
    conn.execute "UPDATE piet_saite set vietas_cena = 0 " + _
	" WHERE id = " + cstr(psid_p)
  end if

  '---- pârbauda vai ir pieðíirta kâda kajîte
  if getnum(r_l("kid")) <> 0 then
    '----- Atrod ða kajîti
    set r_kajite_l = conn.execute ("select * from kajite " + _ 
    "where kajite.id = " + cstr(r_l("kid")))
    '----- saglabâ ðîs vietas cenu
    conn.execute "UPDATE piet_saite set kvietas_cena = " + cstr(Kajites_Veida_Cena(getnum(r_kajite_l("veids")),getnum(r_l("kvietas_veids")) )) + _
	" WHERE id = " + cstr(psid_p)
  else
    '----- saglabâ ðîs vietas cenu ka tâ ir 0
    conn.execute "UPDATE piet_saite set kvietas_cena = 0 " + _
	" WHERE id = " + cstr(psid_p)
  end if


  '--- vçlreiz atver pieteikuma saiti lai sakalkulçtu cenas
  set r_l = conn.execute ("select * from piet_saite where id = " + cstr(psid_p))
  '----- Pieskaita vietas cenu
  sum_l = sum_l + getnum(r_l("vietas_cena"))
  '----- Pieskaita kajîtes cenu
  sum_l = sum_l + getnum(r_l("kvietas_cena"))
  '--- pieskaita cenas korekciju korekciju
  sum_l = (sum_l + getnum(r_l("cena"))) * getnum(r_l("vietsk"))
  '--- saglabâ sakalkulçto summu tai paðâ ierakstâ
  conn.execute "UPDATE piet_saite set summa = " + cstr(getnum(sum_l)) + _
	" WHERE id = " + cstr(psid_p)
End Sub

'-------------------------------------
'kv_p - kajîtes veids (kajites_veidi.id)
'kvv_p - kajîtes vietas veids (piet_saite.kvietas_veids)
Function Kajites_veida_cena (kv_p,kvv_p)
set r_l = conn.execute("SELECT * FROM kajites_veidi WHERE id = " + cstr(getnum(kv_p)))
Kajites_veida_cena = 0
if not r_l.eof then
	if kvv_p = 1 then Kajites_veida_cena = r_l("standart_cena")
	if kvv_p = 2 then Kajites_veida_cena = r_l("bernu_cena")
	if kvv_p = 3 then Kajites_veida_cena = r_l("papild_cena")
	if kvv_p = 4 then Kajites_veida_cena = r_l("senioru_cena")
	if kvv_p = 5 then Kajites_veida_cena = r_l("pusaudzu_cena")
else
	Kajites_veida_cena = 0
end if
end function

function piet_papildvietas(pid_p)
'----- vajadzçs updeitot, kad pâries uz jauno sistçmu
'----- tas bûs tad, kad personas laukâ nebûs Nulles.
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (NOT DELETED = 1) and (papildv = 1) and pid ="+cstr(pid_p))
piet_papildvietas = r("sk")
end function


'---------------------
'@ 0 piet_kopsumma
function piet_kopsumma(pid_p)
set r = conn.execute("select sum(summa) as sm from piet_saite where (not deleted = 1) and pid ="+cstr(pid_p))
piet_kopsumma = r("sm")
end function

'@ 0 piet_atlaides
function piet_atlaides(pid_p)
summa=0
set r = conn.execute("select * from orderis where (not deleted=1) and pid ="+cstr(pid_p))
set rAtl = conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums=0 and pid = " + cstr(pid_p))
set rPiem = conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums=1 and pid = " + cstr(pid_p))
if piet_nVal(pid_p) = "Ls" then
	while not r.eof
	 summa = summa + (r("atlaide")/100) * r("summa")
	r.movenext
	wend
else
	set valUSD = server.createobject("ADODB.Recordset")
	while not r.eof
		valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
		if not valusd.eof then
			summa = summa + (r("summa")*valUSD("kurss2")) * (r("atlaide")/100)
		end if
		valUSD.close
		r.movenext
	wend
end if
summa = summa + getnum(rAtl("x"))-getnum(rPiem("x"))
piet_atlaides = round(getnum(summa)*100)/100
end function



'---------------------
'@ 0 piet_iemaksas
function piet_iemaksas(pid_p)
dim sum
if piet_nVal(pid_p) = "Ls" then
	set r = conn.execute("select sum(summa) as sm from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
	piet_iemaksas = getnum(r("sm"))
else
	set r = conn.execute("select * from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
	set valUSD = server.createobject("ADODB.Recordset")
	sum = 0
	while not r.eof
		valUSD.open "select kurss2 from valutakurss where datums = '"+sqldate(r("datums")) +"' AND valuta = 68",conn,3,3
		if not valUSD.eof then
			sum = sum + getnum(r("summa")) * getnum(valUSD("kurss2"))
		end if
		valUSD.close
		r.movenext
	wend
	piet_iemaksas = round(sum*100)/100
end if
end function

'@ 0 piet_izmaksas
function piet_izmaksas(pid_p)
dim sum
if piet_nVal(pid_p) = "Ls" then
	set r = conn.execute("select sum(summa) as sm from orderis where (deleted = 0 ) and NoPid ="+cstr(pid_p))
	piet_izmaksas = getnum(r("sm"))
else
set r = conn.execute("select * from orderis where (deleted = 0 ) and Nopid ="+cstr(pid_p))
set valUSD = server.createobject("ADODB.Recordset")
while not r.eof
	valUSD.open "select kurss2 from valutakurss where datums = #"+sqldate(r("datums")) +"# AND valuta = 68" ,conn,3,3
	IF NOT VALUSD.EOF THEN
		sum = sum + r("summa")*valUSD("kurss2")
	ELSE
		RESPONSE.WRITE "NAV NORÂDÎTS USD KURSS. DATUMS:" + dateprint(r("datums"))
		''response.write "select kurss2 from valutakurss where datums = #"+sqldate(r("datums")) +"# AND valuta = 68"
	END IF
	valUSD.close
	r.movenext
wend
piet_izmaksas = int(sum*100)/100
end if


end function

'---------------------
'@ 0 piet_iem_sk
function piet_iem_sk(pid_p)
set r = conn.execute("select count(*) as sm from orderis where (deleted = 0 ) and pid ="+cstr(pid_p))
piet_iemaksas = r("sm")
end function

'---------------------
'piet_bilance
function piet_bilance(pid_p)
set r = conn.execute("SELECT iemaksas,summa,izmaksas,atlaides FROM Pieteikums WHERE id = " + cstr(pid_p))
IF R.EOF THEN EXIT FUNCTION
piet_bilance = r("iemaksas") - r("summa") - r("izmaksas") + r("atlaides")
end function

function Piet_nVal(pid_p)
set r_l = conn.execute("select USD from marsruts,grupa,pieteikums where marsruts.id=grupa.mid and grupa.id=pieteikums.gid and pieteikums.id="+cstr(pid_p))
if r_l.eof then
 Piet_nVal = "Ls"
 exit function
end if
if r_l("USD") = true then Piet_nVal = "USD" else piet_nVal = "Ls"
end function

function piet_personas(pid_p)
'----- vajadzçs updeitot, kad pâries uz jauno sistçmu
'----- tas bûs tad, kad personas laukâ nebûs Nulles.
set r = conn.execute("select sum(vietsk) as sk from piet_saite where (NOT DELETED = 1) and (persona = 1 or isnull(kid,0)<>0 or vietas_veids is null ) and pid ="+cstr(pid_p))
piet_personas = r("sk")
end function

function piet_info(pid_p)
dim r, ret, id
set r = server.createobject("ADODB.Recordset")
if isnull(pid_p) then
	piet_info = ""
	exit function
end if
if pid_p = "" then
	piet_info = ""
	exit function
end if
if pid_p = 0 then
	piet_info = ""
	exit function
end if
r.open "select * from pieteikums where id = "+cstr(pid_p),conn,3,3
if r.recordcount = 0 then 
	piet_info = "Pieteikums neeksistç"
	exit function
end if
if not isnull(r("datums")) then ret = TIMEPRINT(r("datums"))+" "
ret = ret + id_field("marsruts",id_field("grupa",r("gid"),"mid"),"v") + " "
r.close
r.open "SELECT * FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did WHERE piet_saite.deleted <> 1 and pid = "+cstr(pid_p),conn,3,3
if r.recordcount = 0 then 
	ret = ret + "Pieteikums nesatur dalîbniekus! "
else
	ret = ret + "<br>Dalîbnieki: "
	while not r.eof
		ret = ret + "<br>"+nullprint(r("vards")) + " "+nullprint(r("uzvards")) + " "+nullprint(r("nosaukums"))
		r.movenext
	wend
end if
if ret = "" then ret = "???"
piet_info = ret
end function

%>