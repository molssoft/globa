<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<% 

docstart "Tûrisma informâcijas sistçma - Globa Tûr","y1.jpg" 



dim conn
OpenConn


%>

<center><img src="impro/bildes/globatur.jpg" WIDTH="417" HEIGHT="70"><br>
<img src="impro/bildes/turisma.jpg" WIDTH="417" HEIGHT="26"><br>
<br><br><br>
<%

x = "a!n!c"
b = instr(x,"!n!")

if session("message") <> "" then
	%>
	<font size = 4 color = red><%=session("message")%> </font><BR><BR>
	<%
	session("message") = ""
end if
%>Jaunais serveris II<BR>
<b>Ar sistçmu strâdâ :
<% Response.write get_user() %> (<%=GetCurUserID%>)</b><br><br>

<table border = 0>
<td valign=top>
<font size = 3 color = black>

<font size = 4 color = black>Klienti</font><br>
 <%' if isaccess(T_ANKETAS) then %>
 <li><a href="dalibn.asp"> Dalîbnieku anketa</a><br>	
 <li><a href="dalibn_kompleks.asp"> Komplekso pasûtîjumu dalîbnieki</a><br>	
 <li><a href="eadreses.asp"> Klientu e-pasta adreses</a><br>	
 <li><a href="email_list.asp"> Interesentu e-pasta adreses</a><br>	
 <li><a href="message_compose.asp"> E-pasta izsûtîðana</a><br>	
 <li><a href="email_history.asp"> E-pasta vçsture</a><br>	
 <% if isaccess(T_ANKETAS) then %>
 <li><a href="anketa_grupa.asp"> Anketas</a><br>
 <% end if %>
 <li><a href="atsauksmes.asp"> Atsauksmes</a><br>		
 <li><a href="dalibn_charter.asp"> Èarteru klienti</a><br>		
 <li><a href="dalibn_kompleks2.asp"> Kompleksie klienti</a><br>	
 <li><a href="balle.asp"> Balles biïetes</a><br>	
 <%  '' if isaccess(T_BALLES_ORG) then %>
 <li><a href="dalibn_gadi.asp">Dalîbnieki pa gadiem</a><br>	
 <% ' End If %>
 <li><a href="novadi.asp"> Novadi</a><br>		

<br>
<font size = 4 color = black>Pieteikumi</font><br>
 <li><a href="piet_meklesana.asp"> Pieteikumu pârskats</a><br>
  <% if (isaccess(T_GRAMATVEDIS) or isaccess(T_ONLINE_REZ)) then %>
 <li><a href="c_ligumi.php?f=meklet"> Lîgumu pârskats</a><br>	 
  <% end if %>
 <li><a href="kavetaji_param.asp"> Kavçtâju saraksts</a><br>	

<% if not isaccess(T_DROSIBA) then %>
<br>
<font size = 4 color = black>Aìenti</font><br>
 <li><a href="agenti.asp">Aìentu saraksts</a><br>
 <li><a href="c_agenti_stat.php"> Aìentu statistika</a><br>	
 <% if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) then %>
  <li><a href="c_agenti_stat.php?f=stat2"> Aìentu statistika 2</a><br>
 <% end if %>
 <li><a href="agenti_nauda.asp"> Aìentu norçíini</a><br>		
 <li><a href="starpnieciba.asp"> Starpniecîbas noteikumi</a><br>		
<% end if %>

<br>
<font size = 4 color = black>Parâdnieki</font><br>
 <li><a href="parad_kompleks_all.asp">Kompleksie</a><br>

<br>
<font size = 4 color = black>Cita informâcija</font><br>
 <li><a href="mantas.asp">Atrastâs mantas</a><br>
 <li><a href="grafiks_sais.asp">Darba grafiks</a><br>
 <li><a href="lietotaji.asp">Sistçmas lietotâji</a><br>
 <li><a href="lietotaji_asp.asp">Ârçjie sistçmas lietotâji</a><br>
 <li><a href="darbi.asp">Programmçðanas darbi</a><br>	

</font>
</td>
<td width = 10%>
</td>
<td valign = top>

<font size = 3 color = black>

<font size = 4 color = black>Ceïojumi</font><br>
 <li><a href="out_grupa.asp"> Ceïojumu grupas</a><br>	
 <li><a href="grupas_gaidam.asp"> Gaidâmâs grupas</a><br>	
 <% if IsAccess(T_GRUPU_PAPILD_INFO) then %><li><a href="out_grupa2.asp"> Grupu info</a><br><% end if %>	
 <li><a href="kaj_grupas.asp"> Kajîðu grupas</a><br>	
 <li><a href="vietu_veidi.asp?gid=<%=GetComplexGroup%>"> Kompleksie pakalpojumi</a><br>	
 <li><a href="vietu_veidi.asp?gid=<%=conn.execute("select charter from  parametri")(0)%>"> Èarteru pakalpojumi</a><br>	
 <li><a href="grupas2.asp"> Labot grupas</a><br>	
 <li><a href="c_grupu_vaditaji.php"> Grupu vadîtâji</a><br>
 <li><a href="grupas_pas.asp"> Pasûtîjuma grupu pieteikumi</a><br>
 <li><a href="pakalpojumi.asp"> Pakalpojumu saraksts</a><br>
 <li><a href="c_grupu_vad_grafiks.php"> Grupu vadîtâju grafiks</a><br>
 <li><a href="c_valstis.php?f=stat"> Valstis</a><br>
 <li><a href="c_vietu_apraksti.php?f=index"> Vietu apraksti</a><br>
 <li><a href="c_grupa_sapulces.php"> Grupu sapulces</a><br>

