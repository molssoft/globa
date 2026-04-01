<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
gid = session("LastGid")

docstart "Kajîðu saraksta drukâðana","" 

'@ 1 Atrodam kajiites
set r = server.createobject("ADODB.Recordset")
r.open "Select kajite.id as kid, * from kajite INNER JOIN kajites_veidi ON kajite.veids = kajites_veidi.id WHERE kajite.gid = " + cstr(gid) + " AND (NOT DELETED = 1) order by veids,kajite.id",conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	KajNr = 1
	DalNr = 1
	dim rDal
	set rDal = Server.createobject("ADODB.Recordset")
	%> <center> <table border="1" cellpadding = 0 cellspacing = 0>
	<tr>
	<th align = center>CABIN</th>
	<th align = center>N</th>
	<th align = center>SURNAME</th>
	<th align = center>NAME</th>
	<th align = center>DATE OF B.</th>
	<th align = center>PASSPORT</th>
	<th align = center>ID CARD</th>
	<th align = center>SEX</th>
	</tr>
	<%
	KajVeids = 0
	while not r.eof
		if Request.Form("anglu") = "yes" then
			rDal.open "SELECT isnull(dalibn.dzimsanas_datums,'') as dzimsanas_datums, REPLACE(dalibn.vards2,'#','') AS vards, REPLACE(dalibn.uzvards2,'#','') AS uzvards, dalibn.pk1, dalibn.paseS, dalibn.paseNR,dalibn.idS, dalibn.idNR,  " + _
				" dalibn.ID, piet_saite.kid, piet_saite.id as id, piet_saite.did as did, " + _ 
				" piet_saite.kvietas_veids as kveids, dalibn.dzimta as dzimta " + _
				" FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
				" WHERE (NOT PIET_SAITE.DELETED = 1) AND kid = " + cstr(r("kid")) ,conn,3,3
		else
			rDal.open "SELECT isnull(dalibn.dzimsanas_datums,'') as dzimsanas_datums, dalibn.vards, dalibn.uzvards, dalibn.pk1, dalibn.paseS, dalibn.paseNR, dalibn.idS, dalibn.idNR, " + _
				" dalibn.ID, piet_saite.kid, piet_saite.id as id, piet_saite.did as did, " + _ 
				" piet_saite.kvietas_veids as kveids, dalibn.dzimta as dzimta " + _
				" FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
				" WHERE (NOT PIET_SAITE.DELETED = 1) AND kid = " + cstr(r("kid")) ,conn,3,3
		end if
		
		DalKajNr = 0
		
		while not rDal.eof
			%><tr><td><%
			DalKajNr = DalKajNr + 1
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + " - " + cstr(KajNr)
			end if
			%></td>
			<% if rDal("kveids") = 3 then %>
				<td><%=cstr(DalNr)%></td><td></td><td></td><td></td><td></td><td></td><td></td>
			<% else %>
			<td><%=cstr(DalNr)%></td>
			<td><%=ucase(nullprint(rDal("uzvards")))%></a></td>
			<td><%=ucase(nullprint(rDal("vards")))%></a></td>
			<td><%
			if (DatePrint(rDal("dzimsanas_datums")) <> "") then
				response.write(DatePrint(rDal("dzimsanas_datums")))
				else 
				' Drukaa dzimsanas datumu peec personas koda pirmaas daljas
				if len(rDal("pk1")) = 6 then					
					response.write(mid(rDal("pk1"),1,2)+".")
					response.write(mid(rDal("pk1"),3,2)+".")
					Y = (ASC(mid(rDal("pk1"),5,1)) - ASC("0"))*10+(ASC(mid(rDal("pk1"),6,1))-ASC("0"))+1900
					if y+99 < year(now) then y = y + 100
					response.write(cstr(y))
				end if
			end if
			%></td>
			<td><%=NullPrint(rDal("paseS"))%><%=NullPrint(rDal("paseNr"))%></td>
			<td><%=NullPrint(rDal("idS"))%><%=NullPrint(rDal("idNR"))%></td>
			<td>
				<%if NullPrint(rDal("dzimta")) = "x" then Response.Write "-"%>
				<%if NullPrint(rDal("dzimta")) = "v" then Response.Write "M"%>
				<%if NullPrint(rDal("dzimta")) = "s" then Response.Write "F"%>
			</td>
			<td>
			</tr><%
			end if
			DalNr = DalNr + 1
			rDal.MoveNext
		wend
		while (DalKajNr < r("vietas"))
			DalKajNr = DalKajNr + 1
			%><tr><td><%
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + " - " + cstr(KajNr)
			end if
			%></td></td>
			<td><%=DalNr%></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			</tr>
			<%DalNr = DalNr + 1
		wend
		KajNr = KajNr + 1
		rDal.close
		r.movenext
	wend
	%></table>
	<%
else
	response.write "Grupâ kajîðu nav!"
end if

%></body>
</html>













