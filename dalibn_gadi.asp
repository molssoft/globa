<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'@ 0 Header
dim conn
openconn

If not IsAccess(T_BALLES_ORG) then 
	session("message") = "Autorizâcijas kïûda. Nav pieejas tiesîbu."
	response.redirect "default.asp"
end If

f_gads_no = cstr(request.form("gads_no"))
f_gads_lidz = cstr(request.form("gads_lidz"))

if f_gads_no = "" then f_gads_no = "09"
if f_gads_lidz = "" then f_gads_lidz = "09"

f_datums_no = cstr(request.form("datums_no"))
f_datums_lidz = cstr(request.form("datums_lidz"))

 'if (f_datums_no) = "" then f_datums_no="01.01."+cstr(Year(Now()))
'' if (f_datums_lidz) = "" then f_datums_lidz="31.12."+cstr(Year(Now()))


docstart "Dalîbnieki pa gadiem","y1.jpg"
%>
<font face=arial>
<center><font color="GREEN" size="5"><b>Dalîbnieki pa gadiem</b></font><hr>
<%headlinks%><br>

<!--SADAÏA IR IZSTRÂDES STADIJÂ-->

<form action="" method="POST" id=form1 name=form1>

<table border="0" bgcolor="#FDFFDD">
<!--tr>
 <td align="right" bgcolor="#ffc1cc">Gads no (ieskaitot): 20<b></td>
 <td bgcolor="#fff1cc" colspan="3"> 

	<input name="gads_no" type="text" value="<%=f_gads_no%>" />

 </td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Gads lîdz (ieskaitot): 20<b></td>
 <td bgcolor="#fff1cc" colspan="3"> 

	<input name="gads_lidz" type="text" value="<%=f_gads_lidz%>" />

 </td>
</tr-->
<tr>
 <td align="right" bgcolor="#ffc1cc">Datums no (ieskaitot):<b></td>
 <td bgcolor="#fff1cc" colspan="3"> 

	<input name="datums_no" type="text"  placeholder="dd.mm.gggg"  value="<%=f_datums_no%>" />

 </td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Datums lîdz (ieskaitot):<b></td>
 <td bgcolor="#fff1cc" colspan="3"> 

	<input name="datums_lidz" type="text" placeholder="dd.mm.gggg" value="<%=f_datums_lidz%>" />

 </td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Ir grupâ<b></td>
 <td bgcolor="#fff1cc" colspan="3"> 

	<% 
			set rGrVeidi = conn.execute("select * from grveidi ORDER By vards ASC")
			if not rGrVeidi.eof then
			%>
			<select name="gr_veids">
				<option value="0">-</option>
			<%
				while not rGrVeidi.eof
					%>
					<option value="<%=cstr(rgrVeidi("id"))%>" <% if Request.Form("gr_veids")=cstr(rgrVeidi("id")) then rw "selected" %>><%=cstr(rGrVeidi("vards"))%></option>
					<%
					rGrVeidi.movenext
				wend
				%>
			</select>
				<%
			end if
					
			%>

 </td>
</tr>

<tr>
 <td align="right" bgcolor="#ffc1cc">Ir epasts</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="ir_epasts" <%if Request.Form("ir_epasts") = "on" then Response.Write "checked"%>>
</td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Ir tâlrunis</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="ir_talrunis" <%if Request.Form("ir_talrunis") = "on" then Response.Write "checked"%>>
</td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">No 16 gadiem</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="no_16" <%if Request.Form("no_16") = "on" then Response.Write "checked"%>>
</td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Nesaòem jaunumus</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="nav_jaunumos" <%if Request.Form("nav_jaunumos") = "on" then Response.Write "checked"%>>
</td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Ir nosûtîts epasts</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="nosutits_epasts" <%if Request.Form("nosutits_epasts") = "on" then Response.Write "checked"%> disabled>
</td>
</tr>
<tr>
 <td align="right" bgcolor="#ffc1cc">Ir sazvanîts</td>
	<td bgcolor="#fff1cc">
	<input type=checkbox name="ir_sazvanits" <%if Request.Form("ir_sazvanits") = "on" then Response.Write "checked"%> disabled>
