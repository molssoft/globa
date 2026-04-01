<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1257"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
gid = request.querystring("gid")

''response.redirect "grupa_edit2.asp?gid="+gid

''============================================================
''============================================================
''============================================================
dim carter, carter_viesn_id, rGrupa, c_vid
dim izbr_vieta, iebr_vieta, ssql, izbr, iebr, ielid_laiks_uz, ielid_laiks_no
Dim pdf, block, sapulces_laiks_no, sapulces_laiks_lidz

if session("require_add_pakalpojumi") = 1 then
	Response.Redirect "vietu_veidi.asp?gid="+cstr(gid)
	session("require_add_pakalpojumi") = 0
	session("return_to_grupa_edit") = 1
end if

ssql = "select g.standarta_viesnicas as sv, g.*, g.pdf as apraksts, lidojums, carter_viesn_id as c_vid,kede from grupa g left join portal.dbo.grupas pg ON pg.gr_kods = g.kods AND g.pdf IS NOT NULL where g.id = "&gid

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

ielid_laiks_uz = rGr("ielid_laiks_uz") '--- ielido�anas laiks uz m�r�i
ielid_laiks_no = rGr("ielid_laiks_no") '--- ielido�anas laiks no m�r�a
sapulces_dat = rGr("sapulces_dat")
pdf = rGrupa("apraksts")
carter_viesn_id = rGrupa("c_vid") 'rGrupa("carter_viesn_id")!!!! nedarbojas. ja ieliek priek�� izbr_vieta, tad nedarbojas izbr_vieta wtf?
carter = rGr("carter")
online = rGr("internets")
garantets = rGr("garantets")
internets_no = rGr("internets_no")
nevajag_pases = rGr("nevajag_pases")
eklase = rGr("eklase")
pardot_agentiem = rGr("pardot_agentiem")


set rMarsruts = conn.execute ("select * from marsruts where id = "+cstr(rGr("mid")))
%>

<%
Response.Charset = "Windows-1257"
Response.ContentType = "text/html"
docstart "Grupas labo&#353;ana","y1.jpg"

DefJavaSubmit

%>

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

if request.querystring("message") <> "" then
   %><font color="RED" size="4"><%=request.querystring("Message")%></font><% 
   session("message") = ""
end if 
%>

<%
 'Nosakam ties�bas labot
 if IsAccess(T_GR_LAB1) then gr_lab1 = true else gr_lab1 = false
 if IsAccess(T_GR_LAB2) then gr_lab2 = true else gr_lab2 = false
