<%

'@ 0 Kajites_skaits
function Kajites_skaits(kid_p)
dim r_p
set r_p = server.createobject("ADODB.Recordset")
r_p.open "select count(*) as sk from piet_saite where ( deleted = 0) AND kid = " + cstr(kid_p),conn,3,3
kajites_skaits = r_p("sk")
end function

'---------------------
'@ 0 Kajites_dalibnieki
function Kajites_dalibnieki(kid_p,stils_p)
'stils_p 0 - rinda; 1 - stabiòð
dim ret
dim r_p
set r_p = CONN.EXECUTE (" SELECT piet_saite.kid, dalibn.vards, dalibn.uzvards, dalibn.nosaukums, piet_saite.pid " + _
" FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
" WHERE (NOT PIET_SAITE.DELETED = 1) AND piet_saite.kid= " +cstr(kid_p))

if NOT r_p.EOF then
	while not r_p.eof
		if stils_p = 0 then ret = ret +  nullprint(r_p("uzvards")) + " " + nullprint(r_p("nosaukums"))+ "/ " 
		if stils_p = 1 then ret = ret + "<a href = 'pieteikums.asp?pid=" + cstr(r_p("pid")) + "'>" +nullprint(r_p("vards")) + " " + nullprint(r_p("uzvards")) + " " + nullprint(r_p("nosaukums"))+ "</a><br>"
	r_p.movenext
	wend
	if stils_p = 0 then ret = mid(ret,1,len(ret)-2)
	if stils_p = 1 then ret = mid(ret,1,len(ret)-4)
else
	ret = "-"
end if
kajites_dalibnieki = ret
end function

Function Kajites_veida_cena (kv_p,kvv_p)
set r_l = conn.execute("SELECT * FROM kajites_veidi WHERE id = " + cstr(getnum(kv_p)))
Kajites_veida_cena = 0
if not r_l.eof then
	if kvv_p = 1 then Kajites_veida_cena = r_l("standart_cena")
	if kvv_p = 2 then Kajites_veida_cena = r_l("bernu_cena")
	if kvv_p = 3 then Kajites_veida_cena = r_l("papild_cena")
	if kvv_p = 6 then Kajites_veida_cena = r_l("papild2_cena")
	if kvv_p = 4 then Kajites_veida_cena = r_l("senioru_cena")
	if kvv_p = 5 then Kajites_veida_cena = r_l("pusaudzu_cena")
else
	Kajites_veida_cena = 0
end if
end function


%>