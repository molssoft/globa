<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
dim dsk
dim conn
openconn

oid = request.querystring("oid")
if oid = "" then 	message = "Nav noradits ordera id!"
set ord_L = server.createobject("ADODB.Recordset")
ord_L.CursorLocation = 3
ord_L.open "select * from orderis where id =" + cstr(oid),conn,3,3

if request.querystring("drukat") = 1 then 
	if ord_L("pid") = 0 then
		response.redirect "drukord_izm.asp"+qstring()
	else
		response.redirect "drukord.asp"+qstring()
	end if
end if

validation = 0
if IsAccess(T_ORD_LAB) = true then validation = 1

'Bankas kontiem speciâlas permîcijas kâdreiz bija
'if ucase(get_user) = "ELITA" then
'	if mid(request.form("kredits"),1,4) = "2624" then validation = 1
'	if mid(request.form("debets"),1,4) = "2624" then validation = 1
'end if

if validation <> 1 then
 	error = 1
	message = "Ðis serviss jums nav pieejams."
	docstart "Kïûda","y1.jpg"
	Response.Write "<center><font color = red>" + message + "<br>" + "Autorizâcijas kïûda."
else
	session("item") = "orderis"
	session("datums") = request.form("datums")
	session("kas") = request.form("kas")
	session("pamatojums") = request.form("pamatojums")
	session("pielikums") = request.form("pielikums")
	session("kredits") = request.form("kredits")
	session("debets") = request.form("debets")
	session("resurss") = Request.Form("resurss")
	session("resurss_uz") = Request.Form("resurss_uz")
	session("summa") = request.form("summa")
	session("valuta") = request.form("valuta")
	session("NoPid") = request.form("NoPid")
	session("UzPid") = request.form("UzPid")
	session("parsk") = request.form("parsk")
	session("parvalutu") = request.form("parvalutu")
	session("dala_no") = CheckBox(Request.Form("dala_no"))
	session("dala_uz") = CheckBox(Request.Form("dala_uz"))
	session("rekins") = getnum(Request.Form("rekins"))
	session("rekins_gads") = getnum(Request.Form("rekins_gads"))
	session("rekins_pazime") = request.form("rekins_pazime")
	session("zils") = getnum(Request.Form("zils"))

	'Response.Write("-> "&session("zils"))
	'Response.end

	if request.form("datums") <> "" then ord_L("datums") = FormatedTime(request.form("datums"),"dmy") else ord_L("datums")=null'normaldate2(request.form("datums")) else ord_L("datums")=null
	if request.form("kas") <> "" then 
	 ord_L("kas") = request.form("kas") 
	 ord_L("kas2") = encode(request.form("kas"))
	else 
	 ord_L("kas")=null
	 ord_L("kas2") = request.form("kas") 
	end if
	if request.form("pamatojums") <> "" then 
	 ord_L("pamatojums") = request.form("pamatojums") 
	 ord_L("pamatojums2") = encode(request.form("pamatojums"))
	else 
	 ord_L("pamatojums2")=null
	 ord_L("pamatojums")=null
	end if
	if request.form("pielikums") <> "" then 
	 ord_L("pielikums") = request.form("pielikums") 
	 ord_L("pielikums2") = encode(request.form("pielikums"))
	else 
	 ord_L("pielikums")=null
	 ord_L("pielikums2")=null
	end if
	ord_L("summaLVL") = 0
	ord_L("summaUSD") = 0
	ord_L("summaEUR") = 0
	ord_L("nosummaLVL") = 0
	ord_L("nosummaUSD") = 0
	ord_L("nosummaEUR") = 0
	ord_L("summa") = 0
	ord_L("dala_no") = CBool(session("dala_no"))
	ord_L("dala_uz") = CBool(session("dala_uz"))
	ord_L("rekins") = CLng(session("rekins"))
	ord_L("rekins_gads") = CLng(session("rekins_gads"))
	ord_L("rekins_pazime") = CStr(left(session("rekins_pazime"),2))
	
	if session("zils") = "on" then
		ord_L("zils") = true
	else
		ord_L("zils") = false
	end if
	
	if request.form("kredits") <> "" then ord_L("kredits") = request.form("kredits") else ord_L("kredits")=null
	if request.form("debets") <> "" then ord_L("debets") = request.form("debets") else ord_L("debets")=Null

	'maksâjuma veids
	maks_veids = maksajuma_veids(ord_L("kredits"))
	If maks_veids = "" Then maks_veids = maksajuma_veids(ord_L("debets"))
	ord_L("maks_veids") = maks_veids

	if request.form("resurss") <> "" then ord_L("resurss") = request.form("resurss") else ord_L("resurss")=null
	if request.form("resurss_uz") <> "" then ord_L("resurss_uz") = request.form("resurss_uz") else ord_L("resurss_uz")=null
	if request.form("summa") <> "" then ord_L("summaval") = request.form("summa") else ord_L("summaval")=null
	if request.form("valuta") <> "" then ord_L("valuta") = request.form("valuta") else ord_L("valuta")=null
	set kur = server.createobject("ADODB.Recordset")
	kur.open "select * from valutakurss where valuta = "+cstr(session("valuta"))+" AND datums = '" + sqldate(session("datums"))+"'",conn,3,3
	''if session("valuta") <> 49 then
	if session("valuta") <> CStr(DefaultValutaIDD(now)) then
		if kur.recordcount = 0  then
			session("message") = "Nav norâdîts valûtas kurss. Lûdzu pievienojiet to." + session("valuta")
			ord_L.update
			session("valutaord") = ord_L("id")
			response.redirect "valuta.asp"
		end if
		kurss = kur("kurss2")
		ord_L("summa") = getnum(ord_L("summaval"))/kurss
		ord_L("summa") = round(ord_L("summa")*100)/100
	else
		ord_L("summa") = ord_L("summaval")
	end If
	
	'if session("parvalutu") = "LVL" then
	 'ord_L("summaLVL") = ord_L("summa")
	 'ord_L("summaUSD") = 0
	 'ord_L("summaEUR") = 0
	 'ord_L("nosummaLVL") = ord_L("summa")
	 'ord_L("nosummaUSD") = 0
	 'ord_L("nosummaEUR") = 0
	 'if getnum(ord_L("pid"))<>0 and getnum(ord_L("nopid"))<>0 then
	  ''Response.Write "test"
	  'if ord_L("valuta") = 49 then
	   'ord_L("nosummaLVL") = 0
	   'ord_L("nosummaUSD") = 0
	   'ord_L("nosummaEUR") = ord_L("summaval")
	  'elseif ord_L("valuta") = 68 then
	   'ord_L("nosummaUSD") = ord_L("summaval")
	   'ord_L("nosummaLVL") = 0
	   'ord_L("nosummaEUR") = 0
	  'else
	   'ord_L("nosummaUSD") = 0
	   'ord_L("nosummaLVL") = ord_L("summaval")	   
	   'ord_L("nosummaEUR") = 0
	  'end if
	 'else
	  'if session("valuta") = 68 then
	   'ord_L("nosummaLVL") = 0
	   'ord_L("nosummaUSD") = request.form("summa")
	  'end if
	 'end if
	'end If
	
	if session("parvalutu") = "LVL" then
	 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
	 if rValuta("val") = "LVL" then
	  ord_L("summaLVL") = ord_L("summaval")
	  ord_L("nosummaLVL") = ord_L("summaval")
	 else
	  rLVLKurss = conn.execute("select * from valutakurss where valuta = 40 AND datums = '" + sqldate(session("datums"))+"'")
	  ord_L("summaLVL") = ord_L("summa")*rLVLKurss("kurss2")
	  ord_L("summaLVL") = round(ord_L("summaLVL")*100)/100
	  ord_L("nosummaLVL") = ord_L("summaLVL")
	 end if
	 ord_L("summaEUR") = 0
	 ord_L("nosummaEUR") = 0
	 ord_L("summaUSD") = 0
	 ord_L("nosummaUSD") = 0
	 if getnum(ord_L("pid"))<>0 and getnum(ord_L("nopid"))<>0 then
	  if ord_L("valuta") = 40 then
	   ord_L("nosummaLVL") = ord_L("summaval")
	   ord_L("nosummaEUR") = 0
	  else
	   ord_L("nosummaEUR") = ord_L("summaval")
	   ord_L("nosummaLVL") = 0
	  end if
	 end if
	end if


	if session("parvalutu") = "USD" then
	 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
	 if rValuta("val") = "USD" then
	  ord_L("summaUSD") = ord_L("summaval")
	  ord_L("nosummaUSD") = ord_L("summaval")
	 else
	  rUSDKurss = conn.execute("select * from valutakurss where valuta = 68 AND datums = '" + sqldate(session("datums"))+"'")
	  ord_L("summaUSD") = ord_L("summa")*rUSDKurss("kurss2")
	  ord_L("summaUSD") = round(ord_L("summaUSD")*100)/100
	  ord_L("nosummaUSD") = ord_L("summaUSD")
	 end if
	 ord_L("summaLVL") = 0
	 ord_L("nosummaLVL") = 0
	 if getnum(ord_L("pid"))<>0 and getnum(ord_L("nopid"))<>0 then
	  if ord_L("valuta") = 40 then
	   ord_L("nosummaLVL") = ord_L("summaval")
	   ord_L("nosummaUSD") = 0
	  else
	   ord_L("nosummaUSD") = ord_L("summaval")
	   ord_L("nosummaLVL") = 0
	  end if
	 end if
	end if
	
	if session("parvalutu") = "EUR" then
	 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
	 if rValuta("val") = "EUR" then
	  ord_L("summaEUR") = ord_L("summaval")
	  ord_L("nosummaEUR") = ord_L("summaval")
	 else
	  rEURKurss = conn.execute("select * from valutakurss where valuta = 49 AND datums = '" + sqldate(session("datums"))+"'")
	  ord_L("summaEUR") = ord_L("summa")*rEURKurss("kurss2")
	  ord_L("summaEUR") = round(ord_L("summaEUR")*100)/100
	  ord_L("nosummaEUR") = ord_L("summaEUR")
	 end if
	 ord_L("summaLVL") = 0
	 ord_L("nosummaLVL") = 0
	 ord_L("summaUSD") = 0
	 ord_L("nosummaUSD") = 0
	 if getnum(ord_L("pid"))<>0 and getnum(ord_L("nopid"))<>0 then
	  if ord_L("valuta") = 40 then
	   ord_L("nosummaLVL") = ord_L("summaval")
	   ord_L("nosummaEUR") = 0
	  else
	   ord_L("nosummaEUR") = ord_L("summaval")
	   ord_L("nosummaLVL") = 0
	  end if
	 end if
	end if
	
	'maksâjuma veids
	maks_veids = maksajuma_veids(ord_L("kredits"))
	If maks_veids = "" Then maks_veids = maksajuma_veids(ord_L("debets"))
	ord_L("maks_veids") = maks_veids

	ord_L("need_check") = 1
	ord_L.update
	pieteikums_recalculate GETNUM(ORD_L("PID"))
	pieteikums_recalculate GETNUM(ORD_L("NOPID"))

	session("valutaord") = 0
	LogEditAction "orderis",ord_l("id")
	response.redirect "ordedit.asp"+qstring()
end if


%>