<% if not isaccess(T_DROSIBA) then %>
<br>
 <font size = 4 color = black>Nauda</font><br>
 <li><a href="ord_list.asp"> Naudas operâciju pârskats</a><br>	
 <li><a href="valuta.asp"> LB valûtu kursi</a><br>	
 <li><a href="valuta_impro.asp"> IMPRO valûtu kursi</a><br>	
 <li><a href="valuta_edit.asp"> Valûtu konti</a><br>
 <li><a href="terms.asp"> Iemaksu termiòi</a><br>	
<% end if %>
<% if isaccess(T_GRAMATVEDIS) then %>

<li><a href="c_maksajumi.php"> Bankas pârskatu imports</a><br>	
<% end if %>

<br>
<font size = 4 color = black>Atskaites</font><br>
 <li><a href="atsk_komp.asp">Kompleksie pasûtîjumi</a><br>	
 <li><a href="atsk_komp_dal.asp"><nobr>Kompleksie pasûtîjumi (dalîtâ)</nobr></a><br>	
 <li><a href="atsk_ien.asp">Ienâkoðais tûrisms</a><br>	
 <li><a href="atsk_char.asp">Èarteri</a><br>	
 <li><a href="atsk_viss.asp">Kopçjâ</a><br>	
 <li><a href="atsk_pakalp.asp">Grupu pakalpojumi</a><br>	
 <% if isaccess(T_ANKETAS) then %>
 <li><a href="anketas_atsk.asp">Anketu atskaite</a><br>	
 <li><a href="anketas_stat.asp">Anketu statistika</a><br>
 <% end if %>
 <li><a href="atsk_savakts.asp">Vâkto grupu piepildîðanâs</a><br>	
 <li><a href="atsk_grupu_ienemumi.asp">Grupu ieòçmumi</a><br>	
 <li><a href="atsk_piet_atlaides.asp">Pieteikumu atlaides</a><br>

 <li ><a onclick="$('#web_statistika_menu').toggle();$('#web_menu_arrow').toggle();return false;" href="#">Mâjaslapas statistika <span id="web_menu_arrow">&#10148;</span></a>
  <ul id="web_statistika_menu" style="display:none"  >
	<li><a href="c_web_top_grupas.php">Bieþâk skatîtie ceïojumi</a></li>
	<li><a href="c_web_meklesana_log.php?f=TOPKeywords">Bieþâk meklçtie atslçgas vârdi</a></li>
	<li><a href="c_web_meklesana_log.php?f=TOPValstis">Bieþâk meklçtâs valstis</a></li>
	<li><a href="c_web_meklesana_log.php?f=TOPRegioni">Bieþâk meklçtie reìioni</a></li>
  </ul>
 </li>

</font>

<% if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN) or isaccess(T_ONLINE_REZ)) then %>
<br>
 <font size = 4 color = black>Online rezervâcijas</font><br>
 <li><a href="online_rez_2.asp">Rezervâciju pârskats</a><br></li>
   <li><a href="c_mainiti_dok.php">Klienti ar mainîtiem personu dokumentiem</a><br></li>
   
<%
set dkcount = conn.execute("SELECT isnull(COUNT(*),0) AS requested_invoices FROM online_rez WHERE invoice_status = 'requested';")
if dkcount("requested_invoices") = 0 then %>
  <li><a href="c_davanu_kartes.php">Dâvanu kartes</a><br></li>
<% else %>
  <li><a href="c_davanu_kartes.php">Dâvanu kartes <font color=red>(<%=dkcount("requested_invoices")%>)</font></a><br></li>
<% end if %>
   
    <li><a href="c_online_profili.php">Online profili</a><br></li>
	<li><a href="c_online_rez.php">Pârbaudâmâs rezervâcijas</a><br></li>
	<li><a href="c_parbaudit_online_viesnicas_kajites.php" target="_blank">Pârbaudâmie viesnîcu un kajîðu salikumi</a><br></li>
 <% end if %>
<% if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) then %> 
 <li><a href="orderu_apst_2_1.asp">Norçíinu apstiprinâðana</a><br></li>
 <li><a href="online_merchant_trans.asp">Maksâjumu karðu transakcijas</a><br></li>
<% end if %>
<% if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN) or isaccess(T_ONLINE_REZ)) then %>
 <li><a href="c_online_settings.php">Atslçgt/pieslçgt online apmaksas veidus</a><br></li>
 <% end if %>
 <li><a href="user_tracking.asp">Sesiju izsekoðana</a><br></li>
 <li><a href="online_rez_restore.asp">Dzçstas rezervâcijas atjaunoðana</a><br></li>

 
</td>
</table>


</body>
</html>
