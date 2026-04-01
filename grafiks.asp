<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "calendar.inc" -->
<% 

'atver konektu pie datubâzes
dim Conn
OpenConn

shoferi = Request.QueryString("shoferi")

if shoferi = "1" then
	parametri = "shoferi=1"
	plid = "&lid=" + Request.QueryString("lid")
	set rUser = conn.execute ("select id, vards, uzvards from lietotaji where id = " & cstr(Request.QueryString("lid")))
else
	parametri = ""
	plid = ""
	set rUser = conn.execute ("select id, vards, uzvards from lietotaji where lietotajs = '" & get_user & "'")
end if

'ilgterminja periods
ilg_no = "1/1/2000"
ilg_lidz = "1/1/2029"

'pamata darba laiks
dl_no = "9:00"
dl_lidz = "18:00"


'docstart "Darba grafiks " +cstr(get_user),"y1.jpg"
docstart "Darba grafiks " +cstr(rUser("vards")+" "+rUser("uzvards")),"y1.jpg"

if Request.QueryString("lid") <> "" then
 set rX = conn.execute("select * from lietotaji where id = " & Request.QueryString("lid"))%>
 <center><font color="GREEN" size="5"><b>Darba grafiks <%Response.write(rX("vards")+" "+rX("uzvards"))%></b></font><hr> 
<%else%>
 <center><font color="GREEN" size="5"><b>Darba grafiks <%Response.write(rUser("vards")+" "+rUser("uzvards"))%></b></font><hr>
<% end if %>

<% 
 headlinks 
 DefJavaSubmit
%>



<%if Request.QueryString("action") = 1 then %>

 <form name="forma" method="POST">
 <p>Pievienot darba grafiku</p>
 <p>
 Tips: <select name=tips onchange="TopSubmit('grafiks.asp?action=1<%Response.Write(plid+"&"+parametri)%>')"><option value="iis" <%if Request.Form("tips") = "iis" then Response.Write "selected"%>>Îstermiòa</option><option value="gar" <%if Request.Form("tips") = "gar" then Response.Write "selected"%>>Ilgtermiòa</option></select>
 </p>
 </center>

