<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%

Function ToUnicode(s)
s = Replace(s, "в", "&#257;")
s = Replace(s, "и", "&#269;")
s = Replace(s, "з", "&#275;")
s = Replace(s, "м", "&#291;")
s = Replace(s, "о", "&#299;")
s = Replace(s, "н", "&#311;")
s = Replace(s, "п", "&#316;")
s = Replace(s, "т", "&#326;")
s = Replace(s, "р", "&#353;")
s = Replace(s, "ы", "&#363;")
s = Replace(s, "ю", "&#382;")
s = Replace(s, "В", "&#256;")
s = Replace(s, "И", "&#268;")
s = Replace(s, "З", "&#274;")
s = Replace(s, "М", "&#290;")
s = Replace(s, "О", "&#298;")
s = Replace(s, "Н", "&#310;")
s = Replace(s, "П", "&#315;")
s = Replace(s, "Т", "&#325;")
s = Replace(s, "Р", "&#352;")
s = Replace(s, "Ы", "&#362;")
s = Replace(s, "Ю", "&#381;")
ToUnicode = s
End Function


dim conn
OpenConn

'Response.Write "test"
'Response.Write conn.execute("select * from email_history where id = 2")("message")
'Response.Write "test2"
'Response.End

if not IsAccess(T_SUT_EMAILI) then
 session("message") = "Emailu sыtорana jums nav pieejama"
 Response.Redirect "default.asp"
end if

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
 FilePath = "./attachments/" & fName
 SavePath = Server.MapPath(FilePath)
 Set SaveFile = lf.CreateTextFile(SavePath, True)
 SaveFile.Write(myRequestFiles(0, 1))
 SaveFile.Close
end if








subject = STR_SQL(MyRequest("subject"))
mysource2 = replace(ToUnicode(MyRequest("mysource2")),"'","''")
message = MyRequest("message")



if MyRequest("klientiem") = "on" then
 Veids = "K"
 set rc = conn.execute ("select max(id) as c from dalibn")
elseif MyRequest("anketam") = "on" then
 Veids = "A"
 set rc = conn.execute ("select max(id) as c from anketas")
else
 Veids = "I"
 set rc = conn.execute ("select max(id) as c from email_list")
end if

c = rc("c")

conn.execute "INSERT INTO email_history (subject,kas,kad,next_id,veids,sent,max_id,attachment,klientiem) VALUES ("+subject+",'"+get_user+"','"+sqldate(now)+"',0,'"+cstr(veids)+"',0,"+cstr(c)+",'"+cstr(fName)+"',0)"
'Response.Write len(mysource2)'
'for i = 1 to 5125
' s = s + "X"
'next
'conn.execute  "update email_history set message = '"+s+"' where id =2"

max_id = conn.execute("select max(id) from email_history")(0)
conn.execute  "update email_history set message = '"+mysource2+"' where id = " + cstr(max_id)

Response.Redirect "email_history.asp"
%>

