<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%



'lîgums tikko ìenerçts, uzreiz parsûtam uz PDF
if request("generated")="1" Then
	Response.redirect "download_pdf.asp?id="+request("id")
	Response.end
End If

dim conn
openconn

'lîguma parakstîðanas poga nospiesta

if cstr(request("subm")) = "2"  then
	'rw "subm is 2"
	dim ligumi,pos,lid,name,val,val_str,val_arr,gid,piet_id
	
	for each item in request.form()
		' response.write(InStr(item,"_"))
		if (item = "gid") then
			gid = request.form(item)
			
		else
			pos = InStr(item,"_") + 1
			
			'rw pos
			ligumi = Split(item,"_")
			name = ligumi(0)
			
			if (name="parakstit") then
				lid = Mid(item,pos)
				val_str = request.form(item)
				val_arr = split(val_str,",")
				val = val_arr(0)
				
				if (val <> 0) then
					'rw "parakstit"
					ssql = "SELECT DISTINCT id FROM ligumi WHERE id = "+cstr(lid)+" and deleted=0 AND isnull(parakstits,0)<>1"
					set parakstitie = conn.execute(ssql) 
					if (not parakstitie.eof) then
						ssql = "UPDATE ligumi SET parakstits = 1,parakstits_date = getdate() WHERE id="+cstr(lid)+""
						'response.write ssql
						conn.Execute(ssql)
						ssql = "SELECT id FROm pieteikums WHERE ligums_id="+cstr(lid)+""
						'rw ssql
						set piet = conn.execute(ssql)
						while (not piet.eof)
							piet_id = piet("id")
							'rw (piet_id)
							LogAction "pieteikums",piet_id,"Parakstîts lîgums"
							piet.movenext
						wend
					end if
					
				else 
					'rw "nevajadzes"
					ssql = "SELECT DISTINCT id FROM ligumi WHERE id = "+cstr(lid)+" and deleted=0 AND isnull(parakstits,0)<>0"
					set neparakstitie = conn.execute(ssql) 
					if (not neparakstitie.eof) then
						ssql = "UPDATE ligumi SET parakstits = 0,parakstits_date = getdate() WHERE id="+cstr(lid)+""
						'response.write ssql
						conn.Execute(ssql)
						ssql = "SELECT id FROm pieteikums WHERE ligums_id="+cstr(lid)+""
						'rw ssql
						set piet = conn.execute(ssql)
						
						while (not piet.eof)
							piet_id = piet("id")
							'rw (piet_id)
							LogAction "pieteikums",piet_id,"Lîgums nav parakstîts"
							piet.movenext
						wend
					end if
				
				end if
			end if
	
			if (name="nosutits") then
				lid = Mid(item,pos)
				val_str = request.form(item)
				val_arr = split(val_str,",")
				val = val_arr(0)
				
				if (val <> 0) then
					'rw "parakstit"
					ssql = "SELECT DISTINCT id FROM ligumi WHERE id = "+cstr(lid)+" and deleted=0 AND isnull(nosutits,0)<>1"
					set parakstitie = conn.execute(ssql) 
					if (not parakstitie.eof) then
						ssql = "UPDATE ligumi SET nosutits = 1,nosutits_date = getdate() WHERE id="+cstr(lid)+""
						'response.write ssql
						conn.Execute(ssql)
						ssql = "SELECT id FROm pieteikums WHERE ligums_id="+cstr(lid)+""
						'rw ssql
						set piet = conn.execute(ssql)
						while (not piet.eof)
							piet_id = piet("id")
							'rw (piet_id)
							LogAction "pieteikums",piet_id,"Nosûtîts lîgums"
							piet.movenext
						wend
					end if
					
				else 
					'rw "nevajadzes"
					ssql = "SELECT DISTINCT id FROM ligumi WHERE id = "+cstr(lid)+" and deleted=0 AND isnull(nosutits,0)<>0"
					set neparakstitie = conn.execute(ssql) 
					if (not neparakstitie.eof) then
						ssql = "UPDATE ligumi SET nosutits = 0,nosutits_date = getdate() WHERE id="+cstr(lid)+""
						'response.write ssql
						conn.Execute(ssql)
						ssql = "SELECT id FROm pieteikums WHERE ligums_id="+cstr(lid)+""
						'rw ssql
						set piet = conn.execute(ssql)
						
						while (not piet.eof)
							piet_id = piet("id")
							'rw (piet_id)
							LogAction "pieteikums",piet_id,"Lîgums nav nosûtîts"
							piet.movenext
						wend
					end if
				
				end if
			end if
		end if
		
       ' Response.Write("<p>" & item & ": " & request.form(item) & " lid: " & lid &" val_arr(0):" & val & "</p>")
    next

	
	session("message") = "Izmaiòas saglabâtas"
	
	response.redirect "pieteikumi_grupaa.asp?gid="+cstr(gid)+"&mode=ligums"
	response.end
	
