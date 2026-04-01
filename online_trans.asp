<!-- #include File ="online_rez\inc\header.asp" -->
<!-- #include File ="online_rez\inc\connect.asp" -->
<!-- #include File ="online_rez\inc\secure.asp" -->
<!-- #include File ="procs.inc" -->

<%

Dim db, query, result, summa
Dim s_post, whereC
Dim datums_no, datums_lidz, gr_kods, grupa_id, parbaude
Dim summaLVL, cnt
dim rez_id, completed

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
	completed = s_post("completed")

	'response.write("from "&datums_no&" lîdz "&datums_lidz&"<br />")
	
	If datums_no <> "" Then
		If IsDate(datums_no) Then
			whereC = whereC + " and t.datums >= "&left(InputSQLDate(datums_no),len(InputSQLDate(datums_no))-1)&" 00:00:00' "
		Else
			response.write("Nepareizs datums no")
		End if
	End If
	
	If datums_lidz <> "" Then
		If IsDate(datums_lidz) Then
			whereC = whereC + " and t.datums <= "&left(InputSQLDate(datums_lidz),len(InputSQLDate(datums_lidz))-1)&" 23:59:00' "
		Else
			response.write("Nepareizs datums lîdz")
		End if
	End If

	If rez_id <> "" Then
		whereC = whereC + " and t.rez_id = "&rez_id&" "
	End if
	
	If completed <> "" Then
		whereC = whereC + " and t.completed = "&completed&" "
	end if

End If


query = "select t.* from trans_uid t left join orderis o on o.id = t.o_id where 1=1 "&whereC&" order by t.id"

'response.write(query)
Set result = db.Conn.execute(query)

%>
<div id="impro_header">
	Online dalîto maksâjumu transakcijas
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
			<select name="completed">
				<option value="" ></option>
			    <option value="1" <% if completed="1" then Response.Write("selected")%>>Izpildîts</option>
				<option value="0" <% if completed="0" then Response.Write("selected")%>>Neizpildîts</option>
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
		<th>ID</th>
		<th>transakcijas nr.</th>
		<th>rezervacijas nr.</th>
		<th>pieteikuma ID</th>
		<th>summa</th>
		<th>datums</th>
		<th>statuss</th>				
		<th>ordera ID</th>
	</tr>
	
	<% While Not result.eof 

		'cnt	= cnt + 1
		'summaLVL = 	result("summaLVL")
		
		completed = result("completed")
		if completed=true then
			completed = "Izpildîts"
		else
			completed = "-" '"Neizpildîts"
		end if
		
		%>
		<tr>
			<td><%=result("id")%></td>
			<td><%=result("trans_id")%></td>
			
			<td><a href="online_rez_2_details.asp?id=<%=result("rez_id")%>" target="_blank"><%=result("rez_id")%></a></td>
			<td><a href="pieteikums.asp?pid=<%=result("pid")%>" target="_blank"><%=result("pid")%></a></td>
			<td><%=CurrPrint(result("summa"))%></td>
			<td><%=secured.DatePrint(result("datums"))%></td>
			<td><%=completed%></td>
			<td><a href="ordedit.asp?oid=<%=result("o_id")%>" target="_blank"><%=result("o_id")%></a></td>
		</tr>
		<% 	'summa = summa + secured.getFloat(result("summaLVL"))
		result.movenext	
		Wend 
		%>
	<tr><td colspan="12">&nbsp;</td></tr>
	<tr><td colspan="12" class="center"><a href="default.asp">Atgriezties uz Globu</a></td></tr>

</table>
</center>
</form>
<!-- #include File = "online_rez\inc\footer.asp" -->