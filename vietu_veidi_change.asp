<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
OpenConn
gid = request.querystring("gid")
vv = request.querystring("vv")

if request.form("subm") = "1" then
	tips = request.form("tips")
	'16.01.2019 RT : Jâsaglabâ detalizçtâk pakalpojumu vçsture
	id_query = "select * from vietu_veidi where id = " + CStr(vv)
	Dim old_vals
	set old_vals = CreateDict(id_query) 
	'16.01.2019 RT:pieliku, lai nomainâs arî personas un papildvietas lauks, jo ja pçc tam save nenospieþ, tie nenomainâs atkarîbâ no tipa. Tagad nomainîsies
	persona = "0"
	papildv = "0"
	
	if tips = "C" or tips = "Z1" or tips = "CH1" Or tips = "C_NA" Or tips = "CH1_NA" then
	 papildv = "0"
	 persona = "1"
	end if
	if tips = "P" then 
	 papildv = "1"
	 persona = "0"
	end if 
	if tips = "X" then
	 papildv = "0"
	 persona = "0"
	end if
	
	if tips = "G" then
	 papildv = "0"
	 persona = "0"
	end if
	response.write "update vietu_veidi set tips = '"+request.form("tips")+"', persona = "+cstr(persona)+", papildv = "+cstr(papildv)+" where id = "+vv
	
	conn.execute("update vietu_veidi set tips = '"+request.form("tips")+"', persona = "+cstr(persona)+", papildv = "+cstr(papildv)+" where id = "+vv)
	
	Dim new_vals
	set new_vals = CreateDict(id_query) 
	UpdateActionDetails old_vals,new_vals,"vietu_veidi",vv,""
	
	'--- parrekina visus pieteikumus, kur ir sis vietas veids
	recalculatePieteikumiOnVietuVeidiChange vv,persona,papildv
	
	
	response.redirect "vietu_veidi.asp?gid="+cstr(gid)
end if

docstart "Pakalpojuma veida maiòa","y1.jpg" 

set rGrupa = conn.execute ("select * from grupa where id = " +cstr(gid))



%>

<%checkGroupBlocked(gid)%>

<center><font color="GREEN" size="5"><b>Pakalpojuma veida maiòa</b></font>
<br><font color="GREEN" size="5"><%=grupas_nosaukums (gid,NULL)%></font><hr>

<form name=forma method=POST>

	<% 
	sql = "select * from vietu_veidi_tipi where kods in (select tips from vietu_veidi where id = "+vv+")"
	Set r = conn.execute(sql)
	%>Paðreizçjais pakalpojuma veids:<%
	if not r.eof then
		response.write r("nosaukums")
	end if
	

	%><BR><BR>

	<select name=tips>
		<option value="">Nav norâdîts</option>
		<% 
		Set rVVT = conn.execute("select * from vietu_veidi_tipi where not kods like '%_NA' order by nosaukums") 
		While Not rVVT.eof 
		
			selected = ""
			if rVVT("kods") = r("kods") then selected = " selected " 
			
			%><option <%=selected%> value=<%=rVVT("kods")%>><%=rVVT("nosaukums")%></option><%
			rVVT.movenext
		wend
		%>
	</select>
	<input type=submit value="Nomainît">
	<input type=hidden name=subm value=1>
</form>