end if
	
%>



<% 	docstart "Lîgums","y1.jpg"  %>
<!-- #include file = "cls_rezervacijas.inc.asp" -->

<style>
table.ligums {width:100%;border:none;}
table.ligums tr td {
	white-space:nowrap;
	text-align:left;
	border:1px solid grey;
	border-spacing:0;
	border-collapse:collapse;
	padding: 5;
}
table.cel_nos{width:100%;border:1px solid grey;}
table.cel_nos tr td {white-space:nowrap;text-align:left;border:none;}
</style>
<%







Set res = new cls_rezervacijas

'' sanem sarakstu ar pieteikuma id kuriem javeido ligums
if request("ligums").count > 0 then
	
	pids_str = request("ligums")
	
	'pids=split(pids_str,",")
	'For i=LBound(pids) to UBound(pids)
		'Response.Write pids(i) + "<br>"
	' Next 
	
	Set summary = res.get_current_reservation(pids_str)
	
	' Dim liguma_teksts, hash, rez_id
	
	'--- HTML ----
	%>
	<center><p><a href="pieteikumi_grupaa.asp?gid=<%=summary("gid")%>&mode=ligums"><font color="GREEN" size="5"><b><%=summary("celojums")&" "&DatePrint(summary("datums"))&" - "&DatePrint(summary("beigu_datums"))%></b></font></a></p>
	<% headlinks %>
	<hr>
	<div id="profils_data_area">
		<form id="ligums_form" name="frm_celojums_ligums" method="POST" target="_pdf">
			
			<input type="hidden" name="accepted" value="1">
			<input type="hidden" name="test_tic" value="0">
			<input type="hidden" name="pids" value="<%=pids_str%>">
			
						
					Lîgums vçl nav izveidots<BR><BR>

					<a href="pieteikumi_grupaa.asp?gid=<%=summary("gid")%>&mode=ligums">Atcelt&nbsp;</a>
					<a href="#" onclick="ligums_form.submit();return false;">&nbsp;Izveidot</a>
					<BR><BR><BR>
		</form>
	</div>
	<%
	
end if

