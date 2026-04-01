<%
class secure
	
	Private data_GET
	Private data_POST
	Private regexp_sting
	Private regexp_sting_tag1
	Private regexp_sting_tag2
	
	private sub Class_Initialize()
		regexp_sting = "(<.{1,10}?>)|([%""&~'`]+)"
		regexp_sting_tag1 = "<"
		regexp_sting_tag2 = ">"
		clean_post()
		clean_get()
	end sub 

	private sub Class_Terminate()

		''data_GET = Nothing
		''data_POST = Nothing
		''regexp_sting = empty
	end sub 

' get dictionary object for POST data
	Public Property Get s_POST()
		SET s_POST = data_POST
	End Property

' get dictionary object for GET data
	Public Property Get s_GET()
		SET s_GET = data_GET
	End Property

	Private Sub clean_post()
		Dim key
		Dim value
		Dim regexp
		
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = regexp_sting
		
		Set data_POST = CreateObject("Scripting.Dictionary")

		for Each key In Request.Form
			regexp.Pattern = regexp_sting
			value =regexp.Replace(Request.Form(key),"")
			regexp.Pattern = regexp_sting_tag1
			value =regexp.Replace(value,"&lt;")
			regexp.Pattern = regexp_sting_tag2
			value =regexp.Replace(value,"&gt;")
			Call data_POST.Add( key,value)
		Next
	End Sub
	
	Private Sub clean_get()
		Dim key
		Dim value
		Dim regexp
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = regexp_sting
		Set data_GET = CreateObject("Scripting.Dictionary")

		for Each key In Request.QueryString
			regexp.Pattern = regexp_sting
			value =regexp.Replace(Request.QueryString(key),"")
			regexp.Pattern = regexp_sting_tag1
			value =regexp.Replace(value,"&lt;")
			regexp.Pattern = regexp_sting_tag2
			value =regexp.Replace(value,"&gt;")
			Call data_GET.Add( key,value)
		Next
	End Sub
