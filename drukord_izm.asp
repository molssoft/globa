<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim vu
dim oid
DIM CONN
OPENCONN

pid=Request.QueryString("pid")+""
if request.querystring("drukat") <> 1 then
	if pid="" then
		message = "Nav norâdîts no kura pieteikuma izmaksâ!"
	else
		gid = id_field("pieteikums",pid,"gid")
		veidsID = getnum(id_field("grupa",gid,"veids"))
		pielikums = session("pielikums")
		if veidsID = 6 then pielikums = "Kopleksais pasûtîjums nr. "+ cstr(gid) + " "+pielikums
	end if
	poga_var = session("poga")
	fieldso = "num kredits debets resurss resurss_uz datums pamatojums pielikums summaval valuta kas"
	formso = "num kredits debets resurss resurss_uz datums pamatojums pielikums summa valuta kas"
	if poga_var = "Reìistrçt" then
		set ord = server.createobject("ADODB.Recordset")
		incordnum conn
		if len(session("kredits"))>7 then
		 if mid(session("kredits"),1,7) = "2.6.1.2" then session("num") = "0"
		end if
		ord.open "select * from orderis where id=0",conn,3,3
		ord.addnew
		ord("pid") = 0
		ord("NoPid") = session("LastPid")
		ord("dala_uz") = CBool(session("dala_uz"))
		ord("dala_no") = CBool(session("dala_no"))
		'if session("datums")<>"" then ord("datums") = NORMALDATE2(session("datums"))
		if session("datums")<>"" then ord("datums") =FormatedTime(session("datums"),"dmy")
		if session("kas")<>"" then 
		 ord("kas") = session("kas")
		 ord("kas2") = encode(session("kas"))
		end if
		if session("pielikums")<>"" then 
		 ord("pielikums") = session("pielikums")
		 ord("pielikums2") = encode(session("pielikums"))
		end if
		if session("pamatojums")<>"" then 
		 ord("pamatojums") = session("pamatojums")
		 ord("pamatojums2") = encode(session("pamatojums"))
		end if
		if session("debets")<>"" then ord("debets") = session("debets")
		if session("kredits")<>"" then ord("kredits") = session("kredits")
		if session("resurss")<>"" then ord("resurss") = session("resurss")
		if session("resurss_uz")<>"" then ord("resurss") = session("resurss_uz")
		if session("summa")<>"" then ord("summaval") = cdbl(session("summa"))	


		
		if session("valuta")<>"" then ord("valuta") = session("valuta")
		set kur = server.createobject("ADODB.Recordset")
		kur.open "select * from valutakurss where valuta = "+cstr(session("valuta"))+" AND datums = '" + sqldate(session("datums"))+"'",conn,3,3
		
		'-----------------------------------------------------------------------------
		'pievienots 10.01.2018, lai nekonvçrtçtu vecajos piet. LVL uz EUR

		set valuuta = conn.execute("SELECT val FROM valuta WHERE id="+cstr(session("valuta"))+"")
		valutas_nos = valuuta(0)
		'rw valutas_nos
		if session("valuta") <> 49 and valuutas_nos<>session("parvaluta") then
		'-------------------------------------------------------------------------
		'if session("valuta") <> 49 then
			if kur.recordcount = 0  then
				session("message") = "Nav norâdîts valûtas kurss."
				response.redirect "valuta.asp"
			end if
			kurss = kur("kurss2")
			ord("summa") = getnum(ord("summaval"))/kurss
			ord("summa") = round(ord("summa")*100)/100
		else
			ord("summa") = ord("summaval")
		end if
		'--- USD + LVL + EUR
		 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
		if session("parvalutu") = "LVL" then
		 ord("summaLVL") = ord("summa")
		 ord("summaUSD") = 0
		 ord("summaEUR") = 0
		end if
		if session("parvalutu") = "USD" then
		
		 if rValuta("val") = "USD" then
		  ord("summaUSD") = ord("summaval")
		 else
		  set rUSDKurss = conn.execute("select * from valutakurss where valuta = 68 AND datums = '" + sqldate(session("datums"))+"'")
		  if not rUSDKurss.eof then
		   ord("summaUSD") = ord("summa")*rUSDKurss("kurss2")
		  else
		   session("message") = "Nav noradits valutas kurss."
		   response.redirect "valuta.asp"
		  end if
		 end if
		 ord("summaLVL") = 0
		 ord("summaEUR") = 0
		end if 
		
		if session("parvalutu") = "EUR" then
		 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
		 if rValuta("val") = "EUR" then
		  ord("summaEUR") = ord("summaval")
		 else
		  set rEURKurss = conn.execute("select * from valutakurss where valuta = 49 AND datums = '" + sqldate(session("datums"))+"'")
		  if not rEURKurss.eof then
		   ord("summaEUR") = ord("summa")*rEURKurss("kurss2")
		  else
		   session("message") = "Nav noradits valutas kurss."
		   response.redirect "valuta.asp"
		  end if
		 end if
		 ord("summaLVL") = 0
		 ord("summaUSD") = 0
		end if
		
		ord("summaLVL") = round(ord("summaLVL")*100)/100
		ord("summaUSD") = round(ord("summaUSD")*100)/100
		ord("summaEUR") = round(ord("summaEUR")*100)/100
		
		'pârbaudam vai ir tik daudz naudas 
		'-----------------------------------
		izm = 0
		
		if ord("summaLVL")<>0 then 
			izm = ord("summaLVL")
		else if ord("summaUSD")<>0 then 
				izm = ord("summaUSD")
				else if ord("summaEUR")<>0 then 
						izm = ord("summaEUR")
					end if
			end if
		end if
				
		
		izmaksat_var = false
		
		set rPiet = conn.execute("select * from pieteikums where id = "+cstr(pid))
		'rw session("parvalutu")
		'rw rValuta("val")
		if session("parvalutu")="USD" then
			if rValuta("val")="USD" then
				paliek = rPiet("iemaksasUSD")-rPiet("izmaksasUSD")
				if paliek < ord("summaval") then
					session("message") = "Izmaksât norâdîto summu nav iespçjams. Maksimâlâ summa="+cstr(paliek)
					response.redirect "orderis_izm.asp?pid="+nullprint(ord("nopid"))
				else
					izmaksat_var = true
				end if
			end if
		end if
		
		if session("parvalutu")="LVL" then
			if rValuta("val")="LVL" then
				paliek = rPiet("iemaksasLVL")-rPiet("izmaksasLVL")
				if paliek < ord("summaval") then
					session("message") = "Izmaksât norâdîto summu nav iespçjams. Maksimâlâ summa="+cstr(paliek)
					response.redirect "orderis_izm.asp?pid="+nullprint(ord("nopid"))
				else
					izmaksat_var = true
				end if
			end if
		end if
		
		if session("parvalutu")="EUR" then
			if rValuta("val")="EUR" then
				paliek = rPiet("iemaksasEUR")-rPiet("izmaksasEUR")

				if paliek < ord("summaval") then
					session("message") = "Izmaksât norâdîto summu nav iespçjams. Maksimâlâ summa="+cstr(paliek)
					response.redirect "orderis_izm.asp?pid="+nullprint(ord("nopid"))
				else
					izmaksat_var = true
				end if
			end if
		end if

		'pIemaksas = piet_iemaksas2(ord("nopid"),0,0) '--- iegust apstiprinaato iemaksu summu 
		'pIzmaksas = piet_izmaksas(ord("nopid"))
		
		pIemaksasLVL = piet_iemaksas3(ord("nopid"),0,"LVL") '--- iegust apstiprinaato iemaksu summu 
		pIzmaksasLVL = piet_izmaksas3(ord("nopid"),0,"LVL") '--- 
		pIemaksasEUR = piet_iemaksas3(ord("nopid"),0,"EUR") '--- iegust apstiprinaato iemaksu summu 
		pIzmaksasEUR = piet_izmaksas3(ord("nopid"),0,"EUR") '--- 

		'rw pIemaksasLVL 
		'rw "<--piemlVL<br>"
		'rw pIzmaksasLVL
		'rw "<--pizmLVL<br>"
		'rw ord("summaLVL")
		'rw "<--ordsummlvlv<br>"
		'rw izm
		'rw "<--izm<br>"
		'rw izmaksat_var
		'rw "<--izmaksat_var<br>"
		'response.end
		if ((pIemaksasLVL - pIzmaksasLVL) < ord("summaLVL") or izm <= 0) and (not izmaksat_var) then
			
			session("message") = "Izmaksât norâdîto summu nav iespçjams. Iemaksu summa = "+cstr(pIemaksasLVL)
			response.redirect "orderis_izm.asp?pid="+nullprint(ord("nopid"))
				
		Elseif ((pIemaksasEUR - pIzmaksasEUR) < ord("summaEUR") or izm <= 0) and (not izmaksat_var) then
			
			session("message") = "Izmaksât norâdîto summu nav iespçjams. Iemaksu summa = "+cstr(pIemaksasEUR)
			response.redirect "orderis_izm.asp?pid="+nullprint(ord("nopid"))
				
		Else
		
			maks_veids = maksajuma_veids(ord("kredits"))
			If maks_veids = "" Then maks_veids = maksajuma_veids(ord("debets"))
			ord("maks_veids") = maks_veids

			ord("need_check") = 1
			ord.update	
			pieteikums_recalculate session("LastPid")
			ord.movelast
			LogInsertAction "orderis",ord("id")
			message = "Izmaksas Orderis reìistrçts " + CStr(oid)
			
		end if
		'-----------------------------------
		
	end if