'' registre ka ligums ir akceptets
if request("accepted")=1 then
	
	pids = request("pids")


	
	'pârbauda, vai ir piesaistîta bazes cena un summa nav 0
	ssql = "SELECT * FROM grupa where id=(SELECT DISTINCT gid from pieteikums where id in ("&pids&"))"
	'ja grupa ir vâktâ un nav ar kajîtçm
	set grupa=conn.execute(ssql)
	Dim bazes_cena_required
	gid=0
	bazes_cena_required=0
	if not grupa.eof then
		if (grupa("veids") = "1") then
			gid = grupa("ID")
			'pârbauda, vai ir kajîtes
			
			set kajites = conn.execute("SELECT * FROM kajites_veidi WHERE gid="+cstr(gid))
			'ja kajiisu nav- jabuut bazes cenai
			 
			if kajites.eof then				
				bazes_cena_required = 1			
			end if
		
		end if
	end if

	set pieteikumi = conn.execute("SELECT * FROM pieteikums WHERE id in ("&pids&")")
	if not pieteikumi.eof then
		while not pieteikumi.eof
			pid = cstr(pieteikumi("id"))
			if pieteikumi("summaEUR") = "0" then
			
				response.write("<font color='red'>Lîgumu nevar izveidot. Pieteikuma #"+cstr(pid)+" summa ir 0.00EUR. <a href='pieteikums.asp?pid="+cstr(pid)+"'>Uz pieteikumu</a></font>")
				response.end
			end if
			'pârbauda, vai ir piesaistîta bâzes cena
			rw bazes_cena_required
			if (bazes_cena_required <> 0) then
				ssql = "SELECT * FROm piet_saite WHERE vietas_veids IN (SELECT id FROM vietu_veidi WHERE tips='C' and gid="+cstr(gid)+") AND deleted=0 and pid="+cstr(pid)+""
				'rw ssql
				set piet_bazes_cena = conn.execute(ssql)
				if piet_bazes_cena.eof then
					response.write("<font color='red'>Lîgumu nevar izveidot. Pieteikumam #"+cstr(pid)+" nav pievienota bâzes cena. <a href='pieteikums.asp?pid="+cstr(pid)+"'>Uz pieteikumu</a></font>")
					response.end
				end if
			end if
			
			pieteikumi.movenext
		wend
	end if

		''for i=lbound(pid_arr) to ubound(pid_arr)
		''	response.write pid_arr(i)
		''next 
		''response.end

	Set summary = res.get_current_reservation(pids)

	ligums_id = res.save_ligums("skatît pdf", summary("gid"))  
	'Response.Write ligums_id&" "&pids
	

	
	if clng(ligums_id)>0 and pids<>"" and request("test_tic")<>"1" then
		pid_arr = Split(pids,",")
		
		
		ssql = "UPDATE pieteikums SET ligums_id = "&ligums_id&" WHERE id in ("&pids&") and deleted=0"
		conn.Execute(ssql)
		For Each pid In pid_arr
		  LogAction "pieteikums",pid,"Izveidots lîgums"
		Next
		
		
		'--- create pdf (php)
		%>
		<form name="php_post" action="https://www.impro.lv/php/ligums.php" method="post">
			<input type="hidden" name="ligums_id" value="<%=ligums_id%>" >
		</form>
		<script>
			document.php_post.submit();
		</script>
		<%
		
	end if

end if

if request("id")<>"" then


	'--- atver esoðu lîgumu
	lid = request("id")
	
	'--- uzzina liguma veidu un vai ir izdrukâts
	query = "SELECT printed, rez_id, accepted_date FROM ligumi WHERE id = '"&lid&"'"
	SET result = Conn.Execute(query)
	
	if not result.eof then

		'--- parbaudam vai ligums saturs ir saglabats datubazee
		query = "SELECT id from ligumi where id = "+CStr(lid)+ "/* and (not bpdf is null or isnull(file_name,'')<>'') */"
'		response.write(query)
		Set satursok = conn.execute(query)
		If satursok.eof Then
			%>
			<form name="php_post" action="http://www.impro.lv/php/ligums.php" method="post">
				<input type="hidden" name="ligums_id" value="<%=lid%>" >
			</form>
			<script>
				document.php_post.submit();
			</script>
			<%
			Response.end
		End if
		
		if isnull(result("rez_id")) then
			printed = result("printed")	
			online_rez = false
		else
			online_rez = true
		end if
		accepted_date = result("accepted_date")
	else
		Response.Write("Kïûda. Lîgums nav atrasts.")
		Response.end
	end if
	
	'-----------------------
	
	pids = get_pids(lid)

	Set summary = res.get_current_reservation(pids)

	'liguma_teksts = ImproLigums(pids) 
	

	'--- HTML ----
	%>
	<center><p><a href="pieteikumi_grupaa.asp?gid=<%=summary("gid")%>&mode=ligums"><font color="GREEN" size="5"><b><%=summary("celojums")&" "&DatePrint(summary("datums"))&" - "&DatePrint(summary("beigu_datums"))%></b></font></a></p>
	<% headlinks %>
	<hr>
	<div id="profils_data_area">
		<form id="ligums_form" name="frm_celojums_ligums" method="POST">
			<input type="hidden" name="printed" value="1">
			<table class="form_table" border=1 >
				<tr>
					<%if online_rez then%>
						<td align="center">
							Online rezervâcijas lîgums
						</td>
						<td align="right">
							<a href="download_pdf.asp?id=<%=lid%>" target="_blank">Atvçrt</a>
						</td>
					<%else
						if printed then%>
							<td align="center">
								Lîgums ir jau izdrukâts!
							</td>
							<td align="right">
								<a href="download_pdf.asp?id=<%=lid%>" target="_blank">Atvçrt</a>
							</td>
						<%else%>
							<td align="center">
								Lîgums nav izdrukâts!
							</td>
							<td align="right">
								<a href="download_pdf.asp?id=<%=lid%>" target="_blank">Izdrukât</a>
							</td>
						<%end if
					end if
					%>
					
				</tr>
				<tr>
					<td class="center" colspan="2" style="text-align:justify;">
						<%=replace(liguma_teksts, VbCrLf, "<br />")%>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<%
	
