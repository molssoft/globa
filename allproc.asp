<%
'izveido jaunu pieteikumu
'atgrieþ pieteikuma id
function InsertPiet(gid,did)
 'insertç pieteikumu
 
 conn.execute("INSERT INTO pieteikums (gid,did,datums,deleted,atcelts) values " + _
  " ("+cstr(gid)+","+cstr(did)+",'"+SQLTime(now)+"',0,0)")
  
 'Set p_result = conn.execute("SET NOCOUNT ON; INSERT INTO pieteikums (gid,did,datums,deleted,atcelts) values " + _
 ' " ("+cstr(gid)+","+cstr(did)+",'"+SQLTime(now)+"',0,0); SELECT @@IDENTITY AS ID")
 
 'dabot id
 set rl = conn.execute("select max(id) as max_id from pieteikums where gid = "+cstr(gid)+" and did = " + cstr(did))
 InsertPiet =  rl("max_id")'p_result("ID")
 rl.close
 
 'ja aìents tad piezîmç id
 if AGENT_MODE then
  conn.execute "UPDATE pieteikums SET agents = "+cstr(GetCurAID)+" WHERE id = " + cstr(InsertPiet)
 end if
 'insertç piet_saiti
 conn.execute "INSERT INTO piet_saite (pid,did,vietsk) values " + _
  " ("+cstr(InsertPiet)+","+cstr(did)+",1)"
 'pârrçíina
 WriteLog 1,InsertPiet,"A"
 LogInsertAction "pieteikums",InsertPiet
 pieteikums_recalculate(InsertPiet)
end function

'-------------------------------------------------------
'ieprieksejas funkcijas kopija tikai ar nosummaLVL un nosummaEUR
'nepieciesams pieteikumu atlikumu konvertacijai
'izveido operâciju, atgrieþ id
'ja kïûda tad 0
'kïûdas paziòojums iekð session("message")
'-------------------------------------------------------
function InsertOpConv(pid_p,nopid_p,datums_p,kas_p,pamatojums_p,pielikums_p,debets_p,kredits_p,summaval_p,valuta_p,nosummaLVL_p,nosummaEUR_p,summaLVL_p,summaEUR_p,rekins_p)
 'ar aìentu modi saistîtie uzdevumi
 if agent_mode then
  need_check = 0
  parbaude = 1
  aid = GetCurAID
 else
  need_check = 1
  parbaude = 0
  aid = "NULL"
 end if
 If pamatojums_p = "" then
   pamatojums_p = "Pârskaitîjums no "+PietNosaukums(nopid_p)+" uz "+PietNosaukums(pid_p)
 end if
 'nosaka nâkamo operacijas numuru
 if clng(pid_p) <> 0 and clng(nopid_p) <> 0 then
  'parskaitijumi
  num = 0
 elseif clng(pid_p) <> 0 then
  'izdevumi
  set rl = conn.execute("select max(num) from orderis where isnull(pid,0)=0 and isnull(nopid,0)<>0 and DATEPART(yyyy,datums) = DATEPART(yyyy,'"+SQLDate(datums_p)+"') ")
  if isnull(rl(0)) then
   num = 1
  else
   num = rl(0)
  end if
 else
  'ieòemumi
  set rl = conn.execute("select max(num) from orderis where isnull(nopid,0)=0 and isnull(pid,0)<>0 and DATEPART(yyyy,datums) = DATEPART(yyyy,'"+SQLDate(datums_p)+"') ")
  if rl.eof then
   num = 1
  else
   num = rl(0)
  end if
 end if
 
 'konti
 'if debets_p <> "" then
 ' debets = debets_p 
 ' else
 '  debets = PietKonts(nopid_p,datums_p,valuta_p)
 'end if

 'if kredits_p <> "" then
 ' kredits = kredits_p 
 'else
 ' kredits = PietKonts(pid_p,datums_p,valuta_p)
 'end if
 
 '
set rP = conn.execute ("select gid from pieteikums where id = "+cstr(pid_p))
uz_grupa = rP("gid")

if session("parsk") = "uz" and desc_gid <> "" then uz_grupa = desc_gid
'session("message") = clng(uz_grupa)
set g = conn.execute ("select * from grupa where id = "+cstr(uz_grupa))

if year(g("beigu_dat"))>year(now) or month(g("beigu_dat"))>month(now) then 
  kredits = g("konts_ava")
else
  kredits = g("konts")
end if

