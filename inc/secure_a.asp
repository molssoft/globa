<%

Const ED_VEIDS_1 = " HB "
Const ED_VEIDS_2 = " FB+ "
Const ED_VEIDS_3 = " AI "

class secure
	
	Private data_GET
	Private data_POST
	Private regexp_sting
	Private regexp_sting_tag1
	Private regexp_sting_tag2
	Private db
	
	private sub Class_Initialize()
		regexp_sting = "(<.{1,10}?>)|([%""&~'`]+)"
		regexp_sting_tag1 = "<"
		regexp_sting_tag2 = ">"
		clean_post()
		clean_get()

		Set db = new cls_db

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
	
	public sub delete_post()
	
		Set data_POST = CreateObject("Scripting.Dictionary")
	
	end sub

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
		Dim item,key

				response.write("Dictionary=><br>{<br>")
				for Each item In arr
					response.write("<br>&nbsp;&nbsp;&nbsp;&nbsp;" & item & " = ")
					response.write(arr(item) & "<br>")
					'response.write(arr.item(key) & "<br>")
				Next

				response.write("}<br>")

	End Sub
   
     public Sub print_post()
	 Dim item,x
      For Each Item In Request.Form
          For x=1 To Request.Form(item).Count
              Response.Write Item & ": " & Request.Form(Item)(x) & "<br>"
          Next
      Next 
      End Sub 	

     public Sub print_session()
		%>
		<font face=arial size=1>
		Session Variables - <% =Session.Contents.Count %> Found<br><br>
		<%
		Dim item, itemloop
		For Each item in Session.Contents
		  If IsArray(Session(item)) then
		    For itemloop = LBound(Session(item)) to UBound(Session(item))
		%>
		<% =item %>  <% =itemloop %> <font color=blue><% =Session(item)(itemloop) %></font><BR>
		<%
		    Next
		  Else
		%>
		<% =item %> <font color=blue><% =Session.Contents(item) %></font><BR>
		<%
		  End If
		Next

      End Sub 	
	
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
		getInt=0
		if Not isnull(value) then
			getInt=CLng(value)
		End if
	End Function
	
	function getnum(s_p)
		on error resume next
		getnum = 0
		if isnull(s_p) then
		 getnum = 0
		else
		 if cstr(s_p) = "" then
		  getnum = 0
		 else
		  getnum = s_p
		 end if
		end if
	end function
	
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

'---- funkcijas no Globas

function SQLDate2(d_p)
	SQLDate2 = rtrim(normaldate(d_p))
	exit function
end Function

function NormalDate(date_p)
	dim i
	on error resume next
	if Not isdate(date_p) then
		NormalDate = ""
		exit function
	end if

x = date_p + date_p
if len(cstr(date_p)) <> len(cstr(x))/2 then
	NormalDate = cstr(month(date_p))+"/"+cstr(day(date_p))+"/"+cstr(year(date_p))
else 
	s = date_p
	tim = ""
	if instr(s," ")<>0 then
	 tim = mid(s,instr(s," "),len(s)-instr(s," ")+1)
	end if
	i = 1
	while isdigit(mid(s,i,1))
		s1=s1+mid(s,i,1)
		i = i + 1
	wend
	i = i + 1
	while isdigit(mid(s,i,1))
		s2=s2+mid(s,i,1)
		i = i + 1
	wend
	i = i + 1
	while isdigit(mid(s,i,1))
		s3=s3+mid(s,i,1)
		i = i + 1
	wend
	i1 = cint(s1)
	i2 = cint(s2)
	if s3 = "" then 
         s3 = cstr(year(now))
	end if
	i3 = cint(s3)
	NormalDate = cstr(i2)+"/"+cstr(i1)+"/"+cstr(i3)+" "+tim
end if
end Function

Function IsDigit(d)
	dim s
	s = cstr(d)
	if len(s) > 1 then IsDigit = false:exit function
	if len(s) < 1 then IsDigit = false:exit function
	if s<"0" then IsDigit = false:exit function
	if s>"9" then IsDigit = false: exit function
	IsDigit = true
end Function