<% if Request.Form("tips") <> "gar" then %>
 <p>
	Aktuâls:  
	No <input type=date name=aktivs_no value="<%if Request.Form("aktivs_no")<>"" and Request.Form("aktivs_no")<>ilg_no then Response.Write Request.Form("aktivs_no") else Response.Write DatePrint(now())%>">
	Lîdz <input type=date name=aktivs_lidz value="<%if Request.Form("aktivs_lidz")<>"" and Request.Form("aktivs_lidz")<>ilg_lidz then Response.Write Request.Form("aktivs_lidz") else Response.Write DatePrint(now())%>">
 </p>
 

	<p>
	<select name="iemesls" onchange="TopSubmit('grafiks.asp?action=1<%Response.Write(plid+"&"+parametri)%>')">
		<option id="0" <%if Request.Form("iemesls") = "0" then Response.Write("selected") end if %> value="0">Darba laiks</option>
		<option id="1" <%if Request.Form("iemesls") = "1" then Response.Write("selected") end if %> value="1">Nav darbâ</option>	
	</select>

	<%
	if Request.Form("iemesls") <> "1" then %>
		No <input type=date  name=atrodas_no value="<%Response.Write(dl_no)%>">
		Lîdz <input type=date name=atrodas_lidz value="<%Response.Write(dl_lidz)%>"></input>
		
	<%else%>
		<input type=hidden  name=atrodas_no value="00:00"></input>
		<input type=hidden name=atrodas_lidz value="00:00"></input>
	<%end if%>
	
	</p>

	
 <%else %>
 
	<!--hide periodu ilglaicigajam grafikam-->
 	<input type=hidden name=aktivs_no value="<%=ilg_no%>">
	<input type=hidden name=aktivs_lidz value="<%=ilg_lidz%>">

	<table>
		<tr>
			<td>Darba laiki pirmdienâs. No <input type=time name=no1 value="<%Response.Write dl_no%>"></td>
			<td>Lîdz <input type=time name=lidz1 value="<%Response.Write dl_lidz%>"></td>
		</tr>
		<tr>
			<td>Darba laiki otrdienâs. No <input type=time name=no2 value="<%Response.Write dl_no%>"></td>
			<td>Lîdz <input type=time name=lidz2 value="<%Response.Write dl_lidz%>"></td>
		<tr>
		<tr>
			<td>Darba laiki treðdienâs. No <input type=time name=no3 value="<%Response.Write dl_no%>"></td>
			<td>Lîdz <input type=time name=lidz3 value="<%Response.Write dl_lidz%>"></td>
		<tr>
		<tr>
			<td>Darba laiki ceturtdienâs. No <input type=time name=no4 value="<%Response.Write dl_no%>"></td>
			<td>Lîdz <input type=time name=lidz4 value="<%Response.Write dl_lidz%>"></td>
		<tr>
		<tr>
			<td>Darba laiki piektdienâs. No <input type=time name=no5 value="<%Response.Write dl_no%>"></td>
			<td>Lîdz <input type=time name=lidz5 value="<%Response.Write dl_lidz%>"></td>
		<tr>
		<tr>
			<td>Darba laiki sestdienâs. No <input type=time name=no6 value=""></td>
			<td>Lîdz <input type=time name=lidz6 value=""></td>
		<tr>
	</table>
 
 <% end if %>
 
 <br><br><center><input type="button" alt="Pievienot grafiku" onclick="TopSubmit('grafiks.asp?action=3&<%Response.write(parametri+plid)%>')" name=labot value="Pievienot"></center>
 
 <% if shoferi<>"1" then
 
 if (IsAccess(T_LIETOT_ADMIN) or IsAccess(T_GRAFIKS_LAB) ) then %>
  <br><br><center><input type="button" alt="Pievienot grafiku" onclick="TopSubmit('grafiks.asp?action=6')" name=labot value="Pievienot citam lietotâjam">
 
  <select name=useris>
  <%
  ''response.write("select * from lietotaji where IsNull(vards,'') <> '' and IsNull(uzvards,'') <> '' and not vards like '%TIC%' and (IsNull(tel_vietejais,'') <> 0 or IsNull(tel_arejais,'') <> 0 or IsNull(tel_mobilais,'') <> '') order by uzvards")
  set rLiet = conn.execute ("select * from lietotaji where IsNull(vards,'') <> '' and IsNull(uzvards,'') <> '' and not vards like '%TIC%' and (IsNull(tel_vietejais,'') <> '' or IsNull(tel_arejais,'') <> '' or IsNull(tel_mobilais,'') <> '') order by uzvards")
  do Until rLiet.eof
   Response.Write "<option value=" & rLiet("id") & ">" & rLiet("uzvards") & " " & rLiet("vards") & "</option>"
   rLiet.movenext
  loop
  %>
  </select>
  </center>
 
 <% elseif get_colleague<>"unknown" then %>
  <br><br><center><input type="button" alt="Pievienot grafiku" onclick="TopSubmit('grafiks.asp?action=6')" name=labot value="Pievienot citam lietotâjam">
  <select name=useris>
  <%set rLiet = conn.execute ("select vards as v, * from lietotaji where LOWER(lietotajs) = LOWER('" & get_colleague & "')")
  do Until rLiet.eof
   Response.Write "<option value=" & rLiet("id") & ">" & rLiet("uzvards") & " " & rLiet("v") & "</option>"
   rLiet.movenext
  loop
  %>
  </select>
  </center>
 <% end if
 
 end if %>
 
 
  <p><input type="image" src="impro/bildes/atpakal.bmp" alt="Atgriezties uz darba grafiku" onclick="TopSubmit('grafiks.asp?lid=<%=rUser("id")%>&<%=parametri%>')" WIDTH="25" HEIGHT="25" id=image1 name=image1></p>

 </form></body></html>
 <%
 Response.End
 
