<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<% 

'atver konektu pie datubâzes
dim Conn
OpenConn

shoferi = Request.QueryString("shoferi")



function crtime (dt)
 If cint(Hour(dt)) <> 0 then
  crtime = TwoDigits(Hour(dt)) & ":" & TwoDigits(Minute(dt))
 end if
end function


set rL = conn.execute ("select id, vards, uzvards from lietotaji where lietotajs = '" & cstr(get_user) & "'") 

if shoferi = "1" then
	pTitle = "Atgriezties uz darba grafiku"
	pLink = "grafiks_sais.asp"
	pHeader = "Autobusu ðoferu kontakti"
	parametri = "shoferi=1"
	whereC = "info like 'ðoferis' and"
else
	pTitle = "Uz pilno darba grafiku"
	pLink = "grafiks.asp?lid=" + cstr(rL("id"))
	pHeader = "Saîsinâtais darba grafiks " + rL("vards") + " " + rL("uzvards")
	parametri = ""
	whereC = "not info like 'ðoferis' and"	
end if



response.write "<!DOCTYPE HTML PUBLIC "+chr(34)+"-//IETF//DTD HTML//EN"+chr(34)+">"
response.write "<html>"

response.write "<head>"
response.write "<meta http-equiv='Content-Type' "
response.write "content= 'text/html; charset=windows-1257'>"
response.write "<link rel=stylesheet type='text/css' href='styles.css'><style type='text/css'></style>"
response.write "<title>" + pHeader + "</title>"

'--- refresh pec 2 min

response.Write "<META HTTP-EQUIV='refresh' content='120;URL=grafiks_sais.asp?"+parametri+"'>"
response.write "</head>"

response.write "<body background='y1.jpg' text="+chr(34)+"#000000"+chr(34)+""
response.write "link="+chr(34)+"#008040"+chr(34)+" vlink="+chr(34)+"#804000"+chr(34)+" alink="+chr(34)+"#FF0000"+chr(34)+">"

%>
<center><font color="GREEN" size="5"><b><%=pHeader%></b></font><hr>
<% headlinks 
DefJavaSubmit

'--- lietotaja status karogs
uzvietas = false
 

%>
<%

if Request.QueryString("action") = 1 then
	
 if Request.QueryString("liet") = "cits" then
	lid = Request.Form("useris")
 else
	lid = rL("id")
 end if

 set rGr = conn.execute ("select max(id) as maxid from lietotaji_grafiks")

 '--- "iziet lidz dienas beigaam" apstraade
prom_lidz = Request.Form("iziet")
 
 if prom_lidz = 999 then
 
 	prom_lidz = SQLDate(Now())+ " " + Request.Form("liidz_"+cstr(lid)) '---" 23:59"
 	prom_lidz_uzsk = SQLDate(Now())+ " " + Request.Form("liidz_"+cstr(lid)) 
 	 	 
 else
	
	prom_lidz = SQLTime(DateAdd("n", Request.Form("iziet"), Now()))
	prom_lidz_uzsk = prom_lidz
	
 end if
 
'--- lietotaji_prombutne tabulaa uzskaitaas laiks, ko atteelo darba laika veesturee
 ssql = "insert into lietotaji_prombutne (lid, grid, datums, prom_no, prom_lidz) " & _
 "VALUES (" & cstr(lid) & "," & rGr("maxid") + 1 & ",'" & SQLDate(Now) & "','" & SQLTime(Now) & "','" & prom_lidz_uzsk &"')"
 conn.execute(ssql)

'--- lietotaji_grafiks tabula satur informaaciju par darba laiku un lietotaaja statusu darba laikaa
 ssql = "insert into lietotaji_grafiks (id, lietotajs_id, tips, aktivs_no, aktivs_lidz, atrodas_no, atrodas_lidz)" & _
 " VALUES (" & rGr("maxid") + 1 & "," & cstr(lid) & ",'iis','" & SQLDate(Now()) & "','" & SQLDate(Now()) & "','" & prom_lidz & "',null)"
 conn.execute(ssql)

 session("message") = "Atgrieðanâs laiks pievienots"
 Response.redirect("grafiks_sais.asp")
 
