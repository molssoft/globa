<!-- #include File ="online_rez\inc\header.asp" -->
<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include File ="procs.inc" -->

<%

Dim db, query, result, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, gr_kods, grupa_id, parbaude
Dim summaLVL, summaEUR, cnt
dim rez_id, maks_veids, o_debets, r_val

summa = 0
whereC = ""
summaLVL = 0
cnt = 0



Set db = new cls_db
Set s_post = secured.s_POST()

If s_post.count > 0 Then

	datums_no = s_post("datums_no")
	datums_lidz = s_post("datums_lidz")
	rez_id = s_post("rez_id")
	gr_kods = s_post("gr_kods")
	parbaude = s_post("parbaude")
	maks_veids = s_post("maks_veids")

	'response.write("from "&datums_no&" lîdz "&datums_lidz&"<br />")

	If maks_veids <> "" Then
			
			Set r_val = db.conn.Execute("SELECT id, bankas_konts, mkartes_konts FROM valuta WHERE val = 'EUR'")
			
			if maks_veids = "mk" then
				o_debets = "2.6.2.5.1" 'r_val("mkartes_konts")
			elseif maks_veids = "swedbank" then 
				o_debets = "2.6.2.4.5" 'r_val("bankas_konts")			
			elseif maks_veids = "dnb" then
				o_debets = "2.6.2.2.1"
			elseif maks_veids = "seb" then
				o_debets = "2.6.2.6.1" 
			elseif maks_veids = "citadele" then
				o_debets = "2.6.2.1.2" '"2.6.2.1.1" 
			end if
		whereC = " and o.debets ='"&o_debets&"'"
	End if
	
	If gr_kods <> "" Then
		whereC = " and g.kods like'%"&gr_kods&"%'"
	End if

	If datums_no <> "" Then
		If IsDate(datums_no) Then
			whereC = whereC + " and o.datums >= "&InputSQLDate(datums_no)&" "
		Else
			response.write("Nepareizs datums no")
		End if
	End If
	
	If datums_lidz <> "" Then
		If IsDate(datums_lidz) Then
			whereC = whereC + " and o.datums <= "&InputSQLDate(datums_lidz)&" "
		Else
			response.write("Nepareizs datums lîdz")
		End if
	End If

	If rez_id <> "" Then
		whereC = whereC + " and p.online_rez = "&rez_id&" "
	End if
	
	If parbaude <> "" Then
		whereC = whereC + " and o.parbaude = "&parbaude&" "
	end if
else
	if datums_no = "" then

		'datums_no = date_ddmmyy(date()-30)
		'23-04-2019 RT samazinâm uz 7 dienâm, lai âtrâk ielâdçjâs:
		datums_no = date_ddmmyy(date()-7)

		whereC = whereC + " and o.datums >= "&InputSQLDate(datums_no)&" "

	end if
End If


query = "Select g.id as gid, p.profile_id, p.online_rez, g.sakuma_dat, d.id as did, d.vards+' '+d.uzvards as dalibnieks, o.parbaude as apst, o.*, v.val, t.trans_id from orderis o left join grupa g on o.resurss = g.kods left join valuta v on v.id = o.valuta left join dalibn d on d.id = o.dalib left join pieteikums p on p.id = o.pid left join trans_uid t on t.o_id = o.id Where p.deleted=0 and p.tmp = 0 and (p.step = '4' or p.online_rez in (select id FROM online_rez WHERE no_delete=1)) and p.atcelts = 0 and o.deleted=0 and isnull(p.online_rez, 0)<>0 and isnull(o.resurss,'') <> '' "&whereC&" order by o.datums, p.online_rez, g.id"
'--- 5.feb 2013 pievienots nosacijums -> and isnull(o.resurss,'') <> ''
'--- parskaitijumam resurss ir tukss. parskaitijums izveidots globaa, tapec online maksajumos tam nav japaradas.

''response.write(query)
Set result = db.Conn.execute(query)

%>
<div id="impro_header">
	Online maksâjumu transakcijas
</div>

<center>

