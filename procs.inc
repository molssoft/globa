<%

dim EUR_DATE
dim EUR_RATE
EUR_DATE = DateSerial(2014,1,1)
EUR_RATE = 0.702804 

Function Quotes(s)
	Quotes = replace(nullprint(s),"""","&quot;")
End Function 

function GetTime(v)
	On Error Resume Next
	GetTime = FormatDateTime(v,4)
	If Err.Number <> 0 Then
		GetTime = "00:00"
	End If
	On Error Goto 0 ' Reset error handling.
end function

function DefaultValuta()
	if Now()>EUR_DATE then
		DefaultValuta = "EUR"
	else
		DefaultValuta = "LVL"
	end if
end function

function DefaultValutaD(d)
	if d>EUR_DATE then
		DefaultValutaD = "EUR"
	else
		DefaultValutaD = "LVL"
	end if
end function

function DefaultValutaID()

	if Now()>EUR_DATE then
		DefaultValutaID = 49
	else
		DefaultValutaID = 40
	end if
end function

function DefaultValutaIDD(d)
	if d>EUR_DATE then
		DefaultValutaIDD = 49
	else
		DefaultValutaIDD = 40
	end if	
end function


sub JSPoints ()
%>
  <script>
  function JSPoints (s) {
    temp2=""; 
    temp = s.value; 
    if ((temp.length > 1) && (temp.split(".")[0] == temp)) { 
      for (i=0;i<temp.length-1;i++) { 
        temp2 = temp2 + temp.substring(i,i+1) + "."; 
      } 
      s.value = temp2 + temp.substring(temp.length-1,temp.length); 
    }
  }
  </script>
<%
end sub

sub Code_Replace_PID_DID(kods,pid)
dim rTemp
  If not isnull(pid) then
    kods = replace (nullprint(kods),"PID",cstr(getnum(pid)))
    rTemp = conn.execute("select did from piet_saite where deleted = 0 and pid = " + cstr(pid) + " order by persona desc")
    'response.write("select did from piet_saite where deleted = 0 and pid = " + cstr(pid))
    kods = replace (nullprint(kods),"DID",rTemp("did"))
  End If
end sub

function isReadOnly(pType,pId)

	res = false

	isReadOnly = res

end function

function isOnlineRez(pid)

	res = false
	
	if clng(pid) > 0 then
		ssql = "SELECT online_rez FROM pieteikums WHERE online_rez IS NOT NULL AND id = "&pid
		set piet = conn.execute(ssql)
		if not piet.eof then
			res = true
		end if
	end if
	
	isOnlineRez res

end function

function get_zaud_nauda(p_gid)
	
	'--- 4.Sept 2012 Nils
	'--- atgriez grupas zaudetas naudas summu atbilstoshi terminjam
	'--- atgriez -1, ja ir pagajis tresais termins un zaudeta nauda ir pilna celjojuma summa (taas db nav)
	
	'--- 3.Apr 2013 Nils
	'--- izmainîts nosacîjums, lai piemçrotu zaudçto naudu lîdz norâdîtajam termiòam to ieskaitot.
	'--- ->
	'--- shçma: term1_zaud_summa tiek piemçrota lîdz term2_dat ieskaitot.
	'--- term2_zaud_summa tiek piemçrota pçc term2_dat un lîdz date_3 ieskaitot.
	'--- pçc date_3 tiek piemçrota visa summa.

	today = Date
	summa = 0
	
	if p_gid>0 then
		
		ssql = "SELECT * FROM grupa WHERE id = "&p_gid
		set r_grupa = conn.execute(ssql)
		
		'rw ssql
		'response.end
		
		if not r_grupa.eof then
			
			date_2 = r_grupa("term2_dat")
			date_3 = r_grupa("term3_dat")
			term1_zaud_summa = r_grupa("term1_zaud_summa")
			term2_zaud_summa = r_grupa("term2_zaud_summa")
			
			if datediff("d",today,date_2)>=0 then
				
				summa = getnum(term1_zaud_summa)
			
			elseif datediff("d",today,date_3)>=0 then
				
				summa = getnum(term2_zaud_summa)
				
				'--- ja otraa summa nav noradits, njem pirmo
				if summa = 0 then
				
					summa = getnum(term1_zaud_summa)
				end if
			
			else '--- klients zaudee visu iemaksato summu
			
				summa = -1
			
			end if
					
		end if
		
	end if
	
	get_zaud_nauda = summa

end function

function irMelnajaSaraksta(pk1,pk2)

	ssql = "SELECT * FROM melnais_saraksts WHERE pk1 ='"+nullprint(pk1)+"' AND pk2 ='"+nullprint(pk2)+"'"
	
	set ms = conn.execute(ssql)
	
    if not ms.eof then 
		irMelnajaSaraksta = true
	else
		irMelnajaSaraksta = false
	end if
    
end function

Function in_array(element, arr)

    For i=0 To Ubound(arr)
        If Trim(arr(i)) = Trim(element) Then
            in_array = True
            Exit Function
        Else
            in_array = False
        End If 
    Next

End Function 

function getWeekdayName(wd)

	select case wd
		case 2
			getWeekdayName = "Pirmdiena"
		case 3
			getWeekdayName = "Otrdiena"
		case 4
			getWeekdayName = "Treðdiena"
		case 5
			getWeekdayName = "Ceturtdiena"
		case 6
			getWeekdayName = "Piektdiena"
		case 7
			getWeekdayName = "Sestdiena"
		case 1
			getWeekdayName = "Svçtdiena"
	end select

end function


function getIVieta(num)

	'--- funkcija jâapdeito. vertibas janjem no tabulas grupa_izbr_vieta
	
	value = ""

	select case num
		case 0 value = ""
		case 1 value = "Nav zin&amacr;ms"
		case 2 value = "R&imacr;gas Lidosta"
		case 3 value = "Latvie&scaron;u Biedr&imacr;b&amacr;s Nams"
		case 4 value = "R&imacr;gas Autoosta"
		case 5 value = "R&imacr;gas pasa&zcaron;ieru osta"
		case 6 value = "T.C. ORIGO"				
		case 7 value = "Str&emacr;lnieku Piemineklis"				
		case 8 value = "L. Nacion&amacr;lais te&amacr;tris"				
		case 9 value = "11.novembra krastmala (pezid. pils)"				
		case 10 value = "Kalpaka bulv&amacr;r&amacr; st&amacr;vvieta"				
		case 11 value = "L. Zin&amacr;t&ncedil;u akad&emacr;mija"				
		case 12 value = "L. Dailes te&amacr;tris"				
		case 13 value = "Rai&ncedil;&amacr; Bulv. 19"				
	end select

	getIVieta = value
	
end function

function isCarter(p_gid)
	
	dim ssql, r, res
	
	res = false
	
	if getnum(p_gid)>0 then
	
		ssql = "SELECT carter FROM grupa where id = "&p_gid
		set r = conn.execute(ssql)
	
		if not r.eof then
			if r(0) then res = true
		end if
	end if
		
	isCarter = res

end function

function checkSingle(pid)
	
	'--- parbauda vai ir Single piemaksa, ja ir single numurs.
	'--- ja nav, atgriez false. parejos gadijumos true.
	'--- session("message") ieraksta kljudas pazinjojumu.
	
	dim ssql, r, res, vietas, single_num, piemaksa

	single_num = false
	piemaksa = false
	
	'-- uzzina vai pieteikums ir single numuraa
	ssql = "select vv.vietas,isnull(vietu_veidi_id,0) as vietas_id from piet_saite ps " + _
			"inner join viesnicas v on v.id = ps.vid " + _
			"inner join viesnicas_veidi vv on vv.id = v.veids " + _
			"where pid = " & pid & " and ps.deleted = 0 "
	
	set r = conn.execute(ssql)
	
	if not r.eof then
		if r("vietas_id") <> 0 then
			piemaksa = true
			exit function
		end if
		
		vietas = getnum(r(0))
		if vietas=1 then '--- ir single numurs
			
			single_num = true
		end if
	end if	
			
	'--- parbauda vai ir piemaksa
	ssql = "select vv.tips from vietu_veidi vv " + _
			"inner join piet_saite ps on ps.vietas_veids = vv.id " + _
			"where ps.pid = " & pid & " and ps.deleted = 0"
			
	set r = conn.execute(ssql)
			
	Do while not r.EOF 

		if r("tips")="V1" or r("tips")="CH1" Or r("tips")="CH1_NA" then
			
			piemaksa = true
			exit do
				
		end if
				
		r.movenext
	loop
	
	if single_num and not piemaksa then 
	
		res = false
		session("message") = "SINGLE numuram nav piemaksas vai atbilstoðas SINGLE cenas ar iekïautu piemaksu."
	
	elseif piemaksa and not single_num then
	
		res = false
		session("message") = "Ja tiek reìistrçta piemaksa par SINGLE numuru vai cena ar iekïautu SINGLE, atbilstoði, dalîbnieks jâievieto SINGLE nummurâ."
	else
		res = true
	end if
		
	checkSingle = res
	
end function

function rezBilanceLVL(rez_id)

	dim ssql, r, bilance
	
	bilance = 0

	if rez_id<>"" then
	
		ssql = "select iemaksasLVL, bilanceLVL from pieteikums where deleted = 0 and globa_rez = "&rez_id
		
		set r = conn.execute(ssql)
		
		while not r.eof
		
			bilance = bilance + r("bilanceLVL")
			
			r.movenext
		wend
	end if
	
	rezBilanceLVL = bilance

end function
function viesnDalBilanceLVL(p_vid)

	dim ssql, r, bilance

	if p_vid<>"" then
	
		ssql = "select bilanceEUR from pieteikums p " + _
				"inner join piet_saite ps on ps.pid = p.id " + _
				"where ps.deleted = 0 and p.deleted = 0 and ps.vid =  "&p_vid
	
		'Response.Write ("<br>->"&ssql&"<br>")

		set r = conn.execute(ssql)
	
		while not r.eof
	
			bilance = bilance + r("bilanceEUR")
			
			r.movenext
		wend
	
	end if
	
	viesnDalBilanceLVL = bilance

end function


function addRezDal(p_rez_id, p_did) 
'--- izveido dalibnieka pieteikumu ar piesaisti grupai un kopejai (chartera) rezervacijai
	
	dim ssql, r, piet
	
	ssql = "SELECT * FROM pieteikums WHERE globa_rez = "&p_rez_id&" AND deleted = 0 "
	set piet = conn.execute(ssql)
	
	if not piet.eof then
		ssql = "SET NOCOUNT ON; INSERT INTO pieteikums(gid, did, globa_rez, izveidoja) VALUES("&piet("gid")&","&p_did&","&piet("globa_rez")&",'"+Get_User+"'); SELECT @@IDENTITY AS ID"	
		' rw ssql
		' response.end
		set r = conn.execute(ssql)
		
		conn.execute "INSERT INTO piet_saite (pid,did,vietsk) VALUES ("&r("id")&","&p_did&",1)"
		LogInsertAction "pieteikums", r("id")
		
		response.redirect("pieteikums.asp?pid="&r("id"))
	end if
	
end function

function paxCount(vid, pax_type)
	
	dim count, ssql, r_d, dalibn
	count = 0
	
	ssql = "select ps.did, p.gid from piet_saite ps " + _
			"inner join pieteikums p on p.id = ps.pid " + _
			"where p.deleted = 0 and ps.deleted = 0 and ps.vid="&vid
	
	set r_d = conn.execute(ssql)
	
	while not r_d.eof 
	
		dalibn = ch_whois(r_d("did"), r_d("gid"))
		if dalibn=pax_type then count=count+1
		
		r_d.movenext
	wend
		
	paxCount = count
	
end function

function paxCountSmart(vid, pax_type)

	'--- atgriez pasazieru skaitu viesnicas numuraa
	'--- pax_type ir "adult" vai "child"
	'--- darbojas likums,ja numuraa ir mazaak par diviem piaugushajiem un ir arii beerns
	'--- beernu uzskata kaa pieaugusho.
	
	dim count, ssql, r_d, dalibn
	dim adults, children
	
	count = 0
	adults = 0 
	children = 0
	
	ssql = "select ps.did, p.gid from piet_saite ps " + _
			"inner join pieteikums p on p.id = ps.pid " + _
			"where p.deleted = 0 and ps.deleted = 0 and ps.vid="&vid
	
	set r_d = conn.execute(ssql)
	
	while not r_d.eof 
	
		dalibn = ch_whois(r_d("did"), r_d("gid"))
		
		if dalibn="adult" then adults = adults + 1
		if dalibn="child" then children = children + 1
		
		r_d.movenext
	wend
	
	if pax_type="adult" then '-- jauzzin cik numuraa ir pieaugushie
		
		count = adults
		
		if adults<2 and children>0 then '--- skatas vai ir beerns, kuru pieskaita kaa pieaugusho
			count = count + 1
		end if
		
	elseif pax_type="child" then '-- jauzzin cik numuraa ir beerni
	
		count = children
	
		if adults<2 and children>0 then '--- skatas vai ir beerns, kuru pieskaita kaa pieaugusho 
										'--- un atskaita no beernu skaita
			count = count - 1
		end if
		
	end if
		
	paxCountSmart = count
	
end function

function isSetPak(p_id)
	
	dim res, ssql, r, viesn, vv
	
	viesn = false
	vv = false
	
	ssql = "select * from piet_saite where deleted = 0 and pid = "&p_id
	
	set r = conn.execute(ssql)
	
	while not r.eof
		
		if getnum(r("vid"))>0 then viesn = true
			
		if getnum(r("vietas_veids"))>0 then vv = true
		
		r.movenext		
	wend
		
	if vv and viesn then
		res = true
	else
		res = false
	end if
	
	isSetPak = res
	
end function


function inFullRoom(pid)

		dim ssql, r, res
		
		res = false
		
		ssql="select (select vv.vietas as vvietas from viesnicas v " + _
		"inner join viesnicas_veidi vv on vv.id = v.veids where v.id = ps.vid) as vietas,  " + _
		"(select vv.nosaukums as vvietas from viesnicas v" + _
		" join viesnicas_veidi vv on vv.id = v.veids where v.id = ps.vid) as nosaukums, " + _
		"(select count(ps2.id) from piet_saite ps2 inner join pieteikums p2 on p2.id = ps2.pid where ps2.vid = ps.vid and ps2.deleted=0 and p2.deleted=0) as aiznemts " + _ 
		"from piet_saite ps where pid = "&pid&" and isnull(vid,0)<>0 and ps.deleted = 0" 
		
		set r = conn.execute(ssql)
		' rw ssql 
		
		if not r.eof then
			if r("vietas")<=r("aiznemts") or (r("nosaukums")="TWIN")   then res = true
		end if
		
		inFullRoom = res

end function

function ch_whois(did, gid)
	if getnum(did) = 0 then exit function
	dim child_min, adult_min, res, r, ssql, pk1
	
	res = false
	child_min = 2
	adult_min = 13
	
	ssql = "SELECT * FROM dalibn WHERE id = "&did
	
	set r = conn.execute(ssql)
	
	if not r.eof then 
		
		pk1 = r("pk1")
		if ch_vecaksPar(adult_min, pk1, gid) then 
		
			res = "adult"
			
		elseif ch_vecaksPar(child_min, pk1, gid) then
		
			res = "child"
		else
		
			res = "infant"
		end if
		
	end if
	
	ch_whois = res

end function

function ch_vecaksPar(gadi, p_kods, g_id)
	' --- pec personas koda nosaka vai dalibnieks ir vecaks par uzdoto vecumu gados.
	' --- precizai salidzinashanai izmanto dienas, njemot veraa garos gadus.
	'--- salidzina pret grupas beigu datumu +1

	dim dz_datums, res, dz_gads, dienas_nodz, g_beigu_dat, ssql, r_g
	
	ssql = "SELECT beigu_dat FROM grupa WHERE atcelta = 0 AND id = "&g_id
	set r_g = conn.execute(ssql)
	
	if not r_g.eof then g_beigu_dat = DateAdd("d", 1, r_g("beigu_dat"))
	
	res = false

			if len(p_kods)=6 then
				
				dz_gads = right(p_kods,2)
				
				if cint(dz_gads) < cint(right(Year(now),2))+1 then
					dz_gads = "20" + dz_gads
				else
					dz_gads = "19" + dz_gads
				end if
				
				
				dz_datums = DateSerial(dz_gads, Mid(p_kods,3,2), Left(p_kods,2)) '--- y/m/d
			
				'--- nodzivoto dienu skaits
			    dienas_nodz = DateDiff("d", dz_datums, g_beigu_dat) 
			    
			    '--- dienu skaits, ar ko salidzinaat vai dalibnieks ir vecaaks par so laiku
			    dienas = DateDiff("d", DateAdd("yyyy", -gadi, g_beigu_dat), g_beigu_dat) 
				
				'rw dienas_nodz&" >= "&dienas&"<br />"
				
				if dienas_nodz >= dienas then
					res = true
				end if
				
			end if
	
	ch_vecaksPar = res

end function

function gidsIrAiznemts(gid, gkods, sakuma_dat, beigu_dat)
''	response.write sqldateq(beigu_dat)
''response.end
	value = false
	ssql = "select * from grupa " + _
		"where (vaditajs = "+cstr(gid)+" or vaditajs2 = "+cstr(gid)+") " + _
		"and atcelta = 0 and kods <> '" + gkods + "' and beigu_dat > '1/1/"+cstr(Year(Date))+"' " + _
		"and ((" + sakuma_dat + " BETWEEN sakuma_dat and beigu_dat) " + _
		"or (" + beigu_dat + " BETWEEN sakuma_dat and beigu_dat) " + _
		"or (" + sakuma_dat + " <= sakuma_dat and " + beigu_dat + " >= beigu_dat))"
	
''	response.write ssql
''response.end
	set rGrupas = conn.execute(ssql)
	
	if not rGrupas.eof then
		rMarsruts = conn.execute("select * from marsruts where id = "+cstr(rGrupas("mid")))
		session("aiznemts_celojums") = rGrupas("kods") + " " +rMarsruts("v")
		value = true
	end if
	
	gidsIrAiznemts = value
	''gidsIrAiznemts = ssql
	
end function

function Code_Update(kods)
dim i, temp, fault
  fault = false
  if (len(kods)<=6) and (mid(kods,1,1)>="A" and mid(kods,1,1)<="Z") or (mid(kods,1,1)>="a" and mid(kods,1,1)<="z") then
    temp = "__"
    For i = 1 to len(kods)
      temp = temp + "." + mid(kods,i,1)
      if mid(kods,i,1)="." then fault = true
    Next
    If not fault then
      Code_Update = temp
      Exit function
    end if
  end if
  Code_Update = kods
end function

function STR_SQL(s)
dim i, s2, last_ch
  s = replace(s,"'","''")
  s2 = ""
  for i = 1 to len(s)
    if i > 1 then s2 = s2 + "+"
    if within(mid(s,i,1),"â,è,ç,ì,î,í,ï,ò,ð,û,þ,Â,È,Ç,Ì,Î,Í,Ï,Ò,Ð,Û,Þ") then
      s2 = s2 + "NCHAR(" + cstr(ASC_SQL(ASC(mid(s,i,1)))) + ")"
    else
      if s2<>"" then
       if mid(s2,len(s2)-1,2) = "'+" then
        s2 = mid(s2,1,len(s2)-2) + mid(s,i,1) + "'"
       else
        s2 = s2 + "'" + mid(s,i,1) + "'"
       end if
      else
        s2 = s2 + "'" + mid(s,i,1) + "'"
      end if
    end if
  next
  if s2 = "" then s2 = "''"
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
  elseif x = "A" or x="10" then
    s = "oktobris"
  elseif x = "B"  or x="11"  then
    s = "novembris"
  elseif x = "C"  or x="12"  then
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
  if eur_amount<>0 then
  Curr3Print = Curr3Print + " " +CurrPrint(eur_amount) + " EUR"
 end if
if usd_amount<>0 then
  Curr3Print = Curr3Print + " " +CurrPrint(usd_amount) + " USD"
 end if
 if Curr3Print = "" then Curr3Print = "0.00"
end function


function Curr3PrintTest(lvl_amount,usd_amount,eur_amount)
 
 Curr3PrintTest = ""
 rw "lvl_amount:"
 rw lvl_amount
 rw "<br>"
  rw "usd_amount:"
 rw usd_amount
 rw "<br>"
  rw "eur_amount:"
 rw eur_amount
 rw "<br>"
 if lvl_amount<>0 then
  Curr3PrintTest = CurrPrint(lvl_amount) + " LVL"
 end if
  if eur_amount<>0 then
  Curr3PrintTest = Curr3PrintTest + " " +CurrPrint(eur_amount) + " EUR"
 end if
if usd_amount<>0 then
  Curr3PrintTest = Curr3PrintTest + " " +CurrPrint(usd_amount) + " USD"
 end if
 if Curr3PrintTest = "" then Curr3PrintTest = "0.00"
end function

'---------------------------------------
'jaunâ funkcija kas râda informatîvu summu otrajâ valûtâ sakarâ ar pârieðanu uz EUR
'---------------------------------------
function Curr3Print2(lvl_amount,usd_amount,eur_amount)
 Curr3Print2 = ""
 if lvl_amount<>0 then
  Curr3Print2 = CurrPrint(lvl_amount) + " LVL <font color=#AAAAAA>("+CurrPrint(lvl_amount/EUR_RATE)+" EUR)</font>"
  
 end if
  if eur_amount<>0 then
  Curr3Print2 = Curr3Print2 + " " +CurrPrint(eur_amount) + " EUR <font color=#AAAAAA></font>"
 end if
if usd_amount<>0 then
  Curr3Print2 = Curr3Print2 + " " +CurrPrint(usd_amount) + " USD"
 end if
 if Curr3Print2 = "" then Curr3Print2 = "0.00"
end function

'---------------------------------------
'modifikâcija bez iekavâm un vienâ krâsâ
'---------------------------------------
function Curr3PrintPlain(lvl_amount,usd_amount,eur_amount)
 Curr3PrintPlain = ""
 if lvl_amount<>0 then
  Curr3PrintPlain= CurrPrint(lvl_amount) + " LVL  "
  
 end if
  if eur_amount<>0 then
  Curr3PrintPlain= Curr3PrintPlain + " " +CurrPrint(eur_amount) + " EUR "
 end if
if usd_amount<>0 then
  Curr3PrintPlain= Curr3PrintPlain + " " +CurrPrint(usd_amount) + " USD"
 end if
 if Curr3PrintPlain= "" then Curr3PrintPlain= "0.00"
end function

'---------------------------------------
'funkcija râda kopçjo summu latos vai eiro 
'atkarîbâ no datuma (pirms vai pçc eiro ievieðanas)
'priekð USD tiek izmantots ðodienas kurss
'---------------------------------------
function Curr3Total(lvl_amount,usd_amount,eur_amount)
	Curr3Total = 0
	if now<EUR_DATE then
		'pirms eiro çra
		total = getnum(lvl_amount)
		total = total + getnum(eur_amount) * EUR_RATE + getnum(usd_amount) / USDKurss()
		Curr3Total = CurrPrint(total)+" LVL <font color=#AAAAAA>("+CurrPrint(total/EUR_RATE)+" EUR)</font>"
	else
		'eiro çra
		total = getnum(eur_amount)
		If USDKurss()<>0 then
			total = total + getnum(lvl_amount) / EUR_RATE + getnum(usd_amount) / USDKurss()
		End if
		Curr3Total = CurrPrint(total)+" EUR <font color=#AAAAAA>("+CurrPrint(total*EUR_RATE)+" LVL)</font>"
	end if
end function

function Curr3value(lvl_amount,usd_amount,eur_amount)

 Curr3value = 0
 if lvl_amount<>0 then
  Curr3value = lvl_amount
 elseif usd_amount<>0 then
  Curr3value = usd_amount
 elseif eur_amount<>0 then
  Curr3value = eur_amount
 end if

end function

Function CurrPrint(x)
 CurrPrint = cstr(round100(getnum(x)))
 'lai visos pârlûkos pareizi attçlotos summas:
  currprint = Replace(currprint,",",".")
  
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

function brivasVietasGrupa(gid)
	
	set vietas = conn.execute("select brivs = dbo.fn_brivas_vietas("+cstr(gid) + ")")
	brivasVietasGrupa = getnum(vietas("brivs"))
	exit function
end function

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
  if z = "–" then z = "-"
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
	dim lastcip
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
	
	if (isNumeric(clng(s_p)) or s_p = "on") then '--- labots 22.sept 2010 Nils
	'--- if (isNumeric(s_p) or s_p = "on") then
		
		getnum = s_p
	else 
		getnum = 0
	end if
	
 end if
 
end if

end function

'--------------------------------------
'grupas_nosaukums
function grupas_nosaukums(gid_p,pid)
dim result_l
result_l = ""
if gid_p <> 0 then 
	mid_l = id_field("grupa",gid_p,"mid")
	kods_l = id_field("grupa",gid_p,"kods")
	Code_Replace_PID_DID kods_l,pid
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
	connection_p.execute "update ordnum set ordnum = ordnum + 1"
	' dim table_l
	'dim num_l
	'set table_l = server.createobject("ADODB.Recordset")
	'table_l.open "ordnum",connection_p,3,3
	'table_l.movefirst
	'num_l = table_l("ordnum")
	'table_l("ordnum") = num_l+1
	'table_l.update

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
'grupas_combo Izdrukâ grupu sarakstu
'---- viss = 1 ja pilns saraksts. 0 ja tikai atktuaalie marshruti
'--------------------------------------
sub grupas_combo_last_year(selected_p)


    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= '" + SQLDate(now-360) + "' OR marsruts.v like '!%' OR marsruts.v like 'Kompleksie%' OR grupa.id = " + cstr(selected_p) + _
    " ORDER BY marsruts.v, grupa.sakuma_dat;"

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

function getBlockType(b_type)

 bt = "nav"

 Select Case b_type
	Case 1
		bt = "slçgta"
	Case 2
		bt = "atvçrta"
 End Select	

getBlockType = bt

end function

'--------------------------------------

function comboBlockType(b_type)

 shtml = "<SELECT name=blocked>"
 shtml = shtml + "<OPTION value=0"
 if getnum(b_type) = 0 then shtml = shtml + " selected "
 shtml = shtml + ">nav</OPTION>"
 
 shtml = shtml + "<OPTION value=1"
 if getnum(b_type) = 1 then shtml = shtml + " selected "
 shtml = shtml + ">slçgta</OPTION>"
 
 'shtml = shtml + "<OPTION value=2"
 'if getnum(b_type) = 2 then shtml = shtml + " selected "
 'shtml = shtml + ">atvçrta</OPTION>" 

 shtml = shtml + "</SELECT>"

comboBlockType = shtml

end function

'--------------------------------------

function isGroupBlocked(gid)
'--- paarbauda vai vaaktaa grupa ir blokjeeta

	res = false
	if gid<>"" then
		ssql = "SELECT blocked FROM grupa WHERE kods like '__.V.%' and id = " + cstr(gid)
		set rg = conn.execute(ssql)
	
		if not rg.eof then
			if rg("blocked")=1 then	res = true
		end if
	end if
	isGroupBlocked = res

	
end function

'--------------------------------------

function isDalibnInBlockedGroup(pdid)
	'19.09.2019 RT: papildinâjums - neattiecas uz grupu vadîtâjiem ðis nosacîjums, kâ arî grupâm, kuru ceïojumi jau ir notikuði
	res = false
	if pdid<>"" then
		ssql = "select count(*) as cnt from pieteikums p inner join piet_saite ps on p.id = ps.pid where p.deleted = 0 and ps.deleted = 0 and ps.did = "+cstr(pdid)+"  and p.gid in (select id from grupa where kods like '__.V.%' and blocked = 1 AND sakuma_dat>GETDATE()) AND ISNULL(p.grupas_vad,0)<>1"
		'response.write ssql
		'response.end
		set rd = conn.execute(ssql)
		if not rd.eof then
			if rd("cnt")>0 then res = true
		end if	
	end if
	isDalibnInBlockedGroup = res

end function 

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
response.write "	return false;	"
response.write "};"

response.write "function TopSubmit2(url)"
response.write "{"
response.write "	forma.action = url;"
response.write "}"

response.write "</script>"
end sub
'--------------------------------------
'WhereClause

'--------------------------------------
sub checkGroupBlocked(pgid)

	response.write "<script LANGUAGE=""JScript"">"
	response.write "function checkBlocked() {"
	response.write "	var res;"

	if isGroupBlocked(pgid) then
		response.write "	res = false;"
		response.write "	alert('Izmaiòas veikt nav iespçjams, jo grupa ir bloíçta! Lûdzu griezties pie grupas kuratora.');"
		response.write "	if (document.getElementById('forma')){forma.reset();}"
	else
		response.write "	res = true;"
	end if

	response.write "	return res;	"
	response.write "}"
	response.write "</script>"

end sub
'--------------------------------------

sub checkDalibnInGroup(p_did, p_gid)

	response.write "<script LANGUAGE=""JScript"">"
	response.write "function checkDalibnInGroup() {"
	response.write "	var res;"

	if isDalibnInGroup(p_did, p_gid) then
		response.write "	res = false;"
		response.write "	alert('Dalîbnieks vienreiz jau ir rçìistrçts ðim ceïojumam.');"
		response.write "	if (document.getElementById('forma')){forma.reset();}"
	else
		response.write "	res = true;"
	end if

	response.write "	return res;	}</script>"

end sub
'--------------------------------------
function isDalibnInGroup(p_did, p_gid)

	res = false
	if p_did<>"" and p_gid<>"" then
		ssql = "select * from pieteikums p inner join piet_saite ps on p.id = ps.pid where p.deleted = 0 and ps.deleted = 0 and ps.did = "+cstr(p_did)+"  and p.gid = "+cstr(p_gid)
		set rd = conn.execute(ssql)
		if not rd.eof then
			res = true
		end if	
	end if
	isDalibnInGroup = res

end function

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
		if type_l = "text"   then result_l = result_l + " and " + field_l+" like N'%" + trim(val_l) + "%'"
		if type_l = "string" then result_l = result_l + " and " + field_l+" = '" + trim(val_l) + "'"
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
		
		if field_l="pasederdat" or field_l="id_derdat" or field_l="paseterm" or field_l="dzimsanas_datums" or field_l="idderdat" then '---iznjemums dalibn formas laukam paseDerDat. Datumu pârvçrð sql datubazes formâtâ 'mm.dd.yyyy'

			r_l(field_l)= FormatedTime(val_l,"dmy")
			
		else '--- visi parejie lauki
			
			r_l(field_l)=val_l
			
		end if
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
		if field_l="pasederdat" or field_l="id_derdat" or field_l="paseterm" or field_l="dzimsanas_datums" or field_l="idderdat" then '---iznjemums dalibn formas laukam paseDerDat. Datumu pârvçrð sql datubazes formâtâ 'mm.dd.yyyy'

			r_l(field_l)= FormatedTime(val_l,"dmy")
			
		else '--- visi parejie lauki
			
			r_l(field_l)=val_l
			
		end if
		'r_l(field_l)=val_l
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
%>
<script type='text/javascript' src='https://code.jquery.com/jquery-latest.js'></script>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js'></script>
<script  src='https://code.jquery.com/ui/1.12.1/jquery-ui.min.js'  integrity='sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU='  crossorigin='anonymous'></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Tom Select CSS -->
<link href="https://cdn.jsdelivr.net/npm/tom-select/dist/css/tom-select.css" rel="stylesheet">
<!-- Tom Select JS -->
<script src="https://cdn.jsdelivr.net/npm/tom-select/dist/js/tom-select.complete.min.js"></script>
<style>
.ts-control {
	padding:0px;
	min-height:20px;
}
</style>
<%
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


sub recalculatePieteikumiOnVietuVeidiChange(id,persona,papildv)
	set rc = conn.execute ("select count(id) from pieteikums where deleted = 0 and gid in (select gid from vietu_veidi where id = " +cstr(id)+")")

	'--- parrekina visus pieteikumus, kur ir sis vietas veids

	' Kompleksai grupai tas process ietu paaraak ilgi
	if cstr(session("lastgid"))<>cstr(GetComplexGroup()) and getnum(rc(0))<100 then
	 
	 conn.execute ("update piet_saite set persona = "+persona+", papildv =  "+papildv+" where deleted = 0 and vietas_veids = "+cstr(id))
	 set rPiet = conn.execute("select * from pieteikums where deleted = 0 and id in (select pid from piet_saite where deleted = 0 and vietas_veids = "+cstr(id)+")")
		
		while not rPiet.eof
		
			'Response.Write rPiet("id")
			
			 pieteikums_recalculate (rPiet("id"))
			 rPiet.Movenext
		wend
	end if
end sub


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
dim empty_date
empty_date = Cdate("1900-01-01")
if not isnull(date_p) and date_p <> empty_date then 
	dateprint = twodigits(day(date_p))+"."+twodigits(month(date_p))+"."+cstr(year(date_p))
else
	dateprint = ""
end if
end function

function date_ddmmyy(date_p)

	on error resume next
	
	dim dd
	dim mm
	dim yy
	
	if not isnull(date_p) then 
		dd = day(date_p)
		if dd<10 then 
			dd = "0"+cstr(dd)
		end if
		mm = month(date_p)
		if mm<10 then 
			mm = "0"+cstr(mm)
		end if

		yy = right(cstr(year(date_p)),4)
		
		date_ddmmyy = cstr(dd)+"."+cstr(mm)+"."+yy
	else
		date_ddmmyy = ""
	end if

end function

'timeprint
function timeprint(date_p)
dim ret_l
if not isnull(date_p) then 
   If date_p<>0 then
	ret_l = ret_l + twodigits(day(date_p))+"."
	ret_l = ret_l + twodigits(month(date_p))+"."
	ret_l = ret_l + cstr(year(date_p))+" "
	ret_l = ret_l + twodigits(hour(date_p))+":"
	ret_l = ret_l + twodigits(minute(date_p))+":"
	ret_l = ret_l + twodigits(second(date_p))
	timeprint = ret_l
   Else
        timeprint = ""
   End if
else
	timeprint = ""
end if
end function

function timeprint2(date_p)
dim ret_l
if not isnull(date_p) then 
	ret_l = ret_l + twodigits(hour(date_p))+":"
	ret_l = ret_l + twodigits(minute(date_p))
	timeprint2 = ret_l
else
	timeprint2 = ""
end if
end function

'@ DigitCount
'Prints at least two digits 01,02 etc.
function TwoDigits(x)
if x<10 then TwoDigits = "0" + cstr(x) else TwoDigits = cstr(x)
end function

'________________
Function IsDigit(d)
dim s
s = cstr(d)
if len(s) > 1 then IsDigit = false:exit function
if len(s) < 1 then IsDigit = false:exit function
if s<"0" then IsDigit = false:exit function
if s>"9" then IsDigit = false: exit function
IsDigit = true
end function

function NormalDate(date_p)
dim i
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

'SQLDate
function SQLDate(d_p)
sqldate = SQLDateYMD(d_p)
'sqldate = rtrim(normaldate(d_p))
exit function
end function

function SQLDate2(d_p)
sqldate2 = rtrim(normaldate2(d_p))
exit function
end function

function SQLDateYMD(d_p)


dim mon
dim da

mon = cstr(month(normaldate2(d_p)))
da = cstr(day(normaldate2(d_p)))

if len(cstr(mon)) = 1 then mon = "0" + cstr(mon)
if len(cstr(da)) = 1 then da = "0" + cstr(da)


SQLDateYMD = cstr(year(normaldate2(d_p))) + "-" + mon + "-" + da
exit function
end function

function SQLTime(d_p)
 if isnull(d_p) then exit function
 SQLTime = cstr(month(d_p))
 SQLTime = SQLTime + "/"+cstr(day(d_p))
 SQLTime = SQLTime + "/"+cstr(year(d_p))
 SQLTime = SQLTime + " "+cstr(hour(d_p))
 SQLTIME = SQLTime+":"+cstr(minute(d_p))
 SQLTime = SQLTime+":"+cstr(second(d_p))
end function

function SQLTimeNow(d_p1)
 d_p = rtrim(normaldate(d_p1))
 SQLTimeNow = cstr(month(d_p))
 SQLTimeNow = SQLTimeNow + "/"+cstr(day(d_p))
 SQLTimeNow = SQLTimeNow + "/"+cstr(year(d_p))
 SQLTimeNow = SQLTimeNow + " "+cstr(hour(now))
 SQLTimeNow = SQLTimeNow+":"+cstr(minute(now))
 SQLTimeNow = SQLTimeNow+":"+cstr(second(now))
end function


function NormalDate2(date_p)
dim i
on error resume next


x = date_p + date_p
if len(cstr(date_p)) <> len(cstr(x))/2 then
	NormalDate2 = cstr(day(date_p))+"/"+cstr(month(date_p))+"/"+cstr(year(date_p))
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
	
	if (i1) = 0 then i1 = 1
	if (i2) = 0 then i2 = 1
	if (i3) = 0 then i3 = 1
	
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
dim f
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
dim f
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

function InputSQLDate(inp_p)

	InputSQLDate = inp_p
	if InputSQLDate = "" or isnull(inp_p) then
	 InputSQLDate = "NULL"
	else
	 InputSQLDate = "'"+SQLDate(FormatedDate(InputSQLDate,"dmy"))+"'"
	end if
end function

function FormatedDate(stringg,formatt)
dim d
dim m
dim y
dim i
dim sy
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
dim i
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
 SQLText = replace(nullprint(s),"'","''")
end function

function SQLNum(s)
 SQLNum = replace(s,",",".")
end function

sub rw(s)
  response.write s
end sub

function IIF(a, b, c)
  If a then
   IIF = b
  else
   IIF = c
  end if
end function

function CountriesByRegion(s)
dim valstis
 if s = "R" then
 
  valstis = "'ANDORA', 'AUSTRIJA', 'BELGIJA', 'BENELUX', 'FRANCIJA', 'GRIEKIJA', 'ITALIJA'"
  valstis = valstis + ", 'LIHTENST', 'LUKSEMBURG', 'MONAKO', 'NIDERLANDE', 'PORTUGALE', 'SPANIJA', 'SVEICE', 'TURCIJA', 'VACIJA'"
  valstis = valstis + ", 'MALTA', 'MONAKO'"
  
 elseif s = "Z" then
  
  valstis = "'DANIJA', 'IRIJA', 'LIELBRITAN', 'NORVEGIJA', 'SOMIJA', 'ZVIEDRIJA', 'LIETUVA', 'LATVIJA', 'IGAUNIJA'"
  
 elseif s = "C" then 
  
  valstis = "'BALTKRIEV', 'BULGARIJA', 'CEHIJA', 'HORVATIJA', 'KRIEVIJA'"
  valstis = valstis + ", 'MELNKALNE', 'POLIJA', 'RUMANIJA', 'SERBIJA', 'SLOVAKIJA', 'SLOVENIJA', 'UKRAINA', 'UNGARIJA'"
  valstis = valstis + ", 'BOSNIJA', 'ALBANIJA', 'ARMENIJA', 'GRUZIJA', 'KAZAHSTANA', 'KIRGIZSTAN', 'MAKEDONIJA'"
  valstis = valstis + ", 'MOLDOVA', 'MONGOLIJA', 'TADZIKISTA', 'TURKMENIST', 'UZBEKISTAN'"

 elseif s = "E" then
  
  valstis = "'AAE', 'ARGENTINA', 'ASV', 'AUSTRALIJA', 'BIRMA', 'BRAZILIJA', 'DAAR', 'EGIPTE', 'INDIJA', 'INDONEZIJA'"
  valstis = valstis + ", 'ISLANDE', 'JAPANA', 'KANADA', 'KENIJA', 'KINA', 'KUBA', 'MALAIZIJA', 'MAROKA', 'MEKSIKA'"
  valstis = valstis + ", 'NEPALA', 'NEWZELAND', 'JAUNZELAND', 'OMANA', 'PERU', 'SINGAPURA', 'SRILANKA', 'SURINAMA'"
  valstis = valstis + ", 'TAIZEME', 'TANZANIJA', 'TIBETA', 'TUNISIJA', 'URUGVAJA', 'ZIMBABVE', 'IZRAELA', 'IRANA', 'CILE', 'JORDANIJA', 'ETIOPIJA'"
  valstis = valstis + ", 'AFGAN', 'ALZIRA', 'BELIZA', 'BOLIVIJA', 'BOSTAVANA', 'BUTANA', 'D_KOREJA'" 
  valstis = valstis + ", 'DOMINIKANA', 'EKVADORA', 'ERITREJA', 'FILIPINAS', 'GVATEMALA', 'HONDURASA'" 
  valstis = valstis + ", 'JAMAIKA', 'JEMENA', 'KAMBODZA', 'KANARIJUSA', 'KOLUMBIJA', 'LAOSA'" 
  valstis = valstis + ", 'LESOTO', 'LIBANA', 'MADAGASKAR', 'MALDIVUSAL', 'MALI', 'MAURICIJA', 'MOZAMBIKA'"
  valstis = valstis + ", 'NAMIBIJA', 'PANAMA', 'PARAGVAJA', 'SEISELUSAL', 'SIRIJA', 'SVAZILENDA', 'TAIVANA'" 
  valstis = valstis + ", 'TRINIDADA', 'URUGVAJA', 'VENECUELA', 'VJETNAMA', 'Z_AFRIKA'" 
  
 elseif s = "K" then
  
  valstis = "'KIPRA','CITA'"
 
 end if
 
 CountriesByRegion = valstis

end function

function RegionForCountry(s)

 Select Case s
 
  Case "ANDORA", "AUSTRIJA", "BELGIJA", "BENELUX", "FRANCIJA", "GRIEKIJA", "ITALIJA", "LIHTENST", "LUKSEMBURG", "MONAKO", "NIDERLANDE", "PORTUGALE", "SPANIJA", "SVEICE", "TURCIJA", "VACIJA", "MALTA", "MONAKO" RegionForCountry = "R"
  Case "DANIJA", "IRIJA", "LIELBRITAN", "NORVEGIJA", "SOMIJA", "ZVIEDRIJA", "LIETUVA", "LATVIJA", "IGAUNIJA" RegionForCountry = "Z"
  Case "BALTKRIEV", "BULGARIJA", "CEHIJA", "HORVATIJA", "KRIEVIJA", "MELNKALNE", "POLIJA", "RUMANIJA", "SERBIJA", "SLOVAKIJA", "SLOVENIJA", "UKRAINA", "UNGARIJA", "BOSNIJA", "ALBANIJA", "ARMENIJA", "GRUZIJA", "KAZAHSTANA", "KIRGIZSTAN", "MAKEDONIJA", "MOLDOVA", "MONGOLIJA", "TADZIKISTA", "TURKMENIST", "UZBEKISTAN" RegionForCountry = "C"
  Case "AAE", "ARGENTINA", "ASV", "AUSTRALIJA", "BIRMA", "BRAZILIJA", "DAAR", "EGIPTE", "INDIJA", "INDONEZIJA", "ISLANDE", "JAPANA", "KANADA", "KENIJA", "KINA", "KIPRA','KUBA", "MALAIZIJA", "MAROKA", "MEKSIKA", "NEPALA", "NEWZELAND", "JAUNZELAND", "OMANA", "PERU", "SINGAPURA", "SRILANKA", "SURINAMA", "TAIZEME", "TANZANIJA", "TIBETA", "TUNISIJA", "URUGVAJA", "ZIMBABVE", "IZRAELA", "IRANA", "CILE", "JORDANIJA", "ETIOPIJA", "AFGAN", "ALZIRA", "BELIZA", "BOLIVIJA", "BOSTAVANA", "BUTANA", "D_KOREJA", "DOMINIKANA", "EKVADORA", "ERITREJA", "FILIPINAS", "GVATEMALA", "HONDURASA", "JAMAIKA", "JEMENA", "KAMBODZA", "KANARIJUSA", "KOLUMBIJA", "LAOSA", "LESOTO", "LIBANA", "MADAGASKAR", "MALDIVUSAL", "MALI", "MAURICIJA", "MOZAMBIKA", "NAMIBIJA", "PANAMA", "PARAGVAJA", "SEISELUSAL", "SIRIJA", "SVAZILENDA", "TAIVANA", "TRINIDADA", "URUGVAJA", "VENECUELA", "VJETNAMA", "Z_AFRIKA" RegionForCountry = "E"
  Case "CITA" RegionForCountry = "K"
 
 End Select

end function

function GrupaIsEditable(date)
	if cint(DatePart("yyyy",(formateddate(date,"dmy")))) < Year(Date)-1 Then GrupaIsEditable = 0 Else GrupaIsEditable = 1
end function

function CompareDates(begin_dat,end_dat)
	if DateDiff("d",begin_dat,end_dat) < 0 Then CompareDates = 0 Else CompareDates = 1
end function


function vecums_new(did,beigu_dat)
    Dim ssql, dalibn, p_kods
    Dim dz_gads, dz_menesis, dz_diena
    Dim dz_datums
	
	
	ssql = "select isnull(pk1,'') as pk1, isnull(dzimsanas_datums,'') as dzimsanas_datums from dalibn WHERE id="+cstr(did)+""
	set dalibn=conn.execute(ssql)
	if not dalibn.eof then
		if (dalibn("dzimsanas_datums") <> "" and YEAR(dalibn("dzimsanas_datums")) <> 1900) then

			vecums_new = MyDateDiff("yyyy",dalibn("dzimsanas_datums"),beigu_dat) 
		else
			p_kods = dalibn("pk1")

			if len(p_kods)=6 then
				
				dz_gads = right(p_kods,2)
				'rw dz_gads
				if cint(dz_gads) < int(right(Year(Date),2)) then
					dz_gads = "20" + dz_gads
				else
					dz_gads = "19" + dz_gads
				end if
			
				dz_menesis = cint(mid(p_kods,3,2))
				dz_diena = cint(mid(p_kods,1,2))
				
				dz_datums = dateserial(dz_gads,dz_menesis,dz_diena)
				
				vecums_new = MyDateDiff("yyyy",dz_datums,beigu_dat)
			else
				
				vecums_new = ""
				
			end if
		end if
	else 
		vecums_new = ""
	end if
	
end function

Function MyDateDiff(difftype , date1 , date2 ) 
    Dim EarlyDate, LateDate 
    Dim tempDate 
	Dim i
	
    If date1 <= date2 Then 
        EarlyDate = date1 
        LateDate = date2 
    Else 
        EarlyDate = date2 
        LateDate = date1 
    End If 
     
    tempDate = EarlyDate 
    i = 0 
    Do While tempDate <= LateDate 
        i = i + 1 
        tempDate = DateAdd(difftype, i, EarlyDate) 
    Loop 
    MyDateDiff = i - 1 
End Function 

function vecums(p_kods,beigu_dat)


			if len(p_kods)=6 then
				
				dz_gads = right(p_kods,2)
				
				if cint(dz_gads) < int(right(Year(Date),2)) then
					dz_gads = "20" + dz_gads
				else
					dz_gads = "19" + dz_gads
				end if
			
				dz_menesis = cint(mid(p_kods,3,2))
				dz_diena = cint(mid(p_kods,1,2))
				
				dz_datums = dateserial(dz_gads,dz_menesis,dz_diena)
				
				''vecums = Year(Date) - dz_gads
				''vecums = Year(Date) - year(dz_datums)
				vecums = MyDateDiff("yyyy",dz_datums,beigu_dat)
				''vecums = MyDateDiff("yyyy",dateserial(1999,12,31),dateserial(2000,1,1))
				''vecums = dateprint(dz_datums)
			else
				
				vecums = ""
				
			end if

end function

'vecuma rçíinâðanas funkcija 
function GetAge(did)
	dim ssql
	ssql = "select isnull(pk1,'') as pk1, isnull(dzimsanas_datums,'') as dzimsanas_datums from dalibn WHERE id="+cstr(did)+""
'	response.write(ssql)
	'response.write("<br>")
	set dalibn=conn.execute(ssql)
	if not dalibn.eof then
		if (dalibn("dzimsanas_datums") <> "" and year(dalibn("dzimsanas_datums")) <> 1900 ) then
	
			GetAge = DateDiff("yyyy",dalibn("dzimsanas_datums"),Date()) 
			'response.write(GetAge)
		else
			if (dalibn("pk1") <> "" And Len(pk1) =6) then
			
				d_yy = getnum(right(dalibn("pk1"),2)) 'gads no personas koda
				'Response.Write(d_yy)
				if d_yy > 0 then

					if  d_yy <= getnum(right(Year(Date()),2)) then
						d_yy = 2000 + d_yy
					else
						d_yy = 1900 + d_yy
					end if
				
								
					GetAge = DateDiff("yyyy", "01/01/" & d_yy, Date())
				end if
				
			else 
				GetAge = false
			end if			
		end if
	end if	
end function

sub JsDateVerify()
%>
<script language = "Javascript">
/**
 * DHTML date validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */
// Declaring valid date character, minimum year and maximum year
var dtCh= ".";
var minYear=1900;
var maxYear=2100;

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr){
	var daysInMonth = DaysArray(12)
	var pos1=dtStr.indexOf(dtCh)
	var pos2=dtStr.indexOf(dtCh,pos1+1)
	var strDay=dtStr.substring(0,pos1)
	var strMonth=dtStr.substring(pos1+1,pos2)
	var strYear=dtStr.substring(pos2+1)
	strYr=strYear
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
	if (pos1==-1 || pos2==-1){
		alert("Datuma ievades formâtam jâbût : dd.mm.yyyy")
		return false
	}
	if (strMonth.length<1 || month<1 || month>12){
		alert("Lûdzu ievadiet pareizu datuma mçnesi")
		return false
	}
	if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		alert("Lûdzu ievadiet pareizu datuma dienu")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		alert("Lûdzu ievadiet 4 ciparu gadu robeþâs no "+minYear+" lîdz "+maxYear)
		return false
	}
	if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
		alert("Lûdzu ievadiet pareizu datumu")
		return false
	}
return true
}

function ValidateDate(f){

	var dt=f;
	if (isDate(dt.value)==false){ 
		//dt.focus();
		return false;
	}
    return true;
 }

</script>
<%
end sub
%>
