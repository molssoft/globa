<!-- #include file = "procs.asp" -->
<%

'Adjust this depending on the size of the files you'll
'be expecting; longer timeout for larger files!
Server.ScriptTimeout = 5400

Const ForWriting = 2
Const TristateTrue = -1
CrLf = Chr(13) & Chr(10)

'This function retreives a field's name
Function GetFieldName(infoStr)
	sPos = InStr(infoStr, "name=")
	EndPos = InStr(sPos + 6, infoStr, Chr(34) & ";")
	If EndPos = 0 Then
		EndPos = inStr(sPos + 6, infoStr, Chr(34))
	End If
	GetFieldName = Mid(infoStr, sPos + 6, endPos - _
		(sPos + 6))
End Function

'This function retreives a file field's filename
Function GetFileName(infoStr)
	sPos = InStr(infoStr, "filename=")
	EndPos = InStr(infoStr, Chr(34) & CrLf)
	GetFileName = Mid(infoStr, sPos + 10, EndPos - _
		(sPos + 10))
End Function

'This function retreives a file field's MIME type
Function GetFileType(infoStr)
	sPos = InStr(infoStr, "Content-Type: ")
	GetFileType = Mid(infoStr, sPos + 14)
End Function


'Yank the file (and anything else) that was posted
PostData = ""
Dim biData
biData = Request.BinaryRead(Request.TotalBytes)
'Careful! It's binary! So, let's change it into
'something a bit more manageable.
For nIndex = 1 to LenB(biData)
	PostData = PostData & Chr(AscB(MidB(biData,nIndex,1)))
Next

'Having used BinaryRead, the Request.Form collection is
'no longer available to us. So, we have to parse the
'request variables ourselves!
'First, let's find that encoding type!
ContentType = Request.ServerVariables( _
	"HTTP_CONTENT_TYPE")
ctArray = Split(ContentType, ";")
'File posts only work well when the encoding is 
'"multipart/form-data", so let's check for that!

If Trim(ctArray(0)) = "multipart/form-data" Then
	ErrMsg = ""
	' grab the form boundary...
	bArray = Split(Trim(ctArray(1)), "=")
	Boundary = Trim(bArray(1))
	'fix boundary
	bArray = split(Boundary,",")
	Boundary = bArray(0)
	
	'Now use that to split up all the variables!
	FormData = Split(PostData, Boundary)
	'Extract the information for each variable and its data
	Dim myRequest, myRequestFiles(9, 3) 
	Set myRequest = CreateObject("Scripting.Dictionary")
	FileCount = 0
	For x = 0 to UBound(FormData)
		'Two CrLfs mark the end of the information about
		'this field; everything after that is the value
		InfoEnd = InStr(FormData(x), CrLf & CrLf)
		If InfoEnd > 0 Then
			'Get info for this field, minus stuff at the end
			varInfo = Mid(FormData(x), 3, InfoEnd - 3)
			'Get value for this field, being sure to skip
			'CrLf pairs at the start and the CrLf at the end
			varValue = Mid(FormData(x), InfoEnd + 4, _
				Len(FormData(x)) - InfoEnd - 7)
			'Is this a file?
			If (InStr(varInfo, "filename=") > 0) Then
				'Place it into our files array
				'(While this supports more than one file
				'uploaded at a time we only consider the
				'single file case in this example)
				myRequestFiles(FileCount, 0) = GetFieldName( _
					varInfo)
				myRequestFiles(FileCount, 1) = varValue
				myRequestFiles(FileCount, 2) = GetFileName( _
					varInfo)
				myRequestFiles(FileCount, 3) = GetFileType( _
					varInfo)
				FileCount = FileCount + 1
			Else
				'It's a regular field
				myRequest.add GetFieldName(varInfo), varValue
			End If
		End If
	Next
Else
	ErrMsg = "Wrong encoding type!"
End If 


'Save the actual posted file
'If supporting more than one file, turn this into a loop!
Set lf = server.createObject("Scripting.FileSystemObject")
sPos = InStrRev(myRequestFiles(0, 2), "\")
if MyRequest("nosaukums") = "" then
 fName = MyRequest("prefix") + twodigits(year(now))+twodigits(month(now))+twodigits(day(now))+Mid(myRequestFiles(0, 2), sPos + 1)
else
 fName = MyRequest("nosaukums")
end if

if fName<>"" then
 FilePath = "../common_images/" & fName
 SavePath = Server.MapPath(FilePath)
 Set SaveFile = lf.CreateTextFile(SavePath, True)
 SaveFile.Write(myRequestFiles(0, 1))
 SaveFile.Close
end if

%>
<body onload="opener.forma.<%=MyRequest("var")%>.value='<%=fName%>';window.close()">
</body>