elseif Request.QueryString("action") = 2 then
 
 set rGr = conn.execute("select * from lietotaji_grafiks where id = " & Request.QueryString("id"))
 If rGr.eof then
  session("message") = "Ðâds grafiks neeksistç"
  Response.Redirect "grafiks.asp"
 end if
 %>
 
 <form name="forma" method="POST">
 <p>Labot darba grafiku</p>
 <p>Tips: <%If Trim(rGr("tips")) = "iis" then Response.Write "Îstermiòa" else response.write "Ilgtermiòa"%>
 </p>
 </center>
 <p>Aktuâls: No <input type=text name=aktivs_no value="<%=DatePrint(rGr("aktivs_no"))%>"
 >Lîdz <input type=text name=aktivs_lidz value="<%=DatePrint(rGr("aktivs_lidz"))%>">
 </p>
 
 <% if Trim(rGr("tips")) <> "gar" then %>

	<p>
	<select name="iemesls" onchange="TopSubmit('grafiks.asp?action=2&id=<%=rGr("id")%>&<%Response.write(parametri+plid)%>')">
		<option id="0" <%if Request.Form("iemesls") = "0" or (rGr("atrodas_no") <> "" and Hour(rGr("atrodas_no")) <> 0) then Response.Write("selected") end if %> value="0">Darba laiks</option>
		<option id="1" <%if Request.Form("iemesls") = "1" or (Request.Form("iemesls") <> "0" and Hour(rGr("atrodas_no")) = 0 and Hour(rGr("atrodas_lidz")) = 0) then Response.Write("selected") end if %> value="1">Nav darbâ</option>	
	</select>

	<%if Request.Form("iemesls") = "0" or (Request.Form("iemesls") <> "1" and rGr("atrodas_no") <> "" and Hour(rGr("atrodas_no")) <> 0) then %>

		No <input type=date name=atrodas_no value="<%if rGr("atrodas_no") <> "" and Hour(rGr("atrodas_no")) <> 0 then Response.write TwoDigits(Hour(rGr("atrodas_no"))) & ":" & TwoDigits(Minute(rGr("atrodas_no")))%>"></input>
		Lîdz <input type=date name=atrodas_lidz value="<%if rGr("atrodas_lidz") <> "" and Hour(rGr("atrodas_lidz")) <> 0 then Response.write TwoDigits(Hour(rGr("atrodas_lidz"))) & ":" & TwoDigits(Minute(rGr("atrodas_lidz")))%>"></input>

	<%else%>
		<input type=hidden name=atrodas_no value="00:00"></input>
		<input type=hidden name=atrodas_lidz value="00:00"></input>
	<%end if%>
	
	</p>
	
 <% else %>
	Darba laiki pirmdienâs. No <input type=time name=no1 value=
	"<%if rGr("1_no") <> "" and Hour(rGr("1_no")) then Response.write TwoDigits(Hour(rGr("1_no"))) & ":" & TwoDigits(Minute(rGr("1_no")))%>"
	>Lîdz <input type=time name=lidz1 value=
	"<%if rGr("1_lidz") <> "" and Hour(rGr("1_lidz")) then Response.write TwoDigits(Hour(rGr("1_lidz"))) & ":" & TwoDigits(Minute(rGr("1_lidz")))%>"
	>
	<br>Darba laiki otrdienâs. No <input type=time name=no2 value=
	"<%if rGr("2_no") <> "" and Hour(rGr("2_no")) then Response.write TwoDigits(Hour(rGr("2_no"))) & ":" & TwoDigits(Minute(rGr("2_no")))%>"
	>Lîdz <input type=time name=lidz2 value=
	"<%if rGr("2_lidz") <> "" and Hour(rGr("2_lidz")) then Response.write TwoDigits(Hour(rGr("2_lidz"))) & ":" & TwoDigits(Minute(rGr("2_lidz")))%>"
	>
	<br>Darba laiki treðdienâs. No <input type=time name=no3 value=
	"<%if rGr("3_no") <> "" and Hour(rGr("3_no")) then Response.write TwoDigits(Hour(rGr("3_no"))) & ":" & TwoDigits(Minute(rGr("3_no")))%>"
	>Lîdz <input type=time name=lidz3 value=
	"<%if rGr("3_lidz") <> "" and Hour(rGr("3_lidz")) then Response.write TwoDigits(Hour(rGr("3_lidz"))) & ":" & TwoDigits(Minute(rGr("3_lidz")))%>"
	>
	<br>Darba laiki ceturtdienâs. No <input type=time name=no4 value=
	"<%if rGr("4_no") <> "" and Hour(rGr("4_no")) then Response.write TwoDigits(Hour(rGr("4_no"))) & ":" & TwoDigits(Minute(rGr("4_no")))%>"
	>Lîdz <input type=time name=lidz4 value=
	"<%if rGr("4_lidz") <> "" and Hour(rGr("4_lidz")) then Response.write TwoDigits(Hour(rGr("4_lidz"))) & ":" & TwoDigits(Minute(rGr("4_lidz")))%>"
	>
	<br>Darba laiki piektdienâs. No <input type=time name=no5 value=
	"<%if rGr("5_no") <> "" and Hour(rGr("5_no")) then Response.write TwoDigits(Hour(rGr("5_no"))) & ":" & TwoDigits(Minute(rGr("5_no")))%>"
	>Lîdz <input type=time name=lidz5 value=
	"<%if rGr("5_lidz") <> "" and Hour(rGr("5_lidz")) then Response.write TwoDigits(Hour(rGr("5_lidz"))) & ":" & TwoDigits(Minute(rGr("5_lidz")))%>"
	>
	<br>Darba laiki sestdienâs. No <input type=time name=no6 value=
	"<%if rGr("6_no") <> "" and Hour(rGr("6_no")) then Response.write TwoDigits(Hour(rGr("6_no"))) & ":" & TwoDigits(Minute(rGr("6_no")))%>"
	>Lîdz <input type=time name=lidz6 value=
	"<%if rGr("6_lidz") <> "" and Hour(rGr("6_lidz")) then Response.write TwoDigits(Hour(rGr("6_lidz"))) & ":" & TwoDigits(Minute(rGr("6_lidz")))%>"
	>
 <% end if %>
 <br><br><center><input type="button" alt="Saglabât grafiku" onclick="TopSubmit('grafiks.asp?action=4&id=<%=Request.QueryString("id")%>&lid=<%=rUser("id")%>&<%Response.write(parametri)%>')" name=labot value="Saglabât"></center> <%'rGr("lietotajs_id")%>
 <p><input type="image" src="impro/bildes/atpakal.bmp" alt="Atgriezties uz darba grafiku" onclick="TopSubmit('grafiks.asp?lid=<%=rUser("id")%>&<%Response.write(parametri)%>')" WIDTH="25" HEIGHT="25" id=image1 name=image1></p>

 </form></body></html>
 <%
 Response.End

