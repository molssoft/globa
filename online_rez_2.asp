<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

Dim db, query, result, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, cel_datums_no, cel_datums_lidz, gr_kods, rez_id
Dim summaLVL, summaUSD, summaEUR
Dim bilanceLVL, bilanceUSD, bilanceEUR
Dim num, pietbilance, pietsumma

Dim conn
openconn

summa = 0
whereC = ""
summaLVL = 0
summaUSD = 0 
summaEUR = 0 
bilanceLVL = 0
bilanceUSD = 0 
bilanceEUR = 0 
personas = 0

cel_datums_no = ""
cel_datums_lidz = ""

num = 0 'skaititajs
pietbilance = 0  
pietsumma = 0

Set db = new cls_db
Set s_post = secured.s_POST()
Set s_get = secured.s_GET()


if s_get.count > 0 and s_get("delete_rez_id") <> "" then
	ssql = "Update online_rez SET tika_lidz_bankai=0 WHERE id="+cstr(s_get("delete_rez_id"))
	'rw ssql
	conn.execute(ssql)
end if

if s_get.count > 0 and s_get("rez_id") <> "" then
	rez_id =s_get("rez_id")
	datums_no=""
	datums_lidz=""


else If s_post.count > 0 Then

	datums_no = replace(s_post("datums_no"),"/",".")
	datums_lidz = replace(s_post("datums_lidz"),"/",".")
	cel_datums_no = replace(s_post("cel_datums_no"),"/",".")
	cel_datums_lidz = replace(s_post("cel_datums_lidz"),"/",".")
	rez_id = s_post("rez_id")
	gr_kods = s_post("gr_kods")
	gr_veids = s_post("gr_veids")

else
	datums_no = dateprint(date-30)
	datums_lidz = dateprint(date)
end if
end if

	
	If gr_veids = "kipra_carter" Then
		whereC = " and isnull(g.carter, 0) = 1 "
	End if

	If gr_kods <> "" Then
		whereC = " and g.kods like'%"&gr_kods&"%' "
	End if
	
	If datums_no <> "" Then
		whereC = whereC + " and p.datums >= "&InputSQLDate(datums_no)&" "
	End If
	
	If datums_lidz <> "" Then
		whereC = whereC + " and p.datums < DATEADD(d, 1, "&InputSQLDate(datums_lidz)&") "
	End If

	If cel_datums_no <> "" Then
		whereC = whereC + " and g.sakuma_dat >= "&InputSQLDate(cel_datums_no)&" "
	End If
	
	If cel_datums_lidz <> "" Then
		whereC = whereC + " and g.sakuma_dat < DATEADD(d, 1, "&InputSQLDate(cel_datums_lidz)&") "
	End If

	If rez_id <> "" Then
		whereC = whereC + " and orez.id = "&rez_id&" "
	End if


'response.write("from "&datums_no&" to "&datums_lidz&"<br />")
'18.12.2019 papildinâjums ar dalibn joinu, par cik ne visiem izveidojâs profili (dk pirkðana bez reìistrâcijas)

	query ="SET ARITHABORT ON; select isnull(orez.no_delete,0) as no_delete,isnull(orez.dk_attelota,0) as dk_attelota,isnull(orez.tika_lidz_bankai,0) as tika_lidz_bankai,orez.deleted,sakuma_dat,orez.id, max(p.datums) as datums, g.kods, m.v, d.vards, d.uzvards, count(p.personas) as dalibnieki, " + _ 
	"sum(p.summaLVL) as summaLVL, sum(p.summaUSD) as summaUSD, sum(p.summaEUR) as summaEUR, " + _ 
	"sum(p.bilanceLVL) as bilanceLVL,sum(p.bilanceUSD) as bilanceUSD,sum(p.bilanceEUR) as bilanceEUR, " + _ 
	"orez.ligums_id, p.atlaidesLVL, " + _
	"STUFF((SELECT DISTINCT '<br>' + destination " & _
        "       FROM swedbank_trans " & _
        "       WHERE rez_id = orez.id and destination IS NOT NULL " & _
        "       FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 4, '') AS dest " & _
	"from online_rez orez " + _ 
	"inner join pieteikums p on p.online_rez = orez.id " + _ 
	"inner join profili pr on pr.id = orez.profile_id " + _ 
	"inner join dalibn d on d.pk1=pr.pk1 and d.pk2=pr.pk2 "+_ 
	"inner join grupa g on g.id = p.gid " + _
	"inner join marsruts m on m.id = g.mid " + _
	"where ((orez.deleted = 0 and p.deleted = 0 and p.tmp = 0 and (p.step = '4' or orez.no_delete=1)) or (orez.deleted=1 and isnull(orez.tika_lidz_bankai,0)=1) or (isnull(orez.no_delete,0) = 1 and isnull(dk_attelota,0)=1)) and p.internets = 1 " + whereC + _ 
	"group by orez.no_delete,orez.dk_attelota, orez.tika_lidz_bankai, orez.deleted,sakuma_dat, orez.id, g.kods, m.v, orez.ligums_id, d.vards, d.uzvards, p.atlaidesLVL " + _
	"order by p.datums DESC"

''response.write(query)

Set result = db.Conn.execute(query)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Online rezervâcijas</title>
<link rel="stylesheet" href="online_rez/css/default.css" type="text/css"/>
</head>

<body>
<div id="main_area">
	<div id="main_area_center">
	
<div id="impro_header">
	Online rezervâciju pârskats
</div>

<center>

