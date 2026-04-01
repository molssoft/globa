<!-- #include File ="conn.asp" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%

Dim db, query, result,r,st_skaits,datumsNo, DatumsLidz,rez_id,ErrMsg

Dim conn
OpenConn ()

ErrMsg = ""

if request.querystring("rez_id") then
	rez_id = request.querystring("rez_id")
	
end if
if (request.form("self") = "true" and request.form("poga") <> "Tîra forma") or  rez_id<>"" then
	'DatumsNo = request.form("datums_no")
	DatumsNo = request.form("datums_lidz")
	DatumsLidz = request.form("datums_lidz")
	if rez_id="" then
		rez_id = request.form("rez_id")
	end if
	
	if request.form("datums_lidz") <>  "" or rez_id<>"" then
		st_skaits=200
		st_skaits_no =0
		' query ="select sakuma_dat,orez.id, max(p.datums) as datums, g.kods, m.v, pr.vards, pr.uzvards, count(p.personas) as dalibnieki, " + _ 
		' "sum(p.summaLVL) as summaLVL, sum(p.summaUSD) as summaUSD, sum(p.summaEUR) as summaEUR, " + _ 
		' "sum(p.bilanceLVL) as bilanceLVL,sum(p.bilanceUSD) as bilanceUSD,sum(p.bilanceEUR) as bilanceEUR, " + _ 
		' "orez.ligums_id, p.atlaidesLVL from online_rez orez " + _ 
		' "inner join pieteikums p on p.online_rez = orez.id " + _ 
		' "inner join profili pr on pr.id = orez.profile_id " + _ 
		' "inner join grupa g on g.id = p.gid " + _
		' "inner join marsruts m on m.id = g.mid " + _
		' "where orez.deleted = 0 and p.deleted = 0 and p.tmp = 0 and p.step = '4' and p.internets = 1 " + whereC + _ 
		' "group by sakuma_dat, orez.id, g.kods, m.v, orez.ligums_id, pr.vards, pr.uzvards, p.atlaidesLVL " + _
		' "order by p.datums"

		query="select session, count(user_tracking.id) as c,min(ts) as m, max(pk1) as pk1,max(pk2)as pk2,max(vards) as vards,max(uzvards) as uzvards, max(profili.id) as profili_id from user_tracking "+_ 
		"left join profili on profili.id = user_tracking.profili_id "+ _   
		"WHERE version = 2 "
		if (request.form("datums_lidz") <> "" ) then
			query = query + "and ts BETWEEN /*DATEADD(hour, -"+cstr(st_skaits)+",current_timestamp) AND DATEADD(hour, -"+cstr(st_skaits_no)+",current_timestamp) */ '"+SQLDate(DatumsNo)+"' AND '"+SQLDate(DateAdd("d", +1, DatumsLidz) )+"'/*current_timestamp*/ " 
		end if

		if getnum(rez_id) <> 0 then
			query = query + " AND rez_id="+cstr(rez_id)+" "
		end if
		query = query + "/* AND (vards IS NOT NULL) */" +_
		"group by session order by m desc"

		 ' response.write(query)

		set result = conn.Execute(query)
		' response.write(result)
	else 
		ErrMsg = "Lûdzu, izvçlieties datumu un/vai Rez. Nr."
	end if
	
else
	'DatumsNo = DateAdd("d", -1, Date()) 
	DatumsNo = Date()
	DatumsLidz = Date()
	res_id = ""
	'DatumsNoSQL = 
	'DatumsLidz = 1
end if


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1257">
<title>Sesiju izsekoðana</title>
<link rel="stylesheet" href="online_rez/css/default.css" type="text/css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<style>
.session_cont{
	display:none;
}
a{
cursor:pointer;
}
</style>
<script>
function showSession(id){
	$(".sess"+id).toggle();
}
</script>
</head>

<body>
<div id="main_area">
	<div id="main_area_center">
	
	<div id="impro_header">
		Sesiju izsekoðana
	</div>

	<center>
	<a href="default.asp">Atgriezties uz Globu</a>
	<br>
	<br>
<form method="POST" name="forma"  ACCEPT-CHARSET=windows-1257 action="user_tracking.asp">
		<% if ErrMsg <> "" then
			rw "<font color='red'>"+ErrMsg+"</font>"
		end if
		%>
		<div align="center"><center><table border="0">
        <!--<tr>
            <td align="right" bgcolor="#ffc1cc">Datums no: </td>
            <td bgcolor="#fff1cc"><label for="datums_no"></label>
			<input type="text" size="16" id="datums_no" maxlength="80"
            name="datums_no" value="<%=DatumsNo%>" placeholder="dd.mm.YYYY"></td>
        </tr>-->
        <tr>
            <td align="right" bgcolor="#ffc1cc">Datums: </td>
            <td bgcolor="#fff1cc"><label for="datums_lidz"></label>
			<input type="text" size="16" name="datums_lidz" id="datums_lidz" placeholder="dd.mm.YYYY"value="<%=DatumsLidz%>"></td>
        </tr>
		 <tr>
            <td align="right" bgcolor="#ffc1cc">Rezervâcijas Nr.: </td>
            <td bgcolor="#fff1cc"><label for="rez_id"></label>
			<input type="text" size="16" name="rez_id" id="rez_id" value="<%=rez_id%>"></td>
        </tr>
        
		</table>
	<center>
		<input type="submit" name = "submit" value="Meklçt!"></td>
		     
            
		<input type="hidden" name="self" value="true" >
          
	
</form>
	
<% if session("message") <> "" then 
	%>
<p align="center"><br>
<font color="#FF0000" size="4"><%=session("message")%></font><br>
<%
	session("message") = ""
end if
%>
	<table class="form_table">
		<tr>
			<th width=220>Sessija</th>
			<th width=200>Datums</th>
			<th>Teksts</th>
		</tr>
		<%
		if not isempty(result) then
			 While Not result.eof 
			%>
			<tr>
				<td><a target="blank_" href="dalibn.asp?profili_id=<%=result("profili_id")%>"><%=result("vards")%>&nbsp;<%=result("uzvards")%> (<%=result("c")%>)</a></td>
				<td><%=timeprint(result("m"))%></td>
				<td><a onclick="showSession('<%=result("session")%>')">Skatît</a></td>
			</tr>
			<%
				query="select * from user_tracking where session='"+result("session")+"'"
				if request.form("datums_lidz") <>  "" then
					query = query +  " and ts BETWEEN '"+SQLDate(DatumsNo)+"' AND '"+SQLDate(DateAdd("d", +1, DatumsLidz) )+"'"
				end if
				if (getnum(rez_id) <> 0 )	then
					query = query + " AND rez_id="+cstr(rez_id)+"" 
				end if
				query = query +  " order by ts asc"
				set r = conn.Execute(query)
				while not r.eof
					%>
					<tr class="session_cont sess<%=result("session")%>">
						<td></td>
						<td><%=timeprint(r("ts"))%></td>
						<td><%=r("text")%></td>
					</tr>
					<%
					r.movenext
				wend
				result.movenext
			 Wend
		 end if
		%>
	</table>

	</center>