%>
<form name=forma action=grupa_save.php method=POST>
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
			<strong>Grupa blo��ta: </strong></td>
			<%	
			b_type = 0
			if block = 1 then
				b_type = block 'rGrupa("blocked")
			end if
					
			if not gr_lab2 then %>
			 <td align=left><%=getBlockType(b_type)%><input type=hidden name=blocked value="<%=b_type%>" size=15>
			<%else%>
			 <td align=left><%=comboBlockType(b_type)%>
			<%end if%>
		    </td>
		</tr>
		<% else %>
		<% end if%>	
		<tr>
			<td align=right><font size=2><strong>P�rdot Online: </strong></font></td>
			<td><input name="online" type="checkbox" <%if online then Response.Write " checked "%> >
			<input type=hidden name=internets_no size=8 value=<%=DatePrint(rGr("internets_no"))%>>
			</td>
		</tr>
		<tr>
			<td align=right><font size=2><strong>Garant�ts: </strong></font></td>
			<td><input name="garantets" type="checkbox" <%if garantets then Response.Write " checked "%> >
		</tr>
		<tr>
			<td align=right>
				<font size=2><strong>LV ce�ojums, online nevajag nor�d�t pasi:</strong></font></td>
			<td>	<input name="nevajag_pases" type="checkbox" <%if nevajag_pases then Response.Write " checked "%> >
			</td>
		</tr>			
		<tr>
			<td align=right><font size=2><strong>P�rdot a�entiem s�kot ar: </strong></font></td>
			<td><input name="pardot_agentiem" type="hidden" <%if pardot_agentiem then Response.Write " checked "%> > <input type=text name=pardot_agentiem_no size=8 value=<%=DatePrint(rGr("pardot_agentiem_no"))%>></td>
		</tr>	
		<!--
		<tr>
			<td align=right><font size=2><strong>E-klase: </strong></font></td>
			<td><input name="eklase" type="checkbox" <%if eklase then Response.Write " checked "%> >
			E-klases lietot�jiem ce�ojums ar atlaidi 5%
			</td>
		</tr-->			  
		<tr>
			<td align=right><font size=2>
			<strong><font size=2>Ie��mumu konts: </strong></td>
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
<td align=right><font size=2><strong>Mar�ruts:</strong></td>
    <td align=left>
     <input type=text name=v value="<%=ReplaceChar(rMarsruts("v"),"""","&#34")%>" size=60><a href=marsruts_add.asp?gid=<%=rGrupa("id")%> target=new>+</a>
     <% 
      'nosakam dubultos mar�rutus 
      if not isnull(rGrupa("beigu_dat")) then
       set r = conn.execute("select isnull(count(*),0) from marsruts where v2 = '"+SQLText(rMarsruts("v2"))+"' and id in (select mid from grupa where beigu_dat>='1/1/"+cstr(year(rGrupa("beigu_dat")))+"' and beigu_dat<'1/1/"+cstr(year(rGrupa("beigu_dat"))+1)+"')")
       if r(0)>1 then
        Response.Write "<br>Dubultie mar&scaron;ruti:"+cstr(r(0)) %> <a href=marsruts_apvienot.asp?id=<%=rMarsruts("id")%>&gads=<%=year(rGrupa("beigu_dat"))%> target=new>Apvienot</a><%
       end if
      end if
     %>
    </td>
</tr>
<tr>
<td align=right><font size=2><strong>�arteris: </strong></font></td>
    <td>
    <input id="carter" name="carter" type="checkbox" <%if carter then Response.Write " checked "%> >
    <span id="carter_viesn">
        <font size=2><strong>Viesn�ca: </strong>
        <select id="carter_viesn_id" name="carter_viesn_id">
          <option value="0">-</option>
          <% 
          '--- vec�s �arterviesn�cas jaun�m grup�m sl�pj
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
    <td align=right><font size=2><strong>Vietas lidojum�:</strong></td>
    <td align=left>
        <input type=text name=lidojums_vietas value="<%=lidojums_vietas%>" size=4 >
    </td>
</tr>
<tr>
    <td align=right><font size=2><strong>Viesn�cu numuri:</strong></td>
    <td align=left><%=conn.execute("select count(*) from viesnicas where gid = "+cstr(gid))(0)%></td>
</tr>
<tr>
    <td align=right><font size=2><strong>Standarta viesn�cas:</strong></td>
    <td align=left>
        <input type=checkbox name=standarta_viesnicas id="standarta_viesnicas" size=50><br />
    </td>
</tr>
        <tr>
            <td></td>
            <td><div id="standarta_viesnicas_message" style="width: 500px; display: none;">Ja v�laties, lai pie standarta viesn�c�m tiktu izveidoti ar� SINGLE numuri�i, l�dzu, p�rliecinieties vai grupai ir pievienots pakalpojums ar tipu "Piemaksa SGL"! <a href='vietu_veidi.asp?gid=<%=gid%>' target="_blank"><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></div></td>
        </tr>
		<!--
		<tr>
			<td align=right><font size=2><strong>S�t�t epastu par atteikumiem:</strong></td>
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
		<% if rgrupa("veids") = 2 or rgrupa("veids") = 4 then %>
		<tr>
		<td align=right><font size=2><strong>Klients:</strong></td>
			<td align=left>
			  <input type=hidden name=klients value=<%=rGrupa("pasutitajs")%>>
			  <input type=button value=Mekl�t onclick="window.open('dalibn_izvele.asp?return_id=forma.klients&return_name=klients')" id=button1 name=button1>
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


				<select name=valsts_dala>
				<option value="X">-</option>
				<% set rDalas = conn.execute("select * from portal.dbo.Geo WHERE " + _	
					" type_id in ('P','D') " + _ 
					" AND parent_id = '" + trim(nullprint(rMarsruts("valsts"))) + "' " + _ 
					" order by title ")
				while not rDalas.eof
					response.write "<option value="+cstr(rDalas("id"))+" "
					if trim(rDalas("id")) = trim(rMarsruts("valsts_dala")) then response.write " selected "
					 response.write ">"+rDalas("title")
					 response.write "</Option>"
					 rDalas.movenext
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
			<td align=right><font size=2><strong>Val�ta:</strong></td>
			<td align=left nowrap><input type=text name=valuta value="<%=valuta%>" size=3 ></td>
		</tr-->		
		<tr>
			<td align=right><font size=2><strong>S�kuma datums:</strong></td>
			<td align=left nowrap><input type=text name=sakuma_dat value="<%=datePrint(rGrupa("sakuma_dat"))%>" size=15></td>
		</tr>
		<tr>
			<td align=right><font size=2>
			<%if inStr(rGrupa("kods"),".V.7.")<>0 then%>			
				<strong>Izlido�anas laiks un vieta: </strong>
			<%else%>
				<strong>Izbrauk�anas laiks un vieta: </strong>
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
    <td align=right><strong><font size=2>Ielido�anas laiks galam�r��:</font></strong></td>
    <td align=left><input type=text name=ielid_laiks_uz value="<%rw timeprint2(ielid_laiks_uz) %>" size=5></td>
</tr>
<%end if%>
<tr>
    <td align=right><font size=2><strong>Beigu datums:</strong></font></td>
    <td align=left><input type=text name=beigu_dat value="<%=datePrint(rGrupa("beigu_dat"))%>" size=15></td>
</tr>
<input type=hidden name=ielid_laiks_no value="<%rw timeprint2(ielid_laiks_no) %>" size=5>
<tr>
    <td align=right><strong><font size=2>Druk�t vau�erus:</font></strong></td>
    <td align=left><input type=checkbox name=drukat_vauceri <%if drukat_vauceri then Response.Write " checked "%> size=50></td>
</tr>
<input type=hidden name=reiss_uz value="<%rw reiss_uz %>" size=5>
<tr>
    <td align=right><font size=2>
    <%if inStr(rGrupa("kods"),".V.7.")<>0 then%>    
        <strong>Ielido�anas laiks un vieta: </strong>
    <%else%>
        <strong>Iebrauk�anas laiks un vieta: </strong>
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
    <td align=right><font size=2><strong>Sapulces datums:</strong></font></td>
    <td align=left>
        <input type=text name=sapulces_dat value="<%=datePrint(sapulces_dat)%>" size=15>
        <font size=2><strong>Laiks:</strong>
        <input type=text name="sapulces_laiks_no" value="<%=sapulces_laiks_no%>" size=5>
        <strong>-</strong>
        <input type=text name="sapulces_laiks_lidz" value="<%=sapulces_laiks_lidz%>" size=5>
        </font>
    </td>
</tr>
<% set rGrupa = conn.execute ("select * from grupa where id = "+gid)%>
<tr>
    <td align=right><font size=2><strong>1. termi��:</strong></font></td>
    <td align=left>
        <input type=text name=term1_dat value="<%=datePrint(rGrupa("term1_dat"))%>" size=15>
        <strong><font size=2>1. summa <%=valuta%>:</strong>
        <input type=text name=term1_summa value="<%=rGrupa("term1_summa")%>" size=5>
        <strong><font size=2>zaud. <%=valuta%>:</strong>
        <input type=text name=term1_zaud_summa value="<%=rGrupa("term1_zaud_summa")%>" size=5>
    </td>
</tr>
<% set rGrupa = conn.execute("select * from grupa where id = "+gid) %>
<tr>
    <td align=right><font size=2><strong>2. termi��:</strong></td>
    <td align=left>
        <input type=text name=term2_dat value="<%=datePrint(rGrupa("term2_dat"))%>" size=15>
        <strong><font size=2>2. summa <%=valuta%>:</strong>
        <input type=text name=term2_summa value="<%=rGrupa("term2_summa")%>" size=5>
        <strong><font size=2>zaud. <%=valuta%>:</strong>
        <input type=text name=term2_zaud_summa value="<%=rGrupa("term2_zaud_summa")%>" size=5>
    </td>
</tr>

<% set rGrupa = conn.execute("select * from grupa where id = "+gid) %>
<tr>
    <td align=right><font size=2><strong>Apmaksas gala termi��:</strong></td>
    <td align=left><input type=text name=term3_dat value="<%=datePrint(rGrupa("term3_dat"))%>" size=15></td>
</tr>

<% 
set rGrupa = conn.execute("select * from grupa where id = "+gid)
piet_saite_sk = conn.execute("select count(*) from piet_saite where deleted = 0 and pid in (select id from pieteikums where deleted = 0 and gid = "+gid+")")(0)
if piet_saite_sk > 1 and (ucase(mid(kods,4,1))="P" or ucase(mid(kods,4,1))="S") then
    set rcenas = conn.execute("select sum(summaLVL) as lvl,sum(summaUSD) as usd,sum(summaEUR) as eur from pieteikums where deleted = 0 and gid = "+cstr(gid))
%>
<tr>
    <td align=right><font size=2><strong>Cena EUR:</strong></td>
    <td><input type=hidden name=i_cena_eur value="<%=rGrupa("i_cena_eur")%>" size=8><%=currprint(getnum(rcenas("eur")))%></td>
</tr>
<%
else
%>
<tr>
    <td align=right><font size=2><strong>Cena EUR:</strong></td>
    <td><input type=text name=i_cena_eur value="<%=rGrupa("i_cena_eur")%>" size=8></td>
</tr>
<tr>
    <td align=right><font size=2><strong>P�d�j�s dienas cena EUR:</strong></td>
    <td><input type=text name=pm_cena value="<%=rGrupa("pm_cena")%>" size=8></td>
</tr>
<tr>
    <td align=right><font size=2><strong>P�d�j�s vietas dzimums:</strong></td>
    <td>
        <select name="ped_vietas_dzimums">
            <option value=""></option>
            <option value="S" <% if (rGrupa("ped_vietas_dzimums") = "S") then response.write "selected" end if%>>Sieviete</option>
            <option value="V" <% if (rGrupa("ped_vietas_dzimums") = "V") then response.write "selected" end if%>>V�rietis</option>
        </select>
    </td>
</tr>
<% end if %>

<tr>
    <td align=right><font size=2><strong>Vietas autobus�:</strong></td>
    <td align=left>
        <input type=text name=vietsk value="<%=rGrupa("vietsk")%>" size=3>
        <font size=2><strong>Vietas naktsm�tn�s:</strong>
        <input type=text name=vietsk_nakts value="<%=rGrupa("vietsk_nakts")%>" size=3>
        <font size=2><strong>Avio vietas:</strong>
        <input type=text name=avio_vietas value="<%=rGr("avio_vietas")%>" size=3>
    </td>
</tr>

<tr>
    <td align=right><font size=2><strong>1. Vad�t�js:</strong></td>
    <td>
        <select name=vaditajs>
            <option value=0>Nav nor�d�ts</option>
            <% 
            set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards, uzvards")
            while not rVaditajs.eof
            %>
            <option <% if rGrupa("vaditajs")=rVaditajs("idnum") then Response.Write " selected "%> value=<%=rVaditajs("idnum")%>><%=rVaditajs("vards")+" "+rVaditajs("uzvards")%></option>
            <% rVaditajs.movenext
            wend %>
        </select>
        <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
        <input type=hidden name=vad size=15 value="<%=rGrupa("vad")%>"><%=rGrupa("vad")%>
        <a href="c_grupu_vad_grafiks.php?datums=<%=Year(rGrupa("sakuma_dat"))%>_<%=Month(rGrupa("sakuma_dat"))%>" target="_blank">Skat�t grupas vad�t�ju grafiku</a>
    </td>
</tr>

<tr>
    <td align=right><font size=2><strong>2. Vad�t�js:</strong></td>
    <td>
        <select name=vaditajs2>
            <option value=0>Nav nor�d�ts</option>
            <% 
            set rVaditajs = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards, uzvards")
            while not rVaditajs.eof
            %>
            <option <% if rGrupa("vaditajs2")=rVaditajs("idnum") then Response.Write " selected "%> value=<%=rVaditajs("idnum")%>><%=rVaditajs("vards")+" "+rVaditajs("uzvards")%></option>
            <% rVaditajs.movenext
            wend %>
        </select>
        <a href="javascript:void(window.open('vaditajs_new.asp'))"><img border=0 src="impro/bildes/pievienot.jpg"></a>
    </td>
</tr>
<tr>
    <td align=right><font size=2><strong>Kurators:</strong></td>
    <td>
        <select name=kurators>
            <option value="0">-</option>
            <% 
            set rKurators = conn.execute("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12) order by vards ")
            while not rKurators.eof
                response.write "<option value=" & cstr(rKurators("id")) & " "
                if rKurators("id") = rGrupa("kurators") then response.write " selected "
                response.write ">" & rKurators("v") & " " & rKurators("uzvards")
                response.write "</option>"
                rKurators.movenext
            wend
            %>
        </select>
    </td>
</tr>

<% if mid(kods,4,1) = "V" or mid(kods,4,1) = "T" then %>
    <% set rGrupa = conn.execute ("select * from grupa where id = "+gid) %>
    <tr>
        <td align=right><font size=2><strong>Kontroliera mekl�t�js:</strong></td>
        <td>
            <select name=kontrolieris>
                <option value="0">-</option>
                <% 
                set rKurators = conn.execute("select vards as v, * from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=21) order by vards ")
                while not rKurators.eof
                    response.write "<option value=" & cstr(rKurators("id")) & " "
                    if rKurators("id") = getnum(rGrupa("kontrolieris")) then response.write " selected "
                    response.write ">" & rKurators("v") & " " & rKurators("uzvards")
                    response.write "</option>"
                    rKurators.movenext
                wend
                %>
            </select>&nbsp;
            <input type="image" src="impro/bildes/diskete.jpg" alt="Saglab�t izmai�as lauk� - Kontroliera mekl�t�js." onclick="javascript: TopSubmit('grupa_save.php?kontrolieris='+forma.kontrolieris.value)" name="save_kontrolieri">
        </td>
    </tr>
<% else %>
    <input type=hidden value=<%=rGrupa("kontrolieris")%> name=kontrolieris>
<% end if %>

<tr>
    <td align=right><font size=2><strong>Autobuss:</strong></td>
    <td align=left>
        <select name=autobuss_id style="width:40%;">
            <option value=0>Nav nor�d�ts</option>
            <% 
            set rAutobuss = conn.execute("select autobusi.nosaukums as anos, partneri_auto.nosaukums as pnos, autobusi.id from Autobusi, partneri_auto where autobusi.partneris = partneri_auto.id and autobusi.deleted=0 order by pnos, autobusi.nosaukums")
            while not rAutobuss.eof
            %>
                <option <% if rAutobuss("id")=rGrupa("autobuss_id") then Response.Write " selected "%> value=<%=rAutobuss("id")%>><%=Decode(rAutobuss("pnos") & " - " & rAutobuss("anos"))%></option>
            <% 
            rAutobuss.movenext
            wend
            %>
        </select>
        <font size=2><a href="c_autobusi.php" target="autobusi"> Labot</a></font>
        <font size=2><strong> A.piez�mes: </strong></font><input name=autobuss value="<%=rGrupa("autobuss")%>"/>
    </td>
</tr>

<tr>
    <td align=right><font size=2><strong>��de:</strong></td>
    <td align=left>
        <select name="kede">
            <option></option>
            <% for i=1 to 25
                %><option value="<%=i%>" <% if rGrupa("kede") = cstr(i) then response.write "selected"%>><%=i%>.</option><%
            next %>
        </select>
    </td>
</tr>

<tr>
    <td align=right><font size=2><strong>Dokumenti:</strong></td>
    <td align=left><textarea name=dokumenti cols=70 rows=3><%=rGrupa("dokumenti")%></textarea></td>
</tr>

<tr>
    <td align=right><font size=2><strong>Piez�mes:</strong></td>
    <td align=left><textarea name=piezimes cols=70 rows=3><%=rGrupa("piezimes")%></textarea></td>
</tr>

<tr>
    <td align=right><font size=2><strong>Mekl�t�jam draudz�ga saite:</strong></td>
    <td align=left><input type=text name=slug size=70 value="<%=rGrupa("slug")%>"></td>
</tr>

<tr>
    <td align=right><font size=2><strong>Vietu apraksti m�jas lapai:</strong></td>
    <td align=left>
        <select name="vietu_apraksts" id="vietu_apraksts">
            <option value=""></option>
            <%
            set rApr = conn.execute("select id, nosaukums from portal.dbo.vietu_apraksti order by nosaukums")
            while not rApr.eof
                response.write "<option value='" & cstr(rApr("id")) & "'>" & rApr("nosaukums") & "</option>"
                rApr.movenext
            wend
            %>
        </select> <a href="c_vietu_apraksti.php" target="_blank">Skat�t aprakstus</a>
		
		<%
		
	
		
			set rAprPievienotie = conn.execute (" select mva.id, va.nosaukums  " + _
			" from portal.dbo.vietu_apraksti va  " + _
			" join portal.dbo.Marsruti_vietu_apraksti mva on va.id = mva.vaid " + _
			" join portal.dbo.marsruti m on mva.[mid] = m.ID join portal.dbo.grupas g on m.[ID] = g.marsruts  " + _
			" where g.gr_kods = '" + kods  + "'  " + _
			" order by va.nosaukums " )
			
			while not rAprPievienotie.eof
				%><BR><%=rAprPievienotie("nosaukums")%> 
				<a href="vietas_apraksts_delete.php?id=<%=rAprPievienotie("id")%>&gid=<%=gid%>" 
					onclick="return confirm('Vai tie��m v�lies dz�st �o ierakstu?');">[x]</a>
				<%
				rAprPievienotie.MoveNext
			wend

		%>
    </td>
</tr>

<tr>
    <td align=right><font size=2><strong>Meta apraksts:</strong></td>
    <td align=left><input type=text name=meta_desc size=70 value="<%=rGrupa("meta_desc")%>"></td>
</tr>
<% if IsAccess(T_GRUPU_PAPILD_INFO) then %>
<tr><td colspan=2><hr></td></tr>
<%  set rGrupa = conn.execute(ssql) %>

<tr>
    <td align=right><font size=2><strong>Paz�me:</strong></td>
    <td align=left><input type=text name=ln value="<%=TRIM(rGrupa("ln"))%>" maxlength=1 size=1>
    <strong><font size=2>Vad�t�js:</strong>
    <select name=vad_id>
        <option value="">-</option>
        <% set rVad = conn.execute("select * from grupu_vaditaji where deleted=0 order by vards ")
        while not rVad.eof
            response.write "<option value="+cstr(rVad("id"))+" "
            if rVad("id") = rGrupa("vad_id") then response.write " selected "
            response.write ">"+rVad("vards")+" "+rVad("uzvards")
            response.write "</Option>"
            rVad.movenext
        wend %>
    </select>
    </td>
</tr>
<tr>
    <td align=right><font size=2><strong>Papildus piez�mes:</strong></td>
    <td align=left><input type=text name=piezimes2 value="<%=rGrupa("piezimes2")%>"  size=35>
<% end if %>
<tr>
    <td align=right><font size=2><strong>Piez�mes:</strong></td>
    <td align=left><input type=text name=pazimes value="<%=rGrupa("pazimes")%>"  size=10> (D - d�vanu karte)
</tr>
<tr>
    <td align=right></td>
    <td align=left></td>
</tr>

</table>
</td>

<td valign=top>
    <li><a href='grupa_param.asp<%=qstring()%>'><font color="GREEN" size="3"><b>Grupas saraksts</b></font></a></li>
    <% if getnum(rGrupa("kajites_gid"))<>0 then %>
        <li><a href='kajite.asp?gid=<%=rGrupa("kajites_gid")%>'><font color="GREEN" size="3"><b>Kaj�tes</b></font></a></li>
        <li><a href='kajites_veidi.asp?gid=<%=rGrupa("kajites_gid")%>'><b><font color="GREEN">Kaj��u veidi</b></font></a></li>
    <% else %>
        <li><a href='kajite.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Kaj�tes</b></font></a></li>
        <li><a href='kajites_veidi.asp?gid=<%=gid%>'><b><font color="GREEN">Kaj��u veidi</b></font></a></li>
    <% end if %>
    <li><a href='viesnicas.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Viesn�cu numuri</b></font></a></li>
    <li><a href='viesnicas_veidi.asp?gid=<%=gid%>'><b><font color="GREEN">Viesn�cu numuru veidi</b></font></a></li>
    <li><a href='vietu_veidi.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Pakalpojumi</b></font></a></li>
    <!--<li><a href='limits.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Vietu ierobe�ojumi</b></font></a></li>-->
    <li><a href='pieteikumi_grupaa.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Pieteikumi grup�</b></font></a></li>
    <li><a href="pieteikumi_grupaa.asp?gid=<%=gid%>&mode=ligums"><font color="GREEN" size="3"><b>Lidojumi</b></font></a></li>
    <% if rGrupa("veids")="7" then %>
    <li><a href='c_grupa_kopet.php?gid=<%=gid%>'><font color="GREEN" size="3"><b>	</b></font></a></li>
    <% end if%>

    <% if rGrupa("veids")="1" then %>
    <li><a href='interesenti.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Interesenti</b></font></a></li>
    <% 
        elseif len(rGrupa("kods"))>4 then
          if mid(rGrupa("kods"),4,1) = "P" or mid(rGrupa("kods"),4,1) = "S" then
          %><li><a href='kontakti.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>Kontaktpersonas</b></font></a></li><% 
          end if
    end if %>
    <li><a href="grupa_voucer_edit.asp?gid=<%=gid%>"><font color="GREEN" size="3"><b>Vau�era redi���ana</b></a></li>
    <li><a href="c_grupas_dati_nosutiti.php?gid=<%=gid%>"><font color="GREEN" size="3"><b>Grupas dati nos�t�ti</b></a></li>
    <% if IsAccess(T_CELOJUMU_APR) then %>
    <li><a href="c_celojuma_apraksts.php?gid=<%=gid%>"><font color="GREEN" size="3"><b>Ce�ojuma apraksta pievieno�ana</b></a></li>
    <% end if %>
    <li><a href="c_bildes.php?gid=<%=gid%>"><font color="GREEN" size="3"><b>Bi�e�u atsl�gv�rdi</b></a></li>

    <% if pdf<>"" then%>
    <br>
    <li><a href="https://www.impro.lv/pdf/<%=pdf%>.pdf" target="_blank"><font color="GREEN" size="3"><b>Ce�ojuma apraksts</b></a></li>
    <% end if%>
    <li><a href="c_grupas_sar_soc.php?gid=<%=gid%>" target="_blank"><font color="GREEN" size="3"><b>Saraksts soci�lajiem t�kliem</b></a></li>
    <!--<li><a href='piet_summas.asp?gid=<%=gid%>'><font color="GREEN" size="3"><b>P�rr��in�t summas</b></font></a></li>-->
    <br><br>
<table>

<%
query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
        " and gid = "+cstr(gid)+" and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) and piet_saite.deleted = 0 " + _
        " and (kvietas_veids in (1,2,4,5) or persona = 1 )  and (not isnull(kvietas_veids,0) = 3)"

set aizn_vietas = conn.execute(query)
set personas = conn.execute(query+" and (not isnull(kvietas_veids,0) = 3)")
set pieteikumi = conn.execute("select isnull(count(*),0) as x from pieteikums where deleted = 0 and gid = "+cstr(gid))

query = "SELECT sum(piet_saite.vietsk) as sk " +_
        "FROM grupa,pieteikums,piet_saite " +_
        "WHERE grupa.id = "+cstr(gid)+ " AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) );"
set pap = conn.execute(query)

set riemaksas = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where deleted = 0 and pid in (select id from pieteikums where gid = "+cstr(gid)+")")
set riemaksasN = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd from orderis where parbaude = 1 and deleted = 0 and pid in (select id from pieteikums where gid = "+cstr(gid)+")")
set rizmaksas = conn.execute("select sum(summa),sum(summaLVL) as lvl,sum(summaEUR) as eur, sum(summaUSD) as usd  from orderis where deleted = 0 and nopid in (select id from pieteikums where gid = "+cstr(gid)+")")

rnauda2 = conn.execute("select sum(atlaidesLVL) as atLVL, sum(atlaidesUSD) as atUSD, sum(atlaidesEUR) as atEUR, sum(atlaidesBIL) as atBIL, sum(sadardzinLVL) as piemLVL, sum(sadardzinUSD) as piemUSD, sum(sadardzinEUR) as piemEUR, sum(sadardzinBIL) as piemBIL, sum(summaLVL) as sumLVL, sum(summaUSD) as sumUSD, sum(summaEUR) as sumEUR, sum(iemaksasLVL) as iemLVL, sum(iemaksasUSD) as iemUSD, sum(iemaksasEUR) as iemEUR, sum(izmaksasLVL) as izmLVL, sum(izmaksasUSD) as izmUSD, sum(izmaksasEUR) as izmEUR, sum(bilanceLVL) as bilLVL, sum(bilanceUSD) as bilUSD, sum(bilanceEUR) as bilEUR from pieteikums where gid="+cstr(gid)+" and (deleted = 0) and (isnull(tmp,0)=0 OR agents_izv=1) and id in (select pid from piet_saite where deleted = 0)")

set rjaunie = conn.execute("select count(distinct did) as c from  " + _
        "( " + _
        "select  " + _
        " ps.did  " + _
        " ,(select top 1 gid from pieteikums p2 " + _
        " join piet_saite ps2 on p2.id = ps2.pid " + _
        " where p2.deleted = 0 " + _
        " and ps2.deleted = 0  " + _
        " and ps2.did = ps.did " + _
        " order by p2.datums) as gid1 " + _
        " ,g.id as gid " + _
        "from pieteikums p " + _
        "join grupa g on p.gid = g.id " + _
        "join piet_saite ps on p.id = ps.pid " + _
        "where g.id = " + cstr(gid) + _
        " and p.deleted = 0 " + _
        " and ps.deleted = 0 " + _
        ") as t " + _
        "where t.gid1 = gid")
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
    <td align=right><font size=2><strong>Pieteikumi:</strong></td>
    <td ><font size=2><%=getnum(pieteikumi("x"))%></td>
</tr>
<tr>
    <td align=right><font size=2><strong>Papildvietas:</strong></td>
    <td ><font size=2><%=getnum(pap("sk"))%></td>
</tr>
<tr>
    <td align=right><font size=2><strong>Br�vas vietas:</strong></td>
    <td ><font size=2><%=BrivasVietasGrupa(gid)%></td>
</tr>
<% 

if 1=1 then
'if rGrupa("veids") <> 2 and rGrupa("veids") <> 3 then 
'izmain�ts, ja viss b�s k�rt�b�, else zaru j�met �r�
%>
<tr>
    <td align=right><font size=2><strong>J�maks�:</strong></td>
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
    <td align=right><font size=2><strong>Faktiski j�maks�:</strong></td>
    <td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("sumLVL")-rnauda2("atLVL")+rnauda2("piemLVL"),rnauda2("sumUSD")-rnauda2("atUSD")+rnauda2("piemUSD"),rnauda2("sumEUR")-rnauda2("atEUR")+rnauda2("piemEUR"))%></td>
</tr>
<% else %>
<tr>
    <td align=right><font size=2><strong>J�maks� pieteikumos:</strong></td>
    <td ><font size=2><font color=blue><%=Curr3Print2(rnauda2("sumLVL"),rnauda2("sumUSD"),rnauda2("sumEUR"))%></td>
</tr>
<tr>
    <td align=right><font size=2><strong>J�maks�:</strong></td>
    <td ><font size=2><font color=blue><%=Curr3Print2(getnum(rGrupa("i_cena")),getnum(rGrupa("i_cena_usd")),getnum(rGrupa("i_cena_eur")))%></td>
</tr>
<% end if %>
<tr>
    <td align=right><font size=2><strong>Iemaks�ts:</strong></td>
    <td><nobr><font size=2 color=green><%=Curr3Print2(rnauda2("iemLVL"),rnauda2("iemUSD"),rnauda2("iemEUR"))%></td>
</tr>
<tr>
    <td align=right><font size=2><strong>Izmaks�ts:</strong></td>
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
 <tr><td colspan=2 align=center><b>Bilancei</b></td></tr>
 <tr>
  <td><font size=2><b>Iemaksas</b></td>
  <td><font size=2><%=curr3total(riemaksas("lvl"),riemaksas("usd"),riemaksas("eur"))%>
   <% if getnum(riemaksasN(0)) <> 0 then %>
    <br>- <%=curr3total(riemaksasN("lvl"),riemaksasN("usd"),riemaksasN("eur"))%> (neapstiprin�ts) 
    <br>= <b><%=curr3total(getnum(riemaksas("lvl"))-getnum(riemaksasN("lvl")), getnum(riemaksas("usd"))-getnum(riemaksasN("usd")), getnum(riemaksas("eur"))-getnum(riemaksasN("eur")))%></b>
   <% end if %>
  </td>
 </tr>
 <tr>
  <td><font size=2><b>Izmaksas</b></td>
  <td><font size=2><%=curr3total(rizmaksas("lvl"),rizmaksas("usd"),rizmaksas("eur"))%></td>
 </tr>
 <tr>
  <td><font size=2><b>Atlaides</b></td>
  <td><font size=2><%=curr3total(rnauda2("atlvl"),rnauda2("atusd"),rnauda2("ateur"))%></td>
 </tr>
 <tr>
  <td><font size=2><b>Piemaksas</b></td>
  <td><font size=2><%=curr3total(rnauda2("piemlvl"),rnauda2("piemusd"),rnauda2("piemeur"))%></td>
 </tr>
</table>
</td>
</tr>
</table>

<center>
<% if gr_lab1 then %> 
 <input type="image" src="impro/bildes/diskete.jpg" alt="Saglab�t izmai�as.">
<% end if %>
<input type="image" src="impro/bildes/aizvert.bmp" alt="Aizv�rt logu. Atgriezties uz sarakstu." onclick="window.close();return false;">
<a href="vesture.asp?tabula=grupa&id=<%=gid%>" target="vesture">
 <img style="border:0px" src="impro/bildes/clock.bmp" alt="V�sture">
</a>

<%
set r = conn.execute("select isnull(count(id),0) as x from pieteikums where deleted = 0 and gid = " + cstr(gid))
if r("x") = 0 then
%>
 <a href="grupa_del.asp?gid=<%=gid%>">
  <img style="border:0px" onclick="return confirm('Dz�st grupu?');" src="impro/bildes/dzest.jpg" alt="Dz�st">
 </a>
<%
end if
%>
</body>
</html>