'--- pievieno grafiku
elseif Request.QueryString("action") = 3 then 
 
	set rGr = conn.execute ("select IsNull(max(id),0) as maxid from lietotaji_grafiks")
	if shoferi = "1" then
		set rUser = conn.execute ("select id from lietotaji where id = " & Request.QueryString("lid") )
	else
		set rUser = conn.execute ("select id from lietotaji where lietotajs = '" & get_user & "'")
	end if
	
	if Request.Form("tips")="iis" and Request.Form("atrodas_no")="00:00" and Request.Form("atrodas_lidz")="00:00" then 
		nov="N" 
	else
		nov=""	
	end if
 
	conn.execute ("insert into lietotaji_grafiks (id,lietotajs_id,tips,aktivs_no,aktivs_lidz,atrodas_no,atrodas_lidz,[1_no],[1_lidz],[2_no],[2_lidz],[3_no],[3_lidz],[4_no],[4_lidz],[5_no],[5_lidz],[6_no],[6_lidz],novertejums) VALUES " & _
	"(" & rGr("maxid") + 1 & "," & rUser("id") & ",'" & Request.Form("tips") & "','" & SQLDate(Request.Form("aktivs_no")) & "','" & SQLDate(Request.Form("aktivs_lidz")) & "','" & Request.Form("atrodas_no") & "','" & Request.Form("atrodas_lidz") & "','" & Request.Form("no1") & "','" & _
	Request.Form("lidz1") & "','" & Request.Form("no2") & "','" & Request.Form("lidz2") & "','" & Request.Form("no3") & "','" & Request.Form("lidz3") & "','" & Request.Form("no4") & "','" & Request.Form("lidz4") & "','" & Request.Form("no5") & "','" & Request.Form("lidz5") & "','" & Request.Form("no6") & "','" & Request.Form("lidz6") & "','" & nov & "')")
 
	session("message") = "Grafiks pievienots veiksmîgi"
	Response.Redirect("grafiks.asp?lid=" & rUser("id") & "&" & parametri)

'--- labo grafiku
elseif Request.QueryString("action") = 4 then 
 
 if Request.Form("atrodas_no")="00:00" and Request.Form("atrodas_lidz")="00:00" then 
	nov="N" 
 else
	nov=""	
 end if
 conn.execute ("update lietotaji_grafiks set aktivs_no = '" & SQLDate(Request.Form("aktivs_no")) & "', aktivs_lidz = '" & _
 SQLDate(Request.Form("aktivs_lidz")) & "', atrodas_no = '" & Request.Form("atrodas_no") & "', atrodas_lidz = '" & _
 Request.Form("atrodas_lidz") & "', [1_no] = '" & Request.Form("no1") & "', [2_no] = '" & Request.Form("no2") & _
 "', [3_no] = '" & Request.Form("no3") & "', [4_no] = '" & Request.Form("no4") & "', [5_no] = '" & Request.Form("no5") & _
 "', [6_no] = '" & Request.Form("no6") & "', [1_lidz] = '" & Request.Form("lidz1") & "', [2_lidz] = '" & Request.Form("lidz2") & _
 "', [3_lidz] = '" & Request.Form("lidz3") & "', [4_lidz] = '" & Request.Form("lidz4") & "', [5_lidz] = '" & Request.Form("lidz5") & _
 "', [6_lidz] = '" & Request.Form("lidz6") & "', novertejums = '"&nov&"'  where id = " & Request.QueryString("id"))
 session("message") = "Grafiks saglabâts veiksmîgi"
 Response.Redirect ("grafiks.asp?lid="&Request.QueryString("lid")&"&"&parametri)
 