<!-- Meklçðanas forma -->
<form name="filtrs" method="post">
<table cellpadding="5">
	<tr>
		<td>Datums no:</td><td><input type="text" name="datums_no" size="10" maxlength="10" value="<%=datums_no%>" /></td>
		<td>lîdz:</td><td><input type="text" name="datums_lidz" size="10" maxlength="10" value="<%=datums_lidz%>"/></td>
	</tr>	
	<tr>
		<td>Grupas kods:</td><td colspan="3"><input type="text" name="gr_kods" size="14" maxlength="14" /></td>
	</tr>
	<tr>
		<td>Rezervâcijas id:</td><td colspan="3"  align="left"><input type="text" name="rez_id" size="10" maxlength="10" value="<%=rez_id%>" /></td>
	</tr>
	<tr>
		<td align="right" bgcolor="#ffc1cc">Apstiprinâtâs:</td>
		<td align="left" bgcolor="#fff1cc" colspan="3">
			<select name="parbaude">
				<option value="" ></option>
			    <option value="0" <% if parbaude="0" then Response.Write("selected")%>>Apstiprinâtâs</option>
				<option value="1" <% if parbaude="1" then Response.Write("selected")%>>Neapstiprinâtâs</option>
			</select> 
		</td>
	</tr>	
	<tr>
		<td align="right" bgcolor="#ffc1cc">Maks. veids:</td>
		<td align="left" bgcolor="#fff1cc" colspan="3">
			<select name="maks_veids">
				<option value="" >visi</option>
			    <option value="swedbank" <% if maks_veids="swedbank" then Response.Write("selected")%>>Swedbank</option>
				<option value="dnb" <% if maks_veids="dnb" then Response.Write("selected")%>>DNB banka</option>
				<option value="seb" <% if maks_veids="seb" then Response.Write("selected")%>>SEB banka</option>
				<option value="citadele" <% if maks_veids="citadele" then Response.Write("selected")%>>Citadele banka</option>
				<option value="mk" <% if maks_veids="mk" then Response.Write("selected")%>>Maks. karte</option>
			</select> 
		</td>
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
<a href="default.asp">Atgriezties uz Globu</a>

<table class="form_table">
	
	
	
	<tr>
		<th>Npk</th>
		<th>Num</th>
		<th>Datums</th>
		<th>Maksâtâjs</th>
		<th>Pid</th>
		<th>Grupas kods</th>
		<th>Sâk. datums</th>				
		<th>Dalîbnieks</th>
		<th>Bilance</th>
		<th>Iemaksa</th>
		<th>Apstiprinât</th>
		<th>Rezervâcija</th>

	</tr>
	
	<% While Not result.eof 

		cnt	= cnt + 1
		summaLVL = 	result("summaLVL")
		summaEUR = 	result("summaEUR")
		%>
		<tr>
			<td><%=cnt%></td>
			<td><a href="ordedit.asp?oid=<%=result("id")%>" target="_blank"><%=result("id")%></a></td>
			<td><%=DatePrint(result("datums"))%></td>
			<td><a href="dalibn.asp?i=<%=result("did")%>" target="_blank"><%=result("kas")%></a></td>
			<td><a href="pieteikums.asp?pid=<%=result("pid")%>" target="_blank"><%=result("pid")%></a></td>
			<td><%=result("resurss")%></td>
			<td><%=DatePrint(result("sakuma_dat"))%></td>
			<td><%=result("dalibnieks")%>&nbsp;</td>
			<td><%=Curr3Print(summaLVL,0,summaEUR)%></td>
			<td><%=CurrPrint(result("summaval"))%>&nbsp;<%=result("val")%></td>
			<td class="center">
				<%if result("apst")=true then%>
					<a href="orderu_apst_2_2.asp?rez_id=<%=result("online_rez")%>&trans_uid=<%=result("trans_id")%>" >
						<img border=0 src="images/dolars.jpg">
					</a>
				<%end if%>
			</td>
			<td><%=result("online_rez")%></td>
		</tr>
		<% 	summa = summa + secured.getFloat(result("summaEUR"))
		result.movenext	
		Wend 
		%>
	<tr>
		<td colspan="7">&nbsp;</td>
		<td>Kopâ:</td>
		<td><%=CurrPrint(summa)%>&nbsp;</td>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr><td colspan="12">&nbsp;</td></tr>
	<tr><td colspan="12" class="center"><a href="default.asp">Atgriezties uz Globu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->