'--- atgriezties  
elseif Request.QueryString("action") = 2 then

 set rL = conn.execute ("select id from lietotaji where lietotajs = '" & cstr(get_user) & "'")
 
 ssql = "select id, atrodas_no from lietotaji_grafiks "&_
		"where lietotajs_id = " & rL("id") & " AND '" & SQLDate(Now()) & "' = aktivs_no "&_
		"AND aktivs_no = aktivs_lidz AND IsNull(atrodas_no,0) <> 0 AND IsNull(atrodas_lidz,0) = 0 and tips = 'iis'"
 
 set rGrafiks = conn.execute(ssql)
 
 'Response.Write(ssql)
 'Response.End
  
 if not rGrafiks.eof then
	
	ssql = "DELETE FROM lietotaji_grafiks WHERE id =" & cstr(rGrafiks("id"))
	conn.execute(ssql)

	ssql = "UPDATE lietotaji_prombutne SET prom_lidz = '" & SQLTime(Now) & "' WHERE grid =" & rGrafiks("id") & " and prom_lidz='" & SQLTime(rGrafiks("atrodas_no")) & "'"
	conn.execute(ssql)

 end if

 Response.redirect("grafiks_sais.asp")
end if

if session("message") <> "" then %>
<br><font size="5" color="red"><%=session("message")%></font><br>
<%
session("message") = "" 
end if
%>

<%


'qLietotaji = "select lietotaji.id, lietotajs, vards, uzvards,epasts, tel_vietejais, tel_mobilais, tel_arejais from lietotaji where " + whereC + " IsNull(vards,'') <> '' and not vards like '%TIC%' and (IsNull(tel_vietejais,0) <> 0 or IsNull(tel_arejais,0) <> 0 or IsNull(tel_mobilais,0) <> 0) order by uzvards"
if shoferi = "1" then
	qLietotaji = "select * from LietotajiGrafikamSoferi "
else
	qLietotaji = "select * from LietotajiGrafikam "
end if

set rLietotaji = conn.execute(qLietotaji)

%>

<%session.lcid=1062%>

<form name="forma" method="POST">
<center>
<table><tr>
<% if (IsAccess(T_LIETOT_ADMIN) or IsAccess(T_GRAFIKS_LAB) or IsAccess(T_GRAFIKS_SHOF)) and shoferi<>"1" then %>

	

	<td align=center><%=pTitle%>&nbsp;&nbsp;<input type="image" src="impro/bildes/turpinat.bmp" onclick="TopSubmit('<%=pLink%>')" WIDTH="25" HEIGHT="25" id=image1 name=image1>
	<br><br>
	</td>
	</tr>

	<tr>
	<td align=center><a href="kavejumi.asp">Kavçjumu kopsavilkums</a>
		&nbsp;/&nbsp;

<% else %>	<td align=center>
<% end if

if shoferi<>"1" then %>

	<a href="grafiks_sais.asp?shoferi=1">Autobusu ðoferi</a>
	&nbsp;/&nbsp;
	<a href="kontakti_grupu_vaditaji.asp">Grupu vadîtâji</a>
		<br><br>
	</td>
<% else %>	<td></td>	
<% end if %>
</tr>

<%if shoferi <> "1" then%>
<tr>
<td><%Response.Write(FormatDateTime(now,1))%></td>
</tr>
<tr>
<td align="center">
	Iziet uz <select name="iziet" onchange="laix_refresh();">
	<option value="15">15 minûtçm</option>
	<option value="30">30 minûtçm</option>
	<option value="45">45 minûtçm</option>
	<option value="60">1 stundu</option>
	<option value="90">1.5 stundu</option>
	<option value="120">2 stundâm</option>
	<option value="150">2.5 stundâm</option>	
	<option value="180">3 stundâm</option>
	<option value="210">3.5 stundâm</option>
	<option value="240">4 stundâm</option>
	<option value="999">Lîdz rîtam</option>
	</select>
	<input type=hidden name=laix value="">
	Atgrieðanâs laiks <input type=text size=2 readonly name=stunda value="<%=hr%>">:<input type=text name=minute readonly size=2 value="<%=mn%>">
	<input type="button" alt="Iziet" onclick="javascript: if(document.forma.uzvietas.value=='True'){TopSubmit('grafiks_sais.asp?action=1');}else{alert('Lietotâjs nav uz vietas!');}" name=iz value="Iziet">
	&nbsp;&nbsp;&nbsp;
	<% if IsAccess(T_LIETOT_ADMIN) or IsAccess(T_GRAFIKS_LAB) then %>
  
		<select name=useris>
			<option value="0">-</option>
		<%	set rLiet = conn.execute ("select vards as v, * from lietotaji where IsNull(vards,'') <> '' and IsNull(uzvards,'') <> '' and lietotajs not like '%TIC%' and active = 1 and isnull(tel_vietejais,'')<>'' order by uzvards")
			do Until rLiet.eof
				Response.Write "<option value=" & rLiet("id") & ">" + cstr(rLiet("uzvards")) + " " + cstr(rLiet("v")) +  "</option>"
				rLiet.movenext
			loop
		%>
		</select>
		<input type="button" alt="Reìistrçt cita lietotâja izieðanu" onclick="javascript: if(this.form.useris.value!='0'){TopSubmit('grafiks_sais.asp?action=1&liet=cits');}else{alert('Izvçlçties lietotâju!');}" name=iz_cits value="Iziet cita vietâ">

	<%end if%>
	<!---->
