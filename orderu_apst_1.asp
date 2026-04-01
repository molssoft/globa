<!-- #include File ="online_rez\inc\header.asp" -->
<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include File ="procs.inc" -->

<%

Dim db, query, result, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, gr_kods, grupa_id, profils_id, parbaude
Dim summaLVL, cnt

summa = 0
whereC = ""
summaLVL = 0
cnt = 0

Set db = new cls_db
Set s_post = secured.s_POST()

If s_post.count > 0 Then

	datums_no = s_post("datums_no")
	datums_lidz = s_post("datums_lidz")
	grupa_id = s_post("grupa_id")
	profils_id = s_post("profils_id")
	gr_kods = s_post("gr_kods")
	parbaude = s_post("parbaude")

	'response.write("from "&datums_no&" lîdz "&datums_lidz&"<br />")

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

	If grupa_id <> "" Then
		whereC = whereC + " and g.id = "&grupa_id&" "
	End if

	If profils_id <> "" Then
		whereC = whereC + " and p.profile_id = "&profils_id&" "
	End if
	
	If parbaude <> "" Then
		whereC = whereC + " and o.parbaude = "&parbaude&" "
	end if

End If


query = "Select g.id as gid, p.profile_id, g.sakuma_dat, d.vards+' '+d.uzvards as dalibnieks, o.parbaude as apst, o.*, v.val from orderis o left join grupa g on o.resurss = g.kods left join valuta v on v.id = o.valuta left join dalibn d on d.id = o.dalib left join pieteikums p on p.id = o.pid Where p.deleted=0 and p.tmp = 0 and p.step = '4' and p.atcelts = 0 and o.deleted=0 and isnull(p.profile_id, 0)<>0 "&whereC&" order by o.datums, p.profile_id, g.id"

'response.write(query)
Set result = db.Conn.execute(query)

%>
<div id="impro_header">
	Online maksâjumu apstiprinâðana
</div>

<center>

<!-- Meklçðanas forma -->
<form name="filtrs" method="post">
<table cellpadding="5">
	<tr>
		<td>Datums no:</td><td><input type="text" name="datums_no" size="8" maxlength="8" /></td>
		<td>lîdz:</td><td><input type="text" name="datums_lidz" size="8" maxlength="8" /></td>
	</tr>	
	<tr>
		<td>Grupas kods:</td><td colspan="3"><input type="text" name="gr_kods" size="14" maxlength="14" /></td>
	</tr>
	<tr>
		<td>Profila id:</td><td><input type="text" name="profils_id" size="10" maxlength="10" /></td>
		<td>Grupas id:</td><td><input type="text" name="grupa_id" size="10" maxlength="10" /></td>
	</tr>	
	<tr>
		<td align="right" bgcolor="#ffc1cc">Apstiprinâtâs</td>
		<td align="left" bgcolor="#fff1cc" colspan="3">
			<select name="parbaude">
				<option value="" ></option>
			    <option value="0" <% if parbaude="0" then Response.Write("selected")%>>Apstiprinâtâs</option>
				<option value="1" <% if parbaude="1" then Response.Write("selected")%>>Neapstiprinâtâs</option>
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
		<th>Summa</th>
		<th>Valûta</th>
		<th>Apstiprinât</th>
		<th>Rezervâcija</th>

	</tr>
	
	<% While Not result.eof 

		cnt	= cnt + 1
		summaLVL = 	result("summaLVL")
		%>
		<tr>
			<td><%=cnt%></td>
			<td><%=result("id")%></td>
			<td><%=secured.DatePrint(result("datums"))%></td>
			<td><%=result("kas")%></td>
			<td><%=result("pid")%></td>
			<td><%=result("resurss")%></td>
			<td><%=secured.DatePrint(result("sakuma_dat"))%></td>
			<td><%=result("dalibnieks")%>&nbsp;</td>
			<td><%=CurrPrint(summaLVL)%></td>
			<td><%=result("val")%></td>
			<td class="center">
				<%if result("apst")=true then%>
					<a href="orderu_apst_2.asp?gid=<%=result("gid")%>&profile_id=<%=result("profile_id")%>" >
						<img border=0 src="images/dolars.jpg">
					</a>
				<%end if%>
			</td>
			<td><% response.write("profils="&result("profile_id")&"; grupa="&result("gid")) %></td>
		</tr>
		<% 	summa = summa + secured.getFloat(result("summaLVL"))
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