<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<% 

'atver konektu pie datubâzes
dim Conn
OpenConn

if request("act") = 1 then
	cm = Request.Form("month")
else
	cm = month(Date())
end if

Set r = conn.Execute("SELECT L.id, g.novertejums, L.vards, L.uzvards, aktivs_no, aktivs_lidz " + _
                     "FROM lietotaji L inner join lietotaji_grafiks g on lietotajs_id = L.id " + _
                     "WHERE isnull(novertejums,'')<>'' and '5/1/2006' <= aktivs_no "+ _
                     "and DATEPART(month, aktivs_no)=" + nullprint(cm) + " " + _
                     "ORDER BY uzvards, aktivs_no, novertejums") '--- 1. maijs laiks, kad novertejumi tika palaisti. vecaakus atmet


docstart "Darba grafiks - kavçjumu kopsavilkums","y1.jpg"
%>

<center>
<font color="GREEN" size="5">Kavçjumu kopsavilkums</font><hr>
<% 
headlinks 
DefJavaSubmit



%>
<p>
	Uz saîsinâto darba grafiku  <input type="image" src="impro/bildes/atpakal.bmp" alt="Atgriezties uz saîsinâto darba grafiku" onclick="TopSubmit('grafiks_sais.asp')" WIDTH="25" HEIGHT="25" id=image1 name=image1>
</p>
<br>
<form name="forma" method="POST">
Mçnesis: &nbsp;&nbsp;
<select name="month" onchange="TopSubmit('kavejumi.asp?act=1')">
	<option id="1" value="1" <%if cm = 1 then rw "selected"%>>Janvâris</option>
	<option id="2" value="2" <%if cm = 2 then rw "selected"%>>Februâris</option>	
	<option id="3" value="3" <%if cm = 3 then rw "selected"%>>Marts</option>	
	<option id="4" value="4" <%if cm = 4 then rw "selected"%>>Aprîlis</option>	
	<option id="5" value="5" <%if cm = 5 then rw "selected"%>>Maijs</option>	
	<option id="6" value="6" <%if cm = 6 then rw "selected"%>>Jûnijs</option>	
	<option id="7" value="7" <%if cm = 7 then rw "selected"%>>Jûlijs</option>	
	<option id="8" value="8" <%if cm = 8 then rw "selected"%>>Augusts</option>	
	<option id="9" value="9" <%if cm = 9 then rw "selected"%>>Septembris</option>	
	<option id="10" value="10" <%if cm = 10 then rw "selected"%>>Oktobris</option>	
	<option id="11" value="11" <%if cm = 11 then rw "selected"%>>Novembris</option>	
	<option id="12" value="12" <%if cm = 12 then rw "selected"%>>Decembris</option>	
</select>
 
<% 
cnt = 0
if not r.eof then
	
	t = "<table>"
	uid = 0
	
	While Not r.EOF
	          
	            cnt = cnt + 1
	            
	            if r("id") <> uid then
					t = t + "<tr><td colspan=3><hr color=#cccccc></td><tr>"
	            end if
	            
	            
	            vards = r("uzvards") + " " + r("vards")
	            t = t + "<tr><td>"
	            
	            nov = cstr(r("novertejums"))
	            select case nov
					case "N"
						nov = "Nav novçrtçts"
					case "A"
						nov = "Atvaïinâjums"					
					case "S"
						nov = "Slimîba"
					case "K"
						nov = "Komandçjums"
					case "B"
						nov = "Bezalgas atvaïinâjums"						
	            end select
	            
	            't = t + CStr(cnt) + ". "
	            t = t + " " + vards + "</td><td>" + CStr(r("aktivs_no")) + " - " + CStr(r("aktivs_lidz"))
	            
	            if nov = "Nav novçrtçts" then
					t = t + "</td><td><a href=http://192.168.1.100/grafiks.asp?lid=" + CStr(r("id")) + ">" + nov + "</a>"
	            else
					t = t + "</td><td>" + nov
	            end if
	            
	            t = t + "</td></tr>"	           
	            
	            uid = r("id")
	            r.MoveNext
	          
	Wend	
	t = t + "</table>"
	
else
	rw "<p>Kavçjumu nav</p>"
end if

rw t
%>

</form>
<center>
</body>
</html>


