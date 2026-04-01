<%
function getDarbaLaiks(lid, pDate)


	'--- select - iistermina darba grafiks
	ssql = "select DATEDIFF(n,atrodas_no,atrodas_lidz) as diff, id as grid, IsNull(atrodas_lidz,'') as lidz, IsNull(atrodas_no,'') as no, * from lietotaji_grafiks "&_
		"where lietotajs_id = " & lid & " and '" & SQLDate(pDate) & "' between aktivs_no AND aktivs_lidz "&_
		"and tips = 'iis' and atrodas_lidz in (select max(atrodas_lidz) from lietotaji_grafiks "&_
		"where lietotajs_id = " & lid & " and '" & SQLDate(pDate) & "' between aktivs_no AND aktivs_lidz "&_
		"and tips = 'iis')"
	
	set rGrafiks = conn.execute (ssql)
	

	 

	if rGrafiks.eof then

		'--- select - ilgtermina darba grafiks
		ssql = "select id as grid, IsNull(atrodas_lidz,'') as lidz, IsNull(atrodas_no,'') as no, * from lietotaji_grafiks "&_
			"where lietotajs_id = " & lid & " and '" & SQLDate(pDate) & "' between aktivs_no AND aktivs_lidz and tips = 'gar'"
				
		set rGrafiks = conn.execute (ssql)
	
	end if
	
				

	if not rGrafiks.eof then



	 if Trim(rGrafiks("tips")) = "iis" then

		stundas = int(rGrafiks("diff")/60)
		minutes = rGrafiks("diff") mod 60		

		getDarbaLaiks = timeStr(rGrafiks("atrodas_no")) + " - " + timeStr(rGrafiks("atrodas_lidz"))+ "<br>Stundas " + cstr(stundas) + ":" + cstr(minutes)
		
	 else	

		 Select Case Weekday (pDate,2)
		 case 1
		   nogg = rGrafiks("1_no")
		   lidzgg = rGrafiks("1_lidz")
		 case 2
		   nogg = rGrafiks("2_no")
		   lidzgg = rGrafiks("2_lidz")
		 case 3
		   nogg = rGrafiks("3_no")
		   lidzgg = rGrafiks("3_lidz")
		 case 4
		   nogg = rGrafiks("4_no")
		   lidzgg = rGrafiks("4_lidz")
		 case 5
		   nogg = rGrafiks("5_no")
		   lidzgg = rGrafiks("5_lidz")
		 case 6
		   nogg = rGrafiks("6_no")
		   lidzgg = rGrafiks("6_lidz")
		end select
		
		diff = DateDiff("n", timeStr(nogg), timeStr(lidzgg))
		stundas = int(diff /60)
		minutes = diff mod 60		

		getDarbaLaiks = timeStr(nogg) + " - " + timeStr(lidzgg) + "<br>Stundas " + cstr(stundas) + ":" + cstr(minutes)
		
	end if
		    
	
	else
		getDarbaLaiks = "0"
	end if
	

end function

function getPrombutnesLaiks(lid, pDate)

	currMonth = Month(pDate)
	
	set rH = conn.execute("select datums, SUM(DATEDIFF(n,prom_no,prom_lidz)) as diff " + _ 
							 "from lietotaji_prombutne where lid = " + cstr(lid) + " " + _
							 "and DATEPART(MONTH, prom_no) = " + cstr(currMonth) + " " + _
							 "and datums = '" + SQLDate(pDate) + "' " + _ 
							 "group by datums order by datums desc")


	if not rH.eof then
	

		stundas = int(rH("diff") /60)
		minutes = rH("diff") mod 60	
		getPrombutnesLaiks = cstr(stundas) + ":" + cstr(minutes)
	
	else
	
		getPrombutnesLaiks = "-"
	
	end if
	
end function


function timeStr(date_p)
dim ret_l
if not isnull(date_p) then 
	ret_l = ret_l + twodigits(hour(date_p))+":"
	ret_l = ret_l + twodigits(minute(date_p))
	timeStr = ret_l
else
	timeStr = ""
end if
end function

%>