</td>
</tr>
<!--tr>
 <td align="right" bgcolor="#ffc1cc">Sakârtojums pçc lauka</td>
	<td bgcolor="#fff1cc">
		<select name="sakartot_pec" size="1">
			<option value="0"></option>
			<option value="1">uzvârds</option>
			<option value="2">tâlrunis</option>
			<option value="3">epasts</option>
		</select>
	</td>
</tr-->

</table><br>
<input type="hidden" name="subm" value="1">
<input type="image" name="meklet" src="impro/bildes/meklet.jpg" WIDTH="25" HEIGHT="25"> 
</form>
<% 

if request.form("subm") = "1"  then 

where_c = ""

ir_epasts = Request.Form("ir_epasts")
ir_talrunis = Request.Form("ir_talrunis")
no_16 = Request.Form("no_16")
nav_jaunumos = Request.Form("nav_jaunumos")
gr_veids = Request.Form("gr_veids")



if ir_epasts = "on" then where_c = where_c + "AND ISNULL(D.eadr,'')<>'' "
if ir_talrunis = "on" then where_c = where_c + "AND (ISNULL(D.talrunisM,'')<>'' OR ISNULL(D.talrunisMob,'')<>'') "
if no_16 = "on" then where_c = where_c + "AND len(D.pk1)=6 "
if nav_jaunumos = "on" then where_c = where_c + "AND isnull(D.jaunumi,0)=0 "





'1	Vâktâ	V
'2	Pasûtîjuma	P
'3	Skolçnu	S
'4	Transports	T
'5	Uzòemoðais	U
'6	Kompleksais	K
'7	Cita	X
'8	Klubiòð	L
'9	Gidu kursi	G
'10	Dâvanu karte	D

if gr_veids <> "0" then
  'aktajam, pasutijuma, skolenu, transporta grupam skatas grupas datumu
    if (gr_veids= "1" or gr_veids="2") then
		if f_datums_no <> "" and f_datums_lidz <> "" then
		
			where_c = where_c + "AND (g.sakuma_dat >= '" & sqldate(f_datums_no) & "' AND g.sakuma_dat <= '" & sqldate(f_datums_lidz) & "') "
			'where_c = where_c + "AND (G.kods like '" & f_gads_no & ".%' OR G.kods like '" & f_gads_lidz & ".%') "
			 

		elseif f_datums_no <> "" then

			where_c = where_c + "AND g.sakuma_dat >= '" & sqldate(f_datums_no) & "' "

		elseif f_datums_lidz <> "" then

			where_c = where_c + "AND g.sakuma_dat <= '" & sqldate(f_datums_lidz) & "' "

		end if
   '' parejaam pieteikuma datumu
	else  
		if gr_veids="10" or gr_veids="6" then
			if f_datums_no <> "" and f_datums_lidz <> "" then
		
				where_c = where_c + "AND (p.sakuma_datums >= '" & sqldate(f_datums_no) & "' AND p.beigu_datums <= '" & sqldate(f_datums_lidz) & "') "
				'where_c = where_c + "AND (G.kods like '" & f_gads_no & ".%' OR G.kods like '" & f_gads_lidz & ".%') "
				 

			elseif f_datums_no <> "" then

				where_c = where_c + "AND p.sakuma_datums >= '" & sqldate(f_datums_no) & "' "

			elseif f_datums_lidz <> "" then

				where_c = where_c + "AND p.sakuma_datums <= '" & sqldate(f_datums_lidz) & "' "

			end if
		else
			if f_datums_no <> "" and f_datums_lidz <> "" then' and  f_gads_no <> f_gads_lidz then 
	
				where_c = where_c + "AND (g.sakuma_dat >= '" & sqldate(f_datums_no) & "' AND g.sakuma_dat <= '" & sqldate(f_datums_lidz) & "') "
				'where_c = where_c + "AND (G.kods like '" & f_gads_no & ".%' OR G.kods like '" & f_gads_lidz & ".%') "
				 

			elseif f_datums_no <> "" then

				where_c = where_c + "AND g.sakuma_dat >= '" & sqldate(f_datums_no) & "' "

			elseif f_datums_lidz <> "" then

				where_c = where_c + "AND g.sakuma_dat <= '" & sqldate(f_datums_lidz) & "' "

			end if
		end if
   end if
 where_c = where_c + "AND g.veids="+gr_veids+" "
 END IF	