<!-- Meklçðanas forma -->
<form name="filtrs" method="post">
<table cellpadding="5">
	<tr>
		<td>Rezervâcijas datums no:</td><td><input type="text" name="datums_no" size="8" maxlength="10" value="<%=datums_no%>" /></td>
		<td>lîdz:</td><td><input type="text" name="datums_lidz" size="8" maxlength="10" value="<%=datums_lidz%>" /></td>
	</tr>	
	<tr>
		<td>Ceïojuma datums no:</td><td><input type="text" name="cel_datums_no" size="8" maxlength="10" value="<%=cel_datums_no%>" /></td>
		<td>lîdz:</td><td><input type="text" name="cel_datums_lidz" size="8" maxlength="10" value="<%=cel_datums_lidz%>" /></td>
	</tr>	
	<tr>
		<td>Grupas kods:</td><td colspan="3" align="left"><input type="text" name="gr_kods" size="14" maxlength="14" value="<%=gr_kods%>" /></td>
	</tr>
	<tr>
		<td>Rezervâcijas id:</td><td colspan="3" align="left"><input type="text" name="rez_id" size="10" maxlength="10" value="<%=rez_id%>" /></td>
	</tr>	
	<tr>
		<td>Grupas veids:</td><td colspan="3" align="left">
			<select name="gr_veids" width="150" style="width: 150px">
				<option value=""></option>
				<option value="kipra_carter" <% If gr_veids="kipra_carter" Then Response.write "selected" %> >Kipras èarteri</option>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center"><input type="submit" name="submit" value="Meklçt" /></td>
	</tr>
</table>
</form>

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
<a href="default.asp">Atgriezties uz Globu</a>

<table class="form_table">
	<tr>
		<th>Num</th>
		<th>Rez Id</th>
		<th>Datums</th>
		<th>Rezervçja</th>
		<th>Grupas kods</th>
		<th>Ceïojums</th>
		<th>Dalîbnieki</th>					
		<th>Summa</th>
		<th>Bilance</th>
		<th>Banka</th>
		<th>Lîgums</th>
	</tr>
	
	<% While Not result.eof 
	
			num = num + 1
			
			pietsumma = Curr3Print(result("summaLVL")-result("atlaidesLVL"),result("summaUSD"),result("summaEUR"))
			pietbilance = Curr3Print(result("bilanceLVL"),result("bilanceUSD"),result("bilanceEUR"))		
		
			'CurrPrint(summaLVL)
			style = ""
		if (result("deleted")="1" and result("tika_lidz_bankai")) or (result("no_delete") = 1 and result("dk_attelota")=1) then style="style='color:red'" end if
		%>
			
			<tr >
				<td <%=style%>><%=num%> </td>
				<td <%=style%>><% if result("deleted")="0" then%><a href="online_rez_2_details.asp?id=<%=result("id")%>">
				<% end if %><%=result("id")%></a></td>			
				<td <%=style%>><%=DatePrint(result("datums"))%></td>
				<td <%=style%>><a href="user_tracking.asp?rez_id=<%=result("id")%>" ><%Response.write(result("vards")&" "&result("uzvards"))%></a></td>
				<td <%=style%>><%=result("kods")%></td>
				<td <%=style%>><%=result("sakuma_dat")%> - <%=result("v")%>&nbsp;</td>
				<td <%=style%>><%=result("dalibnieki")%></td>
				<td <%=style%>><%=pietsumma%></td>
				<td <%=style%>><%=pietbilance%></td>
				<td><%=result("dest")%>&nbsp;</td>
				<td <%=style%>>
				<% if result("deleted")="1" and  result("tika_lidz_bankai") Then
				%>
				 <image src="impro/bildes/dzest.jpg" title="Dzçst" onclick="if (confirm('Dzçst?')){window.location = '?delete_rez_id=<%=result("id")%>';}"/>
				 <%else
					if result("ligums_id")<>"" then%>
							<a href="download_pdf.asp?rez_id=<%=result("id")%>" target="_blank">Atvçrt</a>
					<% Else
						''ja nav online liguma, dazreiz gadas ka ir izveidots globas ligums
						Set rligums = conn.execute("select * from pieteikums where online_rez = "+CStr(result("id")))
						If Not rligums.eof Then
							%><a href="download_pdf.asp?rez_id=<%=result("id")%>" target="_blank">Atvçrt (G)</a><%
						Else
							%>
								<a href="http://www.impro.lv/online/print_ligums_repair.php?rez_id=<%=result("id")%>" target=repairligums ><span style="color:red">Izveidot</span></a>
							<% 						
						End if
					   end if 
					 end if%>
				</td>

			</tr>
			<% 	
			summaLVL = summaLVL + secured.getFloat(result("summaLVL"))
			summaUSD = summaUSD + secured.getFloat(result("summaUSD"))
			summaEUR = summaEUR + secured.getFloat(result("summaEUR"))
			
			bilanceLVL = bilanceLVL + secured.getFloat(result("bilanceLVL"))
			bilanceUSD = bilanceUSD + secured.getFloat(result("bilanceUSD"))
			bilanceEUR = bilanceEUR + secured.getFloat(result("bilanceEUR"))	
			
			personas = personas + result("dalibnieki")	
			
			result.movenext	
		Wend 
		%>
	<tr>
		<td colspan="6" align="right">Kopâ:</td>
		<td><%=personas%></td>
		<td><%=Curr3Print(summaLVL,summaUSD,summaEUR)%>&nbsp;</td>
		<td><%=Curr3Print(bilanceLVL,bilanceUSD,bilanceEUR)%>&nbsp;</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr><td colspan="11">&nbsp;</td></tr>
	<tr><td colspan="11" class="center"><a href="default.asp">Atgriezties uz Globu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->