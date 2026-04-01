<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->



<%

dim conn
openconn


nopid = 0
pid=Request.QueryString("pid")
oid=Request.QueryString("oid")

if request.querystring("drukat") <> "1" then
 if pid<>"" then
 	
 	set r = conn.execute("select pieteikums.gid,grupa.veids from pieteikums,grupa where pieteikums.gid = grupa.id and pieteikums.id = " +cstr(pid))
	veidsID = getnum(r("veids"))
	gid = r("gid")
 	
 	pielikums = session("pielikums")
 	if veidsID = 6 then 
 		pielikums = "Kopleksais pasûtîjums nr. "+ cstr(gid) + " "+pielikums
 	end if
	r.close	
	
 else
 	pid = 0
 end if
 
 poga_var = session("poga")
 if poga_var = "Reìistrçt" then
 	incordnum conn
 	'pid jau gatavs
 	if session("parsk") = 1 then
 		NoPid = 0
 		Pid = 0
 		if session("NoPid")<>"" then NoPid = session("NoPid")
 		if session("UzPid")<>"" then Pid = session("UzPid")
 		num = 0
 	else
 		Num = session("num")
 	end if
 	datums = session("datums")
 	kas = session("kas")
 	pielikums = session("pielikums")
 	pamatojums = session("pamatojums")
 	debets = session("debets")
 	kredits = session("kredits")
 	resurss = session("resurss")
 	resurss_uz = session("resurss_uz")
 	dala_no = session("dala_no")
 	dala_uz = session("dala_uz")
 	rekins = getnum(session("rekins"))
 	rekins_gads = getnum(session("rekins_gads"))
 	rekins_pazime = session("rekins_pazime")
 	zils = session("zils")
	
 	set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
	valnos = rValuta("val")
	
 	if rekins <> 0 then
 	 pamatojums = pamatojums + " Rek.nr."+cstr(rekins)
 	end if
 	summaval = session("summa")
 	'sheit vajadzeetu buut arii atlaidei saglabaatai mainiigajaa, varbuut arii summa jaapaarreekjina atkariibaa no taas
 	valuta = session("valuta")
 	if debets = "2.6.2.5" then num = "0" '
 	if len(debets)>7 then
 	 if mid(debets,1,7) = "2.6.1.2" then num = "0"
 	end if
 	set kur = server.createobject("ADODB.Recordset")
 	Set kur = conn.execute("select * from valutakurss where valuta = "+session("valuta")+" AND datums = '" + sqldateYMD(session("datums"))+"'")

	defvalID = CStr(DefaultValutaIDD(session("datums")))

	if session("valuta") <>defvalID then
 		if kur.eof  then
 			session("message") = "Nav norâdîts valûtas kurss.(1)"
 			response.redirect "valuta.asp"
 		end if
 		kurss = kur("kurss2")
 		summa = summaval/kurss
 	else
 		summa = summaval
 	end if
	
 	kur.close
 	summaLVL = 0
 	summaUSD = 0
 	summaEUR = 0

	defval = CStr(DefaultValutaD(session("datums")))

 	if session("parvalutu") = "EUR" then
 	  summaEUR = summa
 	end if

 	if session("parvalutu") = "USD" then
 	 set rValuta = conn.execute("select * from valuta where id = "+cstr(session("valuta")))
 	 if rValuta("val") = "USD" then
 	  summaUSD = summaval
 	 else
 	  set rUSDKurss = conn.execute("select * from valutakurss where valuta = 68 AND datums = '" + sqldateYMD(session("datums"))+"'")
 	  if rUSDkurss.EOF then
 	   session("Message") = "Nav norâdîts valûtas kurss.(3)"
 	   response.redirect "valuta.asp"
 	  end if
 	  summaUSD = summa*rUSDKurss("kurss2")
 	 end if
 	end if

 	summa = round100(summa)
 	summaLVL = round100(summaLVL)
 	summaUSD = round100(summaUSD)
 	summaEUR = round100(summaEUR)
 	
	
 	if session("parsk") = 1 then
 	
 	 if session("valuta") = 68 then
 	  nosummaUSD = summaval
 	  nosummaLVL = 0
 	  nosummaEUR = 0
	  str_valuta = "USD"
 	 elseif session("valuta") = 49 then
 	  nosummaUSD = 0
 	  nosummaLVL = 0
 	  nosummaEUR = summaval
  	  str_valuta = "EUR"
 	 else
 	  nosummaUSD = 0
 	  nosummaEUR = 0
 	  nosummaLVL = summaval
  	  str_valuta = "LVL"
 	 end if
 	 
 	else
 	 nosummaUSD = summaUSD
 	 nosummaLVL = summaLVL
 	 nosummaEUR = summaEUR
 	end if



 	'pârbaudam vai debets un kredîts ir ar punktiem
 	
 	kredits = EnsureDots(kredits)
 	debets = EnsureDots(debets)

	maks_veids = maksajuma_veids(kredits)
	If maks_veids = "" Then maks_veids = maksajuma_veids(debets)

 	if zils = "" then zils = "0"
 	
 	'---------------------------------------------------------------------------------------
 	izm = summaval
		
		if nosummaEUR<>0 then 
			izm = nosummaEUR
		else if nosummaUSD<>0 then 
				izm = nosummaUSD
			end if
		end if
				
			
		
		set gv = conn.execute("select grupa.veids, marsruts.v from pieteikums " + _
		" join grupa on pieteikums.gid = grupa.id " + _
		" join marsruts on grupa.[mid] = marsruts.id " + _
		" where pieteikums.id = " +cstr(nopid))
		gveids = getnum(gv("veids"))
		gnos = getnum(gv("v"))
		
		ir_parada_grupa = 0
		if instr(gnos,"!Par") = 1 then
			ir_parada_grupa = 1
		end if
		

		'atljauj paarskaitiit ja ir grupas veids 7 (paraadi u.c)

		done = 0
		' apstrâdâjam pârskaitîjumus
		If session("parsk") = 1  and ir_parada_grupa = 0 Then


			pIemaksas = piet_iemaksas3(NoPid,0,str_valuta) '--- iegust apstiprinaato iemaksu summu 
			pIzmaksas = piet_izmaksas3(NoPid,0,str_valuta)
			'pIemaksas = piet_iemaksas2(NoPid,0,0) '--- iegust apstiprinaato iemaksu summu 
			'pIzmaksas = piet_izmaksas(NoPid)
			'Response.write "-> " &pIemaksas&" / "&pIzmaksas&" / "&izm
			'Response.end
			
			If (ccur(pIemaksas - pIzmaksas) < ccur(izm) or izm <= 0) Then

				if Session("parsk_tips") = "uz" then
					session("parsk") = "uz"
					vpid = session("UzPid")
				else if Session("parsk_tips") = "no" then
						session("parsk") = "no"
						vpid = session("NoPid")
					end if
				end if
					
				session("message") = "Izmaksât norâdîto summu nav iespçjams. Iemaksas:" &nullprint(pIemaksas)&" / Izmaksas:"&nullprint(pIzmaksas)&" / Maksâjums:"&nullprint(izm)&"/"&nullprint(str_valuta)
				'15.46 / 0 / 22
				response.redirect "operacija.asp?pid="+nullprint(vpid)+"&did="+nullprint(session("did"))			
				done = 1
			End if
		End if

		If done = 0 then 	
			if session("qstring_pid") <> request.querystring("pid") then 
				response.write "Neparedzeta kluda, nesakrit ordera pid."
				response.end
			end if
 			'---------------
 			Set rID = conn.execute ("SET NOCOUNT ON; insert into orderis (pid,nopid,num,kas,kas2,pielikums,pielikums2,pamatojums,pamatojums2,datums,summa,summaval,summausd,summalvl,summaeur,nosummausd,nosummalvl,nosummaeur,kredits,debets,resurss,resurss_uz,valuta,need_check,dala_no,dala_uz,rekins,rekins_gads,rekins_pazime,zils,maks_veids) values ("+cstr(pid)+","+cstr(nopid)+","+cstr(num)+",N'"+kas+"','"+encode(kas)+"',N'"+pielikums+"','"+encode(pielikums)+"',N'"+pamatojums+"','"+Encode(pamatojums)+"','"+sqldateYMD(datums)+"',"+cstr(summa)+","+cstr(summaval)+","+cstr(summausd)+","+cstr(summalvl)+","+cstr(summaeur)+","+cstr(nosummausd)+","+cstr(nosummalvl)+","+cstr(nosummaeur)+",'"+kredits+"','"+debets+"','"+resurss+"','"+resurss_uz+"',"+cstr(valuta)+",1,"+dala_no+","+dala_uz+","+cstr(rekins)+","+CStr(rekins_gads)+",'"+rekins_pazime+"',"+zils+",'"+maks_veids+"'); SELECT @@IDENTITY AS 'Identity'")
			'Set rID = conn.execute("SELECT @@IDENTITY AS 'Identity'")

 			if session("parsk") = 1 then
 				if session("UzPid") <> "" then pieteikums_recalculate(session("UzPid"))
 				if session("NoPid") <> "" then pieteikums_recalculate(session("NoPid"))
 			else
 				pieteikums_recalculate(pid)
 			end if
 	
 			'set rID = conn.execute("select max(id) from orderis")
 			LogInsertAction "orderis", rID("Identity")
 			session("message") = "Orderis reìistrçts " + CStr(rID("Identity"))
 		
 		end if
 		
 end if

 if session("parsk") = 1 then
 	session("parsk") = 0
 	response.redirect("pieteikums.asp?pid="+cstr(session("LastPid")))
 end if

