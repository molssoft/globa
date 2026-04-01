<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<%
dim conn
openconn

'response.write(Server.ScriptTimeout)


Server.ScriptTimeout = 1800


'response.write(Server.ScriptTimeout)
'Response.End


if len(Request.form("skatit.x")) <> 0 and (Request.Form("sak_dat1") = "" and Request.Form("beigu_dat1") = "") then
 session("message") = "Jânorâda periods."
end if

docstart "Grupu ieòçmumu atskaite","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Grupu ieòçmumu atskaite</b></font><hr>
<%

headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='RED' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

grupa = getparameter("kompleks")
valuta = Request.Form("valuta")
%>

<form name="forma" action="atsk_grupu_ienemumi.asp" method="POST">
<table>
<tr>
	<td align="right" bgcolor="#ffc1cc">Grupas beigu datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="sak_dat1" value="<%=request.form("sak_dat1")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="beigu_dat1" value="<%=request.form("beigu_dat1")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Iemaksas uz datumu: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="iem_dat1" value="<%=request.form("iem_dat1")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Grupas kods: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="grupas_kods1" value="<%=request.form("grupas_kods1")%>"> 
	</td>
</tr>
</table>
<br />
<input type="hidden" name="skatit.x" value="1">
<input type="image" src="impro/bildes/skatit.jpg" name="skatit" WIDTH="116" HEIGHT="25">
<p>

<table>
	<tr>
		<td valign=top>
			<%PrintTable("1")%>
		</td>
	</tr>
</table>


</form>
</body>
</html>

<%

Sub PrintTable (num)

