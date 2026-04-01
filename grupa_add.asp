<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%


dim conn
openconn
kods = Request.Form("kods")
submit = Request.Form("submit")
grupasnos = Request.Form("veids")
grupastips = Request.Form("grupastips")
kods1 = Request.Form("kods1")
kurvards = Request.Form("kurvards")
kurators = Request.Form("kurators")
valsts = Request.Form("valsts")
valstsnos = Request.Form("valstsnos")
v = Request.Form("v")
v2 = Request.Form("v2")
sakuma_dat = Request.Form("sakuma_dat")
beigu_dat = Request.Form("beigu_dat")
sapulces_dat = Request.Form("sapulces_dat")
reg = Request.Form("reg")
val = Request.Form("val")
mar = Request.Form("mar")
monthv = Request.Form("monthv")
mon = Request.Form("mon")
idx = Request.Form("idx")
tempkods = Request.Form("tempkods")
ien_konts = Request.Form("ien_konts")
ava_konts = Request.Form("ava_konts")
n1_term = Request.Form("n1_term")
n2_term = Request.Form("n2_term")
n3_term = Request.Form("n3_term")
summa1 = Request.Form("summa1")
summa2 = Request.Form("summa2")
veidsid = Request.Form("veidsid")
klients = Request.Form("klients")

'Response.Write "1:"+grupasnos+"<BR>"
'Response.Write "2:"+cstr(veidsid)

%>


<%docstart "Grupas pievienoðana","y1.jpg"
JsDateVerify
%>
<font face=arial>
<%
 'Nosakam tiesibas labot
 if IsAccess(T_GR_LAB1) then gr_lab1 = true else gr_lab1 = false
 if IsAccess(T_GR_LAB2) then gr_lab2 = true else gr_lab2 = false
%>
<form name=forma method=POST>
<%

if submit = "" then

%>
<table width=100%>
		<tr>
		<td align=right valign=top><font size=2><strong>Marðruta veids:</strong></td>
		<td>
			  <% set rVeids = conn.execute("select * from grveidi ")
			  index = 1
			  while not rVeids.eof
			   response.write "<input type=radio name=veids "
			   If index = 1 then 
			     Response.Write "checked=true " 
			     index = index+1
			   end if
			   Response.write "value="+cstr(rVeids("id"))+" "
			   response.write ">"+rVeids("vards")
			   response.write "</input><br>"
			   rVeids.movenext
			  wend
			  %>
			</td>
			<td width=40%>
		</tr>
		<tr>
			<td></td>
			<td align=left colspan=2>
			<input type=submit value='Uz priekðu >' id=submit1 name=submit1>
			<option value="1">
			</option>
			</input>
			<input type=hidden name=submit value=1>
			</input>
		</tr>
<table>
<% end if %>

<%

if submit = "2" then

%>

<center><font color="RED" size="4">
<%	
    submit = "3"
	if Request.Form("kurators") = "0" then 
		Response.Write ("Izvçlieties kâdu kuratoru <br>")
		submit = "1"
	end if
	if Request.Form("valsts") = "X" then 
		Response.Write("Izvçlieties kâdu valsti <br>")
		submit = "1"
	end if
	if not IsValidDate(Request.Form("sakuma_dat"),"dmy") then 
		Response.Write("Ievadiet sâkuma datumu <br>")
		submit = "1"
	end if
	if not IsValidDate(Request.Form("beigu_dat"),"dmy") then 
		Response.Write("Ievadiet beigu datumu <br>")
		submit = "1"
	end if
	if not IsValidDate(Request.Form("sapulces_dat"),"dmy") and Request.Form("sapulces_dat") <> "" then 
		Response.Write("Nepareizs sapulces datuma formâts <br>")
		submit = "1"
	end if
	if grupastips = "2" then
	 if klients <> "" then
	  set rKlients = conn.execute("select IsNull(vards2,'') as vards2, IsNull(uzvards2,'') as uzvards2, IsNull(pk1,'') as pk1, IsNull(pk2,'') as pk2, IsNull(adrese2,'') as adrese2, IsNull(pilseta2,'') as pilseta2, IsNull(indekss,'') as indekss, IsNull(talrunisM,IsNull(talrunisD,IsNull(talrunisMob,''))) as talrunis from dalibn where id = " & klients)
	 end if
	end if
end if  
%>   
</font>
<% 

if submit = "1" then
    if veidsid="" then veidsid = Request.Form("veids")
	set rVeids = conn.execute("select * from grveidi where id = " + cstr(veidsid))
  
  burts =  rVeids("burts")

	'Dâvanu karðu veidoðana Onlinam:
	if burts = "D" then
		 'izveidojam marðrutu
		 dim dk_name
		 dk_name = "!Dâvanu kartes - [ðeit ierakstiet veidu] "+cstr(Year(Now()))+""
       conn.execute "insert into marsruts (v,usd,old) values ('"+dk_name+"',0,0)"
       maid = conn.execute("select max(id) from marsruts where v = '"+dk_name+"'")(0)
        vkonts = "5.2.2.2"
		conn.execute "insert into grupa (mid,konts,izveidots,veids,sakuma_dat,beigu_dat,kods) values ("+cstr(maid)+",'"+vkonts+"','"+sqldate(now)+"',"+cstr(rVeids("id"))+",'"+sqldate("01.01."+cstr(Year(Now())))+"','"+sqldate("31.12."+cstr(Year(Now())))+"','"+cstr(Right(Year(Date()), 2))+".D.x')"
       gid = conn.execute("select max(id) from grupa where mid = "+cstr(maid))(0)
       Response.Redirect "grupa_edit.asp?gid=" +cstr(gid)
	end if
	  if burts = "L" then submit = "KLUBINS"
	  
      if burts = "U" or burts = "X" or burts = "K" then 
       'izveidojam marðrutu
       conn.execute "insert into marsruts (v,usd,old) values ('Klubiòð - ðeit ierakstiet tçmu',0,0)"
       maid = conn.execute("select max(id) from marsruts where v = 'Klubiòð - ðeit ierakstiet tçmu'")(0)
       if cstr(rVeids("burts")) = "L" then '--- klubiòð
	       vkonts = "6.3.3.3"
		   vkonts_ava = "5.2.4"
       elseif cstr(rVeids("burts")) = "K" then '--- kompleksais
	       vkonts = "6.1.2.1"
		   vkonts_ava = "5.2.1.X"
       else
	       vkonts = "6.5.9"
		   vkonts_ava = "5.9.5"
       end if

	   
	   
       conn.execute "insert into grupa (mid,konts,konts_ava,izveidots,veids) values ("+cstr(maid)+",'"+vkonts+"','"+vkonts_ava+"','"+sqldate(now)+"',"+cstr(rVeids("id"))+")"
       gid = conn.execute("select max(id) from grupa where mid = "+cstr(maid))(0)
       Response.Redirect "grupa_edit.asp?gid=" +cstr(gid)
      end if
      
      if cstr(rVeids("burts")) = "V" then grupastips = 1 else grupastips = 2
      veids = rVeids("vards")
      kods1 = rVeids("burts")