elseif Request.QueryString("action") = 5 then '--- dzeesh grafiku

 conn.execute("delete from lietotaji_grafiks where id = " & Request.QueryString("id"))
 'conn.execute("UPDATE lietotaji_prombutne SET prom_lidz = '" & SQLTime(Now) & "' WHERE grid =" & rGrafiks("id") & " and prom_lidz='" & SQLTime(rGrafiks("atrodas_no")) & "'")
 session("message") = "Grafiks dzçsts veiksmîgi"
 Response.Redirect("grafiks.asp?lid="&Request.QueryString("lid")&"&"&parametri)

 
elseif Request.QueryString("action") = 6 then '--- pievieno grafiku citam lietotajam

 set rGr = conn.execute ("select IsNull(max(id),0) as maxid from lietotaji_grafiks")
 set rUser = conn.execute ("select id from lietotaji where id = '" & Request.Form("useris") & "'")
 if Request.Form("tips")="iis" and Request.Form("atrodas_no")="00:00" and Request.Form("atrodas_lidz")="00:00" then 
	nov="N" 
 else
	nov=""	
 end if
 conn.execute ("insert into lietotaji_grafiks (id,lietotajs_id,tips,aktivs_no,aktivs_lidz,atrodas_no,atrodas_lidz,[1_no],[1_lidz],[2_no],[2_lidz],[3_no],[3_lidz],[4_no],[4_lidz],[5_no],[5_lidz],[6_no],[6_lidz],novertejums) VALUES " & _
 "(" & rGr("maxid") + 1 & "," & rUser("id") & ",'" & Request.Form("tips") & "','" & SQLDate(Request.Form("aktivs_no")) & "','" & SQLDate(Request.Form("aktivs_lidz")) & "','" & Request.Form("atrodas_no") & "','" & Request.Form("atrodas_lidz") & "','" & Request.Form("no1") & "','" & _
 Request.Form("lidz1") & "','" & Request.Form("no2") & "','" & Request.Form("lidz2") & "','" & Request.Form("no3") & "','" & Request.Form("lidz3") & "','" & Request.Form("no4") & "','" & Request.Form("lidz4") & "','" & Request.Form("no5") & "','" & Request.Form("lidz5") & "','" & Request.Form("no6") & "','" & Request.Form("lidz6") & "','"& nov &"')")
 session("message") = "Grafiks pievienots veiksmîgi"
 Response.Redirect("grafiks.asp?lid=" & rUser("id"))
 

elseif Request.QueryString("action") = 7 then '--- noveerteeshana

 conn.execute ("update lietotaji_grafiks set novertejums = '"& Request.QueryString("nov") &"' where id = "& Request.QueryString("id"))
 Response.Redirect("grafiks.asp?lid="&Request.QueryString("lid")&"&"&parametri)
end if

if session("message") <> "" then %>
<br><font size="5" color="red"><%=session("message")%></font><br>
<%
session("message") = "" 
end if
%>

<form name="forma" method="POST">
<center>
<%
if isaccess(T_LIETOT_ADMIN) or isaccess(T_GRAFIKS_LAB) then
 qGrafiks = "SELECT L.id, lietotaji_grafiks.id as grid, lietotaji_grafiks.novertejums, L.lietotajs, L.vards, L.uzvards, L.epasts, tips, aktivs_no, aktivs_lidz, atrodas_no, atrodas_lidz, " & _
 "[1_no] as no1, [1_lidz] as lidz1, [2_no] as no2, [2_lidz] as lidz2, [3_no] as no3, [3_lidz] as lidz3, [4_no] as no4, [4_lidz] as lidz4, [5_no] as no5, [5_lidz] as lidz5, [6_no] as no6, [6_lidz] as lidz6 " & _
 "FROM lietotaji L inner join lietotaji_grafiks on lietotajs_id = L.id where ('" & SQLDate(Now()) & "' <= aktivs_lidz or (aktivs_no >= '5/1/2006' and novertejums = 'N'))" 
else
 qGrafiks = "SELECT L.id, lietotaji_grafiks.id as grid,lietotaji_grafiks.novertejums, L.lietotajs, L.vards, L.uzvards, L.epasts, tips, aktivs_no, aktivs_lidz, atrodas_no, atrodas_lidz, " & _
 "[1_no] as no1, [1_lidz] as lidz1, [2_no] as no2, [2_lidz] as lidz2, [3_no] as no3, [3_lidz] as lidz3, [4_no] as no4, [4_lidz] as lidz4, [5_no] as no5, [5_lidz] as lidz5, [6_no] as no6, [6_lidz] as lidz6 " & _
 "FROM lietotaji L inner join lietotaji_grafiks on lietotajs_id = L.id where '" & SQLDate(Now()) & "' <= aktivs_lidz"
end if
if Request.QueryString("lid") <> "" then
 qGrafiks = qGrafiks & " AND L.id = " & Request.QueryString("lid")
