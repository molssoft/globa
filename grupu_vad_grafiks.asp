<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
title="Grupu vadîtâju grafiks"
docstart title,"y1.jpg" %>
<center><font color="GREEN" size="5"><b>Grupu vadîtâju grafiks</b></font>

<%
headlinks 
%><br>
<br>
<center>
<% 
datums = request.querystring("datums")
if (datums <> "") then
	tmp = Split(datums,"_",2)
	y = tmp(0)
	m = tmp(1)
end if
if (m = "") then m = Month(now()) end if
if (y = "") then y = Year(now()) end if

datums = cstr(y)+"_"+cstr(m)

daysInMonth = Day(DateSerial(y, m + 1, 0))
%>
<form id="gr_vad_grafiks_form" method="get">
	<select id="sel_menesis" name="datums" >
	<% curr_date = Now() 
	for i=1 to 12
		y_curr = Year(curr_date)
		m_curr = Month(curr_date)
   
	%>
		<option value="<%=y_curr%>_<%=m_curr%>" <% if datums = cstr(y_curr)+"_"+cstr(m_curr) then rw "selected" %>  ><%=y_curr%>.gada <%=Menesis(m_curr)%></option>
		<%
		curr_date = DateAdd("m",1,curr_date)
	next
	%>
	</select>	
</form>
<table>
	<tr>
		<th style="width:200px"></th>
		<%

		Set vals=Server.CreateObject("Scripting.Dictionary")
			for d=1 to daysInMonth
			%>
			<th style="width:25px"><%rw d%>.</th>
			<%
	
			qry = "select * from grupa  where  atcelta = 0 and (vaditajs<>0 or vaditajs<>0) and beigu_dat > '1/1/"+cstr(y)+"' and (('"+cstr(m)+"/"+cstr(d)+"/"+cstr(y)+"' BETWEEN sakuma_dat and beigu_dat) or ('"+cstr(m)+"/"+cstr(d)+"/"+cstr(y)+"' BETWEEN sakuma_dat and beigu_dat) or ('"+cstr(m)+"/"+cstr(d)+"/"+cstr(y)+"' <= sakuma_dat and '"+cstr(m)+"/"+cstr(d)+"/"+cstr(y)+"'>= beigu_dat))"
			'rw qry
			set rGr = conn.execute(qry)						
			arr = Array()						
			while not rGr.eof
				if rGr("vaditajs")<>0 then
					ReDim Preserve arr(UBound(arr) + 1)
					arr(UBound(arr)) = cstr(rGr("vaditajs"))+"|"+cstr(rGr("ID"))+"|"+grupas_nosaukums (rGr("ID"),NULL)			
				end if
				if rGr("vaditajs2")<>0 then
					ReDim Preserve arr(UBound(arr) + 1)
					arr(UBound(arr)) = cstr(rGr("vaditajs2"))+"|"+cstr(rGr("ID"))+"|"+grupas_nosaukums (rGr("ID"),NULL)
				end if
				rGr.movenext
			wend	
			vals.Add d, arr
			'rw Join(vals(d))
			'rw "<br><br>"
		next
	%>
	</tr>
	<%
	set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards, uzvards")
	while not rVaditajs.eof
	%>
	<tr>
		<th align="right"><%rw rVaditajs("vards")+" "+rVaditajs("uzvards")%></th><%

	
		for i=1 to daysInMonth
		 aiznemts = 0
		  arr = vals(i)

			For Each value in arr					 
				tmp = Split(value,"|",3)
				
				If tmp(0) = cstr(rVaditajs("idnum")) Then
					aiznemts = 1
					Exit For
				End If
				
			Next
			bg = "background-color:	#5cb85c"
			if aiznemts then bg = "background-color:#d9534f" end if
				%><td style="width:20px;<%=bg%>" >
				<% if aiznemts then %>
				<a href="grupa_edit.asp?gid=<%=tmp(1)%>" target="_blank" title="<%=cstr(tmp(2))%>"> &nbsp</a>
				<% else %>
				&nbsp
				<% end if %>
				</td><%
		next 

		rw "</tr>"

	rVaditajs.movenext
	wend



%>
</table>
<style>
	td a {
		display:block;
		width:100%;
	}
</style>
<script>
$(function(){
	 $("#sel_menesis").on("change",function(){
		this.form.submit(); 
	});
}) 
</script>
</body>
</html>