else
 set r = conn.execute("select * from orderis where id = "+cstr(Request.QueryString("oid")))
 session("num") = r("num")
 session("datums") = r("datums")
 session("summa") = r("summa")
 session("valuta") = r("valuta")
 session("kas") = r("kas")
 session("pamatojums") = r("pamatojums")
 session("pielikums") = r("pielikums")
end if
%>

<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<META NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080">

<table border = 1 width = 100%>
<tr><td>
<font size="4"><br>SIA "IMPRO CEÏOJUMI"<p></font>
<p>
<table border = 0 width = 100%>
<tr>
<td><strong>Reìistrâcijas #</strong></td>
<td>40003235627</td>
<td><strong>PVN maks. reg. Nr.</strong></td>
<td>LV40003235627</td>
</tr>
</table>
</td></tr>
</table>

<p>
<center>
<font size = "5"><strong>Kases izdevumu orderis</strong><strong>  Nr.</strong> <%=session("num")%><br></font>
<p>
<table border = "1" width = 100%>
<tr><td>
	<table border = 0 width = 50%>
	<td><strong>Datums</strong></td>
	<td><%=dateprint(NORMALDATE(session("datums")))%></td>
	</table>
</td></tr>

<tr><td>
	<table width = 100%><tr>
	<td colspan=4>
	<% 
	valuta = id_field("valuta",session("valuta"),"val") 
	%>
	<strong>Summa</strong>
	
	<%
		response.write CurrPrint(session("summa")) + " " + valuta
	%>

	</td>
	</tr></table>
</td></tr>


<tr><td>
	<table border = 0 width = 50%>
	<td width=25%><strong>Izsniegt </strong></td>
	<td><%=session("kas")%></td>
	</table>
</td></tr>

<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pamatojums<strong></td>
	<td><%=session("pamatojums")%></td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pielikumâ</strong></td>
	<td><%=pielikums%></td>
	</tr></table>
</td></tr>
</table>

<p>
<table width="100%" border="0">
<tr>
<td><strong>Vadîtâjs</strong></td>
<td>__________________________</td>
<td><strong>Galvenais grâmatvedis</strong></td>
<td>__________________________</td>
<tr>
</table>
<p>
</table>
	<table border="1" width = 100%>
		<tr><td>
		<strong>Saòçma</strong><br>
		<%
		if session("summa")<>"" then
			response.write nauda(session("summa"),id_field("valuta",session("valuta"),"val"))
		end if
		%>
	</table>
<br>
200____.g "_____" _______________________ Paraksts _______________________
<br>
<br>
<table border = 1 width = 100%>
<tr><td>
<strong>Personas dokuments</strong>
</td></tr>
</table>
<p align = "left">
<strong>Izsniedza kasieris</strong> _______________________________
</BODY>
</HTML>