end if
qGrafiks = qGrafiks & " ORDER BY L.uzvards, aktivs_no, aktivs_lidz"
set rGrafiks = conn.execute (qGrafiks)

'rw qGrafiks


%>
<p>
Uz saîsinâto darba grafiku <input type="image" src="impro/bildes/atpakal.bmp" alt="Atgriezties uz saîsinâto darba grafiku" onclick="TopSubmit('grafiks_sais.asp?<%=parametri%>')" WIDTH="25" HEIGHT="25" id=image1 name=image1>
</p>
<%if  LCase(rX("lietotajs"))= LCase(get_user) or (IsAccess(T_GRAFIKS_SHOF)and(shoferi="1")) then 'or isaccess(T_LIETOT_ADMIN) or isaccess(T_GRAFIKS_LAB)%>
	<p>Pievienot jaunu darba grafiku <input type="image" src="impro/bildes/pievienot.jpg" alt="Pievienot jaunu grafiku" onclick="TopSubmit('grafiks.asp?action=1&<%Response.Write(parametri+plid)%>')" WIDTH="25" HEIGHT="25" id=image1 name=image1>
<%end if%>

</p>
<table>
<tr bgcolor = #ffC1cc>
<th width=2%>Uzvârds, Vârds</th>
<th>Tips</th>
<th>Laiki</th><!--th>Laiki (ðodien)</th-->
<th>Aktuâls</th>
<th>Pirmdien</th>
<th>Otrdien</th>
<th>Treðdien</th>
<th>Ceturtdien</th>
<th>Piektdien</th>
<th>Sestdien</th>
<th>.</th>
</tr>
<% 
cnt = 0
do while not rGrafiks.eof
Response.Write "<tr bgcolor = #fff1cc>"
Response.Write("<td>" & rGrafiks("uzvards") & ", " & rGrafiks("vards") & "</td>")
 
 if trim(rGrafiks("tips")) = "iis" then
 
	Response.Write "<td>Îstermiòa</td>"
	if rGrafiks("atrodas_lidz") <> "" and Hour(rGrafiks("atrodas_lidz")) <> 0 then
	 Response.Write "<td>" & TwoDigits(Hour(rGrafiks("atrodas_no"))) & ":" & TwoDigits(Minute(rGrafiks("atrodas_no"))) & " - " & _
	 TwoDigits(Hour(rGrafiks("atrodas_lidz"))) & ":" & TwoDigits(Minute(rGrafiks("atrodas_lidz"))) & "</td>"
	elseif Hour(rGrafiks("atrodas_no")) = 0 and Hour(rGrafiks("atrodas_lidz")) = 0 then
	 Response.Write "<td><font color=red>nebûs</td>"
	else
	 Response.Write "<td><font color=gray>Bûs " & TwoDigits(Hour(rGrafiks("atrodas_no"))) & ":" & TwoDigits(Minute(rGrafiks("atrodas_no"))) & "</td>"
	end if
	Response.Write "<td>" & DatePrint(rGrafiks("aktivs_no")) & "-" & DatePrint(rGrafiks("aktivs_lidz")) & "</td>"
  
	 if Hour(rGrafiks("atrodas_no")) = 0 and Hour(rGrafiks("atrodas_lidz")) = 0 then
	 cnt = cnt + 1
	 %>
		<td>
		<select name="novertejums<%=cnt%>" <% if IsAccess(T_LIETOT_ADMIN)=false and IsAccess(T_GRAFIKS_LAB)=false then response.write("disabled")%> onchange="javascript: this.form.novertet<%=cnt%>.disabled = false">
			<option id="0" <%if rGrafiks("novertejums") = "N" then Response.Write("selected") end if %> value="N">-</option>	
			<option id="1" <%if rGrafiks("novertejums") = "K" then Response.Write("selected") end if %> value="K">Komandçjums</option>	
			<option id="2" <%if rGrafiks("novertejums") = "A" then Response.Write("selected") end if %> value="A">Atvaïinâjums</option> 
			<option id="3" <%if rGrafiks("novertejums") = "S" then Response.Write("selected") end if %> value="S">Slimîba</option>
			<option id="4" <%if rGrafiks("novertejums") = "B" then Response.Write("selected") end if %> value="B">Bezalgas atvaïinâjums</option> 		
		</select>	
		</td>
		<td colspan=5 align=left>
			<input type="button" name="novertet<%=cnt%>" value="Saglabât" disabled onclick="TopSubmit('grafiks.asp?action=7&id=<%=rGrafiks("grid")%>&lid=<%=Request.QueryString("lid")%>&nov='+this.form.novertejums<%=cnt%>.value+'&<%=parametri%>')">
		</td>
	<%
	else
		Response.Write "<td colspan = 6></td>"
	end if
 