if Request.Form("sak_dat"+num) <> "" or Request.Form("beigu_dat"+num) <> "" then
	
	'Nosaka sakuma un beigu datumu
	sak_dat_exact = formateddate(Request.Form("sak_dat"+num),"dmy")
	beigu_dat_exact = formateddate(Request.Form("beigu_dat"+num),"dmy")
	
	if Request.Form("iem_dat"+num)<> "" Then
		iemaks_dat_exact = formateddate(Request.Form("iem_dat"+num),"dmy")
	End if
	'--- where datumi: atlases perioda uzdoshana ----------
	where_periods = "1=1 "
	where_kompl = "1=1 "
	
	if Request.Form("sak_dat"+num) <> "" then
		where_periods = where_periods + "and g.beigu_dat>='"+sqldate(sak_dat_exact)+"' "
		where_kompl = where_kompl + "and p.beigu_datums>='"+sqldate(sak_dat_exact)+"' "
	end if
	if Request.Form("beigu_dat"+num) <> "" then
		where_periods = where_periods + "and g.beigu_dat<='"+sqldate(beigu_dat_exact)+"' "
		where_kompl = where_kompl + "and p.beigu_datums<='"+sqldate(beigu_dat_exact)+"' "
	end if	
	if Request.Form("grupas_kods"+num) <> "" then
		where_periods = where_periods + "and g.kods like '"+Request.Form("grupas_kods"+num)+"%' "
		where_kompl = where_kompl + "and g.kods like '"+Request.Form("grupas_kods"+num)+"%' "
	end if	
	'if Request.Form("iem_dat"+num)<> "" Then
	'	if where_periods <> "" then
	'		where_periods = where_periods + "AND "
	'	end if
	'	where_periods = where_periods + "pieteikums.id in (select orderis.pid from orderis where orderis.pid=pieteikums.id and orderis.datums<='"+sqldate(iemaks_dat_exact)+"') "
	'end if
	'if where_periods = "" then where_periods = "1=1"
	
		if Request.Form("iem_dat"+num)<> "" Then
			iem_datums = " AND o.datums<='"+sqldate(iemaks_dat_exact)+"' "
		else
			iem_datums = ""
		end if
	'------------------------------------------------------

	ssql = "SELECT * FROM (" + _
			"(select g.id as gid, p.id as p_id, g.kods, o.pid, o.nopid, o.summaLVL, o.summaUSD, o.summaEUR from orderis o " + _
			"inner join pieteikums p on p.id = o.pid " + _
			"inner join grupa g on g.id = p.gid " + _
			"where ( (kods like 'I.PID' or kods like 'K.PID') and " + where_kompl + " or (" + where_periods + "))" + _
			"and p.deleted = 0 and p.id in (select pid from piet_saite where deleted = 0) and p.atcelts = 0 " + _ 
			"and o.deleted = 0 " + iem_datums + _ 
			") UNION ALL (" + _
			"select g.id as gid, p.id as p_id, g.kods, o.pid, o.nopid, o.summaLVL, o.summaUSD, o.summaEUR from orderis o " + _
			"inner join pieteikums p on p.id = o.nopid " + _
			"inner join grupa g on g.id = p.gid " + _
			"where ( (kods like 'I.PID' or kods like 'K.PID') and " + where_kompl + " or (" + where_periods + "))" + _
			"and p.deleted = 0 and p.id in (select pid from piet_saite where deleted = 0) and p.atcelts = 0 " + _ 
			"and o.deleted = 0 " + iem_datums + _
			")" + _
			") AS R order by R.kods, R.gid"


	'--- same query, slow version
	'ssql_1 = "select g.id as gid, p.id as p_id, g.kods, o.pid, o.nopid, o.summaLVL, o.summaUSD, o.summaEUR from orderis o " + _
	'		"inner join pieteikums p on p.id = o.pid or p.id = o.nopid " + _
	'		"inner join grupa g on g.id = p.gid " + _
	'		"where ( (kods like 'I.PID' or kods like 'K.PID') and " + where_kompl + " or " + where_periods + ")" + _
	'		"and p.deleted = 0 and p.id in (select pid from piet_saite where deleted = 0) and p.atcelts = 0 " + _ 
	'		"and o.deleted = 0 " + iem_datums + _ 
	'		"order by g.kods, p.id"			

			'"inner join piet_saite ps on ps.pid = p.id " + _
			'and (IsNull(p.piezimes,'') <> 'Pieteikums speciâli ballei')
			
	'response.write(ssql)
	'Response.end
	set r = conn.execute(ssql)
	
	
	%>
	<center>
	<div id="ieraksti_count">
	<%
	qc = r.recordcount
	if qc > 0 Then response.write Galotne(qc,"Atrasts","Atrasti")+ " "+cstr(qc)+ " "+Galotne(qc,"ieraksts","ieraksti")
	%>
	</div>
	<table >
	<tr bgcolor="#ffc1cc">
	<th>Nr.</th>
	<th>Grupas kods</th>
	<th>Pid</th>
	<th>Iemaksas </th>
	<th>Izmaksas </th>
	<th>Bilance</th>
	</tr>
	<% 

		i = 0
		sum_iemaksas_LVL = 0
		sum_izmaksas_LVL = 0
		sum_bilance_LVL = 0
		
		sum_iemaksas_USD = 0
		sum_izmaksas_USD = 0
		sum_bilance_USD = 0
		
		sum_iemaksas_EUR = 0
		sum_izmaksas_EUR = 0
		sum_bilance_EUR = 0
		
		curr_gid = 0
		old_gid = 0
		
		curr_ki_pid = 0 'kompleksie un individualie
		old_ki_pid = 0
					
		while Not r.EOF
		
		'--------------------------------------------------------------------
		
		curr_gid = r("gid")
		
		if r("kods")="K.PID" or r("kods")="I.PID" then
			curr_ki_pid = r("p_id")
		else
			curr_ki_pid = 0
		end if
		
		
		if old_gid <> curr_gid or curr_ki_pid <> old_ki_pid then
			

			i = i + 1
			'nosledz iepriekshejas grupas html tabulas rindu
			if getnum(old_gid) <> 0 or getnum(old_ki_pid) <> 0 then
				
				%>
					<td><%=Curr3Print2(ien_summaLVL,ien_summaUSD,ien_summaEUR)%></td>
					<td><%=Curr3Print2(izd_summaLVL,izd_summaUSD,izd_summaEUR)%></td>
					<td><%=Curr3Print2(0,0,0) %></td>
				</tr>				
				<%
				
				'--- skaita kopsummas ------------------------------------------------------

				sum_iemaksas_LVL = sum_iemaksas_LVL + getnum(ien_summaLVL)
				sum_izmaksas_LVL = sum_izmaksas_LVL + getnum(izd_summaLVL)
				sum_bilance_LVL = sum_bilance_LVL + getnum(0)

				sum_iemaksas_USD = sum_iemaksas_USD + getnum(ien_summaUSD)
				sum_izmaksas_USD = sum_izmaksas_USD + getnum(izd_summaUSD)
				sum_bilance_USD = sum_bilance_USD + getnum(0)
		
				sum_iemaksas_EUR = sum_iemaksas_EUR + getnum(ien_summaEUR)
				sum_izmaksas_EUR = sum_izmaksas_EUR + getnum(izd_summaEUR)
				sum_bilance_EUR = sum_bilance_EUR + getnum(0)

			end if

			ien_summaLVL = 0
			ien_summaUSD = 0
			ien_summaEUR = 0

			izd_summaLVL = 0
			izd_summaUSD = 0
			izd_summaEUR = 0
		
			old_gid = curr_gid
			old_ki_pid = curr_ki_pid
			
			'atver html rindu
			%>
			<tr bgcolor="#fff1cc">	
				<td><%=cstr(i)%>.</td>
				<td><a href="grupa_edit.asp?gid=<%=cstr(curr_gid)%>" target="_blank"><%=r("kods")%></a></td>
				<% if r("kods")="K.PID" or r("kods")="I.PID" then%>
					<td><a href="pieteikums.asp?pid=<%=cstr(curr_ki_pid)%>" target="_blank"><%=curr_ki_pid%></a></td>
				<% else %>
					<td>&nbsp;</td>				
				<% end if%>
			<%
			'skaita tekosas grupas iemaksas un izmaksas
		
    			if r("p_id") = r("pid") then
    				ien_summaLVL = ien_summaLVL + getnum(r("summaLVL"))
    				ien_summaUSD = ien_summaUSD + getnum(r("summaUSD"))
    				ien_summaEUR = ien_summaEUR + getnum(r("summaEUR"))
    			else
    				izd_summaLVL = izd_summaLVL + getnum(r("summaLVL"))
       				izd_summaUSD = izd_summaUSD + getnum(r("summaUSD"))
    				izd_summaEUR = izd_summaEUR + getnum(r("summaEUR"))
    			end if
    			
		else
		'skaita tekosas grupas iemaksas un izmaksas
		
    			if r("p_id") = r("pid") then
    				ien_summaLVL = ien_summaLVL + getnum(r("summaLVL"))
    				ien_summaUSD = ien_summaUSD + getnum(r("summaUSD"))
    				ien_summaEUR = ien_summaEUR + getnum(r("summaEUR"))
    			else
    				izd_summaLVL = izd_summaLVL + getnum(r("summaLVL"))
       				izd_summaUSD = izd_summaUSD + getnum(r("summaUSD"))
    				izd_summaEUR = izd_summaEUR + getnum(r("summaEUR"))
    			end if
    			
	
			
		end if
			
		r.MoveNext
	Wend
	
	'nosledz pedejo rindu	
	if getnum(old_gid) <> 0 then
				%>
					<td><%=Curr3Print2(ien_summaLVL,ien_summaUSD,ien_summaEUR)%></td>
					<td><%=Curr3Print2(izd_summaLVL,izd_summaUSD,izd_summaEUR)%></td>
					<td><%=Curr3Print2(0,0,0) %></td>
				</tr>				
				<%
				'--- skaita kopsummas ------------------------------------------------------

				sum_iemaksas_LVL = sum_iemaksas_LVL + getnum(ien_summaLVL)
				sum_izmaksas_LVL = sum_izmaksas_LVL + getnum(izd_summaLVL)
				sum_bilance_LVL = sum_bilance_LVL + getnum(0)

				sum_iemaksas_USD = sum_iemaksas_USD + getnum(ien_summaUSD)
				sum_izmaksas_USD = sum_izmaksas_USD + getnum(izd_summaUSD)
				sum_bilance_USD = sum_bilance_USD + getnum(0)
		
				sum_iemaksas_EUR = sum_iemaksas_EUR + getnum(ien_summaEUR)
				sum_izmaksas_EUR = sum_izmaksas_EUR + getnum(izd_summaEUR)
				sum_bilance_EUR = sum_bilance_EUR + getnum(0)				
	end if
			
	%>
	<tr bgcolor="#ffc1cc">
	<td>&nbsp;</td><td>&nbsp;</td>
	<td align="right">Kopâ:</td>
	<td><%=Curr3Print2(sum_iemaksas_LVL,sum_iemaksas_USD,sum_iemaksas_EUR)%></td>
	<td><%=Curr3Print2(sum_izmaksas_LVL,sum_izmaksas_USD,sum_izmaksas_EUR)%></td>
	<td><%=Curr3Print2(sum_bilance_LVL,sum_bilance_USD,sum_bilance_EUR)%></td>
	</tr>
	</table>
	<%
	if i>0 and i<>qc Then
		%>
		<script>
			document.getElementById("ieraksti_count").innerHTML = "<%response.write Galotne(i,"Atrasts","Atrasti")+ " "+cstr(i)+ " "+Galotne(i,"ieraksts","ieraksti")%>";
		</script>
		<%
	End if
	%>
		
<%
end if 

End Sub
%>