'print out submited data in GET and POST'
	Public Sub print()
		Dim key
		response.write(" POST=><br>{<br>")
		for Each key In data_POST
			response.write("&nbsp;&nbsp;&nbsp;&nbsp;" & key & " = ")
			response.write(data_POST.Item(key) & "<br>")
		Next
		response.write("}<br>")

		response.write(" GET=><br>{")
		for Each key In data_GET
			response.write("&nbsp;&nbsp;&nbsp;&nbsp;" & key & " = ")
			response.write(data_GET.Item(key) & "<br>")
		Next
		response.write("}<br>")

		response.write(" Session !!UNSECURED DATA!!=>{<table>")
		for Each key In Session.Contents
			response.write("<td>"&key&" </td><td> " & Session.Contents(key) & "</td></tr>")
			
		Next
		response.write("</table>}")
	End Sub
	
	Public sub print_r(arr)
		Dim item

				response.write("Dictionary=><br>{<br>")
				for Each item In arr
					response.write("<br>&nbsp;&nbsp;&nbsp;&nbsp;" & item & " = ")
					response.write(arr.item(key) & "<br>")
				Next
				response.write("}<br>")

	End sub
	
	Public Function regexpInt(value)
		Dim regexp

		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "[^0-9]+"

		''response.End
		value=regexp.Replace(value,"")
		If(value = "")Then 
			regexpInt = 0
		Else
			regexpInt=getInt(value) 'regexpInt=CInt(value)
		End If
			
	End Function
	
	Public Function regexpFloat(value)
		Dim regexp
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "[^0-9\.]+"
		
		regexpFloat=regexp.Replace(value,"")
	End Function
	
	Public sub printInt(value)
		if isnull(value) then
			response.write("0")
		else
			response.write(value)
		end if
	End sub
	
	public sub printFloat(value)
		if isnull(value) then
			response.write("0.00")
		else
			response.write(value)
		end if
	End sub
	
	Public function getInt(value)
		On Error Resume next
		if isnull(value) then
			getInt=0
		else
			getInt=value
		End if
	End function
	
	Public function getFloat(value)
		if isnull(value) then
			getFloat=0.00
		else
			getFloat=value
		End if
	End Function

	Public function getBit(value)
		if isnull(value) then
			getBit=0
		ElseIf value = True then
				getBit=1
			Else
				getBit=0
		End if
	End Function
	
	Function CurrPrint(x)
		 CurrPrint = cstr(getFloat(x))
		 if instr(currprint,".")=0 then currprint = currprint + ".00"
		 if instr(currprint,".")=len(currprint)-1 then currprint = currprint + "0"
		 if instr(currprint,".")<len(currprint)-2 then currprint = mid(currprint,1,instr(currprint,".")+2)
	End Function

	function DatePrint(d_p)
		If Not IsNull(d_p) then
			DatePrint = cstr(day(d_p))+"/"+cstr(month(d_p))+"/"+cstr(year(d_p))
		Else
			DatePrint = "&nbsp;"
		End If
		
	end Function
	function DateTimePrint(d_p)
		If Not IsNull(d_p) then
			DateTimePrint = cstr(day(d_p))+"/"+cstr(month(d_p))+"/"+cstr(year(d_p))+" "+FormatDateTime(d_p,vbshorttime)
		Else
			DateTimePrint = "&nbsp;"
		End If
		
	end Function
	
	function sqlDate(d_p)
		sqlDate = cstr(month(d_p))+"/"+cstr(day(d_p))+"/"+cstr(year(d_p))
	end Function

	
	
	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys phone inputs correctness
	'==========================================================
	Public Function verify_phone(string_data)
		Dim  regexp
		verify_phone = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^([0-9\s\-\+]+)?$"
		verify_phone = regexp.Test(string_data)

	End Function 
	'==========================================================
	
	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys name inputs correctness
	'==========================================================
	Public Function verify_name(string_data)
		Dim  regexp
		verify_name = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ\s]{1,50}$"
		verify_name = regexp.Test(string_data)

	End Function 
	'==========================================================

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys surname inputs correctness
	'==========================================================
	Public Function verify_surname(string_data)
		Dim  regexp
		verify_surname = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ\s]{1,50}$"
		verify_surname = regexp.Test(string_data)

	End Function 
	'==========================================================

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys adress inputs correctness
	'==========================================================
	Public Function verify_adrese(string_data)
		Dim  regexp
		verify_adrese = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[a-z\-\_A-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ0-9\s]{5,100}$"
		verify_adrese = regexp.Test(string_data)

	End Function 
	'==========================================================

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys adress inputs correctness
	'==========================================================
	Public Function verify_pilseta(string_data)
		Dim  regexp
		verify_pilseta = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ]{2,30}$"
		verify_pilseta = regexp.Test(string_data)

	End Function 
	'==========================================================

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys adress inputs correctness
	'==========================================================
	Public Function verify_indekss(string_data)
		Dim  regexp
		verify_indekss = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^LV\-[0-9]{4}$"
		verify_indekss = regexp.Test(string_data)

	End Function 
	'==========================================================

	'==========================================================
	'==Function by Janis Dusa
	'==Uses -
	'==Takes - dirty version string
	'==Returns - true or false
	'==Comment - verifys adress inputs correctness
	'==========================================================
	Public Function verify_email(string_data)
		Dim  regexp
		verify_email = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+?[a-zA-Z0-9.-]*[a-zA-Z0-9]+?\.[a-zA-Z]{2,4})?$"
		verify_email = regexp.Test(string_data)

	End Function 
	'==========================================================
	
	'==========================================================
	Public Function verify_pasesNum(string_serija, string_num)
	
		Dim  regexp, result1, result2
		verify_pasesNum = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[a-zA-zâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ]{2}$"
		result1 = regexp.Test(string_serija)

		regexp.Pattern = "^[0-9]{5,9}$"
		result2 = regexp.Test(string_num)

		If result1 And result2 Then
			verify_pasesNum = true
		End if

	End Function
	'==========================================================

	'==========================================================
	Public Function verify_pers_kods(string_pk1, string_pk2)
	
		Dim  regexp, result1, result2
		verify_pers_kods = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[0-9]{6}$"
		result1 = regexp.Test(string_pk1)

		regexp.Pattern = "^[0-9]{5}$"
		result2 = regexp.Test(string_pk2)

		If result1 And result2 Then
			verify_pers_kods = true
		End if

	End Function
	'==========================================================



end class

Dim secured

Set secured = New secure


%>