end if

if submit = "KLUBINS" then
%>
<table width = 100%>
	<tr><td>
		<table width=100%>
		<tr>
			<td align=right><font size=2><strong>Tçma:</strong></td>
			<td align=left><input type=text name=tema size=30 value="<%=Request.Form("tema")%>"></td> 
		</tr>
		<tr>
			<td align=right><font size=2><strong>Sâkuma datums (obligâts):</strong></td>
			<td align=left><input type=text name=sakuma_dat size=15 value="<%=Request.Form("sakuma_dat")%>">&nbsp;dd.mm.yyyy</td> 
		</tr>

		<tr>
			<td align=center colspan=2>
			<input type=button value='< Atpakaï' onclick="history.back()">
			<input type=submit value='Uz priekðu >' onclick="if (forma.sakuma_dat.value==''){alert('Ievadiet datumu');return false;}">
			<option value="1">
			</option>
			</input>
			<input type=hidden name=submit value="KLUBINS2">
			<input type=hidden name=veids value="<%=veids%>"></input>
			<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>>
			<input type=hidden name=kods1 value=<%Response.Write(kods1)%>>
			<input type=hidden name=kods value=<%Response.Write(kods)%>>
			<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>>
		</tr>
		</table>	
	</td>

	</tr>
</table>
<%
end if

if submit = "KLUBINS2" then
       'izveidojam marðrutu
	   
	   ''kods
	   
	   tema = request.form("tema")
	   sakuma_dat = Formateddate(request.form("sakuma_dat"), "dmy")
	   
		if not IsValidDate(request.form("sakuma_dat"), "dmy") then 
			  Response.Write "Lûdzu ievadiet pareizi datumu<br>"
			response.end
		end if
		
	   kods =  mid(cstr(year(sakuma_dat)),3,2)
	   kods = kods + ".K.6.5."
	   if (month(sakuma_dat))<10 then kods = kods + cstr(month(sakuma_dat))
	   if (month(sakuma_dat))=10 then kods = kods + "A"
	   if (month(sakuma_dat))=11 then kods = kods + "B"
	   if (month(sakuma_dat))=12 then kods = kods + "C"
	   
	   kods = kods + "."
	   
	   '' meklejam nakamo brivo skaitli
	   num = 1
	   set rnum = conn.execute("select id from grupa where kods = '"+kods + cstr(num)+"'")
	   while not rnum.eof
			num = num + 1
			set rnum = conn.execute("select id from grupa where kods = '"+kods + cstr(num)+"'")
	   wend
	   kods = kods + cstr(num)
	   ''response.write "insert into marsruts (v,usd,old) values ('Klubiòð - "+tema+"',0,0)"
	   ''response.end
	   ''response.write kods
	   ''response.end
       conn.execute "insert into marsruts (v,usd,old) values ('Klubiòð - "+tema+"',0,0)"

       maid = conn.execute("select max(id) from marsruts")(0)

	   vkonts = "6.3.3.3"
	   vkonts_ava = "5.2.4"

	   conn.execute "insert into grupa (mid,kods,konts,konts_ava,izveidots,veids,sakuma_dat,beigu_dat) values ("+cstr(maid)+",'"+kods+"','"+vkonts+"','"+vkonts_ava+"','"+sqldate(now)+"',"+request.form("veidsid")+",'"+sqldate(sakuma_dat)+"','"+sqldate(sakuma_dat)+"')"
       gid = conn.execute("select max(id) from grupa where mid = "+cstr(maid))(0)
       Response.Redirect "grupa_edit.asp?gid=" +cstr(gid)

end if

if submit = "1" then
%>

