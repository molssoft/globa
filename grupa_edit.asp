<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
gid = request.querystring("gid")

response.redirect "grupa_edit2.asp?gid="+gid

''============================================================
''============================================================
''============================================================
dim carter, carter_viesn_id, rGrupa, c_vid
dim izbr_vieta, iebr_vieta, ssql, izbr, iebr, ielid_laiks_uz, ielid_laiks_no
Dim pdf, block, sapulces_laiks_no, sapulces_laiks_lidz



'ja nonâkam ðeit no jaunas grupas veidoðanas, pâradresç uz pakalpojumu pievienoðanu
if session("require_add_pakalpojumi") = 1 then
	Response.Redirect "vietu_veidi.asp?gid="+cstr(gid)
	session("require_add_pakalpojumi") = 0
	'lai no pakalpojumu pievinoðanas pa taisno uz ðejieni atgrieztos
	session("return_to_grupa_edit") = 1

end if

'set rGrupa = conn.execute ("select g.standarta_viesnicas as sv, g.*, pg.pdf, carter_viesn_id as c_vid from grupa g left join portal.dbo.grupas pg ON pg.gr_kods = g.kods where g.id = "+gid)
'rw "select g.standarta_viesnicas as sv, g.*, pg.pdf from grupa g left join portal.dbo.grupas pg ON pg.gr_kods = g.kods where g.id = "+gid



ssql = "select g.standarta_viesnicas as sv, g.*, g.pdf as apraksts, lidojums, carter_viesn_id as c_vid,kede from grupa g left join portal.dbo.grupas pg ON pg.gr_kods = g.kods AND g.pdf IS NOT NULL where g.id = "&gid


'rw ssql

set rGrupa = conn.execute(ssql)
Set rGr  = server.createobject("ADODB.Recordset")
rGr.cursorlocation = 3
rGr.open "select * from grupa where id = " & gid,conn

kods = rGr("kods")
block = rGr("blocked")
izbr = rGr("izbr_laiks")
iebr = rGr("iebr_laiks")
izbr_vieta = rGr("izbr_vieta")
iebr_vieta = rGr("iebr_vieta")
reiss_uz = rGr("reiss_uz")
reiss_no = rGr("reiss_no")
drukat_vauceri = rGr("drukat_vauceri")
sapulces_laiks_no = TimePrint2(rGr("sapulces_laiks_no"))
sapulces_laiks_lidz = TimePrint2(rGr("sapulces_laiks_lidz"))
valuta = nullprint(rGr("valuta"))
lidojums = rGr("lidojums")

If nullprint(lidojums)<>""  Then
	Set rlid = conn.execute("select * from lidojums_vietas where lidojums = '"+sqldate(lidojums)+"'")
	If Not rlid.eof Then
		lidojums_vietas = rlid("vietas")
	Else
		lidojums_vietas = ""
	End if
End if


ielid_laiks_uz = rGr("ielid_laiks_uz") '--- ielidosnas laiks uz merkji
ielid_laiks_no = rGr("ielid_laiks_no") '--- ielidosanas laiks no merkja
sapulces_dat = rGr("sapulces_dat")
pdf = rGrupa("apraksts")
carter_viesn_id = rGrupa("c_vid") 'rGrupa("carter_viesn_id")!!!! nedarbojas. ja ieliek prieksa izbr_vieta, tad nedarbojas izbr_vieta wtf?
carter = rGr("carter")
online = rGr("internets")
garantets = rGr("garantets")

internets_no = rGr("internets_no")
nevajag_pases = rGr("nevajag_pases")
eklase = rGr("eklase")
pardot_agentiem = rGr("pardot_agentiem")


DefJavaSubmit

set rMarsruts = conn.execute ("select * from marsruts where id = "+cstr(rGr("mid")))

%>

<%docstart "Grupas laboðana","y1.jpg"%>


<script>
$(document).ready(function() {
<% if carter=false then %>
  $('#standarta_viesnicas').click(function() {
    if ($(this).is(':checked')) {
      $('#standarta_viesnicas_message').show();
    } else {
      $('#standarta_viesnicas_message').hide();
    }
  });
 <% end if %>
});

</script>

<center>
<font face=arial>
<%

if session("message") <> "" then
   %><font color="RED" size="4"><%=session("Message")%></font><% 
   session("message") = ""
end if 
%>

<%
 'Nosakam tiesibas labot
 if IsAccess(T_GR_LAB1) then gr_lab1 = true else gr_lab1 = false
 if IsAccess(T_GR_LAB2) then gr_lab2 = true else gr_lab2 = false
%>
<form name=forma action=grupa_save.asp method=POST>
<input type=hidden name="grupa_id" value="<%=rGr("id")%>">

