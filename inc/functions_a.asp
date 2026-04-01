<% 
function nullprint(what_p)
	on error resume next
	nullprint = ""
	nullprint = cstr(what_p)
end function

function nullString(what_p)
	on error resume next
	nullString = ""
	nullString = cstr(what_p)
end function


function getnum(s_p)

	on error resume next
	getnum = 0

	if isnull(s_p) then
		getnum = 0
	else
		if cstr(s_p) = "" then
			getnum = 0
		else 
			if (isNumeric(clng(s_p)) or s_p = "on") then '--- labots 22.sept 2010 Nils
				getnum = s_p
			else 
				getnum = 0
			end if
		end if
	end if

end Function

function nullNum(s_p)

	on error resume next
	nullNum = 0

	if isnull(s_p) then
		nullNum = 0
	else
		if cstr(s_p) = "" then
			nullNum = 0
		else 
			if (isNumeric(clng(s_p)) or s_p = "on") then '--- labots 22.sept 2010 Nils
				nullNum = s_p
			else 
				nullNum = 0
			end if
		end if
	end if

end Function


function timeprint2(date_p)
dim ret_l
if not isnull(date_p) then 
	ret_l = ret_l + twodigits(hour(date_p))+":"
	ret_l = ret_l + twodigits(minute(date_p))
	timeprint2 = ret_l
else
	timeprint2 = ""
end if
end function

'@ DigitCount
'Prints at least two digits 01,02 etc.
function TwoDigits(x)
if x<10 then TwoDigits = "0" + cstr(x) else TwoDigits = cstr(x)
end Function

function DatePrint(d)
 if isnull(d) then
  DatePrint = ""
  exit function
 end if

 a = cstr(day(d))
 if len(a)<2 then a = "0" + a
 M = cstr(month(d))
 if len(m)<2 then m = "0" + m
 Y = cstr(year(d))
 DatePrint = a+"."+m+"."+y
end function


function rezBilanceLVL(rez_id)

	dim ssql, r, bilance
	
	bilance = 0

	if rez_id<>"" then
	
		ssql = "select iemaksasLVL, bilanceLVL from pieteikums where deleted = 0 and globa_rez = "&rez_id
		
		set r = db.conn.execute(ssql)
		
		while not r.eof
		
			bilance = bilance + r("bilanceLVL")
			
			r.movenext
		wend
	end if
	
	rezBilanceLVL = bilance

end Function

Function Decode(s)
If IsNull(s) Then
 Decode = ""
 Exit Function
End If
m = s
m = Replace (m, "#a", "â")
m = Replace (m, "#c", "è")
m = Replace (m, "#e", "ç")
m = Replace (m, "#g", "ì")
m = Replace (m, "#i", "î")
m = Replace (m, "#k", "í")
m = Replace (m, "#l", "ï")
m = Replace (m, "#n", "ò")
m = Replace (m, "#s", "ð")
m = Replace (m, "#u", "û")
m = Replace (m, "#z", "þ")
m = Replace (m, "#A", "Â")
m = Replace (m, "#C", "È")
m = Replace (m, "#E", "Ç")
m = Replace (m, "#G", "Ì")
m = Replace (m, "#I", "Î")
m = Replace (m, "#K", "Í")
m = Replace (m, "#L", "Ï")
m = Replace (m, "#N", "Ò")
m = Replace (m, "#S", "Ð")
m = Replace (m, "#U", "Û")
m = Replace (m, "#Z", "Þ")

Decode = m
End Function


%>