<table width = 100%>
	<tr><td>
		<table width=100%>
		<tr>
			<td align=right><font size=2><strong>Kurators:</strong></td>
			<td><select name=kurators>
			  <% if Request.Form("kurators") = "0" or Request.Form("kurators") = "" then 
				Response.write "<option value=""0"">-</option>"
			  else
				set rKurators = conn.execute("select * from lietotaji where id = " + cstr(kurators) +" " + rKurators("uzvards")+ " and exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12) order by vards")
				Response.Write "<option value="+cstr(Request.Form("kurators"))+">"+rKurators("vards")+"</option>"
			  end if
			  %>
			  <% set rKurators = conn.execute("select * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12) order by vards")
			  while not rKurators.eof
			   response.write "<option value="+cstr(rKurators("id"))+" "
			   response.write ">"+rKurators("vards") + " " +rKurators("uzvards")
			   response.write "</Option>"
			   rKurators.movenext
			  wend
			  %></select>
			</td>
			<td width = 40%>
				<font size=2><strong>Marðruta veids:
				<% Response.Write(veids) %>
				</strong>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Valsts:</strong></td>
			<td align=left>
				<select name=valsts>
				<% if Request.Form("valsts") = "X" or Request.Form("valsts") = "" then 
					Response.write "<option value=""X"">-</option>"
				else
					valsts = Request.Form("valsts")	
					set rValstis = conn.execute("select * from valstis where id = '" + cstr(valsts)+ "'")
					Response.Write "<option value="+cstr(Request.Form("valsts"))+">"+rValstis("title")+"</option>"
				end if
				set rValstis = conn.execute("select * from valstis order by title")
				while not rValstis.eof
				 response.write "<option value="+cstr(rValstis("id"))+" "
				 response.write ">"+rValstis("title")
				 response.write "</Option>"
				 rValstis.movenext
				wend
				%></select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Sâkuma datums (obligâts):</strong></td>
			<td align=left><input type=text name=sakuma_dat size=15 onblur="if(forma.sakuma_dat.value!=''){return ValidateDate(forma.sakuma_dat)}" value="<%=Request.Form("sakuma_dat")%>">&nbsp;dd.mm.yyyy</td> 

			
		</tr>
		<tr>
			<td align=right><font size=2><strong>Beigu datums (obligâts):</strong></td>
			<td align=left><input type=text name=beigu_dat size=15 onblur="if(forma.beigu_dat.value!=''){return ValidateDate(forma.beigu_dat)}" value="<%=Request.Form("beigu_dat")%>">&nbsp;dd.mm.yyyy</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Sapulces datums:</strong></td>
			<% 
			 Response.Write ("<td align=left><input type=text name=sapulces_dat size=15 value=" + _
			 Request.Form("sapulces_dat")+"></td>") 
			%>
		</tr>
		<% if veids = "Transports" then %>
		<tr>
			<td align=right><font size=2><strong>Klients:</strong></td>
			<td align=left>
			  <input type=hidden name=klients value=<%=Request.Form("klients")%>>
			  <input type=button value=Meklçt onclick="window.open('dalibn_izvele.asp?return_id=forma.klients&return_name=klients')">
			  <%set rKli = conn.execute("select vards, uzvards from dalibn where id = '" & klients & "'")%>
			  <div id=klients><%
			  If rKli.eof then 
			   Response.write "nav" 
			  else 
			   %><a target="_blank" href="dalibn.asp?i=<%=Request.Form("klients")%>"><%Response.Write rKli("vards") & " " & rKli("uzvards")%></a>
			  <%end if%>
			  </div>
		 </td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Izveidot pieteikumu:</strong></td>
		</tr>
		<% end if %>
		<tr>
			<td align=center colspan=2>
			<input type=button value='< Atpakaï' onclick="history.back()">
			<input type=submit value='Uz priekðu >'>
			<option value="1">
			</option>
			</input>
			<input type=hidden name=submit value=2>
			</input>
			<input type=hidden name=valstsnos value="<%Response.Write(valstsnos)%>">
			</input>
			<input type=hidden name=veids value="<%=veids%>"></input>
			<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>></input>
			<input type=hidden name=kods1 value=<%Response.Write(kods1)%>></input>
			<input type=hidden name=kods value=<%Response.Write(kods)%>></input>
			<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>></input>
		</tr>
		</table>	
	</td>

	</tr>
</table>
<% end if %>
<%

if submit = "4" then
%>
<center><font color="RED" size="4">
<%	

    submit = "5"
    if grupastips = 2 then
      if v2 = "" then 
	  	Response.Write ("Ievadiet kâdu marðrutu <br>")
		submit = "3"
	  end if
	else
	  if v2 = "" then 
	  	Response.Write ("Ievadiet vai izvçlieties kâdu marðrutu <br>")
		submit = "3"
	  end if
	end if
end if  
%>
<%
  if submit = "3" then 
%>
<table border=0 width=100%>
<% 
kurators = Request.Form("kurators")	
if kurvards = "" then
set rKurators = conn.execute("select * from lietotaji where id = '" + cstr(kurators) + "' and exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12)") 
kurvards = rKurators("vards")
end if
if valstsnos = "" then
set rValstis = conn.execute("select * from valstis where id = '" + cstr(valsts)+ "'")
valstsnos = rValstis("title")
end if
%>
<tr>
<% if grupastips = 2 then %>
  <td align=right valign=top><font size=2><strong>Marðruts:</strong></td>
			<% Response.Write ("<td align=left valign=top><input type=text name=v2 size=40 value='" + _
			 Request.Form("v2")+"'></td>") %>
<% else %>
  <td align=right valign=top><font size=2><strong>Marðruts:</strong></td>
		<td>