Code_Replace_PID_DID kredits,pid_p
resurss_uz = g("kods")
Code_Replace_PID_DID resurss_uz,pid_p
set rNoGrupa = conn.execute("select id,valuta from grupa where id = "+cstr(getnum(rP("gid"))))

set rP = conn.execute ("select gid,old_gid from pieteikums where id = "+cstr(nopid_p))
att_gid = cstr(conn.execute ("select atteikusies from parametri")(0))
if cstr(rP("gid")) = att_gid and getnum(rP("old_gid"))<>0 then
 no_grupa = getnum(rP("old_gid"))
else
 no_grupa = rP("gid")
end if

if session("parsk") = "no" and desc_gid <> "" then no_grupa = desc_gid
set g = conn.execute ("select * from grupa where ID = "+cstr(no_grupa))

if year(g("beigu_dat"))>year(now) or month(g("beigu_dat"))>month(now) then 
  debets = g("konts_ava")
else
  debets = g("konts")
end if

Code_Replace_PID_DID debets,nopid_p
resurss = g("kods")
Code_Replace_PID_DID resurss,nopid_p
set rUzGrupa = conn.execute("select id,valuta from grupa where id = "+cstr(getnum(rP("gid")))) 
 '
 summa_l = 0 '--lauks ir novecojis, vajag tikt no vina valjaa

 'insertç operâciju 
  
 Set o_result = conn.execute("SET NOCOUNT ON; INSERT INTO orderis (pid,nopid,num,datums,kas,pamatojums,pielikums,summaval,valuta,summa,kredits,debets,resurss,resurss_uz,deleted,nosummaLVL,nosummaEUR,summaLVL,summaEUR,need_check,kas2,pamatojums2,pielikums2,rekins,parbaude,aid) " + _
   " VALUES (" + _
   " "+cstr(pid_p)+"," + _ 
   " "+cstr(nopid_p)+"," + _ 
   " "+cstr(num)+"," + _ 
   " '"+SQLDate(datums_p)+"'," + _ 
   " '"+kas_p+"'," + _ 
   " '"+pamatojums_p+"'," + _ 
   " '"+pielikums_p+"'," + _ 
   " "+Cstr(summaval_p)+"," + _ 
   " "+cstr(GetValKods(valuta_p))+"," + _ 
   " "+cstr(summa_l)+"," + _ 
   " '"+kredits+"'," + _ 
   " '"+debets+"'," + _
   " '"+resurss+"'," + _ 
   " '"+resurss_uz+"'," + _  
   " 0," + _ 
   " "+Cstr(nosummaLVL_p)+"," + _ 
   " "+Cstr(nosummaEUR_p)+"," + _ 
   " "+Cstr(summaLVL_p)+"," + _ 
   " "+Cstr(summaEUR_p)+"," + _ 
   " "+cstr(need_check)+"," + _ 
   " '"+Encode(kas_p)+"'," + _ 
   " '"+Encode(pamatojums_p)+"'," + _ 
   " '"+Encode(pielikums_p)+"'," + _ 
   " "+cstr(rekins_p)+"," + _ 
   " "+cstr(parbaude)+"," + _ 
   " "+cstr(aid)+"); SELECT @@IDENTITY AS ID ")    
 
 'vçsturi pieraksta
 'set rl = conn.execute("select max(id) from orderis")
 LogInsertAction "orderis", o_result("ID") 'rl(0)
 
end function

'-------------------------------------------------------
'izveido operâciju, atgrieþ id
'ja kïûda tad 0
'kïûdas paziòojums iekð session("message")
'-------------------------------------------------------
function InsertOp(pid_p,nopid_p,datums_p,kas_p,pamatojums_p,pielikums_p,debets_p,kredits_p,summaval_p,valuta_p,summaLVL_p,summaEUR_p,rekins_p)
 'ar aìentu modi saistîtie uzdevumi
 if agent_mode then
  need_check = 0
  parbaude = 1
  aid = GetCurAID
 else
  need_check = 1
  parbaude = 0
  aid = "NULL"
 end if
 If pamatojums_p = "" then
   pamatojums_p = "Pârskaitîjums no "+PietNosaukums(nopid_p)+" uz "+PietNosaukums(pid_p)
 end if
 'nosaka nâkamo operacijas numuru
 if clng(pid_p) <> 0 and clng(nopid_p) <> 0 then
  'parskaitijumi
  num = 0
 elseif clng(pid_p) <> 0 then
  'izdevumi
  set rl = conn.execute("select max(num) from orderis where isnull(pid,0)=0 and isnull(nopid,0)<>0 and DATEPART(yyyy,datums) = DATEPART(yyyy,'"+SQLDate(datums_p)+"') ")
  if isnull(rl(0)) then
   num = 1
  else
   num = rl(0)
  end if
 else
  'ieòemumi
  set rl = conn.execute("select max(num) from orderis where isnull(nopid,0)=0 and isnull(pid,0)<>0 and DATEPART(yyyy,datums) = DATEPART(yyyy,'"+SQLDate(datums_p)+"') ")
  if rl.eof then
   num = 1
  else
   num = rl(0)
  end if
 end if
 
 'konti
 'if debets_p <> "" then
 ' debets = debets_p 
 ' else
 '  debets = PietKonts(nopid_p,datums_p,valuta_p)
 'end if

 'if kredits_p <> "" then
 ' kredits = kredits_p 
 'else
 ' kredits = PietKonts(pid_p,datums_p,valuta_p)
 'end if
 
 '