'----

	function DatePrint(d_p)
		If Not IsNull(d_p) then
			DatePrint = cstr(day(d_p))+"/"+cstr(month(d_p))+"/"+cstr(year(d_p))
		Else
			DatePrint = "&nbsp;"
		End If
		
	end Function
	
	function DatePrint2(d_p)
		
		If Not IsNull(d_p) then
			DatePrint2 = twoD(cstr(day(d_p)))+"."+twoD(cstr(month(d_p)))+"."+cstr(year(d_p))
		Else
			DatePrint2 = "&nbsp;"
		End If
		
	end Function
	
	
	function sqlDate(d_p)
		If isdate(d_p) then
			sqlDate = cstr(month(d_p))+"/"+cstr(day(d_p))+"/"+cstr(year(d_p))
		Else
			sqlDate = null
		End if
	end Function

	Function twoD(val)

		if int(val)>0 and int(val)<10 then
			twoD = "0"+cstr(val)
		else 
			twoD = cstr(val)
		end if
		
		
	End Function
	
	function timeprint(date_p)
		dim ret_l
		if not isnull(date_p) then 
			ret_l = ret_l + twoD(hour(date_p))+":"
			ret_l = ret_l + twoD(minute(date_p))
			timeprint = ret_l
		else
			timeprint = ""
		end if
	end function
	
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
		regexp.Pattern = "^([0-9]+)?$"
		'regexp.Pattern = "^([0-9\s\-\+]+)?$"
		verify_phone = regexp.Test(string_data)

	End Function 
	'==========================================================
	
	Public Function verify_phone_req(string_data)
		Dim  regexp
		verify_phone_req = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^([0-9]+)"
		verify_phone_req = regexp.Test(string_data)

	End Function 	
	
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
		'--labots 12. feb 2013
		'regexp.Pattern = "^[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ\s]{1,50}$"
		regexp.Pattern = "(^[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ]+(-|\s)?[a-zA-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ]+$){1,50}"
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
		regexp.Pattern = "^[a-z\-\_A-ZâÂèÈçÇìÌîÎíÍïÏòÒðÐûÛþÞ.,/0-9\s]{5,100}$"
		verify_adrese = regexp.Test(string_data)

	End Function 
	
	Public function htmlspecialchars(someString)
		' Critical that ampersand is converted first, since all entities contain them.
		htmlspecialchars = Replace(someString,"'","''")
		'htmlspecialchars = Replace(replace(replace(replace(replace(someString, "&", "&amp;"), ">", "&gt;"), "<", "&lt;"), """", "&quot;"),"'","&#39;")
	end Function

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
		regexp.Pattern = "^[0-9]{4}$"
		''regexp.Pattern = "^LV\-[0-9]{4}$" bkp
		verify_indekss = regexp.Test(string_data)
		
		'If ((string_data <> "") And Len(string_data)>=4) Then
		'	verify_indekss = true
		'End if

	End Function 
	'==========================================================
	
	public Function ItemExists(ByRef arrArray, varValue)    
		ItemExists = 0    
		For Each varItem In arrArray        
			If Trim(varItem) = Trim(varValue) Then
	            ItemExists = ItemExists + 1         
	        End If    
		Next
	 End Function 

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
		If string_data = "" Then
			verify_email = false
		end If

		query = "SELECT id FROM ["&Application("db_tb_profili")&"] WHERE ([eadr] = '"&string_data&"' OR [eadr_new] = '"&string_data&"') AND ID <> '"&Session("user_id")&"'"
		'response.write(query)
		Set result = db.Conn.Execute(query)
		If Not result.EOF Then
	'	verify_email = False
			'taads epasts kaadam jau ir
	'		Exit Function
		End If				

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

		regexp.Pattern = "^[0-9]+$"
		result2 = regexp.Test(string_num)

		If result1 And result2 Then
			verify_pasesNum = true
		End if

	End Function
	'==========================================================
	
	public function verify_pk_integrity(p_pk1, p_pk2)
	
		Dim pk(11),i, res
		res= true
		
		for i=1 to 6
			pk(i)=mid(p_pk1,i,1)
		next
		
		for i=7 to 11
			pk(i)=mid(p_pk2,i-6,1)
		next
		
		if cint(PK(11)) <> (cint((1101 - (1*PK(1) + 6*PK(2) + 3*PK(3) + 7*PK(4) + 9*PK(5) + 10*PK(6) + 5*PK(7) + 8*PK(8) + 4*PK(9) + 2*PK(10))) mod 11)) then
			res=false
		end if
		
		verify_pk_integrity = res
		
	end function
	
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

	'==========================================================
	Public Function IdInResultSet(num,rs)
		IdInResultSet = False
		While(Not rs.EOF)
			if (getInt(rs("id")) = getInt(num)) Then
				IdInResultSet = True
				Exit Function
			end if
			rs.MoveNext
		Wend
	End Function
	'==========================================================
	
	Public Function in_array(element, arr)
		in_array = False
		
		on error resume next
		
		For i=0 To Ubound(arr)
			If Trim(arr(i)) = Trim(element) Then
				in_array = True
			Exit Function
			End If
		Next
	End Function

	Public Function verify_num(string_data)
		Dim  regexp
		verify_num = False
		
		Set regexp = New RegExp
		regexp.IgnoreCase = True
		regexp.Global = True
		regexp.Pattern = "^[0-9]+$"
		verify_num = regexp.Test(string_data)
	End Function 
	
	'===========================================================
	Public Function encodeLV(s)
	 
	 enlett = "âèçìîíïòðûþôÂÈÇÌÎÍÏÒÐÛÞÔ"
	 for u = 1 to len(s)
	  z = mid(s,u,1)
	  if instr(enlett,z) <> 0 then encodeLV = encodeLV + "#"
	  if z = "â" then z = "a"
	  if z = "è" then z = "c"
	  if z = "ç" then z = "e"
	  if z = "ì" then z = "g"
	  if z = "î" then z = "i"
	  if z = "í" then z = "k"
	  if z = "ï" then z = "l"
	  if z = "ò" then z = "n"
	  if z = "ð" then z = "s"
	  if z = "û" then z = "u"
	  if z = "þ" then z = "z"
	  if z = "Â" then z = "A"
	  if z = "È" then z = "C"
	  if z = "Ç" then z = "E"
	  if z = "Ì" then z = "G"
	  if z = "Î" then z = "I"
	  if z = "Í" then z = "K"
	  if z = "Ï" then z = "L"
	  if z = "Ò" then z = "N"
	  if z = "Ð" then z = "S"
	  if z = "Û" then z = "U"
	  if z = "Þ" then z = "Z"
	  if z = "Ô" then z = "O"
	  if z = "ô" then z = "o"
	  if z = "=" then z = "_" '--- specialais simbols, kuru banka nenjem
	  
	  encodeLV = encodeLV + z
	 next
	End Function
	
end class

Dim secured

Set secured = New secure


%>