<% 
yearv = (Year(now))
set rMarsruts = conn.execute("select id,v,old from marsruts where old='0' and id in " + _
"(select mid from grupa where beigu_dat >= '1/1/"+cstr(yearv)+"' and beigu_dat <= '12/31/"+cstr(yearv)+"' and kods like 'V%') " + _
"and valsts = '" + valstsnos + "'")
			  index = 1
			  if rMarsruts.eof then
    			Response.Write ("<td align=left valign=top><input type=text name=v2 size=40 value='" + _
			    Request.Form("v2")+"'></td>")
			  end if
			  while not rMarsruts.eof
			   if index = 1 then
			     if Request.Form("v2")<>"" then 
			       Response.Write ("<input type=text name=v2 size=40 value='" + _
			       Request.Form("v2")+"'><br>")
			     else
			       Response.Write ("<input type=text name=v2 size=40 value='" + _
			       rMarsruts("v")+"'><br>")
			     end if
			   end if
			   response.write "<input type=radio name=v onclick='forma.v2.value="""+rMarsruts("v")+"""' "
			   If index = 1 then 
			     Response.Write "checked=true " 
			     index = index+1
			   end if
			   Response.write "value='"+cstr(rMarsruts("v"))+"' "
			   response.write ">"+rMarsruts("v")
			   response.write "</input><br>"
			   rMarsruts.movenext
			  wend
			  %>
			</td>
<% end if %>
<td valign=top width=40%>
<table><tr><td>
<font size=2><strong>
Marðruta veids: <%Response.Write grupasnos%><br>
Kurators: <% Response.Write kurvards %> <br>
Valsts: <% Response.Write valstsnos %><br>
Sâkuma datums: <% Response.Write(Request.Form("sakuma_dat")) %><br>
Beigu datums: <% Response.Write(Request.Form("beigu_dat")) %><br>
Sapulces datums: <% Response.Write(Request.Form("sapulces_dat")) %><br>
<% if Request.Form("klients") <> "" then %>
  Klients: <%=conn.execute("select isnull(nosaukums,'')+' '+isnull(vards,'')+' '+isnull(uzvards,'') from dalibn where id = "+request.Form("klients"))(0)%><br>
<% end if %>
</strong>
</td></tr></table>
</td>
</tr><tr>
<% if index = 1 then %>
<td align=center colspan=3>
<% else %>
<td align=center colspan=2>
<% end if %>
<input type=button value='< Atpakaï' onclick="history.back()">
<input type=submit value='Uz priekðu >'></td>
</tr>
<input type=hidden name=submit value=4></input>
<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>></input>
<input type=hidden name=veids value=<%Response.Write(grupasnos)%>></input>
<input type=hidden name=kurvards value="<%Response.Write(kurvards)%>"></input>
<input type=hidden name=kurators value=<%Response.Write(kurators)%>></input>
<input type=hidden name=valstsnos value="<%Response.Write(valstsnos)%>"></input>
<input type=hidden name=valsts value=<%Response.Write(valsts)%>></input>
<input type=hidden name=sakuma_dat value=<%Response.Write(sakuma_dat)%>></input>
<input type=hidden name=beigu_dat value=<%Response.Write(beigu_dat)%>></input>
<input type=hidden name=sapulces_dat value=<%Response.Write(sapulces_dat)%>></input>
<input type=hidden name=kods1 value=<%Response.Write(kods1)%>></input>
<input type=hidden name=kods value=<%Response.Write(kods)%>></input>
<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>></input>
<input type=hidden name=klients value=<%Response.Write(klients)%>></input>

<% end if %>
<%
if submit = "6" then
%>
<center><font color="RED" size="4">

<%	
    submit = "7"
    flag = "0"
    reg = mid(kods,6,1)
    val = mid(kods,8,1)
    mar = mid(kods,10,1)
    mon = mid(kods,12,1)
    idx = mid(kods,14,1)
if cstr(reg)="" or cstr(val)="" or cstr(mar)="" or cstr(mon)="" or cstr(idx)="" then 
  submit = "5"
  Response.Write ("Ievadiet kodu pareizi <br>")
else
  set rTemp = conn.execute ("select G.Kods, G.Beigu_dat from Grupa G where year(G.beigu_dat)='"+cstr(year(Formateddate(beigu_dat, "dmy")))+"' and G.kods = '"+kods1+reg+val+mar+mon+idx+"'")
  
  tempkods = ""
  tempkods = cstr(twodigits(clng(year(Formateddate(beigu_dat, "dmy")) mod 100)))+"."+cstr(kods1)+"."+cstr(reg)+"."+cstr(val)+"."+cstr(mar)+"."+cstr(mon)+"."+cstr(idx)
  'set rTemp = conn.execute ("select G.Kods, G.Beigu_dat from Grupa G where year(G.beigu_dat)='"+cstr(year(Formateddate(beigu_dat, "dmy")))+"' and G.kods = '"+tempkods+"'")
  '!!! aizvietot neiekomenteeto set rTemp rindinju ar iekomenteeto, lai paarbaudiitu vai eksistee jau shaads grupas kods jaunajaa formaataa
  %><input type=hidden name=tempkods value=<%Response.Write(tempkods)%>></input><%
  flag = "1"
  if not rTemp.eof then
    Response.Write "Ðâds grupas kods jau eksistç, lûdzu ievadiet citu pçdçjo simbolu vai nospiediet ""Suggest Index"""
    submit = "5"
  end if
end if

end if  

%>
</center></font>

<%
  if submit = "5" then 
    yearv = (Year(now))
%>
<table border=0 width=100%>
<tr>
<td valign=top><font size=2><strong>
<%monthv = HexDigit(Month(FormatedDate(beigu_dat,"dmy")))%>
<%if mon="" then mon = monthv end if %>
Grupas kods:
<% if reg = "" then reg = "1"
if val = "" then val = "1"
if mar = "" then mar = "1" %>
<%ye = cstr(twodigits(year(Formateddate(beigu_dat, "dmy")) mod 100))%>
<%Response.Write ("<input type=text name=kods size=14 maxlength=14 >")%>
<br>
<% 

'sâkot ar 2009. gadu ir tikai s baaze. Nils 07/01/2009

ssql = "select num, nosaukums, enosaukums from [SER-1\SQL14].s20"+ye+".dbo.resursi_encoded where num like '"+ye+"."+kods1+"._._' or num like '"+ye+"."+kods1+"._.__' or num like '"+ye+"."+kods1+"._._._' or num like '"+ye+"."+kods1+"._._.__' order by LEFT(NUM,9), LEN(NUM), num"
'Response.Write(ssql)
set rResursi = conn.execute(ssql)