set rP = conn.execute ("select gid from pieteikums where id = "+cstr(pid_p))
uz_grupa = rP("gid")

if session("parsk") = "uz" and desc_gid <> "" then uz_grupa = desc_gid
'session("message") = clng(uz_grupa)
set g = conn.execute ("select * from grupa where id = "+cstr(uz_grupa))

if year(g("beigu_dat"))>year(now) or month(g("beigu_dat"))>month(now) then 
  kredits = g("konts_ava")
else
  kredits = g("konts")
end if

Code_Replace_PID_DID kredits,pid_p
resurss_uz = g("kods")
Code_Replace_PID_DID resurss_uz,pid_p
set rNoGrupa = conn.execute("select id,valuta from grupa where id = "+cstr(getnum(rP("gid"))))

set rP = conn.execute ("select gid,old_gid from pieteikums where id = "+cstr(nopid_p))
att_gid = cstr(conn.execute ("select atteikusies from parametri")(0))
if cstr(rP("gid")) = att_gid and getnum(rP("old_gid"))<>0 then
 no_grupa = getnum(rP("old_gid"))
else
 no_grupa = rP("gid")
end if

if session("parsk") = "no" and desc_gid <> "" then no_grupa = desc_gid
set g = conn.execute ("select * from grupa where ID = "+cstr(no_grupa))

if year(g("beigu_dat"))>year(now) or month(g("beigu_dat"))>month(now) then 
  debets = g("konts_ava")
else
  debets = g("konts")
end if

Code_Replace_PID_DID debets,nopid_p
resurss = g("kods")
Code_Replace_PID_DID resurss,nopid_p
set rUzGrupa = conn.execute("select id,valuta from grupa where id = "+cstr(getnum(rP("gid")))) 
 '
 summa_l = 0 '--lauks ir novecojis, vajag tikt no vina valjaa

 'insertç operâciju 
  
 Set o_result = conn.execute("SET NOCOUNT ON; INSERT INTO orderis (pid,nopid,num,datums,kas,pamatojums,pielikums,summaval,valuta,summa,kredits,debets,resurss,resurss_uz,deleted,summaLVL,summaEUR,need_check,kas2,pamatojums2,pielikums2,rekins,parbaude,aid) " + _
   " VALUES (" + _
   " "+cstr(pid_p)+"," + _ 
   " "+cstr(nopid_p)+"," + _ 
   " "+cstr(num)+"," + _ 
   " '"+SQLDate(datums_p)+"'," + _ 
   " '"+kas_p+"'," + _ 
   " '"+pamatojums_p+"'," + _ 
   " '"+pielikums_p+"'," + _ 
   " "+Cstr(summaval_p)+"," + _ 
   " "+cstr(GetValKods(valuta_p))+"," + _ 
   " "+cstr(summa_l)+"," + _ 
   " '"+kredits+"'," + _ 
   " '"+debets+"'," + _
   " '"+resurss+"'," + _ 
   " '"+resurss_uz+"'," + _  
   " 0," + _ 
   " "+Cstr(summaLVL_p)+"," + _ 
   " "+Cstr(summaEUR_p)+"," + _ 
   " "+cstr(need_check)+"," + _ 
   " '"+Encode(kas_p)+"'," + _ 
   " '"+Encode(pamatojums_p)+"'," + _ 
   " '"+Encode(pielikums_p)+"'," + _ 
   " "+cstr(rekins_p)+"," + _ 
   " "+cstr(parbaude)+"," + _ 
   " "+cstr(aid)+"); SELECT @@IDENTITY AS ID ")    
 
 'vçsturi pieraksta
 'set rl = conn.execute("select max(id) from orderis")
 LogInsertAction "orderis", o_result("ID") 'rl(0)
 
