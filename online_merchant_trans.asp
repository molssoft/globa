<!-- #include File ="online_rez\inc\header.asp" -->
<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include File ="procs.inc" -->

<%

Dim db, query, r_1, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, gr_kods, grupa_id, parbaude
Dim summaLVL, cnt
dim rez_id, deleted
dim r_id, r_amount, r_description, r_result, r_response, r_datums, r_trans_uid, r_deleted, r_rez_id

summa = 0
whereC = ""
summaLVL = 0
cnt = 0

datums_no = date_ddmmyy(Date()-7) '--- default atlases periods
whereC = " and datums > '"&SQLDate(Date()-7)&"' " '--- default atlases periods

'Response.Write datums_no&"<br>"

Set db = new cls_db
Set s_post = secured.s_POST()

If s_post.count > 0 Then

	whereC = ""
	datums_no = s_post("datums_no")
	datums_lidz = s_post("datums_lidz")
	rez_id = s_post("rez_id")
	deleted = s_post("deleted")

	'response.write("from "&datums_no&" lîdz "&datums_lidz&"<br />")
	
	If datums_no <> "" Then
		If IsDate(datums_no) Then
			whereC = whereC + " and datums >= "&left(InputSQLDate(datums_no),len(InputSQLDate(datums_no))-1)&" 00:00:00' "
		Else
			response.write("Nepareizs datums no")
		End if
	End If
	
	If datums_lidz <> "" Then
		If IsDate(datums_lidz) Then
			whereC = whereC + " and datums <= "&left(InputSQLDate(datums_lidz),len(InputSQLDate(datums_lidz))-1)&" 23:59:00' "
		Else
			response.write("Nepareizs datums lîdz")
		End if
	End If

	If rez_id <> "" Then
		whereC = whereC + " and rez_id = "&rez_id&" "
	End if
	
	If deleted <> "" Then
		whereC = whereC + " and deleted = "&deleted&" "
	end if

End If

'--- atlasa transakcijas saakot ar 1 decembri 2012
query = "select * from merchant_log where 1=1 "&whereC&" order by id"

'response.write(query)
Set r_1 = db.Conn.execute(query)

%>
<div id="impro_header">
	Online transakcijas ar maksâjumu kartçm
</div>

<center>

<!-- Meklçðanas forma -->
<form name="filtrs" method="post">
<table cellpadding="5">
	<tr>
		<td>Datums no:</td><td><input type="text" name="datums_no" value="<%=datums_no%>" size="10" maxlength="10"  /></td>
		<td>lîdz:</td><td><input type="text" name="datums_lidz" value="<%=datums_lidz%>" size="10" maxlength="10" />&nbsp;dd/mm/yyyy</td>
	</tr>	
	<tr>
		<td>Rezervâcijas id:</td><td colspan="3"  align="left"><input type="text" name="rez_id" size="10" maxlength="10" value="<%=rez_id%>" /></td>
	</tr>
	<tr>
		<td align="right" bgcolor="#ffc1cc">Statuss</td>
		<td align="left" bgcolor="#fff1cc" colspan="3">
			<select name="deleted">
				<option value="" ></option>
			    <option value="0" <% if deleted="0" then Response.Write("selected")%>>Aktuâli</option>
				<option value="1" <% if deleted="1" then Response.Write("selected")%>>Dzçsti</option>
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

If r_1.eof then

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
		<th>ID</th>
		<th>Rezervâcijas nr.</th>
		<th>Summa</th>
		<th>Apraksts</th>
		<th>Rezultâts</th>
		<th>Rezultâta atðifrçjums</th>
		<th>Datums</th>				
		<th>Transakcijas nr.</th>
		<th>Statuss</th>
		
	</tr>
	
	<% 
	'Response.Write "->"&r_1("deleted")
	
	r_1.moveFirst
	
	While Not r_1.eof 
		
		r_description = r_1("description")
		r_result = r_1("result")
		r_deleted = r_1("deleted")
		r_response = r_1("response")
		r_rez_id = r_1("rez_id")
		r_id = r_1("id")
		r_amount = currprint(secured.getFloat(r_1("amount")/100))
		r_datums = secured.DateTimePrint(r_1("datums"))
		r_trans_uid = r_1("trans_uid")
		
		
		
		'cnt	= cnt + 1
		'summaLVL = 	result("summaLVL")

		%>
		<tr>
			<td><%=r_id%></td>
			<td><%if r_deleted=0 then%><a href="online_rez_2_details.asp?id=<%=r_rez_id%>" target="_blank"><%=r_rez_id%></a>
			<%else
				Response.Write r_rez_id
			end if%>
			</td>
			<td><%=r_amount%></td>
			<td><%=r_description%></td>
			<td><%=r_result%></td>
			<td><%=r_response%></td>
			<td><%=r_datums%></td>
			<td><%=r_trans_uid%></td>
			<td><%=r_deleted%></td>
			
		</tr>
		<% 	'summa = summa + secured.getFloat(result("summaLVL"))
		r_1.movenext	
		Wend 
		%>
	<tr><td colspan="12">&nbsp;</td></tr>
	<tr><td colspan="12" class="center"><a href="default.asp">Atgriezties uz Globu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->