elseif trim(rGrafiks("tips")) = "gar" then

  Response.Write "<td>Ilgtermiòa</td><td align=center> >> </td>"
  'Response.Write "<td>" & DatePrint(rGrafiks("aktivs_no")) & "-" & DatePrint(rGrafiks("aktivs_lidz")) & "</td>"
  Response.Write "<td align=center></td>"
  cells = 0
  if rGrafiks("no1") <> "" and rGrafiks("lidz1") <> ""  and Hour(rGrafiks("no1")) <> 0 then 
   Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no1"))) & ":" & TwoDigits(Minute(rGrafiks("no1"))) & " - " & _
   TwoDigits(Hour(rGrafiks("lidz1"))) & ":" & TwoDigits(Minute(rGrafiks("lidz1"))) & "</td>"
  else
   Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  if rGrafiks("no2") <> "" and rGrafiks("lidz2") <> "" and Hour(rGrafiks("no2")) <> 0 then 
  Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no2"))) & ":" & TwoDigits(Minute(rGrafiks("no2"))) & " - " & _
  TwoDigits(Hour(rGrafiks("lidz2"))) & ":" & TwoDigits(Minute(rGrafiks("lidz2"))) & "</td>"
  else
   Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  if rGrafiks("no3") <> "" and rGrafiks("lidz3") <> "" and Hour(rGrafiks("no3")) <> 0 then 
  Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no3"))) & ":" & TwoDigits(Minute(rGrafiks("no3"))) & " - " & _
  TwoDigits(Hour(rGrafiks("lidz3"))) & ":" & TwoDigits(Minute(rGrafiks("lidz3"))) & "</td>"
  else
	Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  if rGrafiks("no4") <> "" and rGrafiks("lidz4") <> "" and Hour(rGrafiks("no4")) <> 0 then 
  Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no4"))) & ":" & TwoDigits(Minute(rGrafiks("no4"))) & " - " & _
  TwoDigits(Hour(rGrafiks("lidz4"))) & ":" & TwoDigits(Minute(rGrafiks("lidz4"))) & "</td>"
  else
  Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  if rGrafiks("no5") <> "" and rGrafiks("lidz5") <> "" and Hour(rGrafiks("no5")) <> 0 then 
  Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no5"))) & ":" & TwoDigits(Minute(rGrafiks("no5"))) & " - " & _
  TwoDigits(Hour(rGrafiks("lidz5"))) & ":" & TwoDigits(Minute(rGrafiks("lidz5"))) & "</td>"
  else
  Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  if rGrafiks("no6") <> "" and rGrafiks("lidz6") <> "" and Hour(rGrafiks("no6")) <> 0 then 
  Response.Write "<td>" & TwoDigits(Hour(rGrafiks("no6"))) & ":" & TwoDigits(Minute(rGrafiks("no6"))) & " - " & _
  TwoDigits(Hour(rGrafiks("lidz6"))) & ":" & TwoDigits(Minute(rGrafiks("lidz6"))) & "</td>"
  else
  Response.Write "<td>-</td>"
   cells = cells + 1
  end if
  'do while cells > 0
  ' Response.Write "<td></td>"
  ' cells = cells - 1
  'loop
 end if
 
 
 'if (LCase(rGrafiks("lietotajs")) = LCase(get_user) or isaccess(T_LIETOT_ADMIN) or isaccess(T_GRAFIKS_LAB) or LCase(rGrafiks("lietotajs")) = LCase(get_colleague)) and SQLDate(rGrafiks("aktivs_lidz")) >= SQLDate(Now) then
 'if ((LCase(rGrafiks("lietotajs"))= LCase(get_user) or LCase(rGrafiks("lietotajs")) = LCase(get_colleague)) or isaccess(T_LIETOT_ADMIN) or isaccess(T_GRAFIKS_LAB)) then   
 
 'Response.Write(DateDiff("D", SQLDate(rGrafiks("aktivs_lidz")), SQLDate(Now)))



 if ( (LCase(rGrafiks("lietotajs"))= LCase(get_user) or LCase(rGrafiks("lietotajs")) = LCase(get_colleague) or isaccess(T_LIETOT_ADMIN) or isaccess(T_GRAFIKS_LAB)) and not (Hour(rGrafiks("atrodas_no")) <> 0 and Hour(rGrafiks("atrodas_lidz")) = 0) ) then %>
	<td nowrap><input type="button" alt="Labot grafiku" onclick="TopSubmit('grafiks.asp?action=2&id=<%=rGrafiks("grid")%>&<%Response.write(parametri+plid)%>')" name=labot value="Labot">
	<input type="button" alt="Dzçst grafiku" onclick="if (confirm('Dzçst ðo darba grafiku?')) { TopSubmit('grafiks.asp?action=5&id=<%=rGrafiks("grid")%>&lid=<%=rGrafiks("id")%>&<%=parametri%>')}" name=dzest value="Dzçst"></td>
 <%else%>
	<td></td>
 <%
 end if