ssql = "SELECT DISTINCT D.ID, D.vards, D.uzvards, D.pk1, D.pk2, D.talrunisM, D.talrunisMob, D.eadr FROM dalibn D " & _
"INNER JOIN piet_saite PS ON PS.did = D.id " & _
"INNER JOIN pieteikums P ON PS.pid = P.id " & _
"INNER JOIN grupa G ON P.gid = G.id " & _
"WHERE " & _
"ISNULL(G.blocked,0) = 0 AND ISNULL(G.atcelta,0) = 0 " & _
"AND ISNULL(P.deleted,0) = 0 AND ISNULL(PS.deleted,0) = 0 " & where_c & _
"ORDER BY D.uzvards, D.vards"

 '' Response.Write(ssql)

set f = server.createobject("ADODB.Recordset")
f.open ssql,conn,3,3

'Response.Write("<div align='center'>Gads: <b>20" + f_gads + "</b></div><br>")

qc=f.recordcount
response.write Galotne(qc,"Atrasts","Atrasti")+ " "+cstr(qc)+ " "+Galotne(qc,"dalîbnieks","dalîbnieki")

%>

<p>
<table>
<font face=arial >
<tr bgcolor="#ffc1cc">
<td><p align="center">Nr.</td>
<td><p align="center"></td>
<td><p align="center">Id</td>
<td><p align="center">Vârds</td>
<td><p align="center">Uzvârds</td>
<td><p align="center">Pk1</td>
<td><p align="center">Vecums</td>
<td><p align="center">Tâlrunis</td>
<td><p align="center">Tâlrunis (mob)</td>
<td><p align="center">E-pasts</td>
<td><p align="center"><input type=checkbox name="atzimet_visus" disabled> Nosûtîts epasts</td>
<td><p align="center">Sazvanîts</td>

</tr>

<%
Dim i
while not f.eof

	i = i + 1
	If (i Mod 1000 = 0) Then
		response.flush
	End if
	
	skip = 0
	cnt = cnt + 1
	
	if no_16 = "on" then
	
		'izrekina dalibnieka vecumu
		'response.write(f("ID"))
	'	response.write("<br>")
		d_age = GetAge(f("ID"))
		'response.write(d_dage)
		'response.end
		'd_yy = getnum(right(f("pk1"),2)) 'gads no personas koda
		'Response.Write(d_yy)
		'if d_yy > 0 then

			'if  d_yy <= getnum(right(Year(Date()),2)) then
			'	d_yy = 2000 + d_yy
		'	else
		'		d_yy = 1900 + d_yy
		'	end if
		
						
	'		d_age = DateDiff("yyyy", "01/01/" & d_yy, Date())
		
			if d_age < 16 then skip = 1
			
		'else
		'	skip = 1
	'	end if
	
	end if
	
	if skip = 0 then
		%>
		  <tr bgcolor="#fff1cc" >
			<td><%=cnt%></td>
		    <td><a target=_blank href="dalibn.asp?i=<%=cstr(f("id"))%>"><img src="impro/bildes/k_zals.gif" WIDTH="31" HEIGHT="14"></a></td>
			<td><font face=arial size="3" <%=color%>><%=f("id")%></font></td>
			<td><font face=arial size="3" <%=color%>><%=f("vards")%></font></td>
			<td><font face=arial size="3" <%=color%>><%=f("uzvards")%></font></td>
			<td><font face=arial size="3" <%=color%>><%=f("pk1")%></font></td>	
			<td><font face=arial size="3" <%=color%>><%=d_age%></font></td>	
			<td><font face=arial size="3" <%=color%>><%=f("talrunisM")%></font></td>
			<td><font face=arial size="3" <%=color%>><%=f("talrunisMob")%></font></td>
			<td><font face=arial size="3" <%=color%>><%=f("eadr")%></font></td>
			<td>
				<input type=checkbox name="nosutits_<%=f("id")%>" disabled>
			</td>
			<td>
				<input type=checkbox name="sazvanits_<%=f("id")%>" disabled>
			</td>
			
		 </tr>

		<%
	end if
	
f.movenext
wend
%>
</table>

<%
end if
%>

</body>
</html>