else

	oid = request.querystring("oid")
	set ord = conn.execute("select * from orderis where id = " + cstr(oid))
	session("num") = ord("num")
	session("datums") = ord("datums")
	session("kas") = ord("kas")
	session("pielikums") = ord("pielikums")
	session("pamatojums") = ord("pamatojums")
	session("summa") = ord("summaval")
	session("valuta") = ord("valuta")
end if
%>

<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<META NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080">
<%' <font color=RED> Resurss</font>%>
<table border = "0" width = 100%>
<tr><td>
	<table border = "1" width = 100%>
	<tr><td><font size="3"><br>SIA "IMPRO CEÏOJUMI"<p></font></td></tr>
	</table>
</td><td align = "rigth">
<strong>Kvîts</strong><br>
<strong>Nr.</strong> <%=session("num")%>
</tr></table>
<p>
<table width = 100%>
<tr>
<td>
<strong>Reìistrâcijas #</strong><br>
</td>
<td>
40003235627<br>
</td>
<td>
<strong>PVN maks. reg. Nr.</strong>
</td>

<td>
LV40003235627
</td></tr>

<tr>
<td><strong>Datums</strong></td>
<td><%=DatePrint(session("datums"))%></td>

<td></td>
<td></td>
</tr>
</table>

<p>