<table>
	<tr><td>
		<table>
		<tr>
			<td align=right><font size=2>
			<strong>Kods:</strong></td>
			<% 
			if not gr_lab2 then %>
			 <td align=left><%=kods%><input type=hidden name=kods value="<%=kods%>" size=15>
			<%else%>
			 <td align=left><input size=15 type=text name=kods value="<%=kods%>">
			<%end if%>
		    </td>
		</tr>
		
  <% if not isaccess(T_DROSIBA) then %>
  
		<% if InStr(nullprint(rGr("kods")),".V.")<>0 then%>
		<tr>
			<td align=right><font size=2>
			<strong>Grupa bloíçta: </strong></td>
			<%	
			b_type = 0
			if block = 1 then
				b_type = block 'rGrupa("blocked")
			end if
					
			if not gr_lab2 then %>
			 <td align=left><%=getBlockType(b_type)%><input type=hidden name=blocked value="<%=getBlockType(b_type)%>" size=15>
			<%else%>
			 <td align=left><%=comboBlockType(b_type)%>
			<%end if%>
		    </td>
		</tr>
		<% else %>
		<!--tr>
			<td></td>
			<td>Grupas bloíçðana pagaidâm nav pieejama. Tiek veiktas izmaiòas.</td>
		</tr-->
		<% end if%>	
		<tr>
			<td align=right><font size=2><strong>Pârdot Online: </strong></font></td>
			<td><input name="online" type="checkbox" <%if online then Response.Write " checked "%> >



			<input type=hidden name=internets_no size=8 value=<%=DatePrint(rGr("internets_no"))%>>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Garantçts: </strong></font></td>
			<td><input name="garantets" type="checkbox" <%if garantets then Response.Write " checked "%> >



			<input type=hidden name=internets_no size=8 value=<%=DatePrint(rGr("internets_no"))%>>
			</td>
		</tr>
		<tr>
			<td align=right>
				<font size=2><strong>LV ceïojums, online nevajag norâdît pasi:</font></td>
			<td>	<input name="nevajag_pases" type="checkbox" <%if nevajag_pases then Response.Write " checked "%> >
			
			</td>
		</tr>			
		<tr>
			<td align=right><font size=2><strong>Pârdot aìentiem sâkot ar: </strong></font></td>
			<td><input name="pardot_agentiem" type="hidden" <%if pardot_agentiem then Response.Write " checked "%> > <input type=text name=pardot_agentiem_no size=8 value=<%=DatePrint(rGr("pardot_agentiem_no"))%>></td>
		</tr>	
		<!--
		<tr>
			<td align=right><font size=2><strong>E-klase: </strong></font></td>
			<td><input name="eklase" type="checkbox" <%if eklase then Response.Write " checked "%> >
			E-klases lietotâjiem ceïojums ar atlaidi 5%
			</td>
		</tr>			  -->
		<tr>
			<td align=right><font size=2>
			<strong><font size=2>Ieòçmumu konts: </strong></td>
			<td align=left>
			<%if not gr_lab2 then %>
			 <%=rGr("konts")%><input type=hidden name=konts value="<%=rGr("konts")%>" size=10>
			<%else%>
			 <input type=text name=konts value="<%=rGr("konts")%>" size=10>
			<%end if%>
			</td>
		</tr>
		<% else %>
		 <input type=hidden name=konts value="<%=rGr("konts")%>" size=10>
  <% end if %>
		
  <% if not isaccess(T_DROSIBA) then %>
		<tr>
			<td align=right><font size=2>
			<strong><font size=2>Avansa konts: </strong></td>
			<td align=left>
			<%if not gr_lab2 then %>
			 <%=rGr("konts_ava")%><input type=hidden name=konts_ava value="<%=rGr("konts_ava")%>" size=10>
			<%else%>
			 <input type=text name=konts_ava value="<%=rGr("konts_ava")%>" size=10>
			<%end if%>
			</td>
		</tr>
		<% else %>
   <input type=hidden name=konts_ava value="<%=rGr("konts_ava")%>" size=10>		
		<% end if %>
		<tr>
			<td align=right><font size=2><strong>Marðruts:</strong></td>
			<td align=left>
			 <input type=text name=v value="<%=ReplaceChar(rMarsruts("v"),"""","&#34")%>" size=60><a href=marsruts_add.asp?gid=<%=rGrupa("id")%> target=new>+</a>
			 <% 
			  'nosakam dubultos marðrutus 
			  if not isnull(rGrupa("beigu_dat")) then
			   set r = conn.execute("select isnull(count(*),0) from marsruts where v2 = '"+SQLText(rMarsruts("v2"))+"' and id in (select mid from grupa where beigu_dat>='1/1/"+cstr(year(rGrupa("beigu_dat")))+"' and beigu_dat<'1/1/"+cstr(year(rGrupa("beigu_dat"))+1)+"')")
			   if r(0)>1 then
			    Response.Write "<br>Dubultie marðruti:"+cstr(r(0)) %> <a href=marsruts_apvienot.asp?id=<%=rMarsruts("id")%>&gads=<%=year(rGrupa("beigu_dat"))%> target=new>Apvienot</a><%
			   end if
			  end if
			 %>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Èarteris: </strong></font></td>
			<td>
			<input id="carter" name="carter" type="checkbox" <%if carter then Response.Write " checked "%> >
			<span id="carter_viesn">
				<font size=2><strong>Viesnîca: </strong>
				<select id="carter_viesn_id" name="carter_viesn_id">
				  <option value="0">-</option>
				  <% 
				  '--- vecaas carter viesnicas jaunaam grupaam sleepj
				  'Response.write CInt(Left(rGrupa("kods"),2))&" = "&CInt(Right(Year(Date),2))
				  If Left(rGrupa("kods"),2) = Right(Year(Date),2) then
					wherec = " and old=0 "
 				  Else
					wherec = ""
				  End If
				  
				  set rVeids = conn.execute("select * from carter_viesnicas where 1=1 "&wherec + " order by valsts,nosaukums")
				  while not rVeids.eof
				   response.write "<option value="+cstr(rVeids("id"))+" "
				   if rVeids("id") = carter_viesn_id then response.write " selected "
				   response.write ">["+rVeids("valsts") + "] " + rVeids("nosaukums")
				   response.write "</Option>"
				   rVeids.movenext
				  wend
				  %></select> <a href="carter_viesnicas.asp" target=carter_viesn>Labot</a>
			</span>
			</td> 
		</tr>
<!--input type=hidden name=lidojums value="<%=dateprint(lidojums)%>" size=8 -->		
		<tr>
			<td align=right><font size=2><strong>Lidojuma datums vietu kontrolei:</strong></td>
			<td align=left>
				<input type=text name=lidojums value="<%=dateprint(lidojums)%>" size=8 >
			</td>
		</tr>
		<!--input type=hidden name=lidojums_vietas value="<%=lidojums_vietas%>" size=4 -->
		<tr>
			<td align=right><font size=2><strong>Vietas lidojumâ:</strong></td>
			<td align=left>
				<input type=text name=lidojums_vietas value="<%=lidojums_vietas%>" size=4 >
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Viesnîcu numuriòi:</strong></td>
			<td align=left><%=conn.execute("select count(*) from viesnicas where gid = "+cstr(gid))(0)%></td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Standarta viesnîcas:</strong></td>
			<td align=left>
                <input type=checkbox name=standarta_viesnicas id="standarta_viesnicas" <%if rGrupa("sv")=true then Response.Write(" checked ") end if%> size=50><br />
            </td>
		</tr>
        <tr>
            <td></td>
            <td><div id="standarta_viesnicas_message" style="width: 500px; display: none;">Ja vçlaties, lai pie sandarta viesnîcâm tiktu izveidoti arî SINGLE numuriòi,lûdzu, pârliecinieties vai grupai ir pievienots pakalpojums ar tipu "Piemaksa SGL"! <a href = 'vietu_veidi.asp?gid=<%=gid%>' target="_blank"><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></div></td>
        </tr>
		<!--
		<tr>
			<td align=right><font size=2><strong>Sûtît epastu par atteikumiem:</strong></td>
			<td align=left><input type="checkbox" name="atteikumu_epasts" <%if rGr("atteikumu_epasts")=true then Response.Write(" checked ") end if%> size="50"></td>
		</tr>-->
		<tr>
			<td align=right><font size=2><strong>Veids:</strong></td>
			<td><select name=veids>
			  <option value="0">-</option>
			  <% set rVeids = conn.execute("select * from grveidi ")
			  while not rVeids.eof
			   response.write "<option value="+cstr(rVeids("id"))+" "
			   if rVeids("id") = rGrupa("veids") then response.write " selected "
			   response.write ">"+rVeids("vards")
			   response.write "</Option>"
			   rVeids.movenext
			  wend
			  %></select>
			</td>
		</tr>
		<% if rgrupa("veids") = 2 then %>
		<tr>
		<td align=right><font size=2><strong>Klients (obligâts):</strong></td>
			<td align=left>
			  <input type=hidden name=klients value=<%=rGrupa("pasutitajs")%>>
			  <input type=button value=Meklçt onclick="window.open('dalibn_izvele.asp?return_id=forma.klients&return_name=klients')" id=button1 name=button1>
			  <%set rKli = conn.execute("select vards, uzvards from dalibn where id = '" & rGrupa("pasutitajs") & "'")%>
			  <div id=klients><%
			  If rKli.eof then 
			   Response.write "nav" 
			  else 
			   %><a target="_blank" href="dalibn.asp?i=<%=rGrupa("pasutitajs")%>"><%Response.Write rKli("vards") & " " & rKli("uzvards")%></a>
			  <%end if%>
			  </div>
		 </td>
		</tr>
		<% else %>
		 <input type=hidden name=klients>
		<% end if %>
		<tr>
			<td align=right><font size=2><strong>Valsts:</strong></td>
			<td align=left>
				<select name=valsts>
				<option value="X">-</option>
				<% set rValstis = conn.execute("select * from valstis WHERE globa=1 order by title")
				while not rValstis.eof
				 response.write "<option value="+cstr(rValstis("id"))+" "
		   if trim(rValstis("id")) = trim(rMarsruts("valsts")) then response.write " selected "
				 response.write ">"+rValstis("title")
				 response.write "</Option>"
				 rValstis.movenext
				wend
				%></select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Grupa atcelta:</strong></td>
			<td align=left><input type=checkbox name=atcelta <%if rGrupa("atcelta") then Response.Write " checked "%> size=50></td>
		</tr>
		<input type=hidden name=valuta value="<%=valuta%>" size=3 >
		<!--tr>
			<td align=right><font size=2><strong>Valûta:</strong></td>
			<td align=left nowrap><input type=text name=valuta value="<%=valuta%>" size=3 ></td>
		</tr-->		<tr>
			<td align=right><font size=2><strong>Sâkuma datums:</strong></td>
			<td align=left nowrap><input type=text name=sakuma_dat value="<%=datePrint(rGrupa("sakuma_dat"))%>" size=15></td>
		</tr>
		<tr>
			<td align=right><font size=2>
			<%if inStr(rGrupa("kods"),".V.7.")<>0 then%>			
				<strong>Izlidoðanas laiks un vieta: </strong>
			<%else%>
				<strong>Izbraukðanas laiks un vieta: </strong>
			<%end if%>
			</font>
		</td>
		<td>
			<input type=text name=izbr_laiks value="<%rw timeprint2(izbr) 'if rGrupa("izbr_vieta")>1 then rw timeprint2(izbr)%>" size=5>
			<select name=izbr_vieta>
			  <option value=0 <%if izbr_vieta=0 then Response.Write("selected")%>><%=getIVieta(0)%></option>
			  <option value=1 <%if izbr_vieta=1 then Response.Write("selected")%>><%=getIVieta(1)%></option>
			  <option value=2 <%if izbr_vieta=2 then Response.Write("selected")%>><%=getIVieta(2)%></option>
			  <option value=3 <%if izbr_vieta=3 then Response.Write("selected")%>><%=getIVieta(3)%></option>
			  <option value=4 <%if izbr_vieta=4 then Response.Write("selected")%>><%=getIVieta(4)%></option>
			  <option value=5 <%if izbr_vieta=5 then Response.Write("selected")%>><%=getIVieta(5)%></option>
			  <option value=6 <%if izbr_vieta=6 then Response.Write("selected")%>><%=getIVieta(6)%></option>			  
			  <option value=7 <%if izbr_vieta=7 then Response.Write("selected")%>><%=getIVieta(7)%></option>			  
			  <option value=8 <%if izbr_vieta=8 then Response.Write("selected")%>><%=getIVieta(8)%></option>			  
			  <option value=9 <%if izbr_vieta=9 then Response.Write("selected")%>><%=getIVieta(9)%></option>			  
			  <option value=10 <%if izbr_vieta=10 then Response.Write("selected")%>><%=getIVieta(10)%></option>			  
			  <option value=11 <%if izbr_vieta=11 then Response.Write("selected")%>><%=getIVieta(11)%></option>			  
			  <option value=12 <%if izbr_vieta=12 then Response.Write("selected")%>><%=getIVieta(12)%></option>			  
			  <option value=13 <%if izbr_vieta=13 then Response.Write("selected")%>><%=getIVieta(13)%></option>			  
			</select>

			</td>
		</tr>
		<%if inStr(rGrupa("kods"),".V.7.")<>0 Then 'lidojumu grupas%>	
		<tr>
			<td align=right><strong><font size=2>Ielidoðanas laiks galamçríî:</font></strong></td>
			<td align=left><input type=text name=ielid_laiks_uz value="<%rw timeprint2(ielid_laiks_uz) %>" size=5></td>
		</tr>
		<%end if%>
		<tr>
			<td align=right><font size=2><strong>Beigu datums:</strong></td>
			<td align=left><input type=text name=beigu_dat value="<%=datePrint(rGrupa("beigu_dat"))%>" size=15>
			</td>
		</tr>
		<input type=hidden name=ielid_laiks_no value="<%rw timeprint2(ielid_laiks_no) %>" size=5>
		<!--tr>
			<td align=right><strong><font size=2>Izlidoðanas laiks no galamçría:</font></strong></td>
			<td align=left><input type=text name=ielid_laiks_no value="<%rw timeprint2(ielid_laiks_no) %>" size=5></td>
		</tr-->
		<tr>
			<td align=right><strong><font size=2>Drukât vauèeri:</font></strong></td>
			<td align=left><input type=checkbox name=drukat_vauceri <%if drukat_vauceri then Response.Write " checked "%> size=50></td>
		</tr>
		<input type=hidden name=reiss_uz value="<%rw reiss_uz %>" size=5>
		<!--tr>
			<td align=right><strong><font size=2>Reisa numuri (turp, atpakaï):</font></strong></td>
			<td align=left><input type=text name=reiss_uz value="<%rw reiss_uz %>" size=5><input type=text name=reiss_no value="<%rw reiss_no %>" size=5></td>
		</tr-->

		<tr>
			<td align=right><font size=2>
			<%if inStr(rGrupa("kods"),".V.7.")<>0 then%>	
				<strong>Ielidoðanas laiks un vieta: </strong>
			<%else%>
				<strong>Iebraukðanas laiks un vieta: </strong>
			<%end if%>		
			</font>							
			</td>
			<td>
			<input type=text name=iebr_laiks value="<%rw timeprint2(iebr) 'if rGrupa("iebr_vieta")>1 then rw timeprint2(iebr)%>" size=5>
			<select name=iebr_vieta>
			  <option value=0 <%if iebr_vieta=0 then Response.Write("selected")%>><%=getIVieta(0)%></option>
			  <option value=1 <%if iebr_vieta=1 then Response.Write("selected")%>><%=getIVieta(1)%></option>
			  <option value=2 <%if iebr_vieta=2 then Response.Write("selected")%>><%=getIVieta(2)%></option>
			  <option value=3 <%if iebr_vieta=3 then Response.Write("selected")%>><%=getIVieta(3)%></option>
			  <option value=4 <%if iebr_vieta=4 then Response.Write("selected")%>><%=getIVieta(4)%></option>
			  <option value=5 <%if iebr_vieta=5 then Response.Write("selected")%>><%=getIVieta(5)%></option>
			  <option value=6 <%if iebr_vieta=6 then Response.Write("selected")%>><%=getIVieta(6)%></option>			  
			  <option value=7 <%if iebr_vieta=7 then Response.Write("selected")%>><%=getIVieta(7)%></option>			  
			  <option value=8 <%if iebr_vieta=8 then Response.Write("selected")%>><%=getIVieta(8)%></option>			  
			  <option value=9 <%if iebr_vieta=9 then Response.Write("selected")%>><%=getIVieta(9)%></option>			  
			  <option value=10 <%if iebr_vieta=10 then Response.Write("selected")%>><%=getIVieta(10)%></option>			  
			  <option value=11 <%if iebr_vieta=11 then Response.Write("selected")%>><%=getIVieta(11)%></option>			  
			  <option value=12 <%if iebr_vieta=12 then Response.Write("selected")%>><%=getIVieta(12)%></option>			  
			  <option value=13 <%if iebr_vieta=13 then Response.Write("selected")%>><%=getIVieta(13)%></option>			  
			</select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Sapulces datums:</strong></td>
			<td align=left>
				<input type=text name=sapulces_dat value="<%=datePrint(sapulces_dat)%>" size=15>
				<font size=2><strong>Laiks:</strong>
				<input type=text name="sapulces_laiks_no" value="<%=sapulces_laiks_no%>" size=5>
				<strong>-</strong>
				<input type=text name="sapulces_laiks_lidz" value="<%=sapulces_laiks_lidz%>" size=5>
				</font>
			</td>
		</tr>
		<!--
		<tr>
			<td align=right><font size=2><strong>Iebrauc Lietuvâ:</strong></td>
			<td align=left><input type=text name=polijas_dat value="<%=TimePrint(rGrupa("polijas_dat"))%>" size=15></td>
		</tr>-->
		<!--
		<tr>
			<td align=right><font size=2><strong>Grupu vâc lîdz:</strong></td>
			<td align=left><input type=text name=vac_dat value="<%=TimePrint(rGrupa("vac_dat"))%>" size=15></td>
		</tr>-->
		<% set rGrupa = conn.execute ("select * from grupa where id = "+gid)%>
		<tr>
			<td align=right><font size=2><strong>1. termiòð:</strong></td>
			<td align=left><input type=text name=term1_dat value="<%=datePrint(rGrupa("term1_dat"))%>" size=15>
			<strong><font size=2>1. summa <%=valuta%>:</strong>
			<input type=text name=term1_summa value="<%=rGrupa("term1_summa")%>" size=5>
			<strong><font size=2>zaud. <%=valuta%>:</strong>
			<input type=text name=term1_zaud_summa value="<%=rGrupa("term1_zaud_summa")%>" size=5>
			</td>
		</tr>
		<% set rGrupa = conn.execute ("select * from grupa where id = "+gid)%>
		<tr>
			<td align=right><font size=2><strong>2. termiòð:</strong></td>
			<td align=left><input type=text name=term2_dat value="<%=datePrint(rGrupa("term2_dat"))%>" size=15>
			<strong><font size=2>2. summa <%=valuta%>:</strong>
			<input type=text name=term2_summa value="<%=rGrupa("term2_summa")%>" size=5>
			<strong><font size=2>zaud. <%=valuta%>:</strong>
			<input type=text name=term2_zaud_summa value="<%=rGrupa("term2_zaud_summa")%>" size=5>			
			</td>
		</tr>
		<% set rGrupa = conn.execute ("select * from grupa where id = "+gid)%>
		<tr>
			<td align=right><font size=2><strong>Apmaksas gala termiòð:</strong></td>
			<td align=left><input type=text name=term3_dat value="<%=datePrint(rGrupa("term3_dat"))  %>" size=15>
			</td>
		</tr>
		<% 'response.write("select * from grupa where id = "+gid)
		set rGrupa = conn.execute ("select * from grupa where id = "+gid)
		'cik pieteikumi?
		piet_saite_sk = conn.execute("select count(*) from piet_saite where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and gid = "+gid+")")(0)
		if piet_saite_sk > 1 and (ucase(mid(kods,4,1))="P" or ucase(mid(kods,4,1))="S") then
		 set rcenas = conn.execute("select sum(summaLVL) as lvl,sum(summaUSD) as usd,sum(summaEUR) as eur from pieteikums where deleted = 0 and gid = "+cstr(gid))
		%>
		<!--<tr>
			<td align=right><font size=2><strong>Cena LVL:</strong></td>
			<td align=left><input type=hidden name=i_cena value="<%=rGrupa("i_cena")%>" size=8><%=currprint(getnum(rcenas("lvl")))%> <b><font size=2>Cenu nevar mainît, jo ir vairâki pieteikumi</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Cena USD:</strong></td>
			<td><input type=hidden name=i_cena_usd value="<%=rGrupa("i_cena_usd")%>" size=8><%=currprint(getnum(rcenas("usd")))%><b><font size=2> Mainiet cenu pieteikumos</td>
		</tr>-->
		<tr>
			<td align=right><font size=2><strong>Cena EUR:</strong></td>
			<td><input type=hidden name=i_cena_eur value="<%=rGrupa("i_cena_eur")%>" size=8><%=currprint(getnum(rcenas("eur")))%></td>
		</tr>
		
  <%
		else
		%>
		<!--
		<tr>
			<td align=right><font size=2><strong>Cena LVL:</strong></td>
			<td align=left><input type=text name=i_cena value="<%=rGrupa("i_cena")%>" size=8 <% If valuta = "EUR" Then response.write " disabled "%>></td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Cena USD:</strong></td>
			<td><input type=text name=i_cena_usd value="<%=rGrupa("i_cena_usd")%>" size=8></td>
		</tr>-->
		<tr>
			<td align=right><font size=2><strong>Cena EUR:</strong></td>
			<td><input type=text name=i_cena_eur value="<%=rGrupa("i_cena_eur")%>" size=8></td>
		</tr>
				<tr>
			<td align=right><font size=2><strong>Pçdçjâs dienas cena EUR:</strong></td>
			<td><input type=text name=pm_cena value="<%=rGrupa("pm_cena")%>" size=8></td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Pçdçjâs vietas dzimums:</strong></td>
			<td>
				<select name="ped_vietas_dzimums">
					<option value=""></option>
					<option value="S" <% if (rGrupa("ped_vietas_dzimums") = "S") then response.write "selected" end if%>>Sieviete</option>
					<option value="V" <% if (rGrupa("ped_vietas_dzimums") = "V") then response.write "selected" end if%>>Vîrietis</option>
				</select>
			</td>
		</tr>
		<% end if %>
			
		<tr>
			<td align=right><font size=2><strong>Vietas autobusâ:</strong></td>
			<td align=left><input type=text name=vietsk value="<%=rGrupa("vietsk")%>" size=3>
			  <font size=2><strong>Vietas naktsmîtnçs:</strong>
			  <input type=text name=vietsk_nakts value="<%=rGrupa("vietsk_nakts")%>" size=3>
			  <font size=2><strong>Avio vietas:</strong>
			  <input type=text name=avio_vietas value="<%=rGr("avio_vietas")%>" size=3>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>1. Vadîtâjs:</strong></td>
			<td>
			 <select name=vaditajs>
			  <option value=0>Nav norâdîts</option>
			  <% 
			   set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards, uzvards")
			   while not rVaditajs.eof
			    %><option 
			    <% if rGrupa("vaditajs")=rVaditajs("idnum") then Response.Write " selected "%>
			    value=<%=rVaditajs("idnum")%>><%=rVaditajs("vards")+" "+rVaditajs("uzvards")%></option><%
			    rVaditajs.movenext
			   wend
			  %>
			 </select>
			 <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
			 <input type=hidden name=vad size=15 value="<%=rGrupa("vad")%>"><%=rGrupa("vad")%>
			  <a href="c_grupu_vad_grafiks.php?datums=<%=Year(rGrupa("sakuma_dat"))%>_<%=Month(rGrupa("sakuma_dat"))%>" target="_blank">Skatît grupas vadîtâju grafiku</a></td>
			 
		</tr>
		<tr>
			<td align=right><font size=2><strong>2. Vadîtâjs:</strong></td>
			<td>
			 <select name=vaditajs2>
			  <option value=0>Nav norâdîts</option>
			  <% 
			   set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards, uzvards")
			   while not rVaditajs.eof
			    %><option 
			    <% if rGrupa("vaditajs2")=rVaditajs("idnum") then Response.Write " selected "%>
			    value=<%=rVaditajs("idnum")%>><%=rVaditajs("vards")+" "+rVaditajs("uzvards")%></option><%
			    rVaditajs.movenext
			   wend
			  %>
			 </select>
			 <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Kurators:</strong></td>
			<td><select name=kurators>
			  <option value="0">-</option>
			  <% set rKurators = conn.execute("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12) order by vards ")
			  while not rKurators.eof
			   response.write "<option value="+cstr(rKurators("id"))+" "
			   if rKurators("id") = rGrupa("kurators") then response.write " selected "
			   response.write ">"+rKurators("v")+" "+rKurators("uzvards")
			   response.write "</Option>"
			   rKurators.movenext
			  wend
			  %></select>
			</td>
		</tr>
		<% if mid(kods,4,1) = "V" or mid(kods,4,1) = "T" then %>
		<% set rGrupa = conn.execute ("select * from grupa where id = "+gid) %>
		<tr>
			<td align=right><font size=2><strong>Kavçtâju meklçtâjs:</strong></td>
			<td><% 'response.write(getnum(rGrupa("kontrolieris")))'response.write("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by vards ") 
			%>  <select name=kontrolieris>
			  <option value="0">-</option>
			  <% set rKurators = conn.execute("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by vards ")
			  
			  while not rKurators.eof
				response.write "<option value="+cstr(rKurators("id"))+" "
				if rKurators("id") = getnum(rGrupa("kontrolieris")) then response.write " selected "
				response.write ">"+rKurators("v")+" "+rKurators("uzvards")
				response.write "</Option>"
			   rKurators.movenext
			  wend
			  %></select>&nbsp;
			  <input type="image" src="impro/bildes/diskete.jpg" alt="Saglabât izmaòas laukâ - Kavçtâju mekçtâjs." onclick="javascript: TopSubmit('grupa_save.asp?kontrolieris='+forma.kontrolieris.value)" name="save_kontrolieri">
			  
			</td>
		</tr>
		<% else %>
		 <input type=hidden value=<%=rGrupa("kontrolieris")%> name=kontrolieris>
		<% end if 'mid(kods,4,1)="V"%>
		<tr>
			<!--<td align=right><font size=2><strong>Starpnieks:</strong></td>
			<td>
			 <input type=text name=starpnieks size=6 value="<%=rGrupa("starpnieks")%>">
			 <%
			 if not isnull(rGrupa("starpnieks")) then
			  set rStarpnieks = conn.execute("select * from dalibn where id = "+cstr(getnum(rGrupa("starpnieks"))))
			  if not rStarpnieks.eof then
			   %><a href=dalibn.asp?i=<%=rStarpnieks("id")%> target=_new><%
			   response.write nullprint(rStarpnieks("vards"))+" "
			   response.write nullprint(rStarpnieks("uzvards"))+" "
			   response.write nullprint(rStarpnieks("nosaukums"))
			   %></a><%
			  end if
			 end if
			 %>
			</td>-->
		</tr>
		<tr>
			<td align=right><font size=2><strong>Autobuss:</strong></td>
			<td align=left>
			
			 <select name=autobuss_id  style="width:40%;">
			  <option value=0>Nav norâdîts</option>
			  <% 
			   set rAutobuss = conn.execute("select autobusi.nosaukums as anos, partneri_auto.nosaukums as pnos,autobusi.id from Autobusi,partneri_auto where autobusi.partneris = partneri_auto.id and autobusi.deleted=0 order by pnos,autobusi.nosaukums")
			   while not rAutobuss.eof
			    %><option 
			    <% if rAutobuss("id")=rGrupa("autobuss_id") then Response.Write " selected "%>
			    value=<%=rAutobuss("id")%>><%=Decode(rAutobuss("pnos") + " - " +rAutobuss("anos"))%></option><%
			    rAutobuss.movenext
			   wend
			  %>
			 </select><font size=2> 
			 <a href="c_autobusi.php" target="autobusi"> Labot</a>
			 <font size=2><strong> A.piezîmes: </strong></font><input name=autobuss  value="<%=rGrupa("autobuss")%>"/>
			
			<!--<input type=hidden name=autobuss value="<%=rGrupa("autobuss")%>" size=8><%=rGrupa("autobuss")%>-->
		</td>
		
	</tr>
	
	<!--
	<tr>
		<td align=right>
			<font size=2><strong>A. cena: </strong>
		</td>
		<td>
			<input type=text name=autobusa_cena value="<%=rGrupa("autobusa_cena")%>" size=15>
			</td>
	</tr>-->
		<tr>
			<td align=right><font size=2><strong>Íçde:</strong></td>
			<td align=left><select name="kede">
			<option></option>
			<% for i=1 to 25 step 1
				%><option value="<%=i%>" <% if rGrupa("kede") = cstr(i) then response.write "selected"%>><%=i%>.</option><%
			next%></select></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Dokumenti:</strong></td>
				<td align=left><textarea name=dokumenti cols=70 rows=3><%=rGrupa("dokumenti")%></textarea>
				</td>
			</tr>
	<tr>
			<td align=right><font size=2><strong>Piezîmes:</strong></td>
			<td align=left><textarea name=piezimes cols=70 rows=3><%=rGrupa("piezimes")%></textarea>
			</td>
		</tr>
		<% if IsAccess(T_GRUPU_PAPILD_INFO) then %>
		<tr><td colspan=2><hr></td></tr>
		<%  set rGrupa = conn.execute(ssql) %>

		<tr>
			<td align=right><font size=2><strong>Pazîme:</strong></td>
			<td align=left><input type=text name=ln value="<%=TRIM(rGrupa("ln"))%>" maxlength=1 size=1>
			<strong><font size=2>Vadîtâjs:</strong>
			<select name=vad_id>
				<option value="">-</option>
				<% set rVad = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards ")
				while not rVad.eof
				 response.write "<option value="+cstr(rVad("id"))+" "
				 if rVad("id") = rGrupa("vad_id") then response.write " selected "
				 response.write ">"+rVad("vards")+" "+rVad("uzvards")
				 response.write "</Option>"
				 rvad.movenext
				wend %>
			</select>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Papildus piezîmes:</strong></td>
			<td align=left><input type=text name=piezimes2 value="<%=rGrupa("piezimes2")%>"  size=35>
		<% end if %>
		<tr>
			<td align=right><font size=2><strong>Pazîmes:</strong></td>
			<td align=left><input type=text name=pazimes value="<%=rGrupa("pazimes")%>"  size=10> (D - dâvanu karte)
		</tr>
		<tr>
			<td align=right></td>
			<td align=left></td>
		</tr>

		</table>
	</td>

	<td valign=top>
		<li><a href = 'grupa_param.asp<%=qstring()%>'><font color="GREEN" size="3"><b>Grupas saraksts</b></font></a></li>
		<% if getnum(rGrupa("kajites_gid"))<>0 then %>
			<li><a href = 'kajite.asp?gid=<%=rGrupa("kajites_gid")%>'><font color="GREEN" size="3"><b>Kajîtes</b></font></a></li>
			<li><a href = 'kajites_veidi.asp?gid=<%=rGrupa("kajites_gid")%>'><b><font color = "GREEN">Kajîðu veidi</b></font></a></li>
		<% else %>
			<li><a href = 'kajite.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Kajîtes</b></font></a></li>
			<li><a href = 'kajites_veidi.asp?gid=<%=gid%>'><b><font color = "GREEN">Kajîðu veidi</b></font></a></li>
		<% end if %>
		<li><a href = 'viesnicas.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Viesnicu numuri</b></font></a></li>
			<li><a href = 'viesnicas_veidi.asp?gid=<%=gid%>'><b><font color = "GREEN">Viesnicu numuru veidi</b></font></a></li>
		<li><a href = 'vietu_veidi.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></li>
		<!--<li><a href = 'limits.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Vietu ierobeþojumi</b></font></a></li>-->
		<li><a href = 'pieteikumi_grupaa.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Pieteikumi grupâ</b></font></a></li>
		<li><a href="pieteikumi_grupaa.asp?gid=<%=gid%>&mode=ligums"><font color="GREEN" size="3"><b>Lîgumi</b></font></a></li>
		<% if rGrupa("veids")="1" then %>
		<li><a href = 'interesenti.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Interesenti</b></font></a></li>
		<% 
		 elseif len(rGrupa("kods"))>4 then
		  if mid(rgrupa("kods"),4,1) = "P" or mid(rgrupa("kods"),4,1) = "S" then
		  %><li><a href = 'kontakti.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Kotaktpersonas</b></font></a></li><% 
		  end if
		end if %>
		<li><a href="grupa_voucer_edit.asp?gid=<%=gid%>"><font color="GREEN" size="3"><b>Vauèera rediìçðana</b></a></li>
		<li><a href="c_grupas_dati_nosutiti.php?gid=<%=gid%>"><font color="GREEN" size="3"><b>Grupas dati nosûtîti</b></a></li>
		<% if IsAccess(T_CELOJUMU_APR) then %>
		<li><a href="c_celojuma_apraksts.php?gid=<%=gid%>"><font color="GREEN" size="3"><b>Ceïojuma apraksta pievienoðana</b></a></li>
		<% end if %>
		<% if pdf<>"" then%>
		<br>
		<li><a href="http://www.impro.lv/pdf/<%=pdf%>.pdf" target="_blank"><font color="GREEN" size="3"><b>Ceïojuma apraksts</b></a></li>
		<% end if%>
		<li><a href="c_grupas_sar_soc.php?gid=<%=gid%>" target="_blank"><font color="GREEN" size="3"><b>Saraksts sociâlajiem tîkliem</b></a></lid>
		<!--<li><a href = 'piet_summas.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Pârrçíinât summas</b></font></a></li>-->
		<br><br>
		<table>
		
			<%
			query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
			" and gid = "+cstr(gid)+" and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) and piet_saite.deleted = 0 " + _
			" and (kvietas_veids in (1,2,4,5) or persona = 1 )  and (not isnull(kvietas_veids,0) = 3)"
			
			'rw query
			
			set aizn_vietas = conn.execute(query)

			set personas = conn.execute(query+" and (not isnull(kvietas_veids,0) = 3)")
			'rw query+" and (not isnull(kvietas_veids,0) = 3)"

			query = "SELECT sum(piet_saite.vietsk) as sk " +_
				"FROM grupa,pieteikums,piet_saite " +_
				"WHERE grupa.id = "+cstr(gid)+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) );"
			set pap = conn.execute(query)
			
   set riemaksas = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where deleted = 0 and pid in (select id from pieteikums where gid = "+cstr(gid)+")")
   set riemaksasN = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where parbaude = 1 and deleted = 0 and pid in (select id from pieteikums where gid = "+cstr(gid)+")")
   set rizmaksas = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd  from orderis where deleted = 0 and nopid in (select id from pieteikums where gid = "+cstr(gid)+")")
   
			rnauda2=conn.execute("select sum(atlaidesLVL) as atLVL, sum(atlaidesUSD) as atUSD, sum(atlaidesEUR) as atEUR, sum(atlaidesBIL) as atBIL, sum(sadardzinLVL) as piemLVL, sum(sadardzinUSD) as piemUSD, sum(sadardzinEUR) as piemEUR, sum(sadardzinBIL) as piemBIL, sum(summaLVL) as sumLVL, sum(summaUSD) as sumUSD, sum(summaEUR) as sumEUR, sum(iemaksasLVL) as iemLVL, sum(iemaksasUSD) as iemUSD, sum(iemaksasEUR) as iemEUR, sum(izmaksasLVL) as izmLVL, sum(izmaksasUSD) as izmUSD, sum(izmaksasEUR) as izmEUR, sum(bilanceLVL) as bilLVL, sum(bilanceUSD) as bilUSD, sum(bilanceEUR) as bilEUR from pieteikums where gid="+cstr(gid)+" and (deleted = 0) and (isnull(tmp,0)=0 OR agents_izv=1) and id in (select pid from piet_saite where deleted = 0)")
			
			%>
			<tr>
				<td align=right><font size=2><strong>Personas:</strong></td>
				<td ><font size=2><%=getnum(personas("aizn"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Jauni klienti:</strong></td>
				<td ><font size=2><%=getnum(rjaunie("c"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Papildvietas:</strong></td>
				<td ><font size=2><%=getnum(pap("sk"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Brîvas vietas:</strong></td>
				<td ><font size=2><%=BrivasVietasGrupa(gid)%>
				</td>
			</tr>
			<% 

			if 1=1 then
			'if rGrupa("veids") <> 2 and rGrupa("veids") <> 3 then 
			'izmainîts, ja viss bûs kârtîbâ else zaru jâmet ârâ
			%>
			<tr>
				<td align=right><font size=2><strong>Jâmaksâ:</strong></td>
				<td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("sumLVL"),rnauda2("sumUSD"),rnauda2("sumEUR"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Atlaides:</strong></td>
				 <td ><font size=2><font color=green><%=Curr3Print2(rnauda2("atLVL"),rnauda2("atUSD"),rnauda2("atEUR"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Piemaksas:</strong></td>
				 <td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("piemLVL"),rnauda2("piemUSD"),rnauda2("piemEUR"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Faktiski jâmaksâ:</strong></td>
				<td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("sumLVL")-rnauda2("atLVL")+rnauda2("piemLVL"),rnauda2("sumUSD")-rnauda2("atUSD")+rnauda2("piemUSD"),rnauda2("sumEUR")-rnauda2("atEUR")+rnauda2("piemEUR"))%></td>
			</tr>
			<% else %>
			<tr>
				<td align=right><font size=2><strong>Jâmaksâ pieteikumos:</strong></td>
				<td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("sumLVL"),rnauda2("sumUSD"),rnauda2("sumEUR"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Jâmaksâ:</strong></td>
				<td ><font size=2><font color=blue><%=Curr3Print2(getnum(rGrupa("i_cena")),getnum(rGrupa("i_cena_usd")),,getnum(rGrupa("i_cena_eur")))%></td>
			</tr>
			<% end if %>
			<tr>
				<td align=right><font size=2><strong>Iemaksâts:</strong></td>
				<td><nobr><font size=2 color=green><%=Curr3Print2(rnauda2("iemLVL"),rnauda2("iemUSD"),rnauda2("iemEUR"))%></td>
			</tr>
			<tr>
				<td align=right><font size=2><strong>Izmaksâts:</strong></td>
				<td ><nobr><font size=2><font color=blue><%=Curr3Print2(rnauda2("izmLVL"),rnauda2("izmUSD"),rnauda2("izmEUR"))%></td>
			</tr>
			<% 
			if 1=1 then 
			'if rGrupa("veids") <> 2 and rGrupa("veids") <> 3 then 
			%>
			<tr>
				<td align=right><font size=2><strong>Bilance:</strong></td>
				<td ><font size=2><b>
				<%if rnauda2("bilLVL")<0 or rnauda2("bilUSD")<0 or rnauda2("bilEUR")<0 then %>
				 <font color=red>
				<% else %>
				 <font color=green>
				<% end if %>
				<%=Curr3Print2(rnauda2("bilLVL"),rnauda2("bilUSD"),rnauda2("bilEUR"))%></td>
		    	</tr>
		   	<% else %>
			<tr>
				<td align=right><font size=2><strong>Bilance:</strong></td>
				<td ><font size=2><b>
				<%if -getnum(rGrupa("i_cena"))+getnum(rnauda2("iemLVL"))-getnum(rnauda2("izmLVL"))<0 or -getnum(rGrupa("i_cena_usd"))+getnum(rnauda2("iemUSD"))-getnum(rnauda2("izmUSD"))<0 or -getnum(rGrupa("i_cena_eur"))+getnum(rnauda2("iemEUR"))-getnum(rnauda2("izmEUR"))<0 then %>
				 <font color=red>
				<% else %>
				 <font color=green>
				<% end if %>
				<%=Curr3Print2(-getnum(rGrupa("i_cena"))+getnum(rnauda2("iemLVL"))-getnum(rnauda2("izmLVL")),-getnum(rGrupa("i_cena_usd"))+getnum(rnauda2("iemUSD"))-getnum(rnauda2("izmUSD")),-getnum(rGrupa("i_cena_eur"))+getnum(rnauda2("iemEUR"))-getnum(rnauda2("izmEUR")))%></td>
			</tr>
			<% end if %>
		</table><br><br>
		<table>
		 <tr><td colspan=2 align=center><b>Bilancei</td></tr>
		 <tr>
		  <td><font size=2><b>Iemaksas</td>
		  <%
		  
		  %>
		  <td><font size=2><%=curr3total(riemaksas("lvl"),riemaksas("usd"),riemaksas("eur"))%>
		   <% if getnum(riemaksasN(0)) <> 0 then %>
		    <BR>- <%=curr3total(riemaksasN("lvl"),riemaksasN("usd"),riemaksasN("eur"))%> (neapstiprinâts) 
			<BR>= <b> <%=curr3total(getnum(riemaksas("lvl"))-getnum(riemaksasN("lvl")), getnum(riemaksas("usd"))-getnum(riemaksasN("usd")), getnum(riemaksas("eur"))-getnum(riemaksasN("eur")))%></b>
		   <% end if 
		   
		   %>
		  </td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Izmaksas</td>
		  <td><font size=2><%=curr3total(rizmaksas("lvl"),rizmaksas("usd"),rizmaksas("eur"))%></td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Atlaides</td>
		  <td><font size=2><%=curr3total(rnauda2("atlvl"),rnauda2("atusd"),rnauda2("ateur"))%></td>
		 </tr>
		 <tr>
		  <td><font size=2><b>Piemaksas</td>
		  <td><font size=2><%=curr3total(rnauda2("piemlvl"),rnauda2("piemusd"),rnauda2("piemeur"))%></td>
		 </tr>
		</table>
	</td>

	</tr>
</table>
<center>
<%if gr_lab1 then %> 
 <input type=image src="impro/bildes/diskete.jpg" alt="Saglabât izmaiòas.">
<% end if %>
<input type=image src="impro/bildes/aizvert.bmp" alt="Aizvçrt logu. Atgriezties uz sarakstu." onclick="window.close();return false;">
<a href="vesture.asp?tabula=grupa&id=<%=gid%>" target=vesture><img style="border:0px" src="impro/bildes/clock.bmp" alt="Vçsture"></a>
<%
set r = conn.execute("select isnull(count(id),0) as x from pieteikums where deleted = 0 and gid = "+cstr(gid))
if r("x")=0 then
	%>
	<a href="grupa_del.asp?gid=<%=gid%>"><img style="border:0px" onclick="return confirm('Dzçst grupu?');" src="impro/bildes/dzest.jpg" alt="Dzest"></a>
	<%
end if
%>
</body>
</html>