</td></tr>
<%end if%>
</table>

<% if shoferi = "1" then %>
<a href="grafiks_sais.asp">Atgriezties</a>
<% end if%>

<br><br>
<table>
<tr bgcolor = #ffC1cc>
<% if shoferi = "1" then %>
<th>NPK</th>
<% end if%>
<th nowrap>Uzvârds, Vârds</th>
<% if shoferi <> "1" then %>
<th>E-pasts</th>
<% end if%>
<th>Vietçjais tel</th>
<th>Ârçjais tel</th>
<th>Mobilais tel</th>
<% if shoferi <> "1" then %>
<th>Uz vietas</th>
<th>Kad bûs</th>
<th>Darba laiks</th>
<th>.</th>
<% end if%>
</tr>
<%

cnt = 0
do while not rLietotaji.eof
 
 cnt = cnt + 1
 
 if lcase(rLietotaji("lietotajs"))=lcase(get_user) then
	pbold = "<b>"
	pbold_close = "</b>"
 else
	pbold = ""
	pbold_close = ""
 end if
	
 Response.Write "<tr bgcolor = #fff1cc>"
 
 if shoferi = "1" then
	Response.Write("<td>"&cnt&"</td><td>"& pbold & rLietotaji("uzvards") &" "& rLietotaji("vards") & pbold_close&"</td>")
	Response.Write "<td>" & rLietotaji("tel_vietejais") & "</td>"
	Response.Write "<td>" & rLietotaji("tel_arejais") & "</td>"
	Response.Write "<td>" & rLietotaji("tel_mobilais") & "</td>"
 end if
 
 if shoferi <> "1" then
    Response.Write("<td>"& pbold &"<a href=""grafiks.asp?lid=" & rLietotaji("id") & "&" & parametri & """>" & rLietotaji("uzvards") &" "& rLietotaji("vards") & "</a>"&pbold_close&"</td>")
	Response.Write "<td><a href=mailto:" & rLietotaji("epasts") & ">" & rLietotaji("epasts") & "</td>"
	Response.Write "<td>" & rLietotaji("tel_vietejais") & "</td>"
	Response.Write "<td>" & rLietotaji("tel_arejais") & "</td>"
	Response.Write "<td>" & rLietotaji("tel_mobilais") & "</td>"


 maxno = "00:00"

 '--- select - cilveks izgaajis uz kaadu briidi ( 1 dienas robezaas)
 ssql = "select id as grid, IsNull(atrodas_lidz,'') as lidz, IsNull(atrodas_no,'') as no, * from lietotaji_grafiks "&_
	"where lietotajs_id = " & rLietotaji("id") & " and '" & SQLDate(Now()) & "' = aktivs_no AND aktivs_no = aktivs_lidz "&_
	"and tips = 'iis' and isnull(atrodas_no,0)<>0 and isnull(atrodas_lidz,0)=0 and atrodas_no in (select max(atrodas_no) from lietotaji_grafiks "&_
	"where lietotajs_id = " & rLietotaji("id") & " and '" & SQLDate(Now()) & "' = aktivs_no AND aktivs_no = aktivs_lidz "&_
	"and tips = 'iis' and isnull(atrodas_no,0)<>0 and isnull(atrodas_lidz,0)=0) " &_	
	"and DATEDIFF(n,atrodas_no,getdate())<0"
 
 set rGrafiks1 = conn.execute (ssql)
 
 'if rGrafiks1.eof then
 
	'--- select - iistermina darba grafiks
	ssql = "select id as grid, IsNull(atrodas_lidz,'') as lidz, IsNull(atrodas_no,'') as no, * from lietotaji_grafiks "&_
		"where lietotajs_id = " & rLietotaji("id") & " and '" & SQLDate(Now()) & "' between aktivs_no AND aktivs_lidz "&_
		"and tips = 'iis' and atrodas_lidz in (select max(atrodas_lidz) from lietotaji_grafiks "&_
		"where lietotajs_id = " & rLietotaji("id") & " and '" & SQLDate(Now()) & "' between aktivs_no AND aktivs_lidz "&_
		"and tips = 'iis')"
	
	set rGrafiks = conn.execute (ssql)
	 
	if rGrafiks.eof then

		'--- select - ilgtermina darba grafiks
		ssql = "select id as grid, IsNull(atrodas_lidz,'') as lidz, IsNull(atrodas_no,'') as no, * from lietotaji_grafiks "&_
			"where lietotajs_id = " & rLietotaji("id") & " and '" & SQLDate(Now()) & "' between aktivs_no AND aktivs_lidz and tips = 'gar'"
			
		set rGrafiks = conn.execute (ssql)
	
	end if
 
 'end if


 
 if rGrafiks.eof and rGrafiks1.eof then
  Response.Write "<td align=center><font color=orange><b>?</td><td></td><td></td>"
 else
  
  no = "00:00"
  nogr = "00:00"
  lidzgr = "24:00"
  nogg = "00:00"
  lidzgg = "24:00"
  
  
  Do While not rGrafiks.eof
  
  '--- iisterminja
   if Trim(rGrafiks("tips")) = "iis" then

	'--- sodien darbaa no - liidz
	if rGrafiks("lidz") <> "" and Hour(rGrafiks("lidz")) <> 0 and crtime(rGrafiks("no")) > nogr then
     nogr = crtime(rGrafiks("no"))
     lidzgr = crtime(rGrafiks("lidz"))
    end if
    
   '--- ilgterminja
   elseif Trim(rGrafiks("tips")) = "gar" then
   
    Select Case Weekday (Now(),2)
     case 1
      if crtime(rGrafiks("1_no")) > nogg then
       nogg = crtime(rGrafiks("1_no"))
       lidzgg = crtime(rGrafiks("1_lidz"))
      end if
     case 2
      if crtime(rGrafiks("2_no")) > nogg then
       nogg = crtime(rGrafiks("2_no"))
       lidzgg = crtime(rGrafiks("2_lidz"))
      end if
     case 3
      if crtime(rGrafiks("3_no")) > nogg then
       nogg = crtime(rGrafiks("3_no"))
       lidzgg = crtime(rGrafiks("3_lidz"))
      end if
     case 4
      if crtime(rGrafiks("4_no")) > nogg then
       nogg = crtime(rGrafiks("4_no"))
       lidzgg = crtime(rGrafiks("4_lidz"))
      end if
     case 5
      if crtime(rGrafiks("5_no")) > nogg then
       nogg = crtime(rGrafiks("5_no"))
       lidzgg = crtime(rGrafiks("5_lidz"))
      end if
     case 6
      if crtime(rGrafiks("6_no")) > nogg then
       nogg = crtime(rGrafiks("6_no"))
       lidzgg = crtime(rGrafiks("6_lidz"))
      end if
    end select
   end if
   aktivs_lidz = rGrafiks("aktivs_lidz")
   rGrafiks.movenext
  Loop
  maxno = no
  nebus = false

  '--- select -> kad buus?
  '--- un parbaude vai kadBuus datums nav cita kaveejuma saakuma diena
 
    ssql = "SELECT DATEADD(DAY,1,aktivs_lidz) as next1, " + _
		 "DATEADD(DAY,2,aktivs_lidz) as next2, " + _ 
		 "DATEADD(DAY,3,aktivs_lidz) as next3 " + _
		 "FROM lietotaji L inner join lietotaji_grafiks on " + _
		 "lietotajs_id = L.id where '"+SQLDATE(Now)+"' <= aktivs_lidz AND " + _
		 "L.id = "+nullprint(rLietotaji("id"))+" and tips = 'iis' " + _
		 "and DATEADD(DAY,1,aktivs_lidz) not in (SELECT aktivs_no from " + _ 
		 "lietotaji_grafiks where lietotajs_id = "+nullprint(rLietotaji("id"))+ " " + _
		 "and '"+SQLDATE(Now)+"' < aktivs_no and tips = 'iis') " + _
		 "ORDER BY aktivs_lidz"
		 
 
  'ssql = "SELECT DATEADD(DAY,1,aktivs_lidz) as next1, " + _
'		 "DATEADD(DAY,2,aktivs_lidz) as next2, " + _ 
'		 "DATEADD(DAY,3,aktivs_lidz) as next3 " + _
'		 "FROM lietotaji L inner join lietotaji_grafiks on " + _
'		 "lietotajs_id = L.id where '"+SQLDATE(Now)+"' <= aktivs_lidz AND " + _
'		 "L.id = "+nullprint(rLietotaji("id"))+" and tips = 'iis' ORDER BY aktivs_lidz"
  
  
 ' rw ssql
 'rw "<br>"
  set rDatums = conn.execute(ssql)
 
  if not rDatums.eof then
 	kadBuus = rDatums("next1")

	'--- parbaude vai nav briivdiena
	if weekday(kadBuus)=7 then '--- ie 7 = sestdiena
		kadBuus = rDatums("next3")
		
	end if
	if weekday(kadBuus)=1 then '--- ie 1 = svetdiena 
		kadBuus = rDatums("next2")

	end if
	
  else kadBuus = ""
  end if
  
  
  

  
  if nogr <> "00:00" then nogg = nogr
  if lidzgr <> "24:00" then lidzgg = lidzgr
  if nogg > no then no = nogg


    '--- ja ir izgaajis
	if not rGrafiks1.eof then
		no = crtime(rGrafiks1("no"))
		maxno = no
	end if




 if (no = "00:00" and nogr = "00:00" and nogg = "00:00") then
 
	Response.Write "<td align=center><font color=red><b>NEBÛS</b>"
	Response.Write "</td><td>"
	if kadBuus <> "" then Response.Write FormatDateTime(kadBuus,1)
	
	nebus = true
 
 elseif no < lidzgg and no > crtime(Now()) then
	
	Response.Write "<td align=center><font color=red><b>BÛS " & no
	
	elseif no < lidzgg and no <= crtime(Now()) and lidzgg >= crtime(Now()) then
   	
   		Response.Write("<td align=center><font color=green><b>IR")
		if lcase(rLietotaji("lietotajs"))=lcase(get_user) then
			uzvietas = true
		end if
	
	else
		nebus = true
		Response.Write "<td align=center><font color=red><b>NEBÛS</b>"
		Response.Write "</td><td>"
	end if
	
	Response.Write "</td>"

	if not nebus then
	   Response.Write "<td></td>"
	end if

 		
	if nebus = false and nogg <> "00:00" then 
		Response.Write "<td>" & nogg & "-" & lidzgg & "</td>"
		Response.Write "<input type='hidden' name='liidz_"+nullprint(rLietotaji("id"))+"' value='" & lidzgg & "'>"
	else
		Response.Write "<td></td>"
	end if

 end if


 if maxno = no and maxno <> "00:00" and ((Hour(maxno) >= Hour(Now()) and Minute(maxno) > Minute(Now())) or (Hour(maxno) > Hour(Now()))) and (lcase(rLietotaji("lietotajs")) = lcase(get_user) or isaccess(T_LIETOT_ADMIN)) then 'or isaccess(T_GRAFIKS_LAB)
  %>
  <td><input type="button" alt="Atgriezties" onclick="TopSubmit('grafiks_sais.asp?action=2')" name=atgriezties value="Atgriezties"></td>
  <%
 else
  Response.Write "<td></td>"
 end if
 if not rGrafiks.eof then%><td nowrap><input type="button" alt="Labot grafiku" onclick="TopSubmit('grafiks.asp?action=2&id=<%=rGrafiks("grid")%>')" name=labot value="Labot">
  <input type="button" alt="Dzçst grafiku" onclick="if (confirm('Dzçst ðo darba grafiku?')) { TopSubmit('grafiks.asp?action=5&id=<%=rGrafiks("grid")%>')}" name=dzest value="Dzçst"></td><%
 end if

end if '--- if shoferi
 
 Response.Write "<TD><a href='lietotaji.asp?USER="+nullprint(rLietotaji("id"))+"' target=new>[labot info]</a></TD></tr>"
 rLietotaji.movenext
loop%>
</table>
 

<%
'atlasa administrçjamâ lietotâja tiesîbas
%>
 <!--tabula ar tiesîbâm-->
 <p>
 <table cols="3">

 
</table>

<script>
laix_refresh();
function laix_refresh()
{
if (forma.iziet){

 var delta = forma.iziet.options[forma.iziet.selectedIndex].value;
 if (delta < 999) 
 {
  var hr = <%=Hour(Now())%>;
  var mn = <%=Minute(Now())%>; 
  mn = mn + (1*delta);
  while (mn>=60)
  {
   mn = mn - 60;
   hr = hr + 1;
  }
 } else {
  hr = '0';//'23';
  mn = '0';//'59';
 }
 if (hr < 10) {hr = '0' + hr;}
 if (mn < 10) {mn = '0' + mn;}
 forma.stunda.value = hr;
 forma.minute.value = mn;
 
 return true;
 
 }else{
	 return false;
 }
 
}
</script>

<input type="hidden" name="uzvietas" value="<%=uzvietas%>">

</form>
</body>
</html>