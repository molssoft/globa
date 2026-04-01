<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
gid = Request.QueryString("gid")

docstart "Viesnicas numuru saraksta drukâðana","" 

ieklaut_edinasanu = false
if Request.Form("edinasana") = "yes" then ieklaut_edinasanu = true 

ieklaut_ekskursijas = false
if Request.Form("ekskursijas") = "yes" then ieklaut_ekskursijas = true 

vaditajs = false
if Request.Form("vaditajs") = "yes" then vaditajs = true 

'@ 1 Atrodam kajiites
set r = server.createobject("ADODB.Recordset")
r.open "Select viesnicas.id as vid, * from viesnicas INNER JOIN viesnicas_veidi ON viesnicas.veids = viesnicas_veidi.id WHERE viesnicas.gid = " + cstr(gid) + " order by veids,viesnicas.id",conn,3,3
if r.recordcount <> 0 then
	r.movefirst
	KajNr = 1
	DalNr = 1
	dim rDal
	set rDal = Server.createobject("ADODB.Recordset")
	%> <center><h3><%=grupas_nosaukums (gid,NULL)%></h3>


<style>
  .rotated-text {
    display: inline-block;
    overflow: hidden;
    width: 1.5em;

}
.rotated-text__inner {
	text-align:left;
    display: inline-block;
    white-space: nowrap;
    /* this is for shity "non IE" browsers
       that doesn't support writing-mode */
    -webkit-transform: translate(1.1em,0) rotate(90deg);
       -moz-transform: translate(1.1em,0) rotate(90deg);
         -o-transform: translate(1.1em,0) rotate(90deg);
            transform: translate(1.1em,0) rotate(90deg);
    -webkit-transform-origin: 0 0;
       -moz-transform-origin: 0 0;
         -o-transform-origin: 0 0;
            transform-origin: 0 0;
   /* IE9+ */
   -ms-transform: none;
   -ms-transform-origin: none;
   /* IE8+ */
   -ms-writing-mode: tb-rl;
   /* IE7 and below */
   *writing-mode: tb-rl;
}
.rotated-text__inner:before {
    content: "";
    float: left;
    margin-top: 100%;
}

/* mininless css that used just for this demo */
.container {
  float: left;
}

td,th,table {
font-size:11pt;
	border-collapse: collapse;
	padding: 2px;
	border-width:0.25pt;
}