end if

function get_pids(ligums_id)

	'--- funkcija atgrieþ lîguma pieteikumu id numurus atdalitus ar komatiem.
	'--- tâlâk tos izmanto ImproLigums
	
	if ligums_id<>"" then
		
		Dim arrResultSet
		arrResultSet = Array()
		pids = ""
		
		'--- globaa izveidotiem liigumiem ligums_id glabajas tabula pieteikums
		'--- online rezervacijaam ligums_id glabajas tabula online_rez
		'--- sakumaa parbauda, kas ta ir par rezervaciju, un tad atlasa rezervacijas pids
		
		query = "SELECT cast(id as varchar) as id FROM pieteikums WHERE deleted = 0 and ligums_id = '"&ligums_id&"'"
		SET result = Conn.Execute(query)
		
		if result.eof then '---- online rez ligums
		
			query = "select cast(p.id as varchar) as id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
					"where r.ligums_id = '"&ligums_id&"' and r.deleted = 0 and p.deleted = 0"
			SET result = Conn.Execute(query)
			
		end if
		
		if result.eof then '---- vçl gadîjums kad lîgums ir tikai tabulâ online_rez
		
			query = "select cast(id as varchar 	) as id from pieteikums where online_rez in (select rez_id from ligumi where id = "+cstr(ligums_id)+")"
			SET result = Conn.Execute(query)
			
		end if
		
		while Not result.EOF 
				if pids = "" then
					pids = result("id")
				else
					pids = pids&","&result("id")
				end if
				
				result.movenext
		wend
		
		get_pids = pids
		
	else
		get_pids = ""	
	end if

end function

Function create_php_session(pids)

		dim query,result,db,datetime,ip,salt,hash
		datetime = FormatDateTime(Time())
		ip = Request.Servervariables("REMOTE_HOST")
		salt = "ms410a"

		randomize
		hash =  hex_sha1( salt & datetime & ip & Rnd)

		query = "INSERT INTO [globa].[dbo].[merchant_session] ([hash],[ip],[description],[timestamp]) VALUES ('" & hash &"','"&ip&"',"&pids&",GetDate())"
		
		SET result = Conn.Execute(query)
		
		create_php_session = hash
End Function

function getKurssEur(p_date)
		'--- p_date forataa dd/mm/yyyy

		set rEURKurss = conn.execute("select * from valutakurss where valuta = 49 AND datums = '" + sqldate(p_date)+"'")
 	    if rEURKurss.EOF then
 			getKurssEur = 0
 		else
 			getKurssEur = rEURKurss("kurss2")
 		end if	 
 		
end function
function getKurssUSD(p_date)
		'--- p_date forataa dd/mm/yyyy

		set rUSDKurss = conn.execute("select * from valutakurss where valuta = 68 AND datums = '" + sqldate(p_date)+"'")
 	    if rUSDKurss.EOF then
 			getKurssUSD = 0
 		else
 			getKurssUSD = rUSDKurss("kurss2")
 		end if	 
 		
end function

 Sub prArray(myArr)
     Dim key
     For Each key in myArr
         Response.Write  key +  "<br />"
     Next
 End Sub

Function in_array(element, arr)
    For i=0 To Ubound(arr) 
        If Trim(arr(i)) = Trim(element) Then 
            in_array = True
		
            Exit Function
        Else 
            in_array = False
        End If  
    Next 
End Function 

Function array_in_array(arr1, arr2)

    For i=0 To Ubound(arr1) 
        If in_array(arr1(i), arr2 ) Then 
            array_in_array = True
            Exit Function
        Else 
            array_in_array = False
        End If  
    Next 

End Function 
%>