<table border = "1" width = 100%>
<tr><td>
	<table width = 100%><tr>
	<td colspan=4>
	<% 
	valuta = id_field("valuta",session("valuta"),"val") 
	%>
	<strong>Summa</strong>
	
	<%
	'EUR pârjas papildfunkcija, attçlo otro valûtu
	response.write CurrPrint(session("summa")) + " " + valuta
	%>

	</td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Saòemts no</strong></td>
	<td><%=session("kas")%></td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pamatojums<strong></td>
	<td><%=pamatojums%></td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pielikums</strong></td>
	<td><%=pielikums%></td>
	</tr></table>
</td></tr>
</table>
<table width="100%" border="0">
	<tr><td width = "350">
	<table border="1">
		<tr><td>
		<strong>Summa vârdiem</strong><br>
		<%
		if session("summa")<>"" then
			response.write nauda(session("summa"),id_field("valuta",session("valuta"),"val"))
		end if
		%>
		<p></tr></td>
	</table>
	</td>

	<td align="left">
	<strong>Galvenais grâmatvedis<p>Kasieris</td></strong>
	</tr>
</table>
<p>
<hr>
<p>
<table border = "0" width = 100%>
<tr><td>
	<table border = "1" width = 100%>
	<tr><td><font size="3"><br> SIA "IMPRO CEÏOJUMI"<p></font></td></tr>
	</table>
</td><td align = "rigth">
<strong>Kvîts</strong><br>
<strong>Nr.</strong> <%=session("num")%>
</tr></table>
<p>
<table width = 100%>
<tr>
<td>
<strong>Reìistrâcijas #</strong><br>
</td>
<td>
40003235627<br>
</td>
<td>
<strong>PVN maks. reg. Nr.</strong>
</td>

<td>
LV40003235627
</td></tr>

<tr>
<td><strong>Datums</strong></td>
<td><%=session("datums")%></td>

<td></td>
<td></td>
</tr>
</table>

<p>

<table border = "1" width = 100%>
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
	<table width = 100%><tr>
	<td width=25%><strong>Saòemts no</strong></td>
	<td><%=session("kas")%></td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pamatojums<strong></td>
	<td><%=session("pamatojums")%></td>
	</tr></table>
</td></tr>
<tr><td>
	<table width = 100%><tr>
	<td width=25%><strong>Pielikums</strong></td>
	<td><%=pielikums%></td>
	</tr></table>
</td></tr>
</table>
<table width="100%" border="0">
	<tr><td width = "350">
	<table border="1">
		<tr><td>
		<strong>Summa vârdiem</strong><br>
		<%
		if session("summa")<>"" then
			response.write nauda(session("summa"),valuta)
		end if
		%>
		<p></tr></td>
	</table>
	</td>

	<td align="left">
	<strong>Galvenais grâmatvedis<p>Kasieris</td></strong>
	</tr>
</table>

<p>
<br><br><br><br><br>
<center><p>Uzmanîbu!</p>
<p>Naudas atmaksa iespçjama, tikai iesniedzot iemaksas èeku.</p>
<p><b>SAGLABÂJIET IEMAKSAS ÈEKUS LÎDZ CEÏOJUMA BEIGÂM!</b></p>
</BODY>
</HTML>

<%
sub incordnum(connection_p)
conn.execute("update ordnum set ordnum = ordnum + 1")
end sub

Function EnsureDots(s)
 EnsureDots = s
 if s<>"" then
  if instr(s,".")=0 then
   EnsureDots = ""
   for i = 1 to len (s)
    EnsureDots = EnsureDots + mid(s,i,1) + "."
   next
   EnsureDots = mid(EnsureDots,1,len(EnsureDots)-1)
  end if
 end if
end Function


%>
