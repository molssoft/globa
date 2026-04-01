<form action = "words.asp" method = post>
<input type = text name = "number">
<input type = "submit">
</form>

<p>
<%
response.write request.form("number")
response.write "<br>" 

n = request.form("number")
response.write "<br>"

function Ones(num)
	select case num  
		case 1 
			Ones = "one"
		case 2
			Ones = "two"
		case 3
			Ones = "three"
		case 4
			Ones = "four"
		case 5
			Ones = "five"
		case 6
			Ones = "six"
		case 7
			Ones = "seven"
		case 8
			Ones = "eight"
		case 9
			Ones = "nine"
	end select
end function

function RTens(num)
		select case mid(num,1,1)
			case "1"
				RTens = "ten"
			case "2"
				RTens = "twenty"
			case "3"
				RTens = "thirty"
			case "4"
				RTens = "fourty"
			case "5"
				RTens = "fifty"
			case "6"
				RTens = "sixty"
			case "7"
				RTens = "seventy"
			case "8"
				RTens = "eighty"
			case "9"
				RTens = "ninety"
		end select
end function

function Tens(num)
	first = mid(num,1,1)
	sec = mid(num,2,1)
	if sec = "0" then Tens = RTens(num) 
	
	if first = "1" then 
		select case sec
			case "0"
				Tens = "ten"
			case "1"
				Tens = "eleven"
			case "2"
				Tens = "twelve"
			case "3"
				Tens = "thirteen"
			case "4"
				Tens = "fourteen"
			case "5"
				Tens = "fiveteen"
			case "6"
				Tens = "sixteen"
			case "7"
				Tens = "seventeen"
			case "8"
				Tens = "eighteen"
			case "9"
				Tens = "nineteen"
		end select
	end if
	
	if first = "0" then tens = ones(sec)
	if first <> "1" AND first <> "0" then 
		Tens = RTens(first+"0") + " " + Ones(sec)
	end if
end function

Function Thundreds(s)
	if len(s) = 3 then 
		if mid(s,1,1) <> "0" then
			Thundreds = ones(mid(s,1,1)) + " hundred " + tens(mid(s,2,2))
		end if
	end if
	if len(s) = 1 then Thundreds = ones(s)
	if len(s) = 2 then Thundreds = tens(s)	
end function

Function Words(num)
	s = cstr(num)
	l = len(s)
	words = ""
	if l > 12 then Words = words + Thundreds(mid(s,1,l-12)) + " trillion " : s = mid(s,l-11,12):l = 12
	if l > 9 then Words = words + Thundreds(mid(s,1,l-9)) + " billion " : s = mid(s,l-8,9) : l = 9
	if l > 6 then Words = words + Thundreds(mid(s,1,l-6)) + " million " : s = mid(s,l-5,6): l = 6
	if l > 3 then Words = words + Thundreds(mid(s,1,l-3)) + " thousand " : s = mid(s,l-2,3): l = 3
	Words = Words + Thundreds(s)
end function

response.write Words(n)
response.write "<br>"
%>