i = 0
while not rResursi.eof
  If len(cstr(rResursi("num")))>8 then
    selected = false
    Response.Write "</strong>"
    response.write "<input type=radio "
    if selected then 
      Response.Write "checked "
    End if
    Response.Write " onclick='window.open(""grupa_index.asp?kods="+cstr(rResursi("num"))+"."+cstr(mon)+""",null,""top = 2000""); ' "
    Response.write "value='"+cstr(rResursi("num"))
    response.write "' name=resurss>"+cstr(rResursi("num"))+" "+decode(rResursi("enosaukums"))
    response.write "</input><br>"
    Response.Write "<strong>"
  else
    Response.Write cstr(rResursi("num"))+" "+decode(rResursi("enosaukums"))+"<br>"
  end if
    rResursi.movenext  
wend
%>
</select>
</td><td valign=top width=40%><table><tr><td>
<font size=2><strong>
Marðruta veids: <%Response.Write grupasnos%><br>
Kurators: <% Response.Write kurvards %> <br>
Valsts: <% Response.Write valstsnos %><br>
Sâkuma datums: <% Response.Write(Request.Form("sakuma_dat")) %><br>
Beigu datums: <% Response.Write(Request.Form("beigu_dat")) %><br>
Sapulces datums: <% Response.Write(Request.Form("sapulces_dat")) %><br>
<% if Request.Form("klients")<>"" then %>
  Klients: <%=conn.execute("select isnull(nosaukums,'')+' '+isnull(vards,'')+' '+isnull(uzvards,'') from dalibn where id = "+request.Form("klients"))(0)%><br>
<% end if %>
Marðruts: <%Response.Write v2%><br>
</td></tr></table></td>
<tr><td align=center>
<input type=button value='< Atpakaï' onclick="history.back()" id=button2 name=button2>
<input type=submit value='Uz priekðu >' id=submit2 name=submit2></td></tr>
<input type=hidden name=submit value=6></input>
<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>></input>
<input type=hidden name=veids value=<%Response.Write(grupasnos)%>></input>
<input type=hidden name=kurvards value="<%Response.Write(kurvards)%>"></input>
<input type=hidden name=kurators value=<%Response.Write(kurators)%>></input>
<input type=hidden name=valstsnos value="<%Response.Write(valstsnos)%>"></input>
<input type=hidden name=valsts value=<%Response.Write(valsts)%>></input>
<input type=hidden name=sakuma_dat value=<%Response.Write(sakuma_dat)%>></input>
<input type=hidden name=beigu_dat value=<%Response.Write(beigu_dat)%>></input>
<input type=hidden name=sapulces_dat value=<%Response.Write(sapulces_dat)%>></input>
<input type=hidden name=kods1 value=<%Response.Write(kods1)%>></input>
<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>></input>
<input type=hidden name=klients value=<%Response.Write(klients)%>></input>
<input type=hidden name=v value=<%Response.Write(v)%>></input>
<input type=hidden name=v2 value='<%Response.Write(v2)%>'></input>
<input type=hidden name=monthv value=<%Response.Write(monthv)%>></input>
</strong></font>
</td>
</tr>


</table>
<%

end if

%>

<%
if submit = "8" then
%>
<center><font color="RED" size="4">

<%	
    submit = "9"
  if ien_konts = "" or ava_konts = "" then 
    Response.Write "Lûdzu ievadiet abu kontu numurus"
    submit = "7"
  end if  
end if
%>

<%
  if submit = "7" then 
    yearv = (Year(now))

%>
<table border=0 width=100%>
<tr><td valign = top><table>
  	<tr>
  		<% If Request.Form("ien_konts") = "" then %>
		  
		  <%
		  select case veidsid 
			
			case 4 '--- Transporta grupa
			
				if mid(kods,6,1)="6" then
					ie_konts = "6.1.3.2" 
				else
					ie_konts = "6.1.3.1"
				end if
			
			case 6 '--- Kompleksa grupa
			
				ie_konts = "6.1.2.1"
			
			case else '--- V, P, S grupas
			
				ie_konts = "6.1.1.1" 
		  
		  end select
		  %>
  		  <td align=right colspan=2><font size=2><strong>Ieòçmumu konts:</strong></td>
  		  <td align=left><input type=text name=ien_konts size=15 value="<%=ie_konts%>"></td>
  		  
  		<% else %>
  		
			<td align=right colspan=2><font size=2><strong>Ieòçmumu konts:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=ien_konts size=15 value=" + _
			 Request.Form("ien_konts")+"></td>") %>
			 
		<% end if %> 
	</tr>
	<tr><% If Request.Form("ava_konts") = "" then 
  		
  		if veidsid = 4 and mid(kods,6,1)="6" then '--- T.6.. grupai
  			av_konts = "5.2.4"
  		else
  			av_konts = "5.2.1.X"
  		end if
  		
  		%>
  			<td align=right colspan=2><font size=2><strong>Avansa konts:</strong></td>
			<td align=left><input type=text name=ava_konts size=15 value="<%=av_konts%>"></td>
  		  
  		<% else %>
			
			<td align=right colspan=2><font size=2><strong>Avansa konts:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=ava_konts size=15 value=" + _
			 Request.Form("ava_konts")+"></td>") %>
			 
		<% end if %>
	</tr>

</table>
</td>
<td valign=top width=40%><table><tr>
<td><font size=2><strong>
Marðruta veids: <%Response.Write grupasnos%><br>
Kurators: <% Response.Write kurvards %> <br>
Valsts: <% Response.Write valstsnos %><br>
Sâkuma datums: <% Response.Write(Request.Form("sakuma_dat")) %><br>
Beigu datums: <% Response.Write(Request.Form("beigu_dat")) %><br>
Sapulces datums: <% Response.Write(Request.Form("sapulces_dat")) %><br>
<% if Request.Form("klients") <> "" then %>
  Klients: <%=conn.execute("select isnull(nosaukums,'')+' '+isnull(vards,'')+' '+isnull(uzvards,'') from dalibn where id = "+request.Form("klients"))(0)%><br>
<% end if %>
Marðruts: <%Response.Write v2%><br>
Grupas kods: <%Response.Write kods%>
</td></tr></table></td>
<tr><td align=center>
<input type=button value='< Atpakaï' onclick="history.back()">
<% if grupastips=1 then %>
<input type=submit value='Uz priekðu >'></td></tr>
<% else %>
<input type=submit value='Saglabât datubâzç'>
<% end if %>
<input type=hidden name=submit value=8></input>
<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>></input>
<input type=hidden name=veids value=<%Response.Write(grupasnos)%>></input>
<input type=hidden name=kurvards value="<%Response.Write(kurvards)%>"></input>
<input type=hidden name=kurators value=<%Response.Write(kurators)%>></input>
<input type=hidden name=valstsnos value="<%Response.Write(valstsnos)%>"></input>
<input type=hidden name=valsts value=<%Response.Write(valsts)%>></input>
<input type=hidden name=sakuma_dat value=<%Response.Write(sakuma_dat)%>></input>
<input type=hidden name=beigu_dat value=<%Response.Write(beigu_dat)%>></input>
<input type=hidden name=sapulces_dat value=<%Response.Write(sapulces_dat)%>></input>
<input type=hidden name=kods1 value=<%Response.Write(kods1)%>></input>
<input type=hidden name=kods value=<%Response.Write(kods)%>></input>
<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>></input>
<input type=hidden name=klients value=<%Response.Write(klients)%>></input>
<input type=hidden name=v value=<%Response.Write(v)%>></input>
<input type=hidden name=v2 value='<%Response.Write(v2)%>'></input>
<input type=hidden name=monthv value=<%Response.Write(monthv)%>></input>
<input type=hidden name=reg value=<%Response.Write(reg)%>></input>
<input type=hidden name=val value=<%Response.Write(val)%>></input>
<input type=hidden name=mar value=<%Response.Write(mar)%>></input>
<input type=hidden name=mon value=<%Response.Write(mon)%>></input>
<input type=hidden name=idx value=<%Response.Write(idx)%>></input>
<% If flag <> "1" then %>
<input type=hidden name=tempkods value=<%Response.Write(tempkods)%>></input>
<% end if %>
</strong></font>
</td>
</tr>
</table>
<%

end if

%>

<%  if submit = "10" then %>
  <center><font color="RED" size="4">
<%  submit = "11" %>
  <% if (grupastips = "1") then
    if (not IsValidDate(n1_term, "dmy")) and (n1_term <> "") then
      Response.Write "Lûdzu ievadiet pareizi vai atstâjiet tukðu pirmo termiòu<br>"
      submit = "9"
    end if
    if (n1_term <> "") then
      if (summa1="") then
        Response.Write "Lûdzu ievadiet pareizi otro summu vai atstâjiet tukðu pirmo termiòu<br>"
	    submit = "9"
      elseif (not IsValidCurr(summa1)) then
        Response.Write "Lûdzu ievadiet pareizi otro summu vai atstâjiet tukðu pirmo termiòu<br>"
	    submit = "9"
      end if
     end if
    if (not IsValidDate(n2_term, "dmy")) and (n2_term <> "") then
      Response.Write "Lûdzu ievadiet pareizi vai atstâjiet tukðu otro termiòu<br>"
      submit = "9"
    end if
    if (n2_term <> "") then
      if (summa2="") then
        Response.Write "Lûdzu ievadiet pareizi otro summu vai atstâjiet tukðu otro termiòu<br>"
	    submit = "9"
      elseif (not IsValidCurr(summa2)) then
        Response.Write "Lûdzu ievadiet pareizi otro summu vai atstâjiet tukðu otro termiòu<br>"
	    submit = "9"
      end if
     end if
    if not IsValidDate(n3_term, "dmy") then 
      Response.Write "Lûdzu ievadiet pareizi gala termiòu<br>"
      submit = "9"
    end if %>
    <% if submit = "11" then %>
      <% if Formateddate(n1_term, "dmy")>Formateddate(n3_term, "dmy") then
        Response.Write "Datumiem jâbût ievadîtiem hronoloìiskâ secîbâ"
        submit = "9"
      end if %>
      <% if (n2_term <> "") and (submit = "11") then
		if (Formateddate(n2_term, "dmy")<Formateddate(n1_term, "dmy")) or (Formateddate(n3_term, "dmy")<Formateddate(n2_term, "dmy")) then    
          Response.Write "Datumiem jâbût ievadîtiem hronoloìiskâ secîbâ"
          submit = "9"
		end if
      end if %>
      <% if (Formateddate(sakuma_dat, "dmy")<Formateddate(n3_term, "dmy")) then
          Response.Write "Gala termiòð nedrîkst pârsniegt ceïojuma sâkuma datumu"
          submit = "9"
      end if %>
    <% end if %>
  <% end if %>
<% end if %>

<%  if submit = "9" then %>
  <% if grupastips = "1" then%>
		<table width = 100%><tr><td valign=top><table width=100%>  
   		<tr>
			<td align=right><font size=2><strong>1. Termiòð:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=n1_term size=15 value=" + _
			 Request.Form("n1_term")+"></td>") %>
		</tr><tr>
			<td align=right><font size=2><strong>1. Summa EUR:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=summa1 size=15 value=" + _
			 Request.Form("summa1")+"></td>") %>
		</tr>
		<tr>
			<td align=right><font size=2><strong>2. Termiòð:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=n2_term size=15 value=" + _
			 Request.Form("n2_term")+"></td>") %>
		</tr><tr>
			<td align=right><font size=2><strong>2. Summa EUR:</strong></td>
			<% Response.Write ("<td align=left><input type=text name=summa2 size=15 value=" + _
			 Request.Form("summa2")+"></td>") %>
		</tr>
		<tr>
		 <% if Request.Form("n3_term") = "" then %>
		    <td align=right><font size=2><strong>Gala Termiòð (obligâts):</strong></td>
			<% if (valsts = "Latvija" or valsts = "Lietuva" or valsts = "Igaunija") then
				Response.Write ("<td align=left><input type=text name=n3_term size=15 value='"+dateprint(Formateddate(sakuma_dat, "dmy")-14)+"'></td>") 
			else 
				Response.Write ("<td align=left><input type=text name=n3_term size=15 value='"+dateprint(Formateddate(sakuma_dat, "dmy")-30)+"'></td>") 
			end if
			%>
			<% else %>
			<td align=right><font size=2><strong>Gala Termiòð (obligâts):</strong></td>
			<% Response.Write ("<td align=left><input type=text name=n3_term size=15 value=" + _
			 Request.Form("n3_term")+"></td>") %>
			<% end if %>
		</tr>
		<tr>
		<td align=center colspan=2>
		<input type=button value='< Atpakaï' onclick="history.back()" id=button4 name=button4>
		<input type=submit value='Saglabât datubâzç' id=submit3 name=submit3>
		</td>
		</tr>
		</table></td>
			<td valign=top width=40%><table><tr>
			<td><font size=2><strong>
			Marðruta veids: <%Response.Write grupasnos%><br>
			Kurators: <% Response.Write kurvards %> <br>
			Valsts: <% Response.Write valstsnos %><br>
			Sâkuma datums: <% Response.Write(Request.Form("sakuma_dat")) %><br>
			Beigu datums: <% Response.Write(Request.Form("beigu_dat")) %><br>
			Sapulces datums: <% Response.Write(Request.Form("sapulces_dat")) %><br>
   <% if Request.Form("klients") <> "" then %>
     Klients: <%=conn.execute("select nosaukums from dalibn where id = "+request.Form("klients"))(0)%><br>
   <% end if %>
			Marðruts: <%Response.Write v2%><br>
			Grupas kods: <%Response.Write tempkods%><br>
			Ieòçmumu konts: <%Response.Write ien_konts%><br>
			Avansa konts: <%Response.Write ava_konts%><br>
			</td></tr></table></td>
		</table>
		<input type=hidden name=submit value=10></input>
		<input type=hidden name=grupastips value=<%Response.Write(grupastips)%>></input>
		<input type=hidden name=veids value=<%Response.Write(grupasnos)%>></input>
		<input type=hidden name=kurvards value="<%Response.Write(kurvards)%>"></input>
		<input type=hidden name=kurators value=<%Response.Write(kurators)%>></input>
		<input type=hidden name=valstsnos value="<%Response.Write(valstsnos)%>"></input>
		<input type=hidden name=valsts value=<%Response.Write(valsts)%>></input>
		<input type=hidden name=sakuma_dat value=<%Response.Write(sakuma_dat)%>></input>
		<input type=hidden name=beigu_dat value=<%Response.Write(beigu_dat)%>></input>
		<input type=hidden name=sapulces_dat value=<%Response.Write(sapulces_dat)%>></input>
		<input type=hidden name=kods1 value=<%Response.Write(kods1)%>></input>
		<input type=hidden name=kods value=<%Response.Write(kods)%>></input>
		<input type=hidden name=veidsid value=<%Response.Write(veidsid)%>></input>
  <input type=hidden name=klients value=<%Response.Write(klients)%>></input>
  <input type=hidden name=v value=<%Response.Write(v)%>></input>
		<input type=hidden name=v2 value='<%Response.Write(v2)%>'></input>
		<input type=hidden name=monthv value=<%Response.Write(monthv)%>></input>
		<input type=hidden name=reg value=<%Response.Write(reg)%>></input>
		<input type=hidden name=val value=<%Response.Write(val)%>></input>
		<input type=hidden name=mar value=<%Response.Write(mar)%>></input>
		<input type=hidden name=mon value=<%Response.Write(mon)%>></input>
		<input type=hidden name=idx value=<%Response.Write(idx)%>></input>
		<% If flag <> "1" then %>
		<input type=hidden name=tempkods value=<%Response.Write(tempkods)%>></input>
		<% end if %>
		<input type=hidden name=ien_konts value=<%Response.Write(ien_konts)%>></input>
		<input type=hidden name=ava_konts value=<%Response.Write(ava_konts)%>></input>
  <% else 
    submit = "11" %>
<% end if %>
<% end if %>

<%
  if submit = "11" then 
%>
<table width=100%><tr><td valign = top><font size=2><strong>
Marðruta veids: <%Response.Write grupasnos%><br>
Kurators: <% Response.Write kurvards %> <br>
Valsts: <% Response.Write valstsnos %><br>
Sâkuma datums: <% Response.Write(Request.Form("sakuma_dat")) %><br>
Beigu datums: <% Response.Write(Request.Form("beigu_dat")) %><br>
Sapulces datums: <% Response.Write(Request.Form("sapulces_dat")) %><br>
<% if Request.Form("klients") <> "" then %>
  Klients: <%=conn.execute("select isnull(nosaukums,'')+' '+isnull(vards,'')+' '+isnull(uzvards,'') from dalibn where id = "+request.Form("klients"))(0)%><br>
<% end if %>
Marðruts: <%Response.Write v2%><br>
Grupas kods: <%Response.Write tempkods%><br>
Ieòçmumu konts: <%Response.Write ien_konts%><br>
Avansa konts: <%Response.Write ava_konts%><br>
<% If grupastips = "1" then %>
  1. Termiòð: <%Response.Write n1_term%><br>
  1. Summa: EUR <%Response.Write summa1%><br>
  <% if n2_term <> "" then%>
    2. Termiòð: <%Response.Write n2_term%><br>
    2. Summa: EUR <%Response.Write summa2%><br>
  <% end if %>
  Gala Termiòð: <%Response.Write n3_term%><br>
<% end if %>
<br>

<%
set testKods = conn.execute("select * from grupa where kods = '"+kods+"'")
if testkods.eof then
	'tas bija vajadzîgs lai dalibn.asp lapâ varçtu nospiest 'ievietot'
	session("return") = ""
	set temp = conn.execute ("select id, old from marsruts where v = '"+v2+"'")
	vid = ""
	while not temp.eof
		if not temp("old") then
			vid = temp("id")
		end if
		temp.movenext
	wend
  
	if cstr(vid) = "" then
		conn.execute "INSERT INTO marsruts (v,old) VALUES ('"+v2+"',0)"
		set r = conn.execute ("select max(id) from marsruts where v = '"+v2+"'")
		vid = r(0)
	end if
   
	conn.execute ("UPDATE marsruts SET valsts = '"+valsts+"' where id = '"+cstr(vid)+"'")
	'Ja valsts ir Latvija, tad uzliek, ka onlinâ nevajag prasît dokumentus
	dim nevajag_pases
	if valsts = "LATVIJA" then
		nevajag_pases = 1
	else
		nevajag_pases = 0
	end if

	'Vâktajâm grupâm uzstâda pârdoðanas sâkuma datumu 12/12/2016 (aìentiem un online)
	if veidsid =1 then 
		pardot_no = FormatedDate("12.12.2016","dmy")
		if pardot_no < now() then
			pardot_no = "null"
		else	
			pardot_no = "'"+sqltime(pardot_no)+"'"
		end if
		
		conn.execute ("INSERT INTO grupa (mID,kods,izveidots,konts,konts_ava,veids,sakuma_dat,beigu_dat,sapulces_dat,kurators,term1_dat,term2_dat,term3_dat,term1_summa,term2_summa,valuta,pasutitajs,pardot_agentiem,nevajag_pases,internets,pardot_agentiem_no) VALUES " + _
		"("+cstr(vid)+",'"+kods+"','"+sqldate(now)+"','"+ien_konts+"','"+ava_konts+"',"+cstr(veidsid)+","+SQLDateQ(sakuma_dat)+","+SQLDateQ(beigu_dat)+","+SQLDateQ(sapulces_dat)+",'"+cstr(kurators)+"',"+SQLDateQ(n1_term)+","+SQLDateQ(n2_term)+","+SQLDateQ(n3_term)+",'"+SQLNum(summa1)+"','"+SQLNum(summa2)+"','"+valuta+"','"+cstr(klients)+"',0,'"+cstr(nevajag_pases)+"',0,"+pardot_no+")")
	else
		conn.execute ("INSERT INTO grupa (mID,kods,izveidots,konts,konts_ava,veids,sakuma_dat,beigu_dat,sapulces_dat,kurators,term1_dat,term2_dat,term3_dat,term1_summa,term2_summa,valuta,pasutitajs,pardot_agentiem,nevajag_pases) VALUES " + _
	  "("+cstr(vid)+",'"+kods+"','"+sqldate(now)+"','"+ien_konts+"','"+ava_konts+"',"+cstr(veidsid)+","+SQLDateQ(sakuma_dat)+","+SQLDateQ(beigu_dat)+","+SQLDateQ(sapulces_dat)+",'"+cstr(kurators)+"',"+SQLDateQ(n1_term)+","+SQLDateQ(n2_term)+","+SQLDateQ(n3_term)+",'"+SQLNum(summa1)+"','"+SQLNum(summa2)+"','"+valuta+"','"+cstr(klients)+"',0,'"+cstr(nevajag_pases)+"')")

	end if

	'!!!aizvietot neiekomenteeto conn.execute ar iekomenteeto, lai izmantotu veco koda formaatu 
	stop
	set r = conn.execute ("select max(id) from grupa where mid = '"+cstr(vid)+"'")
	id = r(0)
	loginsertaction "grupa",id
  
	'te izveido pieteikumu ja vajag
	if cstr(klients) <> "" then
		conn.execute("insert into pieteikums (gid,did,datums,deleted,izveidoja) values ("+cstr(id)+","+klients+",'"+sqldate(now)+"',0,'"+Get_user+"')")
		set rP = conn.execute ("select max(id) from pieteikums where gid = '"+cstr(id)+"'")
		conn.execute("insert into piet_saite (pid,did,cena,vietsk,summa,deleted,papildv,persona) values ("+cstr(rP(0))+","+cstr(klients)+",0,1,0,0,0,1)")
	end if
  
	ped_sim = 1
	If Mid(kods,Len(kods)-2,1) = "." Then
		'pçdçjâ daïa ir divi simboli nevis viens
		ped_sim = 2
	End if
	set rKods = conn.execute("select Num,PVN_koef from [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi where Num = '"+mid(kods,1,len(kods)-ped_sim-1)+"'") 's20!
	
	write = "1"
	if rKods.eof then
		set rKods2 = conn.execute("select Num from [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi where Num = '"+mid(kods,1,len(kods)-ped_sim-3)+"'") 's20!
		''Response.write "<BR>select Num from s20"+mid(kods,1,2)+".dbo.resursi where Num = '"+mid(kods,1,len(kods)-ped_sim-3)+"'"
		if rKods2.eof then 
			session("message") = "Ðâds marðruts grâmatvedîbas datubâzç neeksistç, tâpçc kods tai netiks pievienots"
			write = "0"
		else
			'query formâts?
			set rParent = conn.execute("select Num,Nosaukums,PVN_koef from [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi where Num = '"+mid(kods,1,len(kods)-ped_sim-3)+"'") 's20!
			pvn = rParent("PVN_koef")
			'izveidojam ierakstu jaunam mçnesim
			conn.execute ("INSERT INTO [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi (Num,Nosaukums,PVN_koef,Grupa,Indeks,Parent,Konts,kmLatvija,kmArzemes,auto,extern_id,veids) VALUES ('"+mid(kods,1,len(kods)-2)+"',"+STR_SQL(Menesis(cstr(mid(kods,len(kods)-2,1))))+","+cstr(pvn)+","+cstr(1)+","+"NULL"+",'"+mid(tempkods,1,len(tempkods)-3-ped_sim)+"',"+"''"+","+"NULL"+","+"NULL"+","+cstr(1)+","+"NULL"+","+"NULL"+")") 's20!

		end if
	end if
	if write = "1" then
		If not rKods.eof then pvn = rKods("PVN_koef")
		'pievienojam ierakstu ar jauno kodu
		conn.execute ("INSERT INTO [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi (Num,Nosaukums,PVN_koef,Grupa,Indeks,Parent,Konts,kmLatvija,kmArzemes,auto,extern_id,veids) VALUES ('"+cstr(kods)+"',"+STR_SQL(cstr(v2)+" "+dateprint(FormatedDate(sakuma_dat,"dmy"))+" - "+dateprint(FormatedDate(beigu_dat,"dmy")))+","+cstr(pvn)+","+cstr(0)+","+"NULL"+",'"+cstr(mid(kods,1,Len(kods)-1-ped_sim))+"',"+"''"+","+"NULL"+","+"NULL"+","+cstr(1)+","+"NULL"+","+"NULL"+")")
	end If
	'transporta grupâm neprasa ievadît pakalpojumus auzreiz, pârçjâm prasa - 10.12.2018
	if cstr(veidsid) <> "4" then
		session("require_add_pakalpojumi") = 1
	end if
	Response.Redirect "grupa_edit.asp?gid="+cstr(id)
	%>
		Ieraksts veiksmîgi saglabâts datubâzç, nospiediet "Edit" lai ievadîtu papildinformâciju
<% else %>
	Grupa ar ðâdu kodu eksistç.
<% end if %>
<br>
<input type=submit value=Edit>
<input type=hidden value=32768>
</td></tr></table>
<% end if %>

</center></font>



<center>

<table>

</table>

</form>
</body>
</html>