end function

function GetRate(datums_p,no_p,uz_p)
 GetRate = 0
 'ja valûtas vienâdas tad kurss ir 1
 if no_p = uz_p then
  GetRate = 1
  exit function
 end if
 'dabonam valûtas kursu
 if ucase(no_p)="LVL" then
  nokurss = 1
 else
  no_val_kods = GetValKods(no_p)
  if no_val_kods = 0 then
   session("message") = session("message") + " Valûta neeksistç."
   exit function
  else
   set rl = conn.execute("select kurss2 from valutakurss where datums = '"+SqlDate(datums_p)+"' and valuta = "+cstr(no_val_kods))
   if rl.eof then
    session("message") = session("message") + " Valûtas kurss nav pieejams."
    exit function
   else
    nokurss = rl("kurss2")
   end if
  end if
 end if
 
 'dabonam valûtas kursu
 if ucase(uz_p)="LVL" then
  uzkurss = 1
 else
  uz_val_kods = GetValKods(uz_p)
  if uz_val_kods = 0 then
   session("message") = session("message") + " Valûta neeksistç."
   exit function
  else
   set rl = conn.execute("select kurss2 from valutakurss where datums_p = '"+SqlDate(datums_p)+"' and valuta = "+cstr(uz_val_kods))
   if rl.eof then
    session("message") = session("message") + " Valûtas kurss nav pieejams."
    exit function
   else
    uzkurss = rl("kurss2")
   end if
  end if
 end if
 
 'abi kursi ir zinâmi, aprçíinam rezultâtu
 GetRate = (1/nokurss) * uzkurss
end function

function GetValKods(val_p)
 set rl = conn.execute("select id from valuta where val = '"+val_p+"'")
 if not rl.eof then
  GetValKods = rl("id")
 else
  GetValKods = 0
 end if
end function

function PietKonts(pid_p,datums_p,val_p)
 
 'kases konti
 if pid_p = 0 then
  if val_p = "USD" then
   PietKonts = "26112"
  else 
   PietKonts = "26111"
  end if
  exit function
 end if
 
 rPietL = conn.execute("select * from pieteikums where id = "+cstr(pid_p))
 rGrupaL = conn.execute("select * from grupa where id = "+cstr(rPietL("gid")))
 
 if nullprint(rGrupaL("konts")) = "" then
  if nullprint(rGrupaL("kods")) = "" then
   'ja nav koda un konta
   PietKonts = ""
  elseif mid(ucase(rGrupaL("kods")),1,1) = "K" then
   'ja kompleksais
   if isnull(rPietL("beigu_datums")) then
	PietKonts = "6K"
   elseif year(rPiet("beigu_datums")) > year(datums_p) then
	PietKonts = "5K"
   else
	PietKonts = "6K"
   end if
  else
   'ja parastais
   if not isnull(rGrupaL("beigu_dat")) then
    if year(rGrupaL("beigu_dat")) > year(datums_p) then
     PietKonts =  "5"+rGrupaL("kods")
    else
     PietKonts =  "6"+rGrupaL("kods")
    End if
   Else
    PietKonts =  "6"+rGrupaL("kods")
   End if
  end if
 else
  'ja norâdits zinâms konts
  PietKonts = rGrupaL("konts")
 end if
 
end function

function isValidCurr(s)
 
 if isnull(s) then
  isValidCurr = false
  exit function
 end if
 
 ss = cstr(s)
 stage=0
 for i = 1 to len(ss)
  ch = mid(ss,i,1)
  
  if isDigit(ch) = false and ch<>"." then exit function
  if stage=3 and (isDigit(ch) = false) then exit function
  if stage=2 and (isDigit(ch) = false) then exit function 
  if stage=2 then stage=3
  if stage=1 and ch="." then stage=2
  if stage=0 and (isDigit(ch) = false) then exit function 
  if stage=0 then stage=1
 next
 if stage<>1 and stage<>3 then exit function
 isValidCurr = true
end function

function PietNosaukums(pid)
 If not isnull(pid) then
   set rl = conn.execute ("select pieteikums.id as pid,grupa.kods as kods, marsruts.v as v from grupa,marsruts,pieteikums where grupa.id = pieteikums.gid and marsruts.id = grupa.mid and pieteikums.id = "+cstr(pid))
   if not rl.eof then
     PietNosaukums = "("+cstr(rl("pid"))+") " + nullprint(rl("kods"))+" "+nullprint(rl("v"))
   end if
   end if
end function

%>
