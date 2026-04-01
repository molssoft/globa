<!-- #include File ="online_rez\inc\header.asp" -->
<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include File ="procs.inc" -->

<%

Dim db, query, result, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, gr_kods, grupa_id, profils_id
Dim summaLVL
Dim num, pietbilance, pietsumma

summa = 0
whereC = ""
summaLVL = 0
num = 0 'skaititajs
pietbilance = 0  
pietsumma = 0

Set db = new cls_db
Set s_post = secured.s_POST()

If s_post.count > 0 Then

	datums_no = replace(s_post("datums_no"),".","/")
	datums_lidz = replace(s_post("datums_lidz"),".","/")
	grupa_id = s_post("grupa_id")
	profils_id = s_post("profils_id")
	gr_kods = s_post("gr_kods")

	If gr_kods <> "" Then
		whereC = " and g.kods like'%"&gr_kods&"%' "
	End if
	
	If datums_no <> "" Then
		If IsDate(datums_no) Then
			whereC = whereC + " and p.datums >= "&InputSQLDate(datums_no)&" "
		Else
			response.write("Nepareizs 'Datums no' (dd/mm/yy)")
		End if
	End If
	
	If datums_lidz <> "" Then
		If IsDate(datums_lidz) Then
			whereC = whereC + " and p.datums < DATEADD(d, 1, "&InputSQLDate(datums_lidz)&") "
		Else
			response.write("Nepareizs 'Datums lîdz' (dd/mm/yy)")
		End if
	End If

	If grupa_id <> "" Then
		whereC = whereC + " and g.id = "&grupa_id&" "
	End if

	If profils_id <> "" Then
		whereC = whereC + " and p.profile_id = "&profils_id&" "
	End if

else

	'if datums_lidz="" then
	'	datums_lidz = date_ddmmyy(date())
	'end if

End If

'response.write("from "&datums_no&" to "&datums_lidz&"<br />")
	

query ="select distinct p.id, p.gid, p.datums, p.profile_id, d.vards+' '+d.uzvards as dalibnieks, g.kods, m.v, " + _ 
"p.summaLVL, p.summaUSD, p.summaEUR, p.bilanceLVL, p.bilanceUSD, p.bilanceEUR, p.profile_id " + _ 
"from pieteikums p " + _
"inner join piet_saite ps on ps.pid = p.id " + _
"inner join dalibn d on d.id = ps.did " + _
"inner join grupa g on g.id = p.gid " + _
"inner join marsruts m on m.id = g.mid " + _
"where p.deleted=0 and p.tmp=0 and p.step='4' and p.internets = 1 and isnull(p.profile_id, 0)<>0 and ps.deleted=0 " + _  
whereC + "order by p.datums, p.profile_id, p.gid"

'response.write(query)

Set result = db.Conn.execute(query)

%>
<div id="impro_header">
	Online rezervâciju pârskats
</div>

<center>

<!-- Meklçðanas forma -->
<form name="filtrs" method="post">
<table cellpadding="5">
	<tr>
		<td>Datums no:</td><td><input type="text" name="datums_no" size="8" maxlength="8" value="<%=datums_no%>" /></td>
		<td>lîdz:</td><td><input type="text" name="datums_lidz" size="8" maxlength="8" value="<%=datums_lidz%>" /></td>
	</tr>	
	<tr>
		<td>Grupas kods:</td><td colspan="3"><input type="text" name="gr_kods" size="14" maxlength="14" value="<%=gr_kods%>" /></td>
	</tr>
	<tr>
		<td>Profila id:</td><td><input type="text" name="profils_id" size="10" maxlength="10" value="<%=profils_id%>" /></td>
		<td>Grupas id:</td><td><input type="text" name="grupa_id" size="10" maxlength="10" value="<%=grupa_id%>" /></td>
	</tr>	
	<tr>
		<td colspan="4" align="center"><input type="submit" name="submit" value="Meklçt" /></td>
	</tr>
</table>
</form>
<!---->
<%

If result.eof then

	if s_post.count > 0 Then

		response.write("Nekas nav atrasts.")
		
	end if
	
	response.write("<br><br><a href='default.asp'>Atgriezties uz Globu</a>")
	response.End
	
End if

%>
<form name="frm_orderu_apst">

<table class="form_table">
	<tr>
		<th>Num</th>
		<th>Pid</th>
		<th>Datums</th>
		<th>Dalibnieks</th>
		<th>Grupas kods</th>
		<th>Celojums</th>				
		<th>Summa</th>
		<th>Bilance</th>
		<th>Lîgums</th>
	</tr>
	
	<% While Not result.eof 
	
		num = num + 1
		summaLVL = 	result("summaLVL")
		
		pietsumma = Curr3Print(result("summaLVL"),result("summaUSD"),result("summaEUR"))
		pietbilance = Curr3Print(result("bilanceLVL"),result("bilanceUSD"),result("bilanceEUR"))		
		
		'CurrPrint(summaLVL)
		
		%>
		<tr>
			<td><%=num%></td>
			<td><a href="pieteikums.asp?pid=<%=result("id")%>"><%=result("id")%></a></td>			
			<td><%=secured.DatePrint(result("datums"))%></td>
			<td><%=result("dalibnieks")%></td>
			<td><%=result("kods")%></td>
			<td><%=result("v")%>&nbsp;</td>
			<td><%=pietsumma%></td>
			<td><%=pietbilance%></td>
			<td><a href="download_pdf.asp?gid=<%=result("gid")%>&profile_id=<%=result("profile_id")%>" target="_blank"><% response.write("profils="&result("profile_id")&"; grupa="&result("gid")) %></a></td>

		</tr>
		<% 	summa = summa + secured.getFloat(result("summaLVL"))
		result.movenext	
		Wend 
		%>
	<tr>
		<td colspan="5">&nbsp;</td>
		<td align="right">Kopâ:</td>
		<td><%=CurrPrint(summa)%>&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr><td colspan="11">&nbsp;</td></tr>
	<tr><td colspan="11" class="center"><a href="default.asp">Atgriezties uz Globu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->