Response.Write "</tr>"
rGrafiks.movenext
loop%>

</table>

<%if isaccess(T_LIETOT_ADMIN) or IsAccess(T_GRAFIKS_LAB) then%>

	<p><h2>Darbalaika vçsture<h2></p>
<%

'--- KALENDAARS

dim current_date, first_day, this_date
dim counter,days, weeks, current_year

' Create an array to display the month names
dim month_name(12)
month_name(1)="Janvâris "
month_name(2)="Februâris "
month_name(3)="Marts "
month_name(4)="Aprîlis "
month_name(5)="Maijs "
month_name(6)="Jûnijs "
month_name(7)="Jûlijs "
month_name(8)="Augusts "
month_name(9)="Septembris "
month_name(10)="Oktobris "
month_name(11)="Novembris "
month_name(12)="Decembris "

' create a varible for the current date
current_date=date() 

' create a varible for the current year from the current date
current_year=year(current_date)

' create a varible for the current day from the current date
this_date=day(current_date)

' create a varible for the current month from the current date
month_number=month(current_date)

' create a varible for the first day from the current date
first_day=weekday(dateSerial(current_year,month_number,1))


' create a varible for the length of the current month
select case month_number

	' For the months with 31 days set the end date
	case "1","3","5","7","8","10","12"
		last_day=31

	' For February set the end date by applying the leap year rules
	' if the year is evenly divisable by 4 or ending in 00 divisable by 400
	case "2"
		last_day=28

		right_year_divided=current_year/4
		if right_year_divided = cint(right_year_divided) then 
		last_day=29
		end if 

		if right(current_year,2)="00" then 
		right_year_divided=current_year/400

		if right_year_divided = cint(right_year_divided) then 
		last_day=29
		end if ' end check of year values
		end if ' end check for new century

	' All the rest of the months have 30 days
	case else
		last_day=30

end select ' end selct of month 

%><html>
<body bgcolor="#FFFFFF">
<table border=1 align=center>
<caption><b><%= month_name(month_number) & current_year %></b></caption>
<tr><th>Pirmdiena</th><th>Otrdiena</th><th>Treðdiena</th><th>Ceturtdiena</th>
<th>Piektdiena</th><th>Sestdiena</th><th>Svçtdiena</th></tr>
<tr>
<%
days = 1
' Loop for the 1st week of the month
for counter = 1 to 7
	%><td<%
' Check to see what day the first of the month falls on
if counter > first_day - 1 then 

	
	' Count for days
	days=days+1
	calendarDate = cstr(days) + "/" + cstr(month_number) + "/" + cstr(current_year)

	' rw calendarDate

	' Check to see if the current date is in the 1st week
	' if so place it in bold type
	if days=this_date then 
		%> bgcolor="#aaaaaa"><%
		response.write "<font color=white><b>" & days & "</b></font><br>" & getDarbaLaiks(rX("id"),calendarDate) & _
		"<br>Promb:" & getPrombutnesLaiks(rX("id"),calendarDate)
	else
		%> bgcolor="#eeeeee"><%
		response.write "<font color=black><b>" & days & "</b></font><br>" & getDarbaLaiks(rX("id"),calendarDate) & _
		"<br>Promb:" & getPrombutnesLaiks(rX("id"),calendarDate)
	end if ' End check for current date


 

else
	%>><%


end if ' End check for first day of the week 

	%></td><% 

next %>
</tr>
<%
' Loop for the remaining weeks in the month
for weeks = 1 to 5 %>
<tr>
<% 
' Loop of the remaing days of the month
for counter = 1 to 7 

' Count for days
days=days+1

calendarDate = cstr(days) + "/" + cstr(month_number) + "/" + cstr(current_year)

' Write out the date and place in bold if it's the current date
if days <= last_day then
 
if days=this_date then 
%><td bgcolor="#aaaaaa"><%
response.write "<b><font color=white>" & days & "</font></b><br>" & getDarbaLaiks(rX("id"),calendarDate) & _
				"<br>Promb:" & getPrombutnesLaiks(rX("id"),calendarDate)
else
%><td bgcolor="#eeeeee"><%
response.write "<b><font color=black>" & days & "</font></b><br>" & getDarbaLaiks(rX("id"),calendarDate) & _
				"<br>Promb:" & getPrombutnesLaiks(rX("id"),calendarDate)
end if ' End check for current date
%></td>
<% end if ' End check for end of month 
next %>
</tr><% 
next %>
</table>

<%
end if
%>

</form>
</body>
</html>


