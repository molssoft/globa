<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
Dim query, rez_id
Dim summaLVL, summaUSD, summaEUR
Dim bilanceLVL, bilanceUSD, bilanceEUR

summaLVL = 0
summaUSD = 0 
summaEUR = 0 
bilanceLVL = 0
bilanceUSD = 0 
bilanceEUR = 0 

Dim conn
openconn

rez_id = Request.QueryString("id")

if rez_id = "" then 
	Response.Write("Nav norâdîts rezervâcijas id")
	Response.End
end if

query ="select distinct p.id, p.gid, p.datums, p.profile_id, d.id as did,  d.vards+' '+d.uzvards as dalibnieks, g.kods, m.v, " + _ 
"p.summaLVL, p.summaUSD, p.summaEUR, p.bilanceLVL, p.bilanceUSD, p.bilanceEUR, p.atlaidesLVL, p.profile_id, orez.ligums_id " + _ 
"from pieteikums p " + _
"inner join piet_saite ps on ps.pid = p.id " + _
"inner join dalibn d on d.id = ps.did " + _
"inner join grupa g on g.id = p.gid " + _
"inner join marsruts m on m.id = g.mid " + _
"inner join online_rez orez on orez.id = p.online_rez " + _
"where p.deleted=0 and p.tmp=0 and (p.step='4' or orez.no_delete=1) and p.internets = 1 and p.online_rez = " + rez_id + " " + _  
"order by p.datums, p.id"

'response.write(query)

Set result = conn.execute(query)

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
	Online rezervâcija Nr. <%=rez_id%>
</div>

<center>


<form name="frm_orderu_apst">

<table class="form_table">
	<tr>
		<th>Num</th>
		<th>Pid</th>
		<th>Datums</th>
		<th>Dalibnieks</th>
		<th>Grupas kods</th>
		<th>Ceïojums</th>				
		<th>Summa</th>
		<th>Bilance</th>
	</tr>
	
	<% While Not result.eof 
	
		num = num + 1
		
		pietsumma = Curr3Print(result("summaLVL")-result("atlaidesLVL"),result("summaUSD"),result("summaEUR"))
		pietbilance = Curr3Print(result("bilanceLVL"),result("bilanceUSD"),result("bilanceEUR"))		
		
		%>
		<tr>
			<td><%=num%></td>
			<td><a href="pieteikums.asp?pid=<%=result("id")%>"><%=result("id")%></a></td>			
			<td><%=dateprint(result("datums"))%></td>
			<td><a href="dalibn.asp?i=<%=result("did")%>" target="_blank"><%=result("dalibnieks")%></a></td>
			<td><%=result("kods")%></td>
			<td><%=result("v")%>&nbsp;</td>
			<td><%=pietsumma%></td>
			<td><%=pietbilance%></td>
		</tr>
		<% 	
		summaLVL = summaLVL + result("summaLVL")-result("atlaidesLVL")
		summaUSD = summaUSD + result("summaUSD")
		summaEUR = summaEUR + result("summaEUR")

			bilanceLVL = bilanceLVL + result("bilanceLVL")
			bilanceUSD = bilanceUSD + result("bilanceUSD")
			bilanceEUR = bilanceEUR + result("bilanceEUR")	
			
		result.movenext	
		Wend 
		%>
	<tr>
		<td colspan="5">&nbsp;</td>
		<td align="right">Kopâ:</td>
		<td><%=Curr3Print(summaLVL,summaUSD,summaEUR)%>&nbsp;</td>
		<td><%=Curr3Print(bilanceLVL,bilanceUSD,bilanceEUR)%>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="11" align="right">
					<% result.movefirst
					
					if isnull(result("ligums_id"))=false then%>
							<a href="download_pdf.asp?rez_id=<%=rez_id%>" target="_blank">Izdrukât lîgumu</a>
					<% else %>
							Lîgums vçl nav parakstîts
					<% end if %>	
		</td>
	</tr>
	<tr><td colspan="11" class="center"><a href="online_rez_2.asp">Atgriezties uz sarakstu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->