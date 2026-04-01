<%@ Language=VBScript%>
<%
Option Explicit
Response.Expires=0
Response.CacheControl="no-cache"

dim xmlResponse
dim errMsg
dim personCount
dim conntemp
dim rstemp
dim i

xmlResponse=""
errMsg=""
personCount=0
i=0

 Session.LCID = 2064 '--datuma pareizai attçloðanai pievienoju 11.10.2018

Function GetData()
GetData=false


dim cst
	cst = "Provider=SQLOLEDB;" & _
	      "Data Source=ser-db3\MSSQL2008;" & _ 
	      "Initial Catalog=globa;" & _ 
	      "Network=DBMSSOCN;" & _ 
	      "User Id=globa;" & _ 
	      "Password=K$fRT+zFn}QLv2vW;"
set conntemp=server.createobject("adodb.connection")
	conntemp.open cst

'conntemp.execute("INSERT INTO debug (data_dump) VALUES ('bta.asp request.form: "+cstr(request.form("idcode"))+"; "+cstr(request.form("idlist"))+";')")

'not secure!!!!!!!!!!!!!!!

''If len(request.form)<1 or len(request.form)>50 Then
'' 	errMsg = "Nekorekti autorizâcijas dati!"
'' 	Exit Function
''End If

If cstr(request.querystring("idcode"))<>"I-1x0000"  Then
	errMsg = "Autorizâcija nav veiksmîga!"
	Exit Function
End If

If len(request.querystring("idlist"))<5 or len(request.querystring("idlist"))>20 or InStr(1,cstr(request.querystring("idlist")),"'")<>0 Then
	errMsg = "Nekorekts grupas identifikâcijas kods!"
	
	Exit Function
End If

'----> db conn here

set rstemp=conntemp.execute("SELECT count(dalibn.ID) as personCount " + _
"FROM dalibn INNER JOIN (Pieteikums INNER JOIN piet_saite ON Pieteikums.id = piet_saite.pid INNER JOIN grupa on pieteikums.gid = grupa.id) " + _ 
"ON dalibn.ID = piet_saite.did " + _
"WHERE grupa.kods = '"& cstr(request.querystring("idlist")) &"' AND piet_saite.deleted = 0 and pieteikums.deleted = 0 " + _ 
"and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3)")



if rstemp.eof then
errMsg = "Nav grupas ar tâdu grupas identifikâcijas kodu (1)!"
Exit Function
else
personCount=cint(rstemp("personCount"))

set rstemp=conntemp.execute("SELECT (pk1+'-'+pk2) as ipcode, vards as name, uzvards as lastname,dzimsanas_datums, marsruts.valsts as state,sakuma_dat as startdate, beigu_dat as enddate " + _
"FROM dalibn INNER JOIN (Pieteikums INNER JOIN piet_saite ON Pieteikums.id = piet_saite.pid INNER JOIN grupa on pieteikums.gid = grupa.id INNER JOIN marsruts ON grupa.mid = marsruts.id) " + _ 
"ON dalibn.ID = piet_saite.did " + _
"WHERE grupa.kods = '"& cstr(request.querystring("idlist")) &"' AND piet_saite.deleted = 0 and pieteikums.deleted = 0 " + _ 
"and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3) " + _
"order by pieteikums.id")


if rstemp.eof then
errMsg = "Nav grupas ar tâdu grupas identifikâcijas kodu (2)!"
Exit Function
else
xmlResponse=xmlResponse & "<?xml version=""1.0"" encoding=""windows-1257"" ?>"
xmlResponse=xmlResponse & " <response personCount="""& personCount &""" startdate="""& replace(cstr(rstemp("startdate")),"/",".") &""" enddate="""& replace(cstr(rstemp("enddate")),"/",".") &""" state="""& rstemp("state") &""">"

do while not rstemp.eof
i=i+1
xmlResponse=xmlResponse & " <person pid="""& i &""">"
xmlResponse=xmlResponse & " <ipcode>"& rstemp("ipcode") &"</ipcode>"
xmlResponse=xmlResponse & " <name>"& rstemp("name") &"</name>"
xmlResponse=xmlResponse & " <lastname>"& rstemp("lastname") &"</lastname>"
'xmlResponse=xmlResponse & " <birthDate>"& rstemp("dzimsanas_datums") &"</birthDate>"
xmlResponse=xmlResponse & " </person>"

rstemp.movenext
loop

xmlResponse=xmlResponse & " </response>"
end if
end if 

conntemp.close

GetData=true
End Function



Response.ContentType="text/xml"
If GetData=true then
	response.Write xmlResponse
else
	response.Write "<?xml version=""1.0"" encoding=""windows-1257"" ?><error>"& errMsg &"</error>"
end if
response.End

set xmlResponse=nothing
set errMsg=nothing
set personCount=nothing
set conntemp=nothing
set rstemp=nothing
set i=nothing

%>