<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->


<%

Dim  sGet, pid, gid, query, db, result, user_id
dim mFieldSize, mBytes

dim conn
OpenConn

rez_id = Request.QueryString("rez_id")
id = Request.QueryString("id")

If rez_id<>"" then
	query = "SELECT *,isnull(file_name,'') as fn FROM ligumi WHERE rez_id = "&rez_id&" AND deleted = 0"
Else
	query = "SELECT *,isnull(file_name,'') as fn FROM ligumi WHERE id = "&id&" AND deleted = 0"
End if

SET result = conn.Execute(query)
'response.write(query)
'response.write(result("fn"))

if result("fn")<>"" then
	'response.redirect "https://www.impro.lv/ligumi/"+result("fn")
	response.redirect "paradit_ligumu.php?id="+id
else
	If rez_id<>"" then
		query = "SELECT *,isnull(file_name,'') as fn FROM ligumi WHERE rez_id = "&rez_id&" AND deleted = 0"
	Else
		query = "SELECT *,isnull(file_name,'') as fn FROM ligumi WHERE id = "&id&" AND deleted = 0"
	End if

	SET result = conn.Execute(query)
	mFieldSize = result.Fields("bpdf").ActualSize
	if mFieldSize>0 then


		mBytes = result.Fields("bpdf").GetChunk(mFieldSize)

		response.Clear
		response.ContentType = "application/pdf"
		response.AddHeader "Content-Type", "application/pdf"

		response.binarywrite mBytes
	else
		Response.Write "Kïûda. Lîgums nav atrasts.<br><br>"	
		Response.Write "<a href=""#"" onclick=""self.close()"">Aizvçrt logu</a>"
	end if
		
	response.End
end if
%>