</style>


	<table class="rotate-table-grid" border="1">
	<tr>
	<th align = center>ROOM</th>
	<th align = center>N</th>
	<th align = center>SURNAME</th>
	<th align = center>NAME</th>
	<th align = center>DATE OF B.</th>
	<th align = center colspan = 2>PASSPORT/ID</th>
	<th align = center>SEX</th>
	<% if (ieklaut_edinasanu = true) then %>
	<th align = center>MEALS</th>
	<% end if %>
	<% if (ieklaut_ekskursijas = true) then %>
	<th align = center>EXCURSIONS</th>
	<% end if %>
	</tr>
	<%
	KajVeids = 0
	while not r.eof
	 if Request.Form("anglu") = "yes" then
	  rDal.open "SELECT isnull(dalibn.dzimsanas_datums,'') as dzimsanas_datums, REPLACE(dalibn.vards2,'#','') AS vards, REPLACE(dalibn.uzvards2,'#','') AS uzvards, dalibn.pk1, dalibn.paseS, dalibn.paseNR, " + _
			 " dalibn.idS, dalibn.idNr, dalibn.ID, piet_saite.vid, piet_saite.id as id, piet_saite.did as did, " + _ 
			 " dalibn.dzimta as dzimta,piet_saite.pid as pid " + _
			 " FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
			 " WHERE piet_saite.pid in (select id from pieteikums where gid = "+gid+" AND NOT deleted = 1) and (NOT PIET_SAITE.DELETED = 1) AND vid = " + cstr(r("vid")) ,conn,3,3
	 else
		 rDal.open "SELECT isnull(dalibn.dzimsanas_datums,'') as dzimsanas_datums, dalibn.vards, dalibn.uzvards, dalibn.pk1, dalibn.paseS, dalibn.paseNR, " + _
			 " dalibn.idS, dalibn.idNr, dalibn.ID, piet_saite.vid, piet_saite.id as id, piet_saite.did as did, " + _ 
			 " dalibn.dzimta as dzimta,piet_saite.pid as pid " + _
			 " FROM dalibn INNER JOIN piet_saite ON dalibn.ID = piet_saite.did " + _
			 " WHERE piet_saite.pid in (select id from pieteikums where gid = "+gid+" AND NOT deleted = 1) and (NOT PIET_SAITE.DELETED = 1) AND vid = " + cstr(r("vid")) ,conn,3,3
		end if
		DalKajNr = 0
		DalKajNos = ""
		while not rDal.eof
			%><tr><td><%
			DalKajNr = DalKajNr + 1
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + nullprint(r("piezimes")) + " - " + cstr(KajNr)
			end if
			
			if r("nosaukums") = "SINGLE" then
				KajNrSingle = KajNr
			end if
			
			%></td>
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
			<% if NullPrint(rDal("paseNr"))<>"" then %>
				<td <%=row_style%>><%=NullPrint(rDal("paseS"))%></td>
				<td <%=row_style%>><%=NullPrint(rDal("paseNr"))%></td>
			<% else %>
				<td <%=row_style%>><%=NullPrint(rDal("idS"))%></td>
				<td <%=row_style%>><%=NullPrint(rDal("idNr"))%></td>
			<% end if %>
			<td>
				<%if NullPrint(rDal("dzimta")) = "x" then Response.Write "-"%>
				<%if NullPrint(rDal("dzimta")) = "v" then Response.Write "M"%>
				<%if NullPrint(rDal("dzimta")) = "s" then Response.Write "F"%>
			</td>
			<% if (ieklaut_edinasanu = true) then %>
			<td>
				<%
				''------------ çdinâðanas
				Set rEd = conn.execute("select nosaukums,* from piet_saite inner join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id where pid = "+CStr(rDal("pid"))+" and deleted = 0 and tips = 'ED'")
				While Not rEd.eof
					Response.write(rEd("nosaukums"))+"<BR>"
					rEd.MoveNext
				wend
				%>
			</td>
			<% end if %>
			<% if (ieklaut_ekskursijas = true) then %>
			<td>
				<%
				''------------ ekskursijas
				Set rEx = conn.execute("select nosaukums,* from piet_saite inner join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id where pid = "+CStr(rDal("pid"))+" and deleted = 0 and tips = 'EX'")
				While Not rEx.eof
					Response.write(rEx("nosaukums"))+"<BR>"
					rEx.MoveNext
				wend
				%>
			</td>
			<%end if%>

			</tr><%
			DalNr = DalNr + 1
			rDal.MoveNext
		wend
		while (DalKajNr < r("vietas"))
			DalKajNr = DalKajNr + 1
			%><tr><td><%
			if KajVeids <> r("veids") then KajNr = 1
			KajVeids = r("veids")
			DalKajNos = r("nosaukums")
			if DalKajNr = 1 then 
				response.write r("nosaukums") + " - " + cstr(KajNr)
			end if
			if r("nosaukums") = "SINGLE" then
				KajNrSingle = KajNr
			end if
			
			%></td>
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
	
	if vaditajs then
		%>
		<tr>
			<td>SINGLE - <%=KajNrSingle+1%></td>
			<td><%=DalNr%></td>
			
			<% 
				set rGrupa = conn.execute("select d.vards, d.uzvards, dzimsanas_datums, d.paseNr, d.paseS, d.idS, d.idNr, d.dzimta, d.talrunisMob, d.talrunisMobValsts from grupa g " + _
					" join grupu_vaditaji vad on g.vaditajs = vad.idnum " + _
					" join dalibn d on vad.did = d.id " + _
					" where g.id = " +cstr(gid))
			if not rGrupa.eof then
			%>
				<td><%=rGrupa("uzvards")%><br>Tourleader</td>
				<td><%=rGrupa("vards")%><br>+<%=rGrupa("talrunisMobValsts")%> <%=rGrupa("talrunisMob")%></td>
				<td><%=rGrupa("dzimsanas_datums")%></td>
				
				<% if NullPrint(rGrupa("paseNr"))<>"" then %>
					<td <%=row_style%>><%=NullPrint(rGrupa("paseS"))%></td>
					<td <%=row_style%>><%=NullPrint(rGrupa("paseNr"))%></td>
				<% else %>
					<td <%=row_style%>><%=NullPrint(rGrupa("idS"))%></td>
					<td <%=row_style%>><%=NullPrint(rGrupa("idNr"))%></td>
				<% end if %>	
				
				<td>
				<%if NullPrint(rGrupa("dzimta")) = "x" then Response.Write "-"%>
				<%if NullPrint(rGrupa("dzimta")) = "v" then Response.Write "M"%>
				<%if NullPrint(rGrupa("dzimta")) = "s" then Response.Write "F"%>		
				</td>
			<% end if %>
		</tr>
		<%
	end if
	
	%></table>
	<%
else
	response.write "Grupâ viesnicas numuru nav!"
end if

%></body>
</html>













